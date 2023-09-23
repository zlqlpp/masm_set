;------------------------------------
; �����ǰĿ¼�������ļ���������Ŀ¼��
;-------------------------------------

.386
.model flat,stdcall
option casemap:none

include    windows.inc
include    user32.inc
include    kernel32.inc
include    shell32.inc
include    winResult.inc
include    comdlg32.inc

includelib user32.lib
includelib kernel32.lib
includelib shell32.lib
includelib winResult.lib
includelib comdlg32.lib

ICO_MAIN equ 1000
DLG_MAIN equ 1000
IDC_INFO equ 1001
IDM_MAIN equ 2000
IDM_OPEN equ 2001
IDM_EXIT equ 2002
IDM_1    equ 4000
IDM_2    equ 4001
IDM_3    equ 4002

.data
szPath     db    'c:\ql',256 dup(0)
szBuffer   db    1024 dup(0)
szExeFileName   db  'c:\ql\txt\123456.txt',0

hInstance   dd ?
hRichEdit   dd ?
hWinMain    dd ?
hWinEdit    dd ?
dwOption    db ?
dwFileSizeHigh dd ?
dwFileSizeLow dd ?
dwFileCount dd ?
dwFolderCount dd ?

F_SEARCHING equ 0001h
F_STOP  equ 0002h

szFileName  db MAX_PATH dup(?)

szOut1      db '�ļ�����Ϊ��%s',0dh,0ah,0
szOut2      db '�ļ���С���� %d �ֽ�',0dh,0ah,0
szOut3      db 'Ŀ¼�������ļ����ܴ�СΪ%08x%08x��',0dh,0ah,0
szOut4      db 'Ҫ������Ŀ¼��%s',0dh,0ah,0dh,0ah,0
szStart  db '��ʼ(&S)',0
szStop  db 'ֹͣ(&S)',0
szFilter db '*.*',0
szSearchInfo db '���ҵ� %d ���ļ��У�%d ���ļ����� %luK �ֽ�',0

.const
szDllEdit   db 'RichEd20.dll',0
szClassEdit db 'RichEdit20A',0
szFont      db '����',0
szExtPe     db 'PE File',0,'*.exe;*.dll;*.scr;*.fon;*.drv',0
            db 'All Files(*.*)',0,'*.*',0,0
szErr       db '�ļ���ʽ����!',0
szErrFormat db '����ļ�����PE��ʽ���ļ�!',0
szSuccess   db '��ϲ�㣬����ִ�е������ǳɹ��ġ�',0
szNotFound  db '�޷�����',0
szCrLf      db 0dh,0ah,0


.code
;----------------
;��ʼ�����ڳ���
;----------------
_init proc
  local @stCf:CHARFORMAT
  
  invoke GetDlgItem,hWinMain,IDC_INFO
  mov hWinEdit,eax
  invoke LoadIcon,hInstance,ICO_MAIN
  invoke SendMessage,hWinMain,WM_SETICON,ICON_BIG,eax       ;Ϊ��������ͼ��
  invoke SendMessage,hWinEdit,EM_SETTEXTMODE,TM_PLAINTEXT,0 ;���ñ༭�ؼ�
  invoke RtlZeroMemory,addr @stCf,sizeof @stCf
  mov @stCf.cbSize,sizeof @stCf
  mov @stCf.yHeight,9*20
  mov @stCf.dwMask,CFM_FACE or CFM_SIZE or CFM_BOLD
  invoke lstrcpy,addr @stCf.szFaceName,addr szFont
  invoke SendMessage,hWinEdit,EM_SETCHARFORMAT,0,addr @stCf
  invoke SendMessage,hWinEdit,EM_EXLIMITTEXT,0,-1
  ret
_init endp

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
; ���ı�����׷���ı�
;---------------------
_appendInfo proc _lpsz
  local @stCR:CHARRANGE

  pushad
  invoke GetWindowTextLength,hWinEdit
  mov @stCR.cpMin,eax  ;��������ƶ������
  mov @stCR.cpMax,eax
  invoke SendMessage,hWinEdit,EM_EXSETSEL,0,addr @stCR
  invoke SendMessage,hWinEdit,EM_REPLACESEL,FALSE,_lpsz
  popad
  ret
_appendInfo endp

;---------------------------
; �ж��ļ��Ƿ�ΪEXE�ļ������ݺ�׺
;---------------------------
_isExeFile  proc  _lpFileName
  local @szFile[20]:byte
  local @ret

  pushad
  lea edi,@szFile
  mov al,'.'
  stosb
  mov al,'e'
  stosb
  mov al,'x'
  stosb
  mov al,'e'
  stosb
  mov al,0
  stosb

  invoke lstrlen,_lpFileName
  sub eax,4
  mov esi,_lpFileName
  add esi,eax

  lea edi,@szFile
  invoke lstrcmp,esi,edi
  .if !eax  ;���
     mov @ret,1    
  .else
     mov @ret,0
  .endif   
  popad
  mov eax,@ret
  ret
_isExeFile  endp

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
  invoke wsprintf,addr szBuffer,addr szOut1,esi
  invoke _appendInfo,addr szBuffer
  inc dwFileCount
  invoke CreateFile,_lpszFile,GENERIC_READ,FILE_SHARE_READ,0,\
   OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
  .if eax != INVALID_HANDLE_VALUE
   mov @hFile,eax
   invoke GetFileSize,eax,NULL
   pushad
   invoke wsprintf,addr szBuffer,addr szOut2,eax
   invoke _appendInfo,addr szBuffer
   invoke _appendInfo,addr szCrLf
   popad

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

;-------------------
; ���ڳ���
;-------------------
_ProcDlgMain proc uses ebx edi esi hWnd,wMsg,wParam,lParam
  mov eax,wMsg
  .if eax==WM_CLOSE
    invoke EndDialog,hWnd,NULL
  .elseif eax==WM_INITDIALOG  ;��ʼ��
    push hWnd
    pop hWinMain
    call _init
  .elseif eax==WM_COMMAND     ;�˵�
    mov eax,wParam
    .if eax==IDM_EXIT       ;�˳�
      invoke EndDialog,hWnd,NULL 
    .elseif eax==IDM_OPEN   ;���ļ�
      invoke wsprintf,addr szBuffer,addr szOut4,addr szPath
      invoke _appendInfo,addr szBuffer
      invoke _FindFile,addr szPath
      invoke _appendInfo,addr szCrLf
      invoke wsprintf,addr szBuffer,addr szOut3,dwFileSizeHigh,dwFileSizeLow
      invoke _appendInfo,addr szBuffer
    .elseif eax==IDM_1  ;���������˵���7��Ķ�����ɵģ���
      invoke MessageBox,NULL,offset szErrFormat,offset szErr,MB_ICONWARNING
    .elseif eax==IDM_2
      invoke MessageBox,NULL,offset szErrFormat,offset szErr,MB_ICONQUESTION	
    .elseif eax==IDM_3
      nop
      invoke _isExeFile,addr szExeFileName
    .endif
  .else
    mov eax,FALSE
    ret
  .endif
  mov eax,TRUE
  ret
_ProcDlgMain endp
start:
  invoke LoadLibrary,offset szDllEdit
  mov hRichEdit,eax
  invoke GetModuleHandle,NULL
  mov hInstance,eax
  invoke DialogBoxParam,hInstance,\
         DLG_MAIN,NULL,offset _ProcDlgMain,NULL
  invoke FreeLibrary,hRichEdit
  invoke ExitProcess,NULL
  end start



