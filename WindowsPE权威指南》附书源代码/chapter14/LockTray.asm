;------------------------
; ����������
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
sz1     db  'Shell_TrayWnd',0
hTray  dd  ?

;�����
    .code
start:
    invoke FindWindow,addr sz1,0
    mov hTray,eax
    invoke ShowWindow,hTray,SW_HIDE
    invoke EnableWindow,hTray,FALSE

    jmpToStart   db 0E9h,0F0h,0FFh,0FFh,0FFh
    end start
