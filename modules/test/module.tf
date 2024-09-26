module "storage_account_defender" {
  source = "../modules"
  create_defender = {
    "storage_defender" = {
      storage_account_id = "/subscriptions/9e1b9179-7yhj-47a9-o9ih-19a1e7383469/resourceGroups/kha-40-rg/providers/Microsoft.Storage/storageAccounts/stacount1895"
    }
  }
}