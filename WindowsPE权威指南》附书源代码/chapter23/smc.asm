;------------------------
; �����Լ�������
; ����
; 2006.2.28
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
szText        db  "HelloWorldPE", 0 
dwEncrptSize  dd  ? 


     .code

;----------------------
; ���ܽ���ʹ��ͬһ������
;----------------------
_encrptIt proc  _lpSrc,_size
  pushad
  mov esi,_lpSrc
  mov edi,_lpSrc
  mov ecx,_size
loc1:
  mov al,byte ptr [esi]
  xor al,74h  ;�㷨�ܼ򵥣����
  mov byte ptr [edi],al

  inc esi
  inc edi
  dec ecx
  .if ecx!=0
    jmp loc1
  .endif
 
  popad
  ret
_encrptIt endp

_handler proc _lpException,_lpSEH,\
             _lpContext,_lpDispatcherContext
  nop
  pushad
  mov esi,_lpException
  mov edi,_lpContext
   
  assume edi:ptr CONTEXT

  lea eax,_encrptStart
  invoke _encrptIt,eax,dwEncrptSize

  mov [edi].regEip,offset _safePlace
  assume edi:nothing

  popad  

  ;����һ
  ;�������쳣�ѱ��ú����ӹ�
  mov eax,ExceptionContinueExecution
  ret
_handler endp

start:
  assume fs:nothing

  lea eax,_encrptEnd
  lea edx,_encrptStart
  mov ecx,edx
  sub ecx,eax
  mov dwEncrptSize,ecx

  push offset _handler
  push fs:[0]
  mov fs:[0],esp

  xor eax,eax
  mov [eax],eax

_safePlace:

  pop fs:[0]
  pop eax

  lea eax,_encrptStart
  invoke _encrptIt,eax,dwEncrptSize

_encrptStart:
  push MB_OK
  push NULL
  push addr szText
  push NULL
  call MessageBox
_encrptEnd:

  invoke ExitProcess,NULL 

              end start 
