#!/bin/bash

BUCKET_NAME=$1
TEST_FILE=$2
TEST_FILE_LOCAL=$3
EXAMPLE_FILE="example.txt"

if [ -z "$BUCKET_NAME" ]; then
    echo "Usage: ./s3_bucket_misconf.sh <bucket_name> <TEST_Remote_FILE> <TEST_Local_FILE> "
    exit 1
fi

echo "[INFO] Running tests on bucket: $BUCKET_NAME"

# Test 1: Bucket ACL
echo "[TEST 1] Testing bucket ACL..."
aws s3api get-bucket-acl --bucket $BUCKET_NAME --no-sign-request 2>/dev/null
if [ $? -eq 0 ]; then
    echo "[SUCCESS] Bucket ACL retrieved."
else
    echo "[INFO] Access to bucket ACL is restricted or bucket doesn't exist."
fi

# Test 2: List objects in the bucket
echo "[TEST 2] Testing bucket object listing..."
aws s3 ls s3://$BUCKET_NAME/ --no-sign-request 2>/dev/null
if [ $? -eq 0 ]; then
    echo "[SUCCESS] Bucket is publicly accessible for listing."
else
    echo "[INFO] Listing objects is restricted."
fi

# Test 3: Public write access
echo "[TEST 3] Testing public write access..."
echo "Pentest file" > $TEST_FILE_LOCAL
aws s3 cp $TEST_FILE_LOCAL s3://$BUCKET_NAME/$TEST_FILE --no-sign-request 2>/dev/null
if [ $? -eq 0 ]; then
    echo "[SUCCESS] Public write access allowed."
    echo "[CLEANUP] Deleting test file..."
    aws s3 rm s3://$BUCKET_NAME/$TEST_FILE --no-sign-request 2>/dev/null
else
    echo "[INFO] Public write access is restricted."
fi
rm -f $TEST_FILE_LOCAL

# Test 4: Public read access
echo "[TEST 4] Testing public read access for file '$TEST_FILE'..."
aws s3 cp s3://$BUCKET_NAME/$TEST_FILE ./ --no-sign-request 2>/dev/null
if [ $? -eq 0 ]; then
    echo "[SUCCESS] Public read access for file '$TEST_FILE'."
    rm -f $TEST_FILE
else
    echo "[INFO] Public read access is restricted or file '$TEST_FILE' doesn't exist."
fi

# Test 5: Bucket policy
echo "[TEST 5] Testing bucket policy..."
aws s3api get-bucket-policy --bucket $BUCKET_NAME --no-sign-request 2>/dev/null
if [ $? -eq 0 ]; then
    echo "[SUCCESS] Bucket policy retrieved."
else
    echo "[INFO] No bucket policy found or access restricted."
fi

# Test 6: CORS configuration
echo "[TEST 6] Testing CORS configuration..."
aws s3api get-bucket-cors --bucket $BUCKET_NAME --no-sign-request 2>/dev/null
if [ $? -eq 0 ]; then
    echo "[SUCCESS] CORS configuration retrieved."
else
    echo "[INFO] No CORS configuration found or access restricted."
fi

# Test 7: Object lock configuration
echo "[TEST 7] Testing object lock configuration..."
aws s3api get-object-lock-configuration --bucket $BUCKET_NAME --no-sign-request 2>/dev/null
if [ $? -eq 0 ]; then
    echo "[SUCCESS] Object lock configuration retrieved."
else
    echo "[INFO] No object lock configuration found or access restricted."
fi

# Test 8: Multipart upload
echo "[TEST 8] Testing multipart upload permissions..."
UPLOAD_ID=$(aws s3api create-multipart-upload --bucket $BUCKET_NAME --key "$TEST_FILE" --no-sign-request --output text --query UploadId 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "[SUCCESS] Multipart upload is allowed. Cleaning up..."
    aws s3api abort-multipart-upload --bucket $BUCKET_NAME --key "$TEST_FILE" --upload-id "$UPLOAD_ID" --no-sign-request
else
    echo "[INFO] Multipart upload is restricted."
fi

# Test 9: Versioning status
echo "[TEST 9] Testing bucket versioning..."
aws s3api get-bucket-versioning --bucket $BUCKET_NAME --no-sign-request 2>/dev/null
if [ $? -eq 0 ]; then
    echo "[SUCCESS] Versioning status retrieved."
else
    echo "[INFO] Versioning is disabled or access restricted."
fi

# Test 10: Logging configuration
echo "[TEST 10] Testing bucket logging configuration..."
aws s3api get-bucket-logging --bucket $BUCKET_NAME --no-sign-request 2>/dev/null
if [ $? -eq 0 ]; then
    echo "[SUCCESS] Logging configuration retrieved."
else
    echo "[INFO] No logging configuration found or access restricted."
fi

# Test 11: Fetch bucket metadata
echo "[TEST 11] Testing metadata access for '$TEST_FILE'..."
aws s3api head-object --bucket $BUCKET_NAME --key "$TEST_FILE" --no-sign-request 2>/dev/null
if [ $? -eq 0 ]; then
    echo "[SUCCESS] Object metadata retrieved for '$TEST_FILE'."
else
    echo "[INFO] Metadata access restricted or object '$TEST_FILE' does not exist."
fi

echo "\n[INFO] All tests completed."
