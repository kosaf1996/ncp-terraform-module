resource "ncloud_route" "nat-route" {
  for_each = var.nat-route-table
    route_table_no         = var.route_table_ids[each.value["vpc"]]
    destination_cidr_block = each.value["destination_cidr_block"]
    target_type            = each.value["target_type"]
    target_name            = each.value["target_name"]
    target_no              = var.nat_gateway_ids[each.value["target_name"]]
}