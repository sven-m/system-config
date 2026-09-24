export HISTCONTROL=ignorespace

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

# Prototype Rosé Pine in nvim; the rest of the nvim config stays as is. The
# variant is pinned, so it stays put when the terminal switches light/dark.
nvim-rose-main() {
  nvim -c "lua require('rose-pine').setup({ variant = 'main' })" -c "colorscheme rose-pine" "$@"
}

nvim-rose-dawn() {
  nvim -c "lua require('rose-pine').setup({ variant = 'dawn' })" -c "colorscheme rose-pine" "$@"
}

# Prototype Tokyo Night in nvim: Night when dark, Day when light, following
# light/dark like the normal config
nvim-tokyonight() {
  nvim -c "lua require('tokyonight').setup({ style = 'night', light_style = 'day' })" -c "colorscheme tokyonight" "$@"
}

tmux() {
  __ETC_BASHRC_SOURCED= \
    __ETC_ZPROFILE_SOURCED= \
    __ETC_ZSHENV_SOURCED= \
    __ETC_ZSHRC_SOURCED= \
    __NIX_DARWIN_SET_ENVIRONMENT_DONE= \
    command_and_reset_cursor tmux "$@"
}

# Separate tmux server with the Tokyo Night config; attaches if already running
tmux-tokyonight() {
  tmux -L tokyonight -f ~/.config/tmux/tokyonight.conf new-session -A -s tokyonight "$@"
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

