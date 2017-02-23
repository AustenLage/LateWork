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

Global $bPrompt1 = 0

_MainGUI()

Func _MainGUI()
	#Region MAINGUI
	$MainGUI = GUICreate("LateWork", 691, 183, 598, 398)
	$Button1 = GUICtrlCreateButton("Options", 561, 158, 65, 25, $WS_GROUP)
	$Button2 = GUICtrlCreateButton("About?", 625, 158, 65, 25, $WS_GROUP)
	$Date1 = GUICtrlCreateDate("2017/02/16 16:25:27", 199, 48, 281, 21)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Label1 = GUICtrlCreateLabel("Check for late/incomplete work:", 2, 16, 262, 21)
	GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
	$Label2 = GUICtrlCreateLabel("Check for assignments since", 24, 50, 174, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$Label3 = GUICtrlCreateLabel("What classes/periods would you like me to look in?", 24, 77, 307, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	GUIStartGroup()
	$Radio1 = GUICtrlCreateRadio("All classes/periods", 330, 77, 129, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Radio2 = GUICtrlCreateRadio("Specific classes/periods (PROMPT)", 463, 77, 225, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUIStartGroup()
	$Label4 = GUICtrlCreateLabel("Where should I check for missing assignments?", 24, 104, 285, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	GUIStartGroup()
	$Radio3 = GUICtrlCreateRadio("Everywhere", 312, 104, 89, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Radio4 = GUICtrlCreateRadio("Edmodo only", 404, 104, 97, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Radio5 = GUICtrlCreateRadio("EdPuzzle only", 501, 104, 153, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUIStartGroup()
	$Label5 = GUICtrlCreateLabel("What percentage of completeness warrants a missing assignment?", 24, 131, 401, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$Label6 = GUICtrlCreateLabel("0%", 426, 132, 20, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Label7 = GUICtrlCreateLabel("100%", 599, 130, 34, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Slider1 = GUICtrlCreateSlider(441, 130, 161, 17, BitOR($TBS_AUTOTICKS, $TBS_TOP, $TBS_LEFT))
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
				If MsgBox(4 + 4096, "Quit?", "Are you sure you would like to exit LateWork and lose your current place?") = 6 Then
					Exit
				EndIf
			Case $Radio1 ;All Classes/Periods radio
				If $bPrompt1 = 1 Then
					GUICtrlSetState($Radio2, $GUI_CHECKED)
					GUISetState(@SW_DISABLE)
					If MsgBox(4 + 4096, "Are you sure?", "Are you sure you would like to erase your previously selected classes/periods?") = 6 Then
						$bPrompt1 = 0
						GUICtrlSetState($Radio1, $GUI_CHECKED)
					EndIf
					GUISetState(@SW_ENABLE)
					WinActivate("LateWork")
				EndIf
			Case $Radio2 ;Specific classes/periods radio (prompt for details)
				GUISetState(@SW_DISABLE)
				If $bPrompt1 = 0 Then
					$bPrompt1 = 1
					_ClassesPeriodsGUI()
				Else
					If MsgBox(4 + 4096, "Make Changes?", "Would you like to edit the classes/periods you previously selected?") = 6 Then
						WinActivate("LateWork")
						_ClassesPeriodsGUI()
					EndIf
				EndIf
				GUISetState(@SW_ENABLE)
				WinActivate("LateWork")
			Case $Button3 ;Date help button
				GUISetState(@SW_DISABLE)
				_UserHelp("Date")
				GUISetState(@SW_ENABLE)
				WinActivate("LateWork")
			Case $Button4 ;Class period help button
				GUISetState(@SW_DISABLE)
				_UserHelp("Class")
				GUISetState(@SW_ENABLE)
				WinActivate("LateWork")
			Case $Button5 ;Search location help button
				GUISetState(@SW_DISABLE)
				_UserHelp("Location")
				GUISetState(@SW_ENABLE)
				WinActivate("LateWork")
			Case $Button6 ;Percentage Help button
				GUISetState(@SW_DISABLE)
				_UserHelp("Percentage")
				GUISetState(@SW_ENABLE)
				WinActivate("LateWork")
			Case $Button7 ;Continue Button
				MsgBox(0, "debug", $bPrompt1) ;DEBUGGING
		EndSwitch
		If GUICtrlRead($Label8) <> GUICtrlRead($Slider1 & "%") Then ;
			GUICtrlSetData($Label8, GUICtrlRead($Slider1) & "%") ;Sets live slider value at bottom of slider
		EndIf ;
	WEnd
	#EndRegion MainGUIWhileLoop
EndFunc   ;==>_MainGUI

Func _ClassesPeriodsGUI()
	#Region Classes/PeriodsGUI
	$ClassesPeriodsGUI = GUICreate("Classes/Periods Selection", 322, 314, 258, 223)
	$Combo_ClassPeriod = GUICtrlCreateCombo("Please Select a Class Period to add", 48, 16, 225, 25)
	$Button_AddList = GUICtrlCreateButton("ADD TO LIST", 96, 42, 129, 41, $WS_GROUP)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetTip(-1, "Add above slected period to the search list")
	$List_SearchList = GUICtrlCreateList("", 48, 88, 225, 175)
	$Button_RemoveList = GUICtrlCreateButton("REMOVE SELECTED", 96, 267, 129, 41, $WS_GROUP)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetTip(-1, "Add above slected period to the search list")
	GUISetState(@SW_SHOW)
	#EndRegion Classes/PeriodsGUI

	#Region Classes/PeriodsGUIWhileLoop
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($ClassesPeriodsGUI)
				Return
			Case $Button_RemoveList
		EndSwitch
	WEnd
	#EndRegion Classes/PeriodsGUIWhileLoop
EndFunc   ;==>_ClassesPeriodsGUI

Func _UserHelp($iHelpInfo)
	#Region UserHelp
	Switch $iHelpInfo
		Case "Date"
			MsgBox(0, "placeholder", "Date help")
		Case "Class"
			MsgBox(0, "placeholder", "Class help")
		Case "Location"
			MsgBox(0, "placeholder", "Location help")
		Case "Percentage"
			MsgBox(0, "placeholder", "Percentage help")
		Case Else
			Return
	EndSwitch
	#EndRegion UserHelp
EndFunc   ;==>_UserHelp
