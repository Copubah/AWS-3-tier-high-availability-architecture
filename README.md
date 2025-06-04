# AWS 3-Tier High Availability Architecture

- This project demonstrates how to design and configure a **highly available 3-tier architecture on AWS**, leveraging services like EC2, Elastic Load Balancers, Auto Scaling Groups, and RDS across multiple Availability Zones (AZs).

##  Architecture Overview
The infrastructure is broken down into three main tiers:

1. Presentation Tier (User Interface)
  ## Purpose: Accepts user traffic, handles UI/UX, routes requests.
- Amazon Route 53- DNS management and health checks
- Application Load Balancer (ALB) Public-facing
- EC2 Auto Scaling Group** – Web servers (e.g., NGINX/Apache)
- Deployed in 2+ Availability Zones

2. Application Tier (Business Logic)
 ## Purpose: Hosts business logic (e.g., Node.js, Python, Java).
- Private EC2 Instances or Containers
- Internal ALB** – Load balances app layer traffic
- Auto Scaling Group** for backend services

3. Data Tier (Persistence)
## Purpose: Stores and manages persistent data.
- Amazon RDS (Multi-AZ) – Relational database



##  Technologies Used

- AWS EC2
- AWS Auto Scaling Groups
- AWS Load Balancers (ALB)
- Amazon RDS (PostgreSQL or MySQL)
- Amazon Route 53
- Amazon VPC & Subnets (2+ AZs)
- (Optional) Terraform or AWS CloudFormation



## Architecture Diagram
![AWS 3-Tier](./assets/Tier3Topology.png)


