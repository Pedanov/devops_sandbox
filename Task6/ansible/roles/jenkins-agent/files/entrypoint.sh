#!/bin/bash
sudo docker run -i --rm --name agent1 --init \
    -v /share/jenkins-agent:/home/jenkins/agent \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(which docker):/usr/bin/docker \
    jenkins/agent java -jar /usr/share/jenkins/agent.jar \
    -workDir /home/jenkins/agent \
    -secret af6c79a4c683983158b2771650c6665a95c65d6221d0a16ec28e51483ed069a5 \
    -jnlpUrl http://jenkins.pedanov.com:8080/computer/CentOS%2DAgent1/jenkins-agent.jnlp