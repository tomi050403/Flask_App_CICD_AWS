########################################################
# Outputs
########################################################
output "appsv_instance_private_ip" {
  value = aws_instance.appsv.private_ip
}

output "web_server_id" {
  value = aws_instance.websv.id
}