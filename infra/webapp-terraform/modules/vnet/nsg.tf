resource "azurerm_network_security_group" "nsg" {
  count = length(var.nsg_list)
  name = var.nsg_list[count.index]
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location

  depends_on = [ azurerm_resource_group.rg ]
}

resource "azurerm_network_security_rule" "webapp" {
  for_each = var.nsg_rulesets

  name                        = each.value.name
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = each.value.nsg
  priority                    = each.value.priority
  source_address_prefix       = each.value.src_addr_prefix
  direction                   = "Inbound"
  destination_port_ranges     = each.value.des_port_ranges
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_address_prefix  = "*"

  depends_on = [ azurerm_network_security_group.nsg ]
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  count = length(var.nsg_list)

  subnet_id = try(data.azurerm_subnet.subnet[count.index].id, null)
  network_security_group_id = try(data.azurerm_network_security_group.nsg[count.index].id, null)
}

data "azurerm_subnet" "subnet" {
  count = length(var.subnet_list)

  name                 = var.subnet_list[count.index]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name

  depends_on = [
    azurerm_resource_group.rg, azurerm_subnet.mainapp_subnet
  ]
}

data "azurerm_network_security_group" "nsg" {
  count = length(var.nsg_list)

  name                = var.nsg_list[count.index]
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [
    azurerm_resource_group.rg, azurerm_network_security_group.nsg
  ]
}

