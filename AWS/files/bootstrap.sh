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

wget http://central.maven.org/maven2/com/snowflake/snowflake-kafka-connector/0.3/snowflake-kafka-connector-0.3.jar
sudo mkdir /usr/share/java/kafka-connect-snowflake

sudo mv snowflake-kafka-connector-0.3.jar /usr/share/java/kafka-connect-snowflake/snowflake-kafka-connector-0.3.jar

sudo curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
sudo python get-pip.py
sudo pip install Faker

touch gen-data.py

echo "from faker import Faker" > gen-data.py
echo "from faker.providers import internet" >> gen-data.py
echo "import datetime" >> gen-data.py
echo "fake = Faker()" >> gen-data.py
echo "fake.add_provider(internet)" >> gen-data.py
echo "for _ in range(100):" >> gen-data.py
echo "    print(str(datetime.datetime.now()) + ',' + fake.name() + ',' + fake.ipv4_private())" >> gen-data.py



confluent start 