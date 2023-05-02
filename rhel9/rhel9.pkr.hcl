source "azure-arm" "rhel9" {
  client_id       = "${env("ARM_CLIENT_ID")}"
  client_secret   = "${env("ARM_CLIENT_SECRET")}"
  subscription_id = "${env("ARM_SUBSCRIPTION_ID")}"
  tenant_id       = "${env("ARM_TENANT_ID")}"

  ssh_username = "${var.ssh_username}"

  shared_image_gallery_destination {
    subscription         = "${env("ARM_SUBSCRIPTION_ID")}"
    resource_group       = "benh-packer-builds"
    gallery_name         = "benh_packer_image_gallery"
    image_name           = "packer-rhel91"
    image_version        = "9.1.0"
    replication_regions  = ["uksouth"]
    storage_account_type = "Standard_LRS"
  }

  plan_info {
    plan_name      = "rhel-lvm91-gen2"
    plan_product   = "rhel-byos"
    plan_publisher = "redhat"
  }

  os_type         = "Linux"
  image_publisher = "redhat"
  image_offer     = "rhel-byos"
  image_sku       = "rhel-lvm91-gen2"

  location = "uksouth"
  vm_size  = "Standard_D2as_v4"
}

build {

  hcp_packer_registry {
    bucket_name = "rhel9"
    description = <<EOT
Some nice description about the image being published to HCP Packer Registry.
    EOT
    bucket_labels = {
      "os"     = "Red Hat Enterprise Linux"
      "vendor" = "Red Hat"
      "owner"  = "ben.holmes@hashicorp.com"
    }
  }

  sources = ["sources.azure-arm.rhel9"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline = [
      "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]
    inline_shebang = "/bin/sh -x"
  }
}


