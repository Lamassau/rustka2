name: Bug Report
description: Report a bug or unexpected behavior
title: "[BUG] "
labels: ["bug", "triage"]

body:
  - type: markdown
    attributes:
      value: |
        Thank you for reporting a bug! Please fill out the form below to help us fix it quickly.

  - type: textarea
    id: description
    attributes:
      label: Description
      description: A clear description of the bug
      placeholder: "What went wrong?"
    validations:
      required: true

  - type: textarea
    id: reproduction
    attributes:
      label: Steps to Reproduce
      description: How to reproduce the issue
      placeholder: |
        1. Start broker with `make dev`
        2. Run test with `cargo test test_name`
        3. Observe error...
      value: |
        1. 
        2. 
        3. 
    validations:
      required: true

  - type: textarea
    id: expected
    attributes:
      label: Expected Behavior
      description: What should happen instead
      placeholder: "The broker should..."
    validations:
      required: true

  - type: textarea
    id: actual
    attributes:
      label: Actual Behavior
      description: What actually happened
      placeholder: "Instead, it..."
    validations:
      required: true

  - type: textarea
    id: logs
    attributes:
      label: Relevant Logs
      description: |
        Error messages, stack traces, or log output
        Use ``` for formatting:
        ```
        error logs here
        ```
      placeholder: |
        ```
        error message
        ```

  - type: textarea
    id: environment
    attributes:
      label: Environment
      description: Your development environment
      value: |
        - OS: (macOS / Linux / Windows + WSL2)
        - Rust version: `rustc --version`
        - Rustka commit/branch: 
        - Running locally / Docker / Dev Container
    validations:
      required: true

  - type: textarea
    id: context
    attributes:
      label: Additional Context
      description: Any other relevant information
      placeholder: "Screenshots, related issues, workarounds..."

  - type: checkboxes
    id: checklist
    attributes:
      label: Checklist
      options:
        - label: I've searched for similar issues
          required: true
        - label: I've tried the troubleshooting steps in DEVELOPMENT.md
          required: true
