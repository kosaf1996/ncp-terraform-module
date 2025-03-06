variable "server" {
  type = map(object({
    subnet = string
    name = string
    server_image_name = string
    server_spec_code = string
    login_key_name = string
    is_protect_server_termination = string
    fee_system_type_code = string
    zone = string
  }))
}

variable "subnet_ids" {
  type = map(string)
}

variable "loginkey_ids" {
  type        = string
}