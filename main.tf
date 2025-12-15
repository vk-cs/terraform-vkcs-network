resource "vkcs_networking_router" "router" {
  region      = var.region
  sdn         = var.sdn
  tags        = var.tags
  name        = var.name
  description = var.description
  external_network_id = (
    var.external_network != null && var.external_network != false ?
    data.vkcs_networking_network.ext_net[0].id :
    null
  )
}

resource "vkcs_networking_network" "networks" {
  for_each = { for key, n in var.networks : key => n }

  region = var.region
  sdn    = var.sdn
  tags   = setunion(var.tags, coalesce(each.value.tags, []))
  name = join("", [
    coalesce(each.value.name, var.name),
    "%{if !can(coalesce(each.value.name))}-${each.key}%{else}%{endif}"
  ])
  description           = each.value.description
  private_dns_domain    = each.value.private_dns_domain
  port_security_enabled = each.value.port_security_enabled
  vkcs_services_access  = each.value.vkcs_services_access
}

resource "vkcs_networking_subnet" "subnets" {
  for_each = { for s in local.all_subnets : s.subnet_key => s }

  network_id = vkcs_networking_network.networks[each.value.network_key].id
  region     = var.region
  sdn        = var.sdn
  tags       = setunion(var.tags, coalesce(each.value.tags, []))
  name = join("", [
    coalesce(each.value.name, var.name),
    "%{if !can(coalesce(each.value.name))}-${each.key}%{else}%{endif}"
  ])
  description        = each.value.description
  cidr               = each.value.cidr
  dns_nameservers    = each.value.dns_nameservers
  enable_dhcp        = each.value.enable_dhcp
  enable_private_dns = (
    vkcs_networking_network.networks[each.value.network_key].sdn == "sprut" ?
    each.value.enable_private_dns :
    null
  )
  gateway_ip         = each.value.gateway_ip

  dynamic "allocation_pool" {
    for_each = each.value.allocation_pool != null ? each.value.allocation_pool : []

    content {
      start = allocation_pool.value.start
      end   = allocation_pool.value.end
    }
  }
}

resource "vkcs_networking_router_interface" "router_interfaces" {
  for_each = { for s in local.all_subnets : s.subnet_key => s }

  router_id = vkcs_networking_router.router.id
  subnet_id = vkcs_networking_subnet.subnets[each.key].id
  region    = var.region
  sdn       = var.sdn
}

resource "vkcs_networking_subnet_route" "subnet_routes" {
  for_each = { for r in local.all_routes : r.route_key => r }

  subnet_id        = vkcs_networking_subnet.subnets[each.value.subnet_key].id
  region           = var.region
  sdn              = var.sdn
  destination_cidr = each.value.destination_cidr
  next_hop         = each.value.next_hop
}
