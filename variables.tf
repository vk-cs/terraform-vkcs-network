variable "region" {
  type        = string
  description = "The region in which to obtain the Networking client."
  default     = null
}

variable "sdn" {
  type        = string
  description = "SDN to use for this resource. Must be one of following: `neutron`, `sprut`."
  default     = null
}

variable "router" {
  type = object({
    admin_state_up      = optional(bool)
    description         = optional(string)
    external_network_id = optional(string)
    name                = optional(string)
    tags                = optional(set(string))
    value_specs         = optional(map(string))
    vendor_options = optional(object({
      set_router_gateway_after_create = optional(bool)
    }))
  })
  description = "Configuration for the router"
}

variable "networks" {
  type = list(object({
    admin_state_up        = optional(bool)
    description           = optional(string)
    name                  = optional(string)
    port_security_enabled = optional(bool)
    private_dns_domain    = optional(string)
    tags                  = optional(set(string))
    value_specs           = optional(map(string))
    vkcs_services_access  = optional(bool)

    subnets = optional(list(object({
      allocation_pool = optional(list(object({
        start = string
        end   = string
      })))
      cidr               = optional(string)
      description        = optional(string)
      dns_nameservers    = optional(list(string))
      enable_dhcp        = optional(bool)
      enable_private_dns = optional(bool)
      gateway_ip         = optional(string)
      name               = optional(string)
      no_gateway         = optional(bool)
      prefix_length      = optional(number)
      subnetpool_id      = optional(string)
      tags               = optional(set(string))
      value_specs        = optional(map(string))

      routes = optional(list(object({
        destination_cidr = string
        next_hop         = string
      })))
    })))
  }))
  description = "List of network configurations."
  default     = []
}