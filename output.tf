output "router_id" {
  value       = vkcs_networking_router.router.id
  description = "ID of the router."
}

output "external_ip" {
  value = try(
    vkcs_networking_router.router.external_fixed_ips[0].ip_address,
    null
  )
  description = "External gateway of the router."
}

output "networks" {
  value = [
    for net_key, net in vkcs_networking_network.networks : {
      id   = net.id
      name = net.name
      subnets = [
        for subnet_key, subnet in vkcs_networking_subnet.subnets : {
          id         = subnet.id
          name       = subnet.name
          cidr       = subnet.cidr
          gateway_ip = subnet.gateway_ip
        } if substr(subnet_key, 0, length(net_key)) == net_key
      ]
    }
  ]
  depends_on  = [vkcs_networking_router_interface.router_interfaces]
  description = "List of created networks with subnets."
}