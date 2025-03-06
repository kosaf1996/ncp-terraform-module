output "vpc_details" {
  value = {
    for k, v in ncloud_vpc.vpc : k => {
      id                                = v.id
      vpc_no                            = v.vpc_no
      default_network_acl_no            = v.default_network_acl_no
      default_access_control_group_no   = v.default_access_control_group_no
      default_public_route_table_no     = v.default_public_route_table_no
      default_private_route_table_no    = v.default_private_route_table_no
    }
  }
  description = "Details of the created VPCs"
}
