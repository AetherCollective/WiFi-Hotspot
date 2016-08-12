#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\ISN AutoIt Studio\autoitstudioicon.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <AutoItConstants.au3>
#include <Array.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
Global $sOutput, $bWiFiState, $sSSID
Switch StringRight(@OSLang, 2)
	Case "09"
		Global $sWinTitle = "WiFi-Hotspot"
		Global $sStartCommand = " /c netsh wlan start hostednetwork"
		Global $sStopCommand = " /c netsh wlan stop hostednetwork"
		Global $sShowSettingsCommand = " /c netsh wlan show hostednetwork"
		Global $sChangeSSIDCommand = " /c netsh wlan set hostednetwork ssid="
		Global $sChangePassCommand = " /c netsh wlan set hostednetwork key="
		Global $sEnableHostedNetworkCommand = " /c netsh wlan set hostednetwork mode=allow"
		Global $sCheckStart = "The hosted network started."
		Global $sCheckStop = "The hosted network stopped."
		Global $sCheckEnabled = "The hosted network mode has been set to allow."
		Global $sCheckSSID = "The SSID of the hosted network has been successfully changed."
		Global $sCheckPass = "The user key passphrase of the hosted network has been successfully changed."
		Global $sErrorStart = "An error occured trying to "
		Global $sErrorEnd = " the WiFi-Hotspot."
		Global $sStart = "Start"
		Global $sStop = "Stop"
		Global $sGet = "get the current settings of"
		Global $sEnableHostedNetwork = "enable"
		Global $sEnableHostedNetworkExtended = " Your WiFi may not support this feature."
		Global $sStatus = "Status : "
		Global $sIsStarted = "Started"
		Global $sIsStopped = "Not started"
		Global $sConfigure = "Configure"
		Global $sExit = "Exit"
		Global $sSSIDLen = "Wifi Name must be between 1 and 32 character long."
		Global $sPassLen = "Password must be between 8 and 63 character long."
		Global $sApplied = "Your settings have been saved. You will need to restart the WiFi Hotspot to use the new settings."
	Case Else
		MsgBox($MB_ICONINFORMATION, "WiFi-Hotspot", "This software will only run properly if you language is English - United States. Please ask how you can provide translations at BetaLeaf@gmail.com")
EndSwitch
_GetSettings()

#Region ### START Koda GUI section ### Form=
$hWinTitle = GUICreate($sWinTitle, 130, 109, -1, -1, $WS_CAPTION)
If $bWiFiState = True Then
	$hWiFiState = GUICtrlCreateLabel($sStatus & $sIsStarted, 0, 0, 130)
Else
	$hWiFiState = GUICtrlCreateLabel($sStatus & $sIsStopped, 0, 0, 130)
EndIf
$hStart = GUICtrlCreateButton($sStart, 0, 12, 130, 25)
$hStop = GUICtrlCreateButton($sStop, 0, 36, 130, 25)
$hConfigure = GUICtrlCreateButton($sConfigure, 0, 60, 130, 25)
$hExit = GUICtrlCreateButton($sExit, 0, 84, 130, 25)
GUISetState(@SW_SHOW, $hWinTitle)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $hStart
			GUICtrlSetState($hStart, $GUI_DISABLE)
			$pid = Run(@ComSpec & $sStartCommand, "", @SW_HIDE, $STDOUT_CHILD)
			If _Error($pid, $sCheckStart) = True Then
				MsgBox($MB_ICONERROR, $sWinTitle, $sErrorStart & $sStart & $sErrorEnd)
			Else
				GUICtrlSetData($hWiFiState, $sStatus & $sIsStarted)
			EndIf
			GUICtrlSetState($hStart, $GUI_ENABLE)
		Case $hStop
			GUICtrlSetState($hStop, $GUI_DISABLE)
			$pid = Run(@ComSpec & $sStopCommand, "", @SW_HIDE, $STDOUT_CHILD)
			If _Error($pid, $sCheckStop) = True Then
				MsgBox($MB_ICONERROR, $sWinTitle, $sErrorStart & $sStop & $sErrorEnd)
			Else
				GUICtrlSetData($hWiFiState, $sStatus & $sIsStopped)
			EndIf
			GUICtrlSetState($hStop, $GUI_ENABLE)
		Case $hConfigure

			#Region ### START Koda GUI section ### Form=
			$hConfig = GUICreate($sWinTitle & " - " & $sConfigure, 428, 84, -1, -1)
			$hSSID = GUICtrlCreateLabel("WiFi Name", 4, 8, 56, 17)
			$sInputSSID = GUICtrlCreateInput($sSSID, 64, 4, 360, 21)
			GUICtrlSetLimit($sInputSSID, 32)
			$hPass = GUICtrlCreateLabel("Password", 4, 32, 50, 17)
			$sInputPass = GUICtrlCreateInput("", 64, 30, 360, 21, $ES_PASSWORD)
			GUICtrlSetLimit($sInputSSID, 63)
			$hOk = GUICtrlCreateButton("Ok", 4, 56, 420, 25)
			GUISetState(@SW_SHOW, $hConfig)
			#EndRegion ### END Koda GUI section ###

			While 1
				$nMsg = GUIGetMsg()
				Switch $nMsg
					Case $GUI_EVENT_CLOSE
						GUIDelete($hConfig)
						ExitLoop
					Case $hOk
						$sISSID = GUICtrlRead($sInputSSID)
						$sIPass = GUICtrlRead($sInputPass)
						Select
							Case StringLen($sISSID) < 1
								MsgBox($MB_ICONWARNING, $sWinTitle, $sSSIDLen)
							Case StringLen($sIPass) < 1
								MsgBox($MB_ICONWARNING, $sWinTitle, $sPassLen)
							Case Else
								GUICtrlSetState($hOk, $GUI_DISABLE)
								$pid = Run(@ComSpec & $sEnableHostedNetworkCommand, "", @SW_HIDE, $STDOUT_CHILD)
								If _Error($pid, $sCheckEnabled) = True Then
									MsgBox(16, $sWinTitle, $sErrorStart & $sEnableHostedNetwork & $sErrorEnd & $sEnableHostedNetworkExtended)
									ContinueCase
								EndIf
								$pid = Run(@ComSpec & $sChangeSSIDCommand & '"' & $sISSID & '"', "", @SW_HIDE, $STDOUT_CHILD)
								If _Error($pid, $sCheckSSID) = True Then
									MsgBox($MB_ICONERROR, $sWinTitle, $sErrorStart & $sConfigure & $sErrorEnd)
									ContinueCase
								Else
									$sSSID = $sISSID
								EndIf
								$pid = Run(@ComSpec & $sChangePassCommand & '"' & $sIPass & '"', "", @SW_HIDE, $STDOUT_CHILD)
								GUICtrlSetState($hOk, $GUI_ENABLE)
								If _Error($pid, $sCheckPass) = True Then
									MsgBox($MB_ICONERROR, $sWinTitle, $sErrorStart & $sConfigure & $sErrorEnd)
									ContinueCase
								Else
									MsgBox($MB_ICONINFORMATION, $sWinTitle, $sApplied)
									GUIDelete($hConfig)
									ExitLoop
								EndIf
						EndSelect
				EndSwitch
			WEnd
		Case $hExit
			Exit
	EndSwitch
WEnd

Func _Error(ByRef $pid, $sExpectedOutput = "")
	ProcessWaitClose($pid)
	$sOutput = StdoutRead($pid)
	ConsoleWrite("Expecting:" & @CRLF & $sExpectedOutput & @CRLF & "Received:" & @CRLF & $sOutput & @CRLF & @CRLF)
	$iRet = StringInStr($sOutput, $sExpectedOutput)
	If $sExpectedOutput <> "" And $iRet = 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_Error

Func _GetSettings()
	$pid = Run(@ComSpec & $sShowSettingsCommand, "", @SW_HIDE, $STDOUT_CHILD)
	If _Error($pid) = True Then
		MsgBox($MB_ICONERROR, $sWinTitle, $sErrorStart & $sGet & $sErrorEnd)
	Else
		$sSettings = StringStripWS($sOutput, 4)
		$aSettings = StringSplit(StringStripWS($sOutput, 4), @CRLF)
		Select
			Case StringInStr($aSettings[7], $sIsStarted, 1) > 0
				$bWiFiState = True
			Case StringInStr($aSettings[7], $sIsStopped, 1) > 0
				$bWiFiState = False
			Case @error
				MsgBox($MB_ICONERROR, $sWinTitle, $sErrorStart & $sGet & $sErrorEnd)
			Case Else
				MsgBox($MB_ICONERROR, $sWinTitle, $sErrorStart & $sGet & $sErrorEnd)
		EndSelect
		$sRet = StringReplace($aSettings[3], '"', "")
		$aRet = StringSplit($sRet, ":", 2)
		$sSSID = StringTrimLeft($aRet[1], 1)
	EndIf
EndFunc   ;==>_GetSettings
