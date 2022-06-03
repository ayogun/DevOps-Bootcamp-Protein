#!bin/bash

#################################################################
# Author: Ali Yigit Ogun										 |	
# Contact: yigitogun@gmail.com									 |
# Date: 01.06.2022												 |
# Version: 1.0				  									 |
# Description: Script which take a build for the project		 |
# Usage: $bash build.sh											 |
##################################################################


#----------START OF VARIABLE DECLARATION-------------#

#Variable declaration: Build command carries the value which create out artifact
#BUILD_COMMAND is default from MAVEN package manager. Here -DskipTests value is
#added in order to skip the tests. If it is desired, it can be removed in order to
#run the tests. 
#HELP_COMMAND is the command which shows the help of the build.sh script. 
BUILD_COMMAND="mvn package -DskipTests"
HELP_COMMAND="
	Usage:
    -b  <branch_name>     Branch name
    -n  <new_branch>      Create new branch
    -f  <zip|tar>         Compress format should be either zip or tar
    -p  <artifact_path>   Copy artifact to spesific path, please providee full path
    -d  <debug_mode>      Enable debug mode(expect true or false)
			"
#---------END OF VARIABLE DECLARATION----------#





#---------START OF FUNCTION DECLARATION---------#
#This function is used to show the help of the build.sh script. In this function
# HELP_COMMAND is called to print out explanations for the user and exit the script.
usage(){
	echo "${HELP_COMMAND}"
	exit 1
}
#-----------END OF FUNCTION DECLARATION----------#





#----------------START OF MAIN-----------------#

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



#Here we check first if the user try to take a build with main/master branch. If so,
#an error message is displayed to warn the user. If user provided a valid branch_name
# first it checks if the user is in this branch. If user is in corrent branch, it will
# execute the build command. If user is not in the correct branch, it will check out the
#correct branch, then execute the build command.
if [[ "${branch_name}" == "main" || "${branch_name}" == "master" ]];
then
	echo -e "\e[1;31mWARNING!!!\033[0m"
	echo "Şu an master ve ya main branch'ini build ediyorsunuz !!!"
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
	else
		echo -e "\e[1;31mThe branch of ${branch_name} does not exist."
		echo "Please check the branch name and try again with -n NEW_BRANCH option."
		exit 1
	fi
fi 



#Here we check if user did not provide an empty string for new brancn name.
#If provided a string for name, it will create a new branch with the name provided. 
if [ ! -z "${new_branch}" ];
then
	git checkout -b ${new_branch}
fi



#Here in first statement of first if condition we check if user provided a zip compress format.
#In second statement we check if user provided a valid artifact path. If not, it will create a zip 
#archive file in the current directory as pwd command indicates.
if [[ "${compress_mode}" == "zip" && -z "${artifact_path}" ]];
then
	dir=$(pwd)
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	echo "Compress mode: ${compress_mode} and artifact is created under: $dir/"
	${BUILD_COMMAND}
	zip -r ./${current_branch}.zip ./target/*.jar
#Here we check if compress mode is provided correct as zip and artifact path is provided. If so,
#it will create a zip file under the provided artifact_path.
elif [[ "${compress_mode}" == "zip" && ! -z "${artifact_path}" ]];
then
	echo "Compress mode: ${compress_mode} and artifact path: ${artifact_path}"
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	${BUILD_COMMAND}
	zip -r ${artifact_path}${current_branch}.zip ./target/*.jar
#Here in first statement of first if condition we check if user provided a tar compress format.
#In second statement we check if user provided a valid artifact path. If not, it will create a zip 
#archive file in the current directory as pwd command indicates.
elif [[ "$compress_mode" == "tar" && -z "$artifact_path" ]];
then
	echo "Compress mode: ${compress_mode} and artifact path: ${pwd}"
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	${BUILD_COMMAND}
	tar -czf ./${current_branch}.tar.gz ./target/*.jar
#Here we check if compress mode is provided correct as tar and artifact path is provided. If so,
#it will create a tar file under the provided artifact_path.
elif [[ "${compress_mode}" == "tar" && ! -z "${artifact_path}" ]];
then
	echo "Compress mode: ${compress_mode} and artifact path: ${artifact_path}"
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	${BUILD_COMMAND}
	tar -czf ${artifact_path}${branch_name}.tar.gz ./target/*.jar
#Here we check if user didn't provide either zip or tar compress mode. If so, ıt will show an
#error message and exit the script.

elif [[ "${compress_mode}" != "tar" && "${compress_mode}" != "zip" && ! -z "${compress_mode}" ]];
then
	echo "Uygun bir sıkıştırma formatı girmediniz. Bu script sadece .tar ve .zip uzantılarını destekler"
	exit 1
fi

#Here we take artifact_path and shows it to the user. Also, for double protection, again it is checked
#if user provided a valid artifact_path. 
#if [ "${artifact_path}"!="" ];
#then
#	echo "Artifact path defined as: ${artifact_path}"
#fi


#Here we check if debug mode is activated with the true value. If so, and -X flag is added to our BUILD_COMMAND
#For Maven it means, execute the build with debug mode on.
if [ "${debug_mode}" == "true" ]; then
	echo "Debug mode is enabled"
	BUILD_COMMAND+="-X"
fi



#Execute the build command.
eval "$BUILD_COMMAND"

#---------------------END OF MAIN-------------------------#
