resource "ncloud_lb" "lb" {
    for_each = { for k, v in var.lb : k => v if length(v.subnet) > 0 }
    # for_each = var.lb
        name = each.value["lb_name"]
        network_type = each.value["lb_network"]
        type = each.value["lb_type"]
        throughput_type = each.value["lb_size"]
        subnet_no_list = [for s in each.value.subnet : var.subnet_ids[s]] 
}