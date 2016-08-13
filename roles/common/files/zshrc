# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/will/.zshrc'

# Setup completion
autoload -Uz compinit
compinit

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

#### Aliases ####
# Netctl aliases
alias netstrt='sudo netctl start'
alias netswtch='sudo netctl switch-to'
alias netstop='sudo netctl stop'

# Assorted other aliases
alias pacman='sudo aura'
alias svim='sudo vim'

alias hibrnte='sudo systemctl hibernate'
alias cp='rsync -avhz --progress'
alias ls='ls --color=always -h'
alias df='df -h'
alias biggest='du -h . | sort -rh | head -$1'

# Attempt to stop myself using pip!
alias _pip=$(which pip)
alias pip='echo "use _pip if you really want to use pip, otherwise use pacman" #'

# Base64 encode and decode
function b64d() {
  echo "$1" | base64 -d
}
function b64e() {
  echo "$1" | base64
}
#### Additional Path directories ####
# scripts
export PATH=$PATH:/home/will/scripts
# android sdk
export PATH=$PATH:/opt/android-sdk/tools:/opt/android-sdk/platform-tools
# go-workspace
export GOPATH=$HOME/Projects/go
export PATH=$PATH:$GOPATH/bin
#### ENV VARS ####
# Java blank windows fix
export _JAVA_AWT_WM_NONREPARENTING=1

# RVM
RVMINIT="$HOME/.rvm/scripts/rvm"
if [ -s $RVMINIT ]; then
  export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
  source $RVMINIT
  [[ -r "$HOME/.rvm/scripts/completion" ]] && source "$HOME/.rvm/scripts/completion"
fi

# NVM
NVMINIT="/usr/share/nvm/init-nvm.sh"
[[ -s $NVMINIT ]] && source $NVMINIT

# Store the last directory cd'd into so that we can start new shells in the
# same directory.
# Also chmod's it to 600 (rw owner) for a bit of security paranoia
# See xmonad/xmonad.hs for corresponding command to start urxvt
function cd() {
  builtin cd "$@"
  echo $PWD > /tmp/.last_dir
  chmod 600 /tmp/.last_dir
}
