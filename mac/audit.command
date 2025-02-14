#!/bin/bash
reset

cd "$(dirname $BASH_SOURCE)"

purple='\033[0;35m'
yellow='\033[0;33m'
green='\033[0;32m'
blue='\033[0;34m'
red='\033[0;31m'
gray='\033[0;90m'
cyan='\033[0;36m'
bold='\033[1m'
reset='\033[0m'

notifications=()

tput civis
trap 'tput cnorm' EXIT
trap 'tput cnorm; exit 1' INT TERM

function print {
  question="$1"
  status="$2"
  solution="$3"

  printf "\r\033[K"

  if [ -z "$solution" ]
  then
    printf "\r $status $question\n"
  else
    notifications+=("$(printf "$status $question\nSolution: $solution")")
  fi
}

function spinner {
  local pid=$1
  local delay=0.1
  local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

  while ps -p $pid > /dev/null; do
    for (( i=0; i<${#spinstr}; i++ )); do
      printf "\r ${purple}%s ${gray}%s${reset}" "${spinstr:$i:1}" "${question}"
      sleep $delay
    done
  done
}

function check {
  question="$1"
  checkCommand="$2"
  errorLevel="$3"
  solution="$4"

  eval $checkCommand >/dev/null 2>/dev/null &
  local pid=$!

  spinner $pid

  wait $pid
  result=$?

  printf "\r\033[K"  # Clear line

  if [ $result -eq 0 ]
  then
    print "$question" "${green}✓${reset}"
  else
    if [ $errorLevel = "ERROR" ]
    then
      print "$question" "${red}Critical:${reset}" "$solution"
    elif [ $errorLevel = "WARN" ]
    then
      print "$question" "${yellow}Warning:${reset}" "$solution"
    elif [ $errorLevel = "SUGGESTION" ]
    then
      print "$question" "${purple}Suggestion:${reset}" "$solution"
    fi
  fi
}

function runStatusChecks {
  check \
    "Waking up requires a password to unlock?" \
    "DELAY=\$(sysadminctl -screenLock status 2>&1 | grep -o '[0-9]* seconds' | grep -o '[0-9]*'); [ -n \"\$DELAY\" ] && [ \$DELAY -lt 3600 ]" \
    "WARN" "Check that System Settings > Lock Screen > Require password is set to 'After 15 minutes' or less"

  check \
    "Automatic login is disabled?" \
    "defaults read /library/preferences/com.apple.loginwindow | grep -v autoLoginUser" \
    "ERROR" "Disable autologin by turning on FileVault: https://support.apple.com/en-us/HT204837"

  check \
    "Hard drive is encrypted?" \
    "fdesetup status" \
    "ERROR" "System Settings > Privacy \& Security > FileVault > Turn on FileVault"

  check \
    "Software updates are installed?" \
    "! softwareupdate --list | grep -q 'Software Update found'" \
    "ERROR" "App Store > Updates > Update all"

  check \
  "Latest backup completed within two weeks and is encrypted?" \
  "LATEST_BACKUP=\"$(tmutil latestbackup 2>/dev/null)\" && \
    [ -n \"$LATEST_BACKUP\" ] && \
    [ -d \"$LATEST_BACKUP\" ] && \
    [[ $(stat -f %m \"$LATEST_BACKUP\" 2>/dev/null) -ge $(date -v-2w +%s) ]] && \
    tmutil destinationinfo | grep -q 'Encrypted: Yes'" \
  "WARN" "Setup Time Machine and encrypt the backup https://support.apple.com/en-us/HT201250"

  check \
    "Password manager installed?" \
    "[ $(ls /Applications/ | grep 1Password) ] || [ $(ls /Applications/ | grep KeePass) ] || [ $(ls /Applications/ | grep LastPass) ] || [ $(ls /Applications/ | grep Dashlane) ] || [ $(ls /Applications/ | grep NordPass) ] || [ $(ls /Applications/ | grep RoboForm) ] || [ $(ls /Applications/ | grep Keeper) ] || [ $(ls /Applications/ | grep Enpass) ]" \
    "WARN" "Consider installing a password manager, it makes life easier"

  check \
    "Socket filter firewall is enabled?" \
    "/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate | grep 'State = 1'" \
    "ERROR" "System Settings > Network > Firewall Turn firewall on and reboot"

  check \
    "Application layer firewall is enabled?" \
    "defaults read /library/preferences/com.apple.alf.plist globalstate | grep 1" \
    "SUGGESTION" "Run and reboot: sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool true"

  check \
    "Application layer firewall stealth mode activated?" \
    "defaults read /Library/Preferences/com.apple.alf stealthenabled | grep 1" \
    "SUGGESTION" "Run and reboot: sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true"

  check \
    "Gatekeeper is enabled?" \
    "spctl --status | grep 'enabled'" \
    "ERROR" "Run: sudo spctl --master-enable"

  check \
    "Find My Mac is enabled?" \
    "defaults read /library/preferences/com.apple.FindMyMac.plist FMMEnabled | grep 1" \
    "ERROR" "System Settings > Your Name > iCloud > Saved to iCloud > See All > Turn on 'Find My Mac'"

  check \
    "Workstation routing is disabled?" \
    "sysctl net.inet.ip.forwarding | sed -n 's/net.inet.ip.forwarding: //p' | grep 0" \
    "WARN" "Run: sudo sysctl net.inet.ip.forwarding=0"

  check \
    "Guest account is disabled?" \
    "defaults read /Library/Preferences/com.apple.loginwindow GuestEnabled | grep 0" \
    "WARN" "System Settings > Users & Groups > Turn 'Guest User' off"

  check \
    "Exactly one 'root' account?" \
    "[[ $(dscl . -list /Users UniqueID | grep -w 0 | wc -l) -eq 1 ]]" \
    "ERROR" "You have $(dscl . -list /Users UniqueID | grep -w 0 | wc -l) 'root' accounts, contact your admin."

  check \
    "Deny root login over SSH?" \
    "[ ! -f /etc/ssh/sshd_config ] || grep -e '^[ \t]*PermitRootLogin[ \t]+no' /etc/ssh/sshd_config" \
    "ERROR" "Add the line 'PermitRootLogin no' to /etc/sshd_config (requires sudo)"

  [ $(which brew) ] && check \
    "If homebrew is installed, is it updated and cool?" \
    "brew doctor" \
    "WARN" "Do what brew says, run: brew doctor"

}

function printNotifications {
  if [ ${#notifications[@]} -gt 0 ]
  then
    echo -e "\n\n${bold}${yellow}These need a few minutes of your time:${reset}\n"

    for notification in "${notifications[@]}"
    do
      if [[ $notification == *"Critical:"* ]]; then
        printf '%s\n\n' "$notification"
      fi
    done

    for notification in "${notifications[@]}"
    do
      if [[ $notification == *"Warning:"* ]]; then
        printf '%s\n\n' "$notification"
      fi
    done

    for notification in "${notifications[@]}"
    do
      if [[ $notification == *"Suggestion:"* ]]; then
        printf '%s\n\n' "$notification"
      fi
    done
  fi
}

echo -e "OS X HARDENING AUDIT"
echo -e "No sudo required, only read operations\n"
echo -e "${bold}${green}These look great:${reset}\n"

runStatusChecks
printNotifications

printf "${blue}Tip:${reset} Disable Safari from sending search queries to Apple and automatically opening downloaded files.\nSafari > Settings > Search > Uncheck 'Include Safari Suggestions'\nSafari > Settings > General > Uncheck 'Open safe files after downloading'\n\n"
