variable "servers" {
  type = map(object({
    instance_type = string
    disk_size     = number
    monitoring    = bool
  }))
}