resource "ncloud_lb_listener" "listener" {
    for_each = var.lb-listener
        load_balancer_no = var.lb_ids[each.value["lb"]]
        protocol = each.value["protocol"]
        port = each.value["port"]
        target_group_no = var.lb_tg_ids[each.value["lb-tg"]]
}
