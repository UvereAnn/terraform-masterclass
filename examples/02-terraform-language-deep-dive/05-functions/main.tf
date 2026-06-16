locals {

  naming_prefix = lower(
    join(
      "-",
      [
        var.environment,
        var.application
      ]
    )
  )

}

output "naming_prefix" {
  value = local.naming_prefix
}

output "application_upper" {
  value = upper(var.application)
}