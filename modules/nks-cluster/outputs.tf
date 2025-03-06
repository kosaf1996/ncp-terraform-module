output "nks_cluster_details" {
  value = {
    for k, v in ncloud_nks_cluster.cluster : k => {
      id                                = v.id
      uuid                              = v.uuid
      endpoint                          = v.endpoint 
      acg_no                            = v.acg_no 
    }
  }
  description = "Details of the created NKS Cluster"
}