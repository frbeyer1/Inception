Steps to getting it started in new environment:

- add host:
    sudo nano /etc/hosts
        add at the end: 127.0.0.1   frbeyer.42.fr

- install docker and docker compose

- add user to sudo:
    sudo usermod -aG docker $USER
    newgrp docker

- create volume mount location, if necessarry (gets done by makefile):
    sudo mkdir -p ${HOME}/data/mariadb
    sudo mkdir -p ${HOME}/data/wordpress

Run:

- start: 
    sudo docker compose up
    sudo docker compose up -d

- execute commands insaide containers:
    sudo docker exec

    enter nginx container: sudo docker exec -it nginx bash

- info about containers:
    sudo docker ps
    sudo docker compose ps
    sudo docker logs <container_name_or_id>
    sudo docker info

- stop: 
    sudo docker compose down
    sudo docker compose down -v (removes volumes too)

- list volumes: 
    sudo docker volume ls

- remove container:
    sudo docker rm nginx
    sudo docker rm wordpress
    sudo docker rm mariadb

- remove volumes:
    sudo docker volume rm srcs_wordpress
    sudo docker volume rm srcs_mariadb

- remove all unused volumes:
    sudo docker volume prune