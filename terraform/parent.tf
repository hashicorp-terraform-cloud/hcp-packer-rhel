resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group
  location = var.region

  tags = var.default_tags
}

resource "azurerm_shared_image_gallery" "gallery" {
  name                = "benh_packer_image_gallery"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  description         = "Shared image gallery for Packer builds"

  tags = var.default_tags
}

resource "azurerm_shared_image" "rhel9" {
  name                = "packer-rhel91"
  gallery_name        = azurerm_shared_image_gallery.gallery.name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Linux"
  hyper_v_generation  = "V2"

  purchase_plan {
    name      = "rhel-lvm91-gen2"
    publisher = "redhat"
    product   = "rhel-byos"
  }

  identifier {
    publisher = "internal"
    offer     = "rhel"
    sku       = "rhel-lvm91"
  }
}

resource "azurerm_shared_image" "rhel8" {
  name                = "packer-rhel87"
  gallery_name        = azurerm_shared_image_gallery.gallery.name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Linux"
  hyper_v_generation  = "V2"

  purchase_plan {
    name      = "rhel-lvm87-gen2"
    publisher = "redhat"
    product   = "rhel-byos"
  }

  identifier {
    publisher = "internal"
    offer     = "rhel"
    sku       = "rhel-lvm87"
  }
}

resource "azurerm_shared_image" "rhel7" {
  name                = "packer-rhel79"
  gallery_name        = azurerm_shared_image_gallery.gallery.name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Linux"
  hyper_v_generation  = "V2"

  purchase_plan {
    name      = "rhel-lvm79-gen2"
    publisher = "redhat"
    product   = "rhel-byos"
  }

  identifier {
    publisher = "internal"
    offer     = "rhel"
    sku       = "rhel-lvm79"
  }
}