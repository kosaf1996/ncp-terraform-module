variable "lb" {
  type = map(object({
    lb_name = string
    lb_network = string
    lb_type = string
    lb_size = string
    subnet = list(string)  
  }))
}

variable "subnet_ids" {
  type = map(string)
}