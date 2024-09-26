variable "create_defender" {
  type = map(object({
    storage_account_id                          = string
    override_subscription_settings_enabled      = optional(bool)
    malware_scanning_on_upload_enabled          = optional(bool)
    malware_scanning_on_upload_cap_gb_per_month = optional(number)
    scan_results_event_grid_topic_id            = optional(bool)
    sensitive_data_discovery_enabled            = optional(bool)
  }))

  nullable  = false
  sensitive = false

}