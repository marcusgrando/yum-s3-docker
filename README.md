# YUM S3 Docker

This Docker container allows mounting an S3 bucket and executing the `createrepo_c` command to update the metadata of a YUM repository stored in S3.

## Optimizations

The Docker image has been optimized to have the smallest possible size:

- Uses Rocky Linux 9 Minimal as the base image
- Utilizes native packages from Rocky Linux 9 and EPEL:
  - s3fs-fuse: to mount the S3 bucket
  - createrepo_c: optimized C version of createrepo
  - python3 and python3-boto: for AWS interaction
- Uses the microdnf package manager for lighter installations
- Removes caches and temporary files after installation

## Environment Variables

- `REPO`: S3 bucket name and SQS queue name
- `REGION`: AWS region
- `AWS_ACCESS_KEY_ID`: AWS access key
- `AWS_SECRET_ACCESS_KEY`: AWS secret key

## How to Use

```bash
docker run -d \
  -e REPO=my-bucket \
  -e REGION=us-east-1 \
  -e AWS_ACCESS_KEY_ID=your-access-key \
  -e AWS_SECRET_ACCESS_KEY=your-secret-key \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  --security-opt apparmor:unconfined \
  yum-s3-docker
```

## CI/CD and Security

This image includes a GitHub Actions workflow that:

### Continuous Integration/Deployment
1. Automatically builds and pushes a new Docker image on every push to the master/main branch
2. Ensures that the latest code changes are always reflected in the Docker image

### Security Updates
1. Runs a security check automatically once a week (Sunday at midnight)
2. Pulls the latest image from the registry and checks for available security updates
3. If security updates are found or if the image doesn't exist, automatically builds a new image with the latest updates
4. Publishes the updated image to the configured Docker registry

### GitHub Actions Configuration

For the security workflow to function correctly, you need to configure the following secrets in your GitHub repository:

- `DOCKERHUB_USERNAME`: Your Docker Hub username
- `DOCKERHUB_TOKEN`: Docker Hub access token
- `DOCKER_REGISTRY`: Docker registry URL (e.g., "username" for Docker Hub)

## How It Works

1. The container mounts the specified S3 bucket using s3fs-fuse
2. It monitors an SQS queue with the same name as the bucket
3. When an .rpm file is added to the bucket or a .createrepo file is found, it executes the createrepo_c command to update the repository metadata
