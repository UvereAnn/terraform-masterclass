provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

# Example 1: normal resource
resource "aws_s3_bucket" "eu_bucket" {
  bucket = "terraform-eu-bucket-example"
}

# Example 2: aliased provider usage
resource "aws_s3_bucket" "us_bucket" {
  provider = aws.us
  bucket    = "terraform-us-bucket-example"
}

# Example 3: renamed resource with moved block simulation
resource "aws_instance" "web_new" {
  ami           = "ami-123456"
  instance_type = "t3.micro"
}

# Simulated migration (for learning purposes)
moved {
  from = aws_instance.web_old
  to   = aws_instance.web_new
}