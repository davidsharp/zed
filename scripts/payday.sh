# function which tells you whether today is payday
# run from main/in .zshrc like: payday 24
# (assumes you get paid Fri if payday falls on a weekend)

function payday(){
  DAY=$(date +%u)
  D_O_MONTH=$(date +%-d)
  if (($1 == $D_O_MONTH)) || (($DAY == 5 && (((($1 == $(date -j -v+1d +%-d))) || (($1 == $(date -j -v+2d +%-d))))))); then 
   echo "Today is payday!"
  fi
}