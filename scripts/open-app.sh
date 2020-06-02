#!/bin/zsh

# open applications saved in the Applications folder
function ∆(){
  app=$1; shift;
  if [ -d "/Applications/$app.app" ]; then
    open -a "$app.app" $@
  else
    echo "Couldn't find \"$app.app\" in \"/Applications\", is it definitely installed there?"
  fi
}