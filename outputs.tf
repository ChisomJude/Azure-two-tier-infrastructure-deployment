output "resource_group" {
  value = module.rg.name
}

output "lb_public_ip" {
  value = module.lb.public_ip
}

output "appgw_public_ip" {
  value = module.appgw.public_ip
}

output "web_private_ips" {
  value = module.web_vms.private_ips
}

output "db_private_ip" {
  value = module.db_vm.private_ips[0]
}

output "key_vault_name" {
  value = module.kv.name
}

output "sql_server_fqdn" {
  value = try(module.sql[0].server_fqdn, null)
}

output "sql_database_name" {
  value = try(module.sql[0].database_name, null)
}
