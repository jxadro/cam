locals {
  BASENAME = "jordax"
  var.size == "dev" ? "cx2-2x4" : var.size == "pro" ? "cx2-2x4" : "cx2-2x4"
  
}

provider "ibm" {
  region = var.region
  generation = 2
  resource_group = var.resource_group
}

data "ibm_is_vpc" "vpc" {
  name = var.vpc
}

data "ibm_is_security_group" "sg1" {
  name = var.security_group
}


data "ibm_is_subnet" "subnet1" {
  name = var.subnet
}

data "ibm_is_image" "ubuntu" {
  name = "ibm-centos-7-6-minimal-amd64-2"
}

data "ibm_is_ssh_key" "ssh_key_id" {
  name = var.ssh_key_name
}

data "ibm_resource_group" "group" {
  name = var.resource_group
}


resource "ibm_is_instance" "vsi1" {
  name    = "${local.BASENAME}-${var.instance_name}"
  vpc     = data.ibm_is_vpc.vpc.id
  zone    = var.zone
  keys    = [data.ibm_is_ssh_key.ssh_key_id.id]
  image   = data.ibm_is_image.ubuntu.id
  profile = var.size
  resource_group = data.ibm_resource_group.group.id

  primary_network_interface {
    subnet          = data.ibm_is_subnet.subnet1.id
    security_groups = [data.ibm_is_security_group.sg1.id]
  }
}

resource "ibm_is_floating_ip" "fip1" {
  name   = "${local.BASENAME}-${var.instance_name}-fip1"
  target = ibm_is_instance.vsi1.primary_network_interface[0].id
}


output "ip" {
  value = ibm_is_floating_ip.fip1.address
}

output "ssh" {
  value = ibm_is_ssh_key.ssh_key_id.fingerprint
}

