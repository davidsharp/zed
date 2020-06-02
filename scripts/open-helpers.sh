# Simple functions for opening specific apps from terminal

# a semi-functional alternative to the code cli program (args don't work)
function code(){
  open -a Visual\ Studio\ Code.app $@
}

# open fork (git gui)
function fork(){
  open -a fork $@
}