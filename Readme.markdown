

# markdown.doctools

# DESCRIPTION

precedograph

listbegin definition list:

*one*

> alpha
> 
> alpha two

*two for 2*

> beta

three

> gamma

four

> delta

# Definition List Example Code

Doctools code for a simple definition list:

	[list_begin definitions]
	[def foo]
	The first word used as a generic sample value.
	[example {
	for {set i 0} {i < 10} {incr i} {
		puts [expr {$i * 12}]
	}
	}]
	[def bar]
	The second word used for the same purpose.
	[para]
	Second paragraph of definition for second word.
	[list_end] (1-1)

Rendered as:

foo

> The first word used as a generic sample value.

	for {set i 0} {i < 10} {incr i} {
		puts [expr {$i * 12}]
	} (1-1)

bar

> The second word used for the same purpose.
> 
> Second paragraph of definition for second word.

The example embedded in the list is not correctly indented yet.

# Example Blocks

example (contents are not processed for markup):

	# comment example
	foreach {foo bar} $list {
		if {$foo} {
			puts $bar
		}
	} (1-1)

examplebegin and exampleend (contents **are** processed for markup; however, it seems that since markup tags split the example into multiple plaintext sections, the text immediately after a tag gets indented as if it is a newline. fmtplaintext therefore needs to know how to differentiate input that actually begins the line from input that starts in the middle of a line.)

	#  (1-1)*comment*	 example
	foreach {foo bar} $list {
		if {$foo} {
			puts $bar
		}
	} (1-1)

Finis.
