source ~/.bash_env

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:$PATH"
export PATH="${ANDROID_HOME}/build-tools/35.0.0-rc3/:$PATH"
export PATH="${ANDROID_HOME}/platform-tools:$PATH"
export PATH="${ANDROID_HOME}/emulator:$PATH"

# Runs command and all arguments and resets cursor back to vertical bar
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

eval "$(starship init bash)"
