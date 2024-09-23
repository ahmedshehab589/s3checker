# s3checker
Usage:

    Save the script as s3_bucket_misconf.sh.
    Make it executable:

    bash

chmod +x s3_bucket_misconf.sh

Run the script by passing the bucket name:

bash

    ./s3_bucket_misconf.sh <bucket_name>

What the Script Does:

    Bucket ACL: Tests for public ACL configuration.
    Object Listing: Checks if listing objects is allowed without credentials.
    Public Write Access: Tests if you can upload files to the bucket.
    Public Read Access: Checks if you can read specific files from the bucket.
    Bucket Policy: Retrieves and inspects the bucket policy for misconfigurations.
    CORS Configuration: Checks if the CORS configuration allows cross-origin access.
    Object Lock: Tests for object lock status.
    Multipart Upload: Tests if multipart uploads are allowed.
    Versioning: Checks if versioning is enabled.
    Logging: Tests if logging is enabled.
    Metadata Access: Retrieves object metadata to test if it’s accessible even if the object isn't.
