locals {
  project_name = "${var.environment}-${var.owner}"
  devops       = "Her name is ${var.devops_engineer_name}, with id: ${var.devops_engineer_id}"
}

output "project_name" {
  value = local.project_name
}

output "staff" {
  value = local.devops
}

