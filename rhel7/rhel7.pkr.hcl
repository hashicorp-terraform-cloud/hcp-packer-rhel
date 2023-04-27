source "azure-arm" "rhel7" {
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"

  ssh_username = "${var.ssh_username}"

  managed_image_resource_group_name = "benh-packer-builds"
  managed_image_name                = "packer-rhel7-${local.timestamp}"

  plan_info {
    plan_name      = "rhel-lvm79-gen2"
    plan_product   = "rhel-byos"
    plan_publisher = "redhat"
  }

  os_type         = "Linux"
  image_publisher = "redhat"
  image_offer     = "rhel-byos"
  image_sku       = "rhel-lvm79-gen2"

  location = "uksouth"
  vm_size  = "Standard_D2as_v4"
}

build {

  hcp_packer_registry {
    bucket_name = "rhel7"
    description = <<EOT
Some nice description about the image being published to HCP Packer Registry.
    EOT
    bucket_labels = {
      "os"     = "Red Hat Enterprise Linux",
      "vendor" = "Red Hat"
      "owner"  = "ben.holmes@hashicorp.com"
    }
  }

  sources = ["sources.azure-arm.rhel7"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline = [
      "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]
    inline_shebang = "/bin/sh -x"
  }
}


