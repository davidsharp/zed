#!/bin/zsh

# open applications saved in the Applications folder
function ∆(){
  if [ -d "/Applications/$1.app" ]; then
    open "/Applications/$1.app"
  else
    echo "Couldn't find \"$1.app\" in \"/Applications\", is it definitely installed there?"
  fi
}