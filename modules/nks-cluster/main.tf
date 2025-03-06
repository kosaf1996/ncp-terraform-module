data "ncloud_nks_versions" "version" {
    for_each = var.nks-cluster
        
        hypervisor_code = "KVM"
        filter {
            name = "value"
            values = [each.value.k8s_version]
            regex = true
        }
} 

resource "ncloud_nks_cluster" "cluster" {
    for_each = var.nks-cluster
        hypervisor_code        = "KVM"
        cluster_type           = "SVR.VNKS.STAND.C002.M008.G003"
        k8s_version            = data.ncloud_nks_versions.version[each.key].versions.0.value
        login_key_name         = var.loginkey_ids
        name                   = each.value["name"]
        lb_private_subnet_no   = var.subnet_ids[each.value["lb_private_subnet"]]
        lb_public_subnet_no    = var.subnet_ids[each.value["lb_public_subnet"]]
        kube_network_plugin    = "cilium"
        subnet_no_list         = [for s in each.value.subnet_no_list : var.subnet_ids[s]] 
        vpc_no                 = var.vpc_ids[each.value["vpc"]]
        public_network         = each.value["public_network"]
        zone                   = each.value["zone"]
        log {
            audit = each.value["audit"]
        }
    
}