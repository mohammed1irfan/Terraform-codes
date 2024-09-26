# Map of firewall policies
variable "firewall_policies" {
  description = "Map of firewall policies with optional fields"
  type = map(object({
    name                = string
    base_policy_id      = optional(string)
    resource_group_name = string
    location            = string
    dns = optional(object({
      servers       = optional(list(string))
      proxy_enabled = optional(bool)
    }))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    insights = optional(object({
      enabled                            = bool
      default_log_analytics_workspace_id = string
      retention_in_days                  = optional(number)
      log_analytics_workspace = optional(object({
        id                = string
        firewall_location = string
      }))
    }))
    intrusion_detection = optional(object({
      mode           = optional(string)
      private_ranges = optional(list(string))
      signature_overrides = optional(list(object({
        id    = optional(string)
        state = optional(string)
      })))
      traffic_bypass = optional(list(object({
        name                  = string
        protocol              = string
        description           = optional(string)
        destination_addresses = optional(list(string))
        destination_ip_groups = optional(list(string))
        destination_ports     = optional(list(string))
        source_addresses      = optional(list(string))
        source_ip_groups      = optional(list(string))
      })))
    }))
    private_ip_ranges                 = optional(list(string))
    auto_learn_private_ranges_enabled = optional(bool)
    sku                               = optional(string)
    tags                              = optional(map(string))
    threat_intelligence_allowlist = optional(object({
      ip_addresses = optional(list(string))
      fqdns        = optional(list(string))
    }))
    threat_intelligence_mode = optional(string)
    tls_certificate = optional(object({
      key_vault_secret_id = string
      name                = string
    }))
    sql_redirect_allowed = optional(bool)
    explicit_proxy = optional(object({
      enabled         = optional(bool)
      http_port       = optional(number)
      https_port      = optional(number)
      enable_pac_file = optional(string)
      pac_file_port   = optional(number)
      pac_file        = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      alltrue([for fw in var.firewall_policies : contains(["Free", "Standard", "Premium"], fw.sku)])

    ])
    error_message = "Invalid SKU configuration: sku must be one of 'Free', 'Standard', or 'Premium'."
  }
  validation {
    condition = alltrue([
      alltrue([for fw in var.firewall_policies : contains(["Off", "Alert", "Deny"], fw.threat_intelligence_mode)])
    ])
    error_message = "Invalidate tthreat_intelligence_mode: must be 'Off' or 'Alert' or 'Deny'. "
  }
}

#####firewall_policy_rule_collection_groups #######
variable "firewall_policy_rule_collection_groups" {
  description = "A map of Firewall Policy Rule Collection Groups to create."
  type = map(object({
    name               = string
    firewall_policy_id = string
    priority           = number
    application_rule_collections = list(object({
      name        = string
      discription = optional(string)
      priority    = number
      action      = string
      rules = list(object({
        name = string
        protocols = optional(list(object({
          type = string
          port = number
        })))
        http_headers = optional(list(object({
          name  = string
          value = string
        })))
        source_addresses      = optional(list(string))
        source_ip_groups      = optional(list(string))
        destination_urls      = optional(list(string))
        destination_fqdns     = optional(list(string))
        destination_fqdn_tags = optional(list(string))
        destination_addresses = optional(list(string))
        terminate_tls         = optional(bool)
        web_categories        = optional(list(string))
      }))
    }))
    network_rule_collections = list(object({
      name        = string
      description = optional(string)
      priority    = number
      action      = string
      rules = list(object({
        name                  = string
        protocols             = list(string)
        source_addresses      = optional(list(string))
        source_ip_groups      = optional(list(string))
        destination_addresses = optional(list(string))
        destination_ip_groups = optional(list(string))
        destination_fqdns     = optional(list(string))
        destination_ports     = list(number)
      }))
    }))
    nat_rule_collections = list(object({
      name     = string
      priority = number
      action   = string
      rules = list(object({
        name                = string
        description         = optional(string)
        protocols           = list(string)
        source_addresses    = optional(list(string))
        source_ip_groups    = optional(list(string))
        destination_address = optional(string)
        destination_ports   = optional(list(string))
        translated_address  = string
        translated_fqdn     = optional(string)
        translated_port     = number
      }))
    }))
  }))
  validation {
    condition = alltrue([
      alltrue([for group in var.firewall_policy_rule_collection_groups : group.priority >= 100 && group.priority <= 65000]),
      alltrue([for group in var.firewall_policy_rule_collection_groups : alltrue([for collection in group.application_rule_collections : collection.priority >= 100 && collection.priority <= 65000])]),
      alltrue([for group in var.firewall_policy_rule_collection_groups : alltrue([for collection in group.network_rule_collections : collection.priority >= 100 && collection.priority <= 65000])]),
      alltrue([for group in var.firewall_policy_rule_collection_groups : alltrue([for collection in group.nat_rule_collections : collection.priority >= 100 && collection.priority <= 65000])])

    ])
    error_message = " Invalid priority: must be between 100 to 65000. "
  }
  validation {
    condition = alltrue([
      alltrue([for group in var.firewall_policy_rule_collection_groups : alltrue([for collection in group.application_rule_collections : contains(["Allow", "Deny"], collection.action)])]),
      alltrue([for group in var.firewall_policy_rule_collection_groups : alltrue([for collection in group.network_rule_collections : contains(["Allow", "Deny"], collection.action)])])
    ])
    error_message = " Invalid action: must be 'Allow' or 'Deny'. "
  }
  validation {
    condition = alltrue([
      alltrue([for group in var.firewall_policy_rule_collection_groups : alltrue([for collection in group.nat_rule_collections : contains(["Dnat"], collection.action)])])
    ])
    error_message = "Invalid action : only Dnat is supported"
  }
  validation {
    condition = alltrue([
      alltrue([for group in var.firewall_policy_rule_collection_groups : alltrue([for collection in group.nat_rule_collections : alltrue([for rule in collection.rules : alltrue([for protocol in rule.protocols : contains(["TCP", "UDP"], protocol)])])])]),
      alltrue([for group in var.firewall_policy_rule_collection_groups : alltrue([for collection in group.network_rule_collections : alltrue([for rule in collection.rules : alltrue([for protocol in rule.protocols : contains(["TCP", "UDP", "ICMP", "Any"], protocol)])])])])
    ])
    error_message = " Invalid Protocol: must be 'TCP' or 'UDP' for Nat rule and 'TCP' or 'UDP', 'Any', 'ICMP' for Network_rule."
  }
}

###########Azure Front Door Firewall polciy ##############

variable "firewall_policies_front_door" {
  description = "A map of firewall policies with their configurations."
  type = map(object({
    name                              = string
    resource_group_name               = string
    enabled                           = optional(bool)
    mode                              = optional(string)
    redirect_url                      = optional(string)
    custom_block_response_status_code = optional(number)
    custom_block_response_body        = optional(string)
    tags                              = optional(map(string))
    custom_rule = optional(list(object({
      name                           = string
      enabled                        = optional(bool)
      priority                       = optional(number)
      rate_limit_duration_in_minutes = optional(number)
      rate_limit_threshold           = optional(number)
      type                           = string
      action                         = string
      match_conditions = optional(list(object({
        match_variable     = string
        operator           = string
        negation_condition = optional(bool)
        match_values       = list(string)
        transforms         = optional(list(string))
        selector           = optional(string)
      })))
    })))
    managed_rule = optional(list(object({
      type    = string
      version = string
      exclusion = optional(list(object({
        match_variable = string
        operator       = string
        selector       = string
      })))
      override = optional(list(object({
        rule_group_name = string
        exclusion = optional(list(object({
          match_variable = string
          operator       = string
          selector       = string
        })))
        rule = optional(list(object({
          rule_id = string
          enabled = optional(bool)
          action  = string
          exclusion = optional(list(object({
            match_variable = string
            operator       = string
            selector       = string
          })))
        })))
      })))
    })))
  }))
  validation {
    condition = alltrue([
      alltrue([for fw in var.firewall_policies_front_door : contains(["Detection", "Prevention"], fw.mode)])
    ])
    error_message = "Invalidate mode: must be 'Detection' or 'Prevention'. "
  }
}

############# Web Application policy ##############################################

variable "web_application_firewall_policies" {
  description = "A map of Web Application Firewall Policies."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    tags                = optional(map(string))

    custom_rules = optional(list(object({
      name                 = optional(string)
      enabled              = optional(bool, true)
      priority             = number
      rule_type            = string
      action               = string
      rate_limit_duration  = optional(string)
      rate_limit_threshold = optional(number)
      group_rate_limit_by  = optional(string)
      match_conditions = list(object({
        match_variables = list(object({
          variable_name = string
          selector      = optional(string, null)
        }))
        operator           = string
        negation_condition = optional(bool)
        match_values       = optional(list(string), [])
        transforms         = optional(list(string), [])
      }))
    })))

    policy_settings = optional(object({
      enabled                     = optional(bool)
      mode                        = optional(string)
      request_body_check          = optional(bool)
      file_upload_limit_in_mb     = optional(number)
      max_request_body_size_in_kb = optional(number)
      log_scrubbing = optional(list(object({
        enable = optional(bool)
        rule = optional(list(object({
          enable                  = optional(bool)
          match_variable          = string
          selector                = optional(string)
          selector_match_operator = optional(string)
        })))
      })))
      request_body_enforcement                  = optional(bool, false)
      request_body_inspect_limit_in_kb          = optional(number, 128)
      js_challenge_cookie_expiration_in_minutes = optional(number, 30)
    }))

    managed_rules = list(object({
      exclusions = optional(list(object({
        match_variable          = string
        selector                = string
        selector_match_operator = string
        excluded_rule_set = optional(list(object({
          type    = optional(string, "")
          version = optional(string, "")
          rule_group = optional(list(object({
            rule_group_name = string
            excluded_rules  = optional(list(string), [])
          })), [])
        })))
      })))

      managed_rule_set = object({
        type    = string
        version = string
        rule_group_override = optional(list(object({
          rule_group_name = string
          rules = optional(list(object({
            id      = string
            enabled = optional(bool)
            action  = optional(string)
          })))
        })))
      })
    }))
  }))
}




