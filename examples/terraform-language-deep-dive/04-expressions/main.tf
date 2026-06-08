locals {

  naming_prefix =
    "${var.environment}-${var.application}"

  instance_type =
    var.environment == "prod"
    ? "t3.large"
    : "t3.micro"

}

output "naming_prefix" {
  value = local.naming_prefix
}

output "instance_type" {
  value = local.instance_type
}