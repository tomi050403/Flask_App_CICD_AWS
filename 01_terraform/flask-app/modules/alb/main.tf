# ---
# ALB
# ---
resource "aws_lb" "alb" {
  name               = "${var.project}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    var.alb_sg_id
  ]
  subnets = [
    var.public_subnet_1a,
    var.public_subnet_1c
  ]

  tags = {
    Name    = "${var.project}-${var.environment}-alb"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_lb_listener" "aws_listener_http" {
  count = var.environment == "prod" ? 0 : 1
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }

  tags = {
    Name    = "${var.project}-${var.environment}-listener_http"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_lb_listener" "aws_listener_https" {
  count = var.environment == "prod" ? 1 : 0
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert_alb_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "403 Forbidden"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "block_https_roles" {
  count = var.environment == "prod" ? 1 : 0
  listener_arn = aws_lb_listener.aws_listener_https[0].arn
  priority     = 1

  condition {
    host_header {
      values = ["${var.project}-${var.environment}.${var.public_host_zone}"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = "${var.project}-${var.environment}-targetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = {
    Name    = "${var.project}-${var.environment}-targetgroup"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_lb_target_group_attachment" "aws_lb_target_group_attach" {
  target_group_arn = aws_lb_target_group.lb_target_group.arn
  target_id        = var.web_server_id
}
