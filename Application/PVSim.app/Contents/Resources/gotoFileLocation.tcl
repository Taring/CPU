#------------------------------------------------------------------------------
# My version of Alpha's editFile that ask's no questions.
# Returns name of file's window.

proc myEditFile {{filePath ""}} {
	regexp {([^:/][^:/]*)$} $filePath fn
	set fileWinNum [lsearch -regexp [winNames -f] ".*$fn$"]
	if {$fileWinNum < 0} {
		file::openQuietly $filePath
		set fileWinNum [lsearch -regexp [winNames -f] ".*$fn$"]
	}
	set frontWindow [lindex [winNames -f] $fileWinNum]
	bringToFront $frontWindow
	return $frontWindow
}

#------------------------------------------------------------------------------
# Go to given character position in given file and select the given word.
# Used by the simulator to highlight a definition. Assumes Verilog source.

proc gotoFileLocation {{filePath ""} {position 0} {theWord ""}} {
	set fWin [myEditFile $filePath]
	regexp {([^.][^.]*)$} $theWord localName
        ##status::msg "localName=$localName"
	set wordPos [search -w $fWin -f 1 -r 0 -m 1 -i 1 -n -- "$localName" $position]
	if {$wordPos != ""} {
		select -w $fWin [lindex $wordPos 0] [lindex $wordPos 1]
	} else {
		goto -w $fWin $position
	}
	centerRedraw -w $fWin
	update idletasks
	enterSearchString -w $fWin
	refresh -w $fWin
}
