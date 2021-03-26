locals {
  BASENAME = "jordax"
  ZONE     = "us-south-1"
}

data "ibm_is_security_group" "sg1" {
  name = "jordax-sg1"
}

output "sg" {
  value = data.ibm_is_security_group.sg1
}
