;------------------------
; ��ȡkernel32.dll�Ļ�ַ
; ����
; 2010.6.27
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
szText         db  'kernel32.dll�ڱ������ַ�ռ�Ļ���ַΪ��%08x',0dh,0ah,0
kernel32Base   dd  ?
szBuffer       db 256 dup(0)

;�����
    .code
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


start:
    mov eax,dword ptr [esp]
    invoke _getKernelBase,eax
    invoke wsprintf,addr szBuffer,addr szText,eax
    invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
    ret
    end start
