data "vkcs_networking_network" "ext_net" {
  count = var.external_network != null && var.external_network != false ? 1 : 0

  region   = var.region
  sdn      = try(element(values(vkcs_networking_network.networks), 0).sdn, var.sdn)
  external = true
  name     = var.external_network != true ? var.external_network : null
}
