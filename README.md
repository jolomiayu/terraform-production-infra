# Terraform Production Infrastructure

Production-style AWS infrastructure deployed with Terraform.

## Project Overview

This project provisions a highly available web application environment on AWS using:

- Terraform
- VPC
- Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- EC2 Instances
- PostgreSQL RDS
- Docker
- GitHub
- CI/CD Deployment

## Architecture

- Application Load Balancer
- Auto Scaling Group (2 Desired / 2 Minimum / 2 Maximum)
- Multiple EC2 instances
- PostgreSQL RDS Database
- Dockerized Frontend and Backend
- GitHub Source Control

## Screenshots

### Load Balancer

![Load Balancer](screenshots/Load-balancer.png)

### Target Group

![Target Group](screenshots/Target-group.png)

### Auto Scaling Group

![Auto Scaling Group](screenshots/Auto-scaling-group.png)

### EC2 Instances

![EC2 Instances](screenshots/ec2-instances.png)

### RDS PostgreSQL

![RDS](screenshots/RDS-instance.png)

### Successful Booking Test

![Booking Success](screenshots/successful-booking.png)

### GitHub Repository

![GitHub](screenshots/Github.png)

## Key Achievements

- Built AWS infrastructure using Terraform modules
- Implemented Application Load Balancer
- Configured Auto Scaling Group
- Deployed Dockerized application
- Migrated database to PostgreSQL RDS
- Connected application successfully to RDS
- Implemented GitHub version control
- Tested successful booking workflow

## Author

Jolomi Ayu
