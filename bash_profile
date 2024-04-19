export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

[[ -r "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
[[ -r "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

alias python='python3'
alias pip='pip3'

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
