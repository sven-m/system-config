source ~/.bash_env

export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

eval "$(starship init bash)"

# Runs command $1 and resets cursor back to vertical bar
command_and_reset_cursor() {
  command "$@"
  local status=$?
  printf "\e[6 q"
  return $status
}

nvim() {
  command_and_reset_cursor nvim "$@"
}

tmux() {
  command_and_reset_cursor tmux "$@"
}
