output "nacl_details" {
  value = {
    for k, v in ncloud_network_acl.nacl : k => {
      id                                = v.id
      network_acl_no                    = v.network_acl_no
      is_default                        = v.is_default
    }
  }
  description = "Details of the created NACL"
}
