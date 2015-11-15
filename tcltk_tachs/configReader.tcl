#############################################################################
##
##    		  Global Edge SoftWare Limited.
## 
##  SCRIPTNAME   : FspfEventSimulater.tck
##  DEVELOPER    : V. Bhaskar
##  DATE         : 20-07-2003
##  REVISION     : 1.1.b
##  PLATFORM     : Red Hat Linux 8.0 
##  LANGUAGE     : tck & tk
##  PURPOSE      :  A Script to implement a Centralized Event Manager
##                 all fspfAgents running
##
##  CHANGE LOG   :
##
##  HISTORY      :
##  
##	DATE     : 2-08-2003
##       BY      : V.Bhaskar & E.Rajshekhar
##  MODIFICATION : Added code for Status Field in GUI.
##    
##      DATE 	 : 29-08-2003
##	 BY      : V. Bhaskar & E.Rajshekhar
##  MODIFICATION : Fixed a bug while forming hash arrays using keys which are strings. 
##                 Now spaces are removed,if any, before reading the values from 
##		   Config file into local variables (used as keys for hashes).
##		   	
##############################################################################

#global ExecFile ExecSource ConfigFile eventLogFile
#global TRUE FALSE msgWindow logFileId  b1Frame b2Frame
#global array arrayDomWithIp arraySpairWithDpair textWindow
set ExecFile ./eventTransporter
set ExecSource ./eventTransporter.c
set ConfigFile ./config.cfg
set eventLogFile ./eventLogs
set prevLogFile ./prevEventLogs
set TRUE  1;set FALSE 0
set textWindow Nothing

############################################################
##    This Function Reads line by line from Config file 
##  and Splits this line read into fileds by delimeter ":"
##  then passes it to the InsertValuesIntoArrays Function
##  for further processing.
#### NOTE:- Exists on not enough fields, invalid Ip Address. 
############################################################
proc ReadFromConfig { filename } {
    global FALSE TRUE
    set fileId [open ./$filename r] 
    while { [gets $fileId line] != -1 } {
    	set fields [split $line ":"]
    	if { [llength $fields ] == 3 } {
	    if { [isValidIpAddress [lindex $fields 1]] } {
    	       eval InsertValuesIntoArrays { [lindex $fields 0] \
     	   		  		     [lindex $fields 1] \
    	   				     [lindex $fields 2] }
	    } else { exit }
        }
    }
    close $fileId	
}

################################################################
##   This Function validates the Given Ip Address
## Input  : Ip_Address
## OutPut : returns TRUE if Ip is Valid, FALSE otherwise
################################################################
proc isValidIpAddress { ip } {
    set Values [split $ip "."]
    set total [llength $Values]
    if { [expr $total!=4 ] } { return FALSE }
    foreach i $Values {
        if { [ expr ($i>255)||($i<0) ] } {
	    puts "isValidIpAddress: Invalid Ip Address => $ip"
	    return FALSE
	}
    }
    return TRUE
}
####################################################################
##	This Function does :
##  1.   calls validate functions for domain and ip, if valid	
##	inserts into hashArray ( key = domainId )
##  2.   Processes Port Pairs in to variables and then calls
## 	a function for inserting into a hashArray(Key = sdom:sport)
## Input  : source Domain, source IpAddress, portPair List
## Output : returns TRUE on success
##	    returns FALSE on failure.
#####################################################################
proc InsertValuesIntoArrays { sDomId sIp portPairs } {
    global TRUE FALSE 
    global array arrayDomWithIp     	
    # Remove spaces in the given DomainId and IP
    regsub -all " " "$sDomId" "" sDomId	
    regsub -all " " "$sIp" "" sIp
    set arrayDomWithIp($sDomId) $sIp
    ## Lets Process the Port Pairs...into connections
    set pairs [split $portPairs ";"]
    set count [llength $pairs]
    for {set i 0} { $i < $count} {incr i} {
	set onePair [lindex $pairs $i]
	if { [regexp {[ 0-9]+ [ 0-9]+ [ 0-9]+} $onePair] == 1 } {
  	    set dDomId  [lindex $onePair 0]
	    set sPort   [lindex $onePair 1]
	    set dPort   [lindex $onePair 2]
	    ## Call the Function to check and insert...ignore return value	
	    InsertThePairsIntoHashArray $sDomId $sPort $dDomId $dPort 
	}
    }	
}

####################################################################
##    This Function puts the source and destination port pairs into 
##   the HashArray if that was not present Previously. else returns 
##   a FALSE flag; 
## Input  : source Domain & Port, destination Domain & Port
## Output : HashArray updated, returns TRUE if the pair not already 
##         there returns FALSE.
#####################################################################
proc InsertThePairsIntoHashArray { sDomId sPort dDomId dPort } {
    global TRUE FALSE
    global array arraysPairWithdPair
    set sPair "$sDomId:$sPort"
    set dPair "$dDomId:$dPort"
    #puts "s=> \'$sDomId:$sPort\' == d=>\'$dDomId:$dPort\'"
    set sPairList [array names arraysPairWithdPair]
    if { [lsearch -exact $sPairList $sPair] != -1 } { return $FALSE }
    if { [lsearch -exact $sPairList $dPair] != -1 } { return $FALSE }
    set arraysPairWithdPair($sDomId:$sPort) $dDomId:$dPort 
    set arraysPairWithdPair($dDomId:$dPort) $sDomId:$sPort 	
    return $TRUE
}

##################################################################
##    This Function returns the destination Pair ( dDomId:dPort )
##   for a given source Pair ( sDomId:sPort )
## Input  : source Pair
## Output : returns corresponding destination pair if present
##  	    returns FALSE is not present
###################################################################
proc getdPairWithsPair { sPair } {
    global TRUE FALSE
    global array arraysPairWithdPair
    set sPairList [array names arraysPairWithdPair]
    if { [lsearch -exact $sPairList $sPair] == -1 } { return $FALSE }
    return $arraysPairWithdPair($sPair) 
}

#################################################################
##    This Function returns all the Domains Present
##   Input  : Nothing
##   Output : returns all the Domains as a list if present.
##	      returns FALSE if not found
#################################################################
proc getAllDomains { } {
    global TRUE FALSE
    global array arraysPairWithdPair
    set allDomains { }
    set sPairList [array names arraysPairWithdPair]
    set count [llength $sPairList]
    if { $count == 0 } { return $FALSE }
    for {set i 0} { $i < $count } {incr i} {
 	set sDsPpair [lindex $sPairList $i]
	set sDsP  [split $sDsPpair ":"] 
	set sDom  [lindex $sDsP 0]
	if { [lsearch -exact $allDomains $sDom ] == -1 } {
		set allDomains [linsert $allDomains 0 $sDom]
	}
    }
    return $allDomains
}
#################################################################
##  	This Function returns the Ip Address for a given Domain.
##   Input  : DomainId
##   Output : returns Ip Address for Given Domain
##	      returns FALSE if not found
#################################################################
proc getIpWithDomId { sDomId } {
    global TRUE FALSE
    global array arrayDomWithIp 
    set sDomList [array names arrayDomWithIp]
    if { [lsearch -exact $sDomList $sDomId] == -1 } { return $FALSE }
    return $arrayDomWithIp($sDomId)
}

##################################################################
##    This Function returns the all source Ports for this Domaind
## input  : source Domain
## output : returns sourcePort List if there are any in hashArray
##	    returns FALSE if not found
##################################################################
proc getSportsForDomain { sDomain } {
    global TRUE FALSE 
    set sourcePorts { }
    global array arraysPairWithdPair
    set sDomList [array names arraysPairWithdPair]
    set count [llength $sDomList]
    if { $count == 0 } { return $FALSE }
    for {set i 0} { $i < $count } {incr i} {
 	set sDsPpair [lindex $sDomList $i]
	set sDsP  [split $sDsPpair ":"] 
	set sDom  [lindex $sDsP 0]
	set sPort [lindex $sDsP 1]
	if { $sDom == $sDomain } { 
	    set sourcePorts [linsert $sourcePorts 0 $sPort] 
	}
    }
    set sourcePorts [lsort -integer $sourcePorts]
    return $sourcePorts
}

###########################################################	
###	Check if Files needed are Available!!	 	###
###########################################################	
## Find if Config File is present or not!
if { [file exists $ConfigFile] != 1 } {
   puts "Main: $ConfigFile: No Such File..."
   exit
}

###########################################################
##  If Transporter Binary is not present then Create is  ## 
## from Source File.( if exists );			 ##
##==>the TESTER need not worry about EventTransporter <==##
###########################################################
if { [file exists $ExecFile] != 1 } {
    if { [file exists $ExecSource ] == 1 } {
         set Status [exec cc -o $ExecFile $ExecSource]
    } else {
         puts "Main: $ExecSource: No Such File..."
         exit
    }
}

## Save Previous eventLogFile as OldeventLogFile
if { [file exists $eventLogFile] == 1 } {
    exec mv $eventLogFile $prevLogFile
}	

## Set the Global Variables
set logFileId [open $eventLogFile w]

## Main Starts with this call; tcl
ReadFromConfig $ConfigFile
