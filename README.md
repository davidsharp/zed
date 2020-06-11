# zed – zsh scripts
> opinionated zsh scripts, written for myself, but free to the world

## to use
to use, stick `source ~/path/to/zed/main.sh` in your `.zshrc` or `.zprofile`

or source specific scripts directly from `~/path/to/zed/scripts`

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

## highlights
- `gitconfig <name> <email>`: sets a name and email in the gitconfig to the current git directory, useful for using git for personal and work use on the same machine

## re: `wildwest.sh`
```
# This script is made up of a load of old bash
# functions and aliases, as things are tested
# and fixed, they'll be moved to new homes.

#  You have been warned:
#    Here be dragons.
```