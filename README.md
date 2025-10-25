# AWS 3-Tier High Availability Architecture

This Terraform project provisions a production-ready 3-tier architecture on AWS using modular design and best practices.

## Architecture Overview

This infrastructure includes:
- Presentation Tier: Web servers in public subnets with load balancing capability
- Application Tier: Application servers in private subnets
- Data Tier: RDS MariaDB in private subnets with Multi-AZ support
- Management: Bastion host for secure access to private resources

### Key Features
- Modular Terraform design for reusability and maintainability
- Multi-AZ deployment for high availability
- Security groups with least privilege access
- Encrypted storage and secure database configuration
- Cost-optimized NAT Gateway setup
- Comprehensive tagging strategy
- Environment-specific configurations

## Architecture Diagram

![AWS 3-Tier Architecture](./assets/Tier3Topology.png)

### Creating Your Own Diagram

You can create a detailed architecture diagram using:

1. **draw.io (Recommended)**
   - Import the provided template: [aws-3tier-architecture.drawio](./assets/aws-3tier-architecture.drawio)
   - Follow the detailed guide: [Architecture Diagram Guide](./assets/architecture-diagram-guide.md)

2. **Lucidchart**
   - Use the AWS architecture template
   - Follow the component layout in the diagram guide

3. **AWS Architecture Icons**
   - Download official AWS icons from [AWS Architecture Center](https://aws.amazon.com/architecture/icons/)
   - Use consistent colors and styling as outlined in the guide

### Architecture Components

The diagram shows the complete 3-tier architecture with:
- Internet Gateway for public internet access
- Public subnets hosting web servers and bastion host
- Private subnets for application servers and database
- NAT Gateway for outbound internet access from private subnets
- Security groups controlling traffic between tiers
- Multi-AZ deployment for high availability

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- AWS CLI configured with appropriate permissions
- An existing EC2 key pair in your target region

### Required AWS Permissions
Your AWS credentials need permissions for:
- VPC, Subnet, Route Table, Internet Gateway, NAT Gateway
- EC2 instances, Security Groups, Key Pairs
- RDS instances, DB Subnet Groups, Parameter Groups
- IAM roles and policies (for RDS monitoring)

## Project Structure

```
├── main.tf                    # Main configuration using modules
├── variables.tf               # Input variable definitions
├── outputs.tf                 # Output value definitions
├── versions.tf                # Provider version constraints
├── terraform.tfvars.example   # Example variable values
├── .gitignore                 # Git ignore patterns
├── README.md                  # This file
├── assets/                    # Architecture diagrams and guides
│   ├── Tier3Topology.png      # Current architecture diagram
│   ├── aws-3tier-architecture.drawio  # draw.io diagram template
│   └── architecture-diagram-guide.md  # Detailed diagram creation guide
├── docs/                      # Additional documentation
│   ├── cost-optimization.md   # Comprehensive cost optimization guide
│   └── cost-calculator.md     # Cost breakdown and calculation tools
└── modules/
    ├── networking/            # VPC, subnets, routing
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security/              # Security groups
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── compute/               # EC2 instances
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── user_data/         # Instance initialization scripts
    │       ├── bastion.sh
    │       ├── web_server.sh
    │       └── app_server.sh
    └── database/              # RDS configuration
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Quick Start

1. Clone and Setup
   ```bash
   git clone https://github.com/Copubah/AWS-3-tier-high-availability-architecture
   cd AWS-3-tier-high-availability-architecture
   ```

2. Configure Variables
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your specific values
   ```

3. Initialize and Plan
   ```bash
   terraform init
   terraform plan
   ```

4. Deploy Infrastructure
   ```bash
   terraform apply
   ```

## Configuration

### Required Variables

Edit `terraform.tfvars` with your specific values:

```hcl
# Essential Configuration
key_name     = "your-existing-key-pair"
db_password  = "YourSecurePassword123!"

# Optional: Restrict SSH access
allowed_ssh_cidrs = ["YOUR.IP.ADDRESS/32"]
```

### Environment-Specific Deployments

For different environments, create separate tfvars files:

```bash
# Development
terraform apply -var-file="dev.tfvars"

# Staging  
terraform apply -var-file="staging.tfvars"

# Production
terraform apply -var-file="prod.tfvars"
```

## Security Best Practices

- Network Isolation: Private subnets for app and database tiers
- Access Control: Security groups with minimal required access
- Encryption: RDS storage encryption enabled
- Monitoring: Enhanced RDS monitoring configured
- Backup: Automated database backups with configurable retention
- SSH Access: Bastion host pattern for secure private resource access

## Outputs

After deployment, you'll receive:

```
vpc_id                = "vpc-xxxxxxxxx"
bastion_public_ip     = "x.x.x.x"
web_public_ip         = "x.x.x.x"
web_url               = "http://x.x.x.x"
rds_endpoint          = "database.xxxxxxxxx.region.rds.amazonaws.com:3306"
ssh_bastion_command   = "ssh -i your-key.pem ec2-user@x.x.x.x"
```

## Access Instructions

### SSH to Bastion Host
```bash
ssh -i your-key.pem ec2-user@<bastion-public-ip>
```

### Access Private Servers via Bastion
```bash
# From bastion, connect to app server
ssh -i your-key.pem ec2-user@<app-private-ip>

# Or use SSH tunneling
ssh -i your-key.pem -J ec2-user@<bastion-ip> ec2-user@<app-private-ip>
```

### Database Connection
```bash
# From app server
mysql -h <rds-endpoint> -u admin -p
```

## Cost Optimization

This architecture is designed with cost optimization in mind:

### Current Cost Structure
- Development Environment: ~$70/month
- Production Environment: ~$214/month

### Key Cost Optimizations Implemented
- Single NAT Gateway for development (can be expanded for HA in production)
- Burstable t3.micro instances (right-sized for workload)
- GP2 storage with auto-scaling enabled
- Environment-specific backup retention policies
- Comprehensive resource tagging for cost allocation

### Additional Cost Savings Opportunities
- Switch to Spot Instances for development (70% savings)
- Use NAT Instance instead of NAT Gateway (94% savings)
- Implement Reserved Instances for production (40% savings)
- Upgrade to GP3 storage for better price/performance (20% savings)
- Automated resource scheduling for non-production environments

### Potential Annual Savings
With full optimization implementation:
- Development: Up to 80% cost reduction
- Production: Up to 35% cost reduction
- Total potential annual savings: ~$2,200

For detailed cost optimization strategies, see [Cost Optimization Guide](./docs/cost-optimization.md).

For specific cost calculations and scenarios, see [Cost Calculator](./docs/cost-calculator.md).

## Scaling Considerations

This architecture supports:
- Horizontal Scaling: Add Auto Scaling Groups to compute module
- Load Balancing: Add Application Load Balancer to web tier
- Database Scaling: Enable Multi-AZ, add read replicas
- Multi-Region: Deploy modules in multiple regions

## Cleanup

```bash
terraform destroy
```

Warning: This will delete all resources. Ensure you have backups of any important data.

## Module Development

Each module is self-contained and can be:
- Versioned independently
- Tested separately  
- Reused across projects
- Published to Terraform Registry

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - see LICENSE file for details






