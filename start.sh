#!/bin/sh

mkdir -p /mnt/$REPO

if [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "Using provided AWS credentials"
    echo "$AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY" > /etc/passwd-s3fs
    chmod 640 /etc/passwd-s3fs
    s3fs -f $REPO /mnt/$REPO &
else
    echo "No AWS credentials provided, assuming IAM role is being used"
    s3fs -f $REPO /mnt/$REPO -o iam_role=auto &
fi

python3 /usr/bin/sqs-createrepo.py
