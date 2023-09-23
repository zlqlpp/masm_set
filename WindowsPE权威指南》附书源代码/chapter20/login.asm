;------------------------
; �ó�����ʾ��һ������Ҫ��Դ�ļ��ĵ�¼����ʾ��
; ���ض�λ��Ϣ�������ݶ�
; ����
; 2010.6.28
;------------------------
    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc
include    user32.inc
includelib user32.lib
include    kernel32.inc
includelib kernel32.lib
include    gdi32.inc
includelib gdi32.lib

ID_BUTTON1         equ   1
ID_BUTTON2         equ   2
ID_LABEL1          equ   3
ID_LABEL2          equ   4
ID_EDIT1           equ   5
ID_EDIT2           equ   6



;�����
    .code
jmp start

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
dwRelocBase        dd  ?

;------------------------------------
; ����kernel32.dll�е�һ����ַ��ȡ���Ļ���ַ
;------------------------------------
_getKernelBase  proc _dwKernelRetAddress
   local @dwRet

   pushad

   mov @dwRet,0
   
   mov edi,_dwKernelRetAddress
   and edi,0ffff0000h  ;����ָ������ҳ�ı߽磬��1000h����

   .repeat
     .if word ptr [edi]==IMAGE_DOS_SIGNATURE  ;�ҵ�kernel32.dll��dosͷ
        mov esi,edi
        add esi,[esi+003ch]
        .if word ptr [esi]==IMAGE_NT_SIGNATURE ;�ҵ�kernel32.dll��PEͷ��ʶ
          mov @dwRet,edi
          .break
        .endif
     .endif
     sub edi,010000h
     .break .if edi<070000000h
   .until FALSE
   popad
   mov eax,@dwRet
   ret
_getKernelBase  endp   

;-------------------------------
; ��ȡָ���ַ�����API�����ĵ��õ�ַ
; ��ڲ�����_hModuleΪ��̬���ӿ�Ļ�ַ��_lpApiΪAPI����������ַ
; ���ڲ�����eaxΪ�����������ַ�ռ��е���ʵ��ַ
;-------------------------------
_getApi proc _hModule,_lpApi
   local @ret
   local @dwLen

   pushad
   mov @ret,0
   ;����API�ַ����ĳ��ȣ���������
   mov edi,_lpApi
   mov ecx,-1
   xor al,al
   cld
   repnz scasb
   mov ecx,edi
   sub ecx,_lpApi
   mov @dwLen,ecx

   ;��pe�ļ�ͷ������Ŀ¼��ȡ�������ַ
   mov esi,_hModule
   add esi,[esi+3ch]
   assume esi:ptr IMAGE_NT_HEADERS
   mov esi,[esi].OptionalHeader.DataDirectory.VirtualAddress
   add esi,_hModule
   assume esi:ptr IMAGE_EXPORT_DIRECTORY

   ;���ҷ������Ƶĵ���������
   mov ebx,[esi].AddressOfNames
   add ebx,_hModule
   xor edx,edx
   .repeat
     push esi
     mov edi,[ebx]
     add edi,_hModule
     mov esi,_lpApi
     mov ecx,@dwLen
     repz cmpsb
     .if ZERO?
       pop esi
       jmp @F
     .endif
     pop esi
     add ebx,4
     inc edx
   .until edx>=[esi].NumberOfNames
   jmp _ret
@@:
   ;ͨ��API����������ȡ��������ٻ�ȡ��ַ����
   sub ebx,[esi].AddressOfNames
   sub ebx,_hModule
   shr ebx,1
   add ebx,[esi].AddressOfNameOrdinals
   add ebx,_hModule
   movzx eax,word ptr [ebx]
   shl eax,2
   add eax,[esi].AddressOfFunctions
   add eax,_hModule
   
   ;�ӵ�ַ��õ����������ĵ�ַ
   mov eax,[eax]
   add eax,_hModule
   mov @ret,eax

_ret:
   assume esi:nothing
   popad
   mov eax,@ret
   ret
_getApi endp
;----------------
; �˳�����
;----------------
_Quit  proc
       pushad
       call @F   ; ��ȥ�ض�λ
@@:
       pop ebx
       sub ebx,offset @B   ;��λ����ַebx       
       invoke DestroyWindow,[ebx+offset hWinMain]
       invoke PostQuitMessage,NULL
       popad
       ret
_Quit  endp

_Exit proc
       invoke ExitProcess,NULL
_Exit endp
;------------------
; ������Ϣ�����ӳ���
;------------------
_ProcWinMain proc uses ebx edi esi,hWnd,uMsg,wParam,lParam
      local @stPos:POINT
      local hLabel1:dword
      local hLabel2:dword
      local hEdit1:dword
      local hEdit2:dword
      local hButton1:dword
      local hButton2:dword

      call @F   ; ��ȥ�ض�λ
   @@:
      pop ebx
      sub ebx,offset @B   ;��λ����ַebx

      mov eax,uMsg
      
      .if eax==WM_CREATE
          mov eax,hWnd
          mov [ebx+offset hWinMain],eax

          ;��ǩ
          mov eax,offset szLabelClass
          add eax,ebx
          mov ecx,offset szLabel1
          add ecx,ebx
      
          mov edx,[ebx+offset hInstance]

          push ebx
          invoke CreateWindowEx,NULL,\
                 eax,ecx,WS_CHILD or WS_VISIBLE, \
                 10,20,100,30,hWnd,ID_LABEL1,edx,NULL
          mov hLabel1,eax
          pop ebx

          mov eax,offset szLabelClass
          add eax,ebx
          mov ecx,offset szLabel2
          add ecx,ebx
      
          mov edx,[ebx+offset hInstance]

          push ebx
          invoke CreateWindowEx,NULL,\
                 eax,ecx,WS_CHILD or WS_VISIBLE, \
                 10,50,100,30,hWnd,ID_LABEL2,edx,NULL
          mov hLabel2,eax
          pop ebx

          ;�ı���
          mov eax,offset szEditClass
          add eax,ebx
     
          mov edx,[ebx+offset hInstance]

          push ebx
          invoke CreateWindowEx,WS_EX_TOPMOST,\
                 eax,NULL,WS_CHILD or WS_VISIBLE \
                 or WS_BORDER,\
                 105,19,175,22,hWnd,ID_EDIT1,edx,NULL
          mov hEdit1,eax
          pop ebx

          mov eax,offset szEditClass
          add eax,ebx
     
          mov edx,[ebx+offset hInstance]
          push ebx
          invoke CreateWindowEx,WS_EX_TOPMOST,\
                 eax,NULL,WS_CHILD or WS_VISIBLE \
                 or WS_BORDER or ES_PASSWORD,\
                 105,49,175,22,hWnd,ID_EDIT2,edx,NULL
          mov hEdit2,eax
          pop ebx

          ;��ť
          mov eax,offset szButtonClass
          add eax,ebx
          mov ecx,offset szButtonText1
          add ecx,ebx
     
          mov edx,[ebx+offset hInstance]
          push ebx
          invoke CreateWindowEx,NULL,\
                 eax,ecx,WS_CHILD or WS_VISIBLE, \
                 120,100,60,30,hWnd,ID_BUTTON1,edx,NULL
          mov hButton1,eax
          pop ebx

          mov eax,offset szButtonClass
          add eax,ebx
          mov ecx,offset szButtonText2
          add ecx,ebx
     
          mov edx,[ebx+offset hInstance]
          push ebx 
          invoke CreateWindowEx,NULL,\
                 eax,ecx,WS_CHILD or WS_VISIBLE, \
                 200,100,60,30,hWnd,ID_BUTTON2,edx,NULL
          mov hButton2,eax
          pop ebx
      .elseif eax==WM_COMMAND  ;����˵������ټ���Ϣ
          mov eax,wParam
          movzx eax,ax
          .if eax==ID_BUTTON1
             mov eax,offset szBuffer
             add eax,ebx
             push ebx
             invoke GetDlgItemText,hWnd,ID_EDIT1,\
                    eax,sizeof szBuffer
             pop ebx

             mov eax,offset szBuffer2
             add eax,ebx
             push ebx
             invoke GetDlgItemText,hWnd,ID_EDIT2,\
                    eax,sizeof szBuffer2
             pop ebx
             mov eax,offset szBuffer
             add eax,ebx
             mov ecx,offset lpszUser
             add ecx,ebx
             push ebx
             invoke lstrcmp,eax,ecx
             pop ebx
             .if eax
                jmp _ret
             .endif
             mov eax,offset szBuffer2
             add eax,ebx
             mov ecx,offset lpszPass
             add ecx,ebx
             push ebx
             invoke lstrcmp,eax,ecx
             pop ebx
             .if eax
                jmp _ret
             .endif

             ;invoke MessageBox,NULL,offset szText,offset szCaption,MB_OK
             jmp _ret1
          .elseif eax==ID_BUTTON2
_ret:        call _Exit
_ret1:       call _Quit
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
_WinMain  proc _base

       local @stWndClass:WNDCLASSEX
       local @stMsg:MSG
       local @hAccelerator

       mov ebx,_base
       push ebx
       invoke GetModuleHandle,NULL
       pop ebx
       mov [ebx+offset hInstance],eax

       push ebx
       ;ע�ᴰ����
       invoke RtlZeroMemory,addr @stWndClass,sizeof @stWndClass
       mov @stWndClass.hIcon,NULL
       mov @stWndClass.hIconSm,NULL

       mov @stWndClass.hCursor,NULL

       pop ebx

       mov edx,offset _ProcWinMain
       add edx,ebx
       mov ecx,offset szClassName
       add ecx,ebx

       push [ebx+offset hInstance]
       pop @stWndClass.hInstance
       mov @stWndClass.cbSize,sizeof WNDCLASSEX
       mov @stWndClass.style,CS_HREDRAW or CS_VREDRAW
       mov @stWndClass.lpfnWndProc,edx
       mov @stWndClass.hbrBackground,COLOR_WINDOW
       mov @stWndClass.lpszClassName,ecx
       push ebx
       invoke RegisterClassEx,addr @stWndClass
       pop ebx

       mov edx,offset szClassName
       add edx,ebx
       mov ecx,offset szCaptionMain
       add ecx,ebx

       mov eax,offset hInstance
       add eax,ebx
       push ebx
       ;��������ʾ����
       invoke CreateWindowEx,WS_EX_CLIENTEDGE,\
              edx,ecx,\
              WS_OVERLAPPED or WS_CAPTION or \
              WS_MINIMIZEBOX,\
              350,280,300,180,\
              NULL,NULL,[eax],NULL
       pop ebx
       mov  [ebx+offset hWinMain],eax
       
       mov edx,offset hWinMain
       add edx,ebx

       push ebx
       push edx
       invoke ShowWindow,[edx],SW_SHOWNORMAL
       pop edx
       invoke UpdateWindow,[edx] ;���¿ͻ�����������WM_PAINT��Ϣ
       pop ebx
   
       ;��Ϣѭ��
       .while TRUE
          push ebx
          invoke GetMessage,addr @stMsg,NULL,0,0
          pop ebx
          .break .if eax==0
          mov edx,offset hWinMain
          add edx,ebx

          push ebx
          invoke TranslateAccelerator,[edx],\
                 @hAccelerator,addr @stMsg
          pop ebx
          .if eax==0
             invoke TranslateMessage,addr @stMsg
             invoke DispatchMessage,addr @stMsg
          .endif
       .endw
       ret
_WinMain endp


start:
    ;ȡ��ǰ�����Ķ�ջջ��ֵ
    mov eax,dword ptr [esp]
    push eax
    call @F   ; ��ȥ�ض�λ
@@:
    pop ebx
    sub ebx,offset @B
    pop eax
    push ebx
    invoke _WinMain,ebx
    pop ebx
    mov eax,offset szCaptionMain
    add eax,ebx
    invoke MessageBox,NULL,eax,NULL,MB_OK
    jmpToStart   db 0E9h,0F0h,0FFh,0FFh,0FFh
    ret
    end start
