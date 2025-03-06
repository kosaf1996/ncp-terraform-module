variable "lb-tg" {
  type = map(object({
      name = string
      vpc = string
      protocol = string
      port = string
      algorithm_type = string

      #health_check Info
      health_protocol = string
      health_http_method = string
      health_port = string
      health_url_path = string
      health_cycle = string
      health_up_threshold = string
      health_down_threshold = string
  }))
}

variable "vpc_ids" {
  type = map(string)
}