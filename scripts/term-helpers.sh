# Helpers for hooking up common terminal tasks into single functions

# cd to a directory and ls immediately
function cdls(){ builtin cd "$@"; ls -FGAhno; }

# kills a program that's pointing at the specified port
# `$ portkill 8080`
function portkill(){
  if [ $1 ];then
    echo "killing program using port $1"
    kill $(lsof -t -i :$1)
  else
    echo "portkill needs a port to kill! portkill hungry!"
  fi  
}

# like `which`, but follows a symlink
# `$ whichsym npm`
function whichsym(){
  if [ $1 ];then
    symlink=$(which $1)
    followedlink=$(readlink $symlink)
    mungedpath=$(cd $(dirname $symlink);cd $(dirname $followedlink);echo "$(pwd)/$(basename $followedlink)")
    echo $mungedpath
  else
    echo "whichsym needs a symlink to which! whichsym hungry!"
  fi  
}