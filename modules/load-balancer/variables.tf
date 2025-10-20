variable "rg_name" {}
variable "location" {}
variable "name" {}
variable "backend_nic_ids" { type = list(string) }
variable "tags" { type = map(string) }
