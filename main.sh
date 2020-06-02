#!/bin/zsh
PROMPT="%F{yellow}%1~%f %F{magenta}≈%f "

# other functions live in scripts
for file in ~/Code/zed/scripts/*
do
  source $file
done
function readutils(){
  # this wouldn't work with scripts with spaces, by the way
  dash_scripts=($(ls ~/Code/zed/scripts))
  cat ${dash_scripts[@]} | less
}

# run these when the terminal starts (+ make them yellow)
#echo -n "$(tput setaf 3)"
#kyouwa
#daysuntil
#scheduledevents
#payday 24
#nowplaying
#location="Brighton and Hove"
#esc_location=${location// /%20}
#wttr $esc_location format='%c++%t+|+%w'
echo -n "$(tput sgr 0)"
