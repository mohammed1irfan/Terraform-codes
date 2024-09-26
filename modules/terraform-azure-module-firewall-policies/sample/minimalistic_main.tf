module "firewall_policies" {
  source = "../modules" # Assumes the module is in the parent directory

  firewall_policies = {
    "policy1" = {
      name                = "example-policy-1"
      resource_group_name = "terra-test"
      location            = "East US"
      sku                               = "Standard"
    }
  }
  firewall_policy_rule_collection_groups {
    example1 = {
      name                = "example-fwpolicy-rcg1"
      firewall_policy_id  = module.firewall_policies.firewall_policy_id["policy1"]
      priority            = 500
      application_rule_collections = [
        {
          name     = "app_rule_collection1"
          priority = 500
          action   = "Allow"
          rules = [
            {
              name = "app_rule_collection1_rule1"
              protocols =  [
                {
                  type = "Http"
                  port = "80"
                },
                {
                  type = "Https"
                  port = "443"
                }
              ]
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
              destination_ports     = ["80", "2000"]
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
              protocols           = ["TCP", "UDP"]
            }
          ]
        }
      ]
    }
  }
  firewall_policies_front_door = {
    "front_door_policy1" = {
      name                = "examplefdwafpolicy1"
      resource_group_name = "terra-test"
      custom_rules = [
        {
          name                           = "Rule1"
          type                           = "MatchRule"
          action                         = "Block"
        }
      ]
    }
  }

  web_application_firewall_policies = {
    waf_policy_1 = {
      name                = "wafpolicy1"
      resource_group_name = "terra-test"
      location            = "East US"
    }
  }
     managed_rules = [
      managed_rule_set = {
            type    = "OWASP"
            version = "3.2"
      }
     ]
}

