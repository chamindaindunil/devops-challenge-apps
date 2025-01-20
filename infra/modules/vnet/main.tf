# Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-rg"
  location = var.location
}

# Azure Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.environment}-vnet"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

# Azure Subnets
resource "azurerm_subnet" "subnet" {
  count               = length(var.subnet_list)
  name                = var.subnet_list[count.index].name
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes    = [var.subnet_list[count.index].address_prefix]

  depends_on = [
    azurerm_resource_group.rg,
    azurerm_virtual_network.vnet
  ]
}