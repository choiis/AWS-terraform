
# AWS Terraform Infrastructure

This repository contains a fully automated, production-ready AWS infrastructure built using Terraform.  
It includes VPC networking, subnets, NAT gateways, bastion host, application servers, Network Load Balancer (NLB), Route53 DNS, ACM TLS certificates, Redis, RDS MySQL, Auto Scaling Group (ASG), and more.

## Architecture Overview

The Terraform code provisions:

### Networking
- 1 VPC
- Public and private subnets
- Internet Gateway
- NAT Gateway
- Route tables and routing configuration
- Security groups for public, private, database, and cache layers

### Compute
- Bastion host (public subnet)
- Auto Scaling Group (private subnet)
  - Launch Template based instances
  - Min 1, Max 3
  - CPU-based scale-in/scale-out

### Load Balancing
- Network Load Balancer (NLB)
  - Listener ports: 80/TCP, 443/TLS, 8080/TCP
- Target Group automatically populated by ASG instances

### Domain & TLS
- Hosted Zone via Route53
- ALIAS record → NLB
- ACM certificate with DNS validation
- TLS termination on NLB (port 443)

### Databases
- RDS MySQL
- ElastiCache Redis (Redis 6.x)

## Architecture Diagram (Conceptual)

```
Internet
   │
Route53 (api.insung-terraform.com)
   │
ACM (TLS Certificate)
   │
Network Load Balancer (80 / 443 / 8080)
   │
┌────────────────────────────────────────────┐
│                 AWS VPC                    │
│   ┌───────────────────────────┐            │
│   │     Public Subnets        │            │
│   │  - Bastion Host           │            │
│   │  - NAT Gateway            │            │
│   │  - RDS MySQL              │            │
│   └───────────────────────────┘            │
│   ┌───────────────────────────┐            │
│   │     Private Subnets       │            │
│   │  - ASG Auto EC2 (1~3)     │            │
│   │  - Redis (ElastiCache)    │            │
│   └───────────────────────────┘            │
└────────────────────────────────────────────┘
```

## Architecture Diagram (draw.io)
![AWS](http://imageresizer-dev-serverlessdeploymentbucket-xapz1q6q9exe.s3-website-ap-northeast-1.amazonaws.com/gitpng/aws_diagram_v6.PNG)

## Repository Structure

```
AWS-terraform/
├── vpc.tf
├── security.tf
├── ec2.tf
├── launch_template.tf
├── autoscaling.tf
├── nlb.tf
├── route53.tf
├── acm.tf
├── redis.tf
├── database.tf
├── variables.tf
├── outputs.tf
└── provider.tf
```

## Auto Scaling Behavior

| Condition | Action |
|----------|--------|
| CPU ≥ 40% | Scale-Out (+1 instance) |
| CPU ≤ 20% | Scale-In (–1 instance) |
| Min Size | Always 1 |
| Max Size | Up to 3 |

## Requirements

- Terraform 1.3+
- AWS Account
- AWS CLI installed (`aws configure`)
- SSH keypair named `terraform_key`
- Route53 domain access

## Deployment

### Initialize
```
terraform init
```

### Plan infrastructure
```
terraform plan
```

### Apply infrastructure
```
terraform apply
```

### Destroy infrastructure
```
terraform destroy
```

## Access Instructions

### Bastion Host
```
ssh -i terraform_key.pem ubuntu@<bastion_public_ip>
```

### Private EC2 (via Bastion)
```
ssh ec2-user@<private_ec2_ip>
```

### Application Endpoint
```
http://api.insung-terraform.com
https://api.insung-terraform.com
```

## Future Enhancements
- Multi-VPC + Transit Gateway
- WAF integration
- CloudFront CDN
- ECS Fargate or EKS migration
- Centralized logging (OpenSearch)
- Terraform backend (S3 + DynamoDB)
- GitHub Actions CI/CD
