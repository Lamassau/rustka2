# GHCR Deployment Pipeline

This repository now includes a GitHub Actions pipeline that automatically builds and pushes Docker images to GitHub Container Registry (GHCR).

## How It Works

The workflow (`.github/workflows/build-and-push.yml`) automatically triggers on:
- Push to `main` or `master` branches
- Any git tag starting with `v` (e.g., `v1.0.0`)
- Pull requests (builds only, doesn't push)

## Image Tags

The published images receive multiple tags automatically:

| Tag Format | When It's Applied | Example |
|-----------|------------------|---------|
| `latest` | On push to default branch (master) | `ghcr.io/lamassau/rustka2:latest` |
| `vX.Y.Z` | On semantic version tags | `ghcr.io/lamassau/rustka2:v1.0.0` |
| `branch-<hash>` | On any commit | `ghcr.io/lamassau/rustka2:master-abc1234` |

## Using in Docker Compose

### Quick Start (Latest Version)

```yaml
services:
  rustka:
    image: ghcr.io/lamassau/rustka2:latest
    ports:
      - "9092:9092"  # Kafka port
      - "8080:8080"  # Dashboard
    environment:
      RUST_LOG: info
```

### Or Use Provided Compose File

```bash
docker-compose -f docker-compose.ghcr.yml up
```

### Use Specific Version

```yaml
services:
  rustka:
    image: ghcr.io/lamassau/rustka2:v1.0.0
```

## First-Time Setup (Authenticating to GHCR)

If you get permission errors, you may need to authenticate with GHCR:

```bash
# Authenticate with your GitHub token
echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin

# Or use personal access token
docker login ghcr.io
```

For public images (default), authentication is optional but recommended.

## Building Locally

If you prefer to build locally instead of using GHCR:

```bash
docker-compose up  # Uses local Dockerfile
```

## Checking Image Status

View available images and tags on GitHub:
1. Go to your repository
2. Click "Packages" tab
3. Find "rustka2" package
4. View available tags and deployment info

## Troubleshooting

**Image not found**: Wait a few minutes for the workflow to complete after pushing.

**Permission denied**: Check that your GitHub token has `write:packages` permission.

**Old image cached**: Pull fresh with: `docker pull ghcr.io/lamassau/rustka2:latest`

## Environment Variables

Common options you can set in your compose file:

```yaml
environment:
  RUST_LOG: debug|info|warn|error
  KAFKA_ADVERTISED_HOST: your-host-or-ip
```
