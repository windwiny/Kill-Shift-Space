#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.





#w:: ;;这里的 #->表示window键 w->表示字母w键 小面板
;#WinMinimize,A ;;最小化当前窗口
return ;;结束代码段
#f:: ;;发送反馈win11
;#WinMinimize,A ;;最小化当前窗口
return ;;结束代码段



; win11 ime input Full/half space 禁用输入法全半角切换
<+space::
send , {space}
return
;


; ; win11 Shift-Alt switch input keyboard layout
; <+Alt::
; return
; ;

; <!Shift::
; return
; ;

; win11 Ctrl-Shift switch ime 禁用切换输入法
<^Shift::
return
;

; <+Ctrl::
; return
; ;


^!a::
send , {F1}
return
;
