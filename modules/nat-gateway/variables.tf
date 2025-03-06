variable "nat-gateway" {
  type = map(object({
    vpc    = string
    subnet = string
    name   = string
    zone   = string
  }))
}

variable "vpc_ids" {
  type = map(string)
}

variable "subnet_ids" {
  type = map(string)
}