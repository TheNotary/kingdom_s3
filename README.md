# Kingdom S3

This repo is used for pushing assets into S3.  Bucket creation and uploading will be conducted via terraform from this repo, and downloading will be conducted in seperate apps via awscli or some other in-language means.


###### Setup
```
$ sudo apt-get install awscli
```

### Buckets

###### Secrets
I need to push a folder of secrets up to S3 so that it can easily be downloaded by my peers via various app setup scripts.

###### Static Site
I need to just prove that I can host a static site on S3 (possibly with cloudfront too??).

###### tf_state
I need a way to share my tf_state from the `kingdom_terraform` across multiple computers/ peers.
