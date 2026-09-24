export HISTCONTROL=ignorespace
# lazygit's default on macOS is ~/Library/Application Support/lazygit
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"

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

if command -v fzf &>/dev/null
then
  export FZF_CTRL_R_OPTS="--reverse"
  eval "$(fzf --bash)"
fi

if command -v starship &>/dev/null
then
  eval "$(starship init bash)"
fi

