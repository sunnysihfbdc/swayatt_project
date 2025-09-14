# swayatt Research Task Documentation

**Thid documentation is around the setup and configuration of sandbox infra required to run swayatt researh AI evaluation models**

# Infrastructure

## AWS

AWS Cloud Provider has been used to deploy the required infrastructure resources and following service are used
* EKS
* VPC
* IAM
* S3
* EC2
* ECR

## Terraform

Terraform, Infrastructure as code has been used to deploy all the resources and everything has been kept modular to 
make the deployment extensible and modular.

Project Architecture & Documentation
## Overview

This project provisions an AWS Infrastructure using Terraform.
It sets up a highly available and secure compute environment that includes:

VPC & Networking (private & public subnets, route tables, IGW, NAT)

Application Load Balancer (ALB) to route traffic from public internet → private EC2 instances / EKS nodes

EKS Cluster (optional) for container orchestration

Bastion Host for secure SSH access into private nodes

ECR Repository for container images

## Security Considerations

ALB → forwards only required ports (80/443) to private EC2/EKS nodes

Bastion Host used for private SSH access (no direct public access)

IAM roles control access for Bastion, EKS, and Node Groups

Tags applied consistently for cost management & resource organization

