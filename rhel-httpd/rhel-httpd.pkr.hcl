locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

data "hcp-packer-image" "azure-rhel9" {
  bucket_name    = "rhel9"
  channel        = "latest"
  cloud_provider = "azure"
  region         = "uksouth"
}

source "azure-arm" "rhel-httpd" {
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"

  ssh_username = "${var.ssh_username}"

  os_type                                  = data.hcp-packer-image.azure-rhel9.labels["os_type"]
  custom_managed_image_name                = data.hcp-packer-image.azure-rhel9.labels["managed_image_name"]
  custom_managed_image_resource_group_name = data.hcp-packer-image.azure-rhel9.labels["managed_image_resourcegroup_name"]

  managed_image_resource_group_name = "benh-packer-builds"
  managed_image_name                = "packer-rhel9-httpd-${local.timestamp}"

  location = "uksouth"
  vm_size  = "Standard_D2as_v4"

  plan_info {
    plan_name      = "rhel-lvm91-gen2"
    plan_product   = "rhel-byos"
    plan_publisher = "redhat"
  }
}

build {

  hcp_packer_registry {
    bucket_name = "rhel-httpd"
    description = <<EOT
Some nice description about the image being published to HCP Packer Registry.
    EOT
    bucket_labels = {
      "os"     = "Red Hat Enterprise Linux",
      "vendor" = "Red Hat"
      "owner"  = "ben.holmes@hashicorp.com"
      "product" = "httpd"
    }
  }

  sources = ["sources.azure-arm.rhel-httpd"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline = [
      "sudo dnf -y upgrade",
      "sudo dnf -y install httpd",
      "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]
    inline_shebang = "/bin/sh -x"
  }
}


