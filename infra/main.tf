module "vnet" {
  source                = "./modules/vnet"
  environment           = var.environment
  location              = var.location
  vnet_address_space    = var.vnet_address_space
  subnet_list           = var.subnet_list
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
  subnet_id                = module.vnet.subnet_id
  docker_registry_url      = var.docker_registry_url
  docker_registry_username = var.docker_registry_username
  docker_registry_password = var.docker_registry_password
  docker_image_name        = var.docker_image_name
  tags                     = {
    environment            = var.environment
    terraform              = "true"
  }
}