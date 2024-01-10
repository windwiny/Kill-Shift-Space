/*
*	A simple program testing Windows global hotkey usage. 
*	Using the keybind 'shift + space' will print a message in the program console.
*	Largely taken from MSDN topic on RegisterHotkey here:
*	https://msdn.microsoft.com/en-us/library/windows/desktop/ms646309%28v=vs.85%29.aspx

RegisterHotKey GetMessage LPMSG  
GetAsyncKeyState GetKeyState   SHIFTED
WM_HOTKEY
    VK_LSHIFT	0xA0	Left SHIFT key
    VK_RSHIFT	0xA1	Right SHIFT key
    VK_LCONTROL	0xA2	Left CONTROL key
    VK_RCONTROL	0xA3	Right CONTROL key
    VK_LMENU	0xA4	Left ALT key
    VK_RMENU	0xA5	Right ALT key
    VK_SHIFT	0x10	SHIFT key
    VK_CONTROL	0x11	CTRL key
    VK_MENU		0x12	ALT key

    MOD_ALT		0x0001	Either ALT key must be held down.
    MOD_CONTROL	0x0002	Either CTRL key must be held down.
    MOD_NOREPEAT	0x4000	Changes the hotkey behavior so that the keyboard auto-repeat does not yield multiple hotkey notifications　Windows Vista:  This flag is not supported.
    MOD_SHIFT	0x0004	Either SHIFT key must be held down.
    MOD_WIN		0x0008	Either WINDOWS key was held down.


ref  ahk win32api regedit
  https://github.com/Svtter/Kill-Shift-Space


g++ killShiftSpace.cpp  -o killShiftSpace.exe  -Wl,--subsystem,windows

 
*/


#include <Windows.h>
#include <stdio.h>
#include <time.h>


// comment this will show the console   // only used cl.exe , not work on g++
#pragma comment( linker, "/subsystem:\"windows\" /entry:\"mainCRTStartup\"" )

#define SHIFTED 0x8000
#define ID_SHIFT_SPACE 0x2010
#define ID_ALT_SHIFT (ID_SHIFT_SPACE+1)
#define ID_CTRL_SHIFT (ID_ALT_SHIFT+1)

FILE *f = stderr;


void ProcShiftSpace(SHORT isLeft) {
    if(isLeft) {
        fprintf(f, "%d - *SKIP left shift + space : win11 wubi input switch Full/half space \n", time(NULL) );
        keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
        keybd_event(VK_SPACE, 0, KEYEVENTF_KEYUP, 0);
        keybd_event(VK_SPACE, 0, 0, 0);
        keybd_event(VK_SPACE, 0, KEYEVENTF_KEYUP, 0);
    } else {
        fprintf(f, "%d - right shift + space : resend origin keys? unknow howto do \n", time(NULL) );
        // TODO FIXME
    }
}

void ProcAltShift(SHORT isLeft) {
    if(isLeft) {
        fprintf(f, "%d - *SKIP left shift + alt : win11 switch IME keyboard layout\n", time(NULL) );
        keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
        keybd_event(VK_MENU, 0, KEYEVENTF_KEYUP, 0);    //alt
    } else {
        fprintf(f, "%d - right shift + alt : resend origin keys \n", time(NULL) );
        // TODO FIXME
        // keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
        // keybd_event(VK_MENU, 0, KEYEVENTF_KEYUP, 0);    //alt
        // keybd_event(VK_MENU, 0, 0, 0);
        // keybd_event(VK_SHIFT, 0, 0, 0);
        // keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
        // keybd_event(VK_MENU, 0, KEYEVENTF_KEYUP, 0);
    }
}

void ProcCtrlShift(SHORT isLeft) {
    if(isLeft) {
        fprintf(f, "%d - *SKIP left shift + ctrl: win11 switch IME\n", time(NULL) );
        keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
        keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
    } else {
        fprintf(f, "%d - right shift + ctrl : resend origin keys \n", time(NULL) );
        // TODO FIXME
        // keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
        // keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
        // keybd_event(VK_CONTROL, 0, 0, 0);
        // keybd_event(VK_SHIFT, 0, 0, 0);
        // keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
        // keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
    }
}


int main(int argc, char *argv[]) {
    for (int i=0; i<argc; i++)
        if(argv[i][0] =='-' && argv[i][1] == 'f') {
            f = fopen("killSS.log", "a");
            break;
        }

    int quitSig = 0;
    fprintf(f, "Press 6 times shift+alt, will quit\n");

    {
        int res ;
        res = RegisterHotKey(NULL, ID_SHIFT_SPACE, MOD_SHIFT | MOD_NOREPEAT, 0x20);
        fprintf(f, "%d - registered %X global hotkey res= %d\n", time(NULL), ID_SHIFT_SPACE, res );
        res = RegisterHotKey(NULL, ID_ALT_SHIFT, MOD_ALT | MOD_SHIFT | MOD_NOREPEAT, 0); // vk 0
        fprintf(f, "%d - registered %X global hotkey res= %d\n", time(NULL), ID_ALT_SHIFT, res );
        res = RegisterHotKey(NULL, ID_CTRL_SHIFT, MOD_CONTROL | MOD_SHIFT | MOD_NOREPEAT, 0); // vk 0
        fprintf(f, "%d - registered %X global hotkey res= %d\n", time(NULL), ID_CTRL_SHIFT, res );
        fflush(f);
    }

	MSG winMessage = { 0 };

	// perpetually wait until a message is received
	while (GetMessage(&winMessage, NULL, 0, 0))	{
		if (winMessage.message == WM_HOTKEY) {
            UINT ID_HOT_KEY = winMessage.wParam;
            UINT MOD = LOWORD(winMessage.lParam);
            UINT VK = HIWORD(winMessage.lParam);
            fprintf(f, " %d  HK:%X MOD:%X VK:%X  -- ", winMessage.time, ID_HOT_KEY, MOD, VK );
            // just skip left pos, not right pos key
			if (ID_HOT_KEY == ID_SHIFT_SPACE) {
                quitSig = 0;
                SHORT isLeft = GetKeyState(VK_LSHIFT) & SHIFTED;
                ProcShiftSpace(isLeft);
            } else if (ID_HOT_KEY == ID_ALT_SHIFT) {
                quitSig++;
                if(quitSig>5) {
			        fprintf(f, "\n%d - check repeat %d, quit prog.. \n", time(NULL), quitSig );
                    break;
                }
                SHORT isLeft = GetKeyState(MOD==MOD_SHIFT ? VK_LSHIFT : VK_LMENU) & SHIFTED; // check which key latest release is MOD
                ProcAltShift(isLeft);
            } else if (ID_HOT_KEY == ID_CTRL_SHIFT) {
                quitSig = 0;
                SHORT isLeft = GetKeyState(MOD==MOD_SHIFT ? VK_LSHIFT : VK_LCONTROL) & SHIFTED; // check which key latest release is MOD
                ProcCtrlShift(isLeft);
            } else {
                quitSig = 0;
			    fprintf(f, "%d - miss some thing ??\n", time(NULL) );
            }
		}
        fflush(f);
	}

	// unregister the hotkey
    for (int ID=ID_SHIFT_SPACE; ID<=ID_CTRL_SHIFT; ID++) {
        int res = UnregisterHotKey(NULL, ID);
        fprintf(f, "%d - unregistered %X hotkey res= %d\n", time(NULL), ID, res );
    }

	return 0;
}
