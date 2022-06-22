#!/bin/bash

#################################################################
# Author: Ali Yigit Ogun										 |
# Contact: yigitogun@gmail.com									 |
# Date: 09.06.2022												 |
# Version: 1.0				  									 |
# Description: Script which helps user about docker. 			 |
# Usage: $bash first_script.sh or ./first_script.sh				 |
##################################################################



#------------------------------------- COLOR DECLERATIONS -------------------------------------# 
# Here colors declared to use inline texts. The LINE variable is declared to seperate
# sections during the printing out to the terminal screen.


END='\033[0m'     		  # Text Reset
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
YELLOW='\033[0;33m'       # Yellow
LINE='--------------------------------------------------------------------------------'	# Line

#------------------------------------- COLOR DECLERATIONS -------------------------------------#






#------------------------------------- HELP MESSAGE -------------------------------------#


#HELP_COMMAND is the variable which shows the help of the build.sh script. 
HELP_COMMAND="

${YELLOW}Usage:${END}
--mode              Select mode <build|deploy|template> 
--image-name        Docker image name
--image-tag         Docker image tag
--memory            Container memory limit
--cpu               Container cpu limit
--container-name    Container name
--registery         DocherHub or GitLab Image registery <dockerhub|gitlab>
--application-name  Run mysql or mongo server <mysql|mongo>



${YELLOW}About:${END}
This script helps user to build, run a docker image or create a database. Under this scope, --modis the main parameter which helps user to select the mode and this is a mandatory parameter. Builoption automatically builds the docker image, deploy option automatically runs the docker image antemplate option creates a database container.

The script is divided into three parts. The first part is the build part which requires mandator--image-name and --image-tag parameters. The second part is the deploy part which requires mandator--image-name and --image-tag parameters. The deploy part can take additional three optionaparameters as --container-name, --memory and --cpu. The third part is the template part whicrequires mandatory --application-name parameter.



${YELLOW}Examples:${END}
$ ./docker_dev_tools.sh --mode build --image-name example_image --image-tag v1 --registeexample_registe
$ ./docker_dev_tools.sh --mode deploy --image-name example_image --image-tag v1 --container-naexample_container --memory \"1g\" --cpu \"1.0\"
$ docker_dev_tools.sh --mode tempate --application-name mysql
			"
#------------------------------------- HELP MESSAGE -------------------------------------#






#--------------------------------- FUNCTION DECLARATION -----------------------------------#
#This function is used to show the help of the build.sh script. In this function
# HELP_COMMAND is called to print out explanations for the user and exit the script.
usage(){
	echo -e "${HELP_COMMAND}"
	exit 1
}
#---------------------------------- FUNCTION DECLARATION ------------------------------------#







#---------------------------------- OPTION CHECK ------------------------------------#

while [[ "$#" -gt 0 ]]; do								# This loop is used to check the number of 																	  parameters.
	case $1 in
		--mode)  				MODE="$2"				# This is used to check the mode parameter.
								shift 2					# This is used to shift the parameters. To 
								;;						# check next parameter.
		
		--image-name) 			IMAGE_NAME="$2"			# This is used to check the image-name parameter.
								shift 2
								;;
		
		--image-tag) 			IMAGE_TAG="$2"			# This is used to check the image-tag parameter.
								shift 2
								;;
		
		--registry) 			REGISTRY="$2"			# This is used to check the registry parameter.
								shift 2
								;;
		
		--container-name) 		CONTAINER_NAME="$2"		# This is used to check the container-name parameter.
								shift 2
								;;
		
		--memory) 				MEMORY="$2"				# This is used to check the memory parameter.
								shift 2
								;;
		
		--cpu) 					CPU="$2"				# This is used to check the cpu parameter.
								shift 2
								;;
		
		--application-name) 	APPLICATION_NAME="$2"	# This is used to check the application-name 														  parameter.
								shift 2
								;;
		
		*)						echo -e "${RED}ERROR:${END} Unknown option: $1"   # This is used to check 																			   invalid parameters.
								usage
								exit 1
								;;
		esac
done

#---------------------------------- OPTION CHECK ------------------------------------#







#--------------------------------------------- MODE CHECK ----------------------------------------------#

if [ -z "$MODE" ]; then									# if mode is not set, then show the help message.
	echo -e "${RED}ERROR:${END} Mode is not set and it is mandatory"
	usage
	exit 1
fi

case $MODE in						# Check what --mode option is given

#---------------------------- BUILD OPTION ----------------------------------#
	build)	echo -e "${GREEN}Building image...${END}"			# If --mode is Build
			if [[ -z "$IMAGE_NAME" || -z "$IMAGE_TAG" ]]; then  # If --image-name and --image-tag aren't set?
				echo -e "${RED}ERROR:${END} Image name or tag is not set and it is mandatory"
				usage
				exit 1

			else
				if [ -z "$REGISTRY" ]; then       							#If --registry isn't set?
					docker build -t ${IMAGE_NAME}:${IMAGE_TAG} . > /dev/null 2>&1
				
				else 														# If --registry is set
					docker build -t ${IMAGE_NAME}:${IMAGE_TAG} . > /dev/null 2>&1
					if [ "$REGISTRY" == "dockerhub" ]; then				   # If --registry is dockerhub		
						echo -n "Please give your Docker Hub username: " 	# Ask for the username
						read username										# Read the username
						echo -n "Please give your Docker Hub password: "	# Ask for the password
						read -s password									# Read the password with hidden characters
						echo
						docker login -u="${username}" -p="${password}"				# Login to Docker Hub
						docker image tag ${IMAGE_NAME}:${IMAGE_TAG} ${username}/${IMAGE_NAME}:${IMAGE_TAG}	# Tag the image for Docker Hub
						docker image push ${username}/${IMAGE_NAME}:${IMAGE_TAG}				# Push the image to Docker Hub
					
					elif [ "$REGISTRY" == "gitlab" ]; then							# If --registry is gitlab
						echo -n "Please give your GitLab username: "				# Ask for the username
						read username												# Read the username		
						echo -n "Please give your GitLab password: "				# Ask for the password
						read -s password											# Read the password with hidden characters
						echo -n "Please give your GitLab project name: "			# Ask for the project name
						read project												# Read the project name
						# Login to GitLab
						docker login -u="${username}" -p="${password}" registry.gitlab.com
						# Tag the image for GitLab				
						docker image tag ${IMAGE_NAME}:${IMAGE_TAG} registry.gitlab.com/${project}/${IMAGE_NAME}:${IMAGE_TAG}
						# Push the image to GitLab	
						docker image push registry.gitlab.com/${project}/${IMAGE_NAME}:${IMAGE_TAG}
					
					else									# If --registry is neither dockerhub nor gitlab
						echo -e "${RED}ERROR:${END} Unknown registry"
						usage
						exit 1
					fi	
				fi
			fi
   			;;
#---------------------------- BUILD OPTION ----------------------------------#





#---------------------------- DEPLOY OPTION ----------------------------------#

	deploy) echo -e "${GREEN}Running the image...${END}"						# If --mode is Deploy
			if [[ -z "$IMAGE_NAME" || -z "$IMAGE_TAG" ]]; then	# If --image-name and --image-tag aren't set?
				echo -e "${RED}ERROR:${END} Image name or tag is not set and it is mandatory"
				usage
				exit 1

			else
						# Welcome to my spaghetti code. I'm sorry. For the love of god don't look at it. But if you do, we have three parameters. Here they are checked one by one if they are set. So with permutations of the three parameters with two possibilities of each, it makes 8 different case. Here they are checked in this spaghetti.
				if [[ ! -z "$CONTAINER_NAME" && ! -z "$MEMORY" && ! -z "$CPU" ]]; then
					docker run -d --name ${CONTAINER_NAME} --memory="${MEMORY}" --cpus="${CPU}" ${IMAGE_NAME}:${IMAGE_TAG}
				elif [[ ! -z "$CONTAINER_NAME" && ! -z "$MEMORY" && -z "$CPU" ]]; then
					docker run -d --name ${CONTAINER_NAME} --memory="${MEMORY}" ${IMAGE_NAME}:${IMAGE_TAG}
				elif [[ ! -z "$CONTAINER_NAME" && -z "$MEMORY" && ! -z "$CPU" ]]; then
					docker run -d --name ${CONTAINER_NAME} --cpus="${CPU}" ${IMAGE_NAME}:${IMAGE_TAG}
				elif [[ ! -z "$CONTAINER_NAME" && -z "$MEMORY" && -z "$CPU" ]]; then
					docker run -d --name ${CONTAINER_NAME} ${IMAGE_NAME}:${IMAGE_TAG}
				elif [[ -z "$CONTAINER_NAME" && ! -z "$MEMORY" && ! -z "$CPU" ]]; then
					docker run -d --memory="${MEMORY}" --cpus="${CPU}" ${IMAGE_NAME}:${IMAGE_TAG}
				elif [[ -z "$CONTAINER_NAME" && ! -z "$MEMORY" && -z "$CPU" ]]; then
					docker run -d --memory="${MEMORY}" ${IMAGE_NAME}:${IMAGE_TAG}
				elif [[ -z "$CONTAINER_NAME" && -z "$MEMORY" && ! -z "$CPU" ]]; then
					docker run -d --cpus="${CPU}" ${IMAGE_NAME}:${IMAGE_TAG}
				elif [[ -z "$CONTAINER_NAME" && -z "$MEMORY" && -z "$CPU" ]]; then
					docker run -d ${IMAGE_NAME}:${IMAGE_TAG}
				fi
			fi
			;;
#---------------------------- DEPLOY OPTION ----------------------------------#


#---------------------------- TEMPLATE OPTION ----------------------------------#
	template) echo -e "${GREEN}Creating database${END}"							# If --mode is Template
			if [ -z "$APPLICATION_NAME" ]; then					# If --application-name isn't set?
				echo -e "${RED}ERROR:${END} Application Name is not set and it is mandatory"
				usage
				exit 1
			fi
			if [ "$APPLICATION_NAME" == "mysql" ]; then			    # If --application-name is mysql
				echo -e "${GREEN}Creating MySQL DB${END}"
				docker-compose -f docker-compose-mysql.yml up -d  # Start the mysql service in detach mode
				echo -e "${YELLOW}---INFORMATION---${END}"		  # Print information message to user
				echo "Port: 3306:3306"
				echo "MYSQL_ROOT_PASSWORD=admin"
				echo "MYSQL_PASSWORD=admin"
        		echo "MYSQL_USER=admin"
        		echo "MYSQL_DATABASE=admin"
			
			elif [ "$APPLICATION_NAME" == "mongo" ]; then			# If --application-name is mongo
				echo -e "${GREEN}Creating Mongo DB${END}"
				docker-compose -f docker-compose-mongo.yml up -d 	# Start the mongo service in detach mode
				echo -e "${YELLOW}---INFORMATION---${END}"			# Print information message to user
				echo "MONGO_INITDB_ROOT_USERNAME=admin"
    			echo "MONGO_INITDB_ROOT_PASSWORD=admin"
			
			else 													# If --application-name is neither mysql nor mongo
				echo -e "${RED}ERROR:${END} Application Name is invalid"
				usage
				exit 1
			fi
			;;
#------------------------- TEMPLATE OPTION --------------------------#


#------------------------ EXEMPTION ------------------------------#
	*)		echo -e "${RED}ERROR:${END} Unknown mode"				# If --mode is neither Build nor Deploy nor Template
			usage
			exit 1
			;;
#----------------------- EXEMPTION -------------------------------#

esac

#---------------------------------------------- MODE CHECK ----------------------------------------------#
