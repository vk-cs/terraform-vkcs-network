locals {
  all_subnets = flatten([
    for net_idx, net in var.networks : [
      for subnet_idx, subnet in net.subnets != null ? net.subnets : [] : {
        network_key   = net_idx
        subnet_key    = "${net_idx}-${subnet_idx}"
        subnet_config = subnet
        network_id    = vkcs_networking_network.networks[net_idx].id
      }
    ]
  ])

  all_routes = flatten([
    for net_idx, net in var.networks : [
      for subnet_idx, subnet in net.subnets != null ? net.subnets : [] : [
        for route_idx, route in subnet.routes != null ? subnet.routes : [] : {
          subnet_key   = "${net_idx}-${subnet_idx}"
          route_key    = "${net_idx}-${subnet_idx}-${route_idx}"
          route_config = route
          subnet_id    = vkcs_networking_subnet.subnets["${net_idx}-${subnet_idx}"].id
        }
      ]
    ]
  ])
}