#!/bin/bash
set -e

# rs232 controller for Nuvo Essentia
# version 0.1.0
# using zone10 instead of zone01

# set to the port your cable is connected to
port=/dev/ttyS0

pick01='Master Bathroom'
pick02='Sunroom'
pick03='Master Bedroom'
pick04='Dining Room'
pick05='Family Room'
pick06='Den'
pick07='Bedroom 2'
pick08='Bedroom 3'
pick09='Bedroom 4'


nuvo_main()
{
 clear
 echo "
   -- Nuvo Control System --
 Please choose from the following:
 (or enter 0 to exit this script)

  1. (Zone 10) $pick01
  2. (Zone 02) $pick02
  3. (Zone 03) $pick03
  4. (Zone 04) $pick04
  5. (Zone 05) $pick05
  6. (Zone 06) $pick06
  7. (Zone 07) $pick07
  8. (Zone 08) $pick08
  9. (Zone 09) $pick09
  g. (Global)  Global Submenu 
  h. (Help)    Help Summary 
  0. (Exit)    Exit Menu
"
  read -p " Enter selection [0-9,g,h] > " 

  case $REPLY in
    0) echo "  Program terminated."
       exit 0
       ;;  

    1) echo "  $pick01"
       room=$pick01
       # changed from zone 01 to 10
       zone=Z10
       nuvo_sub
       nuvo_main
       ;;  

    2) echo "  $pick02"
       room=$pick02
       zone=Z02
       nuvo_sub
       nuvo_main
       ;;  

    3) echo "  $pick03"
       room=$pick03
       zone=Z03
       nuvo_sub
       nuvo_main
       ;;  

    4) echo "  $pick04"
       room=$pick04
       zone=Z04
       nuvo_sub
       nuvo_main
       ;;  

    5) echo "  $pick05"    
       room=$pick05
       zone=Z05
       nuvo_sub
       nuvo_main
       ;;  

    6) echo "  $pick06"
       room=$pick06
       zone=Z06
       nuvo_sub
       nuvo_main
       ;;  

    7) echo "  $pick07"
       room=$pick07
       zone=Z07
       nuvo_sub
       nuvo_main
       ;;  

    8) echo "  $pick08"
       room=$pick08
       zone=Z08
       nuvo_sub
       nuvo_main
       ;;  

    9) echo "  $pick09"
       room=$pick09
       zone=Z09
       nuvo_sub
       nuvo_main
       ;;  

    g) echo "Global Stuff"
       global_sub
       nuvo_main
       ;;  

    h) echo "Help"
       help_sub
       nuvo_main
       ;;  

    *) echo "  Invalid selection."
       read -p " Press Enter to continue."
       nuvo_main
       ;;  
esac
}


help_sub()
{
 clear
 echo "
 --     HELP for Nuvo Control System     --

This script will control your Nuvo Essentia
through a serial (rs232) cable.

Press a number for the room you wish to control.

In the room menu:
  1-6   will change the source to listen to.
    7   will turn on the speakers for that room.
    8   will turn off the speakers for that room.
    9   will set a default volume for speakers.
  l,m,h will set volume to different levels.

"
  read -p " Press Enter to continue." 

  case $REPLY in
    *) nuvo_main
       ;;  
esac
}


nuvo_sub()
{
 clear
 mnow=`mpc current`
 echo "
 -- $room ($zone) Submenu --
    0. Main Menu
    1-6 Select Source
    7. Turn on
    8. Turn off
    9. Preset Volume
    l. Preset Low  Volume
    m. Preset Med  Volume
    h. Preset High Volume

   Currently playing on MPD:
  $mnow

    p. Prev song on MPD
    n. Next song on MPD
    t. toggle play/pause
"
  read -p " Enter selection [0-9,l,m,h,p,n,t] > " 

  case $REPLY in
    0) nuvo_main
       ;;  
    1) echo "*$zone"SRC1"" > $port
       nuvo_sub
       ;;  
    2) echo "*$zone"SRC2"" > $port
       nuvo_sub
       ;;  
    3) echo "*$zone"SRC3"" > $port
       nuvo_sub
       ;;  
    4) echo "*$zone"SRC4"" > $port
       nuvo_sub
       ;;  
    5) echo "*$zone"SRC5"" > $port
       nuvo_sub
       ;;  
    6) echo "*$zone"SRC6"" > $port
       nuvo_sub
       ;;  
    7) echo "*$zone"ON"" > $port
       nuvo_sub
       ;;  
    8) echo "*$zone"OFF"" > $port
       nuvo_sub
       ;;  
    9) echo "*$zone"VOL55"" > $port
       nuvo_sub
       ;;  
    l) echo "*$zone"VOL45"" > $port
       nuvo_sub
       ;;  
    m) echo "*$zone"VOL35"" > $port
       nuvo_sub
       ;;  
    h) echo "*$zone"VOL25"" > $port
       nuvo_sub
       ;;  
    p) mpc prev
       nuvo_sub
       ;;  
    n) mpc next
       nuvo_sub
       ;;  
    t) mpc toggle
       nuvo_sub
       ;;  
    *) echo "  Invalid selection."
       read -p " Press Enter to continue."
       nuvo_sub
       ;;  
esac
}


global_sub()
{
 clear
 echo "
 -- Global Submenu --
    0. Main Menu
    1. All OFF
    2. All Mute ON
    3. All Mute OFF
    4. Watch Nuvo Output
    5. Reset Port
    6. 
    7. 
    8. 
    9. Exit
"
  read -p " Enter selection [0-9] > " 

  case $REPLY in
    0) nuvo_main
       ;;  
    1) echo "*ALLOFF" > $port
       global_sub
       ;;  
    2) echo "*ALLMON" > $port
       global_sub
       ;;  
    3) echo "*ALLMOFF" > $port
       global_sub
       ;;  
    4) cat $port
       global_sub
       ;;  
    5) stty -F $port 9600 cs8 min 1 hupcl -inpck icrnl ixon -ixoff opost onlcr isig icanon iexten echo echoe echok
       echo "   Port $port reset."
       read -p " Press Enter to continue."
       global_sub
       ;;  
    6) echo ""
       global_sub
       ;;  
    7) echo ""
       global_sub
       ;;  
    8) echo ""
       global_sub
       ;;  
    9) echo "Exiting..."
       exit 0
       ;;  
    *) echo "  Invalid selection."
       read -p " Press Enter to continue."
       global_sub
       ;;  
esac
}

nuvo_main

