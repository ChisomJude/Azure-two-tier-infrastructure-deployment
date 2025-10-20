output "id"  { value = local.kv_id }
output "name"{ value = local.kv_name }

#passing this to the VM module so it can read the secret
output "admin_password_secret_id" {
  value = local.kv_id
}
