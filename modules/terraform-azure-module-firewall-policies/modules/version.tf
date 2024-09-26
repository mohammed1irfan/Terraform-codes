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
  subscription_id                 = "abc-jjen"
  tenant_id                       = "xyz"
  resource_provider_registrations = "none"
}