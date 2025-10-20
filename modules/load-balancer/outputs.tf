output "public_ip" {
  description = "Public IP address of the Standard Load Balancer"
  value       = azurerm_public_ip.pip.ip_address
}

output "backend_pool_id" {
  description = "Backend address pool id"
  value       = azurerm_lb_backend_address_pool.bepool.id
}
