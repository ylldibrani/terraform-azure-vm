variable "resource_group" {
  default  = "terraform-rg"
  describe = "Terraform resource group name"
}

variable "location" {
  default  = "eastus"
  describe = "Terraform services location"
}

variable "virtual_network" {
  default  = "terraform-vn"
  describe = "Terraform virtual network name"
}

variable "subnet" {
  default  = "terraform-subnet"
  describe = "Terraform subnet name"
}

variable "terraform-public-ip" {
  default  = "terraform-public-ip"
  describe = "Terraform public ip name"
}


variable "terraform-nsg" {
  default  = "terraform-nsg"
  describe = "Terraform network security group name"
}

variable "terraform-ni" {
  default  = "terraform-ni"
  describe = "Terraform network interface name"
}

variable "terraform-vm" {
  default  = "terraform-vm"
  describe = "Terraform virtual machine name"
}

variable "username" {
  default  = "yll"
  describe = "Terraform virtual machine username"
}

variable "password" {
  default  = "yWcDt3Fkz5ZbfvpK"
  describe = "Terraform virtual machine password"
}
