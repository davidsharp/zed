# Simple functions for opening specific apps from terminal

# a semi-functional alternative to the code cli program (args don't work)
function code(){
  open -a Visual\ Studio\ Code.app $@
}
function codenew(){ touch "$1"; code "$1"; }
alias create="codenew"

# open fork (git gui)
function fork(){
  open -a fork $@
}