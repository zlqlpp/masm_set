;------------------------
; �ӳټ���ʵ��
; ����
; 2011.2.10
;------------------------
    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc
include    user32.inc
includelib user32.lib
include    kernel32.inc
includelib kernel32.lib
include    MyDll.inc
includelib MyDll.lib

;���ݶ�
    .data
dwFlag     dd  1
szText     db  'HelloWorldPE',0

;�����
    .code
start:
    mov eax,dwFlag
    .if eax==0
      invoke sayHello
    .endif
    invoke MessageBox,NULL,offset szText,NULL,MB_OK
    invoke ExitProcess,NULL
    end start
