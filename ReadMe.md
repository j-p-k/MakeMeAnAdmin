# Make Me an Admin!

This script, when run, will allow a standard user to upgrade themselves to an admin for 30 minutes and then will grab a snapshot of the logs for the past 30 minutes as well so you can track what they did. 

## Setup

Install the script files in `/opt/MakeMeAnAdmin/`

Allow the user to run this particular script as root. To this end, edit the sudoers file
using the `sudo visudo` command. (If the editor is vim, prees `i` for insert mode and 
`ESC:wq` to save.): Add (in section "User specification"):

```
# Allow user to lauch MakeMeAnAdmin script
test            ALL = (ALL) /opt/MakeMeAnAdmin/MakeMeAnAdmin.sh
```
(where test is the username)

## Use

The user can run the script as `sudo /opt/MakeMeAnAdmin/MakeMeAnAdmin.sh`.
Admins can find the logs collected in `/opt/MakeMeAnAdmin/username.date.logarchive/`

## Details
The script will make the current user an admin when run with `sudo`.

The script will create a launch daemon to take care of demoting the user so that no matter how many times they log out or shut down, after 30 minutes of uptime, a script will be run to remove their admin privileges. 

## Credits

Idea and code copied from https://github.com/jamf/MakeMeAnAdmin