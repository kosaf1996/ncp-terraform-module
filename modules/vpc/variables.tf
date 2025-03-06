variable "vpc" {
  type = map(object({
    name  = string
    cidr  = string
  }))
}
