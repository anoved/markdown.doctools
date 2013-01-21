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
	test markup-[incr testnum] $description \
			-setup {::doctools::new doc -format ../markdown.doctools.tcl}
			-body {doc format [dth $dtinput]}
			-cleanup {doc destroy}
			-result [mdh $mdoutput]
}

mtest "arg - em"         {[arg foo]}       {*foo*}
mtest "class - code"     {[class foo]}     {`foo`}
mtest "cmd - code"       {[cmd foo]}       {`foo`}
mtest "const - code"     {[const foo]}     {`foo`}
mtest "emph - strong"    {[emph foo]}      {**foo**}
mtest "file - \"code\""  {[file foo]}      {"`foo`"}
mtest "fun - code"       {[fun foo]}       {`foo`}
mtest "image"            {[image foo]}     {![foo](foo)}
mtest "image w/label"    {[image foo bar]} {![bar](foo)}
mtest "method - code"    {[method foo]}    {`foo`}
mtest "namespace - code" {[namespace foo]} {`foo`}
mtest "opt - ?opt?"      {[opt foo]}       {?foo?}
mtest "option - code"    {[option foo]}    {`foo`}
mtest "package - code"   {[package foo]}   {`foo`}
mtest "sectref"          {[sectref foo]}   {**foo**}
mtest "sectref w/label"  {[sectref a b]}   {**b**}
mtest "sectref-external" {[sectref-external foo]} {**foo**}
mtest "syscmd - code"    {[syscmd foo]}    {`foo`}
mtest "term - em"        {[term foo]}      {*foo*}
mtest "type - code"      {[type foo]}      {`foo`}
mtest "uri"              {[uri foo]}       {[foo](foo)}
mtest "uri w/label"      {[uri foo bar]}   {[bar](foo)}
mtest "var - code"       {[var foo]}       {`foo`}
mtest "widget - code"    {[widget foo]}    {`foo`}

# deprecated markup
mtest "strong (emph) - strong" {[strong foo]} {**foo**}
