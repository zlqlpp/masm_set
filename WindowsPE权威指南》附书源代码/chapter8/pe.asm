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

include    winResult.inc
includelib winResult.lib


ICO_MAIN equ 1000
DLG_MAIN equ 1000
IDC_INFO equ 1001
IDM_MAIN equ 2000
IDM_OPEN equ 2001
IDM_EXIT equ 2002
IDM_1    equ 4000
IDM_2    equ 4001
IDM_3    equ 4002
IDB_WINRESULT equ 5000
DLLTYPE       equ 6000

.data
hInstance   dd ?
hRichEdit   dd ?
hWinMain    dd ?
hWinEdit    dd ?
szFileName  db MAX_PATH dup(?)

hRes        dd ?
hFile       dd ?
dwResSize   dd ?
lpRes       dd ?



.const
szDllEdit   db 'RichEd20.dll',0
szDllName   db 'winResult.dll',0
szClassEdit db 'RichEdit20A',0
szFont      db '����',0


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
    invoke FadeInOpen,hWinMain
    call _init
  .elseif eax==WM_COMMAND  ;�˵�
    mov eax,wParam
    .if eax==IDM_EXIT       ;�˳�
      invoke EndDialog,hWnd,NULL 
    .elseif eax==IDM_OPEN   ;���ļ�
    .elseif eax==IDM_1  
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


;--------------------------
; ��̬����winResult.dll
;--------------------------
_createDll proc _hInstance
  local @dwWritten

  pushad

  ;Ѱ����Դ
  invoke FindResource,_hInstance,IDB_WINRESULT,DLLTYPE
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
             invoke CreateFile,addr szDllName,GENERIC_WRITE,\
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



start:
  invoke LoadLibrary,offset szDllEdit
  mov hRichEdit,eax
  invoke GetModuleHandle,NULL
  mov hInstance,eax

  invoke _createDll,hInstance  ;��δ����DLL����ǰ���ͷŸ�DLL�ļ�

  invoke DialogBoxParam,hInstance,\
         DLG_MAIN,NULL,offset _ProcDlgMain,NULL
  invoke FreeLibrary,hRichEdit
  invoke ExitProcess,NULL
  end start
