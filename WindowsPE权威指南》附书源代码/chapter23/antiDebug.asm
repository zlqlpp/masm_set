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
szDebugged    db  "�����ڱ�����!", 0  
szNoDebugged  db  "û�б�����!", 0  

     .code
start:
  assume fs:nothing
  ;ָ�� PDB(Process Database)  
  mov eax,fs:[30h]  ;EAXΪTEB.ProcessEnvironmentBlock

  mov eax, [eax+68h]
  and eax, 070h     ;NtGlobalFlags
  test eax, eax
  jne @isDebugged

  invoke MessageBox,NULL,addr szNoDebugged,\
                                      NULL,MB_OK
  jmp @ret

@isDebugged:
  invoke MessageBox,NULL,addr szDebugged,\
                                      NULL,MB_OK
@ret:
  invoke ExitProcess,NULL 

              end start 
