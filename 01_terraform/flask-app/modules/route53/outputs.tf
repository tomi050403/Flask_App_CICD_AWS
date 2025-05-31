########################################################
# Outputs
########################################################
output "cert_alb_arn" {
  value = try(aws_acm_certificate.cert_alb[0].arn, null)
}

output "public_host_zone" {
  value = var.public_host_zone
}
