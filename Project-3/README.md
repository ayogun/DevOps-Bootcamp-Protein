
# Protein DevOps Engineering Bootcamp 3.Week 1.Project
</br>

My dear friend who ended up here to evaluate my project. The scripts that you will be looking for are:
- `first_script.sh`
- `docker_dev_tools.sh` 

 For first part of the homework, you can check `first_script.sh`. For second part you check `docker_dev_tools.sh`.

</br>

---

---

</br>
</br>

# Table of contents [![](./docs/img/pin.svg)](#table-of-contents)

</br>
</br>

1. [About](#about)
2. [Scope](#scope)
3. [Usage](#usage)
    - [Synopsis](#synopsis)
    - [Examples](#examples)
4. [Technologies](#technologies)
5. [Note](#note)


</br>
</br>

---

</br>
</br>

📌

## **About** 

This project includes two seperate automatization scripts. They are created for developers in our team. They are `first_script.sh` and `docker_dev_tools.sh`. These two scripts rely on some files in this directory. They are:
- `Dockerfile` 
- `docker-compose-mongo.yml` 
- `docker-compose-mysql.yml` 
- `.dockerignore` 

**PS:** *Please make sure these files are included in your project directory.*

</br>
</br>

---
</br>
</br>

📌

## **Scope**  

Here in this project, I have developed two scripts. To get more information read further.


### **1) first_script.sh** 

This script helps user to run the application with the docker which is found in directory `app`. This script works with 4 multiple stages. 

1. In this first stage, script will ask if you want to take a builf of the app. If you want, it will ask two mandatory parameters as `image name` and `image tag` in order to successfully build the image. If one of these mandatory parameters were not given, script will print an `ERROR` message and stop working. It relies on `Dockerfile`. Please make sure that you have this file and update it according to your needs.

2. In this stage, script will ask if you want to run this image in your local. If you want it will ask if you want to specify two optional parameters `memory` ve `cpu` limits. It will help you to limit your container to avoid of depleteing your resources. If these parameters are not specified, container will work unlimited.


3. In this stage, script will ask if you want to push your image. If your answer is yes, you can use either `dockerhub` or `gitlab image registery`. After you specify your choice, script will ask your login name and password before push. Then it will push image to the specified registry.

4. In case of user need any database, in this stage script asks whether database needed or not. If user needs one, script expect an answer from user as `mysql` or `mongo`. According to selection, specified database image is being pulled and run. This stage rely on `docker-compose-mongo.yml` and `docker-compose-mysql.yml` files. In these docker compose files a `memory` and `cpu` limitation has been specified. According to user desire, they might be updated.


</br>
</br>

### **2) docker_dev_tools.sh**

This script has 3 different modes and they all have different mandatory and optional flags that you can use. Further detail is provided below.

1. **First Mode**: *Image Build Mode*

   With this mode user can build an image. --registery parameter is an optional parameter but --image-name and --image-tag parameters are mandatory. If --registry parameter is provided, this image will be pushed to the specified registry.

```shell
   Example:
        docker_dev_tools.sh --mode build --image-name example_image --image-tag v1 --registery example_registery     
    
   
   Optional Parameters:
    - registery
   
   Mandatory Parameters:
   - mode
   - image-name
   - image-tag
```

2. **Second Mode:** *Image Deploy Mood*

User here can run the image that has been already built. If optional parameters are specified, they will be appended to command, unless image will be run without --container-name or --cpu and --memory limitation.

```shell
    Example: 
        docker_dev_tools.sh --mode deploy --image-name example_image --image-tag v1 --container-name example_container --memory "1g" --cpu "1.0"
    
    Mandatory Parameters:
    - mode
    - image-name
    - image tag
    
    Optional Parameters:
    - container-name
    - memory
    - cpu 
          
```

3. **Third Mode:** *Template Mode*

With this mode, user may run some container among options. For this version only MySQL and MongoDB templates are specified. If any parameter but not `mysql`or `mongo` would be tried to passed by user, script will crash and print an error message. This mode rely on `docker-compose` files in the directory.


```shell
    Example: 
        docker_dev_tools.sh --mode tempate --application-name mysql
    
    Mandatory Parameters:
    - mode
    - application-name
    
```
</br>
</br>

---

</br>
</br>

📌

### **Usage**  
The script file should be added to .bashrc file in order to use the script ,as requested in project, as a bash command. `first_script.sh`has build-in instructions. Read further for `docker_dev_tools.sh`. 

#### _Synopsis_ 
`docker_dev_tools.sh         [OPTION...]`

#### _Examples_ 
    

```shell
Usage:
--mode              Select mode <build|deploy|template> 
--image-name        Docker image name
--image-tag         Docker image tag
--memory            Container memory limit
--cpu               Container cpu limit
--container-name    Container name
--registery         DocherHub or GitLab Image registery <dockerhub|gitlab>
--application-name  Run mysql or mongo server <mysql|mongo>



About:
This script helps user to build, run a docker image or create a database. Under this scope, --modis the main parameter which helps user to select the mode and this is a mandatory parameter. Builoption automatically builds the docker image, deploy option automatically runs the docker image antemplate option creates a database container.

The script is divided into three parts. The first part is the build part which requires mandator--image-name and --image-tag parameters. The second part is the deploy part which requires mandator--image-name and --image-tag parameters. The deploy part can take additional three optionaparameters as --container-name, --memory and --cpu. The third part is the template part whicrequires mandatory --application-name parameter.



Examples:
$ ./docker_dev_tools.sh --mode build --image-name example_image --image-tag v1 --registeexample_registe
$ ./docker_dev_tools.sh --mode deploy --image-name example_image --image-tag v1 --container-naexample_container --memory "1g" --cpu "1.0"
$ docker_dev_tools.sh --mode tempate --application-name mysql    
```

</br>
</br>


---

</br>
</br>

📌

## **Technologies** 

![MongoDB](https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=for-the-badge&logo=mongodb&logoColor=white) ![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white) ![GitLab](https://img.shields.io/badge/GitLab-330F63?style=for-the-badge&logo=gitlab&logoColor=white)

![DockerHub](https://img.shields.io/badge/Docker%20Hub-294356?style=flat&logo=docker&logoColor=white) ![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=GNU%20Bash&logoColor=white) ![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=flat&logo=docker&logoColor=white) ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat&logo=linux&logoColor=black)

</br>
</br>


---

</br>
</br>

📌

## **Note** 

- The project given here is written particularly for the python app in this directory. If you want to clone it and use in your own local, you should update your Dockerfile and docker-compose files.
- Since it is version 1.0, it doesn't include a lot of options. You may extend the options according to your desires.

