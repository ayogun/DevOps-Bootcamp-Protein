#!bin/bash

#################################################################
# Author: Ali Yigit Ogun										 |	
# Contact: yigitogun@gmail.com									 |
# Date: 01.06.2022												 |
# Version: 1.0				  									 |
# Description: Script which take a build for the project		 |
# Usage: $bash build.sh											 |
##################################################################


#-----------------------------------------VARIABLE DECLARATION---------------------------------------------#

#Variable declaration and initilization
artifact_path=$(pwd)
branch_name=$(git rev-parse --abbrev-ref HEAD)


#BUILD_COMMAND is using MAVEN package manager as default. Here -DskipTests value is
#added in order to skip the tests. If it is desired, it can be removed in order to
#run the tests. 
BUILD_COMMAND="mvn package -DskipTests && tar -czf ${artifact_path}/${branch_name}.tar.gz ./target/*.jar"


#HELP_COMMAND is the variable which shows the help of the build.sh script. 
HELP_COMMAND="
	Usage:
    -b  <branch_name>     Branch name
    -n  <new_branch>      Create new branch, (-n branch_name)
    -f  <tar/zip>         Compress format should be either zip or tar
    -p  <artifact_path>   Copy artifact to an absolute path
    -d  <true/false>      Enable or disable(default) debug mode

	-b = BRANCH_NAME 
 		Taking the build for the given BRANCH_NAME 

	-n = NEW_BRANCH 
 		Create the new branch with the name of given NEW_BRANCH 
		and take build for that branch. 

	-f = COMPRESSION_FORMAT 
		After it takes the build' it compress the build with the given 
		COMPRESSION_FORMAT as zip or tar. COMPRESSION_FORMAT supports only 
		zip and tar. Compressed artifact is placed under current directory 
 		if it is not specified with -p flag. It is set to tar by default. 

	-p = ARTIFCAT_PATH 
		Compressed artifact is placed to the given path as ARTIFACT_PATH 
		The path should be absolute but not relative. 

	-d = DEBUG_MODE <debug_mode> 
 		According to given DEBUG_MODE value it enables debug mode. 
		In order to enable debug mode, give <true>, to disable 
 		give <false>. As default DEBUG_MODE is set to <false>. 
			"
#--------------------------------------------VARIABLE DECLARATION----------------------------------------------#








#---------------------------------FUNCTION DECLARATION-----------------------------------#
#This function is used to show the help of the build.sh script. In this function
# HELP_COMMAND is called to print out explanations for the user and exit the script.
usage(){
	echo "${HELP_COMMAND}"
	exit 1
}
#----------------------------------FUNCTION DECLARATION------------------------------------#







#------------------------------------CHECKING FLAGS--------------------------------------#

#Here a loop is used to check the arguments delievered by the user. Here we do this with
#getopts. Inside we define the options/flags that are defined in our script such as
#b, n, f, p, d. If the user does not provide any of these flags, the script will execute
#the "usage" function. It has been done with asteriks(*) sign.
while getopts ":b:n:f:p:d:" opt
do
  case "${opt}" in
	b)
		branch_name=${OPTARG}
		;;
	n)
		new_branch=${OPTARG}
		;;
	f)
		compress_mode=${OPTARG}
		#((debug_mode == "zip" || debug_mode == "tar")) || usage
		;;
	p)
		artifact_path=${OPTARG}
		;;
	d)
		debug_mode=${OPTARG}
		((debug_mode == "true" || debug_mode == "false")) || usage
		;;
	*)
		usage
		;;
  esac
done

#------------------------------------CHECKING FLAGS--------------------------------------#






#------------------------------------NEW BRANCH CREATION-----------------------------------#

#Here we check if user did not provide an empty string for new brancn name.
#If provided a string for name, it will create a new branch with the name provided. 
if [ ! -z "${new_branch}" ];
then
	echo "Creating new branch: ${new_branch}"
	git checkout -b ${new_branch}
	echo "Build has not started on branch: ${new_branch}"
	echo "If you want you can take build on a particular branch with use of -b option with branch name."
	exit 0
fi

#------------------------------------NEW BRANCH CREATION-----------------------------------#






#------------------------------------BUILDING FOR A BRANCH-----------------------------------#

#Here we check first if the user try to take a build with main/master branch. If so,
#an error message is displayed to warn the user. If user provided a valid branch_name
# first it checks if the user is in this branch. If user is in corrent branch, it will
# execute the build command. If user is not in the correct branch, it will check out the
#correct branch, then execute the build command.
if [[ "${branch_name}" == "main" || "${branch_name}" == "master" ]];
then
	echo -e "\e[0;33mWARNING!!!\033[0m"
	echo "You are taking the build of master/main branch !!!"
	BUILD_COMMAND="mvn package -DskipTests && tar -czf ${artifact_path}/${branch_name}.tar.gz ./target/*.jar"
fi 

if [ "${branch_name}" == $(git rev-parse --abbrev-ref HEAD) ]; 
then
	echo "Build has started on branch: ${branch_name}"
elif [[ "${branch_name}" != $(git rev-parse --abbrev-ref HEAD) && ! -z "${branch_name}" ]];
then
		echo "Checking out branch: ${branch_name}"
		git checkout ${branch_name}
		
	if [ $? -eq 0 ];
	then
		echo "Build has started on branch: ${branch_name}"
		BUILD_COMMAND="mvn package -DskipTests && tar -czf ${artifact_path}/${branch_name}.tar.gz ./target/*.jar"
	else
		echo -e "\e[1;31mThe branch of ${branch_name} does not exist."
		echo "Please check the branch name and try again."
		echo "If you want to create a new branch, use NEW_BRANCH option with -n."
		exit 1
	fi
fi 

#------------------------------------BUILDING FOR A BRANCH-----------------------------------#







#------------------------------------TAKING COMPRESSION MODE-----------------------------------#

#Here in first statement of first if condition we check if user provided a zip compress format.
#In second statement we check if user provided a valid artifact path. If not, it will create a zip 
#archive file in the current directory as pwd command indicates.
if [[ "${compress_mode}" == "zip" && -z "${artifact_path}" ]];
then
	dir=$(pwd)
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	echo "Compress mode: ${compress_mode} and artifact is created under: $dir/"
	BUILD_COMMAND="mvn package -DskipTests && zip -r ${dir}/${branch_name}.zip ./target/*.jar"

#Here we check if compress mode is provided correct as zip and artifact path is provided. If so,
#it will create a zip file under the provided artifact_path.
elif [[ "${compress_mode}" == "zip" && ! -z "${artifact_path}" ]];
then
	echo "Compress mode: ${compress_mode} and artifact path: ${artifact_path}"
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	BUILD_COMMAND="mvn package -DskipTests && zip -r ${artifact_path}/${branch_name}.zip ./target/*.jar"

#Here in first statement of first if condition we check if user provided a tar compress format.
#In second statement we check if user provided a valid artifact path. If not, it will create a zip 
#archive file in the current directory as pwd command indicates.
elif [[ "$compress_mode" == "tar" && -z "$artifact_path" ]];
then
	echo "Compress mode: ${compress_mode} and artifact path: ${pwd}"
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	BUILD_COMMAND="mvn package -DskipTests && tar -czf ${pwd}/${branch_name}.tar.gz ./target/*.jar"

#Here we check if compress mode is provided correct as tar and artifact path is provided. If so,
#it will create a tar file under the provided artifact_path.
elif [[ "${compress_mode}" == "tar" && ! -z "${artifact_path}" ]];
then
	echo "Compress mode: ${compress_mode} and artifact path: ${artifact_path}"
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	BUILD_COMMAND="mvn package -DskipTests && tar -czf ${artifact_path}/${branch_name}.tar.gz ./target/*.jar"

#Here we check if user didn't provide either zip or tar compress mode. If so, ıt will show an
#error message and exit the script.
elif [[ "${compress_mode}" != "tar" && "${compress_mode}" != "zip" && ! -z "${compress_mode}" ]];
then
	echo "You have provided an invalid compress mode: ${compress_mode}"
	echo "Please provide a valid compress mode as zip or tar."
	exit 1
fi

#------------------------------------TAKING COMPRESSION MODE-----------------------------------#







#------------------------------------TAKING ARTIFACT PATH-----------------------------------#

#Here we take artifact_path and shows it to the user. Also, for double protection, again it is checked
#if user provided a valid artifact_path. 
if [ -z "${artifact_path}" ];
then
	echo "You gave an undefined path. Current directory is used as artifact path."
	artifact_path=$(pwd)
fi

#------------------------------------TAKING ARTIFACT PATH-----------------------------------#






#------------------------------------DEBUG MODE-----------------------------------#

#Here we check if debug mode is activated with the true value. If so, and -X flag is added to our BUILD_COMMAND
#For Maven it means, execute the build with debug mode on.
if [ "${debug_mode}" == "true" ]; then
	echo "Debug mode is enabled"
	BUILD_COMMAND+="-X"
fi

#------------------------------------DEBUG MODE-----------------------------------#








#---------------------------------EXECUTION OF BUILD COMMAND----------------------------#
#Execute the build command.
eval "$BUILD_COMMAND"

#---------------------------------EXECUTION OF BUILD COMMAND----------------------------#
