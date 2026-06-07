provider "aws" {
    region = "eu-west-1"
}

resource "aws_s3_bucket" "terraform_masterclass_demo" {
    bucket = "terraform-masterclass-demo-bucket-123456"
}