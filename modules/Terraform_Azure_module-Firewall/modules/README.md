# Terraform Module for AZURE FIREWALL

## This module creates following resources :
1) Multiple Firewalls in one module call 
2) Multiple Collection like application_rule_collection, NAT_rule_collection and Network_rule_connection and we can dynamically attach theseCollections to Firewall as per our choice
3) We can also add already made Firewall policy as well


## Module Usage

### Description

Azure Firewall is a cloud-native, managed network security service that protects Azure Virtual Network resources. It provides advanced threat protection with high availability and scalability. Key features include built-in high availability, centralized policy management, and fully stateful firewall capabilities. Options include Azure Firewall Standard (for general network security) and Azure Firewall Premium (with advanced features like TLS inspection, IDPS, and URL filtering). It integrates with Azure Monitor for enhanced logging and analytics.

**Please refer to "sample" folder for complete and  minimalistic example.**

1. complete_main.tf
2. minimalistic_main.tf

## Requirements 
| Name      | Version  |
|-----------|----------|
| Terraform | ~> 1.5.0 |

## Providers
| Name | Version   |
|------|-----------|
| Azure  | "~>4.0"|


# Inputs

 Variable Name             | Type         | Description                                                                | Default  | Required | Accepted Values                     | modification forces recreation 
-------------------------|--------------|----------------------------------------------------------------------------|----------|----------|-------------------------------------|--------------------------------
 create_firewalls                          | map(object)  | Create map of firewall (attribute of map of objet define below)                 | {}       | Yes      | Values                              | Yes                            
 name                           | string       | Name for firewall (part of map of object)                             |         | Yes       | "my-firewall-1"                     | Yes                            
 resource_group_name                     | string       | resource_group_name for firewall  (part of map of object)                      |          | yes       | "Resource group name which is created already            | Yes                            
 location                    | string       | location for firewall  (part of map of object)                     |         |    Yes    | "Region Name"                   | Yes                          
 sku_name                  | string       | sku_name for firewall  (part of map of object)                   |          | Yes       | "AZFW_Hub" or "AZFW_VNet"          | Yes                          
 sku_tier                      | string       | sku_tier for firewall  (part of map of object)                       |         | Yes       | "Basic" or "Standard" or "Premium"           | No                             
 threat_intel_mode                    | string       | IPv6 threat_intel_mode for Firewall  (part of map of object)                     |  Alert        | No       | "Off" or "Alert" or "Deny"                 | No                             
 zones                  | list(String)       | zones for Firewall  (part of map of object)                   |         | No       | ["1", "2", "3"]                                  | Yes                             
 dns_servers | list(string)       | dns_servers for firewall   (part of map of object) |        | No       | list of servers                       | No                             
dns_proxy_enabled                   | bool         | dns_proxy_enabled for firewall  (part of map of object)                    | True     | No       | "true" or "false"                          | No                             
 ip_configuration     | list(string)         | ip_configuration for firewall  (part of map of object)      | IP and subnet/26    | Yes      | public IP ID and Subnet ID of Azure firewall subnet                          | Yes   
 create_firewalls.private_ip_ranges    | list(string)| private_ip_ranges (part of map of object)                |                     | No       | "IANAPrivateRanges"    | No       |
| ip_configuration.name                 | string      | Name of IP_configuration (part of map of object)         |                | Yes      | Name changes to different | No    |                          
 management_ip_configuration                                 | list(object)  | management_ip_configuration for firewall   (part of map of object)                                 |          | No       | Key-pair values (ex. Name = "test") | Yes    
 management_ip_configuration.ip_address   | string      | Management IP configuration for firewall (part of map of object) |             | Yes      | If management_ip_configuration yes   | No       |                         
 virtual_hub_id                     | list(object)  | virtual_hub_id for firewall  (attribute of map of object define below)   |      |No       |      Virtual_hub_id                  | Yes                             
 firewall_policy                           | string       | firewall_policy for firewall  (part of map of object)                |        | No       | "firewall ID if created and used instead of Rule collection"                      | No
 ####Application rule ##################                          
application_rule_collection      | map(object)  | application rule for firewall (part of map of object)                      |    {}      | Yes       | {} | Yes                             
name                | string       | Name for firewall (part of map of object)                             |         | Yes       | "rule name"                     | Yes       |                                     | yes                             
 azure_firewall_name                           | string       | azure_firewall_name (part of map of object)               |         | Yes       | "firewall name which will get from firewall resource"       | Yes                            
 resource_group_name                     | string       | resource_group_name for firewall  (part of map of object)     |          | yes       | "Resource group name which is created already            | Yes 
 priority | number | priority for application rule (part of map of object) |  | Yes | Range between "100 - 65000" | No
  action | string | action for application rule (part of map of object) |  | Yes | allow or Deny | No
  rules | list (object) | rules for Firewall(part of map of object) (under rules Name is nd require and description, source_address and Source group is optional) |  | Yes |  | No
  #####NAT_RULE######
  NAT_Rule | map(object) | Nat_rule (part of map of object)                      |    {}      | Yes       | {} | Yes 
  name                | string       | Name for firewall (part of map of object)                             |          | Yes       | "rule name"                     | Yes       |                                     | yes                             
  azure_firewall_name                           | string       | azure_firewall_name (part of map of object)               |          | Yes       | "firewall name which will get from firewall resource"       | Yes                            
  resource_group_name                     | string       | resource_group_name for firewall  (part of map of object)     |         | yes       | "Resource group name which is created already            | Yes 
  priority | number | priority for application rule (part of map of object) |  | Yes | Range between "100 - 65000" | No
  action | string | action for application rule (part of map of object) |  | Yes | Dnat or Snat | No
  rules | list (object) | rules for Firewall(part of map of object) (under rules Name is nd require and description, source_address and Source group is optional) |  | Yes | {} | No 
  destination_addresses(under rule) | list(string) | destination_addresses for firewall rule (part of map of object) |  | Yes | list of IP of IP range | NO
  destination_ports (under the rule) | list(string) | destination_ports (part of map of object) | | Yes | {} | No
  protocols (under the rule) | list(string) | protocols of firewall rule (part of map of object)| If action is Dnat, protocols can only be TCP and UDP | Yes | Any, ICMP, TCP and UDP | No
  translated_address (under the rule) | string | translated_address for firewall rule (part of map of object) |  | Yes | {} | No
  translated_port (under the rule) | number | translated_port (part of map of object) |  | Yes  | {} | No
  #####network_rule_collection####
  network_rule_collection | map(object)| network_rule_collection for Firewall |  | Yes | {} | Yes
  name                | string       | Name for firewall (part of map of object)                             |          | Yes       | "rule name"                     | Yes       |                                     | yes                             
  azure_firewall_name                           | string       | azure_firewall_name (part of map of object)               |          | Yes       | "firewall name which will get from firewall resource"       | Yes                            
  resource_group_name                     | string       | resource_group_name for firewall  (part of map of object)     |         | yes       | "Resource group name which is created already            | Yes 
  priority | number | priority for application rule (part of map of object) | | Yes | Range between "100 - 65000" | No
  action | string | action for application rule (part of map of object) |  | Yes | Dnat or Snat | No
  rules | list (object) | rules for Firewall(part of map of object) (under rules Name is nd require and description, source_address and Source group, destination_addresses, destination_ip_groups,destination_fqdns is optional) |  | Yes | {} | No 
  protocols (under the rule) | list(string) | protocols of firewall rule (part of map of object)|  | Yes | Any, ICMP, TCP and UDP | No
destination_ports (under the rule) | list(string) | destination_ports (part of map of object) | | Yes | {} | No
 network_rule_collection.rules.source_addresses     | list(string)| source_addresses (part of map of object)  |   | No       | {}           | No                             |
| network_rule_collection.rules.source_ip_groups     | list(string)| source_ip_groups (part of map of object)  |     | No       | {}           | No                             |
| network_rule_collection.rules.destination_addresses`| list(string)| destination_addresses (part of map of object)|   | No       | {}          | No                             |
| network_rule_collection.rules.destination_ip_groups| list(string)| destination_ip_groups (part of map of object)|   | No       | {}            | No                             |
| network_rule_collection.rules.destination_fqdns    | list(string)| destination_fqdns (part of map of object) |    | No       |{}             | No     |

    




# Outputs

| Output Name              | Description                                      |
|--------------------------|--------------------------------------------------|
| Azure Firewall ID                   | ID of the Firewall                    |
| firewall_names                      | Firewall Name                        |
| ip_configuration                    | private_ip_address of the IP_Configuration       |
| firewall_virtual_hub_public         | public_ip_address of the Virtual ID       |
|firewall_virtual_hub_private         | private_ip_address of the Virtual ID |


## Notes


## Authors
mohammedirfan@cloudxsupport.com

## Contributors


## Team DL
devops@cloudxchange.io


