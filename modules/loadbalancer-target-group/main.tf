resource "ncloud_lb_target_group" "lb-tg" {
    for_each = var.lb-tg
        vpc_no   = var.vpc_ids[each.value["vpc"]]
        protocol = each.value["protocol"]
        target_type = "VSVR"
        port        = each.value["port"]
        name = each.value["name"]
        health_check {
            protocol = each.value["health_protocol"]
            http_method = each.value["health_http_method"]
            port           = each.value["health_port"]
            url_path       = each.value["health_url_path"]
            cycle          = each.value["health_cycle"]
            up_threshold   = each.value["health_up_threshold"]
            down_threshold = each.value["health_down_threshold"]
        }
        algorithm_type = each.value["algorithm_type"]
}
