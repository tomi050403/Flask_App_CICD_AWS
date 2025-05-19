# ---
# VPC
# ---
resource "aws_vpc" "vpc" {
  cidr_block                       = var.vpc_cidr_block
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}

# ---
# Subnet
# ---
# Public
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.AZ_1
  cidr_block              = var.AZ_1_publicsub
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1a"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.AZ_2
  cidr_block              = var.AZ_2_publicsub
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1c"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

#Private
resource "aws_subnet" "private_subnet_1a_web" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.AZ_1
  cidr_block              = var.AZ_1_privatesub_web
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1a_web"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_subnet_1a_app" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.AZ_1
  cidr_block              = var.AZ_1_privatesub_app
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1a_app"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_subnet_1a_rds" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.AZ_1
  cidr_block              = var.AZ_1_privatesub_rds
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1a_rds"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_subnet_1c_web" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.AZ_2
  cidr_block              = var.AZ_2_privatesub_web
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1c_web"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_subnet_1c_app" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.AZ_2
  cidr_block              = var.AZ_2_privatesub_app
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1c_app"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_subnet_1c_rds" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.AZ_2
  cidr_block              = var.AZ_2_privatesub_rds
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1c_rds"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

# ---
# Route Table
# ---
# Public
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-public-route-table"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_route_table_association" "public_route_asso" {
  for_each = {
    "1a" = aws_subnet.public_subnet_1a.id,
    "1c" = aws_subnet.public_subnet_1c.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.public_route_table.id
}

# Private
# Private_1 web app
resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-private-route-table_1"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_route_table_association" "private_route_asso_1" {
  for_each = {
    "1a_web" = aws_subnet.private_subnet_1a_web.id,
    "1a_app" = aws_subnet.private_subnet_1a_app.id,
    "1c_web" = aws_subnet.private_subnet_1c_web.id,
    "1c_app" = aws_subnet.private_subnet_1c_app.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.private_route_table_1.id
}

# Private_2 rds
resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-private-route-table_2"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_route_table_association" "private_route_asso_2" {
  for_each = {
    "1a_rds" = aws_subnet.private_subnet_1a_rds.id,
    "1c_rds" = aws_subnet.private_subnet_1c_rds.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.private_route_table_2.id
}

# ---
# Internet Gateway(public to internet)
# ---
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_route" "igw_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# ---
# Nat Gateway(private to internet)
# ---
resource "aws_eip" "eip_nat" {
  vpc = true

  tags = {
    Name    = "${var.project}-${var.environment}-eip-nat"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.public_subnet_1a.id

  tags = {
    Name    = "${var.project}-${var.environment}-nat-gw"
    Project = var.project
    Env     = var.environment
  }
  depends_on = [aws_eip.eip_nat]
}

resource "aws_route" "nat_route_private" {
  route_table_id         = aws_route_table.private_route_table_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}


########################################################
# Outputs
########################################################
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_1a" {
  value = aws_subnet.public_subnet_1a.id
}

output "public_subnet_1c" {
  value = aws_subnet.public_subnet_1c.id
}

output "private_subnet_1a_web" {
  value = aws_subnet.private_subnet_1a_web.id
}

output "private_subnet_1a_app" {
  value = aws_subnet.private_subnet_1a_app.id
}

output "private_subnet_1a_rds" {
  value = aws_subnet.private_subnet_1a_rds.id
}

output "private_subnet_1c_web" {
  value = aws_subnet.private_subnet_1c_web.id
}

output "private_subnet_1c_app" {
  value = aws_subnet.private_subnet_1c_app.id
}

output "private_subnet_1c_rds" {
  value = aws_subnet.private_subnet_1c_rds.id
}
