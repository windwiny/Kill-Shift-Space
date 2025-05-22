#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent
#SingleInstance force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
 

;; F1 依次复制多个内容到暂存区，
;; F2逐个取出一条内容并粘贴，
;; F3放回已取出内容
;; F4将暂存区复制的条目顺序反转
;; Tab 一键显示/隐藏 Tooltip 避免其霸屏 （2023-02-17 新增）

 
Menu, Tray, Tip, F1连续复制 F2顺序粘贴  F4 反转剪贴板中的顺序 ;实现悬停图标出提示
Menu, Tray, Add, 我的程序, menu_show  ;创建菜单项
;~ Menu, Tray, Toggleenable, 我的程序  ;标题行不让其响应点击动作
menu, tray, add, 禁用
 
 
Menu, Tray, Default, 我的程序 ;增加默认动作，能响应托盘点击事件，必须有此项
Menu, Tray, Add
 
;创建子菜单
Menu, mainmenu, Add
Menu, mainmenu, Add, R、刷新, menu_reload
Menu, mainmenu, Default, R、刷新
 ;加载子菜单
Menu, Tray, Add, 程序(&Q), :mainmenu
 
Menu, Tray, Add
Menu, Tray, Add, 帮助(&H), Tray_help
Menu, Tray, Add, 重启(&R), menu_reload
Menu, Tray, Add, 退出(&X), Tray_close
Menu, Tray, NoStandard
Menu, Tray, Click, 1  ;实现单击托盘图标显示菜单，否则需要双击的
TrayTip, 我的程序 is Ready !, %A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min% %A_DDDD%
flag:=1
return
 
;复制
f1::
    CBData.Copy()
return
;粘贴
f2::
    CBData.Paste()
return
;将粘贴用过的内容重新放到剪贴板
f3::
    CBData.Redo()
return
;逆序
F4::
    CBData.List:=CBData.List.reverse()
    CBData.Show()
return
我的程序:
 
    Menu, mainmenu, Show
 
;~ menu, tray, ToggleEnable, TestToggleEnable
Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
禁用:
menu, tray, ToggleCheck, 禁用
menu, tray, ToggleEnable, 我的程序 ; 同时启用了下一行的测试, 因为它不能撤销自己的禁用状态.
Suspend,toggle
 
return
 
 
 
;点击托盘图标会响应
menu_show:
Menu, Tray, Show
 
Return
menu_reload:
Reload
Return
runmenu:
runfile := file_%a_thismenuitempos%
Run, %runfile%
Return
runsubmenu:
runfile := file_%a_thismenu%_%a_thismenuitempos%
Run, %runfile%
Return
Tray_close:
ExitApp
Return
Tray_help:
MsgBox, Alt+Q 呼出程序列表`n快捷方式图标放置于Shortcut文件夹内`nShortcht内文件夹可随意安排`n根目录快捷方式在Auto下
return
$!q::Goto 我的程序
tab::
if WinExist("ahk_class tooltips_class32")
   Tooltip
else
   CBData.Show()
Return
Class CBData
{
    Static List:= []
    Static Recycle := []
 
    Copy()
    {
        CB := ClipboardAll
        Clipboard := ""
        SendInput, ^{Ins} ;^{vk43sc02E} ;ctrl+c
        ClipWait,% 1, 1
        If !Errorlevel
            this.List.Insert(Clipboard)
        Clipboard := CB
        this.Show()
    }
 
    Paste()
    {
        msg := this.List[this.List.MinIndex()]
        If strlen(msg)
        {
            CB := ClipboardAll
            Clipboard := msg
            SendInput, ^v
            this.List.Remove(1)
            this.Recycle.Insert(msg)
        }
        this.Show()
    }
 
    Redo()
    {
        msg := this.Recycle[this.Recycle.MaxIndex()]
        If strlen(msg)
        {
            this.List.InsertAt(1,msg)
            this.Recycle.Remove()
        }
        this.Show()
    }
 
    Show()
    {
        Loop % this.List.MaxIndex()
        {
            msg .= "#" A_Index " | `t" this.List[A_Index] "`n"
        }
        Tooltip % msg
    }
 
}
 
 
Array(p*){
	p.base := Object("join", "Array_Join", "reverse", "Array_Reverse")
	Return p
}
 
Array_Join(this, sep="`n"){
	Loop, % this.maxindex()
		str .= this[A_Index] sep
	StringTrimRight, str, str, % StrLen(sep)
	return str
}
 
Array_Reverse(arr) {
	arr2 := Array()
	Loop, % len:=arr.maxindex()
    {
		arr2[len-(A_Index-1)] := arr[A_Index]
    }
	Return arr2
}

