resource "ncloud_access_control_group" "acg" {
    for_each = var.acg
        name        = each.value["name"]
        vpc_no      = var.vpc_ids[each.value["vpc"]]  # vpc_ids에서 ID 참조
}