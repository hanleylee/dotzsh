# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License
# Open the current directory in a Finder window

if ! is_darwin; then
    return
fi

#################
# MARK:  ALIAS  #
#################

# alias show_external_ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias show_network_info='scutil --nwi'
alias myip='ifconfig | sed -En "s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p"'
alias show_external_ip='curl -s https://api.ipify.org && echo'
alias show_local_ip='ipconfig getifaddr en0'
alias remove_dsstore="find . -type f -name '.DS_Store' -ls -delete"
alias clipboard_convert_plain='pbpaste | textutil -convert txt -stdin -stdout -encoding 30 | pbcopy'
alias clipboard_expand_tab='pbpaste | expand | pbcopy'
alias clipboard_remove_duplicate='pbpaste | sort | uniq | pbcopy'
alias chrome="open -a \"Google Chrome\""
alias safari="open -a \"Safari\""
# mount all connected Firewire disks
alias mountall='system_profiler SPFireWireDataType | grep "BSD Name: disk.$" | sed "s/^.*: //" | (while read i; do /usr/sbin/diskutil mountDisk $i; done)'
# unmount them all
alias unmountall='system_profiler SPFireWireDataType | grep "BSD Name: disk.$" | sed "s/^.*: //" | (while read i; do /usr/sbin/diskutil unmountDisk $i; done)'
# mute the system volume
alias stfu="osascript -e 'set volume output muted true'"

if is-at-least 10.15 "$(sw_vers -productVersion)"; then
    alias displays='open /System/Library/PreferencePanes/Displays.prefPane'
else
    alias displays='open /Library/PreferencePanes/Displays.prefPane'
fi
alias ofd='open -b com.apple.finder $PWD'
alias rfd='open -R $PWD'

# Show/hide hidden files in the Finder
alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

#####################
#  MARK: FUNCTIONS  #
#####################

# Bluetooth restart
function btrestart() {
    sudo kextunload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport
    sudo kextload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport
}

function _omz_macos_get_frontmost_app() {
    osascript 2>/dev/null <<EOF
    tell application "System Events"
        name of first item of (every process whose frontmost is true)
    end tell
EOF
}

# cd to current directory of Finder
function cdf() {
    cd "$(pfd)" || return
}

function pushdf() {
    pushd "$(pfd)" || return
}

# return directory of the active frontmost Xcode workspace
function pxd() {
    dirname "$(pfxc_workspace)"
}

function cdx() {
    cd "$(pxd)" || return
}

# 在 xcode 中打开当前目录下的工程
function ofx() {
    # open ./*.xcworkspace || open ./*.xcodeproj || open ./Package.swift
    xed .
} 2> /dev/null

# use MacVim to edit the current file of Xcode
function mvxc() {
    # either of the below method is acceptable
    # open -a MacVim `pfxc_file`
    osascript <<EOF
    tell application "MacVim"
        activate
        set current_document_path to "$(pfxc_file)"
        if (current_document_path is not "") then
            open current_document_path
            return
        end if
    end tell
EOF
}

function mvim_pffile() {
    mvim --remote-expr "execute('echo hl#buffer#frontmostFilePath()')" | tr -d "\n"
}

function mvim_pfdir() {
    current_file_path=$(mvim_pffile)
    dirname "$current_file_path"
}

# cd to the path of MacVim's current working directory
function cdmv() {
    current_dir_path=$(mvim_pfdir)
    cd "$current_dir_path" || return
}
# cd to the path of iTerm2's current working directory
# function cdit() {
#   cd "$(pfit)"
# }

function copy_ios_screenshot() {
    # temp_png="/tmp/screenshot/${RANDOM}.png"
    # temp_png="$(mktemp /tmp/ios_screen_shot_XXXXXX.png)"
    # temp_png="$(mktemp /tmp/screenshot/XXXXXX.png)"
    # temp_png="$(gmktemp --suffix=.png)"
    temp_png="${TMPDIR}screenshot_${RANDOM}.png"

    tidevice screenshot "${temp_png}"
    img_copy "${temp_png}"
    # file-to-clipboard "${temp_png}"
}

function quick-look() {
    (( $# > 0 )) && qlmanage -p $* &>/dev/null &
}

function show_current_wifi_ssid() {
    /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'
}

function show_wifi_password() {
    ssid=$1
    security find-generic-password -D "AirPort network password" -a $ssid -gw
}

function show_current_wifi_password() {
    ssid=$(show_current_wifi_ssid)

    show_wifi_password $ssid
}

function man-preview() {
    local page
    for page in "${(@f)"$(man -w $@)"}"; do
        command mandoc -Tpdf $page | open -f -a Preview
    done
}
compdef _man man-preview

function vncviewer() {
    open vnc://$@
}

# Remove .DS_Store files recursively in a directory, default .
function rmdsstore() {
    find "${@:-.}" -type f -name .DS_Store -delete
}

# Erases purgeable disk space with 0s on the selected disk
function freespace(){
    if [[ -z "$1" ]]; then
        echo "Usage: $0 <disk>"
        echo "Example: $0 /dev/disk1s1"
        echo
        echo "Possible disks:"
        df -h | awk 'NR == 1 || /^\/dev\/disk/'
        return 1
    fi

    echo "Cleaning purgeable files from disk: $1 ...."
    diskutil secureErase freespace 0 $1
}

_freespace() {
    local -a disks
    disks=("${(@f)"$(df | awk '/^\/dev\/disk/{ printf $1 ":"; for (i=9; i<=NF; i++) printf $i FS; print "" }')"}")
    _describe disks disks
}

compdef _freespace freespace

# Music / iTunes control function
# source "${0:h:A}/music"

# Spotify control function
# source "${0:h:A}/spotify"
