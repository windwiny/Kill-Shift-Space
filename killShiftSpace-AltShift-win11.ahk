﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; win11  wubi input Full/half space
<+space::
return
;


; win11 Shift-Alt switch input keyboard layout
<+Alt::
return
;

<!Shift::
return
;

; ; win11 Ctrl-Shift switch ime
; <^Shift::
; return
; ;

<+Ctrl::
return
;