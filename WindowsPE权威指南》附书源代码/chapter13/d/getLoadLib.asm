;------------------------
; ���ܲ�����
; ��ȡLoadLibraryA�ĺ�����ַ������
; 
; 00000245      00001d7b      LoadLibraryA

; ����
; 2011.2.22
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

szText  db 'LoadLibrary�ĺ�����ַΪ�� %08x',0
szOut   db '%08x',0dh,0ah,0
szBuffer db 256 dup(0)

;�����
    .code

start:
   mov edi,edi
   call loc0
   db 'LoadLibraryA',0  ;����������
   db 'pa',0            ;��̬���ӿ�pa.dll
loc0:
   pop edx            ;edx�д�����������������ڵ�ַ
   push edx

   push edx

   assume fs:nothing
   mov eax,fs:[30h] ;��ȡPEB���ڵ�ַ
   mov eax,[eax+0ch] ;��ȡPEB_LDR_DATA �ṹָ��
   mov esi,[eax+1ch] ;��ȡInInitializationOrderModuleList ����ͷ
                     ;��һ��LDR_MODULE�ڵ�InInitializationOrderModuleList��Ա��ָ��
   lodsd             ;��ȡ˫������ǰ�ڵ��̵�ָ��
   mov ebx,[eax+8]   ;��ȡkernel32.dll�Ļ���ַ


loc2:   ;����������
   mov esi,dword ptr [ebx+3ch] 
   add esi,ebx ;ESIָ��PEͷ
   mov esi,dword ptr [esi+78h]
   add esi,ebx ;ESIָ������Ŀ¼�еĵ�����
   mov edi,dword ptr [esi+20h] ;ָ�򵼳����AddressOfNames
   add edi,ebx ;EDIΪAddressOfNames������ʼλ��
   mov ecx,dword ptr [esi+14h] ;ָ�򵼳����NumberOfNames

   push esi
   xor eax,eax

loc3:
   push edi
   push ecx
   mov edi,dword ptr [edi]
   add edi,ebx  ;ediָ���˵�һ���������ַ�������ʼ
   mov esi,edx  ;esiָ����������������ʼ
   xor ecx,ecx
   mov cl,0ch   ;�����������ĳ���
   repe cmpsb
   je loc4    ;�ҵ�����������ת��

   pop ecx
   pop edi
   add edi,4  ;edi�ƶ�����һ�����������ڵ�ַ
   inc eax    ;eaxΪ����
   loop loc3
loc4:
   pop ecx
   pop edi
   pop esi ;ESIָ������Ŀ¼�еĵ�����   
   mov edi,dword ptr [esi+24h] ;ָ�򵼳����Name����
   add edi,ebx ;EDIΪAddressOfNamesOrdinals������ʼλ��

   ;����eax����ֵ
   sal eax,1   ;eax�д����ָ���������������ƫ��
   add edi,eax
   mov ax,word ptr [edi]  ;����һ������
   mov edi,dword ptr [esi+1ch]  ;AddressOfFunctions
   add edi,ebx   
   
   sal eax,2
   add edi,eax
   mov eax,dword ptr [edi]
   add eax,ebx

   ;edxָ��patch.dll
   ;����dll�������Բ����ĵ���
   pop edx
   add edx,0dh 
   push edx
   call eax
   ;��ת
   db 0E9h,0FFh,0FFh,0FFh,0FFh
   end start
