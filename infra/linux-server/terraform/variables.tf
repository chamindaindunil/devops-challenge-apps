variable "project" {}
variable "environment" {}
variable "aws_region" {}

variable "access_key" {
  sensitive = true
}
variable "secret_key" {
  sensitive = true
}

variable "cidr_block" {}
variable "public_subnets" {}
variable "az_set" {}

variable "ami_id" {}
variable "instance_type" {}
variable "disk_size" {}