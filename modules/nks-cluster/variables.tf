variable "nks-cluster" {
  type = map(object({
    k8s_version = string
    login_key_name = string
    name = string
    lb_private_subnet = string
    lb_public_subnet = string
    subnet_no_list = list(string)
    vpc = string
    public_network = bool
    zone = string
    audit = bool
  }))
}

variable "loginkey_ids" {
  type        = string
}

variable "subnet_ids" {
  type = map(string)
}

variable "vpc_ids" {
  type = map(string)
}