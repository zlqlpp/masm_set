;------------------------
; �ҵĵ�һ������WIN32�Ļ�����
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

;���ݶ�
    .data
szText     db  'HelloWorld',0
;�����
    .code

fun1  proc _p1,_p2
    local @dwTemp:dword
    local @dwCount:dword

    pushad

    mov @dwTemp,0
    mov eax,_p2
    mov @dwCount,eax

    popad
    mov eax,@dwCount
    ret
fun1  endp

start:
    invoke fun1,addr szText,2
    invoke MessageBox,NULL,offset szText,NULL,MB_OK
    invoke ExitProcess,NULL
    end start
