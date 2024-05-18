# These contents are included in the generated ~/.zshrc

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Borrowed from original /etc/zshrc, for easy zsh keybindings
typeset -g -A key

[[ -n "$terminfo[kf1]" ]] && key[F1]=$terminfo[kf1]
[[ -n "$terminfo[kf2]" ]] && key[F2]=$terminfo[kf2]
[[ -n "$terminfo[kf3]" ]] && key[F3]=$terminfo[kf3]
[[ -n "$terminfo[kf4]" ]] && key[F4]=$terminfo[kf4]
[[ -n "$terminfo[kf5]" ]] && key[F5]=$terminfo[kf5]
[[ -n "$terminfo[kf6]" ]] && key[F6]=$terminfo[kf6]
[[ -n "$terminfo[kf7]" ]] && key[F7]=$terminfo[kf7]
[[ -n "$terminfo[kf8]" ]] && key[F8]=$terminfo[kf8]
[[ -n "$terminfo[kf9]" ]] && key[F9]=$terminfo[kf9]
[[ -n "$terminfo[kf10]" ]] && key[F10]=$terminfo[kf10]
[[ -n "$terminfo[kf11]" ]] && key[F11]=$terminfo[kf11]
[[ -n "$terminfo[kf12]" ]] && key[F12]=$terminfo[kf12]
[[ -n "$terminfo[kf13]" ]] && key[F13]=$terminfo[kf13]
[[ -n "$terminfo[kf14]" ]] && key[F14]=$terminfo[kf14]
[[ -n "$terminfo[kf15]" ]] && key[F15]=$terminfo[kf15]
[[ -n "$terminfo[kf16]" ]] && key[F16]=$terminfo[kf16]
[[ -n "$terminfo[kf17]" ]] && key[F17]=$terminfo[kf17]
[[ -n "$terminfo[kf18]" ]] && key[F18]=$terminfo[kf18]
[[ -n "$terminfo[kf19]" ]] && key[F19]=$terminfo[kf19]
[[ -n "$terminfo[kf20]" ]] && key[F20]=$terminfo[kf20]
[[ -n "$terminfo[kbs]" ]] && key[Backspace]=$terminfo[kbs]
[[ -n "$terminfo[kich1]" ]] && key[Insert]=$terminfo[kich1]
[[ -n "$terminfo[kdch1]" ]] && key[Delete]=$terminfo[kdch1]
[[ -n "$terminfo[khome]" ]] && key[Home]=$terminfo[khome]
[[ -n "$terminfo[kend]" ]] && key[End]=$terminfo[kend]
[[ -n "$terminfo[kpp]" ]] && key[PageUp]=$terminfo[kpp]
[[ -n "$terminfo[knp]" ]] && key[PageDown]=$terminfo[knp]
[[ -n "$terminfo[kcuu1]" ]] && key[Up]=$terminfo[kcuu1]
[[ -n "$terminfo[kcub1]" ]] && key[Left]=$terminfo[kcub1]
[[ -n "$terminfo[kcud1]" ]] && key[Down]=$terminfo[kcud1]
[[ -n "$terminfo[kcuf1]" ]] && key[Right]=$terminfo[kcuf1]

# Default key bindings
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
#[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
#[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search

# End of borrowed section

#autoload -U history-search-end
#zle -N history-beginning-search-backward history-search-end
#zle -N history-beginning-search-forward history-search-end
#bindkey "\e[A" history-beginning-search-backward-end
#bindkey "\e[B" history-beginning-search-forward-end

bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward

source "$HOME/.config/zsh/local.zshrc.zsh"

# End included portion
