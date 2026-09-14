setopt HIST_IGNORE_ALL_DUPS
bindkey -e
WORDCHARS=${WORDCHARS//[\/]}
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zsh
source ${ZIM_HOME}/init.zsh
alias ls="ls --color -A"
alias paru="yay"

eval "$(zoxide init zsh)"
# eval "$(starship init zsh)"

  printf '\n   \e[94;1;3mH\e[95;1;3me\e[0m\e[1;3ml\e[95;1;3ml\e[94;1;3mo\e[0m\e[1;3m!\e[36m :3\e[0m\n\n'


export PATH=$PATH:/home/julia/.spicetify
