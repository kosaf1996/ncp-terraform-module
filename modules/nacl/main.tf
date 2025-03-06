resource "ncloud_network_acl" "nacl" {
    for_each = var.nacl
        #vpc_no      = ncloud_vpc.vpc[each.value["vpc"]].id
        vpc_no = var.vpc_ids[each.value["vpc"]]  # vpc_ids에서 ID 참조
        name        = each.value["name"]
 }
