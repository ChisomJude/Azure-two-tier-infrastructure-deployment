variable "rg_name"  { type = string }
variable "location" { type = string }
variable "name" { 
    type = string 
    default = "backup" 
}

variable "vm_ids" {
  type = list(string)
}

variable "total_vm_count" {
  type = number
}

variable "tags" {
  type = map(string)
}
