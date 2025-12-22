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
    resource_key          = optional(string)

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
      resource_key = optional(string)
    }))
  }))
  description = <<-EOT
  List of network configurations.

  See `vkcs_networking_network` arguments for `networks`.
  `name` is inherited from the module name by default.
  `resource_key` default value is resulting `name` value. Must be defined if more than one network is specified.
  
  See `vkcs_networking_subnet` arguments for `subnets`.
  `name` is inherited from the module name by default.
  `resource_key` default value is `cidr` or `name` value if specified.

  `resource_key` - an unique key within list to index TF resources. May be used to prevent resource recreation on changing of resource name or simplify access to resources in TF state.
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
    condition = length(var.networks) == length(distinct([
      for n in var.networks : coalesce(n.resource_key, n.name, var.name)
    ]))
    error_message = "Networks must have unique resource_key (name by default if specified or module name) within the module to prevent their recreation on changing of network list."
  }
  validation {
    condition     = alltrue([for n in var.networks : length(n.subnets) > 0])
    error_message = "Specify at least one subnet for each network."
  }
  validation {
    condition     = alltrue([for s in flatten(var.networks[*].subnets[*]) : try(trimspace(s.name), "_") != ""])
    error_message = "Subnet name must not be empty if specified."
  }
  validation {
    condition = alltrue([for n in var.networks :
      length([
        for s in n.subnets : can(coalesce(s.resource_key, s.name)) if can(coalesce(s.resource_key, s.name))
        ]) == length(distinct([
          for s in n.subnets : coalesce(s.resource_key, s.name) if can(coalesce(s.resource_key, s.name))
      ]))
    ])
    error_message = "Subnets must have unique resource_key (name by default if specified) within a network to prevent their recreation on changing of subnet list."
  }
}
