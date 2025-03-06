variable "nacl" {
  type = map(object({
    vpc  = string #VPC NAME
    name  = string #NACL NAME
  }))
}

variable "vpc_ids" {
  type = map(string)
}