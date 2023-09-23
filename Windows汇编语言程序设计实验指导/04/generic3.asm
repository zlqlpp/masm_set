;程序清单: generic3.asm(GDI编程)
.386p
.model flat, stdcall
include     windows.inc
include     user32.inc
include     kernel32.inc
include     gdi32.inc
includelib  user32.lib
includelib  kernel32.lib
includelib  gdi32.lib
IDB_BITMAP  equ     103         ; 位图的整数宏，应该与resource.h一致
.data 
WindowClass byte    'Generic3',0                ; 窗口类
WindowTitle byte    'GDI API sample',0          ; 窗口标题
szMousePos  byte    30 dup (?)                  ; 要显示的字符串
nStrLen     dword   ?                           ; 要显示的字符串的长度
szFmt       byte    '鼠标位置(%d,%d)     ',0    ; 字符串格式
hBitmap     dword   ?                           ; 位图句柄
hBrsh1      dword   ?                           ; 画刷1句柄    
hBrsh2      dword   ?                           ; 画刷2句柄    
hBrsh3      dword   ?                           ; 画刷3句柄    
hBrsh4      dword   ?                           ; 画刷4句柄
hInst1      dword   0                           ; 当前程序的实例句柄 
lpCmdLine1  LPSTR   0                           ; 命令行参数的指针 
.code
; WinMain函数与generic.asm一致，除了2个地方不同：
; (1) mov  wcex.lpszMenuName,0   窗口上不再有菜单
; (2) 100,100,720,300,           窗口的大小设定为(720,300)
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
            mov     wcex.lpszMenuName,0 
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
                    100,100,720,300,
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

WndProc  proc uses ebx edi esi, hWnd:DWORD, wMsg:DWORD, 
              wParam:DWORD, lParam:DWORD
local hDC:HDC,hMemDC:HDC 
local ps:PAINTSTRUCT 
        .IF wMsg==WM_CREATE
            ; 从资源中装入位图
            invoke  LoadBitmap,hInst1,IDB_BITMAP
            mov     hBitmap, eax 
            ; 创建4个画刷
            invoke  CreateSolidBrush,0ff0000H
            mov     hBrsh1,eax
            invoke  CreateSolidBrush, 000ff00H
            mov     hBrsh2,eax
            invoke  CreateHatchBrush,HS_HORIZONTAL,00000ffH
            mov     hBrsh3,eax
            invoke  CreateHatchBrush,HS_DIAGCROSS,0ffff00h
            mov     hBrsh4,eax
            ; 返回0，表示WM_CREATE消息已被处理
            mov     eax,0 
            ret 
        .ELSEIF wMsg==WM_DESTROY
            ; 删除创建的画刷
            invoke  DeleteObject,hBrsh1
            invoke  DeleteObject,hBrsh2
            invoke  DeleteObject,hBrsh3
            invoke  DeleteObject,hBrsh4
            ; 删除位图资源
            invoke  DeleteObject,HBITMAP
            ; 发送一个WM_QUIT消息
            invoke  PostQuitMessage,0 
            mov     eax,0 
            ret 
        .ELSEIF wMsg==WM_MOUSEMOVE 
            ; lParam的高16位为y坐标，低16位为x坐标
            mov     eax,lParam
            movzx   ebx,ax
            shr     eax,16
            invoke  wsprintfA,offset szMousePos,offset szFmt,ebx,eax
            mov     nStrLen, eax
            ; 调用GetDC(hWnd)得到窗口区域的设备描述表句柄
            invoke  GetDC,hWnd
            mov     hDC,eax
            ; 在(20,230)处显示字符串
            invoke  TextOutA,hDC,20,230,offset szMousePos,nStrLen
            ; 释放设备描述表句柄
            invoke  ReleaseDC,hWnd,hDC
            xor     eax,eax
            ret        
        .ELSEIF wMsg==WM_PAINT
            ; 得到显示区域的设备描述表句柄hDC
            invoke  BeginPaint,hWnd,addr ps
            mov     hDC,eax
            ; 选择已创建的画刷
            invoke  SelectObject,hDC,hBrsh1
            ; 画矩形
            invoke  Rectangle,hDC,20,10,90,220
            invoke  SelectObject,hDC,hBrsh2
            invoke  Rectangle,hDC,110,10,180,220
            invoke  SelectObject,hDC,hBrsh3
            invoke  Rectangle,hDC,200,10,270,220
            invoke  SelectObject,hDC,hBrsh4
            invoke  Rectangle,hDC,290,10,360,220
            ; 创建hDC的内存映像hMemDC
            invoke  CreateCompatibleDC,hDC
            mov     hMemDC,eax
            ; 将位图画在"屏幕内存映像"上
            invoke  SelectObject,hMemDC,hBitmap
            ; 将位图从hMemDC复制到hDC中
            invoke  BitBlt,hDC,400,10,290,210,hMemDC,0,0,SRCCOPY
            ; 删除hMemDC
            invoke  DeleteDC,hMemDC
            ; EndPaint()和BeginPaint()配对使用，使无效区域有效
            invoke  EndPaint,hWnd,addr ps
            xor     eax,eax
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
