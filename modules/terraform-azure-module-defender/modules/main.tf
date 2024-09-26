resource "azurerm_security_center_storage_defender" "defender" {
  for_each                                    = var.create_defender
  storage_account_id                          = each.value["storage_account_id"]
  override_subscription_settings_enabled      = each.value["override_subscription_settings_enabled"]
  malware_scanning_on_upload_enabled          = each.value["malware_scanning_on_upload_enabled"]
  malware_scanning_on_upload_cap_gb_per_month = each.value["malware_scanning_on_upload_cap_gb_per_month"]
  scan_results_event_grid_topic_id            = each.value["scan_results_event_grid_topic_id"]
  sensitive_data_discovery_enabled            = each.value["sensitive_data_discovery_enabled"]
}