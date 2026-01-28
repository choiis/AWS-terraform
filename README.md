
# AWS Terraform Infrastructure

This repository contains a fully automated, production-ready AWS infrastructure built using Terraform.
It includes VPC networking, subnets, NAT gateways, bastion host, application servers, Network Load Balancer (NLB), Route53 DNS, ACM TLS certificates, RDS MySQL, Auto Scaling Group (ASG), S3 static hosting, CloudFront CDN, CloudWatch monitoring and more.

## Architecture Overview

The Terraform code provisions:

### Networking
- 1 VPC (10.10.0.0/16)
- Public subnets (2개 AZ: ap-northeast-2b, 2c)
- Private subnet (1개 AZ)
- Internet Gateway
- NAT Gateway with Elastic IP
- Route tables and routing configuration
- Security groups for public, private, database layers
- Network ACLs for additional security

### Compute
- Bastion host (public subnet) - Ubuntu
- AWS Linux Server (private subnet)
- RedHat Server (private subnet)
- Auto Scaling Group (private subnet)
  - Launch Template based instances
  - Min 1, Max 3
  - CPU-based scale-in/scale-out

### Load Balancing
- Network Load Balancer (NLB)
  - Listener ports: 80/TCP, 443/TLS, 8080/TCP
- Target Group automatically populated by ASG instances

### Domain & TLS
- Hosted Zone via Route53 (insung-terraform.com)
- ALIAS record (api.insung-terraform.com) → NLB
- ACM certificate with DNS validation
- TLS termination on NLB (port 443)

### Database
- RDS MySQL 8.0 (db.t3.micro)
  - 8GB allocated storage
  - Automatic backup enabled (7 days retention)
  - Backup window: 03:00-04:00 UTC

### Caching
- ElastiCache Redis 7.1 (cache.t3.micro)
  - Single node cluster
  - Port 6379
  - Deployed in VPC subnet group

### Static Storage + CDN
- S3 Bucket (private, CloudFront OAC access only)
- CloudFront CDN with Origin Access Control
- Price Class: PriceClass_200 (North America, Europe, Asia)

### Monitoring
- CloudWatch Log Group (14 days retention)
- CPU High/Low Alarms for Auto Scaling

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
│            (10.10.0.0/16)                  │
│   ┌───────────────────────────┐            │
│   │     Public Subnets        │            │
│   │  - Bastion Host           │            │
│   │  - NAT Gateway            │            │
│   │  - NLB                    │            │
│   └───────────────────────────┘            │
│   ┌───────────────────────────┐            │
│   │     Private Subnets       │            │
│   │  - ASG Auto EC2 (1~3)     │            │
│   │  - AWS Linux Server       │            │
│   │  - RedHat Server          │            │
│   └───────────────────────────┘            │
│   ┌───────────────────────────┐            │
│   │     Database & Cache      │            │
│   │  - RDS MySQL 8.0          │            │
│   │  - ElastiCache Redis 7.1  │            │
│   └───────────────────────────┘            │
└────────────────────────────────────────────┘

CloudFront CDN ──► S3 Bucket (Static Content)
```

## Architecture Diagram (draw.io)
![AWS](http://imageresizer-dev-serverlessdeploymentbucket-xapz1q6q9exe.s3-website-ap-northeast-1.amazonaws.com/gitpng/aws_diagram_v6.PNG)

## Repository Structure

```
AWS-terraform/
├── aws-provider.tf          # AWS provider configuration
├── vpc.tf                   # VPC configuration
├── public_subnet-gateway.tf # Public subnets & Internet Gateway
├── private_subnet-gateway.tf# Private subnets & NAT Gateway
├── security_group.tf        # Security groups
├── security_group_ACL.tf    # Network ACLs
├── instance.tf              # EC2 instances (Bastion, Linux, RedHat)
├── launch_template.tf       # Launch template for ASG
├── autoscaling.tf           # Auto Scaling Group & policies
├── nlb.tf                   # Network Load Balancer
├── route53.tf               # Route53 DNS configuration
├── acm.tf                   # ACM TLS certificate
├── database.tf              # RDS MySQL database
├── redis.tf                 # ElastiCache Redis cluster
├── s3.tf                    # S3 bucket for static content
├── cloudfront.tf            # CloudFront CDN distribution
└── cloudwatch.tf            # CloudWatch logs & alarms
```

## Auto Scaling Behavior

| Condition | Action |
|----------|--------|
| CPU ≥ 40% | Scale-Out (+1 instance) |
| CPU ≤ 20% | Scale-In (–1 instance) |
| Min Size | Always 1 |
| Max Size | Up to 3 |
| Cooldown | 60 seconds |

## RDS Backup Configuration

| Setting | Value |
|---------|-------|
| Retention Period | 7 days |
| Backup Window | 03:00-04:00 UTC |
| Delete on Termination | No (backups preserved) |

## ElastiCache Redis Configuration

| Setting | Value |
|---------|-------|
| Engine | Redis 7.1 |
| Node Type | cache.t3.micro |
| Number of Nodes | 1 |
| Port | 6379 |
| Parameter Group | default.redis7 |

## Security Configuration

### Security Groups
- **Public**: Web traffic (HTTP/HTTPS)
- **Private**: Internal application traffic
- **Database**: Restricted access (specific IP only)

### Network ACLs
- **Public ACL**: Allow 80, 443, 22, ephemeral ports
- **Private ACL**: VPC internal + NAT response traffic

## Requirements

- Terraform 1.6+
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
- ElastiCache Redis Cluster Mode for high availability
- Multi-VPC + Transit Gateway
- WAF integration
- ECS Fargate or EKS migration
- Centralized logging (OpenSearch)
- Terraform backend (S3 + DynamoDB)
- GitHub Actions CI/CD
- AWS Secrets Manager for credentials
- VPC Endpoints for cost optimization
