;------------------------
; ��ջ����������
; ����
; 2010.2.28
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
szText       db 'HelloWorldPE',0
szShellCode  db 11 dup(0ffh),0

;�����
    .code

;---------------------------
; δ��鳤�ȵ��ַ�����������
;---------------------------
_memCopy proc _lpSrc
    local @buf[4]:byte

    pushad
    mov esi,_lpSrc
    lea edi,@buf
    mov al,byte ptr [esi]    
    .while al!=0
      mov byte ptr [edi],al
      mov al,byte ptr [esi]

      inc esi
      inc edi
    .endw
    popad
    ret
_memCopy endp


start:
    invoke _memCopy,addr szShellCode

    invoke MessageBox,NULL,offset szText,NULL,MB_OK
    invoke ExitProcess,NULL
    end start
