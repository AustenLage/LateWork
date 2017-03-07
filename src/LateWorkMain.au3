#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.14.2
	Author:         Austen Lage

	Script Function:
	Simplify grading process for some services.

#ce ----------------------------------------------------------------------------

#include <ButtonConstants.au3>
#include <DateTimeConstants.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <ComboConstants.au3>
#include <GUIListBox.au3>
#include <Array.au3>
#include <File.au3>
#include <Excel.au3>

#AutoIt3Wrapper_If_Run
	#AutoIt3Wrapper_Run_AU3Check=Y
	#AutoIt3Wrapper_Run_Tidy=N
#Autoit3Wrapper_If_Compile
	#AutoIt3Wrapper_OutFile="LateWork.exe"
	#AutoIt3Wrapper_Run_AU3Stripper=Y
	#AutoIt3Wrapper_Run_AU3Check=Y
	#AutoIt3Wrapper_Run_Tidy=Y
	#AutoIt3Wrapper_Compression=4
	#AutoIt3Wrapper_Res_Description="LateWork - Makes finding students with late work easy!"
#AutoIt3wrapper_EndIf

Global $bPrompt1 = 0, $MainGUI, $ClassesPeriodsGUI, $List_SearchList, $Combo_ClassPeriod, $aClassListMemory[8], $Date_SearchSince, $Radio_AllClasses, $Radio_SpecificClasses, $Radio_Everywhere, $Radio_Edmodo, $Radio_EdPuzzle, $Slider_Percentage, $aSearchParamMemory[10][10], $sClasses, $sAndClass, $sLocation, $sLastAddedClass, $iSliderMemory
;;I WILL REORGANIZE MY GLOBAL VARIBALE INITIALIZATIONS BY DATATYPE EVENTUALLY!

$aClassListMemory[0] = "0"

_MainGUI()

Func _MainGUI() ;This is the main GUI with all the question on it that you first see, this acts as a hub for the program
	ConsoleWrite('@@ (43) :(' & @MIN & ':' & @SEC & ') _MainGUI()' & @CR) ;### Function Trace
	#Region MAINGUI
	$MainGUI = GUICreate("LateWork", 691, 183, 598, 398)
	$Button1 = GUICtrlCreateButton("Options", 561, 158, 65, 25, $WS_GROUP)
	$Button2 = GUICtrlCreateButton("About?", 625, 158, 65, 25, $WS_GROUP)
	$Date_SearchSince = GUICtrlCreateDate("2017/02/16 16:25:27", 199, 48, 281, 21)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Label1 = GUICtrlCreateLabel("Check for late/incomplete work:", 2, 16, 262, 21)
	GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
	$Label2 = GUICtrlCreateLabel("Check for assignments since", 24, 50, 174, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$Label3 = GUICtrlCreateLabel("What classes/periods would you like me to look in?", 24, 77, 307, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	GUIStartGroup()
	$Radio_AllClasses = GUICtrlCreateRadio("All classes/periods", 330, 77, 129, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Radio_SpecificClasses = GUICtrlCreateRadio("Specific classes/periods (PROMPT)", 463, 77, 225, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUIStartGroup()
	$Label4 = GUICtrlCreateLabel("Where should I check for missing assignments?", 24, 104, 285, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	GUIStartGroup()
	$Radio_Everywhere = GUICtrlCreateRadio("Everywhere", 312, 104, 89, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Radio_Edmodo = GUICtrlCreateRadio("Edmodo only", 404, 104, 97, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Radio_EdPuzzle = GUICtrlCreateRadio("EdPuzzle only", 501, 104, 153, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUIStartGroup()
	$Label5 = GUICtrlCreateLabel("What percentage of completeness warrants a missing assignment?", 24, 131, 401, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$Label6 = GUICtrlCreateLabel("0%", 426, 132, 20, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Label7 = GUICtrlCreateLabel("100%", 599, 130, 34, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Slider_Percentage = GUICtrlCreateSlider(441, 130, 161, 17, BitOR($TBS_AUTOTICKS, $TBS_TOP, $TBS_LEFT))
	GUICtrlSetTip(-1, "EDMODO ONLY KNOWS IF SOMETHING IS MISSING BASED ON TEXT IN THE GRADE!")
	$Label8 = GUICtrlCreateLabel("0%", 441, 145, 161, 11, $SS_CENTER)
	$Button3 = GUICtrlCreateButton("?", 4, 50, 19, 17, $WS_GROUP)
	GUICtrlSetCursor(-1, 4)
	$Button4 = GUICtrlCreateButton("?", 4, 77, 19, 17, $WS_GROUP)
	GUICtrlSetCursor(-1, 4)
	$Button5 = GUICtrlCreateButton("?", 4, 104, 19, 17, $WS_GROUP)
	GUICtrlSetCursor(-1, 4)
	$Button6 = GUICtrlCreateButton("?", 4, 131, 19, 17, $WS_GROUP)
	GUICtrlSetCursor(-1, 4)
	$Button7 = GUICtrlCreateButton("CONTINUE", 264, 152, 161, 25, $WS_GROUP)
	GUICtrlSetBkColor(-1, 0x00FF00)
	$Group1 = GUICtrlCreateGroup("", 557, 148, 153, 73)
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUISetState(@SW_SHOW)
	#EndRegion MAINGUI

	#Region MainGUIWhileLoop
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE ;X Button (top right)
				_GUIState(0, $MainGUI)
				_ExitGUI()
				_GUIState(1, $MainGUI)
			Case $Radio_AllClasses ;All Classes/Periods radio
				GUICtrlSetTip($Radio_SpecificClasses, "")
				If $aClassListMemory[0] <> "0" Then
					If $bPrompt1 = 1 Then
						GUICtrlSetState($Radio_SpecificClasses, $GUI_CHECKED)
						_GUIState(0, $MainGUI)
						If _YesNoBox(4 + 4096, "Are you sure?", @CRLF & "Are you sure you would like to erase " & _
								"your previously selected classes/periods?") = 6 Then
							$bPrompt1 = 0
							_DeleteClassList()
							GUICtrlSetState($Radio_AllClasses, $GUI_CHECKED)
						EndIf
						_GUIState(1, $MainGUI)
					EndIf
				EndIf
			Case $Radio_SpecificClasses ;Specific classes/periods radio (prompt for details)
				GUICtrlSetTip($Radio_SpecificClasses, "Click again to edit previosly selected classes")
				_GUIState(0, $MainGUI)
				If $aClassListMemory[0] = "0" Then
					$bPrompt1 = 1
					_ClassesPeriodsGUI()
					If $aClassListMemory[0] = "0" Then
						GUICtrlSetState($Radio_AllClasses, $GUI_CHECKED)
					EndIf
				Else
					If _YesNoBox(4 + 4096, "Make Changes?", @CRLF & "Would you like to edit the classes/" & _
							"periods you previously selected?") = 6 Then
						WinActivate("LateWork")
						_ClassesPeriodsGUI()
					EndIf
				EndIf
				_GUIState(1, $MainGUI)
			Case $Radio_Edmodo
				GUICtrlSetTip($Slider_Percentage, "EDMODO ONLY KNOWS IF SOMETHING IS MISSING BASED ON TEXT IN THE GRADE!")
				$iSliderMemory = GUICtrlRead($Slider_Percentage)
				GUICtrlSetState($Slider_Percentage, $GUI_DISABLE)
				GUICtrlSetState($Label6, $GUI_DISABLE)
				GUICtrlSetState($Label7, $GUI_DISABLE)
				GUICtrlSetState($Label8, $GUI_DISABLE)
				GUICtrlSetData($Slider_Percentage, 0)
			Case $Radio_Everywhere
				GUICtrlSetTip($Slider_Percentage, "EDMODO ONLY KNOWS IF SOMETHING IS MISSING BASED ON TEXT IN THE GRADE!")
				GUICtrlSetState($Slider_Percentage, $GUI_ENABLE)
				GUICtrlSetState($Label6, $GUI_ENABLE)
				GUICtrlSetState($Label7, $GUI_ENABLE)
				GUICtrlSetState($Label8, $GUI_ENABLE)
				If GUICtrlRead($Slider_Percentage) = 0 Then
					GUICtrlSetData($Slider_Percentage, $iSliderMemory)
				EndIf
			Case $Radio_EdPuzzle
				GUICtrlSetTip($Slider_Percentage, "")
				GUICtrlSetState($Slider_Percentage, $GUI_ENABLE)
				GUICtrlSetState($Label6, $GUI_ENABLE)
				GUICtrlSetState($Label7, $GUI_ENABLE)
				GUICtrlSetState($Label8, $GUI_ENABLE)
				If GUICtrlRead($Slider_Percentage) = 0 Then
					GUICtrlSetData($Slider_Percentage, $iSliderMemory)
				EndIf
			Case $Button2
				_GUIState(0, $MainGUI)
				_AboutGUI()
				_GUIState(1, $MainGUI)
			Case $Button3 ;Date help button
				_GUIState(0, $MainGUI)
				_UserHelpGUI("Main_Date", $MainGUI)
				_GUIState(1, $MainGUI)
			Case $Button4 ;Class period help button
				_GUIState(0, $MainGUI)
				_UserHelpGUI("Main_Class", $MainGUI)
				_GUIState(1, $MainGUI)
			Case $Button5 ;Search location help button
				_GUIState(0, $MainGUI)
				_UserHelpGUI("Main_Location", $MainGUI)
				_GUIState(1, $MainGUI)
			Case $Button6 ;Percentage Help button
				_GUIState(0, $MainGUI)
				_UserHelpGUI("Main_Percentage", $MainGUI)
				_GUIState(1, $MainGUI)
			Case $Button7 ;Continue Button
				_GUIState(0, $MainGUI)
				_ConfirmationGUI()
				_GUIState(1, $MainGUI)
		EndSwitch
		If GUICtrlRead($Label8) <> GUICtrlRead($Slider_Percentage & "%") Then ;
			GUICtrlSetData($Label8, GUICtrlRead($Slider_Percentage) & "%") ;Sets live slider value at bottom of slider
		EndIf ;
	WEnd
	#EndRegion MainGUIWhileLoop
EndFunc   ;==>_MainGUI

Func _ClassesPeriodsGUI() ;GUI containing list that allows you to select specific period(s) to search in
	ConsoleWrite('@@ (198) :(' & @MIN & ':' & @SEC & ') _ClassesPeriodsGUI()' & @CR) ;### Function Trace
	#Region Classes/PeriodsGUI
	$ClassesPeriodsGUI = GUICreate("Classes/Periods Selection", 322, 314, 100, 100)
	_CenterMessageBox($MainGUI, $ClassesPeriodsGUI)
	$Combo_ClassPeriod = GUICtrlCreateCombo("Please Select a Class Period to add", 48, 16, 225, 25)
	GUICtrlSetData($Combo_ClassPeriod, "1st Period|2nd Period|3rd Period|4th Period|5th Period|6th Period|7th Period|8th Period") ;example classes to create code for search list (this combo will later be populated by a different function probably)
	$Button_AddList = GUICtrlCreateButton("ADD TO LIST", 96, 42, 129, 41, $WS_GROUP)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetTip(-1, "Add above slected period to the search list")
	$List_SearchList = GUICtrlCreateList("", 48, 88, 225, 175)
	If $aClassListMemory[0] <> "0" Then
		For $i = 0 To 7
			If $aClassListMemory[$i] <> "0" Then
				GUICtrlSetData($List_SearchList, $aClassListMemory[$i])
			EndIf
		Next
	EndIf
	$Button_RemoveList = GUICtrlCreateButton("REMOVE SELECTED", 96, 267, 129, 41, $WS_GROUP)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetTip(-1, "Add above selected period to the search list")
	WinSetOnTop($ClassesPeriodsGUI, "", 1)
	GUISetState(@SW_SHOW)
	#EndRegion Classes/PeriodsGUI

	#Region Classes/PeriodsGUIWhileLoop
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				If _GUICtrlListBox_GetText($List_SearchList, 0) == 0 Then
					GUICtrlSetState($Radio_AllClasses, $GUI_CHECKED)
					GUIDelete($ClassesPeriodsGUI)
					Return
				Else
					_RememberClassList()
					GUIDelete($ClassesPeriodsGUI)
					Return
				EndIf
			Case $Button_AddList
				_AddList()
			Case $Button_RemoveList
				_RemoveList()
		EndSwitch
		If _GUICtrlListBox_GetText($List_SearchList, 7) <> 0 Then
			_GUIState(0, $ClassesPeriodsGUI)
			Local $Prompt = _YesNoBox(262433, "Are you sure you want to do that?", @CRLF & "You have selected all classes, " & _
					"the list window will close and the correct option will be selected automatically.")
			If $Prompt = 7 Then
				_GUICtrlListBox_DeleteString($List_SearchList, _GUICtrlListBox_FindString($List_SearchList, $sLastAddedClass))
				_GUIState(1, $ClassesPeriodsGUI)
			ElseIf $Prompt = 6 Then
				GUIDelete($ClassesPeriodsGUI)
				GUICtrlSetState($Radio_AllClasses, $GUI_CHECKED)
				Return
			EndIf
		EndIf
	WEnd
	#EndRegion Classes/PeriodsGUIWhileLoop
EndFunc   ;==>_ClassesPeriodsGUI

Func _ConfirmationGUI() ;This GUI displays the text generated by _GetSearchParams() to confirm if it is correct before searching for late assignments
	ConsoleWrite('@@ (258) :(' & @MIN & ':' & @SEC & ') _ConfirmationGUI()' & @CR) ;### Function Trace
	Local $sCompleteness
	$ConfirmationGUI = GUICreate("Is this information correct?", 422, 90, 100, 100)
	_CenterMessageBox($MainGUI, $ConfirmationGUI)
	$Label1 = GUICtrlCreateLabel("", 8, 8, 404, 43, $SS_CENTER)
	_GetSearchParams()
	If $aSearchParamMemory[2][0] = 2 Then
		$sCompleteness = ", any late assignments(text in grade field) will be returned."
	ElseIf $aSearchParamMemory[2][0] = 1 Then
		$sCompleteness = ", with a minimum completeness of " & $aSearchParamMemory[3][0] & " percent."
	ElseIf $aSearchParamMemory[2][0] = 3 Then
		$sCompleteness = ", with a minimum completeness of " & $aSearchParamMemory[3][0] & " percent."
	EndIf
	WinActivate($MainGUI)
	WinActivate($ConfirmationGUI)
	GUICtrlSetData($Label1, "I will check for late assignments since " & $aSearchParamMemory[0][0] & " in " & $sClasses & _
			"I will look for assignments on " & $sLocation & $sCompleteness)
	$sClasses = ""
	$aSearchParamMemory[1][0] = ""
	$Button_Yes = GUICtrlCreateButton("Yes, continue", 8, 50, 193, 33, $WS_GROUP)
	$Button_No = GUICtrlCreateButton("No, go back", 219, 50, 193, 33, $WS_GROUP)
	WinSetOnTop($ConfirmationGUI, "", 1)
	If $aSearchParamMemory[2][0] = 1 Then ;Has to be after GUI window shows in order to make movement of the msgbox less noticeable
		_OkBox(266304, "Important!", "EDMODO ASSIGNMENTS IGNORE THE SET PERCENTAGE AND RETURN LATE/ONTIME ONLY!")
	EndIf
	WinActivate($MainGUI)
	GUISetState(@SW_SHOW, $ConfirmationGUI)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($ConfirmationGUI)
				Return
			Case $Button_Yes
				_ParseEdPuzzleCSV()
			Case $Button_No
				GUIDelete($ConfirmationGUI)
				Return
		EndSwitch
	WEnd
EndFunc   ;==>_ConfirmationGUI

Func _OptionsGUI() ;This GUI allows the user(Mrs. Potter) to change basic settings concerning the operation of LateWork
	ConsoleWrite('@@ (303) :(' & @MIN & ':' & @SEC & ') _OptionsGUI()' & @CR) ;### Function Trace

EndFunc   ;==>_OptionsGUI

Func _AboutGUI() ;This GUI displays information about the developer
	ConsoleWrite('@@ (308) :(' & @MIN & ':' & @SEC & ') _AboutGUI()' & @CR) ;### Function Trace
	Global $AboutGUI = GUICreate("About!", 626, 177, 100, 100)
	_CenterMessageBox($MainGUI, $AboutGUI)
	Global $Label24 = GUICtrlCreateLabel("All code, ideas, and GUI design by: Austen Lage", 139, 24, 347, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	Global $Label70 = GUICtrlCreateLabel("Thank you so much for using my program, I really appreciate it! If you have any questions, comments, or concerns", 30, 101, 564, 19, $SS_CENTER)
	GUICtrlSetColor(-1, 0x000000)
	Global $Button68 = GUICtrlCreateButton("http://github.com/AustenLage", 224, 56, 177, 33)
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetTip(-1, "Go to Austen's GitHub")
	Global $Label1098 = GUICtrlCreateLabel("Please contact me via issue, or pull request on my GitHub! I am also available at austenlage98@hotmail.com", 30, 115, 564, 19, $SS_CENTER)
	GUICtrlSetColor(-1, 0x000000)
	Global $Button198798 = GUICtrlCreateButton("Close", 262, 151, 100, 25)
	GUICtrlSetTip(-1, "Close about window")
	Global $AboutGUI_AccelTable[1][2] = [["{DEL}", $Button68]]
	GUISetAccelerators($AboutGUI_AccelTable)
	WinSetOnTop($AboutGUI, "", 1)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIDelete($AboutGUI)
				Return
			Case $Button68
				ShellExecute("http://github.com/AustenLage/")
			Case $Button198798
				GUIDelete($AboutGUI)
				Return
		EndSwitch
	WEnd
	Return
EndFunc   ;==>_AboutGUI

Func _UserHelpGUI($iHelpInfo, $hHandle) ;This function handles all help requests in the program via a centralized GUI
	ConsoleWrite('@@ (343) :(' & @MIN & ':' & @SEC & ') _UserHelpGUI()' & @CR) ;### Function Trace
	Local $sHelpTitle, $sHelpText

	Switch $iHelpInfo
		Case "Main_Date"
			$sHelpTitle = "selecting a date"
			$sHelpText = ""
		Case "Main_Class"
			$sHelpTitle = "selecting classes"
			$sHelpText = ""
		Case "Main_Location"
			$sHelpTitle = "selecting location(s)"
			$sHelpText = ""
		Case "Main_Percentage"
			$sHelpTitle = "choosing a percentage"
			$sHelpText = ""
		Case Else
			Return 0
	EndSwitch

	$HelpGUI = GUICreate("Help", 393, 117, 100, 100)
	_CenterMessageBox($MainGUI, $HelpGUI)
	$Label_Title = GUICtrlCreateLabel("Help with " & $sHelpTitle & ":", 0, 1, 392, 18, $SS_CENTER)
	GUICtrlSetFont(-1, 14, 800, 0, "Lucida Console")
	GUICtrlSetColor(-1, 0x000000)
	$Label_HelpInfo = GUICtrlCreateLabel($sHelpText, 0, 24, 392, 58, $SS_CENTER)
	GUICtrlSetTip(-1, "CLICK FOR MORE HELP/SUPPORT INFORMATION")
	GUICtrlSetFont(-1, 10, 400, 0, "Lucida Console")
	GUICtrlSetColor(-1, 0x000000)
	$Button_CloseHelp = GUICtrlCreateButton("Close", 156, 94, 81, 17, $WS_GROUP)
	GUICtrlSetFont(-1, 8, 800, 0, "Lucida Console")
	WinSetOnTop($HelpGUI, "", 1)
	GUISetState(@SW_SHOW)
	WinActivate("LateWork")
	WinActivate("Help")

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($HelpGUI)
				Return
			Case $Label_HelpInfo
				_GUIState($HelpGUI, 0)
				_NoHaltMsgBox(266304, "Support", "If your problem or question persists, please contact austenlage98@hotmail.com for further assistance.")
				_CenterMessageBox("Support", $HelpGUI)
				_GUIState($HelpGUI, 1)
			Case $Button_CloseHelp
				GUIDelete($HelpGUI)
				Return
		EndSwitch
	WEnd

EndFunc   ;==>_UserHelpGUI

Func _YesNoBox($iFlag, $sTitle, $sText) ;Creates basic yes/no question GUI based on provided title and text. (created so I can center it on things easily.)
	ConsoleWrite('@@ (399) :(' & @MIN & ':' & @SEC & ') _YesNoBox()' & @CR) ;### Function Trace
	;;RETURNS 6 IF YES IS PRESSED
	;;RETURNS 7 IF NO IS PRESSED
	Local $hParent = WinGetHandle("", "")
	$YesNoGUI = GUICreate($sTitle, 460, 109, 100, 100)
	_CenterMessageBox($hParent, $YesNoGUI)
	$Label_Prompt = GUICtrlCreateLabel($sText, 25, 16, 406, 41, $SS_CENTER)
	$Button_Yes = GUICtrlCreateButton("Yes", 88, 72, 97, 25)
	$Button_No = GUICtrlCreateButton("No", 273, 72, 97, 25)
	WinSetOnTop($YesNoGUI, "", 1)
	GUISetState(@SW_SHOW)


	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($YesNoGUI)
				Return 7
			Case $Button_Yes
				GUIDelete($YesNoGUI)
				Return 6
			Case $Button_No
				GUIDelete($YesNoGUI)
				WinActivate($MainGUI)
				WinActivate($hParent)
				Return 7
		EndSwitch
	WEnd
EndFunc   ;==>_YesNoBox

Func _OkBox($iFlag, $sTitle, $sText)
	$OkGUI = GUICreate($sTitle, 459, 98, 233, 240)
	_CenterMessageBox(WinGetHandle("", ""), $OkGUI)
	$Label_Prompt = GUICtrlCreateLabel($sText, 25, 16, 406, 33, $SS_CENTER)
	$Button_Ok = GUICtrlCreateButton("Ok", 180, 64, 97, 25)
	;-237 = alert icon
	;-278 = info icon
	$Icon_Flag = GUICtrlCreateIcon("C:\Windows\System32\shell32.dll", -278, 8, 16, 33, 33)
	WinSetOnTop($OkGUI, "", 1)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($OkGUI)
				Return
			Case $Button_Ok
				GUIDelete($OkGUI)
				Return
		EndSwitch
	WEnd
EndFunc   ;==>_OkBox


Func _ExitGUI() ;Makes sure the user really wants to quit when they try to close LateWork
	ConsoleWrite('@@ (407) :(' & @MIN & ':' & @SEC & ') _ExitGUI()' & @CR) ;### Function Trace
	$ExitGUI = GUICreate("Are you sure?", 546, 111, 100, 100)
	_CenterMessageBox($MainGUI, $ExitGUI)
	$Label1 = GUICtrlCreateLabel("Are you sure you would like to exit LateWork and lose your current place?", 20, 24, 508, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$Button_Quit = GUICtrlCreateButton("Yes, Quit", 136, 64, 121, 25, $WS_GROUP)
	$Button_Stay = GUICtrlCreateButton("No, Stay", 287, 64, 121, 25, $WS_GROUP)
	WinSetOnTop($ExitGUI, "", 1)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($ExitGUI)
				Return
			Case $Button_Quit
				Exit
			Case $Button_Stay
				GUIDelete($ExitGUI)
				Return
		EndSwitch
	WEnd
EndFunc   ;==>_ExitGUI

#Region Class List Functions
Func _AddList() ;Adds element to list on Classes/Periods GUI
	ConsoleWrite('@@ (434) :(' & @MIN & ':' & @SEC & ') _AddList()' & @CR) ;### Function Trace
	Local $sClass = GUICtrlRead($Combo_ClassPeriod)
	$sLastAddedClass = $sClass
	If $sClass = "Please Select a Class Period to add" Then
		_OkBox(4144, "Oops!", "Please select a class period to add to the list from the dropdown menu!")
		Return
	Else
		GUICtrlSetData($List_SearchList, $sClass)
	EndIf
EndFunc   ;==>_AddList

Func _RemoveList() ;Removes element from list on Classes/Periods GUI
	ConsoleWrite('@@ (447) :(' & @MIN & ':' & @SEC & ') _RemoveList()' & @CR) ;### Function Trace
	Local $sClass = GUICtrlRead($List_SearchList)
	Local $iListPosition = _GUICtrlListBox_GetCaretIndex($List_SearchList)
	If $sClass = "" Then
		_NoHaltMsgBox(4144, "Oops!", "There is no list item selected!")
		_CenterMessageBox("Oops!", $ClassesPeriodsGUI)
	Else
		_GUICtrlListBox_DeleteString($List_SearchList, $iListPosition)
		$aClassListMemory[$iListPosition] = "0"
		Return
	EndIf
EndFunc   ;==>_RemoveList

Func _RememberClassList() ;Remembers the class list by populating the array $aClassListMemory
	ConsoleWrite('@@ (461) :(' & @MIN & ':' & @SEC & ') _RememberClassList()' & @CR) ;### Function Trace
	For $i = 0 To 7
		If _GUICtrlListBox_GetText($List_SearchList, $i) == 0 Then
			$aClassListMemory[$i] = "0"
		Else
			$aClassListMemory[$i] = _GUICtrlListBox_GetText($List_SearchList, $i)
		EndIf
	Next
EndFunc   ;==>_RememberClassList

Func _DeleteClassList() ;Sets all the elements in the $aClassListMemory array to a string containing the number 0
	ConsoleWrite('@@ (472) :(' & @MIN & ':' & @SEC & ') _DeleteClassList()' & @CR) ;### Function Trace
	For $i = 0 To 7
		$aClassListMemory[$i] = "0"
	Next
EndFunc   ;==>_DeleteClassList
#EndRegion Class List Functions

Func _GUIState($bState, $hHandle) ;Allows setting the visibility state in a signle line
	ConsoleWrite('@@ (480) :(' & @MIN & ':' & @SEC & ') _GUIState()' & @CR) ;### Function Trace
	If $bState = 0 Then
		GUISetState(@SW_DISABLE, $hHandle)
	Else
		Local $sGUITitle = WinGetTitle($hHandle)
		GUISetState(@SW_ENABLE, $hHandle)
		WinActivate($sGUITitle)
	EndIf
EndFunc   ;==>_GUIState

Func _GetSearchParams() ;Retrievs the answers to all the questions asked on the main GUI, and organizes the list of selected classes to be displayed on the confirmation GUI.
	ConsoleWrite('@@ (491) :(' & @MIN & ':' & @SEC & ') _GetSearchParams()' & @CR) ;### Function Trace
	;$aSearchParamMemory[$][$]
	;[0][0] = date
	;[1][0](set to true if all classes is selected) or [1][1-8(Depending on how many classes selected)] = class(es)
	;[2][0](1 = BOTH, 2 = EDMODO, 3 = EDPUZZLE) = search location(s)
	;[3][0] = percentage(contains minimum completeness percentage as integer)
	$aSearchParamMemory[0][0] = GUICtrlRead($Date_SearchSince)

	If GUICtrlRead($Radio_AllClasses) = $GUI_CHECKED Then
		$aSearchParamMemory[1][0] = 1
	Else
		For $i = 0 To 7
			$aSearchParamMemory[1][$i + 1] = $aClassListMemory[$i]
		Next
	EndIf

	If GUICtrlRead($Radio_Everywhere) = $GUI_CHECKED Then ;1 = BOTH
		$aSearchParamMemory[2][0] = 1
		$sLocation = "Edmodo and EdPuzzle"
	ElseIf GUICtrlRead($Radio_Edmodo) = $GUI_CHECKED Then ;2 = EDMODO
		$aSearchParamMemory[2][0] = 2
		$sLocation = "Edmodo only"
	ElseIf GUICtrlRead($Radio_EdPuzzle) = $GUI_CHECKED Then ;3 = EDPUZZLE
		$aSearchParamMemory[2][0] = 3
		$sLocation = "Edpuzzle only"
	EndIf

	$aSearchParamMemory[3][0] = GUICtrlRead($Slider_Percentage)

	;;Code below here in this function organizes the list of classes to be displayed on the confirmation GUI and chooses/inserts the correct punctuation
	If $aSearchParamMemory[1][0] == 1 Then
		$sClasses = "all classes. "
	Else
		For $iCount = 1 To 8
			If $aSearchParamMemory[1][$iCount] == "0" Then
				$iCount1 = $iCount - 1
				$iCount2 = $iCount - 2
				For $iCount3 = 0 To $iCount2
					If $iCount3 <> 0 Then
						If $iCount2 <> 1 Then
							$sClasses &= $aSearchParamMemory[1][$iCount3] & ", "
						Else
							$sClasses &= $aSearchParamMemory[1][$iCount3] & " "
						EndIf
					EndIf
				Next
				If $aSearchParamMemory[1][2] == "0" Then
					$sClasses = $aSearchParamMemory[1][1] & ". "
				Else
					$sClasses &= "and " & $aSearchParamMemory[1][$iCount1] & ". "
					Return
				EndIf
			EndIf
		Next
	EndIf
EndFunc   ;==>_GetSearchParams

Func _CenterMessageBox($sTitle, $hGUI) ;Centers any no halt msgbox on any GUI with simple math, because regular msgboxes pause the script they can't be moved(or, centered in our case). The longer the time between creating a NoHaltMsgBox and Centering it with this function, the less smooth the transition will be. Also works to center GUIs on other GUIs by passing the parent handle as $sTitle and the child handle as $hGUI
	ConsoleWrite('@@ (549) :(' & @MIN & ':' & @SEC & ') _CenterMessageBox()' & @CR) ;### Function Trace
	If IsString($sTitle) = 1 Then
		Local $aPos = WinGetPos($hGUI)
		Local $aSizeParent = WinGetClientSize($hGUI)
		Local $aSizeChild = WinGetClientSize($sTitle)
	Else
		Local $aPos = WinGetPos($sTitle)
		Local $aSizeParent = WinGetClientSize($sTitle)
		Local $aSizeChild = WinGetClientSize($hGUI)
	EndIf
	Local $iParentWidth = $aSizeParent[0]
	Local $iParentHeight = $aSizeParent[1]
	Local $iChildWidth = $aSizeChild[0]
	Local $iChildHeight = $aSizeChild[1]

	If $iParentWidth < $iChildWidth Then
		Local $iFinalX = $aPos[0] - ($iChildWidth - $iParentWidth) / 2
	Else
		Local $iFinalX = $aPos[0] + ($iParentWidth - $iChildWidth) / 2
	EndIf

	If $iParentHeight < $iChildHeight Then
		Local $iFinalY = $aPos[1] - ($iChildHeight - $iParentHeight) / 2
	Else
		Local $iFinalY = $aPos[1] - ($iChildHeight - $iParentHeight) / 2
	EndIf

	If IsString($sTitle) = 1 Then
		WinMove($sTitle, "", $iFinalX, $iFinalY)
	Else
		WinMove($hGUI, "", $iFinalX, $iFinalY)
	EndIf
EndFunc   ;==>_CenterMessageBox

Func _NoHaltMsgBox($flags = 0, $sTitle = "", $sText = "", $iTimeout = 0) ;Creates a regular msgbox that does not halt the script, but makes sure duplicate msgboxes can't be opened by mistake(as long as the msgbox is not hidden by WinSetState())
	ConsoleWrite('@@ (574) :(' & @MIN & ':' & @SEC & ') _NoHaltMsgBox()' & @CR) ;### Function Trace
	If WinExists($sTitle, $sText) = 0 Then
		Run(@AutoItExe & ' /AutoIt3ExecuteLine  "MsgBox(' & $flags & ', ''' & $sTitle & ''', ''' & $sText & ''',' & $iTimeout & ')"')
		Sleep(100)
	Else
		Return
	EndIf
EndFunc   ;==>_NoHaltMsgBox

Func _ParseEdPuzzleCSV() ;Reads and separates elements of files that EdPuzzle outputs (in the form of .csv) into an array dynamically based on the number of files
	ConsoleWrite('@@ (584) :(' & @MIN & ':' & @SEC & ') _ParseEdPuzzleCSV()' & @CR) ;### Function Trace

EndFunc   ;==>_ParseEdPuzzleCSV

Func _ParseEdmodoExcel() ;Reads and separates the elements of files that Edmodo outputs (in the form of Microsoft Ecxel Worksheets) into an array dynamically based on the number of files
	ConsoleWrite('@@ (594) :(' & @MIN & ':' & @SEC & ') _ParseEdmodoExcelToCSV()' & @CR) ;### Function Trace

EndFunc   ;==>_ParseEdmodoExcel

Func _ParseDistrictNamesCSV()
	ConsoleWrite('@@ (599) :(' & @MIN & ':' & @SEC & ') _ParseDistrictNamesCSV()' & @CR) ;### Function Trace

EndFunc   ;==>_ParseDistrictNamesCSV



