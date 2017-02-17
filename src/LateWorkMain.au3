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

_MainGUI()

Func _MainGUI()
	#Region MAINGUI
	$Form1 = GUICreate("LateWork", 691, 183, 598, 398)
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
	$Radio5 = GUICtrlCreateRadio("[FORGOT NAME] only", 501, 104, 153, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUIStartGroup()
	$Label5 = GUICtrlCreateLabel("What percentage of completeness warrants a missing assignment?", 24, 131, 401, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$Label6 = GUICtrlCreateLabel("0%", 426, 132, 20, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Label7 = GUICtrlCreateLabel("100%", 599, 130, 34, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Slider1 = GUICtrlCreateSlider(441, 130, 161, 17, BitOR($TBS_AUTOTICKS, $TBS_TOP, $TBS_LEFT))
	GUICtrlSetTip(-1, "EDMODO CAN ONLY TELL IF SOMETHING IS MISSING")
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

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit

		EndSwitch
	WEnd
EndFunc   ;==>_MainGUI
