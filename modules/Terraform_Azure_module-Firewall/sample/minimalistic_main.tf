/*module "Azure_firewall" {
  source = "../modules"
  create_firewalls = {
    firewall1 = {
      name                = "my-firewall-1"
      resource_group_name = "terra-test"
      location            = "East US"
      sku_name            = "AZFW_VNet"
      sku_tier            = "Standard"
      firewall_policy_id  = "/subscriptions/23615ce4-ba17-4a79-8be5-0313e1d540b4/resourceGroups/terra-test/providers/Microsoft.Network/firewallPolicies/terra-policy"
      zones               = ["1"]
      ip_configuration = [
        {
          name                 = "my-ip-config"
        }
      ]
      management_ip_configuration = [
        {
          name                 = "my-management-ip-config"
          public_ip_address_id = "/subscriptions/23615ce4-ba17-4a79-8be5-0313e1d540b4/resourceGroups/terra-test/providers/Microsoft.Network/publicIPAddresses/terraform-pub-02"
          subnet_id            = "/subscriptions/23615ce4-ba17-4a79-8be5-0313e1d540b4/resourceGroups/terra-test/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/AzureFirewallManagementSubnet"
        }
      ]
      virtual_hub_id = [
        {
          virtual_hub_id  = "/subscriptions/23615ce4-ba17-4a79-8be5-0313e1d540b4/resourceGroups/terra-test/providers/Microsoft.Network/virtualHubs/vwan-virtualhub"
          }
      ]
    }
  }

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
        }]
    }
  }
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
            destination_ports     = ["53"]
            destination_addresses = ["20.242.230.95"]
            protocols             = ["TCP", "UDP"]
            translated_port       = 53
            translated_address    = "8.8.8.8"
          }
      ]
    }
    }
    network_rule_collection = {
    rule_collection_1 = {
      azure_firewall_name = "my-firewall-1"
      resource_group_name = "terra-test"
      priority            = 100
      action              = "Allow"
      rules = [
        {
          name                  = "rule1"
          destination_ports     = ["53"]
          protocols             = ["TCP", "UDP"]
        }
      ]
    }
    }
}*/


