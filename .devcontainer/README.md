# Rustka2 Dev Container Setup

This directory contains configuration for VS Code Dev Containers for Rustka2 development.

## Quick Start

1. **Install VS Code Extensions**:
   - Remote - Containers (ms-vscode-remote.remote-containers)
   
2. **Reopen in Container**:
   - Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on macOS)
   - Type "Dev Containers: Reopen in Container"
   - VS Code will build and start the dev environment

3. **Wait for Setup**:
   - The container will install all dependencies
   - First build takes ~2-3 minutes
   - Subsequent opens are much faster

4. **Start Developing**:
   ```bash
   make dev          # Start the broker
   make test         # Run tests
   make lint         # Check code
   ```

## What's Included

- **Rust**: Latest stable toolchain
- **Tools**: cargo, rustfmt, clippy, lldb
- **VS Code Extensions**:
  - rust-analyzer (IntelliSense, debugging)
  - CodeLLDB (debugger)
  - Crates (dependency version management)
  - Even Better TOML (Cargo.toml editing)
  - Docker (container management)

## Port Forwarding

Ports are automatically forwarded and accessible on your machine:

- **:9092** - Kafka broker (open with `localhost:9092`)
- **:8080** - Dashboard (open with `http://localhost:8080`)

## Benefits

✅ **Consistent Environment**: Same setup for all team members
✅ **No Local Installation**: No need to install Rust on your machine
✅ **Isolated**: Doesn't affect your system Rust installation
✅ **Easy Cleanup**: Just delete the container to clean up
✅ **VS Code Integration**: Full IDE support out of the box

## Troubleshooting

**"Docker daemon not running"**
- Start Docker Desktop
- Or start Docker daemon: `docker info`

**"Can't connect to container"**
- Rebuild: `Dev Containers: Rebuild Container`

**"Out of disk space"**
- Clean up: `docker system prune -a`
- Or rebuild with smaller cache

**"Slow performance"**
- On macOS/Windows: Docker Desktop settings → Resources → increase CPU/Memory
- On Linux: Usually fine, check `docker stats`
