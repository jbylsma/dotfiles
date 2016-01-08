# Private function for checking if program is in path
function _which() {
  command which "$@" >/dev/null 2>&1
  return $?
}

# Reset PATH on OS X keep it from being clobbered in tmux
# See https://github.com/yyuu/pyenv/issues/85
if [ -x /usr/libexec/path_helper ]; then
  PATH=''
  source /etc/profile
fi

# History configuration
export HISTSIZE=
export HISTFILESIZE=
shopt -s histappend

# Terminal configuration
if [ -n "$PS1" ]; then
  # If SSH, set host color to red, otherwise bold cyan.
  export PS1="\[\033[32m\][\w]\[\033[0m\]\n\[\033[\$( [ ! -z \${SSH_CONNECTION+x} ] && echo -n '31' || echo -n '1;36' )m\]\u@\h\[\033[1;33m\]$ \[\033[0m\]"
fi
export CLICOLOR=1

# Add some additional paths ($HOME, Homebrew)
DIRS=( $HOME/usr/bin $HOME/bin /usr/local/sbin /usr/local/bin )
for ((i=${#DIRS[@]}-1; i>=0; i--)); do
  DIR=${DIRS[$i]}
  if [ -d $DIR ]; then
    PATH=${DIR}:$(echo ${PATH} | sed -e "s|${DIR}||g" -e "s|:\{2,\}|:|g" -e 's|^:||')
    PATH=$(echo ${PATH} | sed -e 's|:$||')
  fi
done
export PATH
unset DIRS

# Set bash's vi mode
set -o vi

# Aliases
alias ack='ack --pager="less -SFRX"'
alias ag='ag --pager="less -SFRX"'
alias grep='grep -I --color=auto'

if _which mvim && ! _which gvim; then
  alias gvim='mvim'
fi

if [[ -f "/Applications/GitX.app/Contents/Resources/gitx" ]]; then
  alias gitx="/Applications/GitX.app/Contents/Resources/gitx"
fi

# Homebrew specific rules
if _which brew; then
  BREW_PREFIX="$(brew --prefix)"
  BREW_GITHUB_TOKEN="${HOME}/.homebrew_github_api_token"

  # Use a GitHub API Token so Homebrew gets a higher rate limit.
  if [ -f "${BREW_GITHUB_TOKEN}" ]; then
    read HOMEBREW_GITHUB_API_TOKEN < "${BREW_GITHUB_TOKEN}"
    export HOMEBREW_GITHUB_API_TOKEN
  elif [ -n "$PS1" ]; then
    echo "GitHub API token for Homebrew does not exist."
    echo "Consider creating ${BREW_GITHUB_TOKEN}."
  fi

  # Use Brew's vim for the Editor
  if [ -f "${BREW_PREFIX}/bin/vim" ]; then
    export EDITOR="${BREW_PREFIX}/bin/vim"
  fi

  # Add Bash completion
  if [ -f "${BREW_PREFIX}/etc/bash_completion" ]; then
    . "${BREW_PREFIX}/etc/bash_completion"
  fi

  unset BREW_PREFIX
fi

# Default bc scale
if [ -f $HOME/.bcrc ]; then
  export BC_ENV_ARGS=$HOME/.bcrc
fi

# Quickly change to the webroot of Drupal site
if _which drush; then
  function dcd {
    local path
    local target

    target="${1:-root}"
    path="$(drush dd --local-only "${target}" 2>/dev/null)"

    if [[ $? -eq 0 ]]; then
      if ! cd "${path}"; then
        echo "Could not change to directory ${path}."
        return 1
      fi
    else
      echo "Target '${target}' not found."
      return 1
    fi
  }
fi

# Disable Wine debugger everywhere
export WINEDEBUG=-all

# Unset private _which function
unset -f _which

# Source local (non-shared) configuration.
[[ -f $HOME/.bashrc.local ]] && source $HOME/.bashrc.local
