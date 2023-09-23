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

.data
hInstance   dd ?
hRichEdit   dd ?
hWinMain    dd ?
hWinEdit    dd ?
totalSize   dd ?   ; �ļ���С
lpMemory    dd ?   ; �ڴ�ӳ���ļ����ڴ����ʼλ��
szFileName  db MAX_PATH dup(?)               ;Ҫ�򿪵��ļ�·����������


szOut2      db 13,10,'�򿪵��ļ���%s',13,10,13,10,0
szTitle     db '����          FOA       �ܴ�С       ���ÿռ�      ���ÿռ�FOA',13,10
            db '-----------------------------------------------------------------------',13,10
            db 0

szOut       db '%s    %08x   %d(%xh)      %d(%xh)     %08x',13,10,0
szHeader    db '.head',0
szBuffer    db 256 dup(0)


szSection   db 10 dup(0),0  ;����
lpFOA       dd ?            ;FOA
dwTotalSize dd ?            ;�ܴ�С
dwAvailable dd ?            ;���ÿռ�
lpAvailable dd ?            ;���ÿռ�FOA


.const
szDllEdit   db 'RichEd20.dll',0
szClassEdit db 'RichEdit20A',0
szFont      db '����',0
szExtPe     db 'PE File',0,'*.exe;*.dll;*.scr;*.fon;*.drv',0
            db 'All Files(*.*)',0,'*.*',0,0
szErr       db '�ļ���ʽ����!',0
szErrFormat db '����ļ�����PE��ʽ���ļ�!',0

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

;---------------------
; ���ڴ�ƫ����RVAת��Ϊ�ļ�ƫ��
; lp_FileHeadΪ�ļ�ͷ����ʼ��ַ
; _dwRVAΪ������RVA��ַ
;---------------------
_RVAToOffset proc _lpFileHead,_dwRVA
  local @dwReturn
  
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edi,_dwRVA
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  movzx ecx,[esi].FileHeader.NumberOfSections
  ;�����ڱ�
  .repeat
    mov eax,[edx].VirtualAddress
    add eax,[edx].SizeOfRawData        
    ;����ýڽ���RVA��
    ;����Misc����Ҫԭ������Щ�ε�Miscֵ�Ǵ���ģ�
    .if (edi>=[edx].VirtualAddress)&&(edi<eax)
      mov eax,[edx].VirtualAddress
      sub edi,eax                ;����RVA�ڽ��е�ƫ��
      mov eax,[edx].PointerToRawData
      add eax,edi                ;���Ͻ����ļ��еĵ���ʼλ��
      jmp @F
    .endif
    add edx,sizeof IMAGE_SECTION_HEADER
  .untilcxz
  assume edx:nothing
  assume esi:nothing
  mov eax,-1
@@:
  mov @dwReturn,eax
  popad
  mov eax,@dwReturn
  ret
_RVAToOffset endp


;-------------------
; ��λ��PE��ʶ
; _lpHeader ͷ������ַ
; _dwFlag1
;    Ϊ0��ʾ_lpHeader��PEӳ��ͷ
;    Ϊ1��ʾ_lpHeader���ڴ�ӳ���ļ�ͷ 
; _dwFlag2
;    Ϊ0��ʾ����RVA+ģ�����ַ
;    Ϊ1��ʾ����FOA+�ļ�����ַ
;    Ϊ2��ʾ����RVA
;    Ϊ3��ʾ����FOA
; ����eax=PE��ʶ���ڵ�ַ
;
; ע�⣺��_lpHeader��PEӳ��ͷʱ��
;       _dwFlag2Ϊ1��������ģ����Է���FOA
;-------------------
_rPE  proc _lpHeader,_dwFlag1,_dwFlag2
   local @ret
   local @imageBase

   pushad
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew
   mov edi,esi
   assume edi:ptr IMAGE_NT_HEADERS
   mov eax,[edi].OptionalHeader.ImageBase  ;����Ľ���װ�ص�ַ
   mov @imageBase,eax

   .if _dwFlag1==0 ;_lpHeader��PEӳ��ͷ
     .if _dwFlag2==0     ;RVA+ģ�����ַ 
       mov eax,esi
       mov @ret,eax
     .elseif _dwFlag2==1 ;�����壬ֻ����FOA
       sub esi,_lpHeader
       mov eax,esi
       mov @ret,eax
     .else   ;��_dwFlag2=2��3ʱ����ֵ��ͬ
       sub esi,_lpHeader
       mov eax,esi
       mov @ret,eax
     .endif
   .else  ;_lpHeader���ڴ�ӳ���ļ�ͷ
 
     .if _dwFlag2==0     ;RVA+ģ�����ַ 
       sub esi,_lpHeader
       add esi,@imageBase
       mov eax,esi
       mov @ret,eax
     .elseif _dwFlag2==1 ;FOA+�ļ�����ַ
       mov eax,esi
       mov @ret,eax
     .else   ;��_dwFlag2=2��3ʱ����ֵ��ͬ
       sub esi,_lpHeader
       mov eax,esi
       mov @ret,eax
     .endif
   .endif
   popad
   mov eax,@ret
   ret
_rPE endp

;-------------------
; ��λ��ָ������������Ŀ¼���������ݵ���ʼ��ַ
; _lpHeader ͷ������ַ
; _index ����Ŀ¼����������0��ʼ
; _dwFlag1
;    Ϊ0��ʾ_lpHeader��PEӳ��ͷ
;    Ϊ1��ʾ_lpHeader���ڴ�ӳ���ļ�ͷ 
; _dwFlag2
;    Ϊ0��ʾ����RVA+ģ�����ַ
;    Ϊ1��ʾ����FOA+�ļ�����ַ
;    Ϊ2��ʾ����RVA
;    Ϊ3��ʾ����FOA
; ����eax=ָ������������Ŀ¼����������ڵ�ַ
;-------------------
_rDDEntry  proc _lpHeader,_index,_dwFlag1,_dwFlag2
   local @ret,@ret1,@ret2
   local @imageBase
   pushad
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew   ;PE��ʶ
   assume esi:ptr IMAGE_NT_HEADERS
   mov eax,[esi].OptionalHeader.ImageBase  ;����Ľ���װ�ص�ַ
   mov @imageBase,eax

   add esi,0078h ;ָ��DataDirectory
   
   xor eax,eax  ;����*8
   mov eax,_index
   mov bx,8
   mul bx
   mov ebx,eax   
   ; ȡ��ָ����������Ŀ¼���λ��,��RVA
   mov eax,dword ptr [esi][ebx]
   mov @ret1,eax

   .if _dwFlag1==0  ;_lpHeader��PEӳ��ͷ  
     .if _dwFlag2==0     ;RVA+ģ�����ַ
       add eax,_lpHeader 
       mov @ret,eax
     .elseif _dwFlag2==1 ;�����壬����FOA 
       invoke _RVAToOffset,_lpHeader,eax
       mov @ret,eax  
     .elseif _dwFlag2==2 ;RVA
       mov @ret,eax
     .elseif _dwFlag2==3 ;FOA
       invoke _RVAToOffset,_lpHeader,eax
       mov @ret,eax
     .endif
  .else  ;_lpHeader���ڴ�ӳ���ļ�ͷ
     .if _dwFlag2==0     ;RVA+ģ�����ַ
       add eax,@imageBase
       mov @ret,eax
     .elseif _dwFlag2==1 ;FOA+�ļ�����ַ
       ;�Ƚ�RVAת��Ϊ�ļ�ƫ��
       invoke _RVAToOffset,_lpHeader,eax
       mov @ret2,eax  
       add eax,_lpHeader
       mov @ret,eax
     .elseif _dwFlag2==2 ;RVA
       mov @ret,eax
     .elseif _dwFlag2==3 ;FOA
       ;�Ƚ�RVAת��Ϊ�ļ�ƫ��
       invoke _RVAToOffset,_lpHeader,eax
       mov @ret,eax
     .endif
  .endif
   popad
   mov eax,@ret
   ret
_rDDEntry endp

;-------------------
; ��λ��ָ�������Ľڱ���
; _lpHeader ͷ������ַ
; _index ��ʾ�ڼ����ڱ����0��ʼ
; _dwFlag1
;    Ϊ0��ʾ_lpHeader��PEӳ��ͷ
;    Ϊ1��ʾ_lpHeader���ڴ�ӳ���ļ�ͷ 
; _dwFlag2
;    Ϊ0��ʾ����RVA+ģ�����ַ
;    Ϊ1��ʾ����FOA+�ļ�����ַ
;    Ϊ2��ʾ����RVA
;    Ϊ3��ʾ����FOA
; ����eax=ָ�������Ľڱ������ڵ�ַ
;-------------------
_rSection  proc _lpHeader,_index,_dwFlag1,_dwFlag2
   local @ret,@ret1,@ret2
   local @imageBase
   pushad
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew   ;PE��ʶ
   assume esi:ptr IMAGE_NT_HEADERS
   mov eax,[esi].OptionalHeader.ImageBase  ;����Ľ���װ�ص�ַ
   mov @imageBase,eax

   mov eax,[esi].OptionalHeader.NumberOfRvaAndSizes
   mov bx,8
   mul bx
   
   add esi,0078h ;ָ��DataDirectory
   add esi,eax   ;����DataDirectory�Ĵ�С,ָ��ڱ�ʼ
   
   xor eax,eax  ;����*40
   mov eax,_index
   mov bx,40
   mul bx

   add esi,eax   ;���������ڵ�ַ

   .if _dwFlag1==0  ;_lpHeader��PEӳ��ͷ  
     .if _dwFlag2==0     ;RVA+ģ�����ַ
       mov eax,esi 
       mov @ret,eax
     .else
       sub esi,_lpHeader
       mov eax,esi
       mov @ret,eax
     .endif
  .else  ;_lpHeader���ڴ�ӳ���ļ�ͷ
     .if _dwFlag2==0     ;RVA+ģ�����ַ
       sub esi,_lpHeader
       add esi,@imageBase
       mov @ret,eax
     .elseif _dwFlag2==1 ;FOA+�ļ�����ַ
       mov eax,esi
       mov @ret,eax
     .else
       sub esi,_lpHeader
       mov eax,esi
       mov @ret,eax
     .endif
  .endif
   popad
   mov eax,@ret
   ret
_rSection endp

;--------------------
; ��PE�ļ�������
;--------------------
_openFile proc
  local @stOF:OPENFILENAME
  local @hFile,@dwFileSize,@hMapFile,@lpMemory
  local @dwSections
  local @dwTemp,@dwOff

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
  invoke CreateFile,addr szFileName,GENERIC_READ,\
         FILE_SHARE_READ or FILE_SHARE_WRITE,NULL,\
         OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE,NULL
  .if eax!=INVALID_HANDLE_VALUE
    mov @hFile,eax
    invoke GetFileSize,eax,NULL
    mov @dwFileSize,eax
    .if eax
      invoke CreateFileMapping,@hFile,\  ;�ڴ�ӳ���ļ�
             NULL,PAGE_READONLY,0,0,NULL
      .if eax
        mov @hMapFile,eax
        invoke MapViewOfFile,eax,\
               FILE_MAP_READ,0,0,0
        .if eax
          ;����ļ����ڴ��ӳ����ʼλ��
          mov @lpMemory,eax
          assume fs:nothing
          push ebp
          push offset _ErrFormat
          push offset _Handler
          push fs:[0]
          mov fs:[0],esp

          ;���PE�ļ��Ƿ���Ч
          mov esi,@lpMemory
          assume esi:ptr IMAGE_DOS_HEADER

          ;�ж��Ƿ���MZ����
          .if [esi].e_magic!=IMAGE_DOS_SIGNATURE
            jmp _ErrFormat
          .endif

          ;����ESIָ��ָ��PE�ļ�ͷ
          add esi,[esi].e_lfanew
          assume esi:ptr IMAGE_NT_HEADERS
          ;�ж��Ƿ���PE����
          .if [esi].Signature!=IMAGE_NT_SIGNATURE
            jmp _ErrFormat
          .endif

          mov eax,[esi].OptionalHeader.SizeOfHeaders
          movzx eax,[esi].FileHeader.NumberOfSections
          mov @dwSections,eax

          invoke wsprintf,addr szBuffer,addr szOut2,\
                         addr szFileName
          invoke _appendInfo,addr szBuffer
          invoke _appendInfo,addr szTitle

          ;��ȡ���ڵ�����
          mov eax,@dwSections
          mov @dwTemp,eax
          sub @dwTemp,1

          .while @dwTemp!=0FFFFFFFFh
            mov eax,@dwSections
            dec eax
            .if @dwTemp==eax  ;��ʾ���һ����
               mov eax,@dwFileSize ;�ļ���С
               mov @dwOff,eax
            .else
               mov eax,lpFOA
               mov @dwOff,eax ;��һ���ڵ���ʼ
            .endif
            invoke _rSection,@lpMemory,@dwTemp,1,3
            add eax,@lpMemory
            mov esi,eax
            assume esi:ptr IMAGE_SECTION_HEADER
            mov eax,dword ptr [esi].PointerToRawData
            mov lpFOA,eax

            ;��ȡ�ڵ�����
            pushad
            invoke RtlZeroMemory,addr szSection,10
            popad

            nop
            push esi
            push edi
            mov edi,offset szSection
            mov ecx,8
            cld
            rep movsb
            pop edi
            pop esi

            mov edi,@dwOff
            add edi,@lpMemory
            xor ecx,ecx
loc2:       dec edi
            mov al,byte ptr [edi]
            .if al==0
              inc ecx
              jmp loc2          
            .endif

            mov dwAvailable,ecx

            ;��������ߴ�
            mov eax,@dwOff
            sub eax,lpFOA
            mov dwTotalSize,eax
            sub eax,dwAvailable
            add eax,lpFOA
            mov lpAvailable,eax
            invoke wsprintf,addr szBuffer,addr szOut,\
                              addr szSection,\
                              lpFOA,\
                              dwTotalSize,\
                              dwTotalSize,\
                              dwAvailable,\
                              dwAvailable,\
                              lpAvailable
            invoke _appendInfo,addr szBuffer            

            dec @dwTemp
          .endw 

          ;��ȡ�ļ�ͷ�����ÿռ�
          ;��λ����һ���ڱ���
          invoke _rSection,@lpMemory,0,1,3
          add eax,@lpMemory
          mov esi,eax
          assume esi:ptr IMAGE_SECTION_HEADER
          mov eax,dword ptr [esi].PointerToRawData
          mov dwTotalSize,eax

          xor ecx,ecx
          add eax,@lpMemory ;ָ���ļ�ͷ��β��
          mov edi,eax
loc1:     dec edi
          mov al,byte ptr [edi]
          .if al==0
            inc ecx
            jmp loc1          
          .endif
          mov dwAvailable,ecx
          mov lpFOA,0
          mov eax,dwTotalSize
          sub eax,dwAvailable
          mov lpAvailable,eax
          invoke wsprintf,addr szBuffer,addr szOut,\
                              addr szHeader,\
                              lpFOA,\
                              dwTotalSize,\
                              dwTotalSize,\
                              dwAvailable,\
                              dwAvailable,\
                              lpAvailable
          invoke _appendInfo,addr szBuffer
          jmp _ErrorExit
 
_ErrFormat:
          invoke MessageBox,hWinMain,offset szErrFormat,\
                                                 NULL,MB_OK
_ErrorExit:
          pop fs:[0]
          add esp,0ch
          invoke UnmapViewOfFile,@lpMemory
        .endif
        invoke CloseHandle,@hMapFile
      .endif
      invoke CloseHandle,@hFile
    .endif
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
