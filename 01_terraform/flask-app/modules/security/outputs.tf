########################################################
# Outputs
########################################################
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "web_sg_id" {
  value = aws_security_group.websv_sg.id
}

output "app_sg_id" {
  value = aws_security_group.appsv_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}
