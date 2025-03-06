resource "ncloud_block_storage" "storage" {
    for_each = var.block-storage
        server_instance_no = var.server_ids[each.value["server"]]
        name = each.value["name"]
        size = each.value["size"]
        hypervisor_type = "XEN"
        volume_type = each.value["volume_type"]
}