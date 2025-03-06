resource "ncloud_vpc" "vpc" {
  for_each = var.vpc

  name           = each.value.name
  ipv4_cidr_block = each.value.cidr
}
