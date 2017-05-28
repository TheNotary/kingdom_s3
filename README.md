# Kingdom S3

This repo is used for pushing assets into S3.  Bucket creation and uploading will be conducted via terraform from this repo, and downloading will be conducted in seperate apps via awscli or some other in-language means.

###### Usage

First ensure the env variables `HOBBY_AWS_ACCESS_KEY_ID` and `HOBBY_AWS_SECRET_ACCESS_KEY` are properly set.  You'll also need to install the awscli tool, so run a command such as `sudo apt-get install awscli`.  Then see example usages below.

###### Bucket Making

```
$ ./deploy dev plan
$ ./deploy dev apply
$ ./deploy dev state show aws_s3_bucket.secret
```

###### Uploading a Folder

```
$ aws s3 sync secrets/ s3://secrets-dev/secrets
```

###### Downloading a Folder

```
$ aws s3 cp s3://secrets-dev/secrets /tmp/secrets
```

Or use the example demo included in this repo to test downloading from S3.


### Buckets

###### Secrets
I need to push a folder of secrets up to S3 so that it can easily be downloaded by my peers via various app setup scripts.

###### Static Site
I need to just prove that I can host a static site on S3 (possibly with cloudfront too??).

###### tf_state
I need a way to share my tf_state from the `kingdom_terraform` across multiple computers/ peers.

