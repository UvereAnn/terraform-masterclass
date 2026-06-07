provider "aws" {
    region = "eu-west-1"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

output "account_id" {
    value = data.aws_caller_identity.current.account_id
}

output "current_region" {
    value = data.aws_region.current.name
}
