module "Azure-storage-defender" {
  source = "../modules" # Path to the directory containing the module

  # To Create multiple Storage defender 

  create_defender = {
    "storage-defender-01" = {
      storage_account_id                          = "/subscriptions/9e1b9179-t56r-56td-5tgf-19a1e7383469/resourceGroups/kha-40-rg/providers/Microsoft.Storage/storageAccounts/stacount1895"
      override_subscription_settings_enabled      = null
      malware_scanning_on_upload_enabled          = null
      malware_scanning_on_upload_cap_gb_per_month = null
      scan_results_event_grid_topic_id            = null
      sensitive_data_discovery_enabled            = null

    }

    "storage-defender-02" = {
      storage_account_id                          = "/subscriptions/9e1b9179-t56r-56td-5tgf-19a1e7383469/resourceGroups/kha-40-rg/providers/Microsoft.Storage/storageAccounts/stacount1895"
      override_subscription_settings_enabled      = null
      malware_scanning_on_upload_enabled          = null
      malware_scanning_on_upload_cap_gb_per_month = null
      scan_results_event_grid_topic_id            = null
      sensitive_data_discovery_enabled            = null

    }
  }
}
