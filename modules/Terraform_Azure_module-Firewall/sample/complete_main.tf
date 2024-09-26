module "Azure_firewall" {
  source = "../modules"

  create_firewalls = {
    firewall1 = {
      name                = "my-firewall-1"
      resource_group_name = "terra-test"
      location            = "East US"
      sku_name            = "AZFW_VNet"
      sku_tier            = "Standard"
      firewall_policy_id  = "/subscriptions/23615ce4-ba17-4a79-8be5-0313e1d540b4/resourceGroups/terra-test/providers/Microsoft.Network/firewallPolicies/terra-policy"
      threat_intel_mode   = "Alert"
      dns_servers         = ["198.168.0.1", "myserver"]
      dns_proxy_enabled   = true
      zones               = ["1"]
      tags = {
        environment = "production"
      }
      private_ip_ranges = ["10.0.0.0/24", "10.1.0.0/24"]
      ip_configuration = [
        {
          name                 = "my-ip-config"
          public_ip_address_id = "/subscriptions/23615ce4-ba17-4a79-8be5-0313e1d540b4/resourceGroups/terra-test/providers/Microsoft.Network/publicIPAddresses/publlic-ip-terra"
          subnet_id            = "/subscriptions/23615ce4-ba17-4a79-8be5-0313e1d540b4/resourceGroups/terra-test/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/AzureFirewallSubnet"
        }
      ]
      management_ip_configuration = [
        {
          name                 = "my-management-ip-config"
          public_ip_address_id = "/subscriptions/23615ce4-ba17-4a79-8be5-0313e1d540b4/resourceGroups/terra-test/providers/Microsoft.Network/publicIPAddresses/terraform-pub-02"
          subnet_id            = "/subscriptions/23615ce4-ba17-4a79-8be5-0313e1d540b4/resourceGroups/terra-test/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/AzureFirewallManagementSubnet"
        }
      ]
      virtual_hub = [
        {
          virtual_hub_id  = "/subscriptions/23615ce4-ba17-4a79-8be5-0313e1d540b4/resourceGroups/terra-test/providers/Microsoft.Network/virtualHubs/vwan-virtualhub"
          public_ip_count = "1"
        }
      ]
      tags = {
        environment = "production"
      }
    },

  }

  # Combine all application rule collections into one block


  application_rule_collection = {
    rule_collection1 = {
      name                = "testcollection1"
      azure_firewall_name = "my-firewall-1"
      resource_group_name = "terra-test"
      priority            = 100
      action              = "Allow"

      rules = [
        {
          name             = "testrule1"
          description      = "application_rule_collection for firewall"
          source_addresses = ["*"]
          target_fqdns     = ["*.microsoft.com"]
          fqdn_tags        = ["AppService"] # Firewall Application Rules: `fqdn_tags` cannot be used with `target_fqdns` or `protocol`
          source_ip_groups = ["source-group-1"]
          protocols = [
            {
              port = "443"
              type = "Https"
            }
          ]
        }
      ]
    },
  }

  # Combine all NAT rule collections into one block
  firewall_nat_rule_collection = {
    nat_rule_collection_1 = {
      name                = "natcollection1"
      azure_firewall_name = "my-firewall-1"
      resource_group_name = "terra-test"
      priority            = 100
      action              = "Dnat"
      rules = [
        {
          name                  = "rule1"
          description           = "nat_rule_collection for firewall"
          source_addresses      = ["10.0.0.0/16"]
          destination_ports     = ["53"]
          destination_addresses = ["20.242.230.95"]
          translated_port       = 53
          translated_address    = "8.8.8.8"
          protocols             = ["TCP", "UDP"]
          source_ip_groups      = ["source-group-1"]
        }
      ]
    },
  }

  # Combine all network rule collections into one block
  network_rule_collection = {
    rule_collection_1 = {
      azure_firewall_name = "my-firewall-1"
      resource_group_name = "terra-test"
      priority            = 100
      action              = "Allow"
      rules = [
        {
          name                  = "rule1"
          description           = "network_rule_collection for firewall"
          source_addresses      = ["10.0.0.0/16"]
          destination_ports     = ["53"]
          destination_addresses = ["8.8.8.8", "8.8.4.4"]
          protocols             = ["TCP", "UDP"]
        },
        {
          name                  = "rule2"
          source_addresses      = ["10.1.0.0/16"]
          destination_ports     = ["443"]
          destination_addresses = ["1.1.1.1"]
          protocols             = ["TCP"]
          source_ip_groups      = ["source-group-1"]
          destination_ip_groups = ["20.242.230.95"]
          destination_fqdns     = ["*.google.com"] #  destination IP addresses and FQDNs both cannot be specified
        }
      ]
    },
  }
}
