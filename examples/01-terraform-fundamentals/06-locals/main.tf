locals {

  project_name = join(
    "-",
    [
      var.environment,
      var.application
    ]
  )

  common_tags = {
    Environment = var.environment
    Application = var.application
    ManagedBy   = "Terraform"
  }

}

output "project_name" {
  value = local.project_name
}

output "common_tags" {
  value = local.common_tags
}