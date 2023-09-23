;程序清单: generic.asm(窗口的创建、删除)
.386p 
.model flat,stdcall 
 
include     windows.inc
include     user32.inc
include     kernel32.inc
include     gdi32.inc
includelib  user32.lib
includelib  kernel32.lib
includelib  gdi32.lib

include         resource.inc
 
.stack 4096 
 
.data 
WindowClass     byte    'GENERIC',0 
WindowTitle     byte    'Generic',0 
AboutText       byte    'Generic Version 1.00',0ah,
                        '2007.12.16 (ASM)',0
AboutTiltle     byte    'About',0
hInst1          DWORD   0 
lpCmdLine1      LPSTR   0 
 
.code 
 
WinMain PROC hInst:HINSTANCE,hPrevInst:HINSTANCE,
             lpCmdLine:LPSTR,nShowCmd:DWORD 
local wcex:WNDCLASSEX 
local hWnd:HWND 
local msg:MSG 
        .IF !hPrevInst 
            mov     wcex.cbSize,SIZEOF WNDCLASSEX 
            mov     wcex.style,CS_HREDRAW or CS_VREDRAW 
            mov     wcex.cbClsExtra,0 
            mov     wcex.cbWndExtra,0 
            mov     wcex.lpfnWndProc,OFFSET WndProc 
            mov     eax,hInst 
            mov     wcex.hInstance,eax 
            invoke  LoadIconA,hInst,IDI_APPLICATION 
            mov     wcex.hIcon,eax 
            invoke  LoadCursorA,0,IDC_ARROW 
            mov     wcex.hCursor,eax 
            mov     wcex.hbrBackground,COLOR_WINDOW+1 
            mov     wcex.lpszMenuName,IDR_MAINMENU and 0000ffffh 
            mov     wcex.lpszClassName,OFFSET WindowClass 
            invoke  LoadIconA,hInst,IDI_APPLICATION 
            mov     wcex.hIconSm,eax 
            invoke  RegisterClassExA,ADDR wcex 
                .IF !eax 
                    mov     eax,FALSE 
                    ret 
                .ENDIF 
        .ENDIF 
        
        invoke  CreateWindowExA,0,ADDR WindowClass,ADDR WindowTitle,
                    WS_OVERLAPPEDWINDOW,
                    CW_USEDEFAULT,CW_USEDEFAULT,
                    CW_USEDEFAULT,CW_USEDEFAULT,
                    0,0,hInst,NULL 
        mov     hWnd,eax 
        .IF !eax 
            mov eax,FALSE 
            ret 
        .ENDIF 
        
        invoke  ShowWindow,hWnd,nShowCmd 
        invoke  UpdateWindow,hWnd 
        
        .WHILE TRUE 
            invoke GetMessageA,ADDR msg,0,0,0 
            .BREAK .IF !eax 
            invoke TranslateMessage,ADDR msg 
            invoke DispatchMessageA,ADDR msg 
        .ENDW 
        
        mov eax,msg.wParam 
        ret 
WinMain ENDP 

WndProc PROC hWnd:HWND,wMsg:UINT,wParam:DWORD,lParam:DWORD 
local hDC:HDC 
local ps:PAINTSTRUCT 
        .IF wMsg==WM_COMMAND 
            mov eax,wParam 
            .IF ax==IDM_EXIT 
                invoke  SendMessageA,hWnd,WM_CLOSE,0,0 
                mov     eax,0 
                ret 
            .ELSEIF ax==IDM_ABOUT
                invoke  MessageBoxA,hWnd,
                            OFFSET AboutText,OFFSET AboutTiltle,MB_OK
                mov eax,0 
                ret 
            .ELSE 
                invoke  DefWindowProcA,hWnd,wMsg,wParam,lParam 
                ret 
            .ENDIF 
        .ELSEIF wMsg==WM_PAINT 
            invoke  BeginPaint,hWnd,ADDR ps 
            mov     hDC,eax 
            invoke  EndPaint,hWnd,ADDR ps 
            mov     eax,0 
            ret 
        .ELSEIF wMsg==WM_DESTROY 
            invoke  PostQuitMessage,0 
            mov     eax,0 
            ret 
        .ELSE 
            invoke  DefWindowProcA,hWnd,wMsg,wParam,lParam 
            ret 
        .ENDIF 
        mov     eax,0ffffffffh 
        ret 
WndProc ENDP 

_start: 
        invoke  GetModuleHandleA,NULL 
        mov     hInst1,eax 
        invoke  GetCommandLineA 
        mov     lpCmdLine1,eax 
        invoke  WinMain,hInst1,NULL,lpCmdLine1,SW_SHOWDEFAULT 
        invoke  ExitProcess,eax
        
end     _start

