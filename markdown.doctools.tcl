#
# MANAGEMENT COMMANDS
#

proc fmt_numpasses {} {
	return 1
}

proc fmt_listvariables {} {
	return {}
}

proc fmt_varset {varname value} {
	# no module configuration variables supported
	error "unknown variable $varname"
}

proc fmt_initialize {} {
	# start of a conversion run
}

proc fmt_setup {pass} {
	# start of specified conversion pass
	# (at least one pass per run)
}

proc fmt_postprocess {text} {
	return $text
}

proc fmt_shutdown {} {
	# end of conversion run
}

# 22 text markup cmds
# 20 text structure commands 
# 7 document info commands

#
# FORMATTING COMMANDS
#

proc fmt_plain_text {text} {
	return $text
}

# Document Info
# We have to process (and insert) the information from these commands into
# the output document ourself. This is evidently the reason for the multi-pass
# processing design; one pass scans for these, then the second pass outputs them
# and processes the rest of the document as well.

# First pass: these document info procs are defined to accumulate/store values;
# all other formatting commands (text structure and text markup) are no-ops.

# Second pass: these document info procs are defined to be no-ops; all others
# perform as usual. Insert cached document info values as appropriate - into
# manpage_begin (header), manpage_end (footer), or at beginning of description.

# name of document category
proc fmt_category {text} {
}

# document copyright
proc fmt_copyright {text} {
}

# document keyword list
proc fmt_keywords {args} {
}

# document module description
proc fmt_moddesc {text} {
}

# package requirement of document module
proc fmt_require {package {version {}}} {
}

# cross-references to other documents
proc fmt_see_also {args} {
}

# document description (defaults to fmt_moddesc)
proc fmt_titledesc {text} {
}


# Text Markup

# name a command argument
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
proc fmt_sectref {id {label {}}} {
	if {$label eq {}} {
		set label $id
	}
	# strong link
	# (should link to id, using GitHub's anchor form of id)
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
# possibly fmt_call can use fmt_usage, plus list management stuff
proc fmt_usage {args} {
	# presumably the doctools frontend knows to keep quiet and insert in synopsis?
	# args are presumably already formatted with appropriate cmd, arg, etc commands.
	return [join $args]
}

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
