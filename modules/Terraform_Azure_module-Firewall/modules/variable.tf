variable "create_firewalls" {
  description = "A map of Azure Firewall configurations"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku_name            = string
    sku_tier            = string
    threat_intel_mode   = optional(string)
    zones               = list(string)
    dns_servers         = optional(list(string))
    dns_proxy_enabled   = optional(bool)
    private_ip_ranges   = optional(list(string))
    tags                = optional(map(string))
    ip_configuration = list(object({
      name                 = string
      public_ip_address_id = optional(string)
      subnet_id            = optional(string)
    }))
    management_ip_configuration = list(object({
      name                 = string
      public_ip_address_id = string
      subnet_id            = string
    }))
    virtual_hub = optional(list(object({
      virtual_hub_id  = string
      public_ip_count = optional(number)

    })))
  }))
  validation {
    condition = alltrue([
      alltrue([for fw in var.create_firewalls : contains(["AZFW_Hub", "AZFW_VNet"], fw.sku_name)]),
      alltrue([for fw in var.create_firewalls : contains(["Free", "Standard", "Premium"], fw.sku_tier)]),
      
    ])
    error_message = "Invalid SKU configuration: sku_name must be one of 'AZFW_Hub' or 'AZFW_VNet', and sku_tier must be one of 'Free', 'Standard', or 'Premium'."
  }
  validation {
    condition = alltrue([
    alltrue([for fw in var.create_firewalls : contains(["Off", "Alert", "Deny"], fw.threat_intel_mode)])
    ])
    error_message = "Invalidate threat_intel_mode: must be 'Off' or 'Alert' or 'Deny'. "
  }
}

######################################################################
####          Addedd for condition                   #################
####  Keep it True if you are usinging Virtual_hub (AZFW_Hub) ########
#### keep it false if you are using Vnet (AZFW_VNet)          ########
######################################################################
variable "use_firewall_policy" {
  description = "Set to true to use Firewall Policy, false to use Rule Collections"
  type        = bool
  default     = false
}
variable "firewall_policy_id" {
  description = "The ID of the firewall policy to apply"
  type        = string
  default     = null
}

####################################################################################################
###  When using Azure Firewall with Virtual Hub, you do not directly manage,            ############
###  RuleCollections like you would in a typical standalone Azure Firewall.             ############
####################################################################################################


variable "application_rule_collection" {
  description = "Application rule collection configuration when not using firewall policy"
  type = map(object({
    name                = string
    azure_firewall_name = string
    resource_group_name = string
    priority            = number
    action              = string

    rules = list(object({
      name             = string
      description      = optional(string)
      source_addresses = optional(list(string))
      target_fqdns     = optional(list(string))
      fqdn_tags        = optional(list(string))
      source_ip_groups = optional(list(string))

      protocols = optional(list(object({
        port = string
        type = string
      })))
    }))
  }))
  validation {
    condition = alltrue([
      alltrue([for fw in var.application_rule_collection : fw.priority >= 100 && fw.priority <= 65000])
    ])
    error_message = " Invalid priority: must be between 100 to 65000. "
  }
  validation {
    condition = alltrue([
      alltrue([for fw in var.application_rule_collection : contains(["Allow", "Deny"], fw.action)])
    ])
    error_message = " Invalid action: must be 'Allow' or 'Deny'. "
  }
  validation {
    condition = alltrue([
      alltrue([for rule_collection in var.application_rule_collection : alltrue([for rule in rule_collection.rules : alltrue([for protocol in rule.protocols : contains(["Http", "Https", "Mssql"], protocol.type)  # Validate allowed protocol types
      ])])]),
      alltrue([for rule_collection in var.application_rule_collection : alltrue([for rule in rule_collection.rules : alltrue([for protocol in rule.protocols : can(regex("^\\d{1,5}$", protocol.port)) || can(regex("^\\d{1,5}-\\d{1,5}$", protocol.port))])])]),
      ])
    error_message = "Invalid configuration: protocol type must be either 'Http', 'Https', 'Mssql', and port must be a valid number or port range (e.g., 80, 443, or 1000-2000)."
  }
}

##############################################
######         NAT_RULE       ################
##############################################
variable "firewall_nat_rule_collection" {
  description = "NAT rule collection configuration when not using firewall policy"
  type = map(object({
    name                = string
    azure_firewall_name = string
    resource_group_name = string
    priority            = number
    action              = string
    rules = list(object({
      name                  = string
      description           = optional(string)
      source_addresses      = optional(list(string))
      destination_ports     = list(string)
      destination_addresses = list(string)
      translated_port       = number
      translated_address    = string
      protocols             = list(string)
      source_ip_groups      = optional(list(string))
    }))
  }))
  validation {
    condition = alltrue([
      alltrue([for fw in var.firewall_nat_rule_collection : fw.priority >= 100 && fw.priority <= 65000])
    ])
    error_message = " Invalid priority: must be between 100 to 65000. "
  }
  validation {
    condition = alltrue([
      alltrue([for fw in var.firewall_nat_rule_collection : contains(["Snat", "Dnat"], fw.action)])
    ])
    error_message = " Invalid action: must be 'Snat' or 'Dnat'. "
  }
  validation {
    condition = alltrue([
      alltrue([for rule_collection in var.firewall_nat_rule_collection : alltrue([for rule in rule_collection.rules : alltrue([for protocol in rule.protocols : contains(["Any", "ICMP", "TCP", "UDP"], protocol)])])])
      ])
    error_message = "Invalid configuration: protocol type must be either 'TCP', 'UDP', 'Any', 'ICMP'."
  }
}

################################################
###     Netwrok Rule                ############
################################################

variable "network_rule_collection" {
  type = map(object({
    azure_firewall_name = string
    resource_group_name = string
    priority            = number
    action              = string
    rules = list(object({
      name                  = string
      description           = optional(string)
      source_addresses      = list(string)
      source_ip_groups      = optional(list(string))
      destination_ports     = list(string)
      destination_addresses = list(string)
      destination_ip_groups = optional(list(string))
      destination_fqdns     = optional(list(string))
      protocols             = list(string)
    }))
  }))
  validation {
    condition = alltrue([
      alltrue([for fw in var.network_rule_collection : fw.priority >= 100 && fw.priority <= 65000])
    ])
    error_message = " Invalid priority: must be between 100 to 65000. "
  }
  validation {
    condition = alltrue([
      alltrue([for fw in var.network_rule_collection : contains(["Allow", "Deny"], fw.action)])
    ])
    error_message = " Invalid action: must be 'Allow' or 'Deny'. "
  }
  validation {
    condition = alltrue([
      alltrue([for rule_collection in var.network_rule_collection : alltrue([for rule in rule_collection.rules : alltrue([for protocol in rule.protocols : contains(["Any", "ICMP", "TCP", "UDP"], protocol)])])])
      ])
    error_message = "Invalid configuration: protocol type must be either 'TCP', 'UDP', 'Any', 'ICMP'."
  }
}

