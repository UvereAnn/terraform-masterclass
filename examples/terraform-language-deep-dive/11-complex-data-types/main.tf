output "server_summary" {
  value = {
    for name, config in var.servers :
    name => {
      instance_type = config.instance_type
      disk_size     = config.disk_size
      monitoring    = config.monitoring
    }
  }
}