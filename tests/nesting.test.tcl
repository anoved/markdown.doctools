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

mtest n1 "nested itemized list" \
{[list_begin itemized]
[item]one
[item]two
[list_begin itemized]
[item]alpha
[item]beta
[list_end]
[item]three
[list_end]} \
{-	one
-	two
	-	alpha
	-	beta
-	three

}

mtest n2 "nested enumerated list" \
{[list_begin enumerated]
[enum]one
[enum]two
[list_begin enumerated]
[enum]alpha
[enum]beta
[list_end]
[enum]three
[list_end]} \
{1.	one
2.	two
	1.	alpha
	2.	beta
3.	three

}

mtest n3 "enumerated list nested in itemized list" \
{[list_begin itemized]
[item]one
[item]two
[list_begin enumerated]
[enum]alpha
[enum]beta
[list_end]
[item]three
[list_end]} \
{-	one
-	two
	1.	alpha
	2.	beta
-	three

}

mtest n4 "itemized list nested in enumerated list" \
{[list_begin enumerated]
[enum]one
[enum]two
[list_begin itemized]
[item]alpha
[item]beta
[list_end]
[enum]three
[list_end]} \
{1.	one
2.	two
	-	alpha
	-	beta
3.	three

}

mtest n5 "three levels of nesting" \
{[list_begin enumerated]
[enum]outer
[list_begin itemized]
[item]middle
[list_begin enumerated]
[enum]inner
[list_end]
[list_end]
[list_end]} \
{1.	outer
	-	middle
		1.	inner

}

mtest n6 "nested definition list" \
{[list_begin definitions]
[def foo]one
[def bar]two
[list_begin definitions]
[def alpha]zeta
[def beta]omega
[list_end]
[def soom]three
[list_end]} \
{foo

> one

bar

> two
> 
> alpha
> 
> > zeta
> 
> beta
> 
> > omega

soom

> three

}

mtest n7 "itemized list nested in definition list" \
{[list_begin definitions]
[def foo]one
[def bar]two
[list_begin itemized]
[item]alpha
[item]beta
[list_end]
[def soom]three
[list_end]} \
{foo

> one

bar

> two
> 
> -	alpha
> -	beta

soom

> three

}

mtest n8 "enumerated list nested in definition list" \
{[list_begin definitions]
[def foo]one
[def bar]two
[list_begin enumerated]
[enum]alpha
[enum]beta
[list_end]
[def soom]three
[list_end]} \
{foo

> one

bar

> two
> 
> 1.	alpha
> 2.	beta

soom

> three

}

mtest n9 "definition list nested in itemized list" \
{[list_begin itemized]
[item]one
[item]two
[list_begin definitions]
[def foo]alpha
[def bar]beta
[list_end]
[item]three
[list_end]} \
{-	one
-	two
	
	foo
	
	> alpha
	
	bar
	
	> beta
-	three

}

mtest n10 "definition list nested in enumerated list" \
{[list_begin enumerated]
[enum]one
[enum]two
[list_begin definitions]
[def foo]alpha
[def bar]beta
[list_end]
[enum]three
[list_end]} \
{1.	one
2.	two
	
	foo
	
	> alpha
	
	bar
	
	> beta
3.	three

}

mtest n11 "four levels of definition nesting" \
{[list_begin definitions]
[def outer]a
[list_begin definitions]
[def middle]b
[list_begin definitions]
[def extra]c
[list_begin definitions]
[def inner]d
[list_end]
[list_end]
[list_end]
[list_end]} \
{outer

> a
> 
> middle
> 
> > b
> > 
> > extra
> > 
> > > c
> > > 
> > > inner
> > > 
> > > > d

}


::tcltest::cleanupTests
