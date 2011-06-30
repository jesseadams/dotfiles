# Use bash-completion, if available
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

export PS1="\e[1;34m\u \e[0;34m:: \e[1;34m\h \e[0;34m:: \e[1;33m\w \n \[\033[00m\]\$ \[\033[00m\]"

# Commands
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias sshkeys="$HOME/scripts/bash/ssh_keys.sh"
alias fixroute="$HOME/scripts/bash/fix_route.sh"
alias afsinit="kinit jadams1 && aklog"
alias lock="xscreensaver-command --lock"
alias rsync="rsync -h --stats --progress --log-file=$HOME/.rsync.log"
alias vbox="VBoxHeadless -s"
alias ssh="TERM=xterm ssh"
alias difm="screen -S difmplay -d -m difmplay"
alias wow="wine .wine/drive_c/Program\ Files/World\ of\ Warcraft/Wow.exe"
alias jira="echo 'Starting JIRA Lite in the background.'; ~/git/jira_lite/run &> /dev/null &"

if [ -f $HOME/.bash_functions ]; then
  . $HOME/.bash_functions
fi

if [ -f $HOME/.bashrc_private ]; then
  . $HOME/.bashrc_private
fi

# RVM
[[ -s "/home/jadams1/.rvm/scripts/rvm" ]] && source "/home/jadams1/.rvm/scripts/rvm"

export EDITOR=vim
export PAGER=less
export LESS="-iMSx4 -FX"
export PATH=$PATH:/usr/lib/perl5/vendor_perl/bin
export MUSIC_DIR=$HOME/void/music
