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


# This instruction would only upload a single file, which probably wouldn't be very helpful
#resource "aws_s3_bucket_object" "object" {
#  bucket = "secrets-${var.environment}"
#  key    = "secrets.txt"
#  source = "secrets/my_secret.txt"
#  etag   = "${md5(file("secrets/my_secret.txt"))}"
#}




