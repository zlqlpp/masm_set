;------------------------
; �����쳣����
; ����
; 2011.1.19
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
szErr      db  'SEH Error',0
;�����
    .code

_handler proc _lpException,_lpSEH,\
             _lpContext,_lpDispatcherContext
  nop
  pushad
  mov esi,_lpException
  mov edi,_lpContext
   
  assume edi:ptr CONTEXT

  invoke MessageBox,NULL,addr szErr,NULL,MB_OK

  mov [edi].regEip,offset _safePlace
  assume edi:nothing

  popad  

  ;����һ
  ;�������쳣�ѱ��ú����ӹ�
  mov eax,ExceptionContinueExecution

  ;���Զ�
  ;�������쳣δ���ú����ӹ�
  ;mov eax,ExceptionContinueSearch
  ret
_handler endp

start:
    assume fs:nothing
    push offset _handler
    push fs:[0]
    mov fs:[0],esp

    xor eax,eax
    mov dword ptr [eax],eax

_safePlace:

    pop fs:[0]
    pop eax

    invoke MessageBox,NULL,addr szText,NULL,MB_OK
    invoke ExitProcess,NULL
    end start