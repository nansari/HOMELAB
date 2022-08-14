# Jenkins
An open automation server to build, test, deploy and CI/CD. It has 1800+ community contributed plugins to achieve the tasks.
It is one of the good examples of how a fork of the original project survived and thrived after splitting from original project Hudson when the parent company tried to take control of the project.

# Install docker in VM
Install docker in AlmaLinux 8.0 OS
```
dnf install -y yum-utils
yum-config-manager --add-repo \
https://download.docker.com/linux/centos/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin
systemctl enable docker.service
systemctl start docker.service
```

# Run Jenkins dockers
* Pull jenkins docker official LTS images
* pull dind ( Docker in Docker) image. It is needed to controll a container on top of another container. It is required to run CI tools such as Jenkins on top of Docker container.
* Create a Link Layer software bridge network to connect all containers required for a purpose to connect to separate isolated unique network
```
docker image pull jenkins/Jenkins:lts
docker image pull docker:dind  
docker network create jenkins
```
Start Jenkins docker container:
* publish port 8080 of container to host 8080 port to access Jenkins web interface from a host on your network
* publish port 50000 to connect inbound Jenkins agents that would need to interact with blueocean container
```
docker run  \
    --env DOCKER_TLS_CERTDIR=/certs \
    -p 8080:8080 \
    -p 50000:50000 \
    --name jenkins \
    -v jenkins_home:/var/jenkins_home \
    --detach \
    jenkins/Jenkins:lts

doceker ps
```

# Install maven in Jenkins container
```
docker exec -it -u root jenkins /bin/bash
apt-get update && apt-installl maven -y
```

# Start/Stop Jenkins Docker
We need to do certain change to docker container, hence stop it befor sutting down guest OS to preserve changes on next docker run. Ideally, we all changes need to be passed as environment varible while stating docker
```
docker stop Jenkins
docker start Jenkins
```

# Jenkins Pipeline


# Reference
https://www.Jenkins.io/doc/book/installing/docker/
https://www.jenkins.io/doc/book/pipeline/syntax/
https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/

# Credit
Warp 9 Training