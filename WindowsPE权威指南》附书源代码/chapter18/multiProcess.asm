;------------------------------------
; ����ִ�ж�����̵��ļ�
; multiProcess.asm
;-------------------------------------

.386
.model flat,stdcall
option casemap:none

include    windows.inc
include    user32.inc
include    kernel32.inc
include    winResult.inc
includelib user32.lib
includelib kernel32.lib
includelib winResult.lib



TOTAL_FILE_COUNT  equ   100        ;�����������ļ��������
BinderFileStruct  STRUCT
  inExeSequence   byte   ?         ;Ϊ0��ʾ��ִ���ļ���Ϊ1��ʾ����ִ������
  dwFileOff       dword   ?        ;�������е���ʼƫ��
  dwFileSize      dword    ?       ;�ļ���С
  name            db   256 dup(0)  ;�ļ���������Ŀ¼
BinderFileStruct  ENDS


.data
hRunThread  dd ?
stStartUp	STARTUPINFO		<?>
stProcInfo	PROCESS_INFORMATION	<?> 

dwTotalFile     dd  TOTAL_FILE_COUNT    ;�ļ�����
bindFileList    BinderFileStruct TOTAL_FILE_COUNT dup(<?>)

.const
szExeFile   db 'd:\masm32\source\chapter15\notepad.exe',0
szExeFile1  db 'd:\masm32\source\chapter15\mspaint.exe',0


.code

;------------------------------------------
; ִ�г����õ��߳�
; 1. �� CreateProcess ��������
; 2. �� WaitForSingleOject �ȴ����̽���
;-------------------------------------------
_RunThread	proc	uses ebx ecx edx esi edi,\
		dwParam:DWORD
   pushad
   invoke GetStartupInfo,addr stStartUp
   invoke CreateProcess,NULL,addr szExeFile,NULL,NULL,\
            NULL,NORMAL_PRIORITY_CLASS,NULL,NULL,offset stStartUp,offset stProcInfo
   .if eax!=0
     invoke WaitForSingleObject,stProcInfo.hProcess,INFINITE
     invoke CloseHandle,stProcInfo.hProcess
     invoke CloseHandle,stProcInfo.hThread
   .endif
   invoke GetStartupInfo,addr stStartUp
   invoke CreateProcess,NULL,addr szExeFile1,NULL,NULL,\
            NULL,NORMAL_PRIORITY_CLASS,NULL,NULL,offset stStartUp,offset stProcInfo
   .if eax!=0
     invoke WaitForSingleObject,stProcInfo.hProcess,INFINITE
     invoke CloseHandle,stProcInfo.hProcess
     invoke CloseHandle,stProcInfo.hThread
   .endif
   popad
   ret
_RunThread	endp

start:
  invoke  CreateThread,NULL,NULL,offset _RunThread,\
                  NULL,NULL,offset hRunThread
  end start