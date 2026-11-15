name: Feature Request
description: Suggest a new feature or improvement
title: "[FEATURE] "
labels: ["enhancement", "triage"]

body:
  - type: markdown
    attributes:
      value: |
        Have an idea to make Rustka better? Share it here!

  - type: textarea
    id: problem
    attributes:
      label: Problem Statement
      description: What problem does this solve?
      placeholder: "Currently, it's difficult to... / Users need... / It would be helpful if..."
    validations:
      required: true

  - type: textarea
    id: solution
    attributes:
      label: Proposed Solution
      description: How would you like this feature to work?
      placeholder: "The feature should... / A new command like `make ...` could..."
    validations:
      required: true

  - type: textarea
    id: alternatives
    attributes:
      label: Alternatives Considered
      description: Other approaches you've thought about
      placeholder: |
        - Option A: ...
        - Option B: ...
        - Option C: ...

  - type: textarea
    id: benefits
    attributes:
      label: Benefits
      description: Why would this be useful?
      placeholder: |
        - Improves developer experience by...
        - Saves time when...
        - Makes testing easier by...

  - type: textarea
    id: context
    attributes:
      label: Additional Context
      description: Any other relevant information
      placeholder: "Related issues, inspiration from other projects, examples..."

  - type: checkboxes
    id: checklist
    attributes:
      label: Checklist
      options:
        - label: I've checked for similar feature requests
        - label: This aligns with Rustka's goals
