module "firewall_policies" {
  source = "../modules"

  firewall_policies = {
    "policy1" = {
      name                              = "example-policy-1"
      resource_group_name               = "terra-test"
      location                          = "East US"
      dns                               = { servers = ["10.0.0.2"] }
      identity                          = { type = "UserAssigned" }
      auto_learn_private_ranges_enabled = true
      sku                               = "Premium"
      tags                              = { environment = "dev" }
      threat_intelligence_mode          = "Deny"
      private_ip_ranges                 = ["10.0.0.0/8", "192.168.0.0/16"]
      threat_intelligence_allowlist = {
        ip_addresses = ["203.0.113.1", "198.51.200.1"]
        fqdns        = ["example.com", "test1.com"]
      }
      sql_redirect_allowed = false
      explicit_proxy = {
        enabled    = true
        http_port  = 8080
        https_port = 8443
      }
    },
  }

  ################################################################
  ############       Rule_collection Group    ####################
  ################################################################


  firewall_policy_rule_collection_groups = {
    example1 = {
      name               = "example-fwpolicy-rcg1"
      firewall_policy_id = module.firewall_policies.firewall_policy_id["policy1"]
      priority           = 500
      application_rule_collections = [
        {
          name     = "app_rule_collection1"
          priority = 500
          action   = "Allow"
          rules = [
            {
              name = "app_rule_collection1_rule1"
              protocols = [
                {
                  type = "Http"
                  port = "80"
                },
                {
                  type = "Https"
                  port = "443"
                }
              ]
              http_headers = [
                {
                  name  = "X-Custom-Header"
                  value = "custom-value"
                },
                {
                  name  = "Authorization"
                  value = "Bearer token"
                }
              ]
              source_addresses      = ["10.0.0.0/24"]
              source_ip_groups      = ["group1", "group2"]
              destination_urls      = ["*.google.com"]
              destination_fqdns     = ["google.com"] # Destination_urls and Destination_fqdns won't work together
              destination_fqdn_tags = ["tag1", "tag2"]
              destination_addresses = ["192.168.1.1", "192.168.1.2"]
              terminate_tls         = true
              web_categories        = ["News"]
            }
          ]
        }
      ]
      network_rule_collections = [
        {
          name     = "network_rule_collection1"
          priority = 400
          action   = "Allow"
          rules = [
            {
              name                  = "network_rule_collection1_rule1"
              protocols             = ["TCP", "UDP"]
              source_addresses      = ["10.0.3.0/24"]
              destination_addresses = ["192.168.1.1", "192.168.1.2"]
              destination_ports     = ["80", "2000"]
              source_ip_groups      = ["Source-group"]
              destination_ip_groups = ["group1", "group2"]
              destination_fqdns     = ["google.com"] #  network_rule_collection1_rule1 should have only one of destinationAddresses, destinationIpGroups or destinationFqdns
            }
          ]
        }
      ]
      nat_rule_collections = [
        {
          name     = "nat_rule_collection1"
          priority = 300
          action   = "Dnat"
          rules = [
            {
              name                = "nat_rule_collection1_rule1"
              description         = " for nat rule"
              protocols           = ["TCP", "UDP"]
              source_addresses    = ["10.0.1.0/24"]
              source_ip_groups    = ["Source-group"]
              destination_address = "192.0.2.1"
              destination_ports   = ["8080"]
              translated_address  = "10.0.2.1"
              translated_fqdn     = optional(string) # only work if destination_address is not available
              translated_port     = "80"
            }
          ]
        }
      ]
    }
  }

  ##########################################################################
  #################        frontdoor_policy          #######################
  ##########################################################################
  firewall_policies_front_door = {
    "front_door_policy1" = {
      name                              = "examplefdwafpolicy01"
      resource_group_name               = "terra-test"
      enabled                           = true
      mode                              = "Prevention"
      redirect_url                      = "https://www.example.com"
      custom_block_response_status_code = 403
      custom_block_response_body        = "QWNjZXNzIERlbnllZA=="
      tags = {
        Environment = "Production"
        Project     = "Firewall"
      }
      custom_rule = [
        {
          name                           = "Rule1"
          enabled                        = true
          priority                       = 1
          rate_limit_duration_in_minutes = 1
          rate_limit_threshold           = 10
          type                           = "MatchRule"
          action                         = "Allow"
          match_conditions = [
            {
              match_variable     = "RequestHeader"
              operator           = "Equal"
              match_values       = ["192.168.2.0/24", "10.0.0.0/24"]
              transforms         = ["Lowercase"]
              selector           = "RequestHeader"
              negation_condition = false
            }
          ]
        }
      ]
      managed_rule = [
        {
          type    = "Microsoft_DefaultRuleSet"
          version = "1.1"
          exclusion = [
            {
              match_variable = "QueryStringArgNames"
              operator       = "Contains"
              selector       = "not_suspicious"
            }
          ]
          override = [
            {
              rule_group_name = "MS-ThreatIntel-CVEs"
              exclusion = [
                {
                  match_variable = "QueryStringArgNames"
                  operator       = "Equals"
                  selector       = "not_suspicious"
                }
              ]
              rule = [
                {
                  rule_id = "99001015"
                  enabled = true
                  action  = "Allow"
                  exclusion = [
                    {
                      match_variable = "QueryStringArgNames"
                      operator       = "Equals"
                      selector       = "not_suspicious"
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
  }


  ##########################################################
  ########      web application firewall policy      #######
  ##########################################################

  web_application_firewall_policies = {
    waf_policy_1 = {
      name                = "wafpolicy01"
      resource_group_name = "terra-test"
      location            = "East US"
      tags                = { environment = "dev" }

      custom_rules = [
        {
          name                 = "Rule1"
          enabled              = true
          priority             = 1
          rule_type            = "RateLimitRule"
          action               = "Block"
          rate_limit_duration  = "FiveMins"
          rate_limit_threshold = 1000
          group_rate_limit_by  = "GeoLocation"
          match_conditions = [
            {
              match_variables    = [{ variable_name = "RequestHeaders", selector = "UserAgent" }],
              operator           = "Contains",
              negation_condition = true,
              match_values       = ["192.168.1.0/24"]
              transforms         = ["Lowercase"]
            }
          ]
        },
        {
          name                 = "Rule2"
          enable               = true
          priority             = 2
          rule_type            = "MatchRule"
          action               = "Block"
          rate_limit_duration  = "OneMin"
          rate_limit_threshold = 1000
          group_rate_limit_by  = "GeoLocation"
          match_conditions = [
            {
              match_variables    = [{ variable_name = "RequestHeaders", selector = "UserAgent" }],
              operator           = "IPMatch",
              negation_condition = false,
              match_values       = ["192.168.1.0/24"]
              transforms         = ["Lowercase"]
            }
          ]
        }
      ]

      policy_settings = {
        enabled                                   = true
        mode                                      = "Prevention"
        request_body_check                        = true
        file_upload_limit_in_mb                   = 100
        max_request_body_size_in_kb               = 128
        request_body_enforcement                  = false
        request_body_inspect_limit_in_kb          = 256
        js_challenge_cookie_expiration_in_minutes = 15
        log_scrubbing = [
          {
            enable = true
            rule = [
              {
                enable                  = true
                match_variable          = "RequestCookieNames"
                selector                = "Authorization"
                selector_match_operator = "Equals"

              }
            ]
          }
        ]
      }

      managed_rules = [
        {
          exclusions = [
            {
              match_variable          = "RequestHeaderNames"
              selector                = "x-company-secret-header"
              selector_match_operator = "Equals"
              excluded_rule_set = [
                {
                  type    = "OWASP"
                  version = "3.2"
                  rule_group = [
                    {
                      rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
                      excluded_rules  = ["920300"]
                    }
                  ]
                }
              ]
            }
          ]
          managed_rule_set = {
            type    = "OWASP"
            version = "3.2"
            rule_group_override = [
              {
                rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
                rules = [
                  {
                    id      = "920300"
                    enabled = false
                    action  = "JSChallenge"
                  },
                  {
                    id      = "920440"
                    enabled = true
                    action  = "Block"
                  }
                ]
              }
            ]
          }
        }
      ]
    }
  }
}

