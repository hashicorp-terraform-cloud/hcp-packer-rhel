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

  os_type = "Linux"

  shared_image_gallery {
    subscription   = "${var.subscription_id}"
    resource_group = data.hcp-packer-image.azure-rhel9.labels["sig_resource_group"]
    gallery_name   = data.hcp-packer-image.azure-rhel9.labels["sig_name"]
    image_name     = data.hcp-packer-image.azure-rhel9.labels["sig_image_name"]
    image_version  = data.hcp-packer-image.azure-rhel9.labels["sig_image_version"]
  }

  shared_image_gallery_destination {
    subscription         = "${var.subscription_id}"
    resource_group       = data.hcp-packer-image.azure-rhel9.labels["sig_resource_group"]
    gallery_name         = data.hcp-packer-image.azure-rhel9.labels["sig_name"]
    image_name           = "${data.hcp-packer-image.azure-rhel9.labels["sig_image_name"]}-httpd"
    image_version        = data.hcp-packer-image.azure-rhel9.labels["sig_image_version"]
    replication_regions  = ["uksouth"]
    storage_account_type = "Standard_LRS"
  }

  plan_info {
    plan_name      = "rhel-lvm91-gen2"
    plan_product   = "rhel-byos"
    plan_publisher = "redhat"
  }

  location = "uksouth"
  vm_size  = "Standard_D2as_v4"

}

build {

  hcp_packer_registry {
    bucket_name = "rhel-httpd"
    description = <<EOT
A child image containing an application
    EOT
    bucket_labels = {
      "os"      = "Red Hat Enterprise Linux"
      "vendor"  = "Red Hat"
      "owner"   = "ben.holmes@hashicorp.com"
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


