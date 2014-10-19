; ***********************************
; TULULOO EXTENSION MAKER
; Created by Zoltan Percsich
; 2011-2014 SilentWorks
; ***********************************
; Go-Scintilla
; nxSoftWare (www.nxSoftware.com)
; ***********************************

UsePNGImageDecoder()

CompilerIf #PB_Compiler_OS = #PB_OS_Windows 
	InitScintilla()
CompilerEndIf

IncludePath "system"

; Include the scintilla header
XIncludeFile "GoScintilla.pbi"

; Scintilla related constants
Enumeration #PB_Compiler_EnumerationValue
	#STYLES_COMMANDS
	#STYLES_COMMENTS
	#STYLES_LITERALSTRINGS
	#STYLES_NUMBERS
	#STYLES_FUNCTIONS
	#STYLES_ITEM
	#STYLES_GM_FUNCTION
	#STYLES_GM_VARIABLE
	#STYLES_GM_CONSTANT
	#STYLES_ERROR
EndEnumeration

Enumeration
	#MainWindow
	#MainWindowMenu
	#MainWindowMenuNew
	#MainWindowMenuOpen
	#MainWindowMenuSave
	#MainWindowMenuSaveAs
	#MainWindowMenuExit
	#NameGadget
	#AuthorGadget
	#DescriptionGadget
	#HelpGadget
	#CodeGadget
	#NewIcon
	#OpenIcon
	#SaveIcon
	#SaveAsIcon
	#ExitIcon
EndEnumeration

Global sci_color_fore.i = RGB(0, 0, 0)
Global sci_color_selection_back.i = RGB(0, 0, 64)
Global sci_color_selection_fore.i = RGB(255, 255, 255)
Global sci_color_command.i = RGB(54, 45, 227)
Global sci_color_comment.i = RGB(160,160,160)
Global sci_color_string.i = RGB(198, 0, 198)
Global sci_color_number.i = RGB(208, 64, 64)
Global sci_color_function.i = RGB(35, 163, 35)
Global sci_color_resource.i = RGB(49, 170, 187)
Global sci_color_tu_function.i = RGB(32, 106, 34)
Global sci_color_tu_variable.i = RGB(81, 80, 19)
Global sci_color_tu_constant.i = RGB(60, 60, 60)
Global sci_color_caret.i = RGB(255, 240, 240)
Global sci_font_family.s = "Consolas"
Global sci_font_size.i = 11

Global EXTENSIONNAME.s = ""

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
 SetCurrentDirectory(RemoveString(GetCurrentDirectory(), GetFilePart(ProgramFilename()) + ".app/Contents/"))
CompilerEndIf
If FileSize("Extensions") <> -2 : CreateDirectory("Extensions") : EndIf

Declare.i SaveAs()
Declare.i DoSave()
Declare.i myLineStyler(id, *utf8Buffer.ASCII, numUtf8Bytes, currentLine, startLine, originalEndLine)
Declare.i myStylerUtility_StyleCommentPart(id, *utf8Buffer.ASCII, numUtf8Bytes, *ptrCommented.INTEGER)

;The following is our user-defined line-styling function, called whenever GoScintilla is called upon to style lines.
Procedure.i myLineStyler(id, *utf8Buffer.ASCII, numUtf8Bytes, currentLine, startLine, originalEndLine)
	
	Protected result = #GOSCI_STYLELINESASREQUIRED, blnIsEndOfPreviousLineCommented, numBytesToStyle, numBytesStyled, *ptrAscii.ASCII
	Protected blnLastSymbolAValidStarter = #True
	
	;Is the end of the previous line commented? (We store a flag to indicate this in the line data.)
	If currentLine > 0
		blnIsEndOfPreviousLineCommented = GOSCI_GetLineData(id, currentLine-1)
	EndIf
	
	;Need to loop through the UTF-8 buffer, alternating between styling comments and invoking GoScintilla's styling lexer as appropriate.
	While numUtf8Bytes
		
		If blnIsEndOfPreviousLineCommented
			numBytesStyled = myStylerUtility_StyleCommentPart(id, *utf8Buffer, numUtf8Bytes, @blnIsEndOfPreviousLineCommented)
			numUtf8Bytes - numBytesStyled
			*utf8Buffer + numBytesStyled
		EndIf
		
		blnLastSymbolAValidStarter = #True
		If numUtf8Bytes > 0
			
			;We are now outside of a comment block. We now search for an opening /* comment marker on a symbol by symbol basis.
			;All other symbols will be passed back to GoScintilla for styling.
			While numUtf8Bytes > 0
				
				numBytesStyled = 0
				*ptrAscii = *utf8Buffer
				If *ptrAscii\a = '/' And numUtf8Bytes > 1
					*ptrAscii + 1
					
					If blnLastSymbolAValidStarter And *ptrAscii\a = '/' ;We have a single line comment and so we style the remainder of this line (excluding EOL characters) appropriately.
						
						numBytesStyled = numUtf8Bytes
						
						;Do not apply the comment style to EOL characters as this can cause problems.
						*ptrAscii + numUtf8Bytes - 1
						While *ptrAscii\a = #LF Or *ptrAscii\a = #CR
							*ptrAscii - 1
							numBytesStyled - 1
						Wend
						
						ScintillaSendMessage(id, #SCI_SETSTYLING, numBytesStyled, #STYLES_COMMENTS)
						
					ElseIf *ptrAscii\a = '*' ;Open comment found.
						
						;Apply the comment style to the /* symbol so as not to confuse our comment styler utility function below.
						ScintillaSendMessage(id, #SCI_SETSTYLING, 2, #STYLES_COMMENTS)
						
						numUtf8Bytes - 2
						*utf8Buffer + 2
						blnIsEndOfPreviousLineCommented = #True ;Mark that, at this point, the end of the current line will be commented.
						
						Break
						
					EndIf
				EndIf
				
				If numBytesStyled = 0
					
					If *ptrAscii\a = 9 Or *ptrAscii\a = 32 Or *ptrAscii\a = ';'
						blnLastSymbolAValidStarter = #True
					Else
						blnLastSymbolAValidStarter = #False
					EndIf
					
					numBytesStyled = GOSCI_StyleNextSymbol(id, *utf8Buffer, numUtf8Bytes)    
				EndIf
				
				numUtf8Bytes - numBytesStyled
				*utf8Buffer + numBytesStyled
				
			Wend
		EndIf
	Wend
	
	;Mark the current line as appropriate, depending upon whether it is an open ended comment.
	If GOSCI_GetLineData(id, currentLine) <> blnIsEndOfPreviousLineCommented
		GOSCI_SetLineData(id, currentLine, blnIsEndOfPreviousLineCommented)
		result = #GOSCI_STYLENEXTLINEREGARDLESS
	EndIf
	
	ProcedureReturn result
	
EndProcedure

;A utility function called by our main line styler above to apply the comment style to any part of a line which is commented.
;Returns the number of bytes styled.
Procedure.i myStylerUtility_StyleCommentPart(id, *utf8Buffer.ASCII, numUtf8Bytes, *ptrCommented.INTEGER)
	
	Protected numBytesToStyle, *ptrAscii.ASCII
	*ptrAscii = *utf8Buffer
	
	While numBytesToStyle < numUtf8Bytes
		
		numBytesToStyle + 1
		
		If *ptrAscii\a = '*' And numBytesToStyle < numUtf8Bytes
			*ptrAscii + 1
			
			If *ptrAscii\a = '/'
				numBytesToStyle + 1
				*ptrCommented\i = #False 
				Break
			EndIf
			
		Else
			*ptrAscii + 1      
		EndIf
		
	Wend
	
	If numBytesToStyle
		
		;Do not apply the comment style to EOL characters. This will cause Scintilla to force us to restyle the entire document.
		;Instead we will leave myLineStyler() to invoke the GOSCI_StyleNextSymbol() function in order to apply the default style.
		*ptrAscii-1
		While *ptrAscii\a = #LF Or *ptrAscii\a = #CR
			
			numBytesToStyle - 1
			*ptrAscii-1
			If numBytesToStyle = 0
				Break
			EndIf
			
		Wend
		
		If numBytesToStyle
			ScintillaSendMessage(id, #SCI_SETSTYLING, numBytesToStyle, #STYLES_COMMENTS)
		EndIf
		
	EndIf
	
	ProcedureReturn numBytesToStyle
	
EndProcedure

Procedure InitCodeEditor(Gadget)
	
	GOSCI_SetColor(Gadget, #GOSCI_FORECOLOR, sci_color_fore)
	GOSCI_SetColor(Gadget, #GOSCI_SELECTIONBACKCOLOR, sci_color_selection_back)
	GOSCI_SetColor(Gadget, #GOSCI_SELECTIONFORECOLOR, sci_color_selection_fore)
	GOSCI_SetColor(Gadget, #GOSCI_CARETLINEBACKCOLOR, sci_color_caret)
	GOSCI_SetFont(Gadget, sci_font_family, sci_font_size)
	GOSCI_SetTabs(Gadget, 4)
	
	GOSCI_SetMarginWidth(Gadget, #GOSCI_MARGINFOLDINGSYMBOLS, 24)
	
	GOSCI_SetStyleColors(Gadget, #STYLES_COMMANDS, sci_color_command)
	GOSCI_SetStyleFont(Gadget, #STYLES_COMMENTS, "", -1, #PB_Font_Italic)
	GOSCI_SetStyleColors(Gadget, #STYLES_COMMENTS, sci_color_comment)	
	GOSCI_SetStyleColors(Gadget, #STYLES_GM_FUNCTION, sci_color_tu_function)
	GOSCI_SetStyleColors(Gadget, #STYLES_GM_VARIABLE, sci_color_tu_variable)
	GOSCI_SetStyleColors(Gadget, #STYLES_GM_CONSTANT, sci_color_tu_constant)
	GOSCI_SetStyleColors(Gadget, #STYLES_ITEM, sci_color_resource)
	GOSCI_SetStyleColors(Gadget, #STYLES_LITERALSTRINGS, sci_color_string)
	GOSCI_SetStyleColors(Gadget, #STYLES_NUMBERS, sci_color_number)
	GOSCI_SetStyleColors(Gadget, #STYLES_FUNCTIONS, sci_color_function)
	
	GOSCI_SetStyleFont(Gadget, #STYLES_ERROR, "", -1, #PB_Font_Bold)
	GOSCI_SetStyleColors(Gadget, #STYLES_ERROR, $FF0000)
	
	GOSCI_AddDelimiter(Gadget, Chr(34), Chr(34), #GOSCI_DELIMITBETWEEN, #STYLES_LITERALSTRINGS)
	GOSCI_AddDelimiter(Gadget, "'", "'", #GOSCI_DELIMITBETWEEN, #STYLES_LITERALSTRINGS)
	GOSCI_AddDelimiter(Gadget, "(", "", #GOSCI_RIGHTDELIMITWITHWHITESPACE, #STYLES_FUNCTIONS)
	GOSCI_AddDelimiter(Gadget, ")", "", 0, #STYLES_FUNCTIONS)
	
	GOSCI_AddKeywords(Gadget, "break case catch continue debugger default delete do else finally for function if in instanceof new return switch this throw try typeof var void while with true false null undefined", #STYLES_COMMANDS, #GOSCI_ADDTOCODECOMPLETION, #True)
	
	GOSCI_AddKeywords(Gadget, "{", #STYLES_COMMANDS, #GOSCI_OPENFOLDKEYWORD)
	GOSCI_AddKeywords(Gadget, "}", #STYLES_COMMANDS, #GOSCI_CLOSEFOLDKEYWORD)	
	
	GOSCI_SetLexerOption(Gadget, #GOSCI_LEXEROPTION_SEPARATORSYMBOLS, @"=+-*/%()[],.")
	GOSCI_SetLexerOption(Gadget, #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX, #STYLES_NUMBERS)
	GOSCI_SetLexerState(Gadget, #GOSCI_LEXERSTATE_ENABLESYNTAXSTYLING | #GOSCI_LEXERSTATE_ENABLECODEFOLDING | #GOSCI_LEXERSTATE_ENABLECODECOMPLETION | #GOSCI_LEXERSTATE_ENABLEAUTOINDENTATION)
	
	GOSCI_SetLineStylingFunction(Gadget, @MyLineStyler())
	
EndProcedure	

Procedure Open()
	
	File.s = OpenFileRequester("Select a Tululoo Game Maker Extension...", "", "Tululoo Extensions (*.tex)|*.tex", 0)
	
	If File <> ""
				
		Ext.s = ReplaceString(GetFilePart(File), ".tex", "")
		EXTENSIONNAME = Ext
		
		; Get extension details
		E_name.s = ""
		E_author.s = ""
		E_description.s = ""
		E_help.s = ""
		E_code.s = ""
		
		SetGadgetText(#NameGadget, "")
		SetGadgetText(#AuthorGadget, "")
		SetGadgetText(#DescriptionGadget, "")
		SetGadgetText(#HelpGadget, "")
		GOSCI_SetText(#CodeGadget, "")
		
		fp = OpenFile(#PB_Any, File)
		
		section.s = ""
		While Eof(fp) = 0
			
			row.s = ReadString(fp, #PB_UTF8)
			
			Select row
				Case "[EXTENSION]" : row = ReplaceString(row, row, "") : section = "extension"
				Case "[AUTHOR]" : row = ReplaceString(row, row, "") : section = "author"
				Case "[DESCRIPTION]" : row = ReplaceString(row, row, "") : section = "description"
				Case "[HELP]" : row = ReplaceString(row, row, "") : section = "help"
				Case "[CODE]" : row = ReplaceString(row, row, "") : section = "code"
			EndSelect
			
			If row <> "" And section <> "extension" And section <> "author" 
				row = row + Chr(13) + Chr(10)
			EndIf
			
			Select section
				Case "extension" : E_name = E_name + row
				Case "author" : E_author = E_author + row
				Case "description" : E_description = E_description + row
				Case "help" : E_help = E_help + row
				Case "code" : E_code = E_code + row
			EndSelect
			
		Wend
		
		CloseFile(fp)
		
		SetGadgetText(#NameGadget, E_name)
		SetGadgetText(#AuthorGadget, E_author)
		SetGadgetText(#DescriptionGadget, E_description)
		SetGadgetText(#HelpGadget, E_help)
		GOSCI_SetText(#CodeGadget, E_code)
		
	EndIf
	
EndProcedure

Procedure DoSave()
	DeleteFile("Extensions/" + EXTENSIONNAME + ".tex")
	fp = CreateFile(#PB_Any, "Extensions/" + EXTENSIONNAME + ".tex")
	WriteString(fp, "[EXTENSION]" + Chr(13) + Chr(10), #PB_UTF8)
	WriteString(fp, GetGadgetText(#NameGadget) + Chr(13) + Chr(10), #PB_UTF8)
	WriteString(fp, "" + Chr(13) + Chr(10), #PB_UTF8)
	WriteString(fp, "[AUTHOR]" + Chr(13) + Chr(10), #PB_UTF8)
	WriteString(fp, GetGadgetText(#AuthorGadget) + Chr(13) + Chr(10), #PB_UTF8)
	WriteString(fp, "" + Chr(13) + Chr(10), #PB_UTF8)
	WriteString(fp, "[DESCRIPTION]" + Chr(13) + Chr(10), #PB_UTF8)
	WriteString(fp, GetGadgetText(#DescriptionGadget) + Chr(13) + Chr(10), #PB_UTF8)
	WriteString(fp, "" + Chr(13) + Chr(10), #PB_UTF8)
	WriteString(fp, "[HELP]" + Chr(13) + Chr(10), #PB_UTF8)
	WriteString(fp, GetGadgetText(#HelpGadget) + Chr(13) + Chr(10), #PB_UTF8)
	WriteString(fp, "" + Chr(13) + Chr(10), #PB_UTF8)
	WriteString(fp, "[CODE]" + Chr(13) + Chr(10), #PB_UTF8)
	WriteString(fp, GOSCI_GetText(#CodeGadget) + Chr(13) + Chr(10), #PB_UTF8)
	WriteString(fp, "" + Chr(13) + Chr(10), #PB_UTF8)
	CloseFile(fp)
	
	If FileSize("Extensions/" + EXTENSIONNAME + ".tex") > 0
		MessageRequester("Tululoo Extension Maker", "Extension: " + EXTENSIONNAME + " successfully saved.")
	Else
		MessageRequester("Error", "Failed. Please try again.")
	EndIf
EndProcedure

Procedure Save()
	
	If EXTENSIONNAME <> ""
		DoSave()
	Else
		SaveAs()
	EndIf
	
EndProcedure

Procedure SaveAs()
	
	ExtensionWindow = OpenWindow(#PB_Any, 0, 0, 400, 100, "Enter the extension name", #PB_Window_ScreenCentered)
	DisableWindow(#MainWindow, 1)
	StickyWindow(ExtensionWindow, 1)
	
	CancelButton = ButtonGadget(#PB_Any, 10, 65, 100, 25, "Cancel")
	OKButton = ButtonGadget(#PB_Any, 290, 65, 100, 25, "OK")
	
	NameGadget = StringGadget(#PB_Any, 10, 10, 380, 25, EXTENSIONNAME)
	
	Done = 0
	Repeat
		Select WaitWindowEvent()

			Case #PB_Event_Gadget
				Select EventGadget()
						
					; Open
					Case OKButton
						EXTENSIONNAME = GetGadgetText(NameGadget)
						DoSave()
						Done = 1
						
					Case CancelButton
						Done = 1
					
				EndSelect
				
		EndSelect
	Until Done = 1
	
	; Close window
	StickyWindow(ExtensionWindow, 0)
	DisableWindow(#MainWindow, 0)			
	CloseWindow(ExtensionWindow)
	SetActiveWindow(#MainWindow)
	
EndProcedure

EditorFont = LoadFont(#PB_Any, "Courier", 10, #PB_Font_HighQuality)
MainFont = LoadFont(#PB_Any, "Arial", 10, #PB_Font_HighQuality)
MainFontBold = LoadFont(#PB_Any, "Arial", 10, #PB_Font_Bold | #PB_Font_HighQuality)

CatchImage(#NewIcon, ?NewIcon)
CatchImage(#OpenIcon, ?OpenIcon)
CatchImage(#SaveIcon, ?SaveIcon)
CatchImage(#SaveAsIcon, ?SaveAsIcon)
CatchImage(#ExitIcon, ?ExitIcon)

OpenWindow(#MainWindow, 0, 0, 1024, 720, "Tululoo Extension Maker", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)

NameLabel = TextGadget(#PB_Any, 10, 10, 200, 22, "Extension name")
StringGadget(#NameGadget, 10, 35, 200, 22, "")

AuthorLabel = TextGadget(#PB_Any, 10, 65, 200, 22, "Author")
StringGadget(#AuthorGadget, 10, 90, 200, 22, "")

DescriptionLabel = TextGadget(#PB_Any, 10, 120, 200, 22, "Description")
EditorGadget(#DescriptionGadget, 10, 145, 200, 80)

HelpLabel = TextGadget(#PB_Any, 10, 245, 200, 22, "Help")
EditorGadget(#HelpGadget, 10, 270, 200, 300)

CodeLabel = TextGadget(#PB_Any, 220, 10, 200, 22, "Code")

GOSCI_Create(#CodeGadget, 220, 35, 794, 670, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN)
InitCodeEditor(#CodeGadget)
RemoveKeyboardShortcut(#MainWindow, #PB_Shortcut_All)
GOSCI_SetText(#CodeGadget, "")

SetGadgetFont(NameLabel, FontID(MainFontBold))
SetGadgetFont(#NameGadget, FontID(MainFont))
SetGadgetFont(AuthorLabel, FontID(MainFontBold))
SetGadgetFont(#AuthorGadget, FontID(MainFont))
SetGadgetFont(DescriptionLabel, FontID(MainFontBold))
SetGadgetFont(#DescriptionGadget, FontID(MainFont))
SetGadgetFont(HelpLabel, FontID(MainFontBold))
SetGadgetFont(#HelpGadget, FontID(MainFont))
SetGadgetFont(CodeLabel, FontID(MainFontBold))
SetGadgetFont(#CodeGadget, FontID(EditorFont))

CreateImageMenu(#MainWindowMenu, WindowID(#MainWindow))
MenuTitle("File")
MenuItem(#MainWindowMenuNew, "New" + Chr(9) + "Ctrl+N", ImageID(#NewIcon))
MenuBar()
MenuItem(#MainWindowMenuOpen, "Open..." + Chr(9) + "Ctrl+O", ImageID(#OpenIcon))
MenuItem(#MainWindowMenuSave, "Save" + Chr(9) + "Ctrl+S", ImageID(#SaveIcon))
MenuItem(#MainWindowMenuSaveAs, "Save as...", ImageID(#SaveAsIcon))

CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux
 MenuBar()
 MenuItem(#MainWindowMenuExit, "Exit" + Chr(9) + "Ctrl+X", ImageID(#ExitIcon))
CompilerEndIf

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
 MenuItem(#PB_Menu_Quit,"Quit"+Chr(9)+"Cmd+Q")
CompilerEndIf

AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_N, #MainWindowMenuNew)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_O, #MainWindowMenuOpen)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_S, #MainWindowMenuSave)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_X, #MainWindowMenuExit)

Repeat
	Select WaitWindowEvent()
			
		Case #PB_Event_CloseWindow
			If MessageRequester("Confirm", "Exit from Tululoo Extension Maker?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
				End
			EndIf
			
			
		Case #PB_Event_Menu
			
			Select EventMenu()
					
				Case #MainWindowMenuNew
					If MessageRequester("Confirm", "Create a new extension?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
						EXTENSIONNAME = ""
						SetGadgetText(#NameGadget, "")
						SetGadgetText(#AuthorGadget, "")
						SetGadgetText(#DescriptionGadget, "")
						SetGadgetText(#HelpGadget, "")
						GOSCI_SetText(#CodeGadget, "")
					EndIf					
					
				Case #MainWindowMenuOpen
					Open()
					
				Case #MainWindowMenuSave
					Save()
					
				Case #MainWindowMenuSaveAs
					SaveAs()
					
				Case #MainWindowMenuExit
					If MessageRequester("Confirm", "Exit from Tululoo Extension Maker?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
						End
					EndIf
					
				Case #PB_Menu_Quit	
					If MessageRequester("Confirm", "Exit from Tululoo Extension Maker?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
						End
					EndIf
					
			EndSelect
			
	EndSelect 
	
ForEver

DataSection
	NewIcon: IncludeBinary "new_icon.png"
	OpenIcon: IncludeBinary "open_icon.png"
	SaveIcon: IncludeBinary "save_icon.png"
	SaveAsIcon: IncludeBinary "saveas_icon.png"
	ExitIcon: IncludeBinary "exit_icon.png"
EndDataSection
