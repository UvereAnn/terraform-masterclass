terraform {

  backend "s3" {

    bucket = "replace-with-production-state-bucket"

    key = "production/terraform.tfstate"

    region = "eu-west-1"

    encrypt = true

  }

}


resource "null_resource" "secure_state_example" {

}