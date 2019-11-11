# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH configuration.
# (1) ZSH Themes
# (2) Case-sensitive completion
# (3) Disable auto-setting terminal title,
# (4) Disable marking untracked files under VCS as dirty.
# (5) Plugins
ZSH_THEME="frisk"
CASE_SENSITIVE="true"
DISABLE_AUTO_TITLE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(extract git sudo vim-interaction zsh-autosuggestions zsh-syntax-highlighting debian)

# Load oh-my-zsh.sh
source $ZSH/oh-my-zsh.sh

# Custom command aliases and functions.
source ~/.zsh/aliases
source ~/.zsh/functions

# Add extra $PATH.
export PATH="$PATH:$HOME/bin:$HOME/.local/bin:/usr/bin:/usr/local/bin:/sbin:/bin"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"

# Wine
export PATH=$PATH:/opt/wine-stable/bin

# Go
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# User configuration.
USER_LANGUAGE="en_US.UTF-8"
export LC_ALL=${USER_LANGUAGE}
export LANG=${USER_LANGUAGE}
export LANGUAGE=${USER_LANGUAGE}
export BROWSER="chromium"
export EDITOR="nvim"

# Fix incorrect backspace behavior on urxvt+zsh+ssh.
# However, this will cause zsh-autosuggestion to work buggy.
#export TERM=xterm-256color

# fcitx for wps fix.
export XIM=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"

# Prevent Wine from adding menu entries and desktop links.
export WINEDLLOVERRIDES="winemenubuilder.exe=d"

# timestamp
timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# build options
export CHOST="x86_64-pc-linux-gnu"
export CFLAGS="-march=core-avx2 -mavx2 -O2 -pipe"
export CXXFLAGS="${CFLAGS}"

# Print welcome message and todo list.
clear; lastlogin; motd

