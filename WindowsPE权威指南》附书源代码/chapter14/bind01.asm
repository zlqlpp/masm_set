;-------------------------------------------
; ��patch.ext����������뵽ָ��exe�ļ�����������
; ��Ҫ��ʾ���ʹ�ó����޸�PE�ļ���ʽ���Ӷ������
; Ҫʵ�ֵĹ���
; 01-ֻ�������ݶ��Ƿ�����Ҫ��
;-------------------------------------------

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
szFileName  db MAX_PATH dup(?)
szBuffer    db  256 dup(?)

dwPatchDataSize      dd ?  ;�������ݶδ�С
dwPatchDataStart     dd ?  ;����������ʼ��ַ
dwDstDataSize        dd ?  ;Ŀ�����ݶδ�С
dwDstDataStart       dd ?  ;Ŀ��������ʼ��ַ
dwDstRawDataSize     dd ?  ;Ŀ���������ļ��ж����Ĵ�С
dwDstMemDataStart     dd ? ;Ŀ�����ݶ����ڴ��е���ʼ��ַ
dwStartAddressinDstDS dd ? ;�����ӵĲ������ݶ���Ŀ���ļ��е���ʼλ��



.const
szDllEdit   db 'RichEd20.dll',0
szClassEdit db 'RichEdit20A',0
szFont      db '����',0


szFile1     db 'd:\masm32\source\chapter10\patch.exe',256 dup(0)
szFile2     db 'd:\masm32\source\chapter10\HelloWorld.exe',256 dup(0)
hFile1      dd ?
hFile2      dd ?

szErr       db '�ļ���ʽ����!',0
szErrFormat db '����ļ�����PE��ʽ���ļ�!',0
szSuccess   db '��ϲ�㣬����ִ�е������ǳɹ��ġ�',0
szNotFound  db '�޷�����',0
szoutLine   db '----------------------------------------------------------------------------------------',0dh,0ah,0
szErr110      db '>> δ�ҵ��ɴ�����ݵĽڣ�',0dh,0ah,0
szErr11      db '>> Ŀ�����ݶοռ䲻�������������ɲ�����������ݣ�',0dh,0ah,0

szOut11      db '�������ݶεĴ�СΪ��%08x',0dh,0ah,0
szOut12      db '�������ݶ����ļ��е���ʼλ�ã�%08x',0dh,0ah,0
szOut13      db 'Ŀ�����ݶεĴ�СΪ��%08x',0dh,0ah,0
szOut14      db 'Ŀ�����ݶ����ļ��е���ʼλ�ã�%08x',0dh,0ah,0
szOut15      db 'Ŀ�����ݶ����ļ��ж����Ĵ�С��%08x',0dh,0ah,0
szOut16      db 'Ŀ���ļ������ݶ����пռ䣬�ռ��СΪ%08x,�������ݶ���Ŀ���ļ��д�ŵ���ʼλ�ã�%08x',0dh,0ah,0
szOut17      db 'Ŀ�����ݶ����ڴ��е���ʼ��ַ��%08x',0dh,0ah,0
szOut18      db 'Ŀ�����װ���ַ�ͳ���ִ����ڣ�%08x:%08x',0dh,0ah,0


szOut123     db '%04x',0
lpszHexArr  db  '0123456789ABCDEF',0



.data?
stLVC         LV_COLUMN <?>
stLVI         LV_ITEM   <?>


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
    add eax,[edx].Misc             ;����ýڽ���RVA
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

;------------------------
; ��ȡRVA���ڽڵ�����
;------------------------
_getRVASectionName  proc _lpFileHead,_dwRVA
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
    add eax,[edx].SizeOfRawData  ;����ýڽ���RVA
    .if (edi>=[edx].VirtualAddress)&&(edi<eax)
      mov eax,edx
      jmp @F
    .endif
    add edx,sizeof IMAGE_SECTION_HEADER
  .untilcxz
  assume edx:nothing
  assume esi:nothing
  mov eax,offset szNotFound
@@:
  mov @dwReturn,eax
  popad
  mov eax,@dwReturn
  ret
_getRVASectionName  endp
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

;-------------------
; ȡ���ݶδ�С
; ���ݶζ�λ������
; ֻҪ�ڵı�ʶ��6,30,31λΪ1�����ʾ����Ҫ��
; _lpHeaderָ���ڴ���PE�ļ�����ʼ
; ����ֵ��eax��
;-------------------
getDataSize proc _lpHeader
   local @dwSize
   local @dwSectionSize
   pushad
   
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume esi:ptr IMAGE_NT_HEADERS
   ;ȡ�ڵ�����
   add esi,4
   assume esi:ptr IMAGE_FILE_HEADER
   movzx ecx,[esi].NumberOfSections
   mov @dwSectionSize,ecx

   add esi,0F4h   ;esiָ��ڱ�λ��
   .repeat
     assume esi:ptr IMAGE_SECTION_HEADER
     mov ebx,[esi].Characteristics  ;ȡ�ڵı�ʶ
     and ebx,0c0000040h
     .if ebx==0c0000040h
        mov eax,[esi].Misc
        mov @dwSize,eax
        .break
     .endif
     dec @dwSectionSize
     add esi,sizeof IMAGE_SECTION_HEADER
     .break .if @dwSectionSize==0
   .until FALSE
   
   popad
   mov eax,@dwSize
   ret
getDataSize endp

;-------------------
; ȡ���ݶ����ļ��ж����Ĵ�С
; ���ݶζ�λ������
; ֻҪ�ڵı�ʶ��6,30,31λΪ1�����ʾ����Ҫ��
; _lpHeaderָ���ڴ���PE�ļ�����ʼ
; ����ֵ��eax��
;-------------------
getRawDataSize proc _lpHeader
   local @dwSize
   local @dwSectionSize
   pushad
   
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume esi:ptr IMAGE_NT_HEADERS
   ;ȡ�ڵ�����
   add esi,4
   assume esi:ptr IMAGE_FILE_HEADER
   movzx ecx,[esi].NumberOfSections
   mov @dwSectionSize,ecx

   add esi,0F4h   ;esiָ��ڱ�λ��
   .repeat
     assume esi:ptr IMAGE_SECTION_HEADER
     mov ebx,[esi].Characteristics  ;ȡ�ڵı�ʶ
     and ebx,0c0000040h
     .if ebx==0c0000040h
        mov eax,[esi].SizeOfRawData
        mov @dwSize,eax
        .break
     .endif
     dec @dwSectionSize
     add esi,sizeof IMAGE_SECTION_HEADER
     .break .if @dwSectionSize==0
   .until FALSE
   
   popad
   mov eax,@dwSize
   ret
getRawDataSize endp
;-------------------
; ȡ���ݶ����ļ��е���ʼλ��
; ���ݶζ�λ������
; ֻҪ�ڵı�ʶ��6,30,31λΪ1�����ʾ����Ҫ��
; _lpHeaderָ���ڴ���PE�ļ�����ʼ
; ����ֵ��eax��
;-------------------
getDataStart proc _lpHeader
   local @dwStart
   local @dwSectionSize
   pushad
   
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume esi:ptr IMAGE_NT_HEADERS
   ;ȡ�ڵ�����
   add esi,4
   assume esi:ptr IMAGE_FILE_HEADER
   movzx ecx,[esi].NumberOfSections
   mov @dwSectionSize,ecx

   add esi,0F4h   ;esiָ��ڱ�λ��
   .repeat
     assume esi:ptr IMAGE_SECTION_HEADER
     mov ebx,[esi].Characteristics  ;ȡ�ڵı�ʶ
     and ebx,0c0000040h
     .if ebx==0c0000040h
        mov eax,[esi].PointerToRawData
        mov @dwStart,eax
        .break
     .endif
     dec @dwSectionSize
     add esi,sizeof IMAGE_SECTION_HEADER
     .break .if @dwSectionSize==0
   .until FALSE
   
   popad
   mov eax,@dwStart
   ret
getDataStart endp

;-------------------
; ȡ���ݶ����ڴ��е���ʼλ��
; ���ݶζ�λ������
; ֻҪ�ڵı�ʶ��6,30,31λΪ1�����ʾ����Ҫ��
; _lpHeaderָ���ڴ���PE�ļ�����ʼ
; ����ֵ��eax��
;-------------------
getDataStartInMem proc _lpHeader
   local @dwStart
   local @dwSectionSize
   pushad
   
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume esi:ptr IMAGE_NT_HEADERS
   ;ȡ�ڵ�����
   add esi,4
   assume esi:ptr IMAGE_FILE_HEADER
   movzx ecx,[esi].NumberOfSections
   mov @dwSectionSize,ecx

   add esi,0F4h   ;esiָ��ڱ�λ��
   .repeat
     assume esi:ptr IMAGE_SECTION_HEADER
     mov ebx,[esi].Characteristics  ;ȡ�ڵı�ʶ
     and ebx,0c0000040h
     .if ebx==0c0000040h
        mov eax,[esi].VirtualAddress
        mov @dwStart,eax
        .break
     .endif
     dec @dwSectionSize
     add esi,sizeof IMAGE_SECTION_HEADER
     .break .if @dwSectionSize==0
   .until FALSE
   
   popad
   mov eax,@dwStart
   ret
getDataStartInMem endp

;--------------------
; ��PE�ļ�������
;--------------------
_OpenFile proc
  local @stOF:OPENFILENAME
  local @hFile,@dwFileSize,@hMapFile,@lpMemory
  local @hFile1,@dwFileSize1,@hMapFile1,@lpMemory1
  local @bufTemp1[10]:byte
  local @dwTemp:dword,@dwTemp1:dword


  invoke CreateFile,addr szFile1,GENERIC_READ,\
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
          mov @lpMemory,eax              ;����ļ����ڴ��ӳ����ʼλ��
          assume fs:nothing
          push ebp
          push offset _ErrFormat
          push offset _Handler
          push fs:[0]
          mov fs:[0],esp

          ;���PE�ļ��Ƿ���Ч
          mov esi,@lpMemory
          assume esi:ptr IMAGE_DOS_HEADER
          .if [esi].e_magic!=IMAGE_DOS_SIGNATURE  ;�ж��Ƿ���MZ����
            jmp _ErrFormat
          .endif
          add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
          assume esi:ptr IMAGE_NT_HEADERS
          .if [esi].Signature!=IMAGE_NT_SIGNATURE ;�ж��Ƿ���PE����
            jmp _ErrFormat
          .endif
        .endif
      .endif
    .endif
  .endif

  invoke CreateFile,addr szFile2,GENERIC_READ,\
         FILE_SHARE_READ or FILE_SHARE_WRITE,NULL,\
         OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE,NULL

  .if eax!=INVALID_HANDLE_VALUE
    mov @hFile1,eax
    invoke GetFileSize,eax,NULL
    mov @dwFileSize1,eax
    .if eax
      invoke CreateFileMapping,@hFile1,\  ;�ڴ�ӳ���ļ�
             NULL,PAGE_READONLY,0,0,NULL
      .if eax
        mov @hMapFile1,eax
        invoke MapViewOfFile,eax,\
               FILE_MAP_READ,0,0,0
        .if eax
          mov @lpMemory1,eax              ;����ļ����ڴ��ӳ����ʼλ��
          assume fs:nothing
          push ebp
          push offset _ErrFormat1
          push offset _Handler
          push fs:[0]
          mov fs:[0],esp

          ;���PE�ļ��Ƿ���Ч
          mov esi,@lpMemory1
          assume esi:ptr IMAGE_DOS_HEADER
          .if [esi].e_magic!=IMAGE_DOS_SIGNATURE  ;�ж��Ƿ���MZ����
            jmp _ErrFormat1
          .endif
          add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
          assume esi:ptr IMAGE_NT_HEADERS
          .if [esi].Signature!=IMAGE_NT_SIGNATURE ;�ж��Ƿ���PE����
            jmp _ErrFormat1
          .endif
        .endif
      .endif
    .endif
  .endif

  ;����Ϊֹ�������ڴ��ļ���ָ���Ѿ���ȡ���ˡ�@lpMemory��@lpMemory1�ֱ�ָ�������ļ�ͷ
  ;�����Ǵ�����ļ�ͷ��ʼ���ҳ������ݽṹ���ֶ�ֵ�����бȽϡ�


  ;��ȡ�����ļ����ݶεĴ�С
  invoke getDataSize,@lpMemory
  mov dwPatchDataSize,eax

  .if eax==0  ;δ�ҵ�������ݵĽ�
    invoke _appendInfo,addr szErr110
  .else
    invoke wsprintf,addr szBuffer,addr szOut11,eax
    invoke _appendInfo,addr szBuffer
  .endif



  ;��ȡ�����ļ����ݶ����ڴ��е���ʼλ��
  invoke getDataStart,@lpMemory
  mov dwPatchDataStart,eax

  invoke wsprintf,addr szBuffer,addr szOut12,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡĿ���ļ����ݶεĴ�С
  invoke getDataSize,@lpMemory1
  mov dwDstDataSize,eax

  invoke wsprintf,addr szBuffer,addr szOut13,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡĿ���ļ����ݶ����ڴ��е���ʼλ��
  invoke getDataStart,@lpMemory1
  mov dwDstDataStart,eax

  invoke wsprintf,addr szBuffer,addr szOut14,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡĿ���ļ����ݶ����ļ��ж����Ĵ�С
  invoke getRawDataSize,@lpMemory1
  mov dwDstRawDataSize,eax

  invoke wsprintf,addr szBuffer,addr szOut15,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡĿ�����ݶ����ڴ��е���ʼλ��
  invoke getDataStartInMem,@lpMemory1
  mov dwDstMemDataStart,eax

  invoke wsprintf,addr szBuffer,addr szOut17,eax
  invoke _appendInfo,addr szBuffer


  ;�ӱ��ڵ����һ��λ������ǰ����������ȫ0�ַ�
  mov eax,dwDstDataStart
  add eax,dwDstRawDataSize  ;��λ�����ڵ����һ���ֽ�
  mov ecx,dwPatchDataSize
  mov esi,@lpMemory1
  add esi,eax
  dec esi
  .repeat
    mov bl,byte ptr[esi]
    .break .if bl!=0
    dec esi
    dec ecx
    dec eax
    .break .if ecx==0
  .until FALSE
  .if ecx==0  ;��ʾ�ҵ����������õĿռ�
    mov @dwTemp1,eax
    sub eax,dwPatchDataSize
    mov dwStartAddressinDstDS,eax

    mov @dwTemp,0

    mov esi,@lpMemory1
    mov eax,dwDstDataStart
    add eax,dwDstRawDataSize  ;��λ�����ڵ����һ���ֽ�
    add esi,eax
    dec esi
    .repeat
      mov bl,byte ptr [esi]
      .break .if bl!=0
      inc @dwTemp
      dec esi
    .until FALSE
    
    invoke wsprintf,addr szBuffer,addr szOut16,@dwTemp,@dwTemp1
    invoke _appendInfo,addr szBuffer
  .else       ;���ݶοռ䲻��
    invoke _appendInfo,addr szErr11
  .endif

  invoke _appendInfo,addr szoutLine

  ;����ESI,EDIָ��DOSͷ
  mov esi,@lpMemory
  assume esi:ptr IMAGE_DOS_HEADER
  mov edi,@lpMemory1
  assume edi:ptr IMAGE_DOS_HEADER

  add edi,[edi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
  assume edi:ptr IMAGE_NT_HEADERS
  ;ȡ����װ�ص�ַ
  add edi,4
  add edi,sizeof IMAGE_FILE_HEADER
  assume edi:ptr IMAGE_OPTIONAL_HEADER32
  mov eax,[edi].ImageBase
  mov ebx,[edi].AddressOfEntryPoint
  invoke wsprintf,addr szBuffer,addr szOut18,eax,ebx
  invoke _appendInfo,addr szBuffer


  jmp _ErrorExit  ;�����˳�

_ErrFormat:
          invoke MessageBox,hWinMain,offset szErrFormat,NULL,MB_OK
_ErrorExit:
          pop fs:[0]
          add esp,0ch
          invoke UnmapViewOfFile,@lpMemory
          invoke CloseHandle,@hMapFile
          invoke CloseHandle,@hFile
          jmp @F
_ErrFormat1:
          invoke MessageBox,hWinMain,offset szErrFormat,NULL,MB_OK
_ErrorExit1:
          pop fs:[0]
          add esp,0ch
          invoke UnmapViewOfFile,@lpMemory1
          invoke CloseHandle,@hMapFile1
          invoke CloseHandle,@hFile1
@@:        
  ret
_OpenFile endp
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
      invoke _OpenFile

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



