;------------------------
; �ҵĵ�һ������WIN32�Ļ�����
; ����
; 2010.6.10
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
;�����
    .code
start:
    push MB_OK
    push NULL
    push offset szText
    jmp short @next1
    db 8 dup(0aah)
@next1:
    push NULL
    call MessageBoxA
    nop
    add eax,offset szText
    nop
    push NULL
    call ExitProcess
    end start
