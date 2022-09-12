#!/bin/bash

# check all these paths for existence and add to PATH

# shellcheck disable=SC2155
export JAVA_HOME="$(/usr/libexec/java_home)"
###  expands to current installed java
###  🂁  /usr/libexec/java_home
###  /Library/Java/JavaVirtualMachines/jdk-15.0.2.jdk/Contents/Home
MY_PATHS="
/bin
/sbin
/usr/local/bin
/usr/local/sbin
/opt/pkg/bin
/opt/pkg/sbin
/usr/bin
/usr/sbin
$HOME/bin
$HOME/.npm-global/bin
$HOME/py-venv/bin
${JAVA_HOME}/bin
"
for path in $MY_PATHS; do
     test -d "$path" && PATH="$PATH:$path"
done

# probe all these paths for existence and add to CDPATH
MY_CDPATHS="
$HOME/Documents/
$HOME/gits/joyent/
"
for cdpath in $MY_CDPATHS; do
     test -d "$cdpath" && CDPATH="$CDPATH:$cdpath"
done
export CDPATH

MY_HOSTNAME=$(uname -n | sed 's/\..*//g')
# Set terminal titlebar
case $TERM in
  *term | xterm-color | rxvt | gnome* | xterm-256color )
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${MY_HOSTNAME} : ${PWD}\007"'
    ;;
  *)
    ;;
esac
# set a fancy prompt using tput to fetch the color codes rather than manually encoding them
if [[ $(tput colors) -ge 256 ]] 2>/dev/null
then
#    BASE03=$(tput setaf 234)
#    BASE02=$(tput setaf 235)
#    BASE01=$(tput setaf 240)
#    BASE00=$(tput setaf 241)
#    BASE0=$(tput setaf 244)
#    BASE1=$(tput setaf 245)
#    BASE2=$(tput setaf 254)
#    BASE3=$(tput setaf 230)
#    YELLOW=$(tput setaf 136)
    ORANGE=$(tput setaf 166)
#    RED=$(tput setaf 160)
#    MAGENTA=$(tput setaf 125)
    VIOLET=$(tput setaf 61)
#    BLUE=$(tput setaf 33)
#    CYAN=$(tput setaf 37)
#    GREEN=$(tput setaf 64)
    #TERMINUS=⇒
    
    #TERMINUS='♧'
    TERMINUS='🂁'

    #TERMINUS='⤭'
    # do you want to build a snowman
    #TERMINUS='⛄️'
 else
#     BASE03=$(tput setaf 8)
#     BASE02=$(tput setaf 0)
#     BASE01=$(tput setaf 10)
#     BASE00=$(tput setaf 11)
#     BASE0=$(tput setaf 12)
#     BASE1=$(tput setaf 14)
#     BASE2=$(tput setaf 7)
#     BASE3=$(tput setaf 15)
#     YELLOW=$(tput setaf 3)
    ORANGE=$(tput setaf 9)
#     RED=$(tput setaf 1)
#     MAGENTA=$(tput setaf 5)
    VIOLET=$(tput setaf 13)
#     BLUE=$(tput setaf 4)
#     CYAN=$(tput setaf 6)
#     GREEN=$(tput setaf 2)
    TERMINUS='\$'
fi
#BOLD=$(tput bold)
RESET=$(tput sgr0)
#PS1='\[$VIOLET\]$(date +%Y.%m.%d.%H:%M:%S) \[$RESET\]\[$RED\]\u\[$RESET\]@\[$GREEN\]\h\[$RESET\]:\[$BLUE\]\w\[$RESET\] \[$ORANGE\]$TERMINUS\[$RESET\] '
PS1='\[$BASE0\]$(date +%Y.%m.%d.%H:%M:%S)\[$RESET\] \[$VIOLET\]\w\[$RESET\] \[$ORANGE\]$TERMINUS\[$RESET\] '

#PS1='\[$VIOLET\]\w\[$RESET\] \[$ORANGE\]$TERMINUS\[$RESET\] '

# History control
# incompatibe with /etc/bashrc_Apple_Terminal session saving stuff
if ! [ -d ~/.histories/ ]; then
    mkdir ~/.histories/
fi
export HISTCONTROL=ignorespace:erasedups
export HISTFILESIZE=1000000
export HISTSIZE=100000
# this HISTTIMEFORMAT setting adds both timestamps to the `history` output
#  and commented timestamps to $HISTFILE in epoch seconds ie `date "+%s"`
export HISTTIMEFORMAT="%Y.%m.%d.%H:%M:%S "
# histfile per host for when my homedir was an nfs share that moves round
# or otherwise synced/replicated like in workstation changes
export HISTFILE="$HOME/.histories/${MY_HOSTNAME,,}"

# Key Bindings
## make up and down arrows do Ctrl-R like searching based on what is partially typed
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# include pkgsrc bash-completion if installed
[[ -r /opt/pkg/share/bash-completion/bash_completion ]] && source /opt/pkg/share/bash-completion/bash_completion

# use less as my default pager with these settings
export PAGER="less --ignore-case --line-numbers --hilite-unread --squeeze-blank-lines --LONG-PROMPT --tabs=3"

# MacPorts override for the editor to use with it
export MP_EDITOR=/usr/local/bin/mvim
export EDITOR=vim
export RSYNC_RSH=ssh

# fancy settings for curl to output lots of info about the connection
# alias curl='curl --write-out "content_type: %{content_type}\n filename_effective: %{filename_effective}\n http_code: %{http_code}\n http_connect: %{http_connect}\n http_version: %{http_version}\n local_ip: %{local_ip}\n local_port: %{local_port}\n num_connects: %{num_connects}\n num_redirects: %{num_redirects}\n proxy_ssl_verify_result: %{proxy_ssl_verify_result}\n redirect_url: %{redirect_url}\n remote_ip: %{remote_ip}\n remote_port: %{remote_port}\n scheme: %{scheme}\n size_download: %{size_download}\n size_header: %{size_header}\n size_request: %{size_request}\n size_upload: %{size_upload}\n speed_download: %{speed_download}\n ssl_verify_result: %{ssl_verify_result}\n time_appconnect: %{time_appconnect}\n time_connect: %{time_connect}\n time_namelookup: %{time_namelookup}\n time_pretransfer: %{time_pretransfer}\n time_redirect: %{time_redirect}\n time_starttransfer: %{time_starttransfer}\n time_total: %{time_total}\n url_effective: %{url_effective}\n" '

# color on for ls
export CLICOLOR=1

# add my keys to ssh-agent
/usr/bin/ssh-add -K >/dev/null 2>&1 

DISKUTIL=/usr/sbin/diskutil
HDIUTIL=/usr/bin/hdiutil


# close all em disks
function cad() {
    for i in $(T | awk '($1 ~ /dev/ ) && ( $3 ~ /Volumes/ ) {print $1}' )
    do 
        "$HDIUTIL" eject -quiet "$i"
    done
}

# if I have macvim installed, use that vim for consistent behavior
if [[ -e /Applications/MacVim.app/Contents/MacOS/Vim ]]
then
    alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
fi

# crypted sparse disk commands
mounted_sparsedisk=/Volumes/MySecrets
sparsedisk='/Users/michaelhicks/Documents/Personal/sparsinator.sparseimage'
alias less='less -wM --tabs=3'
alias ssh='ssh -A'
alias osdi='$HDIUTIL attach -quiet $sparsedisk'
alias csdi='$DISKUTIL quiet eject $mounted_sparsedisk'

# airport control commands
alias onair='networksetup -setairportpower en0 on'
alias airscan='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s'
alias getairnet='networksetup -getairportnetwork en0'
alias offair='networksetup -setairportpower en0 off'

# location based 'setup all the things' commands
alias saveme='open -a /System/Library/CoreServices/ScreenSaverEngine.app'

# general utility
alias crater='ssh -i /Volumes/MySecrets/smarty root@crater.404.mn -p 9090'
alias netstat='netstat -f inet'
alias vi='vim'

# color all the things
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# ldd is a linux tool, but otool does something very similar
alias ldd='echo "Using otool -L"; otool -L'

# helper function to recursively search my various histories files
hgrep() {
    local searchy="$1"
    grep -r "$searchy" ~/.histories
}

# open a file with vscode
code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args "$@" ;}

# helper functions to make an ssh tunnel port forward so I
# can connect to the VNC port of an HVM instance ( triton used to not do this)
moovnc() {
    if [[ -z $1 ]]
    then
        PORT='64431'
    else
        PORT=$1
    fi
    if [[ -z $2 ]]
    then
        LPORT='9080'
    else
        LPORT=$2
    fi

    ssh -L "localhost:${LPORT}:192.168.1.3:$PORT" root@brownbokbokbrown.mooo.com -p9090
}

evlabvnc() {
    if [[ -z $1 ]]
    then
        PORT='64431'
    else
        PORT=$1
    fi
    if [[ -z $2 ]]
    then
        LPORT='9080'
    else
        LPORT=$2
    fi

    ssh -L "localhost:${LPORT}:172.24.0.2:$PORT" evlab-gz
}

# helper functions for wrangling networking
wait4wifinet(){
  THIS_NET="Current Wi-Fi Network: $1"

  MAX=10
  COUNTER=0
  WHICH_NET=$(getairnet)
  if [[ "$WHICH_NET" =~ "Wi-Fi power is currently off" ]]
  then 
    echo 'Wifi, is off, try turning it on before using this'
    return 1
  fi
  while [[ $WHICH_NET != "$THIS_NET" ]]  && (( COUNTER < MAX ))
  do
    (( COUNTER+=1 ))
    echo "$WHICH_NET is not $THIS_NET yet"
    sleep 1
    WHICH_NET=$(getairnet)
  done
  if [[ $COUNTER -eq $MAX ]]
  then
    echo "Max tries $MAX exceeded, bailing"
  else
    echo "Success $WHICH_NET is now $THIS_NET"
  fi
}

wait_till_can_ping_blah_from_en_what() {
  blah=$1
  myDev=$2
  while ! ping  -c2 -o -t2 -b "$myDev" "$blah" >/dev/null 2>&1
  do
    echo "couln't ping $blah yet"
    sleep 1
  done
  echo "pinged $blah successfully"
}

# switch to my net location with no networking
setLocationTo(){
  location=$1
  echo "checking if you are already in $location"
  if [ "$(networksetup -getcurrentlocation)" != "$location" ]
  then
    echo "Switching to $location"
    sudo networksetup -switchtolocation "$location"
  else
    echo "You are already in $location"
  fi
}

# helper functions to turn bluetooth on and off
setBluetoothTo () {
  desiredState=$1
  echo "Setting bluetooth to state $desiredState"
  if [[ $desiredState == 'on' ]]
  then
    sudo defaults write /Library/Preferences/com.apple.Bluetooth.plist ControllerPowerState 1
    sudo launchctl unload /System/Library/LaunchDaemons/com.apple.blued.plist
    sudo launchctl load /System/Library/LaunchDaemons/com.apple.blued.plist
  elif [[ $desiredState == 'off' ]]
  then
    sudo defaults write /Library/Preferences/com.apple.Bluetooth.plist ControllerPowerState 0
    sudo launchctl unload /System/Library/LaunchDaemons/com.apple.blued.plist
    sudo launchctl load /System/Library/LaunchDaemons/com.apple.blued.plist
  else
    echo "Your desired state of $desiredState is not supported"
  fi
  echo "done"
}

ldapLookupUser ()
{
    /opt/pkg/bin/curl -s -i -u "uid=${1},ou=people,dc=ev3,dc=joyent,dc=us" "ldaps://ops-ldap.joyent.us:636/uid=${1},ou=people,dc=ev3,dc=joyent,dc=us?*?base"
}

fliptable ()
{
    if [[ $1 == 'ru' ]]
    then
        echo 'ノ┬─┬ノ ︵( o°o)︵'
    else
        echo '（╯°□°）╯ ┻━┻'
    fi
}

## from DAve EDDY  https://gist.githubusercontent.com/bahamas10/d58ea9d51493d7f99f19/raw/d2e0fb3003850af8903f9e16948c87fef7187902/manta.bash
##    https://gist.github.com/bahamas10/d58ea9d51493d7f99f19

# Open files from manta in the browser
mopen() {
	murl "$@" | xargs open
}

# Paste bin using manta
## reuires https://pygments.org/download/
##  pip install Pygments
mpaste() {
	local mfile
    mfile="~~/public/pastes/$(date +%s).html"
	pygmentize -f html -O full -g "$@" | mput -p "$mfile"
	murl "$mfile"
}

# convert manta paths into URLs
murl() {
	local u
	for u in "$@"; do
		echo "$MANTA_URL${u/#~~//$MANTA_USER}"
	done
}

# put a file  to manta and generate a signed URL to give to someone to download said file
mputsign() {
    local file=$1
    local getput=$2
    local hours=$3
    local dest=$4

    local EXPD
    EXPD=$(date "-v+${hours}H" '+%s');
    if [[ -z "$dest" ]]
    then
        dest='/mhicks/stor/SEC/'
    fi
    if [[ $getput == 'GET' ]]
    then
        mput -f "$file" "$dest"
    fi
    msign -m "$getput" -e "$EXPD" "$dest"

}

# terminal countdown timer to use in place of sleep for when you want to see it happen
countdown() {
    local seconds="$1"
    local outro="$2"

    if [[ -z $outro ]]
    then
        outro='done'
    fi
    while (( seconds > 0 ))
    do 
        printf '\r%s%s ' "$(tput el)" "$((seconds--))"
        sleep 1
    done
    printf '\r%s%s\n' "$(tput el)" "$outro"
}

# automated signon to 1 password
# prereq to have password in keychain
# security add-generic-password -l "tritonproduct.1password.com" \
#                               -a "michael.hicks@joyent.com" \
#                               -s "tritonproduct.1password.com" \
#                               -T ""
opsignon() {
    eval "$(security find-generic-password \
               -s tritonproduct.1password.com \
               -w \
               | op signin --account tritonproduct)"
}    

# Make bash check it's window size after a process completes to avoid
# the funky line overwrap messy crap-fest
shopt -s checkwinsize

# to move non-portable and local only preferences into
# shellcheck disable=SC1090
[[ -f "$HOME/.profile.local" ]] && source "$HOME/.profile.local"

echo "Get to work eh?   Its time to work you hoser"

# Setting PATH for Python 3.10
# The original version is saved in .profile.pysave
export PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# shellcheck disable=SC1090
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
