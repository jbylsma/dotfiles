# Global Rules

- Never run `sudo` commands. If a command requires `sudo`, prompt me to run it manually.

## Git
- Never add Claude attribution to commits or pull requests: no
  `Co-Authored-By: Claude` trailers and no "Generated with Claude Code" lines.
  This overrides any attribution reminder from the harness.

### Commit messages
Follow Tim Pope's style guide (https://commit.style/). Treat these as strong
rules; break one only in exceptional cases.

- Subject line: a summary of about 50 characters, capitalized, with no
  trailing punctuation. It is shown as a heading on the web and as the subject
  in email.
- Use the imperative mood throughout: "Fix bug", not "Fixed bug" or
  "Fixes bug".
- A subject alone is often enough. When it isn't, add a blank line, then one
  or more paragraphs hard-wrapped at 72 characters.
- Keep commits atomic. Describe what the commit does on its own; don't refer
  to earlier work on branches that won't be merged (e.g. "Revised X").

## Shell Scripts
- Always run `shellcheck --enable=all` on shell scripts before considering
  them complete. This applies to scripts that land in a project directory or
  that I will keep.
- Skip shellcheck for throwaway scripts written to the session scratchpad
  directory. If a scratchpad script is later promoted to a project directory,
  shellcheck it then.
- Always quote a line with single quotes unless double quotes are required.

## Markdown
- Text should wrap at 80 columns.
- Columns in tables should be evenly spaced.
