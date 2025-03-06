variable "lb-listener" {
  type = map(object({
    lb = string
    protocol = string
    port = string
    lb-tg = string
  }))
}

variable "lb_ids" {
  type = map(string)
}

variable "lb_tg_ids" {
  type = map(string)
}