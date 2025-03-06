variable "block-storage" {
  type = map(object({
    server = string
    size = string
    name = string
    volume_type = string
  }))
}

variable "server_ids" {
  type = map(string)
}
