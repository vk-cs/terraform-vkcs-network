locals {
  networks = [
    for idx, network in var.networks : merge(network, {
      network_idx = idx
      network_key = coalesce(network.resource_key, network.name, var.name)
    })
  ]

  subnets = flatten([
    for network in local.networks : [
      for idx, subnet in network.subnets : merge(subnet, {
        network_idx = network.network_idx
        network_key = network.network_key
        subnet_idx  = idx
        subnet_key = format(
          "${network.network_key}/%s",
          coalesce(subnet.resource_key, subnet.name, replace(subnet.cidr, "/", "_"))
        )
      })
    ]
  ])

  routes = flatten([
    for subnet_idx, subnet in local.subnets : try([
      for route_idx, route in subnet.routes : merge(route, {
        subnet_key = subnet.subnet_key
        route_key = format(
          "${subnet.subnet_key}/%s/%s",
          replace(route.destination_cidr, "/", "_"),
          route.next_hop
        )
      })
    ], [])
  ])
}
