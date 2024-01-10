#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; ; hKbdHook := DllCall("SetWindowsHookEx", "int", 13 ; WH_KEYBOARD_LL
; ;         , "uint", RegisterCallback("LowLevelKeyboardProc"), "uint", 0, "uint",0)
; TrayTip,OnRuns
; OnExit, UnhookKeyboardAndExit

; Return

; UnhookKeyboardAndExit:
;     ; DllCall("UnhookWindowsHookEx", "uint", hKbdHook)
;     TrayTip,OnExit
; ExitApp
; return

TrayTip,rrr

<+Ctrl::
TrayTip,LCttxxx
return
;

LCtrl::

TrayTip,LCtt
Return
