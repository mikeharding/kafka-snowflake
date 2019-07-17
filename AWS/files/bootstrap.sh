#!/bin/bash

sudo yum -y install wget
sudo yum -y install epel-release
sudo yum -y install jq

wget https://mharding-java8.s3-us-west-2.amazonaws.com/jdk-8u211-linux-x64.rpm

sudo rpm -Uvh jdk-8u211-linux-x64.rpm

export JAVA_HOME=/usr/java/jdk1.8.0_211-amd64
export PATH=$PATH:/usr/java/jdk1.8.0_211-amd64/bin

propersudo rpm --import https://packages.confluent.io/rpm/5.2/archive.key

sudo echo "[Confluent.dist]
name=Confluent repository (dist)
baseurl=https://packages.confluent.io/rpm/5.2/7
gpgcheck=1
gpgkey=https://packages.confluent.io/rpm/5.2/archive.key
enabled=1

[Confluent]
name=Confluent repository
baseurl=https://packages.confluent.io/rpm/5.2
gpgcheck=1
gpgkey=https://packages.confluent.io/rpm/5.2/archive.key
enabled=1" > confluent.repo

sudo mv confluent.repo /etc/yum.repos.d/
sudo yum clean all

sudo yum -y install confluent-community-2.12

wget http://central.maven.org/maven2/com/snowflake/snowflake-kafka-connector/0.3/snowflake-kafka-connector-0.3.jar
sudo mkdir /usr/share/java/kafka-connect-snowflake

sudo mv snowflake-kafka-connector-0.3.jar /usr/share/java/kafka-connect-snowflake/snowflake-kafka-connector-0.3.jar

sudo yum -y install epel-release
sudo yum -y install python-pip
sudo pip install Faker
sudo pip install request

touch gen-text.py
echo "from faker import Faker" > gen-text.py
echo "from faker.providers import internet" >> gen-text.py
echo "import datetime" >> gen-text.py
echo "fake = Faker()" >> gen-text.py
echo "fake.add_provider(internet)" >> gen-text.py
echo "for _ in range(100):" >> gen-text.py
echo "    print(str(datetime.datetime.now()) + ',' + fake.name() + ',' + fake.ipv4_private())" >> gen-text.py

touch gen-json.py
echo "from faker import Faker" > gen-json.py
echo "from faker.providers import internet" >> gen-json.py
echo "import datetime" >> gen-json.py
echo "fake = Faker()" >> gen-json.py
echo "fake.add_provider(internet)" >> gen-json.py
echo "for _ in range(100):" >> gen-json.py
echo "    print('{\"timestamp\":\"' + str(datetime.datetime.now()) + '\",\"name\":\"' + fake.name() + '\",\"ip\":\"' + fake.ipv4_private() + '\"}')" >> gen-json.py

touch produce-text.sh
echo "python gen-text.py >> strings.txt" > produce-text.sh
sudo chmod +x produce-text.sh

touch produce-json.sh
echo "python gen-json.py >> json.txt" > produce-json.sh
echo "cat json.txt | kafka-console-producer --broker-list localhost:9092 --topic demotopic" >> produce-json.sh
sudo chmod +x produce-json.sh

touch read-topic.sh
echo "sudo kafka-console-consumer --bootstrap-server localhost:9092 --topic demotopic" > read-topic.sh
sudo chmod +x read-topic.sh

sudo sed -i 's/key.converter=io.confluent.connect.avro.AvroConverter/key.converter=org.apache.kafka.connect.json.JsonConverter/' /etc/schema-registry/connect-avro-distributed.properties
sudo sed -i 's,key.converter.schema.registry.url=http://localhost:8081,key.converter.schemas.enable=false,' /etc/schema-registry/connect-avro-distributed.properties
sudo sed -i 's/value.converter=io.confluent.connect.avro.AvroConverter/value.converter=org.apache.kafka.connect.json.JsonConverter/' /etc/schema-registry/connect-avro-distributed.properties
sudo sed -i 's,value.converter.schema.registry.url=http://localhost:8081,value.converter.schemas.enable=false,' /etc/schema-registry/connect-avro-distributed.properties

cat > local-file-source-connector.json << "EOF"
{
    "name": "local-file-source",
    "config": {
        "connector.class": "FileStreamSource",
        "tasks.max": 1,
        "file": "/home/centos/strings.txt",
        "topic": "demotopic",
        "key.converter": "org.apache.kafka.connect.json.JsonConverter",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter"
  }
}
EOF

cat > snowflake-connector.json << "EOF"
{
  "name":"snowflake",
  "config":{
    "connector.class":"com.snowflake.kafka.connector.SnowflakeSinkConnector",
    "tasks.max":"8",
    "topics":"demotopic",
    "snowflake.topic2table.map": "demotopic:demotopic",
    "buffer.count.records":"100",
    "buffer.size.bytes":"65536",
    "snowflake.url.name":"account.snowflakecomputing.com:443",
    "snowflake.user.name":"kafka",
    "snowflake.private.key":"key-on-a-single-line",
    "snowflake.database.name":"database",
    "snowflake.schema.name":"public",
    "key.converter":"org.apache.kafka.connect.storage.StringConverter",
    "value.converter":"com.snowflake.kafka.connector.records.SnowflakeJsonConverter"
  }
}
EOF