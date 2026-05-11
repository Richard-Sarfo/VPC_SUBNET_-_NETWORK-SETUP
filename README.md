# Lab 1.2 — Data Platform VPC (Terraform)

Terraform implementation of Lab 1.2: a production-style VPC for a
data engineering platform, with public/private subnet separation,
NAT egress, tiered security groups, and cost-saving VPC endpoints.

## Architecture

```
VPC: data-platform-vpc (10.0.0.0/16)
│
├─ public-subnet-1a  (10.0.1.0/24, us-east-1a) ── NAT Gateway, IGW route
├─ private-subnet-1a (10.0.2.0/24, us-east-1a) ── Database tier
└─ private-subnet-1b (10.0.3.0/24, us-east-1b) ── Compute tier (EC2 / Lambda / Glue)

Gateways
├─ Internet Gateway (data-platform-igw)
└─ NAT Gateway       (data-platform-nat) + Elastic IP

Route Tables
├─ public-route-table  : 0.0.0.0/0 → IGW         (public-subnet-1a)
└─ private-route-table : 0.0.0.0/0 → NAT Gateway (both private subnets)

Security Groups (deny-by-default)
├─ sg-public-nat        : HTTPS/443 in from 0.0.0.0/0
├─ sg-private-compute   : all traffic from itself + sg-public-nat
└─ sg-private-db        : MySQL/3306 + PostgreSQL/5432 from sg-private-compute

VPC Endpoints
├─ S3 Gateway              (free, attached to private RT)
├─ DynamoDB Gateway        (free, attached to private RT)
└─ Secrets Manager Interface (both private subnets, sg-private-compute)
```

## File layout

| File                  | Purpose                                              |
|-----------------------|------------------------------------------------------|
| `main.tf`             | Terraform & AWS provider config, default tags        |
| `variables.tf`        | Region, CIDRs, AZs, project name                     |
| `vpc.tf`              | VPC, 3 subnets, Internet Gateway                     |
| `nat_gateway.tf`      | Elastic IP + NAT Gateway                             |
| `route_tables.tf`     | Public/private route tables and associations         |
| `security_groups.tf`  | Three tiered security groups                         |
| `vpc_endpoints.tf`    | S3, DynamoDB (Gateway) + Secrets Manager (Interface) |
| `outputs.tf`          | Exported IDs for downstream labs                     |

## Usage

```bash
terraform init
terraform plan
terraform apply
```

Region defaults to `us-east-1`. Override via:

```bash
terraform apply -var="aws_region=us-east-2"
```

### Required AWS permissions

The credentials used must allow create/describe/delete on:
`ec2:*Vpc*`, `ec2:*Subnet*`, `ec2:*Gateway*`, `ec2:*RouteTable*`,
`ec2:*SecurityGroup*`, `ec2:*Address*`, `ec2:*VpcEndpoint*`.

## Cost note

The NAT Gateway is the one paid component (~$0.045/hr + $0.045/GB
processed in us-east-1, roughly $32/month idle). When the lab is
not actively running, destroy with:

```bash
terraform destroy -target=aws_nat_gateway.main -target=aws_eip.nat
```

The rest of the resources (VPC, subnets, IGW, route tables,
security groups, Gateway endpoints) are free. Re-apply to restore
egress before the next lab session.

## Outputs

Run `terraform output` after apply to print the IDs you will need
in subsequent labs (S3 datalake, RDS, Glue, etc.).
