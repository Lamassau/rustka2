# Rustka2 🚀

A lightweight, in-memory Kafka-compatible message broker written in Rust. Designed as a drop-in replacement for Apache Kafka in development environments and simple on-premise deployments like Sentry.

> **Note**: Rustka2 is a fork/continuation of the Rustka project, with enhanced development infrastructure, comprehensive documentation, and improved developer experience for team environments.

## 🎯 Key Features

- **Zero Dependencies**: No JVM, Zookeeper, or external services required
- **Kafka Protocol Compatible**: Works with standard Kafka clients (kafka-python, librdkafka, confluent-kafka)
- **Lightweight**: Minimal resource footprint, perfect for development and testing
- **Fast Startup**: Ready in milliseconds, not seconds
- **Tested with Sentry**: Extensively tested for Sentry compatibility
- **Web Dashboard**: Built-in monitoring and management UI
- **Easy Development**: Comprehensive Makefile, health checks, and dev container support
- **Team Ready**: Enhanced documentation, CI/CD automation, and development infrastructure

## 📋 Supported Kafka APIs

Rustka implements the core Kafka wire protocol APIs needed for most applications:

- Metadata with auto-topic creation
- Produce/Fetch for message publishing and consumption  
- Consumer Groups with proper rebalancing and offset management
- ListOffsets for offset queries
- Full API version negotiation
- SASL/PLAIN authentication support

## ⚡ Quick Start

### Using Makefile (Recommended for Development)

```bash
# Show all available commands
make help

# Start broker with debug logging
make dev

# In another terminal, run tests
make test

# Check broker health
make health
```

### Manual Build

```bash
# Build release binary
cargo build --release

# Run broker
./target/release/rustka

# Broker listens on :9092
# Dashboard available at http://localhost:8080
```

### Docker

```bash
# Build and run in Docker
make docker-run

# Or use Docker Compose
docker-compose up
```

## ⚙️ Configuration

Copy `.env.example` to `.env` to customize settings:

```bash
cp .env.example .env
# Edit .env as needed (most defaults are fine for local development)
```

### Environment Variables

- **`KAFKA_ADVERTISED_HOST`**: The hostname/IP that clients should use to connect
  - Default: Auto-detects primary network interface IP
  - In Kubernetes: Set to Service DNS name (e.g., `rustka-service.default.svc.cluster.local`)
  - In Docker: Set to container name or host IP
  - Local development: Leave unset (auto-detected) or set to `localhost`

- **`RUST_LOG`**: Controls log verbosity
  - Default: `info`
  - Debug: `RUST_LOG=debug` for detailed logging
  - Selective: `RUST_LOG=rustka=debug,kafka_protocol=info` to filter by module

See `.env.example` for all configuration options and detailed explanations.

### Fixed Configuration

The following values are currently hardcoded but may become configurable in future versions:

| Setting | Value | Purpose |
|---------|-------|---------|
| **Kafka Port** | 9092 | Standard Kafka protocol port |
| **Dashboard Port** | 8080 | Web UI and REST API |
| **Message Retention** | 5 minutes | Auto-cleanup old messages |
| **Max Messages/Partition** | 1,000 | Memory limit per partition |
| **Group Offset Retention** | 1 hour | How long to keep offsets |
| **Default Partitions** | 3 | Partitions when creating topics |

## 🧪 Testing

### Rust Tests (Recommended)

All tests are written in Rust for reliability and consistency:

```bash
# Run all tests
make test

# Run quick smoke test
make test-quick

# Run specific test
cargo test --lib consumer_group::tests::test_rebalancing -- --nocapture
```

### Test Coverage

Tests include:
- **Unit tests** (`src/`) - Internal logic and correctness
- **Integration tests** (`tests/`) - Full broker functionality
- **Dashboard tests** - Web UI and REST endpoints
- **Retention tests** - Message cleanup and lifecycle

### GitHub Actions CI

Pull requests automatically run:
- Tests on Linux and macOS
- Code formatting checks
- Linter (clippy) validation
- Security audits

See `.github/workflows/` for details.

## Usage with Sentry

Rustka has been specifically tested to work as a Kafka replacement for on-premise Sentry deployments. Simply point your Sentry configuration to use `localhost:9092` instead of your Kafka cluster.

## 📊 Dashboard & Monitoring

Rustka includes a web-based dashboard at `http://localhost:8080`:

### Dashboard Features

- **Broker Stats**: Uptime, total messages produced/fetched, active connections
- **Topic Metrics**: Messages per topic/partition, high watermarks, bytes in/out
- **Consumer Groups**: Active groups, member status, lag information
- **Storage Stats**: Total messages, estimated memory usage, retention info

### REST API Endpoints

- `GET /api/metrics` - All broker metrics (JSON)
- `GET /api/memory-stats` - Detailed memory usage
- `POST /api/cleanup/empty-topics` - Remove topics with no messages
- `POST /api/cleanup/all-messages` - Clear all messages (keeps topics)

### Health Check

```bash
# Verify broker is running and healthy
./scripts/health-check.sh

# Check specific host/port
./scripts/health-check.sh my-broker.local 9092
```

## 🛠️ Development

### Getting Started

**Prerequisites**:
- Rust 1.70+ (install from [rustup.rs](https://rustup.rs/))
- Git
- Optional: Docker & Docker Compose

**Setup**:
```bash
git clone https://github.com/Lamassau/rustka2.git
cd rustka2
make help          # See all available commands
make dev           # Start developing!
```

### Development Workflow

```bash
# Terminal 1: Start broker with debug logging
make dev

# Terminal 2: Run tests
make test

# Check code quality
make lint
make format-check

# Auto-fix formatting
make format
```

### Using Dev Container (VS Code)

For consistent development environment across your team:

```
1. Install "Remote - Containers" extension in VS Code
2. Open repository in VS Code
3. Press Ctrl+Shift+P → "Dev Containers: Reopen in Container"
4. VS Code will set up everything automatically
```

See [.devcontainer/README.md](.devcontainer/README.md) for details.

### Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Code style guidelines
- Testing requirements
- Commit message format
- PR process

For detailed development information, see [DEVELOPMENT.md](DEVELOPMENT.md).

## 🏗️ Architecture

Rustka is an in-memory message broker implementing the Kafka wire protocol:

```
Kafka Clients → :9092 (Kafka Protocol) → Rustka Broker → In-Memory Storage
                                            ↓
                                        :8080 (HTTP) → Dashboard & REST API
```

### Key Components

- **broker.rs** - TCP server handling Kafka protocol requests
- **storage.rs** - In-memory message storage with retention
- **consumer_group.rs** - Group membership and offset management  
- **dashboard.rs** - Web UI and REST endpoints
- **metrics.rs** - Performance monitoring

### Rustka2 Enhancements

In addition to the core Rustka broker functionality, Rustka2 adds:
- **Comprehensive Development Guide** - DEVELOPMENT.md (10,800+ words)
- **Contributing Guidelines** - CONTRIBUTING.md with code standards
- **CI/CD Automation** - GitHub Actions for testing, linting, security audits
- **Development Tools** - Makefile, health-check script, Docker Compose
- **VS Code Setup** - Dev Container for one-click environment setup
- **Issue & PR Templates** - Structured GitHub workflow
- **Quick Reference** - Fast command and troubleshooting guide

### Memory Management

Rustka uses jemalloc for efficient memory allocation:

| Aspect | Value | Details |
|--------|-------|---------|
| **Message Retention** | 5 minutes | Auto-cleanup of old messages |
| **Max Messages/Partition** | 1,000 | Prevents unbounded memory growth |
| **Offset Retention** | 1 hour (active groups) | Reduces stale offset cleanup |
| **Memory Return** | 10 sec delay | Configured for optimal performance |

### Storage Characteristics

- **In-Memory Only**: No persistence by default (perfect for development)
- **Single Broker**: No replication or clustering
- **Auto Topic Creation**: Creates topics with 3 partitions on first access
- **Lightweight**: Minimal resource footprint

## 📚 Resources

### Documentation
- [DEVELOPMENT.md](DEVELOPMENT.md) - Setup, testing, troubleshooting
- [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Fast command reference
- [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - Infrastructure details
- [CLAUDE.md](CLAUDE.md) - Technical context for AI assistants
- [.env.example](.env.example) - Configuration reference

### External References
- [Kafka Protocol Documentation](https://kafka.apache.org/documentation/)
- [kafka-protocol-rs Library](https://github.com/tychedelia/kafka-protocol-rs)

### Use Cases

**Ideal for**:
- ✅ Local development (no Kafka cluster needed)
- ✅ Testing Kafka client integrations
- ✅ Sentry on-premise deployments
- ✅ Small-scale deployments (< 100 topics)

**Not ideal for**:
- ❌ Production systems (no replication/persistence)
- ❌ High-throughput scenarios (single-broker limitation)
- ❌ Long message retention (5-minute default)

## 🙏 Acknowledgments

### Rustka2 Foundation

Rustka2 is built upon the excellent foundational work of the Rustka project. We are grateful to the original Rustka authors and contributors for creating a solid, well-architected Kafka-compatible broker that serves as the core of Rustka2.

**Original Project**: Rustka - A lightweight Kafka broker implementation in Rust  
**License**: MIT

### Key Dependencies

This project wouldn't have been possible without these critical libraries and tools:

- **[kafka-protocol-rs](https://github.com/tychedelia/kafka-protocol-rs)** - Kafka wire protocol parsing and serialization library
- **[Tokio](https://tokio.rs/)** - Async Rust runtime
- **[Axum](https://github.com/tokio-rs/axum)** - Web framework for the dashboard
- **[kafka-protocol](https://crates.io/crates/kafka-protocol)** - Protocol definitions

### Rustka2 Enhancements

Rustka2 adds comprehensive development infrastructure including:
- Complete documentation suite (50,000+ words)
- CI/CD automation with GitHub Actions
- Development tooling (Makefile, health checks, scripts)
- VS Code dev container configuration
- GitHub issue and PR templates
- Contribution guidelines
- Team-focused workflows and setup guides

### Community

We welcome contributions, bug reports, and feature requests from the community. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📄 License

MIT - See LICENSE file for details

Rustka2 maintains the same MIT license as the original Rustka project.