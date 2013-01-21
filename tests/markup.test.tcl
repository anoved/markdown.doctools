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
			-setup {::doctools::new doc -format ../markdown.doctools.tcl} \
			-body {doc format [dth $dtinput]} \
			-cleanup {doc destroy} \
			-result [mdh $mdoutput]
}

# basic lists
mtest "enumerated list" \
		{[list_begin enum][enum]one[enum]two[enum]three[list_end]} \
		"1. one\n2. two\n3. three\n\n"
mtest "itemized list" \
		{[list_begin item][item]one[item]two[item]three[list_end]} \
		"- one\n- two\n- three\n\n"
mtest "definition list" \
		{[list_begin definitions][def foo]one[def bar]two[def soom]three[list_end]} \
		"foo\n\n> one\n\nbar\n\n> two\n\nsoom\n\n> three\n\n"
mtest "definition list with call" \
		{[list_begin definitions][call foo]one[call bar a]two[call soom 1 2 3]three[list_end]} \
		"foo\n\n> one\n\nbar a\n\n> two\n\nsoom 1 2 3\n\n> three\n\n"
mtest "arguments list" \
		{[list_begin arguments][arg_def int foo]one[arg_def double bar]two[arg_def string soom]three[list_end]} \
		"int foo\n\n> one\n\ndouble bar\n\n> two\n\nstring soom\n\n> three\n\n"
mtest "commands list" \
		{[list_begin commands][cmd_def foo]one[cmd_def bar]two[cmd_def soom]three[list_end]} \
		"foo\n\n> one\n\nbar\n\n> two\n\nsoom\n\n> three\n\n"
mtest "options list" \
		{[list_begin options][opt_def foo]one[opt_def bar]two[opt_def soom alpha]three[list_end]} \
		"foo\n\n> one\n\nbar\n\n> two\n\nsoom alpha\n\n> three\n\n"
mtest "tkoptions list" \
		{[list_begin tkoptions][tkoption_def foo fooname fooclass]one[tkoption_def bar barname barclass]two[list_end]} \
		"foo fooname fooclass\n\n> one\n\nbar barname barclass\n\n> two\n\n"

# sections
mtest "section" {[section Foo]} "# Foo\n\n"
mtest "subsection" {[subsection Foo]} "## Foo\n\n"
mtest "sections and text" {lorem[section Foo]ipsum} "lorem\n\n# Foo\n\nipsum"
mtest "sections and subsections" {[section Foo][subsection Bar]} "# Foo\n\n## Bar\n\n"

# markup
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


::tcltest::cleanupTests
