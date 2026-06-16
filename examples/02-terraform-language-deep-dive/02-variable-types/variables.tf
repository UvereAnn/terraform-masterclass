variable "application" {

  type = object({
    name        = string
    environment = string
    replicas    = number
  })

}