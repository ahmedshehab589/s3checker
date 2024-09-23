# s3checker

## Usage:

1. Save the script as s3checker.sh
1. Make it executable:

    ```
    chmod +x s3_bucket_misconf.sh
    ```

1. Run the script by passing the bucket name:
   
```
    ./s3checker.sh <bucket_name> <remote-file> <Local-file>
```

## What the Script Does:

1. Bucket ACL: Tests for public ACL configuration.
1. Object Listing: Checks if listing objects is allowed without credentials.
1. Public Write Access: Tests if you can upload files to the bucket.
1. Public Read Access: Checks if you can read specific files from the bucket.
1. Bucket Policy: Retrieves and inspects the bucket policy for misconfigurations.
1. CORS Configuration: Checks if the CORS configuration allows cross-origin access.
1. Object Lock: Tests for object lock status.
1. Multipart Upload: Tests if multipart uploads are allowed.
1. Versioning: Checks if versioning is enabled.
1. Logging: Tests if logging is enabled.
1. Metadata Access: Retrieves object metadata to test if it’s accessible even if the object isn't.
