resource "azurerm_shared_image" "rhel9-httpd" {
  name                = "packer-rhel91-httpd"
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
    offer     = "rhel-httpd"
    sku       = "rhel-lvm91-httpd"
  }
}