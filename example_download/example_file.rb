# This example shows how you can use ruby to pull download data from an S3 onto the file system
require 'aws-sdk-core'
require 'fileutils'

$app_root = File.expand_path("#{File.dirname(__FILE__)}/..")

def example_download_file(bucket = 'secrets-dev', folder_name = 'secrets')
  ths = TerraHelper::State.new(
    state_file: "#{$app_root}/.tf_state/terraform_dev.tfstate",
    tf_aws_iam_access_key_id: 'secret_reader'
  )

  ah_s = AwsHelper::S3.new(
    region: 'us-west-1',
    iam_aws_id: ths.iam_aws_id,
    iam_aws_secret: ths.iam_aws_secret,
    bucket: bucket)

  puts ah_s.read_file('secrets/my_secret.txt')

  ah_s.download_folder(folder_name)
end



# This class can lookup info from state_files
module TerraHelper

  # This class provides help with looking up information from state filesiam_
  class State
    def initialize(options)
      @state_file = options[:state_file]
      @tf_aws_iam_access_key_id = options[:tf_aws_iam_access_key_id] # eg the 'secret_reader' part in 'aws_iam_access_key.secret_reader'
    end

    def iam_aws_id
      `#{show_access_key_cmd} | #{extract_cmd("id")}`.strip
    end

    def iam_aws_secret
      `#{show_access_key_cmd} | #{extract_cmd("secret")}`.strip
    end


    private
      def show_access_key_cmd
        "terraform state show -state=#{@state_file} aws_iam_access_key.#{@tf_aws_iam_access_key_id}"
      end

      def extract_cmd(attribute_name)
        "grep ^#{attribute_name}.*= | awk '{print $3}'"
      end
  end

  class CLI

  end
end

# This module contains helpful patterns for working with AWS in a faster less
# generalized manor
module AwsHelper

  class S3
    def initialize(options)
      Aws.config.update({
        region: options[:region],
        credentials: Aws::Credentials.new(options[:iam_aws_id], options[:iam_aws_secret])
      })

      @bucket = options[:bucket]

      @s3 = Aws::S3::Client.new
    end

    def read_file(file, bucket = nil)
      bucket = @bucket if bucket.nil?
      raise "You need to specify what bucket to use with the function" if bucket.nil?

      @s3.get_object(bucket: bucket, key: file).body.read
    end

    # this is super beta, should be extended to support dst path
    def download_folder(folder_name)
      bucket_name = 'secrets-dev'
      files = @s3.list_objects(bucket: bucket_name)
      FileUtils.mkdir_p(folder_name)

      files.contents.each do |obj|
        next unless obj.key =~ /^#{folder_name}\//
        file = File.new("#{obj.key}", "w")
        file.binmode

        io_ref = @s3.get_object(bucket: bucket_name, key: obj.key)
        file.write io_ref.body.read
        file.close
      end
    end
  end
end

example_download_file()
