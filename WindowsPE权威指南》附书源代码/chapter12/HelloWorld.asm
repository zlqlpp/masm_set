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
szText     db  'HelloWorldPE',0
;�����
    .code
start:
    invoke MessageBox,NULL,offset szText,NULL,MB_OK
    invoke ExitProcess,NULL
    end start
