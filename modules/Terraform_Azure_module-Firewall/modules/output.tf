output "firewall_names" {
  description = "The names of the Azure Firewalls"
  value       = { for key, firewall in azurerm_firewall.firewall : key => firewall.name }
}

output "firewall_id" {
  description = "The ID of the Azure Firewall"
  value       = { for key, firewall in azurerm_firewall.firewall : key => firewall.id }
}

output "firewall_ip_configuration_private" {
  description = "The private IP address of the Azure Firewall's IP configuration"
  value = {
    for key, firewall in azurerm_firewall.firewall : key => {
      private_ip_address = length(firewall.ip_configuration) > 0 ? firewall.ip_configuration[0].private_ip_address : null
    }
  }
}

output "firewall_virtual_hub_private" {
  description = "The virtual hub block of the Azure Firewall"
  value = {
    for key, firewall in azurerm_firewall.firewall : key => {
      private_ip_address = firewall.sku_name == "AZFW_Hub" ? firewall.virtual_hub[0].private_ip_address : null
    }
  }
}

output "firewall_virtual_hub_public" {
  description = "The virtual hub block of the Azure Firewall"
  value = {
    for key, firewall in azurerm_firewall.firewall : key => {
      public_ip_addresses = firewall.sku_name == "AZFW_Hub" ? firewall.virtual_hub[0].public_ip_addresses : null
    }
  }
}
