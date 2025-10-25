# AWS 3-Tier Architecture Cost Optimization Guide

## Overview

This document provides detailed cost optimization strategies for the AWS 3-tier architecture, including current costs, optimization techniques, and monitoring recommendations.

## Current Architecture Costs (Monthly Estimates)

### Development Environment
- **EC2 Instances (3x t3.micro)**: ~$15.00/month
  - Bastion Host: ~$5.00
  - Web Server: ~$5.00
  - App Server: ~$5.00
- **RDS (db.t3.micro)**: ~$12.00/month
- **NAT Gateway**: ~$32.00/month (biggest cost component)
- **EBS Storage (60GB total)**: ~$6.00/month
- **Data Transfer**: ~$5.00/month
- **Total Development**: ~$70.00/month

### Production Environment (Estimated)
- **EC2 Instances (3x t3.small + Auto Scaling)**: ~$45.00/month
- **RDS (db.t3.small + Multi-AZ)**: ~$50.00/month
- **Application Load Balancer**: ~$20.00/month
- **NAT Gateway (2x for HA)**: ~$64.00/month
- **EBS Storage (200GB total)**: ~$20.00/month
- **Data Transfer**: ~$15.00/month
- **Total Production**: ~$214.00/month

## Cost Optimization Strategies

### 1. Compute Optimization

#### Instance Right-Sizing
```hcl
# Use burstable instances for variable workloads
variable "instance_types" {
  description = "Instance types by environment"
  type        = map(string)
  default = {
    dev     = "t3.micro"    # $5/month
    staging = "t3.small"    # $15/month
    prod    = "t3.medium"   # $30/month
  }
}
```

#### Spot Instances for Development
```hcl
# Add to compute module for dev environment
resource "aws_spot_instance_request" "web_spot" {
  count = var.environment == "dev" ? 1 : 0
  
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  spot_price            = "0.01"  # 70% savings
  wait_for_fulfillment  = true
  
  # Same configuration as regular instance
}
```

#### Reserved Instances for Production
- **1-year term**: 40% savings
- **3-year term**: 60% savings
- **Convertible RIs**: Flexibility to change instance types

### 2. Network Cost Optimization

#### NAT Gateway Alternatives

**Option 1: Single NAT Gateway (Current Implementation)**
- Cost: $32/month
- Trade-off: Single point of failure
- Best for: Development environments

**Option 2: NAT Instance (Cheapest)**
```hcl
# Replace NAT Gateway with NAT Instance
resource "aws_instance" "nat" {
  ami                    = "ami-00a9d4a05375b2763"  # NAT AMI
  instance_type          = "t3.nano"
  subnet_id              = aws_subnet.public[0].id
  source_dest_check      = false
  
  tags = {
    Name = "NAT Instance"
  }
}
```
- Cost: ~$3/month (94% savings)
- Trade-off: Manual management, lower throughput

**Option 3: VPC Endpoints**
```hcl
# Add VPC endpoints for AWS services
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  
  tags = {
    Name = "S3 VPC Endpoint"
  }
}
```
- Eliminates NAT Gateway traffic for AWS services
- Cost: $0.01 per GB processed

### 3. Database Cost Optimization

#### Storage Optimization
```hcl
# Use GP3 instead of GP2 for better price/performance
resource "aws_db_instance" "main" {
  storage_type          = "gp3"
  allocated_storage     = 20
  max_allocated_storage = 100  # Auto-scaling
  
  # Performance settings for GP3
  iops                  = 3000
  storage_throughput    = 125
}
```

#### Backup Optimization
```hcl
# Optimize backup retention by environment
variable "backup_retention_days" {
  type = map(number)
  default = {
    dev     = 1   # Minimum for dev
    staging = 7   # Standard for staging
    prod    = 30  # Extended for production
  }
}
```

#### Read Replicas for Read-Heavy Workloads
```hcl
resource "aws_db_instance" "read_replica" {
  count = var.environment == "prod" ? 1 : 0
  
  replicate_source_db = aws_db_instance.main.id
  instance_class      = "db.t3.micro"  # Smaller for read-only
  publicly_accessible = false
}
```

### 4. Storage Cost Optimization

#### EBS Volume Optimization
```hcl
# Use GP3 volumes for better cost/performance
resource "aws_ebs_volume" "app_data" {
  availability_zone = var.availability_zones[0]
  size              = 20
  type              = "gp3"
  
  # GP3 specific settings
  iops       = 3000
  throughput = 125
  
  tags = {
    Name = "App Data Volume"
  }
}
```

#### Lifecycle Policies
```hcl
# Implement EBS snapshot lifecycle
resource "aws_dlm_lifecycle_policy" "ebs_backup" {
  description        = "EBS snapshot lifecycle policy"
  execution_role_arn = aws_iam_role.dlm_lifecycle_role.arn
  state              = "ENABLED"

  policy_details {
    resource_types   = ["VOLUME"]
    target_tags = {
      Backup = "true"
    }

    schedule {
      name = "Daily snapshots"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["23:45"]
      }

      retain_rule {
        count = var.environment == "prod" ? 30 : 7
      }
    }
  }
}
```

### 5. Monitoring and Alerting for Cost Control

#### CloudWatch Billing Alarms
```hcl
resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name          = "billing-alarm-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "86400"
  statistic           = "Maximum"
  threshold           = var.billing_threshold
  alarm_description   = "This metric monitors estimated charges"
  alarm_actions       = [aws_sns_topic.billing_alerts.arn]

  dimensions = {
    Currency = "USD"
  }
}
```

#### Cost Allocation Tags
```hcl
locals {
  cost_tags = {
    Environment   = var.environment
    Project      = var.project_name
    Owner        = var.owner
    CostCenter   = var.cost_center
    Application  = "three-tier-web-app"
  }
}
```

## Environment-Specific Cost Strategies

### Development Environment
- Use t3.micro instances
- Single NAT Gateway
- Minimal RDS instance (db.t3.micro)
- 1-day backup retention
- No Multi-AZ deployment
- **Target Cost**: $50-70/month

### Staging Environment
- Use t3.small instances
- Single NAT Gateway
- Standard RDS instance (db.t3.small)
- 7-day backup retention
- No Multi-AZ deployment
- **Target Cost**: $100-130/month

### Production Environment
- Use Reserved Instances for predictable workloads
- Implement Auto Scaling
- Multi-AZ RDS deployment
- Read replicas for performance
- 30-day backup retention
- **Target Cost**: $180-250/month

## Cost Monitoring Tools

### AWS Cost Explorer
- Set up monthly cost reports
- Create cost allocation tags
- Monitor cost trends by service

### AWS Budgets
```hcl
resource "aws_budgets_budget" "monthly_budget" {
  name         = "${var.project_name}-${var.environment}-monthly"
  budget_type  = "COST"
  limit_amount = var.monthly_budget_limit
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_filters = {
    Tag = ["Project:${var.project_name}"]
  }
}
```

### Third-Party Tools
- **CloudHealth**: Advanced cost optimization
- **Cloudability**: Cost analytics and recommendations
- **ParkMyCloud**: Automated resource scheduling

## Automated Cost Optimization

### Resource Scheduling
```bash
# Lambda function to stop/start instances
# Schedule via CloudWatch Events
# Stop dev instances at 6 PM, start at 8 AM
# Potential savings: 60% on compute costs
```

### Auto Scaling Configuration
```hcl
resource "aws_autoscaling_group" "web_asg" {
  name                = "${local.name_prefix}-web-asg"
  vpc_zone_identifier = module.networking.public_subnet_ids
  target_group_arns   = [aws_lb_target_group.web.arn]
  
  min_size         = var.environment == "prod" ? 2 : 1
  max_size         = var.environment == "prod" ? 6 : 2
  desired_capacity = var.environment == "prod" ? 2 : 1
  
  # Scale based on CPU utilization
  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-web-server"
    propagate_at_launch = true
  }
}
```

## Cost Optimization Checklist

### Monthly Reviews
- [ ] Review AWS Cost Explorer reports
- [ ] Analyze unused or underutilized resources
- [ ] Check for zombie resources (unattached EBS volumes, unused EIPs)
- [ ] Review Reserved Instance utilization
- [ ] Optimize data transfer costs

### Quarterly Reviews
- [ ] Evaluate Reserved Instance purchases
- [ ] Review instance right-sizing recommendations
- [ ] Assess storage class optimizations
- [ ] Update cost allocation tags
- [ ] Review backup and retention policies

### Annual Reviews
- [ ] Comprehensive architecture review
- [ ] Evaluate new AWS services for cost savings
- [ ] Review multi-year Reserved Instance commitments
- [ ] Assess disaster recovery costs vs. benefits

## Expected Savings Summary

| Optimization | Development | Production | Annual Savings |
|--------------|-------------|------------|----------------|
| Spot Instances | 70% | N/A | $300 |
| NAT Instance | 94% | 50% | $600 |
| Reserved Instances | N/A | 40% | $800 |
| GP3 Storage | 20% | 20% | $100 |
| Resource Scheduling | 60% | 30% | $400 |
| **Total Potential** | **80%** | **35%** | **$2,200** |

## Implementation Priority

1. **High Impact, Low Effort**
   - Switch to GP3 storage
   - Implement resource tagging
   - Set up billing alarms

2. **High Impact, Medium Effort**
   - Replace NAT Gateway with NAT Instance (dev)
   - Implement Auto Scaling
   - Purchase Reserved Instances (prod)

3. **Medium Impact, High Effort**
   - Implement comprehensive monitoring
   - Set up automated resource scheduling
   - Optimize data transfer patterns