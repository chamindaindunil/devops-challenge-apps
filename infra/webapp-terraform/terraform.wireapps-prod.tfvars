# Azure
location    = "westus3"
environment = "wireapps-uat"

tenant_id       = "774f23c7-7b7d-43bc-a2cd-b1ab70ba1eef"
subscription_id = "5c90cb79-c794-4923-992f-63180bc7f04d"

#Vnet
vnet_address = ["10.0.0.0/24"]
subnet_list = ["public-subnet", "private-subnet"]
nsg_list = ["web-nsg", "api-nsg"]
nsg_rulesets = {
  "web-https" = {
    nsg             = "web-nsg"
    subnet          = "public-subnet"
    subnet_assoc    = true,
    name            = "AllowHttps",
    priority        = "101",
    src_addr_prefix = "Internet"
    des_port_ranges = ["443"]
  }
}

#WebApp
sku_type = "B1"

#docker
docker_registry_url = 
docker_registry_username = 
docker_registry_password = 
docker_image_name = []

cidr_block     = "10.0.0.0/24"
public_subnets = ["10.0.0.0/27", "10.0.0.32/27"]
az_set         = ["ap-south-1a", "ap-south-1b"]

