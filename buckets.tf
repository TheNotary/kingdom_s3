variable "region" { default = "us-west-1" }
variable "access_key" {}
variable "secret_key" {}
variable "environment" {}


provider "aws" "prod" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}



resource "aws_s3_bucket" "secrets" {
  bucket = "secrets-${var.environment}"
  acl    = "private"

  tags {
    Name        = "secrets"
    Environment = "${var.environment}"
  }
}




