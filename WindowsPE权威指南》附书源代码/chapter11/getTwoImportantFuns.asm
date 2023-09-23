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

_QLGetProcAddress typedef proto :dword,:dword      ;��������
_ApiGetProcAddress  typedef ptr _QLGetProcAddress  ;������������

;���ݶ�
    .data
szText         db  'kernel32.dll�ڱ������ַ�ռ�Ļ���ַΪ��%08x',0dh,0ah,0
szText1        db  'GetProcAddress�����ڱ������ַ�ռ����ַΪ��%08x',0dh,0ah,0
szText2        db  'LoadLibraryA�����ڱ������ַ�ռ����ַΪ��%08x',0dh,0ah,0

szGetProcAddr  db  'GetProcAddress',0
szLoadLib      db  'LoadLibraryA',0

_getProcAddress _ApiGetProcAddress  ?              ;���庯��

kernel32Base   dd  ?
lpGetProcAddr  dd  ?
lpLoadLib      dd  ?  

szBuffer       db 256 dup(0)

;�����
    .code
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

start:
    mov eax,dword ptr [esp]
    invoke _getKernelBase,eax
    mov kernel32Base,eax
    invoke wsprintf,addr szBuffer,addr szText,eax
    invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK

    invoke _getApi,kernel32Base,addr szGetProcAddr
    mov lpGetProcAddr,eax
    mov _getProcAddress,eax   ;Ϊ�������ø�ֵ GetProcAddress
    invoke wsprintf,addr szBuffer,addr szText1,eax
    invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK


    invoke _getProcAddress,kernel32Base,addr szLoadLib
    mov lpLoadLib,eax
    invoke wsprintf,addr szBuffer,addr szText2,eax
    invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK 

    ret
    end start
