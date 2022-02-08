variable "name" {}
variable "application" {}

# VPC
variable "region" {}
variable "vpc_cidr_block" {}

variable "pub_subnet_cidr_block" {
  type = list
}
variable "priv_subnet_cidr_block" {
  type = list
}

variable "ssh_sg_cidr_block" {
  type = list
}

# EC2
variable "ami" {}
variable "instance_type" {}

# DB
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "parameter_group_name" {}

variable "asg_max_size" {}
variable "asg_min_size" {}
variable "asg_desired_capacity" {}
variable "health_check_interval" {}
variable "health_check_healthy_threshold" {}
variable "db_allocated_storage" {}
