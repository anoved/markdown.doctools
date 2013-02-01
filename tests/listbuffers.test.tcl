package require Tcl 8.5
package require tcltest 2
namespace import ::tcltest::test
::tcltest::workingDirectory [file dirname [info script]]
eval ::tcltest::configure $argv

package require doctools

proc dth {content} {
	return [format {[manpage_begin test 1 1][description]%s[manpage_end]} $content]
}

proc mdh {content} {
	return [format "\n\n# test\n\n# DESCRIPTION\n\n%s" $content]
}

proc mtest {testname description dtinput mdoutput} {
	test $testname $description \
			-setup {::doctools::new doc -format ../markdown.doctools.tcl} \
			-body {doc format [dth $dtinput]} \
			-cleanup {doc destroy} \
			-result [mdh $mdoutput]
}

mtest dl1 "dl list element buffer" \
{[list_begin definitions]
[def foo]one
[def bar]two
[def soom]three
[list_end]} \
{foo

> one

bar

> two

soom

> three

}

mtest ol1 "ol list element buffer" \
{[list_begin enumerated]
[enum]one
[enum]two
[enum]three
[list_end]} \
{1.	one
2.	two
3.	three

}

mtest ul1 "ul list element buffer" \
{[list_begin itemized]
[item]one
[item]two
[item]three
[list_end]} \
{-	one
-	two
-	three

}

::tcltest::cleanupTests
