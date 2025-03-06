resource "ncloud_lb_target_group_attachment" "lb-tg-attach" {
  for_each = { for k, v in var.lb-tg-attach : k => v if length(v.server) > 0 }

  target_group_no = var.tg_ids[each.value.lb-tg]
  target_no_list  = [for s in each.value.server : var.server_ids[s]]  
}
