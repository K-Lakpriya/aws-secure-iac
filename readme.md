### ================================================================
### 📋 Architecture Diagram Description (for README)
### ================================================================
### [VPC]
### ├── Public Subnet (with Bastion Host, optional)
### ├── Private Subnet (with EC2 Instance)
### └── Internet Gateway + NAT Gateway
###
### [Security]
### ├── VPC Flow Logs (CloudWatch)
### ├── CloudTrail (S3 + Encryption)
### ├── AWS Config Rules
### ├── CloudWatch Alarms (Unauthorized API calls)
### └── Secrets stored in AWS Secrets Manager

# ================================================================
# 📋 README.md (Deployment Instructions)
# ================================================================
# AWS Secure Infrastructure - Terraform IaC

## 📂 Project Folder Structure
```bash
infra/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── iam/
│   │   ├── main.tf
│   │   └── outputs.tf
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── cloudtrail/
│   │   ├── main.tf
│   │   └── outputs.tf
│   ├── config/
│   │   ├── main.tf
│   │   └── outputs.tf
│   ├── cloudwatch/
│   │   ├── main.tf
│   │   └── outputs.tf
│   └── secrets_manager/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── github/
    └── workflows/
        └── terraform.yml
```

## Overview
This Terraform project provisions a secure AWS environment, including a VPC, private/public subnets, EC2 instance, CloudTrail logging, AWS Config compliance, and CloudWatch monitoring.

## Features Implemented
- VPC with public and private subnets
- NAT Gateway for private subnet internet access
- Encrypted EBS volumes
- IAM Role with Least Privilege (SSM access)
- CloudTrail setup with encrypted S3 bucket
- AWS Config enabled with compliance rules
- Unauthorized API CloudWatch alarm
- Secrets stored securely in Secrets Manager
- VPC Flow Logs enabled
- Terraform GitHub Actions CI/CD Pipeline

## How to Deploy

```bash
# 1. Clone the Repository
$ git clone <your-repository-url>
$ cd <project-folder>

# 2. Initialize Terraform
$ terraform init

# 3. (Optional) Customize Variables
- Edit variables in `terraform.tfvars` or provide through CLI

# 4. Run Plan
$ terraform plan

# 5. Apply Changes
$ terraform apply
```

## Pre-requisites
- AWS CLI configured (`aws configure`)
- Terraform installed (`brew install terraform` or download manually)
- IAM user with programmatic access and sufficient permissions

## Security Best Practices Implemented
- VPC isolated with private/public subnet design
- No public IPs for private EC2 instances
- Encrypted storage (EBS volumes, S3 buckets)
- Minimum IAM permissions (principle of least privilege)
- VPC Flow Logs to monitor network traffic
- CloudTrail audit logging across regions
- AWS Config ensures resource compliance
- Alarms for unauthorized actions
- Secrets securely handled via Secrets Manager

## Assumptions
- Bastion Host deployment is optional and assumed to exist separately.
- CIDR blocks used are customizable.
- Costs for NAT Gateway, CloudTrail, Config, etc. are considered.

---

> "Security by design: Infrastructure as Code, the right way." 🚀