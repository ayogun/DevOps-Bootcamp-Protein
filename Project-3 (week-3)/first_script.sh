#!/bin/bash


#------------------------------------- COLOR DECLERATIONS -------------------------------------# 
# Here colors declared to use inline texts. The LINE variable is declared to seperate
# sections during the printing out to the terminal screen.


END='\033[0m'       # Text Reset
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
YELLOW='\033[0;33m'       # Yellow
LINE='--------------------------------------------------------------------------------'	# Line

#------------------------------------- COLOR DECLERATIONS -------------------------------------#






#------------------------------------- IMAGE BUILD STEP -------------------------------------#
echo "${LINE}"
echo -ne "Do you want to build an image for the app in this directory? (y/n): "
read ans
if [ "$ans" == "y" ]; then
	echo -n "Please provide a name for the image: "  	# Ask for the image name
	read name										 	# Read the image name
	echo -n "Please provide a tag for the image: "   	# Ask for the image tag
	read tag										 	# Read the image tag
	if [[ -z "${name}" || -z "${tag}" ]]; then			# If the image name or tag is empty
		echo -e "${RED}ERROR:${END} name and tag are required and cannot be empty"	# Print error message
		echo -e "${RED}Image creation aborted${END}"
		exit 1
	else 												# If the image name and tag are not empty
	docker build -t ${name}:${tag} . > /dev/null 2>&1	# Build the image
	echo -e "${GREEN}The docker image with name=${name} and tag=${tag} has been built.${END}"	# Print success message
	echo
	fi
elif [ "$ans" == "n" ]; then							# If the user does not want to build an image
	echo -e "${YELLOW}Image creation step has been skipped${END}"	# Print message
else													# If the user enters an invalid answer
	echo -e "${RED}ERROR:${END} invalid input"			# Print error message
	echo -e "${RED}Image creation has been aborted${END}"
fi
#------------------------------------- IMAGE BUILD STEP -------------------------------------#







#------------------------------------- IMAGE RUN STEP -------------------------------------#
echo "${LINE}"
echo -n "Do you want to run the image? (y/n): "			# Ask if user wants to run the image
read ans												# Read the answer
if [ "$ans" == "y" ]; then								# If the user wants to run the image
	echo -n "Do you want to add add MEMORY and/or CPU limit for the image? (y/n): "	
	read subans							# Ask if the user wants to add memory and/or cpu limit
	if [ "$subans" == "y" ]; then				# If the user wants to add memory and/or cpu limit
												# Printing some information to the user
		echo -e "${YELLOW}The MEMORY format is [number][unit], e.g. [1g] for 1GB, [2m] for 2MB, etc."
		echo -e "The MEMORY limit is infinte if not specified.${END}"
		echo
		echo -n "Enter the MEMORY limit: "			# Ask for the memory limit
		read mem									# Read the memory limit
												# Printing some information to the user
		echo -e "${YELLOW}The CPU limit depends on how much available CPU you have on your machine."
		echo "Please read the documentation for more information."
		echo -e "The CPU limit is %100 if not specified.${END}"
		echo
		echo -n "Enter the CPU limit in cores: " 	# Ask for the cpu limit
		read cpu									# Read the cpu limit
		
		if [[ -z "${mem}" && ! -z "${cpu}" ]]; then	
		# If the memory limit is empty and the cpu limit is not empty
		# Print error message and print that default memory limit is used
			echo -e "${YELLOW}MEMORY limit is not specified and default value will be used.${END}"
			echo -e "${GREEN}Running image with ${cpu} CPU limit ...${END}"
			docker run -d --cpus="${cpu}" ${name}:${tag} > /dev/null 2>&1
		
		elif [[ ! -z "${mem}" && -z "${cpu}" ]]; then
		# If the memory limit is not empty and the cpu limit is empty
		# Print error message and print that default cpu limit is used
			echo -e "${YELLOW}CPU limit is not specified and default value will be used.${END}"
			echo -e "${GREEN}Running image with ${mem} MEMORY limit...${END}"
			docker run -d --memory="${mem}" ${name}:${tag} > /dev/null 2>&1

		elif [[ -z "${mem}" && -z "${cpu}" ]]; then
		# If the memory limit and cpu limit are empty
		# Print error message and print that default memory and cpu limit is used
			echo -e "${YELLOW}MEMORY and CPU limit are not specified and default value will be used.${END}"
			echo -e "${GREEN}Running image without MEMORY and CPU limit...${END}"
			docker run -d ${name}:${tag} > /dev/null 2>&1
		
		else
		# If the memory limit and cpu limit are specified correctly, run the command
			docker run -d --memory="${mem}" --cpus="${cpu}" ${name}:${tag} > /dev/null 2>&1
		fi

		if [ $? -ne 0 ]; then		# If the command fails
									# it means that the input was not correct
									# Print error message and abort this step
			echo -e "${RED}ERROR:${END} The image has not been runned due to invalid format of CPU or MEMORY limit."
			echo -e "${RED}Image run aborted${END}"
		else
					# If the command succeeds print success message
			echo -e "${GREEN}The image has been runned successfully.${END}"
		fi
	fi
elif [ "$ans" == "n" ]; then			# If the user does not want to run the image
	echo -e "${YELLOW}Image run step has been skipped${END}"	# Print message
else											# If the user enters an invalid answer 
	echo -e "${RED}ERROR:${END} invalid input"	# Print error message
	echo -e "${RED}Image run aborted${END}"
fi
#------------------------------------- IMAGE RUN STEP -------------------------------------#







#------------------------------------- IMAGE PUSH STEP -------------------------------------#
echo "${LINE}"
echo -n "Do you want to push the image? (y/n): " # Ask if user wants to push the image
read ans										# Read the answer
if [ "$ans" == "y" ]; then						# If the user wants to push the image
												# Printing some information to the user
	echo -e "${YELLOW}With this script you can put your image either on Docker Hub or GitLab.${END}"
	echo
															# Ask for the image registry
	echo -n "If you want to use Docker Hub, enter 1. If you want to use GitLab, enter 2."
	read ans												# Read the answer
	if [ "$ans" == "1" ]; then								# If the user wants to use Docker Hub
		echo -n "Please give your Docker Hub username: " 	# Ask for the username
		read username										# Read the username
		echo -n "Please give your Docker Hub password: "	# Ask for the password
		read -s password									# Read the password with hidden characters
		echo
		docker login -u="${username}" -p="${password}"				# Login to Docker Hub
		docker image tag ${name}:${tag} ${username}/${name}:${tag}	# Tag the image for Docker Hub
		docker image push ${username}/${name}:${tag}				# Push the image to Docker Hub
	elif [ "$ans" == "2" ]; then									# If the user wants to use GitLab
		echo -n "Please give your GitLab username: "				# Ask for the username
		read username												# Read the username		
		echo -n "Please give your GitLab password: "				# Ask for the password
		read -s password											# Read the password with hidden characters
		echo -n "Please give your GitLab project name: "			# Ask for the project name
		read project												# Read the project name
		# Login to GitLab
		docker login -u="${username}" -p="${password}" registry.gitlab.com
		# Tag the image for GitLab				
		docker image tag ${name}:${tag} registry.gitlab.com/${project}/${name}:${tag}
		# Push the image to GitLab	
		docker image push registry.gitlab.com/${project}/${name}:${tag}					
	else															# If the user enters an invalid answer
		echo -e "${RED}Invalid input.${END}"						# Print error message
	fi
elif [ "$ans" == "n" ]; then									# If the user does not want to push the image
	echo -e "${YELLOW}Image push step has been skipped${END}"	# Print message
else													# If the user enters an invalid answer
	echo -e "${RED}ERROR:${END} invalid input"			# Print error message
	echo -e "${RED}Image push aborted${END}"
fi
#------------------------------------- IMAGE PUSH STEP -------------------------------------#






#------------------------------------- DB SELECTION STEP -------------------------------------#
echo "${LINE}"
echo -n "Do you need a database? (y/n):"						# Ask if user wants to use a database
read ans														# Read the answer
if [ "$ans" == "y" ]; then										# If the user wants to use a database
					# Printing some information to the user
	echo -e "${YELLOW}With this script only mysql and mongo databases are provided.${END}"
	echo
					# Ask for the database selection
	echo -n "If you want to use MYSQL, enter 1. If you want to use MONGODB, enter 2: "
	read subans		# Read the answer
	if [ "$subans" == "1" ]; then					      # If the user wants to use MYSQL	
		echo -e "${GREEN}MySQL service is being started...${END}"
		docker-compose -f docker-compose-mysql.yml up -d  # Start the mysql service in detach mode
		echo -e "${YELLOW}---INFORMATION---${END}"		  # Print information message to user
		echo "Port: 3306:3306"
		echo "MYSQL_ROOT_PASSWORD=admin"
		echo "MYSQL_PASSWORD=admin"
        echo "MYSQL_USER=admin"
        echo "MYSQL_DATABASE=admin"

	elif [ "$subans" == "2" ]; then							# If the user wants to use MONGODB
		echo -e "${GREEN}MongoDB service is being started...${END}"	
		docker-compose -f docker-compose-mongo.yml up -d 	# Start the mongo service in detach mode
		echo -e "${YELLOW}---INFORMATION---${END}"			# Print information message to user
		echo "MONGO_INITDB_ROOT_USERNAME=admin"
    	echo "MONGO_INITDB_ROOT_PASSWORD=admin"
	else												# If the user enters an invalid answer
		echo -e "${RED}Invalid input.${END}"			# Print error message
	fi
elif [ "$ans" == "n" ]; then							# If the user does not want to use a database
	echo -e "${YELLOW}Database creaiton step has been skipped${END}"	# Print message
else													# If the user enters an invalid answer
	echo -e "${RED}ERROR:${END} invalid input"			# Print error message
	echo -e "${RED}Database creation step has been aborted${END}"
fi
#------------------------------------- DB SELECTION STEP -------------------------------------#
