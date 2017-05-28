variable "region" { default = "us-west-1" }
variable "access_key" {}
variable "secret_key" {}
variable "environment" {}
data "aws_canonical_user_id" "current" {}


provider "aws" "prod" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}





# Setup a user that's allowed read access to the bucket

resource "aws_iam_user" "secret_reader" {
  name = "secret_reader_${var.environment}"
  path = "/system/"
}

resource "aws_iam_access_key" "secret_reader" {
  user = "${aws_iam_user.secret_reader.name}"
}

# This will grant the DL capability to the secret_reader user
resource "aws_iam_user_policy" "secret_reader_ro" {
  name = "secret_reader"
  user = "${aws_iam_user.secret_reader.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:Get*",
        "s3:ListAllMyBuckets",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.secrets.arn}",
        "${aws_s3_bucket.secrets.arn}/*"
      ]
    }
  ]
}
EOF
}


# make it so only the serious terraform account can upload to this bucket
# but make all other iam users able to download?
resource "aws_s3_bucket" "secrets" {
  bucket = "secrets-${var.environment}"
  acl    = "private"

  tags {
    Name        = "kingdom_s3"
    Environment = "${var.environment}"
  }

  force_destroy = true # enables terraform deleting non-empty buckets
}



# This instruction would only upload a single file, which probably wouldn't be very helpful
#resource "aws_s3_bucket_object" "object" {
#  bucket = "secrets-${var.environment}"
#  key    = "secrets.txt"
#  source = "secrets/my_secret.txt"
#  etag   = "${md5(file("secrets/my_secret.txt"))}"
#}
