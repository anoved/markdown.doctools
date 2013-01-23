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

test dlbuffer-1.0 {dl list element buffer} \
		-setup {::doctools::new doc -format ../markdown.doctools.tcl} \
		-body {doc format {
[manpage_begin test 1 1]
[description]
[list_begin definitions]
[def foo]one
[def bar]two
[def soom]three
[list_end]
[manpage_end]
}} \
		-cleanup {doc destroy} \
		-result {

# test

# DESCRIPTION

foo

> one

bar

> two

soom

> three

}

::tcltest::cleanupTests
