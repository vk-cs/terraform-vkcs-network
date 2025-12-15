terraform {
  required_version = ">= 1.3"

  required_providers {
    vkcs = {
      source  = "vk-cs/vkcs"
      version = ">= 0.13.1, < 1.0.0"
    }
  }
}
