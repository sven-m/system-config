# These contents are included in the generated ~/.zshrc

bindkey "^[[3~" delete-char
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

source "$HOME/.config/zsh/zshrc.local.zsh"

# End included portion