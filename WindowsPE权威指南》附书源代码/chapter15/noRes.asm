;------------------------
; �ó�����ʾ��һ������Ҫ��Դ�ļ��ĵ�¼����ʾ��
; ����
; 2006.2.28
;------------------------
    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc
include    user32.inc
includelib user32.lib
include    kernel32.inc
includelib kernel32.lib
include    winResult.inc
includelib winResult.lib


ID_BUTTON1         equ   1
ID_BUTTON2         equ   2
ID_LABEL1          equ   3
ID_LABEL2          equ   4
ID_EDIT1           equ   5
ID_EDIT2           equ   6

;���ݶ�
    .data
szCaption          db  '��ӭ����',0
szText             db  '���ǺϷ��û�����ʹ�ø������',0
szCaptionMain      db  'ϵͳ��¼',0
szClassName        db  'Menu Example',0
szButtonClass      db  'button',0
szEditClass        db  'edit',0
szLabelClass       db  'static',0

szButtonText1      db  '��  ¼',0
szButtonText2      db  'ȡ  ��',0
szLabel1           db  '�û�����',0
szLabel2           db  '��   �룺',0
lpszUser           db  'admin',0       ;ģ���û���������
lpszPass           db  '123456',0

szBuffer           db  256 dup(0)
szBuffer2          db  256 dup(0)

hInstance          dd  ?
hWinMain           dd  ?
hWinEdit           dd  ?
hButton1           dd  ?
hButton2           dd  ?
hLabel1            dd  ?
hLabel2            dd  ?
hEdit1             dd  ?
hEdit2             dd  ?


;�����
    .code

;----------------
; �˳�����
;----------------
_Quit  proc
       pushad
       invoke FadeOutClose,hWinMain
       invoke DestroyWindow,hWinMain
       invoke PostQuitMessage,NULL
       popad
       ret
_Quit  endp
;------------------
; ������Ϣ�����ӳ���
;------------------
_ProcWinMain proc uses ebx edi esi,hWnd,uMsg,wParam,lParam
      local @stPos:POINT

      mov eax,uMsg
      
      .if eax==WM_CREATE
          mov eax,hWnd
          mov hWinMain,eax

          ;��ǩ
          invoke CreateWindowEx,NULL,\
                 addr szLabelClass,addr szLabel1,WS_CHILD or WS_VISIBLE, \
                 10,20,100,30,hWnd,ID_LABEL1,hInstance,NULL
          mov hLabel1,eax
          invoke CreateWindowEx,NULL,\
                 addr szLabelClass,addr szLabel2,WS_CHILD or WS_VISIBLE, \
                 10,50,100,30,hWnd,ID_LABEL2,hInstance,NULL
          mov hLabel2,eax

          ;�ı���
          invoke CreateWindowEx,WS_EX_TOPMOST,\
                 addr szEditClass,NULL,WS_CHILD or WS_VISIBLE \
                 or WS_BORDER,\
                 105,19,175,22,hWnd,ID_EDIT1,hInstance,NULL
          mov hEdit1,eax
          invoke CreateWindowEx,WS_EX_TOPMOST,\
                 addr szEditClass,NULL,WS_CHILD or WS_VISIBLE \
                 or WS_BORDER or ES_PASSWORD,\
                 105,49,175,22,hWnd,ID_EDIT2,hInstance,NULL
          mov hEdit2,eax

          ;��ť
          invoke CreateWindowEx,NULL,\
                 addr szButtonClass,addr szButtonText1,WS_CHILD or WS_VISIBLE, \
                 120,100,60,30,hWnd,ID_BUTTON1,hInstance,NULL
          mov hButton1,eax

          invoke CreateWindowEx,NULL,\
                 addr szButtonClass,addr szButtonText2,WS_CHILD or WS_VISIBLE, \
                 200,100,60,30,hWnd,ID_BUTTON2,hInstance,NULL
          mov hButton2,eax
      .elseif eax==WM_COMMAND  ;����˵������ټ���Ϣ
          mov eax,wParam
          movzx eax,ax
          .if eax==ID_BUTTON1
             invoke GetDlgItemText,hWnd,ID_EDIT1,\
                    addr szBuffer,sizeof szBuffer
             invoke GetDlgItemText,hWnd,ID_EDIT2,\
                    addr szBuffer2,sizeof szBuffer2
             invoke lstrcmp,addr szBuffer,addr lpszUser
             .if eax
                jmp _ret
             .endif
             invoke lstrcmp,addr szBuffer2,addr lpszPass
             .if eax
                jmp _ret
             .endif
             invoke MessageBox,NULL,offset szText,offset szCaption,MB_OK
             invoke FadeOutClose,hWinMain
             invoke DestroyWindow,hWinMain

          .elseif eax==ID_BUTTON2
_ret:        call _Quit
          .endif
      .elseif eax==WM_CLOSE
      .else
          invoke DefWindowProc,hWnd,uMsg,wParam,lParam
          ret
      .endif
      
      xor eax,eax
      ret
_ProcWinMain endp


;----------------------
; �����ڳ���
;----------------------
_WinMain  proc

       local @stWndClass:WNDCLASSEX
       local @stMsg:MSG
       local @hAccelerator

       invoke GetModuleHandle,NULL
       mov hInstance,eax

       ;ע�ᴰ����
       invoke RtlZeroMemory,addr @stWndClass,sizeof @stWndClass
       mov @stWndClass.hIcon,NULL
       mov @stWndClass.hIconSm,NULL

       mov @stWndClass.hCursor,NULL
       push hInstance
       pop @stWndClass.hInstance
       mov @stWndClass.cbSize,sizeof WNDCLASSEX
       mov @stWndClass.style,CS_HREDRAW or CS_VREDRAW
       mov @stWndClass.lpfnWndProc,offset _ProcWinMain
       mov @stWndClass.hbrBackground,COLOR_WINDOW
       mov @stWndClass.lpszClassName,offset szClassName
       invoke RegisterClassEx,addr @stWndClass

       ;��������ʾ����
       invoke CreateWindowEx,WS_EX_CLIENTEDGE,\
              offset szClassName,offset szCaptionMain,\
              WS_OVERLAPPED or WS_CAPTION or \
              WS_MINIMIZEBOX,\
              350,280,300,180,\
              NULL,NULL,hInstance,NULL
       mov  hWinMain,eax
       invoke FadeInOpen,hWinMain
       ;invoke ShowWindow,hWinMain,SW_SHOWNORMAL
       invoke UpdateWindow,hWinMain ;���¿ͻ�����������WM_PAINT��Ϣ

   
       ;��Ϣѭ��
       .while TRUE
          invoke GetMessage,addr @stMsg,NULL,0,0
          .break .if eax==0
          invoke TranslateAccelerator,hWinMain,\
                 @hAccelerator,addr @stMsg
          .if eax==0
             invoke TranslateMessage,addr @stMsg
             invoke DispatchMessage,addr @stMsg
          .endif
       .endw
       ret
_WinMain endp


start:
    call _WinMain    
    invoke ExitProcess,NULL
    end start
