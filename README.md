## Streaming Data to Amazon MSK via AWS DMS

This repository provides you cloudformation scripts and sample code on how to implement
end to end pipeline for replicating transactional data from Aurora Postgresql DB to Apache Kafka.


## Purpose

Demo converting postgresql database to postgresql using postgresql and PostgresSQL RDS instances with SCT and DMS.  Additional option to use Kinesis in between DMS and Aurora.



&nbsp;

## Outline

- [Overview](#overview)
- [AWS Services Used](#aws-services-used)
- [Technical Overview](#technical-overview)
- [Instructions](#instructions)
  - [Create Environment](#create-environment)
  - [Troubleshoot Environment](#troubleshoot-environment)
- [postgresql Setup](#postgresql-setup)
  - [Create Sample Databases](#create-sample-databases)
- [Windows Setup](#windows-setup)
  - [SCT](#sct)
  - [Troubleshooting Windows](#troubleshooting-windows)
- [postgresql with DMS](#postgresql-with-dms)
  - [postgresql Replication](#postgresql-replication)
  - [postgresql Drop Foreign Keys](#postgresql-drop-foreign-keys)
- [Create DMS Resources](#create-dms-resources)
  - [Create DMS Replication Instance](#create-dms-replication-instance)   
  - [Create DMS Endpoints](#create-dms-endpoints)
  - [Create postgresql to Postgresql Task](#create-postgresql-to-postgresql-task)
  - [Create postgresql to Kinesis Task](#create-postgresql-to-kinesis-task)
- [Cleaning up](#cleaning-up)


&nbsp;

## Overview

This demonstates setting up a DMS and Kafka pipeline with Aurora Postgresql as the source database.  Initially started with CloudFormation template from [Streaming data to Amazon Mangaed Streaming for Apache Kafka](https://github.com/aws-samples/aws-dms-msk-demo/blob/master/content/cfn/master-cfn.yaml).  This template was written in support of [this blog on DMS and Kafka](https://aws.amazon.com/blogs/database/streaming-data-to-amazon-managed-streaming-for-apache-kafka-using-aws-dms/).  

## AWS Services Used

* [AWS DMS Database Migration Service](https://aws.amazon.com/dms/)
* [AWS Cloudformation](https://aws.amazon.com/cloudformation/)
* [Amazon Managed Streaming for Apache Kafka (MSK)](https://aws.amazon.com/msk/)
* [Amazon RDS](https://aws.amazon.com/rds/)

## Technical Overview

* Start up environment
* Generate Load to Aurora Postgresql 
* Verify records replicated to MSK
* Contemplate mapping techniques

&nbsp;

---

&nbsp;

## Instructions

***IMPORTANT NOTE**: Creating this demo application in your AWS account will create and consume AWS resources, which **will cost money**.  Costing information is available at [AWS DMS Pricing](https://aws.amazon.com/dms/pricing/)   The template will cost money for the other resources as well.

&nbsp;

### Create Environment

* Some tips on creating an AWS account with [AWS Account instructions](https://dms-immersionday.workshop.aws/en/envconfig/regular.html)
* After reviewing  "Introduction" and "Getting Started", follow the Regular AWS Account instructions. ![Regular AWS Account](README_PHOTOS/InitialNavigation.jpg)
* Complete the "Login to the AWS Console" and "Create an EC2 Key Pair" steps
* In the "Configure the Environment" step, use the provided ./templates/awsDMSKafka.yaml [Solution yaml](https://github.com/jphaugla/awsDMSKafka/blob/main/template/awsDMSKafka.yaml)

### Troubleshoot Environment
* Can have issues with dms role creation.  If the dms-vpc-role already exists, an error will be given the CFN script will fail and rollback.  Either delete existing dms-vpc-role or remove its definition from the CFN script.
* Lambda runtime python version.  Must be able to get to the correct python runtime. [this cfn-response discussion covers this](https://aws.amazon.com/premiumsupport/knowledge-center/cloudformation-cfn-response-lambda/)

### Verify kafka
Login to the EC2 instance and verify the MSK is running using installed Kafka tools
* Open a new ssh session to the client EC2.
* Verify message queue is reachable and empty
    * [Refer this link](https://docs.aws.amazon.com/msk/latest/developerguide/msk-get-bootstrap-brokers.html) to get broker list for the kafka-topic command.
```bash
ssh -i <pemfile> ec2-users@ec2IPAddress
kafka/kafka_2.12-2.2.1/bin/kafka-topics.sh --list --bootstrap-server b-1.streamingblogmskclust.rvq2us.c13.kafka.us-east-1.amazonaws.com:9092,b-2.streamingblogmskclust.rvq2us.c13.kafka.us-east-1.amazonaws.com:9092
```

### PG Table Population
* Create tables and generate some records in to the Postgresql table
```bash
cd
git clone https://github.com/devrimgunduz/pagila.git
cd pagila
psql -d AuroraDB -h jph-dms-kafka-source-1.cykwyngishlk.us-east-1.rds.amazonaws.com -U master -f pagila-schema.sql
# ignore alter table errors as these are alter to owner "postgresql" and our master user is master (unless changed)
```
* Populate the tables
```bash
cd
git clone https://github.com/devrimgunduz/pagila.git
cd pagila
psql -d AuroraDB -h jph-dms-kafka-source-1.cykwyngishlk.us-east-1.rds.amazonaws.com -U master -f pagila-data.sql
# ignore alter table errors as these are alter to owner "postgresql" and our master user is master (unless changed)
```


### verify kafka topic records
```bash
kafka/kafka_2.12-2.2.1/bin/kafka-console-consumer.sh --topic dms-blog --bootstrap-server b-1.streamingblogmskclust.rvq2us.c13.kafka.us-east-1.amazonaws.com:9092,b-2.streamingblogmskclust.rvq2us.c13.kafka.us-east-1.amazonaws.com:9092
```

### Cleaning up

Remove all files from S3 to avoid accruing unnecessary charges

&nbsp;

---

&nbsp;
