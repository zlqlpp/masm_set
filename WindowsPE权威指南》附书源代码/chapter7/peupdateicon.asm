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

ICON_DIR_ENTRY STRUCT
    bWidth BYTE ?
    bHeight BYTE ?
    bColorCount BYTE ?
    bReserved BYTE ?
    wPlanes WORD ?
    wBitCount WORD ?
    dwBytesInRes DWORD ?
    dwImageOffset DWORD ?
ICON_DIR_ENTRY ENDS
ICON_DIR STRUCT
    idReserved WORD ?
    idType WORD ?
    idCount WORD ?
    ;idEntries ICON_DIR_ENTRY <>
ICON_DIR ENDS
PE_ICON_DIR_ENTRY STRUCT
    bWidth BYTE ?
    bHeight BYTE ?
    bColorCount BYTE ?
    bReserved BYTE ?
    wPlanes WORD ?
    wBitCount WORD ?
    dwBytesInRes DWORD ?
    nID   WORD ?
PE_ICON_DIR_ENTRY ENDS
PE_ICON_DIR STRUCT
    idReserved WORD ?
    idType WORD ?
    idCount WORD ?
    idEntries PE_ICON_DIR_ENTRY <>
PE_ICON_DIR ENDS



.data
hInstance   dd ?
hRichEdit   dd ?
hWinMain    dd ?
hWinEdit    dd ?
szFileName  db MAX_PATH dup(?)
hModule     dd ?
hResInfo    dd ?
hGlobal     dd ?
dwSize      dd ?
lpMemory    dd ?
hUpdate     dd ?
szBuffer    db 512 dup(0)

.const
szDllEdit   db 'RichEd20.dll',0
szClassEdit db 'RichEdit20A',0
szFont      db '����',0
lpszBoyIcon db 'D:\masm32\source\chapter8\boy.ico',0
szOut1      db '%d',0
szExtPe     db 'PE File',0,'*.exe;*.dll;*.scr;*.fon;*.drv',0
            db 'All Files(*.*)',0,'*.*',0,0
szErr       db '�ļ���ʽ����!',0
szErrFormat db '����ļ�����PE��ʽ���ļ�!',0
szFailure   db 'ִ��ͼ���޸�ʧ�ܡ�',0
szSuccess   db '��ϲ�㣬ͼ���޸ĳɹ��ɹ��ġ�',0
szNotFound  db '�޷�����',0


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


;-----------------------------------
;��boy.icoͼ���滻ָ��PE�����ͼ��
;ʹ��win32 api����UpdateResourceʵ�ִ˹���
;-----------------------------------
_doUpdate proc _lpszFile, _lpszExeFile
     local @stID:ICON_DIR
     local @stIDE:ICON_DIR_ENTRY
     local @stGID:PE_ICON_DIR
     local @hFile:DWORD
     local @dwReserved:DWORD
     local @nSize:DWORD
     local @nGSize:DWORD
     local @pIcon:DWORD
     local @pGrpIcon:DWORD
     local @hUpdate:DWORD
     local @ret:DWORD

     invoke CreateFile,_lpszFile,GENERIC_READ,\
               NULL,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL
     mov @hFile,eax
     .if eax==INVALID_HANDLE_VALUE
          xor eax, eax
          ret
     .endif

     invoke RtlZeroMemory,addr @stID,sizeof @stID
     invoke ReadFile,@hFile,addr @stID,sizeof @stID,\
                                   addr @dwReserved,NULL
     invoke RtlZeroMemory,addr @stIDE,sizeof @stIDE
     invoke ReadFile,@hFile,addr @stIDE,sizeof @stIDE,\
                                    addr @dwReserved,NULL

     push @stIDE.dwBytesInRes
     pop @nSize
     invoke GlobalAlloc,GPTR,@nSize 
     mov @pIcon,eax
     invoke SetFilePointer,@hFile,@stIDE.dwImageOffset,\
                                              NULL,FILE_BEGIN
     invoke ReadFile,@hFile,@pIcon,@nSize,\
                                        addr @dwReserved, NULL

     .if eax==0
        jmp _ret
     .endif     

     invoke RtlZeroMemory,addr @stGID,sizeof @stGID
     push @stID.idCount
     pop @stGID.idCount
     mov @stGID.idReserved, 0
     mov @stGID.idType, 1
     invoke RtlMoveMemory,addr @stGID.idEntries,addr @stIDE,12
     mov @stGID.idEntries.nID,0
     mov @nGSize,sizeof @stGID
     invoke GlobalAlloc,GPTR,@nGSize
     mov @pGrpIcon, eax
     invoke RtlMoveMemory,@pGrpIcon,addr @stGID,@nGSize

     ;��ʼ�޸�
     invoke BeginUpdateResource,_lpszExeFile,FALSE
     mov @hUpdate,eax
     nop
     invoke UpdateResource,@hUpdate,RT_GROUP_ICON,1,\
                                 LANG_CHINESE,@pGrpIcon,@nGSize
     invoke UpdateResource,@hUpdate,RT_ICON,1,
                                 LANG_CHINESE,@pIcon,@nSize
     mov @ret, eax
     invoke EndUpdateResource, @hUpdate, FALSE
     .if @ret == FALSE
        invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
        jmp _ret
     .endif

     mov eax, 1
     jmp _exit
_ret:
     invoke GlobalFree,@pIcon
     invoke CloseHandle,@hFile
     xor eax, eax
_exit:
     invoke CloseHandle,@hFile
     ret
_doUpdate endp

;--------------------
; ѡ��PE�ļ�������
;--------------------
_openFile proc
  local @stOF:OPENFILENAME
  local @hFile,@dwFileSize,@hMapFile,@lpMemory

  invoke RtlZeroMemory,addr @stOF,sizeof @stOF
  mov @stOF.lStructSize,sizeof @stOF
  push hWinMain
  pop @stOF.hwndOwner
  mov @stOF.lpstrFilter,offset szExtPe
  mov @stOF.lpstrFile,offset szFileName
  mov @stOF.nMaxFile,MAX_PATH
  mov @stOF.Flags,OFN_PATHMUSTEXIST or OFN_FILEMUSTEXIST
  invoke GetOpenFileName,addr @stOF  ;���û�ѡ��򿪵��ļ�
  .if !eax
    jmp @F
  .endif

  ;��boy.ico��ͼ������д��PE�ļ�

  invoke _doUpdate,addr lpszBoyIcon,addr szFileName
  .if eax
    invoke _appendInfo,addr szSuccess
  .else
    invoke _appendInfo,addr szFailure
  .endif
@@:        
  ret
_openFile endp
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
  .elseif eax==WM_COMMAND  ;�˵�
    mov eax,wParam
    .if eax==IDM_EXIT       ;�˳�
      invoke EndDialog,hWnd,NULL 
    .elseif eax==IDM_OPEN   ;���ļ�
      invoke _openFile
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
