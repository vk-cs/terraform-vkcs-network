variable "region" {
  type        = string
  description = "The region in which to obtain the Networking client."
  default     = null
}

variable "sdn" {
  type        = string
  description = "SDN to use for this resource."
  default     = null
}

variable "name" {
  type        = string
  description = "Default name for module resources. Used when a resource does not define its own name."
  default     = null
}

variable "tags" {
  type        = set(string)
  description = "Default set of tags that are added to a resource's tags."
  default     = []
}

variable "external_network_id" {
  type        = string
  description = "The network UUID of an external gateway for the router."
  default     = null
}

variable "router_args" {
  type = object({
    description = optional(string)
    name        = optional(string)
    tags        = optional(set(string), [])
  })
  description = <<-EOT
  Configuration for the router. 
  See `vkcs_networking_router` arguments.
  EOT
  default     = null
}

variable "networks" {
  type = list(object({
    description           = optional(string)
    name                  = optional(string)
    port_security_enabled = optional(bool)
    private_dns_domain    = optional(string)
    tags                  = optional(set(string))
    vkcs_services_access  = optional(bool)

    subnets = optional(list(object({
      allocation_pool = optional(list(object({
        start = string
        end   = string
      })))
      cidr               = string
      description        = optional(string)
      dns_nameservers    = optional(list(string))
      enable_dhcp        = optional(bool)
      enable_private_dns = optional(bool)
      gateway_ip         = optional(string)
      name               = optional(string)
      no_gateway         = optional(bool)
      tags               = optional(set(string))

      routes = optional(list(object({
        destination_cidr = string
        next_hop         = string
      })))
    })))
  }))
  description = <<-EOT
  List of network configurations. 
  See `vkcs_networking_network` arguments for `networks`.
  See `vkcs_networking_subnet` arguments for `subnets`.
  EOT

  default = []
}