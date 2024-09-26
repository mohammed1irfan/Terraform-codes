terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id                 = "axrcv"
  tenant_id                       = "wedff"
  resource_provider_registrations = "none"
}