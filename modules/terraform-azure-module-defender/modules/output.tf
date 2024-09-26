output "defender_id" {
  description = "ID of the Defender"
  value       = [for i in azurerm_security_center_storage_defender.defender : i.id]
}