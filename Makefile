.PHONY: help build release dev test lint clean install-deps run check health docker-build docker-run format

SHELL := /bin/bash
CARGO := cargo
RUST_LOG ?= info

help:
	@echo "╔════════════════════════════════════════════════════════════╗"
	@echo "║      Rustka2 - Kafka-compatible Broker Commands           ║"
	@echo "╚════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "📦 BUILD & RUN"
	@echo "  make build              Build debug binary"
	@echo "  make release            Build optimized release binary"
	@echo "  make run                Run the broker (debug mode)"
	@echo "  make dev                Run with debug logging"
	@echo ""
	@echo "🧪 TESTING"
	@echo "  make test               Run all Rust tests"
	@echo "  make test-quick         Quick smoke test"
	@echo "  make lint               Run clippy linter"
	@echo "  make format             Auto-format code"
	@echo "  make format-check       Check formatting without changes"
	@echo ""
	@echo "🔧 UTILITIES"
	@echo "  make clean              Remove build artifacts"
	@echo "  make check              Run cargo check"
	@echo "  make health             Verify broker health (must be running)"
	@echo "  make install-deps       Install Rust dependencies"
	@echo ""
	@echo "🐳 DOCKER"
	@echo "  make docker-build       Build Docker image"
	@echo "  make docker-run         Run broker in Docker"
	@echo ""

install-deps:
	@echo "📥 Installing Rust dependencies..."
	$(CARGO) fetch
	@echo "✅ Dependencies installed"

build:
	@echo "🔨 Building debug binary..."
	$(CARGO) build
	@echo "✅ Built to ./target/debug/rustka"

release:
	@echo "🚀 Building release binary..."
	$(CARGO) build --release
	@echo "✅ Built to ./target/release/rustka (optimized)"

run: build
	@echo "🚀 Starting broker..."
	./target/debug/rustka

dev: build
	@echo "🚀 Starting broker with debug logging..."
	RUST_LOG=debug ./target/debug/rustka

test: install-deps
	@echo "🧪 Running Rust tests..."
	$(CARGO) test --lib --bins -- --test-threads=1
	@echo "✅ All Rust tests passed"

test-quick:
	@echo "⚡ Quick smoke test (dashboard & retention)..."
	$(CARGO) test --test dashboard_test --test retention_test -- --test-threads=1 --nocapture
	@echo "✅ Smoke tests passed"

lint:
	@echo "🔍 Checking code style with clippy..."
	$(CARGO) clippy --all-targets --all-features -- -D warnings
	@echo "✅ No lint issues found"

format:
	@echo "📝 Auto-formatting code..."
	$(CARGO) fmt --all
	@echo "✅ Code formatted"

format-check:
	@echo "📝 Checking code format..."
	$(CARGO) fmt --all -- --check
	@echo "✅ Code is properly formatted"

check:
	@echo "🔎 Running cargo check..."
	$(CARGO) check --all-targets
	@echo "✅ Check passed"

clean:
	@echo "🧹 Cleaning build artifacts..."
	$(CARGO) clean
	rm -rf target/
	@echo "✅ Clean complete"

health:
	@echo "🏥 Checking broker health..."
	@if ! command -v nc &> /dev/null; then \
		echo "❌ 'nc' (netcat) not found. Cannot check health."; \
		exit 1; \
	fi
	@if nc -z localhost 9092 &>/dev/null; then \
		echo "✅ Broker is running on :9092"; \
		echo "📊 Dashboard: http://localhost:8080"; \
	else \
		echo "❌ Broker is NOT running on :9092"; \
		echo "💡 Start the broker with: make dev"; \
		exit 1; \
	fi

docker-build:
	@echo "🐳 Building Docker image..."
	docker build -t rustka:latest .
	@echo "✅ Docker image built: rustka:latest"

docker-run: docker-build
	@echo "🐳 Running Rustka in Docker..."
	docker run -it \
		-p 9092:9092 \
		-p 8080:8080 \
		-e RUST_LOG=info \
		rustka:latest

.DEFAULT_GOAL := help
