# 🏗️ AWS 3-Tier High Availability Architecture

- This project demonstrates how to design and configure a **highly available 3-tier architecture on AWS**, leveraging services like EC2, Elastic Load Balancers, Auto Scaling Groups, and RDS across multiple Availability Zones (AZs).



##  Architecture Overview

The infrastructure is broken down into three main tiers:

## 1️⃣ Presentation Tier (User Interface)
- Amazon Route 53- DNS management and health checks
- Application Load Balancer (ALB) Public-facing
- EC2 Auto Scaling Group** – Web servers (e.g., NGINX/Apache)
- Deployed in 2+ Availability Zones**

## 2️⃣ Application Tier (Business Logic)
- Private EC2 Instances or Containers
- Internal ALB** – Load balances app layer traffic
- Auto Scaling Group** for backend services

## 3️⃣ Data Tier (Persistence)
- Amazon RDS (Multi-AZ) – Relational database
- Optional: **Amazon DynamoDB** for NoSQL
- Optional: **Amazon ElastiCache** for caching

---

##  Technologies Used

- AWS EC2
- AWS Auto Scaling Groups
- AWS Load Balancers (ALB)
- Amazon RDS (PostgreSQL or MySQL)
- Amazon Route 53
- Amazon VPC & Subnets (2+ AZs)
- (Optional) Terraform or AWS CloudFormation



## Architecture Diagram
![AWS 3-Tier](https://awsrestart.instructure.com/courses/3629/files/408579/download?download_frd=1)


