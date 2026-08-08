# Global Rules

- Never run `sudo` commands. If a command requires `sudo`, prompt me to run it manually.
- Don't include Claude as a co-author on Git commits.

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
