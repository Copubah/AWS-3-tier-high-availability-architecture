# AWS 3-Tier Architecture Cost Calculator

## Monthly Cost Breakdown by Environment

### Development Environment

| Service | Resource | Quantity | Unit Cost | Monthly Cost |
|---------|----------|----------|-----------|--------------|
| EC2 | t3.micro instances | 3 | $5.00 | $15.00 |
| RDS | db.t3.micro | 1 | $12.00 | $12.00 |
| NAT Gateway | Standard | 1 | $32.00 | $32.00 |
| EBS | GP2 20GB | 3 | $2.00 | $6.00 |
| Data Transfer | Outbound | - | - | $5.00 |
| Total Development | | | | $70.00 |

### Staging Environment

| Service | Resource | Quantity | Unit Cost | Monthly Cost |
|---------|----------|----------|-----------|--------------|
| EC2 | t3.small instances | 3 | $15.00 | $45.00 |
| RDS | db.t3.small | 1 | $25.00 | $25.00 |
| NAT Gateway | Standard | 1 | $32.00 | $32.00 |
| EBS | GP3 40GB | 3 | $3.20 | $9.60 |
| Data Transfer | Outbound | - | - | $8.00 |
| Total Staging | | | | $119.60 |

### Production Environment

| Service | Resource | Quantity | Unit Cost | Monthly Cost |
|---------|----------|----------|-----------|--------------|
| EC2 | t3.medium instances | 3 | $30.00 | $90.00 |
| RDS | db.t3.small Multi-AZ | 1 | $50.00 | $50.00 |
| ALB | Application Load Balancer | 1 | $20.00 | $20.00 |
| NAT Gateway | Standard (2 AZ) | 2 | $32.00 | $64.00 |
| EBS | GP3 100GB | 3 | $8.00 | $24.00 |
| Data Transfer | Outbound | - | - | $15.00 |
| Total Production | | | | $263.00 |

## Cost Optimization Scenarios

### Scenario 1: Basic Optimizations

| Optimization | Dev Savings | Prod Savings | Annual Savings |
|--------------|-------------|--------------|----------------|
| GP3 Storage | $1.20 | $4.80 | $72 |
| Right-sizing | $5.00 | $15.00 | $240 |
| Reserved Instances | - | $36.00 | $432 |
| Total | $6.20 | $55.80 | $744 |

### Scenario 2: Aggressive Optimizations

| Optimization | Dev Savings | Prod Savings | Annual Savings |
|--------------|-------------|--------------|----------------|
| Spot Instances (Dev) | $10.50 | - | $126 |
| NAT Instance | $29.00 | $32.00 | $732 |
| Reserved Instances | - | $36.00 | $432 |
| Auto Scaling | - | $27.00 | $324 |
| Resource Scheduling | $21.00 | $26.30 | $568 |
| Total | $60.50 | $121.30 | $2,182 |

## Cost Calculator Formula

### Base Monthly Cost
```
Base Cost = (EC2 Instances × Instance Cost) + 
           (RDS Cost) + 
           (NAT Gateway Cost) + 
           (Storage Cost) + 
           (Data Transfer Cost)
```

### With Optimizations
```
Optimized Cost = Base Cost × (1 - Optimization Percentage)
```

### Annual Calculation
```
Annual Cost = Monthly Cost × 12
Annual Savings = (Base Annual Cost - Optimized Annual Cost)
```

## Regional Cost Variations

### US Regions (Monthly costs for t3.micro)

| Region | EC2 Cost | RDS Cost | NAT Gateway | Total Impact |
|--------|----------|----------|-------------|--------------|
| us-east-1 | $5.00 | $12.00 | $32.00 | Baseline |
| us-west-2 | $5.00 | $12.00 | $32.00 | +0% |
| eu-west-1 | $5.50 | $13.20 | $35.20 | +10% |
| ap-southeast-1 | $6.00 | $14.40 | $38.40 | +20% |

## Cost Monitoring Thresholds

### Recommended Budget Alerts

| Environment | Monthly Budget | Alert Threshold | Action Threshold |
|-------------|----------------|-----------------|------------------|
| Development | $80 | $60 (75%) | $70 (87.5%) |
| Staging | $130 | $100 (77%) | $115 (88%) |
| Production | $280 | $210 (75%) | $245 (87.5%) |

### Cost Per User Metrics

| Environment | Users | Cost/User/Month | Target Cost/User |
|-------------|-------|-----------------|------------------|
| Development | 5 | $14.00 | $10.00 |
| Staging | 20 | $6.00 | $4.50 |
| Production | 1000 | $0.26 | $0.20 |

## Quick Cost Estimation Tool

### Input Parameters
- Environment Type: [Dev/Staging/Prod]
- Instance Type: [t3.micro/t3.small/t3.medium]
- Multi-AZ RDS: [Yes/No]
- Number of AZs: [1/2/3]
- Storage Size (GB): [20/50/100/200]

### Calculation Steps
1. Select base instance costs from table above
2. Add RDS costs (double for Multi-AZ)
3. Add NAT Gateway costs (multiply by number of AZs)
4. Add storage costs (GB × $0.10 for GP2, GB × $0.08 for GP3)
5. Add 10% for data transfer and miscellaneous

### Example Calculation (Development)
```
EC2 (3 × t3.micro): 3 × $5.00 = $15.00
RDS (db.t3.micro): $12.00
NAT Gateway (1): $32.00
Storage (60GB GP2): 60 × $0.10 = $6.00
Data Transfer (10%): ($15.00 + $12.00 + $32.00 + $6.00) × 0.10 = $6.50
Total: $71.50/month
```

## Cost Optimization ROI

### Investment vs. Savings

| Optimization | Implementation Cost | Monthly Savings | Break-even (Months) |
|--------------|-------------------|-----------------|-------------------|
| Reserved Instances | $0 | $36.00 | 0 |
| NAT Instance Setup | $50 | $29.00 | 1.7 |
| Auto Scaling Config | $200 | $27.00 | 7.4 |
| Monitoring Setup | $100 | $15.00 | 6.7 |

### 3-Year Total Cost of Ownership

| Scenario | Year 1 | Year 2 | Year 3 | Total |
|----------|--------|--------|--------|-------|
| No Optimization | $3,156 | $3,156 | $3,156 | $9,468 |
| Basic Optimization | $2,412 | $2,412 | $2,412 | $7,236 |
| Full Optimization | $1,974 | $1,974 | $1,974 | $5,922 |
| Total Savings | | | | $3,546 |