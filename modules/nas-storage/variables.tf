variable "nas-storage" {
  type = map(object({
    nas_name = string
    volume_size = string
  }))
}