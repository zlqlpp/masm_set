;-------------------------------------------
; ��patch.ext����������뵽ָ��exe�ļ�����������
; ��Ҫ��ʾ���ʹ�ó����޸�PE�ļ���ʽ���Ӷ������
; Ҫʵ�ֵĹ���
; 02-ֻ���������
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

dwFunctions db 1024 dup(11h)  ;��¼ÿ����̬���ӿ����õĺ���������
                                         ;����,������������0
szBuffer1   db 1024 dup(0)
szBuffer2   db 1024 dup(0)
bufTemp1         db  200 dup(0),0
bufTemp2         db  200 dup(0),0

dwPatchImportSegSize      dd ?  ;������������ڶεĴ�С
dwPatchImportSegStart     dd ?  ;������������ڶε���ʼ��ַ
dwDstImportSegSize        dd ?  ;Ŀ�굼������ڶδ�С
dwDstImportSegStart       dd ?  ;Ŀ�굼������ڶ�������ʼ��ַ
dwDstImportSegRawSize     dd ?  ;Ŀ�굼������ڶ��������ļ��ж����Ĵ�С
dwPatchImportSize         dd ?  ;����������С
dwDstImportSize           dd ?  ;Ŀ�굼����С
dwNewImportSize           dd ?  ;���ɵ����ļ��ĵ�����С  �������������������С���жϿռ乻��������Ҫ�ֶ�
dwPatchDLLCount           dd ?  ;���������е���DLL�ĸ���
dwDstDLLCount             dd ?  ;Ŀ������е���DLL�ĸ���



;dwDstMemDataStart         dd ?  ;Ŀ�굼������ڶ����ڴ��е���ʼ��ַ
;dwStartAddressinDstRS     dd ?  ;�����ӵĲ�����������ڶε�������Ŀ���ļ��е���ʼλ��



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
szErr20      db '>> δ�ҵ��ɴ�����ݵĽڣ�',0dh,0ah,0
szErr21      db '>> Ŀ��οռ䲻�������������ɲ��������������ݣ�',0dh,0ah,0

szOut221      db '������������ڶεĴ�СΪ��%08x',0dh,0ah,0
szOut22      db '������������ڶ����ļ��е���ʼλ�ã�%08x',0dh,0ah,0
szOut23      db 'Ŀ�굼������ڶεĴ�СΪ��%08x',0dh,0ah,0
szOut24      db 'Ŀ�굼������ڶ����ļ��е���ʼλ�ã�%08x',0dh,0ah,0
szOut25      db 'Ŀ�굼������ڶ����ļ��ж����Ĵ�С��%08x',0dh,0ah,0
szOut26      db 'Ŀ���ļ��ĵ���������Ķ����пռ䡣ʣ��ռ��СΪ:%08x,�ϲ��Ժ�ĵ�����ڶ��е���ʼλ��Ϊ��%08x',0dh,0ah,0
szOut27      db '��������������ӿ������%08x',0dh,0ah,0
szOut28      db '����������ú���������%08x',0dh,0ah,0
szOut29      db '����������ö�̬���ӿ⼰ÿ����̬���ӿ���ú���������ϸ��',0dh,0ah,0
szOut2210     db 'Ŀ�����������ӿ������%08x',0dh,0ah,0
szOut2211     db 'Ŀ�������ú���������%08x',0dh,0ah,0
szOut2212     db 'Ŀ�������ö�̬���ӿ⼰ÿ����̬���ӿ���ú���������ϸ��',0dh,0ah,0

szCrLf      db 0dh,0ah,0

szOut       db '%08x',0
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

;--------------------------
; ��bufTemp2λ�ô�_dwSize���ֽ�ת��Ϊ16���Ƶ��ַ���
; bufTemp1��Ϊת������ַ���
;--------------------------
_Byte2Hex     proc _dwSize
  local @dwSize:dword

  pushad
  mov esi,offset bufTemp2
  mov edi,offset bufTemp1
  mov @dwSize,0
  .repeat
    mov al,byte ptr [esi]

    mov bl,al
    xor edx,edx
    xor eax,eax
    mov al,bl
    mov cx,16
    div cx   ;�����λ��al�У�������dl��


    xor bx,bx
    mov bl,al
    movzx edi,bx
    mov bl,byte ptr lpszHexArr[edi]
    mov eax,@dwSize
    mov byte ptr bufTemp1[eax],bl


    inc @dwSize

    xor bx,bx
    mov bl,dl
    movzx edi,bx

    ;invoke wsprintf,addr szBuffer,addr szOut22,edx
    ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK

    mov bl,byte ptr lpszHexArr[edi]
    mov eax,@dwSize
    mov byte ptr bufTemp1[eax],bl

    inc @dwSize
    mov bl,20h
    mov eax,@dwSize
    mov byte ptr bufTemp1[eax],bl
    inc @dwSize
    inc esi
    dec _dwSize
    .break .if _dwSize==0
   .until FALSE

   mov bl,0
   mov eax,@dwSize
   mov byte ptr bufTemp1[eax],bl

   popad
   ret
_Byte2Hex    endp
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

;------------------------
; ��ȡRVA���ڽڵ��ļ���ʼ��ַ
;------------------------
_getRVASectionStart  proc _lpFileHead,_dwRVA
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
      mov eax,[edx].PointerToRawData
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
_getRVASectionStart  endp


;------------------------
; ��ȡRVA���ڽڵ�ԭʼ��С
;------------------------
_getRVASectionSize  proc _lpFileHead,_dwRVA
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
      ;invoke _appendInfo,edx
      mov eax,[edx].Misc
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
_getRVASectionSize  endp

;------------------------
; ��ȡRVA���ڽ����ļ��ж����Ժ�Ĵ�С
;------------------------
_getRVASectionRawSize  proc _lpFileHead,_dwRVA
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
      mov eax,[edx].SizeOfRawData
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
_getRVASectionRawSize  endp
;-------------------
; ȡ��������ڽڵĴ�С
; ���ݶζ�λ������
; ֻҪ�ڵı�ʶ��6,30,31λΪ1�����ʾ����Ҫ��
; _lpHeaderָ���ڴ���PE�ļ�����ʼ
; ����ֵ��eax��
;-------------------
getImportSegSize proc _lpHeader
   local @dwSize
   pushad
   
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume esi:ptr IMAGE_NT_HEADERS
   mov eax,[esi].OptionalHeader.DataDirectory[8].VirtualAddress

   invoke _getRVASectionSize,_lpHeader,eax
   mov @dwSize,eax   
   popad
   mov eax,@dwSize
   ret
getImportSegSize endp

;-------------------
; ȡ��������ڽ����ļ��ж����Ժ�Ĵ�С
; ���ݶζ�λ������
; ֻҪ�ڵı�ʶ��6,30,31λΪ1�����ʾ����Ҫ��
; _lpHeaderָ���ڴ���PE�ļ�����ʼ
; ����ֵ��eax��
;-------------------
getImportSegRawSize proc _lpHeader
   local @dwSize
   pushad
   
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume esi:ptr IMAGE_NT_HEADERS
   mov eax,[esi].OptionalHeader.DataDirectory[8].VirtualAddress

   invoke _getRVASectionRawSize,_lpHeader,eax
   mov @dwSize,eax   
   popad
   mov eax,@dwSize
   ret
getImportSegRawSize endp

;-------------------
; ȡ������������ڽڵĴ�С
; ���ݶζ�λ������
; ֻҪ�ڵı�ʶ��6,30,31λΪ1�����ʾ����Ҫ��
; _lpHeaderָ���ڴ���PE�ļ�����ʼ
; ����ֵ��eax��
;-------------------
getImportSegStart proc _lpHeader
   local @dwStart
   pushad
   
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume esi:ptr IMAGE_NT_HEADERS
   mov eax,[esi].OptionalHeader.DataDirectory[8].VirtualAddress
   invoke _getRVASectionStart,_lpHeader,eax
   mov @dwStart,eax   
   popad
   mov eax,@dwStart
   ret
getImportSegStart endp

;---------------------------------
; ��ȡPE�ļ��ĵ������õĺ�������
;---------------------------------
_getImportFunctions proc _lpFile
  local @szBuffer[1024]:byte
  local @szSectionName[16]:byte
  local _lpPeHead
  local @dwDlls,@dwFuns,@dwFunctions
  
  pushad
  mov edi,_lpFile
  assume edi:ptr IMAGE_DOS_HEADER
  add edi,[edi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
  assume edi:ptr IMAGE_NT_HEADERS
  mov eax,[edi].OptionalHeader.DataDirectory[8].VirtualAddress
  .if !eax
    jmp @F
  .endif
  invoke _RVAToOffset,_lpFile,eax
  add eax,_lpFile
  mov edi,eax     ;��������������ļ�ƫ��λ��
  assume edi:ptr IMAGE_IMPORT_DESCRIPTOR
  invoke _getRVASectionName,_lpFile,[edi].OriginalFirstThunk

  mov @dwFuns,0
  mov @dwFunctions,0
  mov @dwDlls,0

  .while [edi].OriginalFirstThunk || [edi].TimeDateStamp ||\
         [edi].ForwarderChain || [edi].Name1 || [edi].FirstThunk
    mov @dwFuns,0
    invoke _RVAToOffset,_lpFile,[edi].Name1
    add eax,_lpFile

    ;��ȡIMAGE_THUNK_DATA�б�EBX
    .if [edi].OriginalFirstThunk
      mov eax,[edi].OriginalFirstThunk
    .else
      mov eax,[edi].FirstThunk
    .endif
    invoke _RVAToOffset,_lpFile,eax
    add eax,_lpFile
    mov ebx,eax
    .while dword ptr [ebx]
      inc @dwFuns 
      inc @dwFunctions
      .if dword ptr [ebx] & IMAGE_ORDINAL_FLAG32 ;����ŵ���
        mov eax,dword ptr [ebx]
        and eax,0ffffh
      .else                                      ;�����Ƶ���
        invoke _RVAToOffset,_lpFile,dword ptr [ebx]
        add eax,_lpFile
        assume eax:ptr IMAGE_IMPORT_BY_NAME
        movzx ecx,[eax].Hint
        assume eax:nothing
      .endif
      add ebx,4
    .endw
    mov eax,@dwFuns
    mov ebx,@dwDlls
    mov dword ptr dwFunctions[ebx*4],eax
    mov dword ptr dwFunctions[ebx*4+4],0
    inc @dwDlls
    add edi,sizeof IMAGE_IMPORT_DESCRIPTOR
  .endw
  mov ebx,@dwDlls
  mov dword ptr dwFunctions[ebx*4],0
@@:
  assume edi:nothing
  popad
  mov eax,@dwDlls
  mov ebx,@dwFunctions
  ret
_getImportFunctions endp


;-----------------------
; ��ȡ������С����ȫ0�ṹ
;-----------------------
getImportSize  proc  _lpFile
  local @dwTemp:dword
  pushad
  invoke _getImportFunctions,_lpFile
  add eax,1
  mov edx,0
  mov bx,14h
  mul bx
  mov @dwTemp,eax  

  popad
  mov eax,@dwTemp
  ret
getImportSize  endp

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

 
  ;��ȡ������������ڽڵĴ�С
  invoke getImportSegSize,@lpMemory
  mov dwPatchImportSegSize,eax

  invoke wsprintf,addr szBuffer,addr szOut221,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡ������������ڽ����ļ��е���ʼλ��
  invoke getImportSegStart,@lpMemory
  mov dwPatchImportSegStart,eax

  invoke wsprintf,addr szBuffer,addr szOut22,eax
  invoke _appendInfo,addr szBuffer
  ;��ȡĿ�굼������ڽڵĴ�С
  invoke getImportSegSize,@lpMemory1
  mov dwDstImportSegSize,eax

  invoke wsprintf,addr szBuffer,addr szOut23,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡĿ�굼������ڽ����ļ��е���ʼλ��
  invoke getImportSegStart,@lpMemory1
  mov dwDstImportSegStart,eax

  invoke wsprintf,addr szBuffer,addr szOut24,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡĿ�굼������ڽڵĴ�С
  invoke getImportSegRawSize,@lpMemory1
  mov dwDstImportSegRawSize,eax

  invoke wsprintf,addr szBuffer,addr szOut25,eax
  invoke _appendInfo,addr szBuffer


  ;��ȡ���������dll�������functions����
  invoke _getImportFunctions,@lpMemory
  mov dwPatchDLLCount,eax
  invoke wsprintf,addr szBuffer,addr szOut27,eax
  invoke _appendInfo,addr szBuffer
  invoke wsprintf,addr szBuffer,addr szOut28,ebx
  invoke _appendInfo,addr szBuffer

  ;��ʾÿ����̬���ӿ�ĺ���������
  invoke _appendInfo,addr szOut29
  invoke MemCopy,addr dwFunctions,addr bufTemp2,40
  invoke _Byte2Hex,40
  invoke _appendInfo,addr bufTemp1
  invoke _appendInfo,addr szCrLf

  ;��ȡĿ�굼���dll�������functions����
  invoke _getImportFunctions,@lpMemory1
  mov dwDstDLLCount,eax

  invoke wsprintf,addr szBuffer,addr szOut2210,eax
  invoke _appendInfo,addr szBuffer
  invoke wsprintf,addr szBuffer,addr szOut2211,ebx
  invoke _appendInfo,addr szBuffer

  ;��ʾÿ����̬���ӿ�ĺ���������
  invoke _appendInfo,addr szOut2212
  invoke MemCopy,addr dwFunctions,addr bufTemp2,40
  invoke _Byte2Hex,40
  invoke _appendInfo,addr bufTemp1
  invoke _appendInfo,addr szCrLf


  ;���������ɵ����ļ��ĵ�����С
  invoke getImportSize,@lpMemory   ;����������С
  mov dwPatchImportSize,eax
  invoke getImportSize,@lpMemory1  ;Ŀ���ļ�������С
  mov dwDstImportSize,eax
  add eax,dwPatchImportSize
  sub eax,14h                      ;���ļ�������С��eax��
  mov dwNewImportSize,eax

  ;invoke wsprintf,addr szBuffer,addr szOut,ecx
  ;invoke _appendInfo,addr szBuffer


  ;��Ŀ�굼������ڽڵ����һ��λ������ǰ����������ȫ0�ַ�
  mov eax,dwDstImportSegStart
  add eax,dwDstImportSegRawSize  ;��λ�����ڵ����һ���ֽ�
  mov ecx,dwNewImportSize
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
    mov @dwTemp,0
    mov @dwTemp1,eax
    mov eax,dwDstImportSegStart
    add eax,dwDstImportSegRawSize  ;��λ�����ڵ����һ���ֽ�    
    mov esi,@lpMemory1
    add esi,eax
    dec esi
    .repeat
      mov bl,byte ptr [esi]
      .break .if bl!=0
      inc @dwTemp
      dec esi
      dec eax
    .until FALSE

    invoke wsprintf,addr szBuffer,addr szOut26,@dwTemp,@dwTemp1
    invoke _appendInfo,addr szBuffer

  .else       ;�����οռ䲻��
    invoke _appendInfo,addr szErr21
  .endif





  ;


  invoke _appendInfo,addr szoutLine


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



