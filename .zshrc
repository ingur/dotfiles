# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Download and install zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Add powerlevel10k prompt
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add plugins
zinit ice lucid wait'0'
export ZSH_FZF_HISTORY_SEARCH_BIND="^f"
zinit light joshskidmore/zsh-fzf-history-search
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# homebrew
path+=("/home/linuxbrew/.linuxbrew/bin")

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt append_history
setopt share_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# zoxide
eval "$(zoxide init --cmd j zsh)"

# Aliases
alias cls="clear"
alias vim="nvim"
alias '~'='cd ~'
alias '..'='cd ..'
alias ls="eza --color=auto" # replace ls with eza
alias k="ls -al"

# Custom overrides
if [ -f ~/.zshrc.custom ]; then
  source ~/.zshrc.custom
fi

# Path variables
path=("$HOME/bin" "/usr/local/bin" $path)

export PROGRAMS_DIR="$HOME/programs"
path+=("$PROGRAMS_DIR")

export BOB_NVIM_DIR="$HOME/.local/share/bob/nvim-bin"
path+=("$BOB_NVIM_DIR")

export KITTY_DIR="$HOME/.local/kitty.app/bin"
path+=("$KITTY_DIR")

