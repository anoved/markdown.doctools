#
# MANAGEMENT COMMANDS
#

proc fmt_numpasses {} {
	return 2
}

proc fmt_listvariables {} {
	return {}
}

proc fmt_varset {varname value} {
	# no module configuration variables supported
	# could provide options to toggle behavior between GitHub flavor and vanilla
	error "unknown variable $varname"
}

proc fmt_initialize {} {
	global docinfo
	set docinfo [dict create category {} copyright {} keywords {} moddesc {} require {} see_also {} titledesc {} synopsis {}]
}

proc fmt_setup {pass} {
	switch $pass 1 mddt_setup_1 2 mddt_setup_2
}

proc fmt_postprocess {text} {
	# collapse multiple blank lines to one (a cheat for sloppiness elsewhere!)
	#return [regsub -all "\n{2,}" $text "\n\n"]
	return $text
}

proc fmt_shutdown {} {
}

#
# PASS SETUP
#

proc mddt_setup_1 {} {
	
	#
	# Document information commands active
	#
	
	# fmt_call and fmt_usage should also be scanned in
	# pass 1 to accumulate synopsis listings.
	# Note that their arguments may be formatted with other markup commands,
	# though, so we do need to invoke those somehow.
	
	# note: "If more than one pass is required to perform the formatting only
	# the output of the last pass is relevant. The output of all the previous,
	# preparatory passes is ignored." Soooo, text markup commands could be
	# active permanently. On pass one, they'd only meaningfully be used to
	# format text that get scanned eg for synopsis, such as call or usage args.
	# With this approach, only the docinfo commands (and others that scan on
	# pass one) may need to be toggled.
	
	# built-in text formatter doesn't return text, but rather stores it all
	# in a cmds "display list" global, which it finally processes & returns
	# from fmt_postprocess.
	
	# name of document category (single string)
	proc fmt_category {text} {
		global docinfo
		dict set docinfo category $text
	}

	# document copyright (list of strings)
	proc fmt_copyright {text} {
		global docinfo
		dict lappend docinfo copyright $text
	}
	
	# document keywords (list of strings)
	proc fmt_keywords {args} {
		global docinfo
		dict lappend docinfo keywords {*}$args
	}

	# document module description (single string)
	proc fmt_moddesc {text} {
		global docinfo
		dict set docinfo moddesc $text
		if {[dict get $docinfo titledesc] eq {}} {
			dict set docinfo titledesc $text
		}
	}

	# package requirements of document module (list of {package version} lists)
	proc fmt_require {package {version {}}} {
		global docinfo
		dict lappend docinfo require [list $package $version]
	}

	# cross-references to other documents (list of strings)
	proc fmt_see_also {args} {
		global docinfo
		dict lappend docinfo see_also {*}$args
	}

	# document description (single string; defaults to moddesc)
	proc fmt_titledesc {text} {
		global docinfo
		dict set docinfo titledesc $text
	}
	
	#
	# Text structure and markup commands ignored during first pass.
	#
	
	proc fmt_plain_text {text} {}
	
	# text structure
	proc fmt_arg_def {type name {mode {}}} {}
	proc fmt_call {args} {} ; # scan for synopsis
	proc fmt_cmd_def {command} {}
	proc fmt_def {text} {}
	proc fmt_description {id} {}
	proc fmt_enum {} {}
	proc fmt_example {text} {}
	proc fmt_example_begin {} {}
	proc fmt_example_end {} {}
	proc fmt_item {} {}
	proc fmt_list_begin {type {fuck {}}} {}
	proc fmt_list_end {} {}
	proc fmt_manpage_begin {command section version} {}
	proc fmt_manpage_end {} {}
	proc fmt_opt_def {name {arg {}}} {}
	proc fmt_para {} {}
	proc fmt_section {name {id {}}} {} ; # scan for toc
	proc fmt_subsection {name {id {}}} {} ; # scan for toc
	proc fmt_tkoption_def {name dbname dbclass} {}	
	
	# text markup
	proc fmt_arg {text} {}
	proc fmt_class {text} {}
	proc fmt_cmd {text} {}
	proc fmt_const {text} {}
	proc fmt_emph {text} {}
	proc fmt_file {text} {}
	proc fmt_fun {text} {}
	proc fmt_image {id {label {}}} {}
	proc fmt_method {text} {}
	proc fmt_namespace {text} {}
	proc fmt_opt {text} {}
	proc fmt_option {text} {}
	proc fmt_package {text} {}
	proc fmt_sectref {id {label {}}} {}
	proc fmt_sectref-external {label} {}
	proc fmt_syscmd {text} {}
	proc fmt_term {text} {}
	proc fmt_type {text} {}
	proc fmt_uri {uri {label {}}} {}
	proc fmt_usage {args} {} ; # scan for synopsis
	proc fmt_var {text} {}
	proc fmt_widget {text} {}
	
	# deprecated
	proc fmt_bullet {} {}
	proc fmt_lst_item {text} {}
	proc fmt_nl {} {}
	proc fmt_strong {text} {}
}

proc mddt_setup_2 {} {

	#
	# Document information commands ignored during second pass.
	#
	
	proc fmt_category {text} {}
	proc fmt_copyright {text} {}
	proc fmt_keywords {args} {}
	proc fmt_moddesc {text} {}
	proc fmt_require {package {version {}}} {}
	proc fmt_see_also {args} {}
	proc fmt_titledesc {text} {}
	
	# plain text (context dependent)
	proc fmt_plain_text {text} {
		
		switch [ex_cname] {
			example {
				# indent lines within example blocks
				return [regsub -line -all -- {^} $text "\t"]
			}
		}
		
		# collapse paragraphs; only para tag
		# (and other explicit section breaks) should cause blank lines
		# this should not be applied to text in example blocks, since
		# they should appear exactly as formatted
		return [regsub -all -- "\n+" $text {}]
		
		#return $text
	}

	#
	# Text structure commands
	#
	
	proc fmt_arg_def {type name {mode {}}} {
		# arguments dl list element
	}
	
	proc fmt_call {args} {
		# general dl list element
	}
	
	proc fmt_cmd_def {command} {
		# commands dl list element
	}
	
	proc fmt_def {text} {
		# general dl list element
	}
	
	proc fmt_description {id} {
		# "Implicitly starts a section named "DESCRIPTION""
		return [fmt_section DESCRIPTION]
	}
	
	proc fmt_enum {} {
		# enumerated ol list element
	}
	
	# contrary to documentation, no fmt_example is supported. Instances of
	# [example] are internally wrapped as [example_begin][example_end] blocks.
	#proc fmt_example {text} {
	#	# attempt to prefix lines of example text
	#	return [regsub -all -line -- {^} $text "----"]
	#}
	
	proc fmt_example_begin {} {
		ex_cpush example
		return "\n\n"
	}
	
	proc fmt_example_end {} {
		ex_cpop example
		return "\n\n"
	}
	
	proc fmt_item {} {
		# itemized ul list element
		return "\n- "
	}
	
	proc fmt_list_begin {type {fuck {}}} {
		# start a list. Set some kind of mode flag indicating we're in a list
		# (relative to current context, I suppose, to support nested lists.)
		switch $type {
			arg -
			args -
			arguments {
				# arg_def (dl)
				ex_cpush list
				ex_cset type arguments
			}
			cmd -
			cmds -
			commands {
				# cmd_def (dl)
				ex_cpush list
				ex_cset type commands
			}
			definitions {
				# def or call (dl)
				ex_cpush list
				ex_cset type definitions
			}
			enum -
			enumerated {
				# enum (ol)
				ex_cpush list
				ex_cset type enumerated
			}
			bullet -
			item -
			itemized {
				# item (ul)
				ex_cpush list
				ex_cset type enumerated
			}
			opt -
			opts -
			options {
				# opt_def (dl)
				ex_cpush list
				ex_cset type options
			}
			tkoption -
			tkoptions {
				# tkoption_def (dl)
				ex_cpush list
				ex_cset type tkoptions
			}
			default {
				error "unknown list type $type"
			}
		}
		
		return "\n"
	}
	
	proc fmt_list_end {} {
		# close current list
		# so in THIS case, ex_cpop seems to indeed return the accumulated
		# output (unlike with example).
		return "[ex_cpop list]\n\n"
	}
	
	proc fmt_manpage_begin {command section version} {
		global docinfo
		# output header
		return [fmt_section "$command - [dict get $docinfo titledesc]"]
	}
	
	proc fmt_manpage_end {} {
		# output footer
	}
	
	proc fmt_opt_def {name {arg {}}} {
		# options dl list element
	}
	
	proc fmt_para {} {
		# paragraph - empty line
		return "\n\n"
	}
	
	proc fmt_section {name {id {}}} {
		# h1
		return "# $name\n\n"
	}
	
	proc fmt_subsection {name {id {}}} {
		# h2
		return "## $name\n\n"
	}
	
	proc fmt_tkoption_def {name dbname dbclass} {
		# tkoptions dl list element
	}
	
	#
	# Text markup commands
	#
	
	# name of a command argument
	proc fmt_arg {text} {
		# em
		return "*$text*"
	}

	# name of a class
	proc fmt_class {text} {
		# code
		return "`$text`"
	}

	# name of a Tcl command
	proc fmt_cmd {text} {
		# code
		return "`$text`"
	}

	# value of a constant
	proc fmt_const {text} {
		# code
		return "`$text`"
	}

	# generic emphasis
	proc fmt_emph {text} {
		# strong
		return "**$text**"
	}

	# name of a file or directory (a path)
	proc fmt_file {text} {
		# quoted code
		return "\"`$text`\""
	}

	# name of a function
	proc fmt_fun {text} {
		# code
		return "`$text`"
	}

	# image id (URI) and possibly label
	proc fmt_image {id {label {}}} {
		if {$label eq {}} {
			set label $id
		}
		# embedded img
		return "!\[$label\]($id)"
	}

	# name of an object method
	proc fmt_method {text} {
		# code
		return "`$text`"
	}

	# name of a namespace
	proc fmt_namespace {text} {
		# code
		return "`$text`"
	}

	# optional, as command arguments
	proc fmt_opt {text} {
		# quoted with ?
		return "?$text?"
	}

	# name of an option (ie, a command switch)
	proc fmt_option {text} {
		# code
		return "`$text`"
	}

	# name of package
	proc fmt_package {text} {
		# code
		return "`$text`"
	}

	# reference to section id, possibly with label
	# another stupid doctools quirk: fmt_sectref gets args in reverse order of [sectref]
	proc fmt_sectref {id {label {}}} {
		if {$label eq {}} {
			set label $id
		}
		# strong link
		return "**$label**"
	}

	# reference to external section with label
	proc fmt_sectref-external {label} {
		# strong
		return "**$label**"
	}

	# name of an external command
	proc fmt_syscmd {text} {
		# code
		return "`$text`"
	}

	# general terminology
	proc fmt_term {text} {
		# em
		return "*$text*"
	}

	# name of a data type
	proc fmt_type {text} {
		# code
		return "`$text`"
	}

	# URI and possibly its label
	proc fmt_uri {uri {label {}}} {
		if {$label eq {}} {
			set label $uri
		}
		# link
		return "\[$label\]($uri)"
	}

	# syntax of a command (first arg) with arguments (remainder of args)
	# like call, but silent; used only to populate synopsis
	proc fmt_usage {args} {}

	# name of a variable
	proc fmt_var {text} {
		# code
		return "`$text`"
	}

	# name of a widget
	proc fmt_widget {text} {
		# code
		return "`$text`"
	}
	
	# deprecated
	proc fmt_bullet {} {fmt_item}
	proc fmt_lst_item {text} {fmt_def $text}
	proc fmt_nl {} {fmt_para}
	proc fmt_strong {text} {fmt_emph $text}
}
