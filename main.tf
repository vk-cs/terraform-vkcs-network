resource "vkcs_networking_router" "router" {
  admin_state_up      = var.router.admin_state_up
  description         = var.router.description
  external_network_id = var.router.external_network_id
  region              = var.region
  sdn                 = var.sdn
  name                = var.router.name
  tags                = var.router.tags
  value_specs         = var.router.value_specs

  dynamic "vendor_options" {
    for_each = var.router.vendor_options != null ? [var.router.vendor_options] : []
    content {
      set_router_gateway_after_create = vendor_options.value.set_router_gateway_after_create
    }
  }
}

resource "vkcs_networking_network" "networks" {
  for_each = { for idx, net in var.networks : idx => net }

  admin_state_up        = each.value.admin_state_up
  description           = each.value.description
  name                  = each.value.name
  port_security_enabled = each.value.port_security_enabled
  private_dns_domain    = each.value.private_dns_domain
  region                = var.region
  sdn                   = var.sdn
  tags                  = each.value.tags
  value_specs           = each.value.value_specs
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
  name               = each.value.subnet_config.name
  no_gateway         = each.value.subnet_config.no_gateway
  prefix_length      = each.value.subnet_config.prefix_length
  region             = var.region
  sdn                = var.sdn
  subnetpool_id      = each.value.subnet_config.subnetpool_id
  tags               = each.value.subnet_config.tags
  value_specs        = each.value.subnet_config.value_specs
}

resource "vkcs_networking_router_interface" "router_interfaces" {
  for_each = { for s in local.all_subnets : s.subnet_key => s }

  router_id = vkcs_networking_router.router.id
  # port_id = 
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