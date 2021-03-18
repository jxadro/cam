variable "ssh_key_name" {
  type        = string
  description = "SSH Key Name in IBM Cloud"
}

variable "instance_name" {
  type        = string
  description = "Server instance name"
}

variable "region" {
  type        = string
  description = "VPC Region"
}

variable "resource_group" {
  type        = string
  description = "Resource Group"
}

variable "vpc" {
  type        = string
  description = "VPC Name"
}

variable "security_group" {
  type        = string
  description = "Security Group Name"
}

variable "subnet" {
  type        = string
  description = "Subnet name"
}

variable "size" {
  type        = string
  description = "IBM Cloud Profile"
}

variable "zone" {
  type        = string
  description = "Zone"
}

