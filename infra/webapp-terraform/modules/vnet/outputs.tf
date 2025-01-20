output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_subnet_id" {
  value = azurerm_subnet.web-subnet.id
}

output "private_subnet_id" {
  value = azurerm_subnet.api-subnet.id
}