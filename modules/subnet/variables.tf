variable subnet {
  type = map(object({
    vpc  = string
    subnet  = string
    zone  = string
    network_acl_no  = string
    subnet_type  = string
    name  = string
    usage_type  = string
  }))
}

variable "vpc_ids" {
  type = map(string)
}


variable "nacl_ids" {
  type = map(string)
}