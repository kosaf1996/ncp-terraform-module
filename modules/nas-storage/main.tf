resource "ncloud_nas_volume" "nas" {
    for_each = var.nas-storage
        volume_name_postfix            = each.value["nas_name"]
        volume_size                    = each.value["volume_size"]
        volume_allotment_protocol_type = "NFS"
}
