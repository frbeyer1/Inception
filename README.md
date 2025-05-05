# Inception

Inception is a System Administration project focused on Docker and containerization. It involves setting up a small infrastructure composed of different services using Docker containers.

## Overview

### Setup

1. NGINX with TLSv1.2 or TLSv1.3 only
2. WordPress + php-fpm (without NGINX)
3. MariaDB (without NGINX)

![inception_architecture](https://github.com/user-attachments/assets/5ef856a8-2557-43d5-b91a-4e9703ab1dd9)

### Prerequisites

- Custom Dockerfiles for each service
- Use Alpine or Debian (penultimate stable version)
- No ready-made Docker images (except Alpine/Debian)
- Two users in WordPress database (one administrator)
- NGINX as the only entrypoint (port 443, TLSv1.2 or TLSv1.3)
- Use of environment variables for sensitive data (.env file and Docker secrets)

More information about the project is in the [subject.pdf](https://github.com/frbeyer1/Inception/blob/main/en.subject.pdf)

## Prerequisites

1. Install Docker and Docker Compose

2. Add the user to the docker group (to run docker commands without sudo and root mode)

## Usage

1. Clone the repository:
```
git clone https://github.com/frbeyer1/inception.git
```
2. Navigate to the project directory:
```
cd inception
```
3. edit the hosts file to acess the Wordpress website with frbeyer.42.fr
```
sudo nano /etc/hosts
```
paste in:
```
127.0.0.1 frbeyer.42.fr
```
4. Build the images and launch:
```
make build
```
5. Stop the containers:
```
make down
```
6. Launch the containers:
```
make
```
7. Stop and reaunch the containers:
```
make re
```
8. Remove all containers and unused Docker data (partial)
```
make clean
```
9. Forces deep cleanup of docker data, removes volumes and local data
```
make fclean
```
