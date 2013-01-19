package require Tcl 8.5
package require tcltest 2

::tcltest::workingDirectory [file dirname [info script]]

::tcltest::configure \
		-testdir [::tcltest::workingDirectory] \
		-file {*.test.tcl} \
		-notfile {l.*.test.tcl} \
		-verbose {body pass skip error}

eval ::tcltest::configure $argv

::tcltest::runAllTests
