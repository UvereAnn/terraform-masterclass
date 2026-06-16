locals {

  server_names = [
    for i in range(var.instance_count) :
    "web-${i}"
  ]

}

output "server_names" {
  value = local.server_names
}