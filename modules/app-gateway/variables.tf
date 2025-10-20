variable "rg_name" {}
variable "location" {}
variable "name" {}
variable "subnet_id" {}
variable "backend_ip_addresses" { type = list(string) }
variable "tags" { type = map(string) }
