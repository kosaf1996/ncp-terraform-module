resource "ncloud_subnet" "subnet" {
    for_each = var.subnet
        vpc_no         = var.vpc_ids[each.value["vpc"]]  # vpc_ids에서 ID 참조
        subnet         = each.value["subnet"]
        zone           = each.value["zone"]
        network_acl_no = var.nacl_ids[each.value["network_acl_no"]] # nacl_ids에서 ID 참조
        subnet_type    = each.value["subnet_type"]
        name           = each.value["name"]
        usage_type     = each.value["usage_type"]
}