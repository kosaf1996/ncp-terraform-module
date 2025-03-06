variable "nks-nodepool" {
  type = map(object({
    nks-cluster = string
    nodepool-name = string
    nodepool-count = string
    nodepool-os = string
    nodepool-spec = string
    nodepool-storage = string
    autoscale-bool = bool
    autoscale-min = string
    autoscale-max = string
  }))
}

variable "nks_cluster_ids" {
  type = map(string)
}
