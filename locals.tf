locals {
  all_subnets = flatten([
    for network_idx, network in var.networks : [
      for subnet_idx, subnet in network.subnets : merge(subnet, {
        network_key = tostring(network_idx)
        subnet_key  = "${network_idx}-${subnet_idx}"
      })
    ]
  ])

  all_routes = flatten([
    for network_idx, network in var.networks : [
      for subnet_idx, subnet in network.subnets : [
        for route_idx, route in subnet.routes != null ? subnet.routes : [] : merge(route, {
          subnet_key = "${network_idx}-${subnet_idx}"
          route_key  = "${network_idx}-${subnet_idx}-${route_idx}"
        })
      ]
    ]
  ])
}
