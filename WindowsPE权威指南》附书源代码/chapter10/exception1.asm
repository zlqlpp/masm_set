;------------------------
; �����쳣����
; ����
; 2011.1.19
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
szText     db  'HelloWorldPE',0
szErr      db  'SEH Error',0
;�����
    .code
start:
    xor eax,eax
    mov dword ptr [eax],eax
    invoke MessageBox,NULL,addr szText,NULL,MB_OK
    invoke ExitProcess,NULL
    end start
