output "nks_nodepool_details" {
  value = {
    for k, v in ncloud_nks_node_pool.node_pool : k => {
      id                                = v.id
      instance_no                       = v.instance_no 
      nodes                             = v.nodes 
    }
  }
  description = "Details of the created NKS NodePool"
}