# This example shows how you can use ruby to pull down data from an S3 into memory

require 'aws-sdk-core'


puts "Please input the aws_access_key for the user created via terraform that can read from the s3 bucket:"
aws_id = STDIN.gets.strip
puts "Input the secret key now:"
aws_secret = STDIN.gets.strip

Aws.config.update({
  region: 'us-west-1',
  credentials: Aws::Credentials.new(aws_id, aws_secret)
})

s3 = Aws::S3::Client.new
resp = s3.get_object(bucket:'secrets-dev', key:'secrets/my_secret.txt')

puts resp.body.read

