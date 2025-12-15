output "router_id" {
  value       = vkcs_networking_router.router.id
  description = "Router ID."
}

output "external_ip" {
  value = try(
    vkcs_networking_router.router.external_fixed_ips[0].ip_address,
    null
  )
  description = "External IP of the router."
}

output "networks" {
  value = [
    for network_key, network in vkcs_networking_network.networks : {
      id   = network.id
      name = network.name
      subnets = [
        for subnet in local.all_subnets : {
          id         = vkcs_networking_subnet.subnets[subnet.subnet_key].id
          name       = vkcs_networking_subnet.subnets[subnet.subnet_key].name
          cidr       = vkcs_networking_subnet.subnets[subnet.subnet_key].cidr
          gateway_ip = vkcs_networking_subnet.subnets[subnet.subnet_key].gateway_ip
        } if subnet.network_key == network_key
      ]
    }
  ]
  description = <<-EOT
  List of networks info.
  
  See `vkcs_networking_network` and `vkcs_networking_subnet` for keys meaning.
  EOT
  depends_on  = [vkcs_networking_router_interface.router_interfaces]
}
