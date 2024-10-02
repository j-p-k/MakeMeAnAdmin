#!/bin/bash
########################################
# script run by the Launch daemon      #
# to demote the user and               #
# then pull logs of what the user did. #
########################################

# Change into script's directory
cd "$(dirname $0)"



if [[ -f usersToRemove ]]; then
	for user in $(cat usersToRemove); do
    echo "Removing $user's admin privileges"
    /usr/sbin/dseditgroup -o edit -d $user -t user admin
    log collect --last 30m --output $user.$(date -u "+%Y-%m-%d_%H-%M-%SZ").logarchive
  done
  rm -f usersToRemove
  launchctl unload /Library/LaunchDaemons/removeAdmin.plist
  rm /Library/LaunchDaemons/removeAdmin.plist
fi