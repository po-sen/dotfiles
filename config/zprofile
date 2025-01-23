[[ -r "$HOME/.zshrc" ]] && . "$HOME/.zshrc"

[[ -r "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -r "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]] && . "/opt/homebrew/opt/asdf/libexec/asdf.sh"

# Intel
[[ -r "/usr/local/bin/brew" ]] && eval "$(/usr/local/bin/brew shellenv)"
[[ -r "/usr/local/opt/asdf/libexec/asdf.sh" ]] && . "/usr/local/opt/asdf/libexec/asdf.sh"

# zsh-completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    autoload -Uz compinit
    compinit
fi

alias vi='nvim -p'
alias vim='vim -p'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'
alias ..........='cd ../../../../../../../../..'
alias ...........='cd ../../../../../../../../../..'
