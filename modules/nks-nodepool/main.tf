data "ncloud_nks_server_images" "image"{
    for_each = var.nks-nodepool

  hypervisor_code = "KVM"
  filter {
    name = "label"
    values = [each.value.nodepool-os]
    regex = true
  }
}


resource "ncloud_nks_node_pool" "node_pool" {
    for_each = var.nks-nodepool
        cluster_uuid     = var.nks_cluster_ids[each.value["nks-cluster"]]
        node_pool_name   = each.value["nodepool-name"]
        node_count       = each.value["nodepool-count"]
        software_code    = data.ncloud_nks_server_images.image[each.key].images[0].value
        server_spec_code = each.value["nodepool-spec"]
        storage_size = each.value["nodepool-storage"]
        autoscale {  
            enabled = each.value["autoscale-bool"]
            min = each.value["autoscale-min"]
            max = each.value["autoscale-max"]
        }
}
