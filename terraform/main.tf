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