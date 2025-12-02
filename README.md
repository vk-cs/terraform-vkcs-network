<!-- BEGIN_TF_DOCS -->
![Beta Status](https://img.shields.io/badge/Status-Beta-yellow)

# VKCS Network Terraform module
A Terraform module for creating `Network` in VKCS.

## Examples
You can find examples in the [`examples`](./examples) directory.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_vkcs"></a> [vkcs](#requirement\_vkcs) | < 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [vkcs_networking_network.networks](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/networking_network) | resource |
| [vkcs_networking_router.router](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/networking_router) | resource |
| [vkcs_networking_router_interface.router_interfaces](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/networking_router_interface) | resource |
| [vkcs_networking_subnet.subnets](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/networking_subnet) | resource |
| [vkcs_networking_subnet_route.subnet_routes](https://registry.terraform.io/providers/vk-cs/vkcs/latest/docs/resources/networking_subnet_route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_external_network_id"></a> [external\_network\_id](#input\_external\_network\_id) | The network UUID of an external gateway for the router. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Default name for module resources. Used when a resource does not define its own name. | `string` | `null` | no |
| <a name="input_networks"></a> [networks](#input\_networks) | List of network configurations. <br/>See `vkcs_networking_network` arguments for `networks`.<br/>See `vkcs_networking_subnet` arguments for `subnets`. | <pre>list(object({<br/>    description           = optional(string)<br/>    name                  = optional(string)<br/>    port_security_enabled = optional(bool)<br/>    private_dns_domain    = optional(string)<br/>    tags                  = optional(set(string))<br/>    vkcs_services_access  = optional(bool)<br/><br/>    subnets = optional(list(object({<br/>      allocation_pool = optional(list(object({<br/>        start = string<br/>        end   = string<br/>      })))<br/>      cidr               = string<br/>      description        = optional(string)<br/>      dns_nameservers    = optional(list(string))<br/>      enable_dhcp        = optional(bool)<br/>      enable_private_dns = optional(bool)<br/>      gateway_ip         = optional(string)<br/>      name               = optional(string)<br/>      no_gateway         = optional(bool)<br/>      tags               = optional(set(string))<br/><br/>      routes = optional(list(object({<br/>        destination_cidr = string<br/>        next_hop         = string<br/>      })))<br/>    })))<br/>  }))</pre> | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | The region in which to obtain the Networking client. | `string` | `null` | no |
| <a name="input_router_args"></a> [router\_args](#input\_router\_args) | Configuration for the router. <br/>See `vkcs_networking_router` arguments. | <pre>object({<br/>    description = optional(string)<br/>    name        = optional(string)<br/>    tags        = optional(set(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_sdn"></a> [sdn](#input\_sdn) | SDN to use for this resource. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Default set of tags that are added to a resource's tags. | `set(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_ip"></a> [external\_ip](#output\_external\_ip) | External gateway of the router. |
| <a name="output_networks"></a> [networks](#output\_networks) | List of created networks with subnets. |
| <a name="output_router_id"></a> [router\_id](#output\_router\_id) | ID of the router. |
<!-- END_TF_DOCS -->