# Rustka2 Development Guide

Complete guide for getting Rustka2 running locally and contributing to the project.

**Note**: Rustka2 is an enhanced fork of Rustka, focusing on team development experience and comprehensive infrastructure.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Local Setup](#local-setup)
- [Running the Broker](#running-the-broker)
- [Development Workflow](#development-workflow)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Architecture](#architecture)
- [Common Tasks](#common-tasks)

## Prerequisites

### Required

- **Rust**: 1.70+ (install from [rustup.rs](https://rustup.rs/))
  - Check version: `rustc --version`
  - Update: `rustup update`

- **Git**: For cloning and version control
  - Check version: `git --version`

### Optional but Recommended

- **Docker & Docker Compose**: For isolated testing environments
  - Check: `docker --version && docker-compose --version`

### System Requirements

- **RAM**: 512 MB minimum, 2+ GB recommended
- **Disk**: 1 GB free space for build artifacts
- **CPU**: Any modern processor (no specific CPU features required)
- **OS**: Linux, macOS, or Windows (with WSL2)

---

## Local Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Lamassau/rustka2.git
cd rustka2
```

### 2. Install Rust (if not already installed)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.shell_rc  # or restart terminal
```

### 3. Verify Installation

```bash
rustc --version
cargo --version
make help  # Should show all available commands
```

### 4. Optional: Create .env File

Copy the example environment file to customize settings:

```bash
cp .env.example .env
# Edit .env if needed (most defaults are fine for local development)
```

---

## Running the Broker

### Quick Start (Recommended for Development)

```bash
# Build and run with debug logging
make dev

# Output should show:
# 2024-11-15T00:55:00.000Z  INFO rustka: Broker starting...
# 2024-11-15T00:55:00.001Z  INFO rustka: Listening on [::]:9092
# 2024-11-15T00:55:00.002Z  INFO rustka: Dashboard at http://localhost:8080
```

The broker is now ready to accept connections on `:9092` with dashboard at `http://localhost:8080`.

### Release Build (Optimized)

```bash
make release
./target/release/rustka
```

**Use this for:**
- Performance testing
- Production deployments
- Benchmarking

### Verify Broker is Running

In another terminal:

```bash
make health

# Output should show:
# ✅ Broker is running on :9092
# 📊 Dashboard: http://localhost:8080
```

### Stop the Broker

Press `Ctrl+C` in the terminal where it's running.

---

## Development Workflow

### Typical Day-to-Day Commands

```bash
# Start development session
make dev                    # Runs with debug logging

# In another terminal
make test                   # Run all tests
make lint                   # Check code style
make format                 # Auto-fix formatting
```

### Code Changes Workflow

1. **Make your changes** to `.rs` files

2. **Check for errors** (fast):
   ```bash
   make check
   ```

3. **Run tests**:
   ```bash
   make test
   ```

4. **Check formatting**:
   ```bash
   make format-check
   make lint
   ```

5. **Auto-fix formatting**:
   ```bash
   make format
   ```

6. **Commit and push**:
   ```bash
   git add .
   git commit -m "Your changes"
   git push
   ```

### Project Structure

```
rustka2/
├── src/
│   ├── main.rs              # Broker entry point
│   ├── lib.rs               # Library root
│   ├── broker.rs            # TCP server & protocol handling
│   ├── storage.rs           # In-memory message storage
│   ├── consumer_group.rs    # Consumer group coordination
│   ├── dashboard.rs         # Web UI (port 8080)
│   ├── metrics.rs           # Metrics collection
│   └── ...
├── tests/
│   ├── dashboard_test.rs    # Dashboard functionality
│   ├── retention_test.rs    # Message retention
│   └── ...
├── examples/
│   ├── run_all_tests.py     # Integration test runner (uses Rust-only compatible tests)
│   ├── test_*.rs            # Kafka protocol tests
│   └── ...
├── Makefile                 # Development commands
├── Cargo.toml               # Dependencies
├── .env.example             # Configuration template
└── README.md                # Project overview
```

---

## Testing

### Running Tests

```bash
# All Rust tests (recommended before committing)
make test

# Quick smoke test (faster, catches obvious issues)
make test-quick

# Specific test module
cargo test --test retention_test -- --nocapture

# Single test
cargo test --lib consumer_group::tests::test_rebalancing -- --nocapture --test-threads=1
```

### What Gets Tested

- **Unit Tests** (`src/`) - Internal logic, correctness
- **Integration Tests** (`tests/`) - Full broker functionality
- **Protocol Tests** (`examples/test_*.rs`) - Kafka wire protocol compatibility

### Test Execution Notes

- Tests run with `--test-threads=1` to avoid port conflicts
- Some tests spawn a broker instance; if tests fail with "port already in use", wait a moment and retry
- Tests write to temporary directories; nothing persists after completion

### Writing New Tests

Add tests directly in the source files:

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_your_feature() {
        // Your test code
        assert_eq!(result, expected);
    }
}
```

Run with: `cargo test --lib`

---

## Troubleshooting

### Broker Won't Start

**Error: "Address already in use"**

```bash
# Port 9092 or 8080 is already in use
# Option 1: Stop other services using these ports
# Option 2: Use different ports (requires code change)

# Check what's using port 9092
lsof -i :9092  # macOS/Linux
netstat -ano | findstr :9092  # Windows

# Kill the process
kill -9 <PID>  # macOS/Linux
taskkill /PID <PID> /F  # Windows
```

**Error: "Permission denied"**

```bash
# Trying to bind to privileged port (< 1024)?
# Either:
# 1. Use ports >= 1024 (code change needed)
# 2. Run with sudo (not recommended)
```

### Tests Failing

**"Connection refused"**

```bash
# Broker isn't running
# In another terminal: make dev
# Then retry tests
```

**"Address already in use" during tests**

```bash
# Previous test instance didn't shut down cleanly
# Solution:
#   1. Wait 5-10 seconds for port to be released
#   2. Run: lsof -i :9092 | grep rustka | awk '{print $2}' | xargs kill -9
#   3. Retry: make test
```

**Intermittent failures**

```bash
# Timing-related issues? Run single-threaded:
cargo test --lib -- --test-threads=1

# Add timeouts:
#[tokio::test(flavor = "multi_thread", worker_threads = 1)]
async fn your_test() { ... }
```

### Build Fails

**"error: linker ld not found"**

```bash
# Missing C/C++ build tools
# macOS:
#   xcode-select --install

# Linux (Debian/Ubuntu):
#   sudo apt-get install build-essential

# Linux (Fedora):
#   sudo dnf install gcc glibc-devel
```

**"error: Failed to resolve imports"**

```bash
# Dependencies not fetched yet
make install-deps
make build
```

### High Memory Usage

```bash
# Broker uses in-memory storage; expected with many messages
# Check dashboard for message counts: http://localhost:8080

# Clean up:
# 1. POST to /api/cleanup/all-messages to clear messages
# 2. Or restart the broker
```

---

## Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Kafka Clients                            │
│          (kafka-python, librdkafka, confluent-kafka)        │
└──────────────────────────┬──────────────────────────────────┘
                           │ Kafka Wire Protocol (TCP :9092)
┌──────────────────────────▼──────────────────────────────────┐
│                     Rustka Broker                           │
├──────────────────────────────────────────────────────────────┤
│ broker.rs       - TCP server, protocol parsing              │
│ storage.rs      - In-memory message queue                   │
│ consumer_group  - Group membership, rebalancing             │
│ metrics.rs      - Performance tracking                      │
│ dashboard.rs    - Web UI (port 8080)                        │
└──────────────────────────────────────────────────────────────┘
                           │ REST API (HTTP :8080)
┌──────────────────────────▼──────────────────────────────────┐
│           Web Dashboard & REST Endpoints                    │
│  - Topic/partition metrics                                  │
│  - Consumer group information                               │
│  - Cleanup operations                                       │
└──────────────────────────────────────────────────────────────┘
```

### Key Components

- **broker.rs** - Listens on :9092, handles all Kafka protocol requests
- **storage.rs** - Stores messages in memory, handles retention
- **consumer_group.rs** - Tracks consumer groups, assignments, offsets
- **dashboard.rs** - Web UI for monitoring and management

### Protocol Support

- Kafka API v3-v11 (handles most client versions)
- SASL/PLAIN authentication (accepts any credentials for testing)
- RecordBatch format with headers
- Consumer groups with rebalancing

---

## Common Tasks

### Adding a New Feature

1. **Create a test first** (TDD):
   ```rust
   #[tokio::test]
   async fn test_my_feature() {
       // What should happen?
   }
   ```

2. **Implement the feature**

3. **Run tests**:
   ```bash
   make test
   ```

4. **Check code quality**:
   ```bash
   make format
   make lint
   ```

### Debugging

**Enable debug logging**:

```bash
RUST_LOG=rustka=debug make dev
```

**For specific module**:

```bash
RUST_LOG=rustka::broker=debug make dev
```

**In code**:

```rust
eprintln!("DEBUG: value = {:?}", value);  // Prints to stderr
tracing::debug!("value = {:?}", value);   // Goes through logging system
```

### Performance Testing

```bash
# Run benchmarks (if available)
cargo bench

# Profile memory usage
cargo build --release
./target/release/rustka  # Watch dashboard at http://localhost:8080
```

### Docker Development

```bash
# Build Docker image
make docker-build

# Run in Docker
make docker-run

# Or manually:
docker build -t rustka:latest .
docker run -p 9092:9092 -p 8080:8080 rustka:latest
```

---

## Getting Help

### Resources

- **Kafka Protocol**: [Kafka Documentation](https://kafka.apache.org/documentation/)
- **Tokio Async**: [Tokio Guide](https://tokio.rs/)
- **Rust**: [Rust Book](https://doc.rust-lang.org/book/)

### Questions or Issues?

1. Check existing issues on GitHub
2. Review code comments and documentation
3. Ask in PRs - maintainers are happy to help!

---

## Contributing

When submitting changes:

1. Run `make test` - all tests must pass
2. Run `make lint` - no clippy warnings
3. Run `make format` - code must be formatted
4. Update docs if your change affects users
5. Write clear commit messages

See the repository's CONTRIBUTING.md for detailed guidelines.

---

**Happy coding! 🚀**
