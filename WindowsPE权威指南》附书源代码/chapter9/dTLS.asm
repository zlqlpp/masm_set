;------------------------
; ��̬TLS��ʾ
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

MAX_THREAD_COUNT equ 4

;���ݶ�
    .data
hTlsIndex  dd  ?
dwThreadID dd  ?
hThreadID  dd  MAX_THREAD_COUNT dup(0)

dwCount    dd  ?

szBuffer   db  500 dup(0)
szOut1     db  '�߳�%d��ֹ����ʱ��%d���롣',0
szErr1     db  '��ȡTLS������ʱʧ�ܣ�',0
szErr2     db  'д��TLS������ʱʧ�ܣ�',0



;�����
    .code

;----------
; ��ʼ��
;----------
_initTime  proc  
   local @dwStart

   pushad

   ;��õ�ǰʱ�䣬
   ;���̵߳Ĵ���ʱ�����̶߳��������
   invoke GetTickCount
   mov @dwStart,eax
   invoke TlsSetValue,hTlsIndex,@dwStart
   .if eax==0
     invoke MessageBox,NULL,addr szErr2,\
                                NULL,MB_OK
   .endif
   popad
   ret
_initTime endp

;----------
; ��ȡ��ʱ
;----------
_getLostTime  proc  
   local @dwTemp
   pushad

   ;��õ�ǰʱ�䣬
   ;���ص�ǰʱ����̴߳���ʱ��Ĳ�ֵ
   invoke GetTickCount
   mov @dwTemp,eax
   invoke TlsGetValue,hTlsIndex
   .if eax==0
     invoke MessageBox,NULL,addr szErr2,\
                                NULL,MB_OK
   .endif
   sub @dwTemp,eax
   popad
   mov eax,@dwTemp
   ret
_getLostTime endp


;----------
; �̺߳���
;----------
_tFun   proc  uses ebx ecx edx esi edi,lParam
   local @dwCount
   local @tID
   pushad

   invoke _initTime

   ;ģ���ʱ����
   mov @dwCount,1000*10000
   mov ecx,@dwCount
   .while ecx>0
     dec @dwCount
     dec ecx
   .endw 

   invoke GetCurrentThreadId
   mov @tID,eax
   invoke _getLostTime
   invoke wsprintf,addr szBuffer,\
                    addr szOut1,@tID,eax
   invoke MessageBox,NULL,addr szBuffer,\
                               NULL,MB_OK

   popad
   ret
_tFun   endp


start:
  ;ͨ���ڽ���λ����������һ��������
  ;��ʼ���߳�����ʱ���¼ϵͳ
  invoke TlsAlloc
  mov hTlsIndex,eax

  mov dwCount,MAX_THREAD_COUNT
  mov edi,offset hThreadID
  .while  dwCount>0
     invoke  CreateThread,NULL,0,\
                offset _tFun,NULL,\
                NULL,addr dwThreadID
     mov dword ptr [edi],eax
     add edi,4

     dec dwCount
  .endw
  
  ;�ȴ������߳�
  mov dwCount,MAX_THREAD_COUNT
  mov edi,offset hThreadID
  .while  dwCount>0
     mov eax,dword ptr [edi]
     mov dwThreadID,eax
     push edi
     invoke WaitForSingleObject,eax,\
                              INFINITE
     invoke CloseHandle,dwThreadID
     pop edi

     add edi,4
     dec dwCount
  .endw

  ;ͨ���ͷ��ֲ߳̾��洢������
  ;�ͷ�ʱ���¼ϵͳռ�õ���Դ
  invoke TlsFree,hTlsIndex

  end start
