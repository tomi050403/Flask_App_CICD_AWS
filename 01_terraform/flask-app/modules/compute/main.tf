# ---
# EC2 instance
# ---
# app sv
resource "aws_instance" "appsv" {
  ami                         = var.app_sv_ami
  instance_type               = var.appsv_instance_type
  subnet_id                   = var.private_subnet_1a_app
  associate_public_ip_address = false
  vpc_security_group_ids      = [var.app_sg_id]
  iam_instance_profile        = var.ec2_profile_name

  key_name = "GHA-FLASK-APP"

  tags = {
    Name    = "${var.project}-${var.environment}-appsv"
    Project = var.project
    Env     = var.environment
    type    = "appsv"
  }
}

# web sv
resource "aws_instance" "websv" {
  ami                         = var.web_sv_ami
  instance_type               = var.websv_instance_type
  subnet_id                   = var.private_subnet_1a_web
  associate_public_ip_address = false
  vpc_security_group_ids      = [var.web_sg_id]
  iam_instance_profile        = var.ec2_profile_name

  key_name = "GHA-FLASK-APP"

  tags = {
    Name    = "${var.project}-${var.environment}-websv"
    Project = var.project
    Env     = var.environment
    type    = "websv"
  }
}
