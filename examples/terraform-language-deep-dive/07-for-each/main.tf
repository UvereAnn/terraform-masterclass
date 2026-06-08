output "server_names" {

  value = [
    for name, size in var.servers :
    "${name} -> ${size}"
  ]

}