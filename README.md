homematicIPState
================
ping.tcl
Aufruf im homematic Programm
Setzt die Systemvariabel auf true/false, abhängig von der Erreichbarkeit der IP-Adresse
dom.GetObject("CUxD.CUX2801001:1.CMD_EXEC").State("cd /usr/local/addons/homematicIPState && tclsh ping.tcl '<IP-Adresse>' '<Systemvariabel>'");


IPState.tcl
Aufruf im homematic Programm