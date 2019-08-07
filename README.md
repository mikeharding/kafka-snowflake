# kafka-snowflake

## Single Node Kafka for use with the Snowflake Connector for Apache Kafka

### Description

Spin up a single node of Confluent Community components using Terraform.  

A bash shell script is provided to configure the following components:

- Centos7 node for Confluent
- Deploy the Snowflake Connector for Apache Kafka
- Create scripts to configure Kafka Connect connectors
- Create scripts to produce data in plain text and JSON using Python and Faker

Once deployed and configured, the Snowflake Connector for Apache Kafka will consume data from a Kafka topic and load the data into a table in a Snowflake account.

Currently, the only cloud provider supported is AWS.

## Installation

To run the examples, you will first need to install and configure, or have access, to the following software:

1. An AWS account. Azure and GCP not yet supported.
2. Terraform 0.12.3 or higher - installed and configured with AWS access keys.
3. A Snowflake account - use recommended configuration for the Connector for Apache Kafka as described in the Snowflake documentation.

It is assumed that you are able to install and configure Terraform, configure credentials for AWS, and have a Snowflake account with the required privileges to perform the configuration of the Snowflake database and Snowflake Connector for Kafka.

### AWS Account

You should create an IAM role for Terraform in the AWS Console and generate access keys for that role.  i

Install the AWS CLI and configure it using [these instructions](<https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html>). Terraform will then use the credentials configured for the CLI.

### Terraform

Install Terraform 0.12.3 or higher and configure it using [these instructions](<https://learn.hashicorp.com/terraform/getting-started/install.html>).

### Snowflake

You should have access to a Snowflake account and have the required privileges documented [here](<https://docs.snowflake.net/manuals/user-guide/kafka-connector.html>).

You can get a Snowflake trial account [here](<https://trial.snowflake.com>).

## Configuration

You will need to edit variables.tf located in the cloud provider subdirectory

## Usage

Navigate to the cloud provider subdirectory and execute the following commands at the OS prompt:

```bash
terraform init
terraform plan
```

If there are no errors, execute this command:

```bash
terraform apply
```

Enter __yes__ when prompted.

To remove the provisioned infrastructure, execute this command:

```bash
terraform destroy
```
