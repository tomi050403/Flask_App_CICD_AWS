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
