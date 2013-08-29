#!/bin/tclsh

# load libaries
load tclrega.so

# include functions
source /usr/local/addons/homematicIPState/lib/functions.tcl

set host [lindex $argv 0]
set sv [lindex $argv 1]

# logs
set date [exec date];
set log [open "/usr/local/addons/homematicIPState/ping.log" a]

puts "HOST: $host"
puts "SV: $sv"

set status [pingCheck $host]

# client is online0

if {$status == 1} {
    puts "Online"
} else {
    puts "Offline"
}

puts $log "$date : $host : $status"

# set system variable
set rega_cmd ""
append rega_cmd "var ip = dom.GetObject('$sv');"
append rega_cmd "ip.State('$status');"
rega_script $rega_cmd

exit