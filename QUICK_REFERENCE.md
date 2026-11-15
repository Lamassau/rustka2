# Quick Reference Guide for Rustka2 Development

## 🚀 Getting Started (5 minutes)

```bash
# 1. Clone and enter directory
git clone https://github.com/Lamassau/rustka2.git
cd rustka2

# 2. Start the broker (with debug logging)
make dev

# Output should show:
# ✅ Broker listening on :9092
# ✅ Dashboard at http://localhost:8080

# 3. In a new terminal, verify it's working
make health

# 4. Run tests
make test
```

**You're now productive!** 🎉

---

## 📖 Documentation Map

Need help? Here's where to look:

| Question | Document | What You'll Find |
|----------|----------|------------------|
| What is Rustka2? | **README.md** | Features, quick start, use cases |
| How do I set up? | **DEVELOPMENT.md** | Step-by-step setup, prerequisites |
| How do I run tests? | **Makefile** or **DEVELOPMENT.md** | Test commands and examples |
| What's broken? | **DEVELOPMENT.md** → Troubleshooting | Solutions for common issues |
| What are the configs? | **.env.example** | All environment variables explained |
| How do I contribute? | **CONTRIBUTING.md** | Code standards, PR process |
| How do I debug? | **DEVELOPMENT.md** → Debugging | Logging, inspector tools |
| VS Code setup | **.devcontainer/README.md** | Dev container instructions |

---

## 🎯 Daily Commands

### Start Your Day
```bash
# Terminal 1: Start broker with debug logging
make dev

# Terminal 2: Run tests
make test

# Terminal 3: Check health
make health
```

### Before Committing
```bash
make format          # Auto-fix formatting
make lint            # Check code style (should have 0 warnings)
make test            # Run all tests (should all pass)
```

### Push to GitHub
```bash
git add .
git commit -m "Your clear commit message"
git push origin your-branch-name
```

**GitHub CI automatically runs**: tests, linting, formatting check, security audit

---

## 🧪 Testing

### Run Tests
```bash
make test            # All tests
make test-quick      # Quick smoke test
```

### Write a Test
Add to your `.rs` file:
```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_my_feature() {
        // Arrange
        let mut broker = setup_test_broker();
        
        // Act
        let result = broker.do_something().await;
        
        // Assert
        assert_eq!(result.status, Success);
    }
}
```

---

## 🐛 Troubleshooting (30 seconds)

### "Port already in use"
```bash
# Kill the old process
lsof -i :9092 | grep rustka | awk '{print $2}' | xargs kill -9

# Or run on different port (need code change)
# Or use Docker: make docker-run
```

### "Tests fail with connection refused"
```bash
# Broker isn't running - start it:
make dev  # In another terminal

# Then retry tests:
make test
```

### "Can't figure out what's wrong"
```bash
# Run with debug logging:
RUST_LOG=debug make dev

# Check full documentation:
cat DEVELOPMENT.md | grep -A 20 "Troubleshooting"
```

### "Formatting doesn't match"
```bash
# Auto-fix it:
make format

# Or check without fixing:
make format-check
```

---

## 🚀 Common Tasks

### Add a New Feature
```bash
# 1. Create a branch
git checkout -b feature/my-feature

# 2. Write tests first
# (Add test to src/your_module.rs)

# 3. Implement feature

# 4. Verify
make test && make lint && make format-check

# 5. Commit and push
git add .
git commit -m "feat: add my feature"
git push origin feature/my-feature

# 6. Create PR on GitHub (use template)
```

### Fix a Bug
```bash
# Same process as feature, but:
git checkout -b fix/issue-description

# Commit message:
git commit -m "fix: describe what you fixed

# Explain why the bug happened and how fix works"
```

### Debug a Problem
```bash
# Enable debug logging
RUST_LOG=rustka=debug make dev

# Or specific module
RUST_LOG=rustka::broker=debug make dev

# Watch the output for clues
```

### Check Broker Status
```bash
# Full health check
./scripts/health-check.sh

# Or via Makefile
make health

# Or in browser
# Visit http://localhost:8080 for dashboard
```

---

## 📦 Architecture (10,000 foot view)

```
Your Code (Kafka client)
        ↓
   TCP :9092
        ↓
    Rustka Broker
    ├── broker.rs ........... Handles protocol
    ├── storage.rs ......... In-memory storage
    ├── consumer_group.rs ... Group management
    ├── dashboard.rs ....... Web UI
    └── metrics.rs ......... Performance tracking
        ↓
   HTTP :8080
        ↓
  Browser Dashboard
```

---

## 🐳 Docker Commands

### Run in Docker
```bash
# Quick start
make docker-run

# Or with docker-compose
docker-compose up

# Stop
docker-compose down

# View logs
docker-compose logs -f rustka
```

### Access from Docker
- Broker: `rustka:9092` (from other containers)
- Broker: `localhost:9092` (from your machine)
- Dashboard: `http://localhost:8080`

---

## 🔍 Checking Code Quality

```bash
# All at once (recommended before commit)
make lint && make format-check && make test

# Individual checks
make lint                # Clippy linting
make format-check        # Just show formatting issues
make format              # Auto-fix formatting
make test                # Run all tests
make check               # Fast cargo check (no tests)
```

**All PRs automatically fail if**:
- Tests don't pass
- Code isn't formatted
- Clippy finds issues

---

## 💡 Pro Tips

### Use VS Code Dev Container
```
Ctrl+Shift+P → "Dev Containers: Reopen in Container"
# Everything set up automatically!
# Debugging works out of the box
# All extensions pre-installed
```

### Chain Commands
```bash
# Shorter to write, same result
make format && make lint && make test && git push

# Or use the Makefile directly:
cargo fmt && cargo clippy && cargo test
```

### Environment Variables
```bash
# Debug mode with custom host
RUST_LOG=debug KAFKA_ADVERTISED_HOST=myhost make dev

# Or create .env file
cp .env.example .env
# Edit .env
make dev  # Automatically uses .env
```

### Faster Testing
```bash
# Just the quick smoke test
make test-quick

# Single test file
cargo test --test retention_test

# Single test
cargo test --lib storage::tests::test_retention
```

---

## 📞 Getting Help

### Before Asking
1. **Check documentation**: DEVELOPMENT.md section for your issue
2. **Search GitHub issues**: Your problem might be solved
3. **Check Troubleshooting**: DEVELOPMENT.md has solutions

### Asking Effectively
- Describe what you did
- Show the error message
- Your environment (OS, Rust version, setup method)
- Steps to reproduce

### Useful Commands for Bug Reports
```bash
# Version info
rustc --version
cargo --version

# Check what's running
lsof -i :9092
ps aux | grep rustka

# View logs
tail -100 /tmp/rustka.log  # If logging to file

# Broker info
make health                 # Shows if broker is up
curl http://localhost:8080/api/metrics | jq .  # Get metrics
```

---

## 🎓 Learn More

### Beginner Path
1. Read README.md (what is this?)
2. Follow DEVELOPMENT.md setup (make it work)
3. Run `make test` (verify it works)
4. Read DEVELOPMENT.md Architecture section (understand it)
5. Modify a simple test (hands-on learning)

### Contributor Path
1. Read CONTRIBUTING.md (understand standards)
2. Find "good first issue" on GitHub
3. Create feature branch
4. Make change → test → commit → PR
5. Review feedback → iterate → merge

### Advanced Path
1. Study CLAUDE.md (technical details)
2. Read actual code in src/
3. Add a feature from issue list
4. Optimize or refactor something
5. Consider performance/architecture tradeoffs

---

## ✅ Pre-PR Checklist

Before creating a pull request:

```
[ ] I ran `make test` and all passed
[ ] I ran `make lint` with 0 warnings
[ ] I ran `make format` and committed changes
[ ] I updated DEVELOPMENT.md (if needed)
[ ] I updated README.md (if needed)
[ ] I added tests for new functionality
[ ] Commit messages are clear and descriptive
[ ] I read CONTRIBUTING.md section on PRs
[ ] I filled out the PR template completely
```

**Pro tip**: GitHub won't let you merge unless CI passes anyway, so running these locally saves time!

---

## 🚀 Fastest Path to First Contribution

```bash
# 1. Setup (5 min)
git clone https://github.com/Lamassau/rustka2.git
cd rustka2
make dev &
make test

# 2. Find Issue (5 min)
# Open GitHub → Issues → filter: "good first issue"

# 3. Code (15-30 min depending on task)
git checkout -b fix/issue-123
# Edit files, add test, verify

# 4. Polish (5 min)
make format && make lint && make test

# 5. Submit (5 min)
git commit -m "fix: clear message"
git push origin fix/issue-123
# Create PR on GitHub

# Total: ~45 minutes for your first PR! 🎉
```

---

**Last Updated**: November 15, 2024  
**For Questions**: See DEVELOPMENT.md or CONTRIBUTING.md  
**Ready to Code**: `make dev` 🚀

---

**About Rustka2**: An enhanced fork of Rustka focusing on team development, comprehensive documentation, and infrastructure automation.
