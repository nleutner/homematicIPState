#!/bin/tclsh

# Check if host is is reachable
proc pingCheck {host} {

    if {![catch {exec ping -c 1 -s 1 $host}] } then {
        return 1
    }
    # offline
    return 0
}
