output "vpc_id" {
  description = "ID of the data platform VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  description = "ID of the public subnet hosting the NAT Gateway"
  value       = aws_subnet.public_1a.id
}

output "private_db_subnet_id" {
  description = "ID of the private database subnet (us-east-1a)"
  value       = aws_subnet.private_db_1a.id
}

output "private_compute_subnet_id" {
  description = "ID of the private compute subnet (us-east-1b)"
  value       = aws_subnet.private_compute_1b.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "nat_gateway_public_ip" {
  description = "Elastic IP address attached to the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

output "sg_public_nat_id" {
  description = "ID of the public/NAT security group"
  value       = aws_security_group.public_nat.id
}

output "sg_private_compute_id" {
  description = "ID of the private compute security group"
  value       = aws_security_group.private_compute.id
}

output "sg_private_db_id" {
  description = "ID of the private database security group"
  value       = aws_security_group.private_db.id
}

output "s3_vpc_endpoint_id" {
  description = "ID of the S3 Gateway VPC endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "dynamodb_vpc_endpoint_id" {
  description = "ID of the DynamoDB Gateway VPC endpoint"
  value       = aws_vpc_endpoint.dynamodb.id
}

output "secretsmanager_vpc_endpoint_id" {
  description = "ID of the Secrets Manager Interface VPC endpoint"
  value       = aws_vpc_endpoint.secretsmanager.id
}
