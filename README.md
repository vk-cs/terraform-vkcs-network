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
  source = "../../"

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

## Examples
You can find examples in the [`examples`](./examples) directory on [GitHub](https://github.com/vk-cs/terraform-vkcs-network/tree/v0.0.1/examples).

Running an example:
- Clone [GitHub repository](https://github.com/vk-cs/terraform-vkcs-network/v0.0.1/main)
- [Install Terraform](https://cloud.vk.com/docs/en/tools-for-using-services/terraform/quick-start). **Note**: You do not need `vkcs_provider.tf` to run module example.
- [Init Terraform](https://cloud.vk.com/docs/en/tools-for-using-services/terraform/quick-start#terraform_initialization) from the example folder.
- [Run Terraform](https://cloud.vk.com/docs/en/tools-for-using-services/terraform/quick-start#creating_resources_via_terraform) to create example resources.
- Check example output and explore created resources with `terraform show`, management console, CLI and API requests.
- Remove example resources with `terraform destroy -auto-approve --refresh=false`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_vkcs"></a> [vkcs](#requirement\_vkcs) | >= 0.13.1, < 1.0.0 |

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
| <a name="input_region"></a> [region](#input\_region) | The region in which to create module resources. | `string` | `null` | no |
| <a name="input_sdn"></a> [sdn](#input\_sdn) | SDN to use for this module. Must be set if more than one sdn are plugged to the project. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Default set of module resources tags. | `set(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Default name for module resources. Used when name is not specified for a resource. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | A description for the router. | `string` | `null` | no |
| <a name="input_external_network"></a> [external\_network](#input\_external\_network) | Specify external network name or set `true` if the only external netwrok is available in the project. | `any` | `null` | no |
| <a name="input_networks"></a> [networks](#input\_networks) | List of network configurations.<br/>See `vkcs_networking_network` arguments for `networks`.<br/>See `vkcs_networking_subnet` arguments for `subnets`. | <pre>list(object({<br/>    tags                  = optional(set(string))<br/>    name                  = optional(string)<br/>    description           = optional(string)<br/>    private_dns_domain    = optional(string)<br/>    port_security_enabled = optional(bool)<br/>    vkcs_services_access  = optional(bool)<br/><br/>    subnets = list(object({<br/>      tags        = optional(set(string))<br/>      name        = optional(string)<br/>      description = optional(string)<br/>      cidr        = string<br/>      allocation_pool = optional(list(object({<br/>        start = string<br/>        end   = string<br/>      })))<br/>      dns_nameservers    = optional(list(string))<br/>      enable_dhcp        = optional(bool)<br/>      enable_private_dns = optional(bool)<br/>      gateway_ip         = optional(string)<br/>      routes = optional(list(object({<br/>        destination_cidr = string<br/>        next_hop         = string<br/>      })))<br/>    }))<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_router_id"></a> [router\_id](#output\_router\_id) | Router ID. |
| <a name="output_external_ip"></a> [external\_ip](#output\_external\_ip) | External IP of the router. |
| <a name="output_networks"></a> [networks](#output\_networks) | List of networks info.<br/>See `vkcs_networking_network` and `vkcs_networking_subnet` for keys meaning. |
<!-- END_TF_DOCS -->