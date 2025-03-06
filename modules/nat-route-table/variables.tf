variable "nat-route-table" {
  type = map(object({
    vpc    = string
    destination_cidr_block = string
    target_type   = string
    target_name   = string
  }))
}

variable "route_table_ids" {
  type = map(string)
}

variable "nat_gateway_ids" {
  type = map(string)
}