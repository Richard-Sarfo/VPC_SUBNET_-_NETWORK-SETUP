resource "aws_security_group" "public_nat" {
  name        = "sg-public-nat"
  description = "Security group for public subnet with NAT Gateway. Allows HTTPS inbound only."
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS from anywhere for secure connections"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-public-nat"
  }
}

resource "aws_security_group" "private_compute" {
  name        = "sg-private-compute"
  description = "Security group for compute (EC2, Lambda, Glue) in private subnets. Allow internal traffic."
  vpc_id      = aws_vpc.main.id

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-private-compute"
  }
}

resource "aws_security_group_rule" "compute_self_ingress" {
  type                     = "ingress"
  description              = "Allow all traffic from within this security group"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.private_compute.id
  source_security_group_id = aws_security_group.private_compute.id
}

resource "aws_security_group_rule" "compute_from_public_ingress" {
  type                     = "ingress"
  description              = "Allow all traffic from public NAT security group"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.private_compute.id
  source_security_group_id = aws_security_group.public_nat.id
}

resource "aws_security_group" "private_db" {
  name        = "sg-private-db"
  description = "Security group for RDS databases in private subnets. Only allow from compute layer."
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from compute subnet"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.private_compute.id]
  }

  ingress {
    description     = "PostgreSQL from compute subnet"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.private_compute.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-private-db"
  }
}
