export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

[[ -r "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
[[ -r "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]] && . "/opt/homebrew/opt/asdf/libexec/asdf.sh"
[[ -r "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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
