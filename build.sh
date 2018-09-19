#!/bin/bash
name="apollo-test"
tag=$(date +"%m%d%H%M%S")

docker build -t ${name}:${tag} .

oldImage=$(docker images | grep ${name} | grep -v ${tag} | awk -vOFS=":" '{ print $1,$2 }')
if [[ -n ${oldImage} ]];then
    echo "Delete old Image: ${oldImage}"
    docker rmi ${oldImage}
fi
