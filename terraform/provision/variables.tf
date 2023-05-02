variable "region" {
  type    = string
  default = "uksouth"
}

variable "resource_group" {
  type = string
}

variable "tfc_agent_token" {
  type        = string
  description = "The Terraform Cloud Agent Token retrieved from Terraform Cloud"
}

variable "tfc_agent_image" {
  type        = string
  description = "The location of the TFC Agent Image"
  default     = "quay.io/benjamin_holmes/custom-tfc-agent:latest"
}

variable "default_tags" {
  type = map(any)
  default = {
    owner       = "ben.holmes"
    email       = "ben.holmes@hashicorp.com"
    DoNotDelete = true
  }
}