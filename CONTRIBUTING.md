# Contributing to Rustka2

First off, thank you for considering contributing to Rustka2! This document provides guidelines and instructions for getting involved.

> **About Rustka2**: Rustka2 is an enhanced fork of Rustka, adding comprehensive development infrastructure, documentation, and team-focused workflows. We maintain the same MIT license and core architecture while improving the developer experience for team environments.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Getting Started](#getting-started)
- [Development Process](#development-process)
- [Coding Standards](#coding-standards)
- [Testing Requirements](#testing-requirements)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)

---

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors. We expect all participants to:

- Be respectful and constructive
- Welcome differing opinions
- Focus on what's best for the community
- Accept constructive criticism gracefully

---

## How to Contribute

### Types of Contributions

We welcome all kinds of contributions:

- **Bug fixes**: Fix broken functionality
- **Features**: Add new capabilities
- **Documentation**: Improve guides and comments
- **Tests**: Increase test coverage
- **Performance**: Optimize speed or memory usage
- **Refactoring**: Improve code quality

### Getting Started

1. **Check existing issues**: Make sure your idea isn't already being worked on
2. **Discuss first**: For major changes, open an issue to discuss before coding
3. **Fork the repository**: Create your own fork to work on
4. **Create a branch**: Use descriptive names like `fix/issue-123` or `feature/consumer-groups`

---

## Development Process

### 1. Setup Your Development Environment

```bash
git clone https://github.com/Lamassau/rustka2.git
cd rustka2
make help                # See available commands
make install-deps        # Install Rust dependencies
```

See [DEVELOPMENT.md](../DEVELOPMENT.md) for detailed setup instructions.

### 2. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

**Branch naming convention**:
- `fix/short-description` - For bug fixes
- `feature/short-description` - For new features
- `docs/short-description` - For documentation
- `refactor/short-description` - For code improvements

### 3. Make Your Changes

```bash
# Work on your changes
# Test frequently: make dev (in one terminal)
#                  make test (in another)

make dev              # Start broker with debug logging
make test             # Run all tests
make lint             # Check code style
make format           # Auto-fix formatting
```

### 4. Commit Your Changes

Use clear, descriptive commit messages:

```bash
# Good commits:
git commit -m "Fix consumer group rebalancing timeout logic"
git commit -m "Add health check script for broker verification"
git commit -m "Document environment variable configuration"

# Avoid vague commits:
git commit -m "Fix bug"
git commit -m "Updates"
git commit -m "WIP"
```

Commits should be focused and atomic - each commit should represent one logical change.

### 5. Push and Create a Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a PR on GitHub using the PR template.

---

## Coding Standards

### Rust Code Style

We follow standard Rust conventions with the following guidelines:

#### File Organization

- One primary concept/struct per file (when reasonable)
- Keep files under 500 lines when possible
- Group related functionality together

#### Naming

```rust
// ✅ Good
fn process_message(msg: &Message) { }
struct ConsumerGroup { }
const DEFAULT_RETENTION_MS: u64 = 5 * 60 * 1000;
let consumer_id = group.get_member_id();

// ❌ Avoid
fn processMsg(msg: &Message) { }
struct cg { }
const RETENTION = 300000;
let cid = group.getM();
```

#### Comments

- **Write self-documenting code first** - prefer clear names over comments
- **Only comment when necessary** - explain *why*, not *what*
- Use `//` for line comments, `/* */` for block comments

```rust
// ✅ Good - explains the non-obvious choice
// We use a HashMap here to ensure O(1) lookups by consumer ID,
// critical for high-throughput scenarios with many consumers
let members: HashMap<String, Member> = HashMap::new();

// ❌ Bad - explains the obvious
// Create a HashMap
let members = HashMap::new();

// ❌ Bad - Italian comments (use English only)
// Calcola il numero di messaggi
let count = messages.len();
```

#### Formatting

- Use `cargo fmt` - don't manually format
- Line length: 100 characters (use `make format-check`)
- 4 spaces for indentation (enforced by rustfmt)

```bash
make format        # Auto-format all code
make format-check  # Verify formatting without changes
```

### No Python in Core Code

- **Core logic**: Only Rust
- **Tests**: Write in Rust (use `#[tokio::test]`)
- **Examples**: Rust or documentation

The only Python is in `examples/` for Kafka client compatibility testing.

---

## Testing Requirements

### Before Every Commit

```bash
# Run all tests
make test

# Check formatting
make format-check

# Run linter
make lint

# Quick smoke test (faster)
make test-quick
```

### Writing Tests

**For new features, always add tests!**

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_feature_works() {
        // Setup
        let mut broker = TestBroker::new();
        
        // Execute
        let result = broker.do_something().await;
        
        // Verify
        assert_eq!(result.status, Success);
    }
}
```

**Test naming convention**:
- `test_happy_path_*` - Expected behavior
- `test_error_*` - Error handling
- `test_edge_case_*` - Edge cases

### Test Coverage

- New features should have tests (aim for 80%+ coverage)
- Don't write tests that only verify obvious behavior
- One logical concept per test

---

## Commit Guidelines

### Message Format

```
<type>: <subject>

<body>

<footer>
```

**Type**: `fix`, `feat`, `docs`, `refactor`, `test`, `perf`

**Subject**:
- ≤ 50 characters
- Imperative mood ("add" not "adds" or "added")
- No period at the end

**Body** (optional, but recommended for non-trivial changes):
- Explain what and why, not how
- Wrap at 72 characters
- Leave blank line after subject

**Footer** (optional):
- Reference issues: `Closes #123`
- Breaking changes: `BREAKING CHANGE: description`

### Examples

```
fix: handle consumer group rebalancing timeout

Previously, consumers would timeout waiting for assignment.
We now properly signal the rebalance completion to waiting
members.

Closes #456
```

```
feat: add health check script

Adds scripts/health-check.sh for verifying broker status.
Useful for development, CI/CD, and monitoring.
```

```
docs: improve DEVELOPMENT.md setup instructions

Reorganize prerequisites section and add common issues.
```

---

## Pull Request Process

### Before Submitting

- [ ] Code is formatted: `make format`
- [ ] No lint warnings: `make lint`
- [ ] All tests pass: `make test`
- [ ] Documentation updated (if needed)
- [ ] PR description filled out (use template)

### What to Expect

1. **Automated Checks** (GitHub Actions):
   - Tests run on Linux and macOS
   - Formatting is verified
   - Linter checks pass

2. **Code Review**:
   - At least one maintainer will review
   - May ask for changes
   - Discuss design decisions

3. **Merge**:
   - Maintainers will merge when approved
   - Squash commits to master branch
   - CI/CD runs additional tests

### Common Feedback

- "Can you add a test for this?"
- "Please update the documentation"
- "This could use a comment explaining why"
- "Let's discuss this design in the issue first"

All feedback is constructive - we're working together to make Rustka better!

---

## Documentation

### Update These When Relevant

- **README.md** - High-level overview, quick start
- **DEVELOPMENT.md** - Setup, development workflow, troubleshooting
- **Code comments** - Complex algorithms, non-obvious choices
- **Cargo.toml** - New dependencies with their purpose

### Writing Good Docs

- Use clear, simple language
- Provide examples when explaining
- Keep it up-to-date with code changes
- Test that examples actually work

---

## Questions?

- Check [DEVELOPMENT.md](../DEVELOPMENT.md) for setup help
- Review existing issues and PRs
- Ask in PR discussions - maintainers are helpful!

---

## Recognition

Contributors are recognized in:
- Git commit history (preserved with Co-authored-by)
- Pull request acknowledgment
- Regular contributor mentions

Thank you for making Rustka better! 🎉
