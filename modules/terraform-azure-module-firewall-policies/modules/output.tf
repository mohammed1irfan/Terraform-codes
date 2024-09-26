
output "firewall_policy_id" {
  description = "The ID of the Firewall Policy."
  value       = { for k, v in azurerm_firewall_policy.firewall_policies : k => v.id }
}

output "firewall_policy_child_policies" {
  description = "A list of reference to child Firewall Policies of this Firewall Policy."
  value       = { for k, p in azurerm_firewall_policy.firewall_policies : k => p.child_policies }
}

output "firewall_policy_firewalls" {
  description = "A list of references to Azure Firewalls that this Firewall Policy is associated with."
  value       = { for k, p in azurerm_firewall_policy.firewall_policies : k => p.firewalls }
}

output "firewall_policy_rule_collection_groups" {
  description = "A list of references to Firewall Policy Rule Collection Groups that belong to this Firewall Policy."
  value       = { for k, p in azurerm_firewall_policy.firewall_policies : k => p.rule_collection_groups }
}

output "Firewall_Policy_Rule_Collection_Group_ID" {
  description = "A list of references to Firewall Policy Rule Collection Groups that belong to this Firewall Policy."
  value       = { for k, p in azurerm_firewall_policy.firewall_policies : k => p.rule_collection_groups }
}

output "frontdoor_firewall_policy_ids" {
  description = "A list of IDs for the Front Door Firewall Policies."
  value       = { for k, p in azurerm_frontdoor_firewall_policy.firewall_policies_front_door : k => p.id }
}

output "frontdoor_firewall_policy_locations" {
  description = "A list of Azure Regions where the Front Door Firewall Policies exist."
  value       = { for k, p in azurerm_frontdoor_firewall_policy.firewall_policies_front_door : k => p.location }
}

output "frontdoor_firewall_policy_frontend_endpoint_ids" {
  description = "A list of Frontend Endpoint IDs associated with the Front Door Firewall Policies."
  value       = { for k, p in azurerm_frontdoor_firewall_policy.firewall_policies_front_door : k => p.frontend_endpoint_ids }
}

output "web_application_firewall_policy_ids" {
  description = "A list of IDs for the Web Application Firewall Policies."
  value       = { for k, p in azurerm_web_application_firewall_policy.web_application_firewall_policies : k => p.id }

}




