;------------------------
; ��ȡkernel32.dll�Ļ�ַ
; �ӽ��̵�ַ�ռ�����kernel32.dll�Ļ���ַ
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

   call loc0
   db 'GetProcAddress',0  ;����������

loc0:
   pop edx            ;edx�д�����������������ڵ�ַ
   push edx
   mov ebx,7ffe0000h  ;�Ӹߵ�ַ��ʼ

loc1:
   cmp dword ptr [ebx],905A4Dh
   JE loc2   ;�ж��Ƿ�ΪMS DOSͷ��־

loc5:
   sub ebx,00010000h

   pushad         ;�����Ĵ���1
   invoke IsBadReadPtr,ebx,2
   .if eax
     popad        ;�ָ��Ĵ���1
     jmp loc5
   .endif
   popad          ;�ָ��Ĵ���1

   jmp loc1



loc2:   ;����������
   mov esi,dword ptr [ebx+3ch] 
   add esi,ebx ;ESIָ��PEͷ
   mov esi,dword ptr [esi+78h]
   nop
 
   .if esi==0
     jmp loc5
   .endif
   add esi,ebx ;ESIָ������Ŀ¼�еĵ�����
   mov edi,dword ptr [esi+20h] ;ָ�򵼳����AddressOfNames
   add edi,ebx ;EDIΪAddressOfNames������ʼλ��
   mov ecx,dword ptr [esi+18h] ;ָ�򵼳����NumberOfNames
   push esi


   xor eax,eax
loc3:
   push edi
   push ecx
   mov edi,dword ptr [edi]
   add edi,ebx  ;ediָ���˵�һ���������ַ�������ʼ
   mov esi,edx  ;esiָ����������������ʼ
   xor ecx,ecx
   mov cl,0eh  ;�����������ĳ���
   repe cmpsb
   pop ecx
   pop edi
   je loc4    ;�ҵ�����������ת��
   add edi,4  ;edi�ƶ�����һ�����������ڵ�ַ
   inc eax    ;eaxΪ����
   loop loc3

   jmp loc5
loc4:
   ;��������ƥ��ɹ������ģ�����ַ
    
    invoke wsprintf,addr szBuffer,addr szText,ebx
    invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
    ret
    end start
