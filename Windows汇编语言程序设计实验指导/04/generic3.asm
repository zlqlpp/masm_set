;�����嵥: generic3.asm(GDI���)
.386p
.model flat, stdcall
include     windows.inc
include     user32.inc
include     kernel32.inc
include     gdi32.inc
includelib  user32.lib
includelib  kernel32.lib
includelib  gdi32.lib
IDB_BITMAP  equ     103         ; λͼ�������꣬Ӧ����resource.hһ��
.data 
WindowClass byte    'Generic3',0                ; ������
WindowTitle byte    'GDI API sample',0          ; ���ڱ���
szMousePos  byte    30 dup (?)                  ; Ҫ��ʾ���ַ���
nStrLen     dword   ?                           ; Ҫ��ʾ���ַ����ĳ���
szFmt       byte    '���λ��(%d,%d)     ',0    ; �ַ�����ʽ
hBitmap     dword   ?                           ; λͼ���
hBrsh1      dword   ?                           ; ��ˢ1���    
hBrsh2      dword   ?                           ; ��ˢ2���    
hBrsh3      dword   ?                           ; ��ˢ3���    
hBrsh4      dword   ?                           ; ��ˢ4���
hInst1      dword   0                           ; ��ǰ�����ʵ����� 
lpCmdLine1  LPSTR   0                           ; �����в�����ָ�� 
.code
; WinMain������generic.asmһ�£�����2���ط���ͬ��
; (1) mov  wcex.lpszMenuName,0   �����ϲ����в˵�
; (2) 100,100,720,300,           ���ڵĴ�С�趨Ϊ(720,300)
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
            ; ����Դ��װ��λͼ
            invoke  LoadBitmap,hInst1,IDB_BITMAP
            mov     hBitmap, eax 
            ; ����4����ˢ
            invoke  CreateSolidBrush,0ff0000H
            mov     hBrsh1,eax
            invoke  CreateSolidBrush, 000ff00H
            mov     hBrsh2,eax
            invoke  CreateHatchBrush,HS_HORIZONTAL,00000ffH
            mov     hBrsh3,eax
            invoke  CreateHatchBrush,HS_DIAGCROSS,0ffff00h
            mov     hBrsh4,eax
            ; ����0����ʾWM_CREATE��Ϣ�ѱ�����
            mov     eax,0 
            ret 
        .ELSEIF wMsg==WM_DESTROY
            ; ɾ�������Ļ�ˢ
            invoke  DeleteObject,hBrsh1
            invoke  DeleteObject,hBrsh2
            invoke  DeleteObject,hBrsh3
            invoke  DeleteObject,hBrsh4
            ; ɾ��λͼ��Դ
            invoke  DeleteObject,HBITMAP
            ; ����һ��WM_QUIT��Ϣ
            invoke  PostQuitMessage,0 
            mov     eax,0 
            ret 
        .ELSEIF wMsg==WM_MOUSEMOVE 
            ; lParam�ĸ�16λΪy���꣬��16λΪx����
            mov     eax,lParam
            movzx   ebx,ax
            shr     eax,16
            invoke  wsprintfA,offset szMousePos,offset szFmt,ebx,eax
            mov     nStrLen, eax
            ; ����GetDC(hWnd)�õ�����������豸��������
            invoke  GetDC,hWnd
            mov     hDC,eax
            ; ��(20,230)����ʾ�ַ���
            invoke  TextOutA,hDC,20,230,offset szMousePos,nStrLen
            ; �ͷ��豸��������
            invoke  ReleaseDC,hWnd,hDC
            xor     eax,eax
            ret        
        .ELSEIF wMsg==WM_PAINT
            ; �õ���ʾ������豸��������hDC
            invoke  BeginPaint,hWnd,addr ps
            mov     hDC,eax
            ; ѡ���Ѵ����Ļ�ˢ
            invoke  SelectObject,hDC,hBrsh1
            ; ������
            invoke  Rectangle,hDC,20,10,90,220
            invoke  SelectObject,hDC,hBrsh2
            invoke  Rectangle,hDC,110,10,180,220
            invoke  SelectObject,hDC,hBrsh3
            invoke  Rectangle,hDC,200,10,270,220
            invoke  SelectObject,hDC,hBrsh4
            invoke  Rectangle,hDC,290,10,360,220
            ; ����hDC���ڴ�ӳ��hMemDC
            invoke  CreateCompatibleDC,hDC
            mov     hMemDC,eax
            ; ��λͼ����"��Ļ�ڴ�ӳ��"��
            invoke  SelectObject,hMemDC,hBitmap
            ; ��λͼ��hMemDC���Ƶ�hDC��
            invoke  BitBlt,hDC,400,10,290,210,hMemDC,0,0,SRCCOPY
            ; ɾ��hMemDC
            invoke  DeleteDC,hMemDC
            ; EndPaint()��BeginPaint()���ʹ�ã�ʹ��Ч������Ч
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
