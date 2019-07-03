# terraform-kafka-server

## Single Node Kafka for use with the Snowflake Connector for Apache Kafka

### Description

Spin up a single node of Confluent Community components using Terraform.  

A bash shell script is provided to configure the following components:

- Centos7 node for Confluent
- Deploy the Snowflake Connector for Apache Kafka
- Create scripts to configure Kafka Connect connectors
- Create scripts to produce data in plain text and JSON using Python and Faker

Once deployed and configured, the Snowflake Connector for Apache Kafka will consume data from a Kafka topic and load the data into a table in a Snowflake account.

### Installation

To create an end to end pipeline, you will first need the following:

1. Terraform - installed and configured with AWS access keys.
2. A Snowflake account - use recommended configuration for the Connector for Apache Kafka as described in the Snowflake documentation.
