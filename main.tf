resource "vkcs_networking_router" "router" {
  description         = try(var.router_args.description, null)
  external_network_id = var.external_network_id
  region              = var.region
  sdn                 = var.sdn
  name = (
    var.router_args != null && var.router_args.name != null ? var.router_args.name :
    var.name != null ? var.name :
    null
  )
  tags = setunion(var.tags, try(var.router_args.tags, []))
}

resource "vkcs_networking_network" "networks" {
  for_each = { for idx, net in var.networks : idx => net }

  description = each.value.description
  name = (
    try(each.value.name, null) != null ? each.value.name :
    var.name != null ? var.name :
    null
  )
  port_security_enabled = each.value.port_security_enabled
  private_dns_domain    = each.value.private_dns_domain
  region                = var.region
  sdn                   = var.sdn
  tags                  = setunion(var.tags, coalesce(each.value.tags, []))
  vkcs_services_access  = each.value.vkcs_services_access
}

resource "vkcs_networking_subnet" "subnets" {
  for_each = { for s in local.all_subnets : s.subnet_key => s }

  network_id = each.value.network_id

  dynamic "allocation_pool" {
    for_each = each.value.subnet_config.allocation_pool != null ? each.value.subnet_config.allocation_pool : []
    content {
      start = allocation_pool.value.start
      end   = allocation_pool.value.end
    }
  }

  cidr               = each.value.subnet_config.cidr
  description        = each.value.subnet_config.description
  dns_nameservers    = each.value.subnet_config.dns_nameservers
  enable_dhcp        = each.value.subnet_config.enable_dhcp
  enable_private_dns = each.value.subnet_config.enable_private_dns
  gateway_ip         = each.value.subnet_config.gateway_ip
  name = (
    try(each.value.subnet_config.name, null) != null ? each.value.subnet_config.name :
    var.name != null ? var.name :
    null
  )
  no_gateway = each.value.subnet_config.no_gateway
  region     = var.region
  sdn        = var.sdn
  tags       = setunion(var.tags, coalesce(each.value.subnet_config.tags, []))
}

resource "vkcs_networking_router_interface" "router_interfaces" {
  for_each = { for s in local.all_subnets : s.subnet_key => s }

  router_id = vkcs_networking_router.router.id
  region    = var.region
  sdn       = var.sdn
  subnet_id = vkcs_networking_subnet.subnets[each.key].id
}

resource "vkcs_networking_subnet_route" "subnet_routes" {
  for_each = { for r in local.all_routes : r.route_key => r }

  destination_cidr = each.value.route_config.destination_cidr
  next_hop         = each.value.route_config.next_hop
  subnet_id        = each.value.subnet_id
  region           = var.region
  sdn              = var.sdn
}