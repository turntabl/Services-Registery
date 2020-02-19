#!/bin/bash
 
#create init env files: list all services in the array, separeted by space
declare -a arr=("hello" "gis" ) 
for i in "${arr[@]}"
do
   filename="./.envs/.$i" 
   if [[ ! -e "$filename" ]]; then
    mkdir -p ./.envs
    touch $filename
   fi
done

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
declare -i count=$(docker-compose ps | wc -l) 
if [ $count -gt 2 ]; then
    echo "Restarting services:....."
    docker-compose down
    docker-compose up --build
else 
    echo "Starting all services:....."
    docker-compose up --build
fi 