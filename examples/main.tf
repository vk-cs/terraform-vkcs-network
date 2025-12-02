module "network" {
  source = "../"

  external_network_id = data.vkcs_networking_network.extnet.id

  # If the resource name is not specified, this name will be used.
  name = "network"

  # These tags will be added to the resource tags.
  tags = ["base"]

  # You can also specify router args
  # router_args = {
  #   name = "router-tf-example"
  #   tags = ["router"]
  #   description = "router-description"
  # }

  networks = [
    {
      name        = "app-tf-example-net"
      description = "Application network"
      tags        = ["app-net"]
      subnets = [
        {
          name = "app-tf-example-subnet"
          cidr = "192.168.199.0/24"
          tags = ["app-subnet"]
        }
      ]
    },
    {
      name        = "db-tf-example-net"
      description = "Database network"
      tags        = ["db-net"]
      subnets = [
        {
          name = "db-tf-example-subnet"
          cidr = "192.168.166.0/24"
          tags = ["db-subnet"]
        }
      ]
    }
  ]
}
