module "vpc" {
  source         = "./modules/vpc"
  cidr_block     = var.cidr_block
  az_set         = var.az_set
  public_subnets = var.public_subnets
}

module "ec2" {
  source        = "./modules/ec2"
  project       = var.project
  ami_id        = var.ami_id
  instance_type = var.instance_type
  disk_size     = var.disk_size
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.subnet_id
}