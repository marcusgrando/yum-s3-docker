FROM rockylinux:9-minimal

# Default ENVs
ENV REPO=none
ENV REGION=none

# Install EPEL repository and update all packages for security
RUN microdnf install -y epel-release && \
    microdnf upgrade -y && \
    microdnf clean all

# Install necessary packages
RUN microdnf install -y --nodocs \
    s3fs-fuse \
    createrepo_c \
    rsync \
    python3 \
    python3-boto3 \
    && microdnf clean all \
    && rm -rf /var/cache/yum

# Add scripts
COPY ./start.sh /usr/bin/start.sh
COPY ./sqs-createrepo.py /usr/bin/sqs-createrepo.py

RUN chmod +x /usr/bin/start.sh
CMD ["/usr/bin/start.sh"]
