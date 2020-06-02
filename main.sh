#!/bin/zsh
PROMPT="%F{yellow}%1~%f %F{magenta}・%f "

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