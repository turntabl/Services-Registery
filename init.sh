#!/bin/bash
 
#create init env files: list all services in the array, separeted by space
declare -a arr=("apigateway" "gis" "permission") 
for i in "${arr[@]}"
do
   filename="./.envs/.$i" 
   if [[ ! -e "$filename" ]]; then
    mkdir -p ./.envs
    touch $filename
   fi
done

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
    echo "Restarting services:...."
    sudo docker-compose down 
    sudo docker-compose pull 
    sudo docker rmi $(docker images -a | grep '<none>' | awk '{print $3}')
    sudo docker-compose build --no-cache
    sudo docker-compose up -d
else 
    echo "Starting all services:....."
    sudo docker-compose down 
    sudo docker-compose pull 
    sudo docker rmi $(docker images -a | grep '<none>' | awk '{print $3}')
    sudo docker-compose build --no-cache
    sudo docker-compose up -d
fi