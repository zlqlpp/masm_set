;------------------------
; ��DLL��̬���ӿ�
; ����
; 2011.1.22
;------------------------
    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc
include    user32.inc
includelib user32.lib
include    kernel32.inc
includelib kernel32.lib

;���ݶ�
    .data
szText   db  'DLL Hello',0
;�����
    .code
;------------------
; DLL���
;------------------
DllEntry   proc  _hInstance,_dwReason,_dwReserved

        mov eax,TRUE
        ret
DllEntry   endp

;-----------------------------------------------------------
; ���
;-----------------------------------------------------------
sayHello proc
    pushad
    invoke MessageBox,NULL,addr szText,NULL,MB_OK
    popad
    ret 
sayHello endp

      End DllEntry







