# AGENTS

## Trunk (code quality and security)

This repo uses Trunk for security scanning and pre-commit hooks.

At the start of a session, check whether trunk hooks are active:
`git config core.hooksPath 2>/dev/null | grep -q trunk || echo "not installed"`

If trunk is not initialised, run `trunk install` to activate the pre-commit and
pre-push hooks before starting work.
