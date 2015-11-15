#! /bin/bash
#==============================================================================
#		     BATCH 23 DATABASE MANAGEMENT
#      File Name : MyDB
#      Author    : Bhaskar.V
#      Date      : 6th Aug 2002
#      Version   : 1.2
#      Comments  : This file is the main File.This function runs the shell 
#                  codes Add,Remove,Change & Sort Depending on the Option
#                  Chosen.                
#==============================================================================
# Start of MyDB.sh

# Change the Following Variable Appropriately....( If You have copied ;-) );
# Used by All the Add, Remove, Display, Sort Modules? ( Be Aware !! )
DIR=$PWD

# Running First Time ? Create DATABASE File. 
[ ! -f $DIR/.DATABASE ] && touch $DIR/.DATABASE 

# Trap Control-C 
trap "echo -e \"\nCtrl-C is Disabled, Please Choose Exit as Choice..\"" 2  

xpos=3                                     # Initial X Position for tput
ypos=23                                    # Initial Y Position for tput
Choice=1   				   # Initially TRUE
while [ $Choice -le 5 -a $Choice -gt 0 ]   # Validate Choice
do
        clear
        echo -e '\E[40;041m'"`tput cup 1 48` `date` " ;
        echo -e '\E[40;033m'"`tput cup 23 68`Bhaskar[B.E]" ;
        echo -e '\E[40;033m'"`tput cup 24 70`  B23TR3 `tput sgr0` " ;
        echo -e '\E[43;037m'"`tput cup $xpos $ypos`******** BATCH-23 ********"; 
        xpos=`expr $xpos + 1`

	echo -e '\E[45;032m'"`tput cup $xpos $ypos`*                        *"
        xpos=`expr $xpos + 1`

        echo -e '\E[41;036m'"`tput cup $xpos $ypos`*      1.Add             *"
        xpos=`expr $xpos + 1`

	echo -e '\E[43;037m'"`tput cup $xpos $ypos`*      2.Remove          *" ;
        xpos=`expr $xpos + 1`
        
	echo -e '\E[46;031m'"`tput cup $xpos $ypos`*      3.Change          *"
        xpos=`expr $xpos + 1`

	echo -e '\E[42;034m'"`tput cup $xpos $ypos`*      4.Sort            *"
        xpos=`expr $xpos + 1`

	echo -e '\E[44;032m'"`tput cup $xpos $ypos`*      5.Display         *"
        xpos=`expr $xpos + 1`

        echo -e '\E[45;036m'"`tput cup $xpos $ypos`*      6.Exit            *"  
        xpos=`expr $xpos + 1`

        echo -e '\E[41;035m'"`tput cup $xpos $ypos`*                        *"  
        xpos=`expr $xpos + 1`
	 
        echo -e '\E[47;033m'"`tput cup $xpos $ypos`* Enter Your Choice :    *"
        ypos=`expr $ypos + 22 `
        tput sgr0 
        tput cup $xpos $ypos
        read Choice                         #  Getting the Option
         
            case $Choice in
	 	   1) export NSTATUS=0;
                      . /$DIR/.Add;         # Switch to Add
		      ;;
	     	   2) . /$DIR/.Remove;      # Switch to Remove
		      ;;
		   3) export NSTATUS=1;
                      . /$DIR/.Add;
		      ;;
	           4) . /$DIR/.Sort;        # Switch to Sort
                      . /$DIR/.Display; 
	              ;;
                   5) cat /$DIR/.DATABASE > DispFile ; 
                      . /$DIR/.Display;
                      ;;
                   *) break; 
                      ;;
		esac
       tput reset 
       xpos=3              # Reinitialize X Position
       ypos=23             # Reinitialize Y Position
done
      echo -e '\E[43;036m' "\n\n\n\n\n\n\n\t\t\t***  THANK YOU  ***\n\n"  
      tput sgr0 
      
unset NSTATUS
 # End Of DATABASE CODE 

