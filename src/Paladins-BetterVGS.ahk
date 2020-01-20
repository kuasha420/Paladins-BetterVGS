/*
 * Name: Paladins-BetterVGS
 * Description: Brings back old VGS commands from Paladins 2.x.
 * Version: 0.0.1
 * Author: Arafat Zahan
 * License: MIT
*/
;@Ahk2Exe-SetName Paladins-BetterVGS
;@Ahk2Exe-SetDescription Brings back old VGS commands from Paladins 2.x.
;@Ahk2Exe-SetVersion 0.0.1
;@Ahk2Exe-SetCopyright Copyright (c) 2020`, Arafat Zahan
;@Ahk2Exe-SetOrigFilename Paladins-BetterVGS.ahk

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

Menu, Tray, Icon, icon.ico

VgsCmdList := IniGetKeys("vgs.ini", "VgsList" , ",")

if WinExist("ahk_exe Paladins.exe") {
	WinActivate, ahk_exe Paladins.exe
}
    
else {
	Run, steam://rungameid/444090
}

$Enter::
	if InGame() {
		Hotkey, $v, Toggle
	}
	Send {enter}
return

$v::
	if !InGame() {
		Send v
		return
	}
	Hotkey, $v, Off
	Input, command, L3, {enter}.{esc}{tab}{backspace}, %VgsCmdList%
	if (ErrorLevel != "Match") {
		Hotkey, $v, On
		return
	}
	IniRead, VgsCmd, vgs.ini, VgsList, %command%
	Hotkey, $v, On
	Send %VgsCmd%
return

InGame() {
	if WinActive("ahk_exe Paladins.exe") {
		WinGetPos, X, Y, Width, Height, ahk_exe Paladins.exe
		; These values are suitable for 16:9 screen ratio. Tested on 1928x1080, 1280x720
		SearchStartX := Width-Floor(Width*7.3/100) ; 1780
		SearchStartY := Floor(Height*2.8/100) ; 30
		SearchStopX := Width-Floor(Width*3.65/100) ; 1850
		SearchStopY := Floor(Height*5.6/100) ; 60
		SearchColor = 0xffffff
		Delta = 5
		PixelSearch, Px, Py, %SearchStartX%, %SearchStartY%, %SearchStopX%, %SearchStopY%, %SearchColor%, %Delta%, Fast RGB
		if ErrorLevel {
			return 1
		} else {
			return 0
		}
			
	} else {
		return 0
	}
}

; Credit to freakkk from: autohotkey forums
; https//autohotkey.com/board/topic/6558-ini-getting-all-keys-in-one-section/?p=39765
IniGetKeys(InputFile, Section , Delimiter="")
{
	Loop, Read, %InputFile%
	{
		If SectionMatch=1
		{
			If A_LoopReadLine=
				Continue
			StringLeft, SectionCheck , A_LoopReadLine, 1
			If SectionCheck <> [
			{
				StringSplit, KeyArray, A_LoopReadLine , =
				If KEYSlist=
					KEYSlist=%KeyArray1%
				Else
					KEYSlist=%KEYSlist%%Delimiter%%KeyArray1%
			}
			Else
				SectionMatch=
		}
		If A_LoopReadLine=[%Section%]
			SectionMatch=1
	}
	return KEYSlist
}