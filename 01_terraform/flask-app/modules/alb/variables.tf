### config
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}


########################################################
### import
variable "web_sg_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_1a" {
  type = string
}

variable "public_subnet_1c" {
  type = string
}

variable "private_subnet_1a_web" {
  type = string
}

variable "private_subnet_1c_web" {
  type = string
}

variable "web_server_id" {
  type = string
}

variable "cert_alb_arn" {
  type = string
}

variable "public_host_zone" {
  type = string
}
