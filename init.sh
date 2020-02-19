#!/bin/bash

# install git
if git --version 2>&1 >/dev/null ; then 
    echo >&2 "git installed"
else
    sudo apt install git -y
fi

# install docker
if docker --version 2>&1 >/dev/null ; then 
    echo >&2 "docker installed"
else
    sudo apt install docker -y
fi

#install docker-compose
if docker-compose --version 2>&1 >/dev/null ; then 
    echo >&2 "docker-compose installed"
else
    sudo apt install docker-compose -y
fi

# run docker-compose

IS_RUNNING=`docker-compose ps -q hello-service`
if [[ "$IS_RUNNING" != "" ]]; then
    echo "The service is running!!!"
    docker-compose down
    docker-compose up --build
else 
    docker-compose up --build
fi
#docker-compose down
#docker-compose up --build