package require Tcl 8.5
package require tcltest 2
namespace import ::tcltest::test
::tcltest::workingDirectory [file dirname [info script]]
eval ::tcltest::configure $argv

package require doctools
set testnum 0

proc dth {content} {
	return [format {[manpage_begin test 1 1][description]%s[manpage_end]} $content]
}

proc mdh {content} {
	return [format "\n\n# test\n\n# DESCRIPTION\n\n%s" $content]
}

proc mtest {description dtinput mdoutput} {
	global testnum
	test nesting-[incr testnum] $description \
			-setup {::doctools::new doc -format ../markdown.doctools.tcl} \
			-body {doc format [dth $dtinput]} \
			-cleanup {doc destroy} \
			-result [mdh $mdoutput]
}

mtest "nested itemized list" \
		{[list_begin itemized][item]one[item]two[list_begin itemized][item]alpha[item]beta[list_end][item]three[list_end]} \
		"- one\n- two\n\t- alpha\n\t- beta\n- three\n\n"

mtest "nested enumerated list" \
		{[list_begin enumerated][enum]one[enum]two[list_begin enumerated][enum]alpha[enum]beta[list_end][enum]three[list_end]} \
		"1. one\n2. two\n\t1. alpha\n\t2. beta\n3. three\n\n"

mtest "enumerated list nested in itemized list" \
		{[list_begin itemized][item]one[item]two[list_begin enumerated][enum]alpha[enum]beta[list_end][item]three[list_end]} \
		"- one\n- two\n\t1. alpha\n\t2. beta\n- three\n\n"

mtest "itemized list nested in enumerated list" \
		{[list_begin enumerated][enum]one[enum]two[list_begin itemized][item]alpha[item]beta[list_end][enum]three[list_end]} \
		"1. one\n2. two\n\t- alpha\n\t- beta\n3. three\n\n"

mtest "three levels of nesting" \
		{[list_begin enumerated][enum]outer[list_begin itemized][item]middle[list_begin enumerated][enum]inner[list_end][list_end][list_end]} \
		"1. outer\n\t- middle\n\t\t1. inner\n\n"

mtest "nested definition list" \
		{[list_begin definitions][def foo]one[def bar]two[list_begin definitions][def alpha]zeta[def beta]omega[list_end][def soom]three[list_end]} \
		"foo\n\n> one\n\nbar\n\n> two\n> \n> alpha\n> \n> > zeta\n> \n> beta\n> \n> > omega\n\nsoom\n\n> three\n\n"

::tcltest::cleanupTests
