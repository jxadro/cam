variable "host" {
    description = "URL to retrieve approval status"
}

variable "catalogid" {
    description = "Catalg Id"
}

variable "itemid" {
    description = "Item Id"
}

variable "provider" {
    description = "Cloud Provider"
}

variable "service" {
    description = "Service description to approve"
}

variable "environment" {
    description = "Environment"
}

data "http" "create" {
  url = "http://post2get-post2get.apps.hubcluster.mcmpoc.com/?catalogid=${var.catalogid}&itemid=${var.itemid}&host=${var.host}&service=${var.service}&env=${var.environment}&provider=${var.provider}"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}



resource "local_file" "approval_status" {
    content   = ""
    filename  = "${path.module}/approval_status"
}

#########################################################
# Poll Infrastructure Management for approval status
#########################################################
resource "null_resource" "poll_endpoint" {
 provisioner "local-exec" {
    command = "/bin/bash poll_endpoint.sh $URL $USERNAME $PASSWORD $CURL_OPTIONS $WAIT_TIME $FILE"
    environment = {
      URL          = jsondecode(data.http.create.body).href
      USERNAME     = "admin"
      PASSWORD     = "n0r1t5@C"
      CURL_OPTIONS = "--insecure"
      WAIT_TIME    = 5
      FILE         = "${path.module}/approval_status"
    }
  }
  depends_on = [
    local_file.approval_status
  ]
}

#########################################################
# Output
#########################################################
output "approval_status" {
  value = "${fileexists("${local_file.approval_status.filename}") ? file("${local_file.approval_status.filename}") : ""}"
  depends_on = [
    null_resource.poll_endpoint
  ]
}
