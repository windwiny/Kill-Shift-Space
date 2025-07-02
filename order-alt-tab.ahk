; Use a shell hook to detect minimize and fix the alt-tab order.
OnMessage(DllCall("RegisterWindowMessage", "str", "SHELLHOOK"), "ShellHook")
DllCall("RegisterShellHookWindow", "ptr", A_ScriptHwnd)

ShellHook(wParam, lParam)
{
    if (wParam != 0x5) ; HSHELL_GETMINRECT
        return
    hwnd := NumGet(lParam+0)
    WinGet minmax, MinMax, ahk_id %hwnd%
    if (minmax = -1) ; Minimized
    {
        ; Remove the window from the alt-tab list temporarily to force
        ; it to the end of the list.  To do this, temporarily apply the
        ; WS_EX_TOOLWINDOW style and remove WS_EX_APPWINDOW (if present).
        WinGet oldxs, ExStyle, ahk_id %hwnd%
        newxs := (oldxs & ~0x40000) | 0x80
        if (newxs != oldxs)
        {
            WinSet ExStyle, % newxs, ahk_id %hwnd%
            WinSet ExStyle, % oldxs, ahk_id %hwnd%
        }
    }
}

