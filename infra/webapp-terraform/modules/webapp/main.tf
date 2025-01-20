resource "azurerm_service_plan" "main" {
  name = "${var.environment}-app-service-plan"
  resource_group_name = var.resource_group_name
  location = var.location
  os_type = "Linux"
  sku_name = var.sku_type
}

resource "azurerm_linux_web_app" "app" {
  name = "${var.environment}-webapp"
  resource_group_name = var.resource_group_name
  location = var.location
  service_plan_id = azurerm_service_plan.main.id
  virtual_network_subnet_id = var.public_subnet_id
  public_network_access_enabled = true

  site_config {
    application_stack {
      docker_registry_url = var.docker_registry_url
      docker_registry_username = var.docker_registry_username
      docker_registry_password = var.docker_registry_password
      docker_image_name = var.docker_image_name[0]
    }
  }
}

resource "azurerm_linux_web_app" "api" {
  name = "${var.environment}-api"
  resource_group_name = var.resource_group_name
  location = var.location
  service_plan_id = azurerm_service_plan.main.id
  virtual_network_subnet_id = var.private_subnet_id
  public_network_access_enabled = false

  site_config {
    application_stack {
      docker_registry_url = var.docker_registry_url
      docker_registry_username = var.docker_registry_username
      docker_registry_password = var.docker_registry_password
      docker_image_name = var.docker_image_name[1]
    }
  }
}