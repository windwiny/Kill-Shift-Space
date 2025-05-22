#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.


;;     符号	说明
;;     #	window键
;;     !	alt键
;;     ^	ctrl键
;;     +	shift键
;;     <	有两个相同键时,表示左边那个键.比如alt有左右两个键,<! 表示左alt键
;;     >	表示相同键中右边的那个键
;;     LButton	鼠标左键
;;     RButton	鼠标右键
;;     MButton	鼠标中间键
;;     WheelDown	滚轮向下
;;     WheelUp	滚轮向上
;;     Backspace	退格键
;;     CapsLock	大小写切换键
;;     Escape	退出键


#w:: 	;; win11小面板    # -> 表示window键 w->表示字母w键
;#WinMinimize,A ;;最小化当前窗口
return

#f:: 	;; win11 发送反馈
;;send , ^!+s   ;; 设置失败
return

;;    设置失败
#g:: 	;; win11 gamebar
return

#v:: 	;; win11 super paste ,  use ditto
return


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

; ; win11 Ctrl-Shift switch ime 禁用切换输入法   会影响 其它快捷键 如终端里查找
; <^Shift::
; return
; ;

; <+Ctrl::
; return
; ;


; ^!a::
; send , {F1}
; return
; ;



#F1::
 return

