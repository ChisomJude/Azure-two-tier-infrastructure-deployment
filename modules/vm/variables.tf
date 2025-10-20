variable "rg_name" {}

variable "location" {}

variable "prefix" {}

variable "vm_count" {
  type = number
}

variable "subnet_id" {}

variable "availability_set_id" {
  default = null
}

variable "vm_size" {}

variable "os_disk_size_gb" {
  type = number
}

variable "admin_username" {}

variable "admin_password_secret_id" {}

variable "tags" {
  type = map(string)
}
