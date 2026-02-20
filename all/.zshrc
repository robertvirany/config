# MacOS guard
if [[ -d /opt/homebrew ]]; then
    source $(brew --prefix)/opt/fzf/shell/key-bindings.zsh
    source $(brew --prefix)/opt/fzf/shell/completion.zsh
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
else
    # export PATH=""
    source /usr/share/fzf/shell/key-bindings.zsh
    export PATH="/usr/bin/jvm:$PATH"
fi




# Path Exports 
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin:$PATH"

FNM_PATH="/home/robert/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi



# Shell Options
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%# '
setopt INC_APPEND_HISTORY
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt NO_BEEP
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY
export LC_TIME=C
export MANPAGER='nvim +Man!'
export PAGER='nvim'
export GH_PAGER=''

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'


# Shell Environment
export EDITOR="nvim"
export CODEX_TUI_RECORD_SESSION=1

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"



# Shell Completions

autoload -Uz compinit && compinit

eval "$(direnv hook zsh)"


if command -v tailscale >/dev/null; then
  source <(tailscale completion zsh)
fi

# if command -v wezterm >/dev/null; then
#     wezterm shell-completion --shell zsh | source /dev/stdin
# fi



# Aliases
export EZA_COLORS="uu=37:da=31"
alias ls='eza'
alias ll='eza -alF -snew -r --color=always'
alias la='eza -A'
alias l='ll'
# alias lt='eza -alF -snew -r --color=always'
alias c='cd'
alias c.='cd ..'
alias ce='cd'
alias g='git'
# alias fd='fdfind' # Address RV 01/09/2026
alias bat='bat --style=header,numbers --paging=never'
alias batn='bat --style=header --paging=never' # for piping
alias batc='bat --style=header,numbers --paging=never --color=never'
alias n='nvim'
alias n.='nvim .'
alias jq.='jq .'
alias j='jq'
alias g='git'
alias gs='git status'
alias gd='git diff'
alias b='bat'
alias rg='rg -n'
alias rgi='rg -i'
alias hrg='history|rg -i'
alias erg='env | rg -i'
alias src='source ~/.zshrc'
alias brc='nvim ~/.zshrc'
alias nrc='nvim ~/.config/nvim/init.lua'
alias zrc='nvim ~/.zshrc'
alias nvimrc='nvim ~/.config/nvim/init.lua'
alias wezrc='nvim ~/.config/wezterm/wezterm.lua'
alias history='fc -l -t "%m-%d-%Y %H:%M:%S" 1'
alias h='history'
alias c-='c -'
alias t='type'
alias m='neomutt'
alias karabiner='n ~/.config/karabiner'
alias karab='n ~/.config/karabiner'
alias skhdrc='n ~/.config/skhd/skhdrc'
alias wt='wezterm'


alias dps='docker ps --format "table {{.Names}}\t{{.ID}}\t{{.Status}}\t{{.Command}}"'
alias sql='sqlite3'
alias mesh='sqlmesh'
alias tails='tailscale'
alias python='python3'
alias hq='htmlq'
alias gpp='g++'


alias rc='nvim ~/.mds/.rc.md'
alias todo='nvim ~/.mds/.todo.md'
alias idea='nvim ~/.mds/.ideas.md'
alias dots="git --git-dir=$HOME/.dots --work-tree=$HOME"
alias ds="dots status"
alias mail="c ~/mail"
alias linbox="ssh linbox"
alias fedora="ssh yung_rob@fedora"
alias dbui="nvim +'DBUI'"
alias inbox="neomutt -f ~/mail/INBOX"
alias sent="neomutt -f ~/mail/\[Gmail\]/Sent\ Mail"
alias drafts="neomutt -f ~/mail/\[Gmail\]/Drafts"
alias kp="keepassxc-cli"

#linux only
alias sctl='systemctl'
alias jctl='journalctl'

#mac only
alias lctl='launchctl'



# Keybinds
bindkey -v

# autoload -Uz history-beginning-search-backward history-beginning-search-forward
autoload -U history-search-end


zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end
bindkey -M viins '^[OA' history-beginning-search-backward-end
bindkey -M viins '^[OB' history-beginning-search-forward-end

bindkey -M vicmd 'k' history-beginning-search-backward-end
bindkey -M vicmd 'j' history-beginning-search-forward-end
bindkey -M vicmd '^[[A' history-beginning-search-backward-end
bindkey -M vicmd '^[[B' history-beginning-search-forward-end

# To fix fringe vi mode backspace behavior on macos
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char


bindkey '^F' fzf-file-widget



# Functions
today() {
  local d
  d=$(date +%Y-%m-%d)
  fc -l -t '%Y-%m-%d %H:%M:%S' 1 |
    awk -v d="$d" '
      $2 == d {
        print $3, substr($0, index($0,$4))
      }'
}







### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk


### Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

