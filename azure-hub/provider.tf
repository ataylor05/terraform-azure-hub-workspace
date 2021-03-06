terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.78.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.aad_tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}