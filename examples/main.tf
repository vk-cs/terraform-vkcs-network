module "networking" {
  source = "../"

  router = {
    name                = "router-tf-example"
    external_network_id = data.vkcs_networking_network.extnet.id
  }

  networks = [
    {
      name        = "app-tf-example"
      description = "Application network"
      subnets = [
        {
          name = "app-tf-example"
          cidr = "192.168.199.0/24"
        }
      ]
    },
    {
      name        = "db-tf-example"
      description = "Database network"
      subnets = [
        {
          name = "db-tf-example"
          cidr = "192.168.166.0/24"
        }
      ]
    }
  ]
}