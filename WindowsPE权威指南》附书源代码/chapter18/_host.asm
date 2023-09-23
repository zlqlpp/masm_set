;------------------------------------
; ��������
;-------------------------------------

.386
.model flat,stdcall
option casemap:none

include    windows.inc
include    user32.inc
include    kernel32.inc
include    gdi32.inc
include    comctl32.inc
include    comdlg32.inc
include    advapi32.inc
include    shell32.inc
include    masm32.inc
include    netapi32.inc
include    winmm.inc
include    ws2_32.inc
include    psapi.inc
include    mpr.inc        ;WNetCancelConnection2
include    iphlpapi.inc   ;SendARP
include    winResult.inc
includelib comctl32.lib
includelib comdlg32.lib
includelib gdi32.lib
includelib user32.lib
includelib kernel32.lib
includelib advapi32.lib
includelib shell32.lib
includelib masm32.lib
includelib netapi32.lib
includelib winmm.lib
includelib ws2_32.lib
includelib psapi.lib
includelib mpr.lib
includelib iphlpapi.lib
includelib winResult.lib



TOTAL_FILE_COUNT  equ   100        ;�����������ļ��������
BinderFileStruct  STRUCT
  inExeSequence   byte   ?         ;Ϊ0��ʾ��ִ���ļ���Ϊ1��ʾ����ִ������
  dwFileOff       dword   ?        ;�������е���ʼƫ��
  dwFileSize      dword    ?       ;�ļ���С
  name1           db   256 dup(0)  ;�ļ���������Ŀ¼
BinderFileStruct  ENDS


.data
hRunThread  dd ?
dwFileSizeHigh dd ?
dwFileSizeLow dd ?
dwFileCount dd ?
dwFolderCount dd ?
dwFileSize    dd ?
dwFileOff     dd ?

szFilter   db '*.*',0
szXie      db '\',0
szPath     db 'c:\ql',256 dup(0)
szBuffer   db 1024 dup(0)
szHost     db 'host.exe',0    ;��������
szHost_    db '_host.exe',0   ;�ͷų������ļ�

szTemp     db 'a\b\c\abc.exe',0

stStartUp	STARTUPINFO		<?>
stProcInfo	PROCESS_INFORMATION	<?> 

;����Ϊ�����б����ݽṹ��һ���ļ�������˫�ֺͶ��BinderFileStruct�ṹ
dwFlag          dd  0ffffffffh,0ffffffffh,0ffffffffh,0ffffffffh
dwTotalFile     dd  TOTAL_FILE_COUNT    ;�ļ�����
lpFileList      BinderFileStruct TOTAL_FILE_COUNT dup(<?>)
szBuffer1       db  256 dup(0)

.code
;------------------
; ����Handler
;------------------
_Handler proc _lpExceptionRecord,_lpSEH,\
              _lpContext,_lpDispathcerContext

  pushad
  mov esi,_lpExceptionRecord
  mov edi,_lpContext
  assume esi:ptr EXCEPTION_RECORD,edi:ptr CONTEXT
  mov eax,_lpSEH
  push [eax+0ch]
  pop [edi].regEbp
  push [eax+8]
  pop [edi].regEip
  push eax
  pop [edi].regEsp
  assume esi:nothing,edi:nothing
  popad
  mov eax,ExceptionContinueExecution
  ret
_Handler endp

;---------------------
; �����ҵ����ļ�
;---------------------
_ProcessFile proc _lpszFile
  local @hFile

  invoke lstrlen,addr szPath
  mov esi,eax
  add esi,_lpszFile
  mov al,byte ptr [esi]
  .if al==5ch
    inc esi
  .endif
  inc dwFileCount
  invoke CreateFile,_lpszFile,GENERIC_READ,FILE_SHARE_READ,0,\
   OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
  .if eax != INVALID_HANDLE_VALUE
   mov @hFile,eax
   invoke GetFileSize,eax,NULL

   add dwFileSizeLow,eax
   adc dwFileSizeHigh,0
   invoke CloseHandle,@hFile
  .endif
  ret

_ProcessFile endp

;----------------------------
; ����ָ��Ŀ¼szPath��
;  (����Ŀ¼)�������ļ�
;------------------------------
_FindFile proc _lpszPath
  local @stFindFile:WIN32_FIND_DATA
  local @hFindFile
  local @szPath[MAX_PATH]:byte     ;������š�·��\��
  local @szSearch[MAX_PATH]:byte   ;������š�·��\*.*��
  local @szFindFile[MAX_PATH]:byte ;������š�·��\�ļ���

  pushad
  invoke lstrcpy,addr @szPath,_lpszPath
  ;��·���������\*.*
@@:
  invoke lstrlen,addr @szPath
  lea esi,@szPath
  add esi,eax
  xor eax,eax
  mov al,'\'
  .if byte ptr [esi-1] != al
   mov word ptr [esi],ax
  .endif
  invoke lstrcpy,addr @szSearch,addr @szPath
  invoke lstrcat,addr @szSearch,addr szFilter
  ;Ѱ���ļ�
  invoke FindFirstFile,addr @szSearch,addr @stFindFile
  .if eax != INVALID_HANDLE_VALUE
   mov @hFindFile,eax
   .repeat
    invoke lstrcpy,addr @szFindFile,addr @szPath
    invoke lstrcat,addr @szFindFile,addr @stFindFile.cFileName
    .if @stFindFile.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY
     .if @stFindFile.cFileName != '.'
      inc dwFolderCount
      invoke _FindFile,addr @szFindFile
     .endif
    .else
     invoke _ProcessFile,addr @szFindFile
    .endif
    invoke FindNextFile,@hFindFile,addr @stFindFile
   .until eax==FALSE
   invoke FindClose,@hFindFile
  .endif
  popad
  ret
_FindFile endp
;------------------------------------------
; ִ�г����õ��߳�
; 1. �� CreateProcess ��������
; 2. �� WaitForSingleOject �ȴ����̽���
;-------------------------------------------
_RunThread	proc	uses ebx ecx edx esi edi,\
		dwParam:DWORD
   pushad
   mov ecx,dwTotalFile
   mov esi,offset lpFileList
   .repeat
      assume esi:ptr BinderFileStruct
      mov al,byte ptr [esi]
      push esi
      .if al==1    ;�ļ���ִ������
        push esi
        invoke GetStartupInfo,addr stStartUp
        pop esi
        invoke CreateProcess,NULL,addr [esi].name1,NULL,NULL,\
              NULL,NORMAL_PRIORITY_CLASS,NULL,NULL,offset stStartUp,offset stProcInfo
        .if eax!=0
          invoke WaitForSingleObject,stProcInfo.hProcess,INFINITE
          invoke CloseHandle,stProcInfo.hProcess
          invoke CloseHandle,stProcInfo.hThread
        .endif
      .endif
      invoke Sleep,1000
      pop esi
      add esi,sizeof BinderFileStruct
      dec dwTotalFile
      .break .if dwTotalFile==0
   .until FALSE
   popad
   ret
_RunThread	endp

start:
  ;��ȡ��ǰĿ¼
  invoke GetCurrentDirectory,256,addr szPath  
  invoke  CreateThread,NULL,NULL,offset _RunThread,\
                  NULL,NULL,offset hRunThread
  end start