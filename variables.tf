variable "aws_region" {
  description = "AWS region where networking resources are created"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix used for resource tags and names"
  type        = string
  default     = "data-platform"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (65,536 addresses)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet hosting the NAT Gateway"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_1a_cidr" {
  description = "CIDR block for the private database subnet in us-east-1a"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1b_cidr" {
  description = "CIDR block for the private compute subnet in us-east-1b"
  type        = string
  default     = "10.0.3.0/24"
}

variable "az_primary" {
  description = "Primary availability zone (public + database subnets)"
  type        = string
  default     = "us-east-1a"
}

variable "az_secondary" {
  description = "Secondary availability zone (compute subnet) - must differ from primary for redundancy"
  type        = string
  default     = "us-east-1b"
}
