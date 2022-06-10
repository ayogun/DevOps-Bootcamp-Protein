

# 2.Week 1.Project
With `build.sh` script you can take build of your code easy and fast.

<br />

# Table of contents[![](./docs/img/pin.svg)](#table-of-contents)
<br />

1. [About](#aciklama)
    - [Technologies](#tech)
    - [Scope](#scope)
3. [Note](#not)
4. [Usage](#usage)
    - [Synopsis](#synopsis)
    - [Examples](#examples)

<br />

---

<br />

### About: [![](./docs/img/pin.svg)](#aciklama)

#### Technologies [](#tech)
<span>
<img src="https://img.shields.io/badge/Apache%20Maven-C71A36?style=for-the-badge&logo=Apache%20Maven&logoColor=white" alt="drawing" width="100" />
<img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" alt="drawing" width="100"/>
<img src="https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white" alt="drawing" width="100"/>
<img src="https://img.shields.io/badge/spring-%236DB33F.svg?style=for-the-badge&logo=spring&logoColor=white" alt="drawing" width="100"/>
<img src="https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="drawing" width="100"/>
</span>

#### Scope [](#scope)

Here in this project, we have a java code and arbitrarily imagine that our developer team needs a script to take the build of a particular branch with a script. 
The requirements of he team as shown below:

1. The user should name the branch he wants to get the build and if he is not on that branch at the moment, he should checkout to that branch and the build process should start in that way.
2. When the user wants to compile the main or master branch, a (WARNING) should appear on the screen, saying `You are currently getting a build of the master or main branch !!!`.
3. The user should also be able to create a new branch with the help of this script.
3. Whether the DEBUG mode will be on during the build process shall depend on the user. If the user does not prefer to specify, DEBUG mode should be turned off by default.
4. The user should be able to choose in which format the resulting artifacts will be compressed, two options should be presented to the user: `zip` or `tar.gz ` . If a format other than these two compress formats is given, the build process should not start, the script should stop execution. (Note: The artifact name should be in the format of branch_name.tar.gz and branch_name.zip, that is, the name of the currently working branch should be the name of that compressed file.)
5. The directory where the compressed artifacts will be created should be taken from the user.


`USER`: Is a developer who uses this script to take build of thie java code.

---

### Note: [![](./docs/img/pin.svg)](#not)

- The project given here is written with `Java Spring Boot` and is managed with `Maven` package manager.
- It can be used in a different project than the one given here. For example a `NodeJS` application and you can use `npm` for package management.

---


### Usage: [![](./docs/img/pin.svg)](#usage)
The script file should be added to .bashrc file in order to use the script ,as requested in project, as a bash command. 

#### _Synopsis_ [](#synopsis)
`build.sh         [OPTION...]`

#### _Examples_ [](#examples)
    
>**-b** = _BRANCH_NAME_  </br>
>&emsp;&ensp;    Taking the build for the given BRANCH_NAME  </br>
></br>
>**-n** = _NEW_BRANCH_ </br>
>&emsp;&ensp;    Create the new branch with the name of given NEW_BRANCH and take build for that branch. </br>
></br>
>**-f** = _COMPRESSION_FORMAT_ </br>
>&emsp;&ensp;    After it takes the build' it compress the build with the given COMPRESSION_FORMAT as zip or tar.  </br>
>&emsp;&ensp;    COMPRESSION_FORMAT supports only zip and tar. Compressed artifact is placed under current directory </br>
>&emsp;&ensp;    it it is not specified. </br>
></br>
>**-p** = _ARTIFCAT_PATH_     </br>
>&emsp;&ensp;    Compressed artifact is placed to the given path as ARTIFACT_PATH     </br>
>&emsp;&ensp;    The path should be absolute but not relative.   </br>
> </br>
>**-d** = _DEBUG_MODE_  <debug_mode>    </br>
>&emsp;&ensp;      According to given DEBUG_MODE value it enables debug mode. To enable debug mode, give "true", to disable       </br>
>&emsp;&ensp;      give "false". As default DEBUG_MODE is set to "false.  </br>
></br>
></br>



```shell

$ build.sh --help

Usage:
    -b  <branch_name>     Branch name
    -n  <new_branch>      Create new branch
    -f  <zip|tar>         Compress format should be either zip or tar
    -p  <artifact_path>   Copy artifact to spesific path, please providee full path
    -d  <debug_mode>      Enable debug mode(expect true or false)

```


