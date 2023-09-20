# Open the current directory in a Finder window
alias ofd='open_command $PWD'

# Show/hide hidden files in the Finder
alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

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

function pfs() {
    osascript 2>/dev/null <<EOF
    set output to ""
    tell application "Finder" to set the_selection to selection
    set item_count to count the_selection
    repeat with item_index from 1 to count the_selection
        if item_index is less than item_count then set the_delimiter to "\n"
        if item_index is item_count then set the_delimiter to ""
        set output to output & ( (item item_index of the_selection as alias)'s POSIX path) & the_delimiter
    end repeat
EOF
}

function pfd() {
    osascript 2>/dev/null <<EOF
    tell application "Finder"
        return POSIX path of (insertion location as alias)
    end tell
EOF
}

function cdf() {
    cd "$(pfd)"
}

function pushdf() {
    pushd "$(pfd)"
}

function pxd() {
    dirname $(osascript 2>/dev/null <<EOF
    if application "Xcode" is running then
        tell application "Xcode"
            return path of active workspace document
        end tell
    end if
EOF
)
}

function cdx() {
    cd "$(pxd)" || exit
}

# 在 xcode 中打开当前目录下的工程
function ofx() {
    # open ./*.xcworkspace || open ./*.xcodeproj || open ./Package.swift
    xed .
} 2> /dev/null

# use MacVim to edit the current file of Xcode
function mvxc() {
    # either of the below method is acceptable
    # open -a MacVim `pfxc`
    osascript <<EOF
    tell application "MacVim"
        activate
        set current_document_path to "$(pfxc)"
        if (current_document_path is not "") then
            open current_document_path
            return
        end if
    end tell
EOF
}

# print the path of current file of MacVim's front window
function pfmv() {
    osascript <<'EOF'
    tell application "MacVim"
        set window_title to name of window 1
        set is_empty to offset of "[NO NAME]" in window_title
        if is_empty is 0 then
            set cwd to do shell script "echo '" & window_title & "' |sed 's/.* (\\(.*\\)).*/\\1/'" & " |sed \"s,^~,$HOME,\""
            return cwd
        end if
    end tell
EOF
}

# cd to the path of MacVim's current working directory
function cdmv() {
    cd "$(pfmv)"
}

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
