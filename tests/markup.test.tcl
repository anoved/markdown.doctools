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

# basic lists
mtest l1 "enumerated list" \
{[list_begin enum]
[enum]one
[enum]two
[enum]three
[list_end]} \
{1.	one
2.	two
3.	three

}

mtest l2 "itemized list" \
{[list_begin item]
[item]one
[item]two
[item]three
[list_end]} \
{-	one
-	two
-	three

}

mtest l3 "definition list" \
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

mtest l4 "definition list with call" \
{[list_begin definitions]
[call foo]one
[call bar a]two
[call soom 1 2 3]three
[list_end]} \
{foo

> one

bar a

> two

soom 1 2 3

> three

}

mtest l5 "arguments list" \
{[list_begin arguments]
[arg_def int foo]one
[arg_def double bar]two
[arg_def string soom]three
[list_end]} \
{int foo

> one

double bar

> two

string soom

> three

}

mtest l6 "commands list" \
{[list_begin commands][cmd_def foo]one
[cmd_def bar]two
[cmd_def soom]three
[list_end]} \
{foo

> one

bar

> two

soom

> three

}

mtest l7 "options list" \
{[list_begin options]
[opt_def foo]one
[opt_def bar]two
[opt_def soom alpha]three
[list_end]} \
{foo

> one

bar

> two

soom alpha

> three

}

mtest l8 "tkoptions list" \
{[list_begin tkoptions]
[tkoption_def foo fooname fooclass]one
[tkoption_def bar barname barclass]two
[list_end]} \
{foo fooname fooclass

> one

bar barname barclass

> two

}

# sections
mtest s1 "section" {[section Foo]} "# Foo\n\n"
mtest s2 "subsection" {[subsection Foo]} "## Foo\n\n"
mtest s3 "sections and text" {lorem[section Foo]ipsum} "lorem\n\n# Foo\n\nipsum"
mtest s4 "sections and subsections" {[section Foo][subsection Bar]} "# Foo\n\n## Bar\n\n"

# examples
mtest x1 "example" {[example {# comment and blank line

if {[command $variable]} {
	puts {**Hello, world!**}
}}]} "\t# comment and blank line\n\t\n\tif {\[command \$variable\]} {\n\t\tputs {**Hello, world!**}\n\t}\n\n"
# Use lb and rb for left and right brackets ([ and ]) in example blocks.
# Markup commands (such as [emph]) are applied in example blocks.
mtest x2 "example block" {[example_begin]# comment and blank line

if {[lb]command $variable[rb]} {
	puts {[emph {Hello, world!}]}
}[example_end]} "\t# comment and blank line\n\t\n\tif {\[command \$variable\]} {\n\t\tputs {**Hello, world!**}\n\t}\n\n"

# markup
mtest m1 "arg - em"         {[arg foo]}       {*foo*}
mtest m2 "class - code"     {[class foo]}     {`foo`}
mtest m3 "cmd - code"       {[cmd foo]}       {`foo`}
mtest m4 "const - code"     {[const foo]}     {`foo`}
mtest m5 "emph - strong"    {[emph foo]}      {**foo**}
mtest m6 "file - \"code\""  {[file foo]}      {"`foo`"}
mtest m7 "fun - code"       {[fun foo]}       {`foo`}
mtest m8 "image"            {[image foo]}     {![foo](foo)}
mtest m9 "image w/label"    {[image foo bar]} {![bar](foo)}
mtest m10 "method - code"    {[method foo]}    {`foo`}
mtest m11 "namespace - code" {[namespace foo]} {`foo`}
mtest m12 "opt - ?opt?"      {[opt foo]}       {?foo?}
mtest m13 "option - code"    {[option foo]}    {`foo`}
mtest m14 "package - code"   {[package foo]}   {`foo`}
mtest m15 "sectref"          {[sectref foo]}   {**foo**}
mtest m16 "sectref w/label"  {[sectref a b]}   {**b**}
mtest m17 "sectref-external" {[sectref-external foo]} {**foo**}
mtest m18 "syscmd - code"    {[syscmd foo]}    {`foo`}
mtest m19 "term - em"        {[term foo]}      {*foo*}
mtest m20 "type - code"      {[type foo]}      {`foo`}
mtest m21 "uri"              {[uri foo]}       {[foo](foo)}
mtest m22 "uri w/label"      {[uri foo bar]}   {[bar](foo)}
mtest m23 "var - code"       {[var foo]}       {`foo`}
mtest m24 "widget - code"    {[widget foo]}    {`foo`}

# deprecated markup
mtest d1 "strong (emph) - strong" {[strong foo]} {**foo**}


::tcltest::cleanupTests
