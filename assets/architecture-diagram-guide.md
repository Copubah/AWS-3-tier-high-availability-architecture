# Architecture Diagram Creation Guide

## Diagram Elements for draw.io or Lucidchart

### AWS Region Container
- Large rectangle labeled "AWS Region (us-east-1)"
- Background color: Light blue (#E8F4FD)

### VPC Container
- Rectangle inside region labeled "VPC (10.0.0.0/16)"
- Background color: Light green (#E8F5E8)

### Availability Zones
Create 3 columns for AZs:

#### AZ-1a (Left Column)
- Rectangle labeled "us-east-1a"
- Contains:
  - Public Subnet (10.0.1.0/24) - Light orange background
    - Bastion Host (EC2)
    - Web Server (EC2)
    - NAT Gateway
  - Private Subnet (10.0.2.0/24) - Light gray background
    - App Server (EC2)

#### AZ-1b (Middle Column)
- Rectangle labeled "us-east-1b"
- Contains:
  - Private Subnet (10.0.3.0/24) - Light gray background
    - RDS Primary (if Multi-AZ enabled)

#### AZ-1c (Right Column)
- Rectangle labeled "us-east-1c"
- Contains:
  - Private Subnet (10.0.4.0/24) - Light gray background
    - RDS Standby (if Multi-AZ enabled)

### Network Components
- Internet Gateway (outside VPC, connected to public subnets)
- Route Tables:
  - Public Route Table (connected to public subnets)
  - Private Route Tables (connected to private subnets)

### Security Groups (show as shields/locks)
- Bastion SG (Port 22 from 0.0.0.0/0)
- Web SG (Port 80/443 from 0.0.0.0/0, Port 22 from Bastion SG)
- App SG (Port 8080 from Web SG, Port 22 from Bastion SG)
- DB SG (Port 3306 from App SG)

### Traffic Flow Arrows
- Internet → IGW → Public Subnets
- Public Subnets → NAT Gateway → Private Subnets
- User → Web Server → App Server → Database
- Admin → Bastion → Private Resources

### Icons to Use
- AWS Cloud icon for region
- VPC icon for VPC
- EC2 instances for servers
- RDS icon for database
- Shield icons for security groups
- Router icon for route tables
- Gateway icons for IGW and NAT

### Color Coding
- Public resources: Orange/Yellow
- Private resources: Gray/Blue
- Database: Purple
- Security: Red shields
- Network: Green lines

## Diagram Creation Steps

1. Open draw.io or Lucidchart
2. Start with AWS architecture template
3. Create the region container first
4. Add VPC container inside region
5. Create 3 AZ columns
6. Add subnets to each AZ
7. Place EC2 instances and RDS
8. Add network components (IGW, NAT, Route Tables)
9. Add security group representations
10. Draw traffic flow arrows
11. Add labels and IP ranges
12. Use consistent colors and styling
13. Export as PNG with high resolution (300 DPI)

## File Naming
Save the diagram as: `aws-3tier-architecture-detailed.png`