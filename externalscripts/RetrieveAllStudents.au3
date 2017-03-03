#include <File.au3>
#include <Array.au3>
#include <String.au3>
#include <Date.au3>

Global $aFile, $sAllStudentsRaw, $aAllStudentsParsed[1][1], $aSingleStudentRaw[5], $iProgressValue, $iCount, $iCount1, $hTimer, $iStudentNumEnd, $iStudentNumStart, $aSingleStudentFirstName, $aSingleStudentMidName, $aSingleStudentLastName, $sFirstName, $sMidName, $sLastName, $sSecFirstName

HotKeySet("{ESC}", "_Exit")

$hFile = FileOpen(@DesktopDir & "\udetails.txt")

$sAllStudentsRaw = FileRead($hFile)

$aAllStudentsParsed[0][0] = "null"

$iCount = 0

$iStudentNumStart = InputBox("Start", "Student number to start looking at " & " (>=" & (@YEAR - 2001) * 1000 & ")")
$iStudentNumEnd = InputBox("End", "Student number to stop looking at (<=30000)")

If $iStudentNumStart >= $iStudentNumEnd Then
	MsgBox(0, "CRITICAL INTERNAL ERROR!", "$iStudentNumStart CAN'T BE >= $iStudentNumEnd!")
	Exit
ElseIf $iStudentNumStart < (@YEAR - 2001) * 1000 Then
	MsgBox(0, "CRITICAL INPUT ERROR!", "CAN'T SEARCH FOR GRADUATES BEFORE " & @YEAR - 1 & " (" & (@YEAR - 2001) * 1000 & " AND UP!)")
	Exit
ElseIf $iStudentNumEnd > 30000 Then
	MsgBox(0, "CRITICAL INPUT ERROR!", "CAN'T SEARCH FOR GRADUATES AFTER 2030")
	Exit
EndIf

$hTimer = TimerInit()

$iProgressIncrement = 1 / ($iStudentNumEnd - $iStudentNumStart)
$iProgressValue = $iProgressIncrement

ProgressOn("PROGRESS(HIT ESCAPE TO CLOSE)", "RETRIEVING MCUSD185 STUDENTS!")

For $i = $iStudentNumStart To $iStudentNumEnd
	$aSingleStudentRaw = _StringBetween($sAllStudentsRaw, $i & "@mcusd185.org ", " (" & $i & ") ", 1)
	$iProgressValue += $iProgressIncrement
	$iProgressValue1 = $iProgressValue * 100

	If @error <> 0 Then
		Local $aSingleStudentRaw[500]
		$aSingleStudentRaw[0] = ""
		If Mod($i, 10) = 0 Then
			ProgressSet($iProgressValue1, Round($iProgressValue1) & "%" & " - " & "NO STUDENT FOUND @ " & $i)
		EndIf
		If Mod($i, 100) = 0 Then
			ConsoleWrite("No names found, still looking..." & @CRLF)
		EndIf
	EndIf

	If @error = 0 And StringLen($aSingleStudentRaw[0]) > 3 And StringLen($aSingleStudentRaw[0]) < 41 Then
		$iCount += 1
		ReDim $aAllStudentsParsed[$iCount + 1][2]
		$aAllStudentsParsed[$iCount][0] = $aSingleStudentRaw[0]
		$aAllStudentsParsed[$iCount][1] = $i
		ProgressSet($iProgressValue1, Round($iProgressValue1) & "%" & " - " & "STUDENT FOUND @ " & $i & "(" & $aAllStudentsParsed[$iCount][0] & ")")
		ConsoleWrite("STUDENT FOUND @ " & $i & "(" & $aAllStudentsParsed[$iCount][0] & ")" & @CRLF)
		$aAllStudentsParsed[$iCount][0] = "-" & $aSingleStudentRaw[0] & " "
	EndIf
Next

Sleep(1000)

Global $aAllStudentsParsedFinal[UBound($aAllStudentsParsed, 1)][6]
$iProgressIncrement = 1 / UBound($aAllStudentsParsed)
$iProgressValue = $iProgressIncrement

For $i = 1 To UBound($aAllStudentsParsed) - 1
	$iProgressValue += $iProgressIncrement
	$iProgressValue1 = $iProgressValue * 100

	$aSingleStudentFirstName = _StringBetween($aAllStudentsParsed[$i][0], ", ", " ")
	$sFirstName = _ArrayToString($aSingleStudentFirstName, "")
	$aAllStudentsParsedFinal[$i][0] = $sFirstName

	$aSingleStudentLastName = _StringBetween($aAllStudentsParsed[$i][0], "-", ",")
	$sLastName = _ArrayToString($aSingleStudentLastName, "")
	$aAllStudentsParsedFinal[$i][2] = $sLastName

	$aSingleStudentMidName = _StringBetween($aAllStudentsParsed[$i][0], $sFirstName & " ", ". ")
	$sMidName = _ArrayToString($aSingleStudentMidName, "")
	If $sMidName <> -1 And StringLen($sMidName) = 1 Then
		$aAllStudentsParsedFinal[$i][1] = $sMidName
	ElseIf $sMidName = -1 Then
		$aAllStudentsParsedFinal[$i][1] = "*"
	ElseIf $sMidName <> -1 And StringLen($sMidName) > 1 Then ;RE-PARSE MIDDLE NAME AND FIRST NAME CORRECTLTY FOR PEOPLE WITH A FIRST NAME WITH A SPACE IN IT
		ConsoleWrite("KID WITH SPACE IN HIS FIRST NAME! " & $sMidName & @CRLF)
		$aSingleStudentMidName = StringSplit($sMidName, " ", 2)
		$sMidName = $aSingleStudentMidName[1]
		$aAllStudentsParsedFinal[$i][1] = $sMidName
		$aSingleStudentFirstName = _StringBetween($aAllStudentsParsed[$i][0], $sFirstName & " ", " " & $sMidName & ".")
		$sSecFirstName = _ArrayToString($aSingleStudentFirstName, "")
		$sFirstName &= " " & $sSecFirstName
		$aAllStudentsParsedFinal[$i][0] = $sFirstName
	EndIf

	$aAllStudentsParsedFinal[$i][3] = $aAllStudentsParsed[$i][1]

	ProgressSet($iProgressValue1, Round($iProgressValue1) & "%" & " - " & "Parsing Student #" & $aAllStudentsParsed[$i][1])
	Sleep(10)
Next

ProgressOff()

$aAllStudentsParsedFinal[0][4] = "[" & UBound($aAllStudentsParsedFinal) - 1 & "](TOTAL NAMES FOUND)"
$aAllStudentsParsedFinal[0][0] = "First Name"
$aAllStudentsParsedFinal[0][1] = "Middle Initial"
$aAllStudentsParsedFinal[0][2] = "Last Name"
$aAllStudentsParsedFinal[0][3] = "STUDENT #"
$aAllStudentsParsedFinal[0][5] = "GENERATED ON " & "[" &  _NowDate() & "]" & " @ " & "[" & _NowTime() & "]"

MsgBox(0, "INFO", "IT TOOK " & Round((TimerDiff($hTimer) / 1000) / 60, 1) & " MINUTES TO GENERATE THE LIST, IT WILL NOW BE DISPLAYED.")

_ArrayDisplay($aAllStudentsParsedFinal)

_FileWriteFromArray(@DesktopDir & "\mjshsstudents.csv", $aAllStudentsParsedFinal, Default, Default, ",")

Func _Exit()
	Exit
EndFunc   ;==>_Exit
