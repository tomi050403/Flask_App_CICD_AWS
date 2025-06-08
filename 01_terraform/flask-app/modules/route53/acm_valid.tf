# ---
# cert ap-northeast
# for alb
# ---
resource "aws_acm_certificate" "cert_alb" {
  count             = var.environment == "prod" ? 1 : 0
  domain_name       = "${var.project}-${var.environment}-alb.${var.public_host_zone}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "${var.project}-${var.environment}-cert-alb"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_acm_certificate_validation" "cert_alb_valid" {
  count                   = var.environment == "prod" ? 1 : 0
  certificate_arn         = aws_acm_certificate.cert_alb[0].arn
  validation_record_fqdns = [for get_record in aws_route53_record.public_host_zone_cname_record : get_record.fqdn]
}

resource "aws_route53_record" "public_host_zone_cname_record" {
  for_each = var.environment == "prod" ? {
    for dvo in aws_acm_certificate.cert_alb[0].domain_validation_options : 
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  } : {}
  zone_id         = data.aws_route53_zone.route53_public_host_zone[0].id
  name            = each.value.name
  type            = each.value.type
  ttl             = 600
  records         = [each.value.record]

  depends_on = [
    aws_acm_certificate.cert_alb
  ]
}
