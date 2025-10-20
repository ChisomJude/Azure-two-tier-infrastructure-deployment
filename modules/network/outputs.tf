output "vnet_name"       { value = azurerm_virtual_network.vnet.name }
output "web_subnet_id"   { value = azurerm_subnet.web.id }
output "db_subnet_id"    { value = azurerm_subnet.db.id }
output "appgw_subnet_id" { value = azurerm_subnet.appgw.id }
