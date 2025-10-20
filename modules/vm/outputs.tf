output "vm_ids" {
  value = azurerm_windows_virtual_machine.vm[*].id
}

output "nic_ids" {
  value = azurerm_network_interface.nic[*].id
}

output "private_ips" {
  value = [for n in azurerm_network_interface.nic : n.ip_configuration[0].private_ip_address]
}
