#!/bin/bash
COL=80
ROW=$(tput lines)

cleanup() {
  wait # wait for background jobs (the drops)
  # clear; move cursor to (1,1); show cursor
  # reset color
  printf '\033[2J\033[1;1H\033[?25h\033[0;0m'
}

drop() { # $1=column ; $2=row to end on ; $3 = drop size (ranges from 5 to 15)
  for ((r=1; r<$2+$3+1; r++)); do
    # if before drop's end point : print lowest char in white
    [ $r -lt $2 ] && printf "\033[$r;$1H\033[0;0m\u$[RANDOM % 59 + 21]"

    # if before or on drop's end point : replace older white char with a green one
    [ $r -le $2 ] && printf "\033[$[r-1];$1H\033[0;32m\u$[RANDOM % 59 + 21]"

    # if drop's longer than it's size : erase last char
    [ $r -gt $3 ] && printf "\033[$[r-$3];$1H "

    # wait before moving drop down
    sleep .1
  done
}

# cleanup on exit
trap cleanup EXIT
# clear screen; hide cursor
printf '\033[2J\033[?25l'

# loop with delay
while sleep .1; do
  # start a drop in background : column; ending row; size
  drop $[RANDOM % COL] $[RANDOM % ROW + ROW/3] $[RANDOM % 10 + 5] &
done