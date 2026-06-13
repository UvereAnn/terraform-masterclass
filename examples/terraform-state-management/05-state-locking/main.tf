terraform {

  backend "s3" {

    bucket = "replace-with-your-state-bucket"

    key = "state-locking-example/terraform.tfstate"

    region = "eu-west-1"

    dynamodb_table = "terraform-locks"

    encrypt = true

  }

}


resource "null_resource" "locking_example" {

}