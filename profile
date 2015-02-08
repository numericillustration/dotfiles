#Probe all these paths for existence and add to PATH

JAVA_HOME=$(/usr/libexec/java_home)

MY_PATHS="
$HOME/bin
/bin
/sbin
/usr/sadm/bin
/Developer/Tools
/usr/local/bin
/usr/local/sbin
/opt/local/bin
/opt/local/sbin
/usr/bin
/usr/sbin
${JAVA_HOME}/bin
/usr/local/AWSCloudFormation-1.0.12/bin
"
for path in $MY_PATHS; do
     test -d $path && PATH=$PATH:$path
done

# probe all these paths for existence and add to CDPATH
MY_CDPATHS="
$HOME/Documents/chef/
$HOME/Documents/gits
"
for cdpath in $MY_CDPATHS; do
     test -d $cdpath && CDPATH=$CDPATH:$cdpath
done
export CDPATH




# Fix terminal colors on OpenSolaris to be at least close to solarized
case `hostname` in
  *some_gnome_host )
    TERM=xterm-256color
    if [[ COLORTERM -eq 'gnome-terminal' ]]
    then
  #    ~/gnome-solarize.sh dark
      # from https://gist.github.com/1397104
      PALETTE="#070736364242:#D3D301010202:#858599990000:#B5B589890000:#26268B8BD2D2:#D3D336368282:#2A2AA1A19898:#EEEEE8E8D5D5:#00002B2B3636:#CBCB4B4B1616:#58586E6E7575:#65657B7B8383:#838394949696:#6C6C7171C4C4:#9393A1A1A1A1:#FDFDF6F6E3E3"
      BG_COLOR="#00002B2B3636"
      FG_COLOR="#65657B7B8383"
      gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_background" --type bool false
      gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_colors" --type bool false
      gconftool-2 --set "/apps/gnome-terminal/profiles/Default/palette" --type string "$PALETTE"
      gconftool-2 --set "/apps/gnome-terminal/profiles/Default/background_color" --type string "$BG_COLOR"
      gconftool-2 --set "/apps/gnome-terminal/profiles/Default/foreground_color" --type string "$FG_COLOR"
    fi
    ;;
  *)
    ;;
esac

MY_HOSTNAME=`uname -n | sed 's/\..*//g'`
# Set terminal titlebar
case $TERM in
  *term | xterm-color | rxvt | gnome* | xterm-256color )
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${MY_HOSTNAME} : ${PWD}\007"'
    ;;
  *)
    ;;
esac

# set a fancy prompt using tput to fetch the color codes rather than manually encoding them
if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
      BASE03=$(tput setaf 234)
      BASE02=$(tput setaf 235)
      BASE01=$(tput setaf 240)
      BASE00=$(tput setaf 241)
      BASE0=$(tput setaf 244)
      BASE1=$(tput setaf 245)
      BASE2=$(tput setaf 254)
      BASE3=$(tput setaf 230)
      YELLOW=$(tput setaf 136)
      ORANGE=$(tput setaf 166)
      RED=$(tput setaf 160)
      MAGENTA=$(tput setaf 125)
      VIOLET=$(tput setaf 61)
      BLUE=$(tput setaf 33)
      CYAN=$(tput setaf 37)
      GREEN=$(tput setaf 64)
      TERMINUS=⇒
    else
      BASE03=$(tput setaf 8)
      BASE02=$(tput setaf 0)
      BASE01=$(tput setaf 10)
      BASE00=$(tput setaf 11)
      BASE0=$(tput setaf 12)
      BASE1=$(tput setaf 14)
      BASE2=$(tput setaf 7)
      BASE3=$(tput setaf 15)
      YELLOW=$(tput setaf 3)
      ORANGE=$(tput setaf 9)
      RED=$(tput setaf 1)
      MAGENTA=$(tput setaf 5)
      VIOLET=$(tput setaf 13)
      BLUE=$(tput setaf 4)
      CYAN=$(tput setaf 6)
      GREEN=$(tput setaf 2)
      TERMINUS='\$'
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
PS1='\[$RED\]\u\[$RESET\]@\[$GREEN\]\h\[$RESET\]:\[$BLUE\]\w\[$RESET\] \[$ORANGE\]$TERMINUS\[$RESET\] '

# Turn on bash completion if available
if [ -f /etc/bash_completion ]; then
     . /etc/bash_completion
fi


# History control
 if ! [ -d ~/.histories/ ]; then
    mkdir ~/.histories/
 fi
export HISTCONTROL=ignorespace:erasedups
export HISTFILESIZE=100000
# histfile per host for when my homedir is an nfs share that moves around
export HISTFILE=$HOME/.histories/`echo $MY_HOSTNAME | tr "[:upper:]" "[:lower:]"`

# Key Bindings
## make up and down do Ctrl-R like searching based on what is partially typed
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

export PAGER="less --ignore-case --line-numbers --hilite-unread --squeeze-blank-lines --LONG-PROMPT --tabs=3"
export EDITOR=vi
export RSYNC_RSH=ssh

# Universal Aliases
alias less='less -wM --tabs=3'
alias ssh='ssh -A'

SYSTEM=`uname -s`
case $SYSTEM in
  SunOS)
    if [ -f /opt/sfw/bin/vim ]
    then
      alias vi='vim'
    fi
    LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:*.deb=90'
    alias ls='ls --color=auto' 
    export MANPATH=`echo $PATH | sed 's/bin/man/g'`
    export CLICOLOR=1
    ;;

  Darwin)
    export CLICOLOR=1
    export MANPATH=/opt/local/share/man:$MANPATH
    export MP_EDITOR=/usr/local/bin/mvim
    export AWS_CLOUDFORMATION_HOME=/usr/local/AWSCloudFormation-1.0.12
    export JAVA_HOME
    source ~/.rvm/scripts/rvm
    rvm use ruby-2.1-head

    open=/usr/bin/open
    DISKUTIL=/usr/sbin/diskutil
    HDIUTIL=/usr/bin/hdiutil
    MKDIR=/bin/mkdir
    MOUNT=/sbin/mount
    UMOUNT=/sbin/umount

    ## various variables
    mounted_sparsedisk=/Volumes/crypted_stuff
    GITBASE='/Volumes/roaming_svn/git'

    whoami=`/usr/bin/whoami`

    SQ="'"
    AWKWARD='($1 ~ /dev/ ) && ( $3 ~ /Volumes/ ) {print $1}'
    PREFIX='for i in $(mount | awk'
    POSTFIX='); do hdiutil eject -quiet $i; done'

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi

    # if I have macvim installed, use that vim for consistency
    if [[ -e /Applications/MacVim.app/Contents/MacOS/Vim ]]
    then
        alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
    fi

    # crypted sparse disk commands
    sparsedisk='path_to_crypted_disk'
    mounted_sparsedisk='path_to_crypted_disk_mount_point'

    alias osdi='$HDIUTIL attach -quiet $sparsedisk'
    alias csdi='$DISKUTIL quiet eject $mounted_sparsedisk'

    # close all em disks
    alias cad="$PREFIX $SQ $AWKWARD $SQ $POSTFIX"


    # airport control commands
    alias onair='networksetup -setairportpower en0 on'
    alias airscan='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s'
    alias getairnet='networksetup -getairportnetwork en0'
    alias offair='networksetup -setairportpower en0 off'

    # chat client stuff
    alias chatlogin='osascript -e "tell application \"Messages\" to Log in"'
    alias chatlogout='osascript -e "tell application \"Messages\" to Log out"'
    alias HipChatlogin='/usr/bin/osascript -e "tell application \"HipChat\" to Log in"'
    alias HipChatlogout='/usr/bin/osascript -e "tell application \"HipChat\" to Log out"'


    # location based 'setup all the things' commands
    alias atmydesk='setLocationTo Automatic; offair; setBluetoothTo on && wait_till_can_ping_blah_from_en_what 8.8.8.8 en4 ; /usr/local/bin/screenbrightness 1; sleep 5; open_work_apps; chatlogin; sleep 5; hipstat Available'
    #alias gohome='finishola; setLocationTo Nada; setBluetoothTo off'
    alias gohome='hipstat Away; setLocationTo Nada; setBluetoothTo off'
    alias saveme='open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app'
    alias play='setLocationTo Automatic && onair && wait4wifinet "<nonononononon>" && wait_till_can_ping_blah_from_en_what 8.8.8.8 en0'


    # gits
    alias gsub='git submodule update --init'
    alias gpom='git pull origin master'
    alias gpum='git push origin master'
    alias gbl='git branch --list'

    # color all the things
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias grep='grep --color=auto'
    alias ls='ls -G'

    # ldd is a linux tool, but otool does something very similar
    alias ldd='echo "Using otool -L"; otool -L'

    # Functions - most of which are used above in the location based aliases
    open_work_apps(){
      open /Applications/Mail.app;
      open /Applications/HipChat.app;
      open /Applications/Safari.app;
      open /Applications/Tweetbot.app;
      open /Applications/MacVim.app;
    }
 
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
      while [[ $WHICH_NET != $THIS_NET ]]  && [[ $COUNTER -lt $MAX ]]
      do
        let "COUNTER+=1"
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
      while ! ping  -c2 -o -t2 -b $myDev $blah >/dev/null 2>&1
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
        sudo networksetup -switchtolocation $location
      else
        echo "You are already in $location"
      fi
    }

    vpn_stop(){
      echo "turning 'VPN (Cisco IPSec) off"
      sudo networksetup -setnetworkserviceenabled 'VPN (Cisco IPSec)' off
      sudo networksetup -setnetworkserviceenabled 'VPN (Cisco IPSec)' on
    }


    CORP_BLOCK='1.2.3.4'
    split_tun(){
      ORIG_DEFGW=$(netstat -nr | awk '/^default.*UGScI/ { print $2 }')
      sudo route delete default -interface utun0
      sudo route add -net ${CORP_BLOCK} -interface utun0
      sudo route add default ${ORIG_DEFGW}
      sudo route add qa-mailer.anontest.com -interface utun0
      sudo route add krusty.anonymizer.com -interface utun0
      return 0
    }

    setBluetoothTo () {
      desiredState=$1
      echo "Setting bluetooth to state $desiredState"
      networksetup -connectpppoeservice 'VPN (Cisco IPSec)'
      if [[ "$desiredState" == "on" ]]
      then
        sudo defaults write /Library/Preferences/com.apple.Bluetooth.plist ControllerPowerState 1
        sudo launchctl unload /System/Library/LaunchDaemons/com.apple.blued.plist
        sudo launchctl load /System/Library/LaunchDaemons/com.apple.blued.plist
      elif [[ "$desiredState" == "off" ]]
      then
        sudo defaults write /Library/Preferences/com.apple.Bluetooth.plist ControllerPowerState 0
        sudo launchctl unload /System/Library/LaunchDaemons/com.apple.blued.plist
        sudo launchctl load /System/Library/LaunchDaemons/com.apple.blued.plist
      else
        echo "Your desired state of $desiredState is not supported"
      fi
      echo "done"
    }

    gitstat () {
      declare -a repolist
      COUNT=0
      for i in $(cd $GITBASE && ls -1 | grep -v external)
      do 
        cd ${GITBASE}/${i}
        git fetch >/dev/null 2>&1
        if ! git status 2>&1 | grep -q 'working directory clean'
        then
          repolist[$COUNT]=$i
          let "COUNT += 1"
        fi
      done

      cd ${GITBASE}
      echo ${repolist[@]}
    }

    exgitstat () {
      declare -a repolist
      COUNT=0
      for i in $(cd $GITBASE/external && ls -1)
      do 
        cd ${GITBASE}/external/${i}
        git fetch >/dev/null 2>&1
        if ! git status 2>&1 | grep -q 'working directory clean'
        then
          repolist[$COUNT]=$i
          let "COUNT += 1"
        fi
      done

      cd ${GITBASE}/external
      echo ${repolist[@]}
    }

    hipstat(){ 
      STATUS=$1
      if [ -z $STATUS ]; then
          STATUS="Available"
      fi
      if ! ps -ef | grep HipChat | grep -v -q grep
      then
          echo 'HipChat not running; you have to start it first'
          return
      fi
      TMPF=/tmp/ascript
cat > $TMPF  <<-EOF
tell application "System Events" to tell UI element "HipChat" of list 1 of process "Dock"
  perform action "AXShowMenu"
  delay 0.5
  click menu item "Status" of menu 1
  click menu item "$STATUS" of menu 1 of menu item "Status" of menu 1
end tell
EOF
      osascript $TMPF
      rm $TMPF
    }

    alias bdd=big_data_downloader
    bulk_downloader_download()
    {
        popd ~/Documents/chef
        for i in $(knife search 'chef_environment:production* AND roles:*big*' | grep IP:  | awk '{print $2}')
        do 
            mkdir ./${i}
            scp -o StrictHostKeyChecking=no -i keys/AppsProd.pem -r ubuntu@${i}:/var/log/tealium/ ./${i}/
            tar cvvzf ./bd_log_${i}.tar.gz ./${i}
            rm -rf ./${i}
        done
        tar cvvf bd_logs.tar ./bd_log_*
        rm ./bd_log_*
    }


    fliptable ()
    {
        if [[ "$1" == 'ru' ]]
        then
            echo "ノ┬─┬ノ ︵ ( o°o)"
        else
            echo "（╯°□°）╯ ┻━┻"
        fi
    }


    ;;

  *)
    alias ls='ls --color=auto' 
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias grep='grep --color=auto'
    alias vi='vim'
    ;;
esac

# like push pop but if I'm going to hop around a bit and just want to come back this dir
a() { alias $1=cd\ "$PWD"; }

# Make bash check it's window size after a process completes to avoid
# the funky line overwrap messy crap-fest
shopt -s checkwinsize
