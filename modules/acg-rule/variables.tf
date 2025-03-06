variable "acg-rule" {
  type = map(object({
    acg       = string
    inbound_rules = list(object({
      protocol    = string
      ip_block    = string
      port_range  = string
      description = string
    }))
    outbound_rules = list(object({
      protocol    = string
      ip_block    = string
      port_range  = string
      description = string
    }))
  }))
}

variable "acg_ids" {
  type = map(string)
}