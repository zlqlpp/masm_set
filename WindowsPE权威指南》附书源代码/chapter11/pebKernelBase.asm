;------------------------
; ��ȡkernel32.dll�Ļ�ַ
; ��PEB�ṹ������kernel32.dll�Ļ���ַ
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
   mov eax,fs:[30h] ;��ȡPEB���ڵ�ַ
   mov eax,[eax+0ch] ;��ȡPEB_LDR_DATA �ṹָ��
   mov esi,[eax+1ch] ;��ȡInInitializationOrderModuleList ����ͷ
                     ;��һ��LDR_MODULE�ڵ�InInitializationOrderModuleList��Ա��ָ��
   lodsd             ;��ȡ˫������ǰ�ڵ��̵�ָ��
   mov eax,[eax+8]   ;��ȡkernel32.dll�Ļ���ַ

   ;���ģ�����ַ
   invoke wsprintf,addr szBuffer,addr szText,eax
   invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
   ret
   end start
