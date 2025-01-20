module "vnet" {
  source                = "./modules/vnet"
  environment           = var.environment
  location              = var.location
  vnet_address_space    = var.vnet_address
  subnet_list           = var.subnet_list
  nsg_list              = var.nsg_list
  nsg_rulesets          = var.nsg_rulesets
  tags                  = {
    environment         = var.environment
    terraform           = "true"
  }
}

module "webapp" {
  source                   = "./modules/webapp"
  environment              = var.environment
  location                 = var.location
  resource_group_name      = module.vnet.resource_group_name
  sku_type                 = var.sku_type
  public_subnet_id         = module.vnet.public_subnet_id
  private_subnet_id        = module.vnet.private_subnet_id
  docker_registry_url      = var.docker_registry_url
  docker_registry_username = var.docker_registry_username
  docker_registry_password = var.docker_registry_password
  docker_image_name        = var.docker_image_name
  tags                     = {
    environment            = var.environment
    terraform              = "true"
  }
}