#!/usr/bin/env bash
DEBUG=true

function debug_echo {
  if [ $DEBUG == 'true' ]; then 
    echo $@ 
  fi
}

function check_progs {
#Check existence of certain required programs
  PROGS="xdpyinfo wmctrl xprop echo awk cut"
  for name in $PROGS; do
    if [ ! `which $name` ];then
      echo -e "*Program “$name” is not installed or not in PATH."
      exit 1
    fi
  done
}

function gather_window {
  debug_echo "WINDOW: "$1
  WINDOW_ID=`echo $WINDOW |awk '{print $1}'`
  WINDOW_G=`echo $WINDOW |awk '{print $2}'`
  WINDOW_X=`echo $WINDOW |awk '{print $3}'`
  WINDOW_Y=`echo $WINDOW |awk '{print $4}'`
  WINDOW_W=`echo $WINDOW |awk '{print $5}'`
  WINDOW_H=`echo $WINDOW |awk '{print $6}'`
  WINDOW_RT=$(($WINDOW_X+$WINDOW_W)) 
  WINDOW_RTH=$(($WINDOW_Y+$WINDOW_H)) 

  debug_echo "WINDOW_SPLITS: $WINDOW_ID,$WINDOW_G,$WINDOW_X,$WINDOW_Y,$WINDOW_W,$WINDOW_H"

  if [[ $WINDOW_RT -gt $TOTAL_WIDTH ]] || [[ $WINDOW_RTH -gt $TOTAL_HEIGHT ]]
  then
    debug_echo "window $WINDOW off screen X - moving it..."
    debug_echo "params $WINDOW_G,50,20,$(($TOTAL_WIDTH-100)),$(($TOTAL_HEIGHT-100))"
    #wmctrl -v -i -r $WINDOW_ID -e $WINDOW_G,50,20,$(($TOTAL_WIDTH-100)),$(($TOTAL_HEIGHT-100))
    # wmctrl -v -i -r $WINDOW_ID -t 0
    wmctrl -v -i -r $WINDOW_ID -e $WINDOW_G,50,20,-1,-1
  fi
  if [ $WINDOW_W -gt $TOTAL_WIDTH ]; then
    debug_echo "resizing horz"
    wmctrl -i -r $WINDOW_ID -b remove,maximized_horz
    wmctrl -v -i -r $WINDOW_ID -e $WINDOW_G,50,20,$(($TOTAL_WIDTH-100)),-1
  fi
  if [ $WINDOW_H -gt $TOTAL_HEIGHT ]; then
    debug_echo "resizing vert"
    wmctrl -i -r $WINDOW_ID -b remove,maximized_vert
    wmctrl -v -i -r $WINDOW_ID -e $WINDOW_G,50,20,-1,$(($TOTAL_HEIGHT-100))
  fi
  # wmctrl -i -r $WINDOW_ID -b add,maximized_vert,maximized_horz
  # wmctrl -i -r $WINDOW_ID -b remove,shaded
}

check_progs

TOTAL_WIDTH=`xdpyinfo | grep 'dimensions:' | cut -f 2 -d ':' | cut -f 1 -d 'x' | tr -d ' '`
TOTAL_HEIGHT=`xdpyinfo | grep 'dimensions:' | cut -f 2 -d ':' | cut -f 2 -d 'x'| cut -f 1 -d ' ' | tr -d ' '`

THREEQUARTER_WIDTH=$(($TOTAL_WIDTH*3/4))
THREEQUARTER_HEIGHT=$(($TOTAL_HEIGHT*3/4))

# CURRENT_WINDOW_ID=`xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" |sed 's/.*\(0x.*\),.*/\1/'`

debug_echo screen width: $TOTAL_WIDTH
debug_echo screen height: $TOTAL_HEIGHT

WINDOW_LIST=`wmctrl -lG`
IFS=$'\n'
# WINDOW_LIST=`xlsclients -display :0.0 -l|grep 'Window 0x' |sed 's/://'|awk '{print $2}'`
for WINDOW in $WINDOW_LIST
do
	gather_window $WINDOW
done

exit 0




