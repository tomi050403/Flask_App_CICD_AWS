# ---
# Private Host Zone
# ---
resource "aws_route53_zone" "network-private_host_zone" {
  name          = "${var.environment}.${var.private_host_zone}"
  comment       = "private host zone"
  force_destroy = true

  vpc {
    vpc_id     = var.vpc_id
    vpc_region = var.region
  }

  tags = {
    Name    = "${var.project}-${var.environment}-private-host-zone"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_route53_record" "network-private_zone_record" {
  zone_id = aws_route53_zone.network-private_host_zone.id
  name    = "app"
  type    = "A"
  ttl     = 300
  records = [var.appsv_instance_private_ip]
}


# ---
# Public Host Zone
# and ssl
# ---
# state外で定義したroute53 hostzoneリソースを呼び出し
data "aws_route53_zone" "route53_public_host_zone" {
  count = var.environment == "prod" ? 1 : 0
  name         = var.public_host_zone
  private_zone = false
}

resource "aws_route53_record" "public_host_zone_A_record" {
  count = var.environment == "prod" ? 1 : 0
  zone_id = data.aws_route53_zone.route53_public_host_zone[0].id
  name    = "${var.project}-${var.environment}.${var.public_host_zone}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }

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
  ttl             = 300
  records         = [each.value.record]

  depends_on = [
    aws_acm_certificate.cert_alb
  ]
}


