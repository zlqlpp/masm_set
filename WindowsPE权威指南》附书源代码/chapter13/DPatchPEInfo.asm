.386
.model flat,stdcall
option casemap:none

include    windows.inc
include    user32.inc
includelib user32.lib
include    kernel32.inc
includelib kernel32.lib
include    comdlg32.inc
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
IDB_UPDATE equ 5000
UPDATE     equ 6000

STOP_FLAG_POSITION=00404115h
MAJOR_IMAGE_VERSION=1
MINOR_IMAGE_VERSION=0

_QLSuspend typedef proto :dword      ;��������
_QLResume  typedef proto :dword      ;��������

_ApiSuspend  typedef ptr _QLSuspend  ;������������
_ApiResume  typedef ptr _QLResume  ;������������

.data
hInstance   dd ?
hProcess    dd 0
hProcessID  dd 0
phwnd       dd ?
hRichEdit   dd ?
hWinMain    dd ?
hWinEdit    dd ?
szFileName  db MAX_PATH dup(?)
strTitle    db  256 dup(0)
parent      dd 0
szBuffer    db  256 dup(0)
dwPatchDD   dd 1
dwFlag      dd 0
szOut1      db '����ID=%d',0
szOut2      db '���̺�=%d',0
szOut3      db '����ID=%d',0
szOut       db '�ӽ���PEInfo.exe��ȡ���ı�־λ��ֵΪ��%08x',0

hNtdll      dd   ?
_suspendProcess _ApiSuspend ?
_resumeProcess  _ApiResume ?

stStartUp	STARTUPINFO		<?>
stProcInfo	PROCESS_INFORMATION	<?> 
hRes        dd ?
hFile       dd ?
dwResSize   dd ?
lpRes       dd ?

.const
szErr1       db 'Error happend when openning.',0
szErr2       db 'Error happend when reading.',0
szErr3       db 'Error happend when getting address.',0

szDllEdit   db 'RichEd20.dll',0
szClassEdit db 'RichEdit20A',0
szFont      db '����',0
szTitle     db 'PEInfo by qixiaorui',0

szNtdll     db 'ntdll.dll',0
szSuspend   db 'ZwSuspendProcess',0
szResume    db 'ZwResumeProcess',0

szSrcName   db 'update.exe',0


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

;--------------------
; д�ڴ�ʾ��
; ���Է�������������PEInfo.exe
;           ��ʾKernel32.dll����Ϣ
; �����ó���,��kernel32.dll��ʾ�ض�λʱ�����˵���һ��
; �ᷢ��PEInfo.exe�ı����ض�λ��Ϣ����ֹ
;--------------------
_writeToPEInfo  proc
  pushad

  ;ͨ�������ý��̵�handle
  invoke GetDesktopWindow
  invoke GetWindow,eax,GW_CHILD
  invoke GetWindow,eax,GW_HWNDFIRST
  mov phwnd,eax
  invoke GetParent,eax
  .if !eax
    mov parent,1
  .endif

  mov eax,phwnd
  .while eax
     .if parent
         mov parent,0   ;��λ��־
         ;�õ����ڱ�������
         invoke GetWindowText,phwnd,addr strTitle,\
                               sizeof strTitle
         nop
         invoke lstrcmp,addr strTitle,addr szTitle
         .if  !eax
           mov eax,phwnd
           .break
         .endif
     .endif

     ;Ѱ��������ڵ���һ���ֵܴ���
     invoke GetWindow,phwnd,GW_HWNDNEXT 
     mov phwnd,eax
     invoke GetParent,eax
     .if !eax
       invoke IsWindowVisible,phwnd
       .if eax
          mov parent,1
       .endif
     .endif
     mov eax,phwnd
  .endw

  ;mov eax,phwnd  
  ;invoke wsprintf,addr szBuffer,addr szOut1,eax
  ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK

  ;���ݴ��ھ����ȡ����ID
  invoke GetWindowThreadProcessId,phwnd,addr hProcessID

  ;mov eax,hProcessID
  ;invoke wsprintf,addr szBuffer,addr szOut2,eax
  ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK

  invoke OpenProcess,PROCESS_ALL_ACCESS,\
                     FALSE,hProcessID
  .if !eax
    invoke MessageBox,NULL,addr szErr1,NULL,MB_OK
    jmp @ret
  .endif
  mov hProcess,eax  ;�ҵ��Ľ��̾����hProcess��


  ;invoke wsprintf,addr szBuffer,addr szOut3,eax
  ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK


  ;�����̹���
  ;invoke _suspendProcess,hProcess

  ;���ڴ�
  invoke ReadProcessMemory,hProcess,STOP_FLAG_POSITION,\
                       addr dwFlag,4,NULL
  .if eax
    ;mov eax,dwFlag  
    ;invoke wsprintf,addr szBuffer,addr szOut,eax
    ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK

    ;д�ڴ棬����־λ��ֵ
    invoke WriteProcessMemory,hProcess,\
                       STOP_FLAG_POSITION,\
                       addr dwPatchDD,4,NULL
  .else
    invoke MessageBox,NULL,addr szErr2,NULL,MB_OK
    jmp @ret
  .endif

  ;�������̵�����
  ;invoke _resumeProcess,hProcess
  invoke CloseHandle,hProcess

@ret:
  popad
  ret
_writeToPEInfo  endp

;--------------------------
; �ͷ���Դ
;--------------------------
_createDll proc _hInstance
  local @dwWritten

  pushad

  ;Ѱ����Դ
  invoke FindResource,_hInstance,IDB_UPDATE,UPDATE
  .if eax
    mov hRes,eax
    invoke SizeofResource,_hInstance,eax ;��ȡ��Դ�ߴ�
    mov dwResSize,eax
    invoke LoadResource,_hInstance,hRes ;װ����Դ
    .if eax
         invoke LockResource,eax ;������Դ
         .if eax
             mov lpRes,eax  ;����Դ�ڴ��ַ��lpRes

             ;���ļ�д��
             invoke CreateFile,addr szSrcName,GENERIC_WRITE,\
                                            FILE_SHARE_READ,\
                          0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
             mov hFile,eax
             invoke WriteFile,hFile,lpRes,dwResSize,\
                                        addr @dwWritten,NULL
             invoke CloseHandle,hFile      
         .endif
    .endif
  .endif
  popad
  ret
_createDll endp
;-------------------
; ���ڳ���
;-------------------
_ProcDlgMain proc uses ebx edi esi hWnd,wMsg,wParam,lParam
  local @value

  mov eax,wMsg
  .if eax==WM_CLOSE
    invoke EndDialog,hWnd,NULL
  .elseif eax==WM_INITDIALOG  ;��ʼ��
    push hWnd
    pop hWinMain
    call _init
  .elseif eax==WM_COMMAND  ;�˵�
    mov eax,wParam
    .if eax==IDM_EXIT       ;�˳�
      invoke EndDialog,hWnd,NULL 
    .elseif eax==IDM_OPEN   ;ֹͣ
      invoke _writeToPEInfo
    .elseif eax==IDM_1      ;����
      ;д����������
      invoke GetWindowThreadProcessId,hWnd,addr @value
      mov eax,@value

      mov ebx,0040528eh
      mov dword ptr [ebx],eax
    
      mov ax,MAJOR_IMAGE_VERSION
      mov word ptr [ebx+4],ax
      mov ax,MINOR_IMAGE_VERSION
      mov word ptr [ebx+6],ax

      ;�ͷ�update.exe����
      invoke _createDll,hInstance

      ;����update.exe����
      invoke GetStartupInfo,addr stStartUp
      invoke CreateProcess,NULL,addr szSrcName,NULL,NULL,\
                      NULL,NORMAL_PRIORITY_CLASS,NULL,NULL,\
                      offset stStartUp,offset stProcInfo 

    .elseif eax==IDM_2
    .elseif eax==IDM_3
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

  invoke LoadLibrary,offset szNtdll
  mov hNtdll,eax
  invoke GetProcAddress,hNtdll,addr szSuspend
  mov _suspendProcess,eax

  .if !eax
    invoke MessageBox,NULL,addr szErr3,NULL,MB_OK
  .endif

  invoke GetProcAddress,hNtdll,addr szResume
  mov _resumeProcess,eax

  .if !eax
    invoke MessageBox,NULL,addr szErr3,NULL,MB_OK
  .endif


  invoke GetModuleHandle,NULL
  mov hInstance,eax
  invoke DialogBoxParam,hInstance,\
         DLG_MAIN,NULL,offset _ProcDlgMain,NULL
  invoke FreeLibrary,hRichEdit
  invoke ExitProcess,NULL
  end start
