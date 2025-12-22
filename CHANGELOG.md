# VKCS Network Terraform module's changelog

#### v0.0.3
- Use natural keys for network and subnets instead of indexes. **Note**: This is breaking change. All networks will be recreated.
  Also you must provide `name` or `resource_key` for second etc networks.

#### v0.0.2
- Load module from zip archive for examples

#### v0.0.1
- Initial release
