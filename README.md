<!-- BEGIN_TF_DOCS -->
![Beta Status](https://img.shields.io/badge/Status-Beta-yellow)

# VKCS Network Terraform module
A Terraform module for `Network` in VKCS.

This modules makes it easy to setup virtual networking in VKCS.

It supports creating:
- router (optionally connected to the Internet)
- networks
- subnets of the networks (unconditionally attached to the router)
- subnet routes

It does not support:
- virtual networking without a router
- just a single router
- network without subnets
- subnets not attached to the router
- router routes

## Usage
### Simple network with Internet access
```hcl
module "network" {
  source = "https://github.com/vk-cs/terraform-vkcs-network/archive/refs/tags/v0.0.3.zip//terraform-vkcs-network-0.0.3"
  # Alternatively you may refer right to Hashicorp module repository if you have access to it
  # source = "vk-cs/network/vkcs"
  # version = "0.0.3"

  name = "simple-tf-example"
  # Specify network name instead if default sdn contains more than one external network
  external_network = true

  networks = [{
    subnets = [{
      cidr = "192.168.199.0/24"
    }]
  }]
}
```
```hcl
output "network" {
  value = module.network
}
```

## Examples
You can find examples in the [`examples`](./examples) directory on [GitHub](https://github.com/vk-cs/terraform-vkcs-network/tree/v0.0.3/examples).

Running an example:
- Clone [GitHub repository](https://github.com/vk-cs/terraform-vkcs-network) and checkout tag v0.0.3.
  Or get [module archive](https://github.com/vk-cs/terraform-vkcs-network/archive/refs/tags/v0.0.3.zip) and unpack it.
  Or just copy files above to a new folder.
- [Install Terraform](https://cloud.vk.com/docs/en/tools-for-using-services/terraform/quick-start). **Note**: You do not need `vkcs_provider.tf` to run module example.
- [Init Terraform](https://cloud.vk.com/docs/en/tools-for-using-services/terraform/quick-start#terraform_initialization) from the example folder.
- [Run Terraform](https://cloud.vk.com/docs/en/tools-for-using-services/terraform/quick-start#creating_resources_via_terraform) to create example resources.
- Check example output and explore created resources with `terraform show`, management console, CLI and API requests.
- Remove example resources with `terraform destroy -auto-approve --refresh=false`

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.3)

- <a name="requirement_vkcs"></a> [vkcs](#requirement\_vkcs) (>= 0.13.1, < 1.0.0)

## Resources

The following resources are used by this module:

- [vkcs_networking_network.networks](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/networking_network) (resource)
- [vkcs_networking_router.router](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/networking_router) (resource)
- [vkcs_networking_router_interface.router_interfaces](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/networking_router_interface) (resource)
- [vkcs_networking_subnet.subnets](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/networking_subnet) (resource)
- [vkcs_networking_subnet_route.subnet_routes](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/networking_subnet_route) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_name"></a> [name](#input\_name)

Description: Default name for module resources. Used when name is not specified for a resource.

Type: `string`

### <a name="input_networks"></a> [networks](#input\_networks)

Description: List of network configurations.

See `vkcs_networking_network` arguments for `networks`.
`name` is inherited from the module name by default.
`resource_key` default value is resulting `name` value. Must be defined if more than one network is specified.  

See `vkcs_networking_subnet` arguments for `subnets`.
`name` is inherited from the module name by default.
`resource_key` default value is `cidr` or `name` value if specified.

`resource_key` - an unique key within list to index TF resources. May be used to prevent resource recreation on changing of resource name or simplify access to resources in TF state.

Type:

```hcl
list(object({
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
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_region"></a> [region](#input\_region)

Description: The region in which to create module resources.

Type: `string`

Default: `null`

### <a name="input_sdn"></a> [sdn](#input\_sdn)

Description: SDN to use for this module. Must be set if more than one sdn are plugged to the project.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Default set of module resources tags.

Type: `set(string)`

Default: `[]`

### <a name="input_description"></a> [description](#input\_description)

Description: A description for the router.

Type: `string`

Default: `null`

### <a name="input_external_network"></a> [external\_network](#input\_external\_network)

Description: Specify external network name or set `true` if the only external netwrok is available in the project.

Type: `any`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_router_id"></a> [router\_id](#output\_router\_id)

Description: Router ID.

### <a name="output_external_ip"></a> [external\_ip](#output\_external\_ip)

Description: External IP of the router.

### <a name="output_networks"></a> [networks](#output\_networks)

Description: List of networks info.  

See `vkcs_networking_network` and `vkcs_networking_subnet` for keys meaning.
<!-- END_TF_DOCS -->