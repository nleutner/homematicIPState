#!/bin/tclsh

# load libaries
load tclrega.so

# include functions
source lib/functions.tcl

# include config
source config.tcl

#
# internal config
#

set sv "IP Anwesenheit TS"
# skip running is client has been seen X seconds ago
set skip 30

set timestamp [exec date +%s];

# exit if last occurrence is less than $skip seconds ago get last occurrence
set command ""
append command "dom.GetObject('$sv').Value().ToTime().ToInteger();"
set lastOccurrence [rega $command]

# exit if last occurrence is less than $skip seconds ago
if {$lastOccurrence > [expr ($timestamp - $skip)] } {
    puts skipping
    exit 1
}


# logs
#set date [exec date];
#set log [open "/usr/local/addons/homematicIPState/IPState.log" a]

# check all hosts
foreach id [array names IPStatusHosts] {
    set status [pingCheck $IPStatusHosts($id)]

    puts "Host: $IPStatusHosts($id)"
    #puts $log "$date : $IPStatusHosts($id) : $status"

    # client is online => set sv status
    if {$status == 1} {
      puts "online - setting new occurrence"

      set rega_cmd ""
      append rega_cmd "var ts = $timestamp;"
      append rega_cmd "var sv = dom.GetObject('$sv');"
      append rega_cmd "sv.State(ts.ToTime());"
      rega_script $rega_cmd
    } else {
      puts "offline"
    }
}

exit 0