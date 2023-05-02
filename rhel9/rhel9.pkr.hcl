source "azure-arm" "rhel9" {
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"

  ssh_username = "${var.ssh_username}"

  shared_image_gallery_destination {
    subscription         = "${var.subscription_id}"
    resource_group       = "benh-packer-builds"
    gallery_name         = "benh_packer_image_gallery"
    image_name           = "packer-rhel91"
    image_version        = "9.1.1"
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


