# ratty set of functions for setting a countdown to a date
#  use like: `$ setdaysuntil "My Big Holiday" 29/03/2018`
#   to see how many days: `$ daysuntil` to remove the countdown: `$ rmdaysuntil`
DAYSUNTILFILE=~/.daysuntildate
function daysuntil(){
  if [ -f $DAYSUNTILFILE ]; then
    c=0
    strings=()
    while read -r line
    do
      strings[$c]=$line
      let c=c+1
    done < $DAYSUNTILFILE
    while [  $c -gt 0 ]; do
      event=${strings[$(expr $c - 2)]}
      date=${strings[$(expr $c - 1)]}
      today=$(echo "$(date +%d/%m/%Y:00:00)")
      let days=$(echo $(((`date -jf %d/%m/%Y:%M:%S "$date:00:00" +%s` - `date -jf %d/%m/%Y:%M:%S $today +%s`)/86400)))
      echo "$days days until $event on $date"
      let c=c-2 
    done
  else
    echo "Not currently counting down for anything (hint: \`\$ setdaysuntil \"My Big Holiday\" 29/03/2018\`)"
  fi
}
function setdaysuntil(){
  echo -e "$1\n$2" > $DAYSUNTILFILE
  daysuntil
}
function rmdaysuntil(){
  rm $DAYSUNTILFILE
}
function adddaysuntil(){
  echo -e "$1\n$2" >> $DAYSUNTILFILE
  daysuntil
}

# Even rattier than days until, used for regular events,
#   requires specified dates for each instance
# No helper functions for now, maybe later?
SCHEDULEDEVENTSFILE=~/.scheduledevents
function scheduledevents(){
  if [ -f $SCHEDULEDEVENTSFILE ]; then
    c=0
    strings=()
    while read -r line
    do
      strings[$c]=$line
      let c=c+1
    done < $SCHEDULEDEVENTSFILE
    while [  $c -gt 0 ]; do
      read -a temp <<< $(echo ${strings[$(expr $c - 1)]} | tr ":" "\n")
      event=${temp[0]}
      dates=$(echo ${temp[1]} | tr ";" "\n")
      for date in $dates
      do
        if [ "$date" = "$(date +%d/%m/%Y)" ]; then
          echo "$event is today"
        fi
      done

      let c=c-1
    done
  else
    echo "Not currently got a schedule (hint: layout is \`event\ example:DD/MM/YYYY;DD/MM/YYYY;DD/MM/YYYY\`)"
  fi
}