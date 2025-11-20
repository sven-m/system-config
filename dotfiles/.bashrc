if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

prepend_path () {
  case ":$PATH:" in
    *:"$1":*)
      ;;
    *)
      PATH="$1${PATH:+:$PATH}"
  esac
}

prepend_path "${ANDROID_HOME}/cmdline-tools/latest/bin"
prepend_path "${ANDROID_HOME}/build-tools/35.0.0-rc3/"
prepend_path "${ANDROID_HOME}/platform-tools"
prepend_path "${ANDROID_HOME}/emulator"
prepend_path "$HOME/.local/bin"
prepend_path "$HOME/bin"

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
  __ETC_BASHRC_SOURCED= \
    __ETC_ZPROFILE_SOURCED= \
    __ETC_ZSHENV_SOURCED= \
    __ETC_ZSHRC_SOURCED= \
    __NIX_DARWIN_SET_ENVIRONMENT_DONE= \
    command_and_reset_cursor tmux "$@"
}

eval "$(starship init bash)"
