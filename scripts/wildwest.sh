# This script is made up of a load of old bash
# functions and aliases, as things are tested
# and fixed, they'll be moved to new homes.

#  You have been warned:
#    Here be dragons.

# below is my prompt-y bit of choice: `current-dir ~ `
#export PS1="\[\e[33m\]\W \[\e[35m\]~ \[\e[m\]"
#export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'
# or something a little fancier: `current-dir <random fruit>`
#FRUITS=(🍎 🍐 🍊 🍋 🍌 🍉 🍇 🍓 🍒 🍑 🍍 🥝)
#export PS1="\[\e[33m\]\W \[\e[35m\]${FRUITS[$(echo $RANDOM%12 | bc)]} \[\e[m\]"
# for a new fruit on each line, rather than one per session
# export PROMPT_COMMAND='echo -ne "${FRUITS[$(echo $RANDOM%12 | bc)]} "'

# read this (if it's your .bash_profile)
alias readbash="less ~/.bash_profile"

# reload this (if it's your .bash_profile)
alias reload="source ~/.bash_profile"

# open this to edit (if it's your .bash_profile)
alias editbash="code ~/.bash_profile"

# a semi-functional alternative to the code cli program (args don't work)
function code(){
  open -a Visual\ Studio\ Code.app $@
}

# open fork (git gui)
function fork(){
  open -a fork $@
}

# cd to a directory and ls immediately
function cdls(){ builtin cd "$@"; ls -FGAhno; }

# grab current weather takes an argument for the place
# `$ wttr brighton` or `$ wttr moon` or `$ wttr yyz` or even `$ wttr :help`
# if you know wttr flags, you can specify in a second param
# `$ wttr brighton `
# I could (and might) write some ifs, but if you want, remove the `?0`
function wttr(){
  if [ -z "$2" ]
   then
     curl -f "wttr.in/$1?0"
   else
     curl -f "wttr.in/$1?$2"
  fi
}

# quickly do maths (I always forget how so I end up running Node)
# `$ math "((5*5)+5)/6"` => 5
function math(){
  echo $@ | bc
}
# centimetres <-> inches (approximate) conversion
# cm takes inches and returns cm
function cm(){
  cms=`math "($@)*2.54"`
  # echo "$@ inches ≈ $cms cm"
  echo "$@ inches is approximately $cms cm"
}
# inch takes cm and returns inches
function inch(){
  inches=`math "($@)*0.39"`
  # echo "$@ cm = $inches inches"
  echo "$@ cm is $inches inches"
}

# naive Japanese word lookup, requires w3m (which is brew installable: `brew install w3m`)
# uses Jisho and displays it in a less page, rather than clogging up your shell
# probably only handles single words properly, or at least space-less strings
# `$ jisho android` or `$ jisho わたし`
function jisho(){
  w3m "jisho.org/search/$@" | sed -n '/Words\ /,/Other Dictionaries/p' | less
}

# I don't need this at work, because I've already decided by then
# but hey, can I wear shorts? `$ shorts Brighton`
function shorts(){
  echo "Can I wear shorts in $@?"
  w3m "caniwearshorts.today/?location=$@" | grep -A 1 'Well, Can I?'
}

# grab a gravatar URL by passing an email address `$ getGravatar hello@example.com`
function getGravatar(){
  echo gravatar.com/avatar/$(node -e "console.log(require('crypto').createHash('md5').update('$1').digest('hex'))")
}

# dump out Spotify song info using a bit of AppleScript (cribbed from https://github.com/yianL/atom-spotified/blob/master/src/utils/scripts/getTrack.applescript)
# I'll tidy this up one day and added a like function too
function spoti(){
  # this is pipeable into `less`, which is nice for not clogging the terminal
  # however `less` doesn't show our pretty emojis (use `less -r` to display correctly)
  osascript<<'END'
    on escape_quotes(string_to_escape)
	set AppleScript's text item delimiters to the "\""
  	set the item_list to every text item of string_to_escape
  	set AppleScript's text item delimiters to the "\\\""
	set string_to_escape to the item_list as string
  	set AppleScript's text item delimiters to ""
	return string_to_escape
    end escape_quotes
  
    if application "Spotify" is running then
  	tell application "Spotify"
		set ctrack to "Now playing – 🎧\n"
		set ctrack to ctrack & "🎵  " & my escape_quotes(current track's name)
		set ctrack to ctrack & " by " & my escape_quotes(current track's artist) & "\n"
		set ctrack to ctrack & "🎶    on " & my escape_quotes(current track's album) #& "\n"
		# set ctrack to ctrack & "\"duration\": " & current track's duration & "\n"
		# set ctrack to ctrack & "\"track_number\": " & current track's track number & "\n"
		# set ctrack to ctrack & "\"popularity\": " & current track's popularity & "\n"
		# set ctrack to ctrack & "\"album_artist\": \"" & my escape_quotes(current track's album artist) & "\"\n"
		# set ctrack to ctrack & "\"spotify_url\": \"" & current track's spotify url & "\"\n"
		return ctrack
	end tell
    else
	return ""
    end if
  END
}
# I wanted it green as quickly as possible
# `$ spot`
function spot(){
  echo "$(tput setaf 2)$(spoti)$(tput sgr 0)"
}

# Grab the artwork URL of the currently playing Spotify song
# `$ spotwork | xargs curl > my-image.jpeg`
function spotwork(){
osascript<<'END'
on escape_quotes(string_to_escape)
	set AppleScript's text item delimiters to the "\""
	set the item_list to every text item of string_to_escape
	set AppleScript's text item delimiters to the "\\\""
	set string_to_escape to the item_list as string
	set AppleScript's text item delimiters to ""
	return string_to_escape
end escape_quotes

if application "Spotify" is running then
	tell application "Spotify"
		# set ctrack to "Artwork for "
		# set ctrack to ctrack & my escape_quotes(current track's album)
		# set ctrack to ctrack & ":\n  \"" & current track's artwork url & "\""
                set ctrack to current track's artwork url
		return ctrack
	end tell
else
	return ""
end if
END
}
# figured it'd be good to have a function that saves the album artwork for you
function savework(){
  if [ $1 ];then
    spotwork | xargs curl > $1.jpeg
    echo "saved album artwork as $1.jpeg"
  else
    pbpaste > $(echo "spotify-album-$(date +%Y%m%d%M%S).jpeg")
    echo "saved album artwork as spotify-album-$(date +%Y%m%d%M%S).jpeg"
  fi
}
# dumb artwork renderer, requires `hit-that` (`yarn global add hit-that`)
function bitwork(){
  ht $(spotwork) | less -r
}

# single line 'now playing', doesn't print if nothing is playing
function nowplayingcore(){
osascript -l JavaScript<<'END'
const spotify = Application('spotify')
if(spotify.running()){
  try{
    const { name, artist } = spotify.currentTrack
    if(artist().length>0)`🎧 Now playing: ${name()} - ${artist()}`
    else `🎧 Now playing: ${name()}`
  }
  catch(e){''}
}
else ''
END
}
function nowplaying(){
  np=$(nowplayingcore)
  if [[ $np ]];then
    echo "$np"
  fi
}

# tweeter is a wrapper around `t`
# it prints a `t ruler` allowing better character counting
# this requires a working `t` installation
function tweeter(){
  echo "Enter tweet below and hit [ENTER]"
  t ruler
  read tweet
  t update "$tweet"
}

# get "today is Xday" in polite Japanese
# called it `youbi`, but got a `kyou`/`kyouwa` alias too
# TODO, also hiragana?
function youbi(){
  ARRAY=(日 月 火 水 木 金 土)
  DATE=$(date +%u)
  TODAY=${ARRAY[DATE]}
  kyouwa="今日は"
  youbi="曜日です"
  echo $kyouwa$TODAY$youbi
}
alias kyou="youbi"
alias kyouwa="youbi"

# this is dependent on moment-cli
# defaults to today, but takes DD/MM/YY
function whatday(){
  date=$([ $@ ] && echo "$@" || echo $(moment "$(date)" -f 'DD/MM/YY'))
  echo "$date is a $(moment $date -i DD/MM/YY -f 'dddd')"
}

# set your local git username and email on a repo
function gituser(){
  git config --local user.name "$1"
  git config --local user.email "$2"
}

# set `.nvmrc` to the current Node version being used
function setnvm(){
  if [ $1 ];then
    echo "$1" > .nvmrc
  else
    node -v > .nvmrc
  fi
  echo "set nvm version to $(cat .nvmrc)"
}
# set the default node version used on startup
function setnvmdefault(){
  if [ $1 ];then
    nvm alias default $1
  else
    echo "using node -v to find current version"
    nvm alias default $(node -v)
  fi
  #echo "set nvm default version to $(nvm alias default)"
}

# I always have to find this online, so bash it instead
# and also open it up for re-use! Good for quickly grabbing commonly used values
function copyHelper(){
  echo "$@" | pbcopy; echo "$@ <– was copied to your clipboard"
}
alias shrug="copyHelper '¯\_(ツ)_/¯'"
alias cl="echo \"\" | pbcopy; echo \"  --clipboard cleared--\""

# Save your clipboard into a file, pass a variable to name the file 
# defaults to current directory as `pasted-clipboard-<timestamp>`
function pasteAs(){
  if [ $1 ];then
    pbpaste > $1
    echo "saved clipboard as $1"
  else
    pbpaste > $(echo "pasted-clipboard-$(date +%Y%m%d%M%S)")
    echo "saved clipboard as pasted-clipboard-$(date +%Y%m%d%M%S)"
  fi
}

# sometimes I forget how bashmarks works
function h(){
  echo " bashmarks help :
   s <bookmark_name> - Saves the current directory as <bookmark_name>
   g <bookmark_name> - Goes (cd) to the directory associated with <bookmark_name>
   p <bookmark_name> - Prints the directory associated with <bookmark_name>
   d <bookmark_name> - Deletes the bookmark
   l                 - Lists all available bookmarks"
}

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

function payday(){
  DAY=$(date +%u)
  D_O_MONTH=$(date +%-d)
  if (($1 == $D_O_MONTH)) || (($DAY == 5 && (((($1 == $(date -j -v+1d +%-d))) || (($1 == $(date -j -v+2d +%-d))))))); then 
   echo "Today is payday!"
  fi
}

# depends on t, pipes your timeline into less, so it doesn't fill your terminal
function timeline(){
  t timeline -e=replies -n=80 $@ | less -r
}
function streamline(){
  # todo, something smarter
  t stream timeline -d
}

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

# pumps your clipboard contents into node
# output should happen via `console.log`s
function nodepaste(){
  pbpaste | node
}
# without an input, just nodepaste
# runs an eval and logs the result if not
# `$ nodeeval "[1,2,3].map(c=>c*3)"`
function nodeeval(){
  if [ $1 ];then
    clip=$(pbpaste)
    # echo $1 | pbcopy
    echo "console.log(eval(\"$1\"))" | pbcopy
    nodepaste
    echo "$clip" | pbcopy
  else
    echo "evaluating from clipboard:"
    nodepaste
  fi  
}

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

# quick tweet link
alias tweet="open https://twitter.com/intent/tweet"
