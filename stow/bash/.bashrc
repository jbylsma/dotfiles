# Private function for quietly checking for command
function _which {
  command -v "$@" >/dev/null 2>&1
  return $?
}

# Reset PATH on OS X keep it from being clobbered in tmux
# See https://github.com/yyuu/pyenv/issues/85
if [ -x /usr/libexec/path_helper ]; then
  #shellcheck disable=SC2123
  PATH=''
  #shellcheck disable=SC1091
  source /etc/profile
fi

# History configuration
export HISTSIZE=
export HISTFILESIZE=
shopt -s histappend

# Terminal configuration
if [ -n "${PS1}" ]; then
  # If background jobs, set path color to red, otherwise green.
  # If SSH, set host color to red, otherwise bold cyan.
  export PS1="\[\e[\$( [ ! -z \"\$(jobs -p)\" ] && echo -n '31' || echo -n '32' )m\][\w]\[\e[0m\]\n\[\e[\$( [ ! -z \${SSH_CONNECTION+x} ] && echo -n '31' || echo -n '1;36' )m\]\u@\h\[\e[1;33m\]$ \[\e[0m\]"
fi
export CLICOLOR=1

# Add some additional paths ($HOME, Homebrew)
DIRS=( "${HOME}/usr/bin" "${HOME}/bin" "/usr/local/sbin" "/usr/local/bin" )
for ((i=${#DIRS[@]}-1; i>=0; i--)); do
  DIR="${DIRS[${i}]}"
  if [ -d "${DIR}" ]; then
    PATH="${DIR}:$(echo ${PATH} | sed -e "s|${DIR}||g" -e "s|:\{2,\}|:|g" -e 's|^:||')"
    PATH="${PATH%:}"
  fi
done
export PATH
unset DIRS

export EDITOR="vim"

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Aliases
alias ack='ack --pager="less -SFRX"'
alias ag='ag --pager="less -SFRX"'
alias grep='grep -I --color=auto'
alias less='less -SR'
alias psw='ps -wwf'
alias vij='vim -c "set ft=json"'
alias lsof='lsof -anP'

# If MacVim is present but gvim isn't, map gvim back to mvim
if _which mvim && ! _which gvim; then
  alias gvim='mvim'
fi

# If ls supports the --color argument, alias ls to use it.
if ls --color /dev/null >/dev/null 2>&1; then
  alias ls='ls --color'
fi

# Homebrew specific rules
if _which brew; then
  BREW_PREFIX="$(brew --prefix)"
  BREW_GITHUB_TOKEN="${HOME}/.homebrew_github_api_token"

  # Use a GitHub API Token so Homebrew gets a higher rate limit.
  if [ -f "${BREW_GITHUB_TOKEN}" ]; then
    read -r HOMEBREW_GITHUB_API_TOKEN < "${BREW_GITHUB_TOKEN}"
    export HOMEBREW_GITHUB_API_TOKEN
  elif [ -n "${PS1}" ]; then
    echo "GitHub API token for Homebrew does not exist."
    echo "Consider creating ${BREW_GITHUB_TOKEN}."
  fi

  # Don't automatically update brew before install, update, and tap.
  export HOMEBREW_NO_AUTO_UPDATE=1

  # Use Brew's vim for the Editor
  if [ -f "${BREW_PREFIX}/bin/vim" ]; then
    export EDITOR="${BREW_PREFIX}/bin/vim"
  fi

  # Add Bash completion
  if ! shopt -oq posix; then
    if [ -f "${BREW_PREFIX}/etc/bash_completion" ]; then
      # shellcheck disable=SC1090
      . "${BREW_PREFIX}/etc/bash_completion"
    fi
  fi

  unset BREW_PREFIX
fi

# Default bc scale
if [ -f "${HOME}/.bcrc" ]; then
  export BC_ENV_ARGS="${HOME}/.bcrc"
fi

# Disable Wine debugger everywhere
if _which wine; then
  export WINEDEBUG=-all
fi

# Override SSH timeout
unset TMOUT 2>/dev/null

# Quickly change to the webroot of Drupal site
function dcd {
  local path
  local target

  if ! command -v drush >/dev/null 2>&1; then
    echo "Drush not found"
    return 1
  fi

  target="${1:-root}"
  if path="$(drush dd --local-only "${target}" 2>/dev/null)"; then
    if ! cd "${path}"; then
      echo "Could not change to directory ${path}." >&2
      return 1
    fi
  else
    echo "Target '${target}' not found." >&2
    return 1
  fi
}

# Quickly change to the Git top level dir
function gcd {
  local path

  if ! command -v git >/dev/null 2>&1; then
    echo "Git not found" >&2
    return 1
  fi

  path="$(git rev-parse --show-toplevel 2>/dev/null)"

  if path="$(git rev-parse --show-toplevel 2>/dev/null)"; then
    if ! cd "${path}"; then
      echo "Could not change to directory ${path}." >&2
      return 1
    fi
  else
    echo "Could not determine Git toplevel" >&2
    return 1
  fi
}

# Alias SSH connections forcing password entry. Useful for testing a reset password.
function pssh {
  ssh -S none -o PreferredAuthentications=keyboard-interactive,password "$@"
}
# Use SSH for completion
_pssh() { _xfunc ssh _ssh; } && complete -F _pssh pssh

# Reload all enabled SCLs, useful in tmux sessions
function scl-reload {
  local _scls_current
  if ! command -v scl_source >/dev/null 2>&1; then
    echo "SCL not found" >&2
    return 1
  fi

  _scls_current="${X_SCLS}"
  export -n X_SCLS
  unset X_SCLS
  while read -r collection; do
    source scl_source enable "${collection}"
  done < <(tr -s ' ' \\n <<< "${_scls_current}")
  unset _scls_current
}

# Update terminal variables from tmux
function tue {
  eval "$(
    while IFS= read -r var; do
      if [[ "${var:0:1}" != "-" ]]; then
        key="$(cut -d= -f1 <<< "${var}")"
        val="$(cut -d= -f2 <<< "${var}")"
        echo "${key}=\"${val}\"; export ${key}"
      else
        echo "unset ${var:1}"
      fi
    done < <(tmux show-environment)
  )"
}

# Unset private _which function
unset -f _which

# Source local (non-shared) configuration.
# shellcheck disable=SC1090
if [[ -f "${HOME}/.bashrc.local" ]]; then
  source "${HOME}/.bashrc.local"
fi
