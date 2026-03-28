---
description: Create or update a coding project reference note from a local repository
argument-hint: <repo-path-or-name>
allowed-tools: [Read, Write, Glob, Grep, Edit, "Bash(ls:*)", "Bash(git:*)"]
---

Create a vault reference note for a coding repository.

## Instructions

Arguments: $ARGUMENTS

1. Resolve the repo path:
   - If $ARGUMENTS is a full path, use it directly.
   - If it is a repo name, search under `{{CODING_DIR}}` for a matching directory.
   - If ambiguous or not found, list available repos and ask the user to clarify.

2. Read the repo to extract metadata:
   - Check for README.md, package.json, build.gradle, setup.py, pyproject.toml, Cargo.toml, pom.xml
   - Determine: primary language, framework, description
   - List notable files and directories

3. Create or update `{{VAULT_FOLDER}}/coding/<repo-name>.md`:

```markdown
---
type: coding-project
repo-path: "<absolute-path>"
language: "<detected>"
framework: "<detected>"
status: active
tags: [coding]
---

# <Repo Name>

## Repository
- **Path**: `<absolute-path>`
- **Language**: <language>
- **Framework**: <framework>

## Description
<from README or inferred>

## Key Files
- <list of important files/dirs>

## Related
- [[Coding MOC]]
```

4. Update `{{VAULT_FOLDER}}/maps/Coding MOC.md` to include a link under the appropriate section.
5. Confirm what was created or updated.
