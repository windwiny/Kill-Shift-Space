; We could install and uninstall the hook as needed, but I'm assuming
; LCtrl/RCtrl will be hit often enough to justify leaving the kb hooked.
; (If LowLevelKeyboardProc() takes too long, keyboard responsiveness may suffer.)
hKbdHook := DllCall("SetWindowsHookEx", "int", 13 ; WH_KEYBOARD_LL
        , "uint", RegisterCallback("LowLevelKeyboardProc"), "uint", 0, "uint",0)
TrayTip,OnRuns
OnExit, UnhookKeyboardAndExit

Return

UnhookKeyboardAndExit:
    DllCall("UnhookWindowsHookEx", "uint", hKbdHook)
    TrayTip,OnExit
ExitApp


LowLevelKeyboardProc(nCode, wParam, lParam)
{
    global key_pressed, key_wait_released
    static last_key ; key-repeat filter
    
    vk := NumGet(lParam+0)
    
    if (NumGet(lParam+8) & 0x80)
    {  ; key up
        if (vk = key_wait_released)
            key_wait_released =
        last_key =
    }
    else if (vk != last_key)
    {   ; key down (but not key-repeat)
        key_pressed := last_key := vk
    }

    return DllCall("CallNextHookEx", "uint", 0, "int", nCode, "uint", wParam, "uint", lParam)
}

Morse(timeout = 300)
{
    global key_pressed, key_wait_released
    key_pressed := ""
    
    tout := timeout/1000
    key := RegExReplace(A_ThisHotKey,"[\*\~\$\#\+\!\^]")

    Traytip,xxx
   
    ; There's no easy way to get the VK code from an AutoHotkey key name.
    ; For now, only support these specific keys.
    if key = LCtrl
        morse_key = 0xA2
    else if key = RCtrl
        morse_key = 0xA3
    
    if (morse_key)
    {   ; Let LowLevelKeyboardProc() tell us when this key is released.
        Loop {
            t := A_TickCount
            key_wait_released := morse_key
            Loop {
                if (key_pressed)
                    return ""
                if (!key_wait_released)
                    break
                Sleep, 10
            }
            Pattern .= A_TickCount-t > timeout
            
            keywait_tick := A_TickCount
            Loop {
                if (key_pressed) {
                    if (key_pressed != morse_key)
                        return ""
                    break
                }
                if (A_TickCount-keywait_tick > timeout)  ; Timed out.
                    return Pattern
                Sleep, 10
            }
            key_pressed =
        }
    }
    else
    { ; Don't know vk-code - fall back to original method.
        Loop {
            t := A_TickCount
            KeyWait %key%
            Pattern .= A_TickCount-t > timeout
            KeyWait %key%,DT%tout%
            If (ErrorLevel) ; Timed out.
                Return Pattern
        }
    }
}

LCtrl::
   p := Morse()
   If (p = "111")
      {
      ;Show Help
  TrayTip,Help,LCtrl -- MiM`n101-Run Miranda`n000-Show/Hide Miranda`n00-Get new message`n10-Go Online`n01-Go Away`n11-Quick Contacts`n`nRCtrl -- FB2k`n01-Next`n10-Prev`n00-Pause
      }

   If (p = "101")
      {
      ;Run Miranda
        IfWinNotExist,ahk_class Miranda
        {
          TrayTip,Running Miranda,%A_ThisHotkey% %p% Morse Pattern
        ;   Run,c:\Program Files\Miranda IM\miranda32.exe   
        }
      }


   If (p = "000")
      {
      ;Show/Hide Miranda
    ;   Send,^+h
      TrayTip,Show/Hide Miranda (Ctrl-Shift-H),%A_ThisHotkey% %p% Morse Pattern
      }
   Else If (p = "00")
      {
      ;Get new message
    ;   Send,^+i
      TrayTip,Get Message (Ctrl-Shift-I),%A_ThisHotkey% %p% Morse Pattern
      }
   Else If (p = "10")
      {
      ;Go Online
    ;   Send,^#1
      TrayTip,Miranda Online,%A_ThisHotkey% %p% Morse Pattern
      }
   Else If (p = "01")
      {
      ;Go Away
      Send,^#2
      Traytip,Miranda Away, %A_ThisHotkey% %p% Morse Pattern
      }
    Else If (p="11")
    {
    ;   Send,^+{Browser_Forward}
      Traytip,Miranda Away, %A_ThisHotkey% %p% Morse Pattern
    }
Return

RCtrl::
   p := Morse()
   If (p = "00")
      {
      ;Play/Pause
    ;   Send,{Media_Play_Pause}
      TrayTip,Media Play/Pause,%A_ThisHotkey% %p% Morse Pattern
      }
   Else If (p = "10")
      {
      ;Go Online
    ;   Send,{Media_Prev}
      TrayTip,Media Previous Track,%A_ThisHotkey% %p% Morse Pattern
      }
   Else If (p = "01")
      {
      ;Go Away
    ;   Send,{Media_Next}
      TrayTip,Media Next Track,(RCtrl %p% Morse Pattern)
      }
Return 
