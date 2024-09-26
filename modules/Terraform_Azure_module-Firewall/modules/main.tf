resource "azurerm_firewall" "firewall" {
  for_each = var.create_firewalls

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku_name            = each.value.sku_name
  sku_tier            = each.value.sku_tier
  firewall_policy_id  = var.use_firewall_policy ? var.firewall_policy_id : null                 # Use the firewall policy only if the use_firewall_policy variable is true
  threat_intel_mode   = each.value.sku_name == "AZFW_VNet" ? each.value.threat_intel_mode : null
  zones               = each.value.zones
  private_ip_ranges   = each.value.private_ip_ranges
  tags                = each.value.tags
  dns_servers         = each.value.dns_servers
  dns_proxy_enabled   = each.value.dns_proxy_enabled
  dynamic "ip_configuration" {
    for_each = each.value.sku_name == "AZFW_VNet" ? each.value.ip_configuration : []
    content {
      name                 = ip_configuration.value.name
      public_ip_address_id = ip_configuration.value.public_ip_address_id
      subnet_id            = ip_configuration.value.subnet_id
    }
  }
  dynamic "management_ip_configuration" {
    for_each = each.value.sku_name == "AZFW_VNet" ? each.value.management_ip_configuration : []
    content {
      name                 = management_ip_configuration.value.name
      public_ip_address_id = management_ip_configuration.value.public_ip_address_id
      subnet_id            = management_ip_configuration.value.subnet_id
    }
  }
  dynamic "virtual_hub" {
    for_each = each.value.sku_name == "AZFW_Hub" ? each.value.virtual_hub : []
    content {
      virtual_hub_id  = lookup(virtual_hub.value, "virtual_hub_id", null)
      public_ip_count = try(virtual_hub.value.public_ip_count, 1)
    }
  }
}
resource "azurerm_firewall_application_rule_collection" "firewall-rule" {
  for_each = var.use_firewall_policy ? {} : var.application_rule_collection

  name                = each.value.name
  azure_firewall_name = try(azurerm_firewall.firewall[each.key].name, each.value.azure_firewall_name) 
  resource_group_name = each.value.resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  depends_on = [azurerm_firewall.firewall]
  dynamic "rule" {
    for_each = each.value.rules
    content {
      name             = rule.value.name
      description      = rule.value.description
      source_addresses = rule.value.source_addresses
      target_fqdns     = rule.value.target_fqdns
      fqdn_tags        = rule.value.fqdn_tags
      source_ip_groups = rule.value.source_ip_groups

      dynamic "protocol" {
        for_each = rule.value.protocols
        content {
          port = protocol.value.port
          type = protocol.value.type
        }
      }
    }
  }
}

resource "azurerm_firewall_nat_rule_collection" "nat_rule_collection" {
  for_each = var.use_firewall_policy ? {} : var.firewall_nat_rule_collection

  name                = each.value.name
  azure_firewall_name = try(azurerm_firewall.firewall[each.key].name, each.value.azure_firewall_name) 
  resource_group_name = each.value.resource_group_name
  priority            = each.value.priority
  action              = each.value.action
  depends_on          = [azurerm_firewall.firewall]

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name                  = rule.value.name
      description           = rule.value.description
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      translated_port       = rule.value.translated_port
      translated_address    = rule.value.translated_address
      protocols             = rule.value.protocols
      source_ip_groups      = rule.value.source_ip_groups
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "network_collection" {
  for_each = var.use_firewall_policy ? {} : var.network_rule_collection

  name                = each.value.name
  azure_firewall_name = try(azurerm_firewall.firewall[each.key].name, each.value.azure_firewall_name) 
  resource_group_name = each.value.resource_group_name
  priority            = each.value.priority
  action              = each.value.action
  depends_on          = [azurerm_firewall.firewall]

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name                  = rule.value.name
      description           = rule.value.description
      source_addresses      = rule.value.source_addresses
      source_ip_groups      = try(rule.value.source_ip_groups, [])
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      destination_ip_groups = try(rule.value.destination_ip_groups, [])
      destination_fqdns     = try(rule.value.destination_fqdns, [])                # both IP address and fqdns are not supported
      protocols             = rule.value.protocols
    }
  }
}

