## Description

Briefly describe what this PR does and why. Link any related issues:

Closes #(issue number)
Related to #(issue number)

## Type of Change

- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix or feature that changes existing behavior)
- [ ] Documentation update

## Changes Made

Describe the specific changes:

- Change 1
- Change 2
- Change 3

## Testing

How has this been tested? What tests should reviewers run?

- [ ] Unit tests pass: `make test`
- [ ] Integration tests pass (if applicable)
- [ ] No new warnings: `make lint`
- [ ] Code formatted: `make format-check`
- [ ] Manual testing completed

**Test commands**:
```bash
# Copy and run these to verify the changes
make test
make lint
```

**Manual testing**:
- [ ] Tested locally with `make dev`
- [ ] Tested with Docker: `make docker-run`
- [ ] Dashboard still works at http://localhost:8080
- [ ] Broker responds to clients on :9092

## Documentation

- [ ] Updated README.md (if needed)
- [ ] Updated DEVELOPMENT.md (if needed)
- [ ] Added/updated code comments (if needed)
- [ ] Updated .env.example (if new config vars added)

## Performance Impact

- [ ] No performance impact
- [ ] Performance improvement (describe)
- [ ] Performance regression? Acceptable because: (explain)

## Checklist

- [ ] My code follows the style guidelines
- [ ] I've run `make format` to auto-format code
- [ ] I've run `make lint` with no warnings
- [ ] I've run `make test` with all tests passing
- [ ] I've updated documentation if needed
- [ ] I've added tests for new features
- [ ] I haven't added any Python code (use Rust for tests instead)

## Reviewer Notes

Any specific areas you want reviewers to focus on?

---

## Screenshots (if applicable)

If this involves UI changes, dashboard updates, or bug fixes with visual impact:

![screenshot description](link to screenshot)

---

**Before submitting**: Run `make test && make lint && make format-check`
