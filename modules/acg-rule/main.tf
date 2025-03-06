resource "ncloud_access_control_group_rule" "acg_rule" {
  for_each = var.acg-rule

    access_control_group_no = var.acg_ids[each.value["acg"]]

    dynamic "inbound" {
        for_each = each.value.inbound_rules
        content {
        protocol    = inbound.value.protocol
        ip_block    = inbound.value.ip_block
        port_range  = inbound.value.port_range
        description = inbound.value.description
        }
    }

    dynamic "outbound" {
        for_each = each.value.outbound_rules
        content {
        protocol    = outbound.value.protocol
        ip_block    = outbound.value.ip_block
        port_range  = outbound.value.port_range
        description = outbound.value.description
        }
    }
}
