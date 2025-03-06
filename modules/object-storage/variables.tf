variable "object-storage" {
  type = map(object({
    bucket_name = string
  }))
}