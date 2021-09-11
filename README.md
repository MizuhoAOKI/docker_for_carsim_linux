# Ubuntu 18.04 env. for Carsim Linux
See [this note](https://hackmd.io/3xnUw_hTT3WlnjrMmWYd_w?both) for more information about Carsim Linux. 

## Environment overview
Since docker makes virtual environments, you can use any OS on your PC.
You can edit Dockerfile, docker-compose.yaml to change settings below.

- OS(Base Image): Ubuntu 18.04
- installs: 
    - sudo
    - git 
    - vim
    - tree
    - build-essential 
    - cmake 
    - python3
    - python3-pip
- Image Name : ubuntu1804image
- Container Name : ubuntu1804container

## What is Docker?
- [Official Document](https://docs.docker.com/get-started/overview/)

## How to install docker
- [Docker Desktop for mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac)
- [Docker Desktop for windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
- [Docker for Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- Confirm installation by checking the version of your docker.
    ```
    $ docker -v
    Docker version 19.03.12, build 48a66213fe
    $ docker-compose -v
    docker-compose version 1.27.2, build 18f557f9
    ```

## How to launch a docker container

1. Clone this repository to your working directory.

    ``` 
    $ cd YOUR_WORKING_DIR
    $ git clone https://github.com/MizuhoAOKI/docker_for_carsim_linux.git 
    ```

2. Build image and launch container.
    ```
    $ cd docker_ubuntu1804_env
    $ docker-compose up -d
    ```
    ※ -d: option to process in the background.

3. Start container
    ```
    $ docker start ubuntu1804container
    ```
    ※ ubuntu1804container is a name of docker container. You can check it by running  `docker ps -a`

4. Execute container.
    ```
    $ docker exec -it ubuntu1804container bash
    normaluser@[container ID]:/workspace#
    ```
    - You can operate virtual ubuntu environment as a normaluser (sudoer).
    - Files in /workspace in the container is synchronized with docker_ubuntu1804_env/workspace on your PC.
    

6. After your work finishes, get out of the container, then close it.
    ```
    normaluser@[container ID]:/workspace/# exit
    $ docker stop ubuntu1804container 
    ```


## Check status
- list images
    ``` 
    $ docker images 
    REPOSITORY                       TAG                 IMAGE ID            CREATED             SIZE
    ubuntu1804image                          latest              e421cc616236        22 seconds ago      648MB
    ubuntu                           18.04               9140108b62dc        2 weeks ago         72.9MB
    ```
- list containers
    ``` 
    $ docker ps -a 
    CONTAINER ID        IMAGE                            COMMAND                  CREATED              STATUS                  PORTS               NAMES
    45e6085e0d4f        ubuntu1804image                           "/bin/bash"             About a minute ago   Up About a minute                           ubuntu1804container
    ```

## Repository overview
```
docker_cpp_dev
├── .git
├── .gitignore
├── .devcontainer
├── Dockerfile
├── docker-compose.yml
├── carsim
└── workspace
```

- working directory: workspace/

## Cleaning of your environment
The following command deletes images, containers, volumes, and networks, which are made with `docker-compose up`.
Note that peretual volume on your PC will not be deleted.

```
$ docker-compose down --rmi all --volumes --remove-orphans
```

## How to install and set up Carsim Linux automatically.
- See detailed info at [this note](https://hackmd.io/3xnUw_hTT3WlnjrMmWYd_w?both).