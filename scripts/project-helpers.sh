# opinionated helpers for starting (node) projects

# init a project with defaults and open it in VSCode
# use like `$ init my-new-project`
function init(){
  mkdir $1 && cd $1 && git init && yarn init -y && touch .gitignore && echo "node_modules" > .gitignore && code .
}
# set your git user details for your current project
#  (in case your global needs to be different, for work, etc)
function gitconfig(){
  if [[ $1 ]];then
    git config --local --unset-all user.name
    git config --local --add user.name "$1"
    git config --local --unset-all user.email
    git config --local --add user.email "$2"
  else
    echo "[usage: $ gitconfig myepicusername my.epic@user.name]"
    echo "Current local git config :"
    git config -l --local
  fi  
}