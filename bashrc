# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# pick the best installed editor
editor_prefs=(vim vi nano pico emacs ed)
for ed in "${editor_prefs[@]}"; do
    which $ed > /dev/null 2>&1 && export EDITOR=$(which $ed) && break
done
export VISUAL=$EDITOR

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w'
fi

# ignore case when using tab completion
bind 'set completion-ignore-case on'

# for __git_ps1
if [ -f ~/.git-prompt.sh ]; then
	. ~/.git-prompt.sh
fi

# Indicate when there are staged/unstaged changes
GIT_PS1_SHOWDIRTYSTATE=yes
# Indicate when there are untracked files
GIT_PS1_SHOWUNTRACKEDFILES=yes
# Indicate the state compared to the upstream branch
GIT_PS1_SHOWUPSTREAM=yes

# Append __git_ps1 to show git status
if [ "$color_prompt" = yes ]; then
	PS1=$PS1'$(__git_ps1 "\[\033[00m\]:\[\033[1;33m\]%s")'
else
	PS1=$PS1'$(__git_ps1 ":%s")'
fi

# Append $ character and reset color
if [ "$color_prompt" = yes ]; then
	PS1=$PS1'\[\033[00m\]\$ '
else
	PS1=$PS1'\$ '
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# alias that excludes common directories for a recursive grep
alias rgrep='grep -r --exclude=*~ --exclude=*.pyc --exclude=tags --exclude-dir=log --exclude-dir=.git --exclude-dir=venv --exclude-dir=test_data --exclude-dir=./config/data_*'

alias ag='ag --no-break --pager="less -MIRFX"'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# diff two directory listings recursively and show in vim
# not working in OSX?
if [[ "$OSTYPE" != "darwin"* ]]; then
	function vdiffdir { vimdiff <(cd "$1" && find . | sort) <(cd "$2" && find . | sort); }
	export -f vdiffdir
fi

# necessary for pylint syntastic checker in vim
if [[ "$OSTYPE" = "darwin"* ]]; then
	export LC_CTYPE=$LANG
fi

# convert all .flac files in current directory to mp3 v0
alias flac2mp3v0='for f in *.flac; do avconv -i "$f" -qscale:a 0 "${f[@]/%flac/mp3}"; done'
alias wav2mp3v0='for f in *.wav; do avconv -i "$f" -qscale:a 0 "${f[@]/%wav/mp3}"; done'

# try to connect every 0.5 secs (modulo timeouts)
# nice for when you're constantly rebooting a machine
sssh(){
	while true; do command ssh "$@"; [ $? -ne 255 ] && break || sleep 0.5; done
}
export -f sssh

ssh_mount() {
	sshfs `whoami`@$1\.local:/media/$2 /media/$2/
}

ssh_unmount() {
	fusermount -u "/media/$1/"
}

# move a file somewhere, leaving a symlink in its place
lmv() { [ -e "$1" -a -d "$2" ] && mv "$1" "$2"/ && ln -s $(readlink -f "$2"/"$(basename "$1")") "$(dirname "$1")"; }

# -R lets you pipe colored grep output into less
# -i turns on case-insensitive searching with SmartCasing
LESS="-Ri"; export LESS

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f ~/.git-completion.sh ]; then
	. ~/.git-completion.sh
fi

if [ -d "$HOME/.rvm" ]; then
	# OSX has this for RVM
	PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
fi

