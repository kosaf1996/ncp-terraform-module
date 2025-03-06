output "acg_details" {
  value = {
    for k, v in ncloud_access_control_group.acg : k => {
      id                                = v.id
      access_control_group_no           = v.access_control_group_no
      is_default                        = v.is_default
    }
  }
  description = "Details of the created ACG"
}
