# zed – zsh scripts
to use, stick `source ~/Code/zed/main.sh` in your `.zshrc` or `.zprofile`

to run functions in new terminal sessions, place something like this in your `.zlogin`:
```
# run these when the terminal starts (+ make them yellow)
echo -n "$(tput setaf 3)"
kyouwa
daysuntil
scheduledevents
payday 24
nowplaying
location="Brighton and Hove"
esc_location=${location// /%20}
wttr $esc_location format='%c++%t+|+%w'
echo -n "$(tput sgr 0)"
```

## re: `wildwest.sh`
```
# This script is made up of a load of old bash
# functions and aliases, as things are tested
# and fixed, they'll be moved to new homes.

#  You have been warned:
#    Here be dragons.
```