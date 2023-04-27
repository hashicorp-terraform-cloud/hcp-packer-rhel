variable "region" {
  type    = string
  default = "uksouth"
}

variable "resource_group" {
  type = string
}

variable "default_tags" {
  type = map(any)
  default = {
    owner       = "ben.holmes"
    email       = "ben.holmes@hashicorp.com"
    DoNotDelete = true
  }
}