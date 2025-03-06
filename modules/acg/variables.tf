variable "acg" {
  type = map(object({
    vpc  = string #VPC NAME
    name  = string #ACG NAME
  }))
}

variable "vpc_ids" {
  type = map(string)
}