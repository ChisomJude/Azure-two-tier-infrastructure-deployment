resource "azurerm_availability_set" "web_avset" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  platform_update_domain_count = 5
  platform_fault_domain_count  = 2
  managed = true
  tags   = var.tags
}
