variable "region" {
  type        = string
  description = "The region in which to create module resources."
  default     = null
}

variable "sdn" {
  type        = string
  description = "SDN to use for this module. Must be set if more than one sdn are plugged to the project."
  default     = null
}

variable "tags" {
  type        = set(string)
  description = "Default set of module resources tags."
  default     = []
}

variable "name" {
  type        = string
  description = "Default name for module resources. Used when name is not specified for a resource."

  validation {
    condition     = trimspace(var.name) != ""
    error_message = "name must not be empty."
  }
}

variable "description" {
  type        = string
  description = "A description for the router."
  default     = null
}

variable "external_network" {
  type        = any
  description = "Specify external network name or set `true` if the only external netwrok is available in the project."
  default     = null

  validation {
    condition = (
      var.external_network == null || var.external_network == false || var.external_network == true ||
      can(trimspace(var.external_network))
    )
    error_message = "external_network must be null, bool or string."
  }
}

variable "networks" {
  type = list(object({
    tags                  = optional(set(string))
    name                  = optional(string)
    description           = optional(string)
    private_dns_domain    = optional(string)
    port_security_enabled = optional(bool)
    vkcs_services_access  = optional(bool)

    subnets = list(object({
      tags        = optional(set(string))
      name        = optional(string)
      description = optional(string)
      cidr        = string
      allocation_pool = optional(list(object({
        start = string
        end   = string
      })))
      dns_nameservers    = optional(list(string))
      enable_dhcp        = optional(bool)
      enable_private_dns = optional(bool)
      gateway_ip         = optional(string)
      routes = optional(list(object({
        destination_cidr = string
        next_hop         = string
      })))
    }))
  }))
  description = <<-EOT
  List of network configurations.
  See `vkcs_networking_network` arguments for `networks`.
  See `vkcs_networking_subnet` arguments for `subnets`.
  EOT

  validation {
    condition     = length(var.networks) > 0
    error_message = "Specify at least one network."
  }
  validation {
    condition     = alltrue([for n in var.networks : try(trimspace(n.name), "_") != ""])
    error_message = "Network name must not be empty if specified."
  }
  validation {
    condition     = alltrue([for n in var.networks : length(n.subnets) > 0])
    error_message = "Specify at least one subnet for each network."
  }
  validation {
    condition     = alltrue([for s in flatten(var.networks[*].subnets[*]) : try(trimspace(s.name), "_") != ""])
    error_message = "Subnet name must not be empty if specified."
  }
}
