#!/bin/sh

echo "$AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY" > /etc/passwd-s3fs
chmod 640 /etc/passwd-s3fs
mkdir -p /mnt/$REPO

s3fs -f $REPO /mnt/$REPO &
python /usr/bin/sqs-createrepo.py
