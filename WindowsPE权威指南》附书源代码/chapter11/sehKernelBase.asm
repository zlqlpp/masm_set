;------------------------
; ��ȡkernel32.dll�Ļ�ַ
; ��SEH��ܿռ�������kernel32.dll�Ļ���ַ
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

szText  db 'kernel32.dll�Ļ���ַΪ%08x',0
szOut   db '%08x',0dh,0ah,0
szBuffer db 256 dup(0)

;�����
    .code

start:

   assume fs:nothing
   mov eax,fs:[0]
   inc eax   ; ���eax=0FFFFFFFFh��������Ϊ0
loc1:  
   dec eax
   mov esi,eax ;ESIָ��EXCEPTION_REGISTRATION
   mov eax,[eax]  ;eax=EXCEPTION_REGISTRATION.prev
   inc eax        ;���eax=0FFFFFFFFh��������Ϊ0
   jne loc1
   lodsd          ;����0FFFFFFFFh
   lodsd          ;��ȡkernel32._except_handler��ַ
   xor ax,ax      ;����10000h���룬����
   jmp loc3

loc2:
   sub eax,10000h         
loc3:

   cmp dword ptr [eax],905A4Dh
   jne loc2

   ;���ģ�����ַ
   invoke wsprintf,addr szBuffer,addr szText,eax
   invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
   ret
   end start
