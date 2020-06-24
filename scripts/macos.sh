# Assorted macOS specific functions

alias enableChime='nvram StartupMute=%00'
alias disableChime='nvram StartupMute=%01'

# toggle hidden files, source: https://ianlunn.co.uk/articles/quickly-showhide-hidden-files-mac-os-x-mavericks/
# showHiddens and hideHiddens implicitly kill Finder
alias showHiddens='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideHiddens='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
# showDots and hideDots prompt for killing
alias showDots='defaults write com.apple.finder AppleShowAllFiles YES; finderKillPrompt'
alias hideDots='defaults write com.apple.finder AppleShowAllFiles NO; finderKillPrompt'
function finderKillPrompt(){
  read 'kill?Kill Finder? Y to kill, then hit [ENTER]: '
  if [[ $kill =~ "^(y|Y|yes|YES|Yes)$" ]];
  then
    echo 'Killing Finder';
    killall Finder /System/Library/CoreServices/Finder.app;
  else
    echo 'Finder lives to find another day';
  fi
}