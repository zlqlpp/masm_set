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

;��������
_QLGetProcAddress typedef proto :dword,:dword   
;������������   
_ApiGetProcAddress  typedef ptr _QLGetProcAddress  

_QLLoadLib        typedef proto :dword
_ApiLoadLib       typedef ptr _QLLoadLib

_QLMessageBoxA    typedef proto :dword,:dword,:dword,:dword
_ApiMessageBoxA   typedef ptr _QLMessageBoxA


.data
hInstance   dd ?
hProcess    dd 0
hProcessID  dd 0
phwnd       dd ?
hRichEdit   dd ?
hWinMain    dd ?
hWinEdit    dd ?
lpRemote    dd ?
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

.const
szErr1       db 'Error happend when openning.',0
szErr2       db 'Error happend when reading.',0
szErr3       db 'Error happend when getting address.',0

szDllEdit   db 'RichEd20.dll',0
szClassEdit db 'RichEdit20A',0
szFont      db '����',0
szTitle     db 'PEInfo by qixiaorui',0

.code

REMOTE_THREAD_START equ this byte
;------------------------------------
; ��ȡkernel32.dll�Ļ���ַ
;------------------------------------
_getKernelBase  proc
   local @dwRet

   pushad

   assume fs:nothing
   mov eax,fs:[30h] ;��ȡPEB���ڵ�ַ
   mov eax,[eax+0ch] ;��ȡPEB_LDR_DATA �ṹָ��
   mov esi,[eax+1ch] ;��ȡInInitializationOrderModuleList ����ͷ
   ;��һ��LDR_MODULE�ڵ�InInitializationOrderModuleList��Ա��ָ��
   lodsd             ;��ȡ˫������ǰ�ڵ��̵�ָ��
   mov eax,[eax+8]   ;��ȡkernel32.dll�Ļ���ַ
   mov @dwRet,eax
   popad
   mov eax,@dwRet
   ret
_getKernelBase  endp   

;-------------------------------
; ��ȡָ���ַ�����API�����ĵ��õ�ַ
; ��ڲ�����_hModuleΪ��̬���ӿ�Ļ�ַ
;           _lpApiΪAPI����������ַ
; ���ڲ�����eaxΪ�����������ַ�ռ��е���ʵ��ַ
;-------------------------------
_getApi proc _hModule,_lpApi
   local @ret
   local @dwLen

   pushad
   mov @ret,0
   ;����API�ַ����ĳ��ȣ���������
   mov edi,_lpApi
   mov ecx,-1
   xor al,al
   cld
   repnz scasb
   mov ecx,edi
   sub ecx,_lpApi
   mov @dwLen,ecx

   ;��pe�ļ�ͷ������Ŀ¼��ȡ�������ַ
   mov esi,_hModule
   add esi,[esi+3ch]
   assume esi:ptr IMAGE_NT_HEADERS
   mov esi,[esi].OptionalHeader.DataDirectory.VirtualAddress
   add esi,_hModule
   assume esi:ptr IMAGE_EXPORT_DIRECTORY

   ;���ҷ������Ƶĵ���������
   mov ebx,[esi].AddressOfNames
   add ebx,_hModule
   xor edx,edx
   .repeat
     push esi
     mov edi,[ebx]
     add edi,_hModule
     mov esi,_lpApi
     mov ecx,@dwLen
     repz cmpsb
     .if ZERO?
       pop esi
       jmp @F
     .endif
     pop esi
     add ebx,4
     inc edx
   .until edx>=[esi].NumberOfNames
   jmp _ret
@@:
   ;ͨ��API����������ȡ��������ٻ�ȡ��ַ����
   sub ebx,[esi].AddressOfNames
   sub ebx,_hModule
   shr ebx,1
   add ebx,[esi].AddressOfNameOrdinals
   add ebx,_hModule
   movzx eax,word ptr [ebx]
   shl eax,2
   add eax,[esi].AddressOfFunctions
   add eax,_hModule
   
   ;�ӵ�ַ��õ����������ĵ�ַ
   mov eax,[eax]
   add eax,_hModule
   mov @ret,eax

_ret:
   assume esi:nothing
   popad
   mov eax,@ret
   ret
_getApi endp

_remoteThread  proc uses ebx edi esi lParam 
    
    call @F   ; ��ȥ�ض�λ
@@:
    pop ebx
    sub ebx,offset @B

    ;��ȡkernel32.dll�Ļ���ַ
    invoke _getKernelBase
    mov [ebx+offset hKernel32Base],eax

    ;�ӻ���ַ��������GetProcAddress��������ַ
    mov eax,offset szGetProcAddr
    add eax,ebx

    mov edi,offset hKernel32Base
    mov ecx,[ebx+edi]


    invoke _getApi,ecx,eax
    mov [ebx+offset lpGetProcAddr],eax

    ;Ϊ�������ø�ֵ GetProcAddress
    mov [ebx+offset _getProcAddress],eax   

    ;ʹ��GetProcAddress��������ַ
    ;����������������GetProcAddress���������LoadLibraryA����ַ
    mov eax,offset szLoadLib
    add eax,ebx
   
    mov edi,offset hKernel32Base
    mov ecx,[ebx+edi]
    
    mov edx,offset _getProcAddress
    add edx,ebx
    
    ;ģ�µ��� invoke GetProcAddress,hKernel32Base,addr szLoadLib
    push eax
    push ecx
    call dword ptr [edx]   

    mov [ebx+offset _loadLibrary],eax

    ;ʹ��LoadLibrary��ȡuser32.dll�Ļ���ַ

    mov eax,offset user32_DLL
    add eax,ebx

    mov edi,offset _loadLibrary
    mov edx,[ebx+edi]
    
    push eax
    call edx   ; invoke LoadLibraryA,addr _loadLibrary

    mov [ebx+offset hUser32Base],eax

    ;ʹ��GetProcAddress��������ַ����ú���MessageBoxA����ַ
    mov eax,offset szMessageBox
    add eax,ebx
   
    mov edi,offset hUser32Base
    mov ecx,[ebx+edi]
    
    mov edx,offset _getProcAddress
    add edx,ebx


    ;ģ�µ��� invoke GetProcAddress,hUser32Base,addr szMessageBox
    push eax
    push ecx
    call dword ptr [edx]   
    mov [ebx+offset _messageBox],eax

    ;���ú���MessageBoxA
    mov eax,offset szText
    add eax,ebx

    mov edx,offset _messageBox
    add edx,ebx

    ;ģ�µ��� invoke MessageBoxA,NULL,addr szText,NULL,MB_OK    
    push MB_OK
    push NULL
    push eax
    push NULL
    call dword ptr [edx]   
    ret
_remoteThread endp

;------------------------------------------------
; Զ���߳��õ�������
;------------------------------------------------
szText         db  'HelloWorldPE',0
szGetProcAddr  db  'GetProcAddress',0
szLoadLib      db  'LoadLibraryA',0
szMessageBox   db  'MessageBoxA',0

user32_DLL     db  'user32.dll',0,0

;���庯��
_getProcAddress _ApiGetProcAddress  ?             
_loadLibrary    _ApiLoadLib         ?
_messageBox     _ApiMessageBoxA     ?


hKernel32Base   dd  ?
hUser32Base     dd  ?
lpGetProcAddr   dd  ?
lpLoadLib       dd  ?

REMOTE_THREAD_END equ this byte
REMOTE_THREAD_SIZE=offset REMOTE_THREAD_END-offset REMOTE_THREAD_START

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
; ��Զ���̴߳򵽽���PEInfo.exe��
; ���Է�������������PEInfo.exe
; �����ó���,������һ���˵��ĵ�һ��
; �ᷢ�������ϵ���HelloWorldPE�Ի���
;--------------------
_patchPEInfo  proc
  local @dwTemp

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

  ;����ռ�
  invoke VirtualAllocEx,hProcess,NULL,\
               REMOTE_THREAD_SIZE,MEM_COMMIT,\
               PAGE_EXECUTE_READWRITE
  .if eax
      mov lpRemote,eax
      ;д���̴߳���
      invoke WriteProcessMemory,hProcess,\
                       lpRemote,\
                       offset REMOTE_THREAD_START,\
                       REMOTE_THREAD_SIZE,\
                       addr @dwTemp
      mov eax,lpRemote
      add eax,offset _remoteThread-offset REMOTE_THREAD_START
      invoke CreateRemoteThread,hProcess,NULL,0,eax,0,0,NULL
  .endif

  invoke CloseHandle,hProcess

@ret:
  popad
  ret
_patchPEInfo  endp


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
    .elseif eax==IDM_OPEN   ;ֹͣ
      invoke _patchPEInfo
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
