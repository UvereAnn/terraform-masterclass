locals {
  project_name = "${var.environment}-${var.owner}"
}

output "project_name" {
  value = local.project_name
}

output "environment" {
  value = var.environment
}