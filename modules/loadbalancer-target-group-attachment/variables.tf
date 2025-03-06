variable "lb-tg-attach" {
  type = map(object({
      lb-tg = string
      server = list(string)  

  }))
}

variable "tg_ids" {
  type = map(string)
}
variable "server_ids" {
  type = map(string)
}