terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.15.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.43.0"
    }
  }
}

provider "azurerm" {
  features {}

    subscription_id = var.subscription_id
    tenant_id       = var.tenant_id
}