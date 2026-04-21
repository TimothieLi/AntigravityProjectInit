## Context

The repository has just been initialized with OpenSpec for structured workflows, but the legacy codebase sits in a newly merged GitHub root and partially in the local `AIOT HW2` directory. We need to formalize the environment structure so future development operates flawlessly under OpenSpec.

## Goals / Non-Goals

**Goals:**
- Move all relevant source files into the root project directory or designated `src` directory.
- Maintain existing git histories while integrating them cleanly.
- Establish a uniform environment config.

**Non-Goals:**
- Rewriting or refactoring the legacy code functionality.
- Changing technology stacks.

## Decisions

- **Decision 1:** Existing `.git` repository maintains the remote `origin` from `AntigravityProjectInit`.
- **Decision 2:** Any local detached code in sub-directories like `AIOT HW2` will be tracked into the new project root structure through standard `git add/commit`.

## Risks / Trade-offs

- Overwriting existing un-committed code. Mitigation: Run `git status` to ensure all local changes are safely staged and merged without destructive overwrites.
