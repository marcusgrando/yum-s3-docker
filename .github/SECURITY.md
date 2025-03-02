# Security

## CI/CD and Automatic Security Updates

This repository includes a GitHub Actions workflow that handles both CI/CD and security updates for the Docker image.

### How It Works

#### Continuous Integration/Deployment
1. The workflow automatically builds and pushes a new Docker image on every push to the master/main branch
2. This ensures that the latest code changes are always reflected in the Docker image

#### Security Updates
1. The workflow runs a security check automatically once a week (Sunday at midnight)
2. It pulls the latest image from the registry and checks for available security updates
3. If updates are found or if the image doesn't exist, it automatically builds a new image with the latest fixes
4. It publishes the updated image to the configured Docker registry

### Configuration

For the security workflow to function correctly, you need to configure the following secrets in your GitHub repository:

1. Access your repository settings on GitHub
2. Go to "Settings" > "Secrets and variables" > "Actions"
3. Add the following secrets:

| Name | Description |
|------|-------------|
| `DOCKERHUB_USERNAME` | Your Docker Hub username |
| `DOCKERHUB_TOKEN` | Docker Hub access token (don't use your password) |
| `DOCKER_REGISTRY` | Docker registry URL (e.g., "username" for Docker Hub) |

### Manual Execution

You can also run the workflow manually:

1. Go to the "Actions" tab in your repository
2. Select the "Security Updates" workflow
3. Click on "Run workflow"
4. Select the branch and click on "Run workflow"

## Best Practices

- Keep the security workflow enabled
- Periodically check the workflow execution logs
- Update project dependencies regularly
- Consider adding additional vulnerability scanning
