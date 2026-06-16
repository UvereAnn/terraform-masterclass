terraform {

  backend "s3" {

    bucket = "replace-with-your-state-bucket"

    key = "terraform/state-example.tfstate"

    region = "eu-west-1"

  }

}

resource "null_resource" "remote_state_example" {

}