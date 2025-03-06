resource "ncloud_nat_gateway" "nat_gateway" {
  for_each = var.nat-gateway
    vpc_no      = var.vpc_ids[each.value["vpc"]]  # vpc_ids에서 ID 참조
    subnet_no   = var.subnet_ids[each.value["subnet"]]  # vpc_ids에서 ID 참조
    zone        = each.value["zone"]
    name        = each.value["name"]
}