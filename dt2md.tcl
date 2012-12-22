#!/usr/bin/tclsh

package require doctools

# use the Markdown module by default
set module markdown.doctools.tcl
if {$argc == 1} {
	set module [lindex $argv 0]
}

::doctools::new doc -format $module
puts [doc format [read stdin]]
