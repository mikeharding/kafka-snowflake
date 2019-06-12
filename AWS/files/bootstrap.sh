#!/bin/bash

sudo yum -y install wget

wget https://mharding-java8.s3-us-west-2.amazonaws.com/jdk-8u211-linux-x64.rpm

sudo rpm -Uvh jdk-8u211-linux-x64.rpm

export JAVA_HOME=/usr/java/jdk1.8.0_211-amd64
export PATH=$PATH:/usr/java/jdk1.8.0_211-amd64/bin

sudo rpm --import https://packages.confluent.io/rpm/4.0/archive.key


sudo echo "[Confluent.dist]
name=Confluent repository (dist)
baseurl=https://packages.confluent.io/rpm/4.0/7
gpgcheck=1
gpgkey=https://packages.confluent.io/rpm/4.0/archive.key
enabled=1

[Confluent]
name=Confluent repository
baseurl=https://packages.confluent.io/rpm/4.0
gpgcheck=1
gpgkey=https://packages.confluent.io/rpm/4.0/archive.key
enabled=1" > confluent.repo

sudo mv confluent.repo /etc/yum.repos.d/
sudo yum clean all

sudo yum -y install confluent-platform-oss-2.11


# export PATH=/usr/bin/confluent/bin:$PATH

confluent start 