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
set skip 300

set timestamp [exec date +%s];

# exit if last occurrence is less than $skip seconds ago get last occurrence
set command ""
append command "dom.GetObject('$sv').Value().ToTime().ToInteger();"
set lastOccurrence [rega $command]

# exit if last occurrence is less than $skip minutes ago

if {$lastOccurrence > [expr ($timestamp - $skip)] } {
    puts skipping
    exit 1
}

# check all hosts
foreach id [array names IPStatusHosts] {
    set status [pingCheck $IPStatusHosts($id)]

    # client is online => set sv status
    if {$status == 1} {
      puts "Setting new occurrence"

      set rega_cmd ""
      append rega_cmd "var ts = $timestamp;"
      append rega_cmd "var sv = dom.GetObject('$sv');"
      append rega_cmd "sv.State(ts.ToTime());"
      rega_script $rega_cmd
    }
}

exit 0