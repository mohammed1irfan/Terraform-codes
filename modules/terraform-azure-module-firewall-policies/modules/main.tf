resource "azurerm_firewall_policy" "firewall_policies" {
  for_each = var.firewall_policies

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  # Dynamic block for base_policy_id (no dynamic needed, use lookup directly)
  base_policy_id = lookup(each.value, "base_policy_id", null)

  # Dynamic block for dns
  dynamic "dns" {
    for_each = lookup(each.value, "dns", null) != null ? [each.value.dns] : []
    content {
      servers       = dns.value.servers
      proxy_enabled = dns.value.proxy_enabled 
    }
  }

  # Dynamic block for identity
  dynamic "identity" {
    for_each = lookup(each.value, "identity", null) != null ? [each.value.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids 
    }
  }

  # Dynamic block for insights
  dynamic "insights" {
    for_each = lookup(each.value, "insights", null) != null ? [each.value.insights] : []
    content {
      enabled                            = insights.value.enabled
      default_log_analytics_workspace_id = insights.value.default_log_analytics_workspace_id
      retention_in_days                  = insights.value.retention_in_days
      dynamic "log_analytics_workspace" {
        for_each = insights.value.log_analytics_workspace != null ? [insights.value.log_analytics_workspace] : []
        content {
          id                = log_analytics_workspace.value.id
          firewall_location = log_analytics_workspace.value.firewall_location
        }
      }
    }
  }

  # Dynamic block for intrusion_detection
  dynamic "intrusion_detection" {
    for_each = lookup(each.value, "intrusion_detection", null) != null ? [each.value.intrusion_detection] : []
    content {
      mode           = intrusion_detection.value.mode
      private_ranges = intrusion_detection.value.private_ranges
      dynamic "signature_overrides" {
        for_each = intrusion_detection.value.signature_overrides != null ? intrusion_detection.value.signature_overrides : []

        content {
          id    = signature_overrides.value.id
          state = signature_overrides.value.state
        }
      }

      dynamic "traffic_bypass" {
        for_each = intrusion_detection.value.traffic_bypass != null ? intrusion_detection.value.traffic_bypass : []
        content {
          name                  = traffic_bypass.value.name
          protocol              = traffic_bypass.value.protocol
          description           = traffic_bypass.value.description
          destination_addresses = traffic_bypass.value.destination_addresses
          destination_ip_groups = traffic_bypass.value.destination_ip_groups
          destination_ports     = traffic_bypass.value.destination_ports
          source_addresses      = traffic_bypass.value.source_addresses
          source_ip_groups      = traffic_bypass.value.source_ip_groups
        }
      }
    }
  }

  # Optional fields without dynamic blocks
  private_ip_ranges                 = lookup(each.value, "private_ip_ranges", [])
  auto_learn_private_ranges_enabled = lookup(each.value, "auto_learn_private_ranges_enabled", false)
  sku                               = lookup(each.value, "sku", "Standard")
  tags                              = lookup(each.value, "tags", {})

  # Dynamic block for threat_intelligence_allowlist
  dynamic "threat_intelligence_allowlist" {
    for_each = lookup(each.value, "threat_intelligence_allowlist", null) != null ? [each.value.threat_intelligence_allowlist] : []
    content {
      ip_addresses = threat_intelligence_allowlist.value.ip_addresses
      fqdns        = threat_intelligence_allowlist.value.fqdns
    }
  }

  threat_intelligence_mode = lookup(each.value, "threat_intelligence_mode", "Alert")

  # Dynamic block for tls_certificate
  dynamic "tls_certificate" {
    for_each = lookup(each.value, "tls_certificate", null) != null ? [each.value.tls_certificate] : []
    content {
      key_vault_secret_id = tls_certificate.value.key_vault_secret_id
      name                = tls_certificate.value.name
    }
  }

  sql_redirect_allowed = lookup(each.value, "sql_redirect_allowed", false)

  # Dynamic block for explicit_proxy
  dynamic "explicit_proxy" {
    for_each = lookup(each.value, "explicit_proxy", null) != null ? [each.value.explicit_proxy] : []
    content {
      enabled         = explicit_proxy.value.enabled
      http_port       = explicit_proxy.value.http_port
      https_port      = explicit_proxy.value.https_port
      enable_pac_file = explicit_proxy.value.enable_pac_file
      pac_file_port   = explicit_proxy.value.pac_file_port
      pac_file        = explicit_proxy.value.pac_file
    }
  }
}
#######Firewall policy group with rule collection ######

resource "azurerm_firewall_policy_rule_collection_group" "rule_collection_group" {
  for_each = var.firewall_policy_rule_collection_groups

  name = each.value.name
  firewall_policy_id = each.value.firewall_policy_id
  priority           = each.value.priority

  dynamic "application_rule_collection" {
    for_each = lookup(each.value, "application_rule_collections", [])
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name = rule.value.name

          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
          dynamic "http_headers" {
            for_each = rule.value.http_headers != null ? rule.value.http_headers : []
            content {
              name  = http_headers.value.name
              value = http_headers.value.value
            }
          }

          source_addresses      = rule.value.source_addresses
          source_ip_groups      = rule.value.source_ip_groups
          destination_fqdns     = rule.value.destination_fqdns
          destination_fqdn_tags = rule.value.destination_fqdn_tags
          destination_addresses = rule.value.destination_addresses
          destination_urls      = rule.value.destination_urls
          terminate_tls         = rule.value.terminate_tls
          web_categories        = rule.value.web_categories
        }
      }
    }
  }

  dynamic "network_rule_collection" {
    for_each = lookup(each.value, "network_rule_collections", [])
    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules
        content {
          name                  = rule.value.name
          protocols             = rule.value.protocols
          source_addresses      = rule.value.source_addresses
          source_ip_groups      = rule.value.source_ip_groups
          destination_addresses = rule.value.destination_addresses
          destination_ip_groups = rule.value.destination_ip_groups
          destination_fqdns     = rule.value.destination_fqdns
          destination_ports     = rule.value.destination_ports
        }
      }
    }
  }

  dynamic "nat_rule_collection" {
    for_each = lookup(each.value, "nat_rule_collections", [])
    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = nat_rule_collection.value.action

      dynamic "rule" {
        for_each = nat_rule_collection.value.rules
        content {
          name = rule.value.name
          description         = rule.value.description
          protocols           = rule.value.protocols
          source_addresses    = rule.value.source_addresses
          source_ip_groups    = rule.value.source_ip_groups
          destination_address = rule.value.destination_address
          destination_ports   = rule.value.destination_ports
          translated_address  = rule.value.translated_address
          translated_fqdn     = rule.value.translated_fqdn
          translated_port     = rule.value.translated_port
        }
      }
    }
  }
  depends_on = [azurerm_firewall_policy.firewall_policies]
}

######Azure Front Door Policy ###################################################

resource "azurerm_frontdoor_firewall_policy" "firewall_policies_front_door" {
  for_each = var.firewall_policies_front_door

  name                              = each.value.name
  resource_group_name               = each.value.resource_group_name
  enabled                           = lookup(each.value, "enabled", true)
  mode                              = lookup(each.value, "mode", "Prevention")
  redirect_url                      = lookup(each.value, "redirect_url", "https://www.google.com")
  custom_block_response_status_code = lookup(each.value, "custom_block_response_status_code", 403)
  custom_block_response_body        = lookup(each.value, "custom_block_response_body", null)
  tags                              = try(each.value.tags, null)

  dynamic "custom_rule" {
    for_each = lookup(each.value, "custom_rule", [])
    content {
      name                           = custom_rule.value.name
      enabled                        = lookup(custom_rule.value, "enabled", true)
      priority                       = custom_rule.value.priority
      rate_limit_duration_in_minutes = custom_rule.value.rate_limit_duration_in_minutes
      rate_limit_threshold           = custom_rule.value.rate_limit_threshold
      type                           = custom_rule.value.type
      action                         = custom_rule.value.action

      dynamic "match_condition" {
        for_each = custom_rule.value.match_conditions
        content {
          match_variable     = match_condition.value.match_variable
          operator           = match_condition.value.operator
          negation_condition = lookup(match_condition.value, "negation_condition", false)
          match_values       = match_condition.value.match_values
          transforms         = lookup(match_condition.value, "transforms", [])
          selector           = lookup(match_condition.value, "selector", null)
        }
      }
    }
  }

  dynamic "managed_rule" {
    for_each = try(each.value.managed_rule, [])
    content {
      type    = managed_rule.value.type
      version = managed_rule.value.version

      dynamic "exclusion" {
        for_each = try(managed_rule.value.exclusion, [])
        content {
          match_variable = exclusion.value.match_variable
          operator       = exclusion.value.operator
          selector       = exclusion.value.selector
        }
      }
      dynamic "override" {
        for_each = try(managed_rule.value.override, [])
        content {
          rule_group_name = override.value.rule_group_name

          dynamic "exclusion" {
            for_each = try(override.value.exclusion, [])
            content {
              match_variable = exclusion.value.match_variable
              operator       = exclusion.value.operator
              selector       = exclusion.value.selector
            }
          }

          dynamic "rule" {
            for_each = try(override.value.rule, [])
            content {
              rule_id = rule.value.rule_id
              action  = rule.value.action
              enabled = lookup(rule.value, "enabled", false)
              dynamic "exclusion" {
                for_each = try(rule.value.exclusion, [])
                content {
                  match_variable = exclusion.value.match_variable
                  operator       = exclusion.value.operator
                  selector       = exclusion.value.selector
                }
              }
            }
          }
        }
      }
    }
  }
}


##############Web application policy ################################################

resource "azurerm_web_application_firewall_policy" "web_application_firewall_policies" {
  for_each = var.web_application_firewall_policies

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  tags                = each.value.tags

  dynamic "custom_rules" {
    for_each = lookup(each.value, "custom_rules", [])
    content {
      name                 = try(custom_rules.value.name, null)
      enabled              = lookup(custom_rules.value, "enabled", true)
      priority             = try(custom_rules.value.priority, null)
      rule_type            = try(custom_rules.value.rule_type, null)
      action               = try(custom_rules.value.action, null)
      rate_limit_duration  = try(custom_rules.value.rate_limit_duration, null)
      rate_limit_threshold = try(custom_rules.value.rate_limit_threshold, null)
      group_rate_limit_by  = try(custom_rules.value.group_rate_limit_by, null)

      dynamic "match_conditions" {
        for_each = lookup(custom_rules.value, "match_conditions", [])
        content {
          dynamic "match_variables" {
            for_each = lookup(match_conditions.value, "match_variables", [])
            content {
              variable_name = match_variables.value.variable_name
              selector      = lookup(match_variables.value, "selector", null)
            }
          }

          operator           = match_conditions.value.operator
          negation_condition = lookup(match_conditions.value, "negation_condition", false)
          match_values       = lookup(match_conditions.value, "match_values", [])
          transforms         = lookup(match_conditions.value, "transforms", [])
        }
      }


    }
  }

  policy_settings {
    enabled                                   = each.value.policy_settings.enabled
    mode                                      = each.value.policy_settings.mode
    request_body_check                        = each.value.policy_settings.request_body_check
    file_upload_limit_in_mb                   = each.value.policy_settings.file_upload_limit_in_mb
    max_request_body_size_in_kb               = each.value.policy_settings.max_request_body_size_in_kb
    request_body_enforcement                  = each.value.policy_settings.request_body_enforcement
    request_body_inspect_limit_in_kb          = each.value.policy_settings.request_body_inspect_limit_in_kb
    js_challenge_cookie_expiration_in_minutes = each.value.policy_settings.js_challenge_cookie_expiration_in_minutes

    dynamic "log_scrubbing" {
      for_each = lookup(each.value.policy_settings, "log_scrubbing", [])
      content {
        enabled = lookup(log_scrubbing.value, "enabled", true)
        dynamic "rule" {
          for_each = lookup(log_scrubbing.value, "rule", [])
          content {
            enabled                 = lookup(rule.value, "enabled", true)
            match_variable          = lookup(rule.value, "match_variable", "RequestHeaderNames")
            selector                = lookup(rule.value, "selector", "Authorization")
            selector_match_operator = lookup(rule.value, "selector_match_operator", "Equals")
          }
        }
      }
    }
  }

  dynamic "managed_rules" {
    for_each = lookup(each.value, "managed_rules", [])
    content {
      dynamic "exclusion" {
        for_each = lookup(managed_rules.value, "exclusions", [])
        content {
          match_variable          = exclusion.value.match_variable
          selector                = exclusion.value.selector
          selector_match_operator = lookup(exclusion.value, "selector_match_operator", null)

          dynamic "excluded_rule_set" {
            for_each = lookup(exclusion.value, "excluded_rule_set", [])
            content {
              type    = excluded_rule_set.value.type
              version = excluded_rule_set.value.version

              dynamic "rule_group" {
                for_each = lookup(excluded_rule_set.value, "rule_group", [])
                content {
                  rule_group_name = rule_group.value.rule_group_name
                  excluded_rules  = rule_group.value.excluded_rules
                }
              }
            }
          }
        }
      }

      managed_rule_set {
        type    = managed_rules.value.managed_rule_set.type
        version = managed_rules.value.managed_rule_set.version

        dynamic "rule_group_override" {
          for_each = lookup(managed_rules.value.managed_rule_set, "rule_group_override", [])
          content {
            rule_group_name = rule_group_override.value.rule_group_name

            dynamic "rule" {
              for_each = lookup(rule_group_override.value, "rules", [])
              content {
                id      = rule.value.id
                enabled = lookup(rule.value, "enabled", true)
                action  = rule.value.action
              }
            }
          }
        }
      }
    }
  }
}




