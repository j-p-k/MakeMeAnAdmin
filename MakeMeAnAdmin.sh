#!/bin/bash
###############################################
# This script will provide temporary admin    #
# rights to a standard user right from self   #
# service. First it will grab the username of #
# the logged in user, elevate them to admin   #
# and then create a launch daemon that will   #
# count down from 30 minutes and then create  #
# and run a secondary script that will demote #
# the user back to a standard account. The    #
# launch daemon will continue to count down   #
# no matter how often the user logs out or    #
# restarts their computer.                    #
###############################################

# Change into script's directory
cd "$(dirname $0)"

#############################################
# find the logged in user and let them know #
#############################################

currentUser=$(who | awk '/console/{print $1}')
echo $currentUser

osascript -e 'display dialog "You now have administrative rights for 30 minutes. DO NOT ABUSE THIS PRIVILEGE..." buttons {"Make me an admin, please"} default button 1'

#########################################################
# write a daemon that will let you remove the privilege #
# with another script and chmod/chown to make 	    		#
# sure it'll run, then load the daemon					        #
#########################################################

#Create the plist
defaults write /Library/LaunchDaemons/removeAdmin.plist Label -string "removeAdmin"

#Add program argument to have it run the update script
defaults write /Library/LaunchDaemons/removeAdmin.plist ProgramArguments -array -string /bin/sh -string "/opt/MakeMeAnAdmin/RemoveAdmin.sh"

#Set the run inverval to run every 30 mins
defaults write /Library/LaunchDaemons/removeAdmin.plist StartInterval -integer 1800

#Set run at load
defaults write /Library/LaunchDaemons/removeAdmin.plist RunAtLoad -boolean yes

#Set ownership
chown root:wheel /Library/LaunchDaemons/removeAdmin.plist
chmod 644 /Library/LaunchDaemons/removeAdmin.plist

#Load the daemon 
launchctl load /Library/LaunchDaemons/removeAdmin.plist

##############################################
# Remember which user was given admin rights #
##############################################

echo $currentUser >> usersToRemove

##################################
# give the user admin privileges #
##################################

/usr/sbin/dseditgroup -o edit -a $currentUser -t user admin

exit 0
