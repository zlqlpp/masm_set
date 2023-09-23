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
szFileName  db MAX_PATH dup(?)

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
szMsg       db '�ļ�����%s',0dh,0ah
            db '-----------------------------------------',0dh,0ah,0dh,0ah,0dh,0ah
            db '����ƽ̨��      0x%04x  (014c:Intel 386   014dh:Intel 486  014eh:Intel 586)',0dh,0ah
            db '�ڵ�������      %d',0dh,0ah
            db '�ļ����ԣ�      0x%04x  (��β-��ֹ�ദ����-DLL-ϵͳ�ļ�-��ֹ��������-��ֹ��������-�޵���-32λ-Сβ-X-X-X-�޷���-����-��ִ��-���ض�λ)',0dh,0ah
            db '����װ�����ַ��  0x%08x',0dh,0ah
            db '�ļ�ִ�����(RVA��ַ)��  0x%04x',0dh,0ah,0dh,0ah,0
szMsgSec    db '---------------------------------------------------------------------------------',0dh,0ah
            db '�ڵ����Բο���',0dh,0ah
            db '  00000020h  ��������',0dh,0ah
            db '  00000040h  �����Ѿ���ʼ�������ݣ���.const',0dh,0ah
            db '  00000080h  ����δ��ʼ�����ݣ��� .data?',0dh,0ah
            db '  02000000h  �����ڽ��̿�ʼ�Ժ󱻶�������.reloc',0dh,0ah
            db '  04000000h  �������ݲ���������',0dh,0ah
            db '  08000000h  �������ݲ��ᱻ����������',0dh,0ah
            db '  10000000h  ���ݽ�����ͬ���̹���',0dh,0ah
            db '  20000000h  ��ִ��',0dh,0ah
            db '  40000000h  �ɶ�',0dh,0ah
            db '  80000000h  ��д',0dh,0ah
            db '�����Ĵ����һ��Ϊ��60000020h,���ݽ�һ��Ϊ��c0000040h��������һ��Ϊ��40000040h',0dh,0ah
            db '---------------------------------------------------------------------------------',0dh,0ah,0dh,0ah,0dh,0ah
            db '�ڵ�����  δ����ǰ��ʵ����  �ڴ��е�ƫ��(������) �ļ��ж����ĳ��� �ļ��е�ƫ��  �ڵ�����',0dh,0ah
            db '---------------------------------------------------------------------------------------------',0dh,0ah,0
szFmtSec    db '%s     %08x         %08x              %08x           %08x     %08x',0dh,0ah,0dh,0ah,0dh,0ah,0
szMsg1      db 0dh,0ah,0dh,0ah,0dh,0ah
            db '---------------------------------------------------------------------------------------------',0dh,0ah
            db '����������Ľڣ�%s',0dh,0ah
            db '---------------------------------------------------------------------------------------------',0dh,0ah,0
szMsgImport db 0dh,0ah,0dh,0ah
            db '����⣺%s',0dh,0ah
            db '-----------------------------',0dh,0ah,0dh,0ah
            db 'OriginalFirstThunk  %08x',0dh,0ah
            db 'TimeDateStamp       %08x',0dh,0ah
            db 'ForwarderChain      %08x',0dh,0ah
            db 'FirstThunk          %08x',0dh,0ah
            db '-----------------------------',0dh,0ah,0dh,0ah,0
szMsg2      db '%08u         %s',0dh,0ah,0
szMsg3      db '%08u(�޺�����������ŵ���)',0dh,0ah,0
szErrNoImport db  0dh,0ah,0dh,0ah
              db  'δ���ָ��ļ��е��뺯��',0dh,0ah,0dh,0ah,0

szMsgExport db 0dh,0ah,0dh,0ah,0dh,0ah
            db '---------------------------------------------------------------------------------------------',0dh,0ah
            db '�����������Ľڣ�%s',0dh,0ah
            db '---------------------------------------------------------------------------------------------',0dh,0ah
            db 'ԭʼ�ļ�����%s',0dh,0ah
            db 'nBase               %08x',0dh,0ah
            db 'NumberOfFunctions   %08x',0dh,0ah
            db 'NuberOfNames        %08x',0dh,0ah
            db 'AddressOfFunctions  %08x',0dh,0ah
            db 'AddressOfNames      %08x',0dh,0ah
            db 'AddressOfNameOrd    %08x',0dh,0ah
            db '-------------------------------------',0dh,0ah,0dh,0ah
            db '�������    �����ַ    ������������',0dh,0ah
            db '-------------------------------------',0dh,0ah,0
szMsg4      db '%08x      %08x      %s',0dh,0ah,0
szExportByOrd db  '(������ŵ���)',0
szErrNoExport db 0dh,0ah,0dh,0ah
              db  'δ���ָ��ļ��е�������',0dh,0ah,0dh,0ah,0
szMsgReloc1 db 0dh,0ah,'�ض�λ�������Ľڣ�%s',0dh,0ah,0
szMsgReloc2 db 0dh,0ah
            db '--------------------------------------------------------------------------------------------',0dh,0ah
            db '�ض�λ����ַ�� %08x',0dh,0ah
            db '�ض�λ�������� %d',0dh,0ah
            db '--------------------------------------------------------------------------------------------',0dh,0ah
            db '��Ҫ�ض�λ�ĵ�ַ�б�(ffffffff��ʾ������,����Ҫ�ض�λ)',0dh,0ah
            db '--------------------------------------------------------------------------------------------',0dh,0ah,0
szMsgReloc3 db '%08x  ',0
szCrLf      db 0dh,0ah,0
szMsgReloc4 db 0dh,0ah,'δ���ָ��ļ����ض�λ��Ϣ.',0dh,0ah,0

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

;---------------------------------
; ���ڴ�ƫ����RVAת��Ϊ�ļ�ƫ��
; lp_FileHeadΪ�ļ�ͷ����ʼ��ַ
; _dwRVAΪ������RVA��ַ
;---------------------------------
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
    ;����ýڽ���RVA������Misc����Ҫԭ������Щ�ε�Miscֵ�Ǵ���ģ�
    add eax,[edx].SizeOfRawData 
    .if (edi>=[edx].VirtualAddress)&&(edi<eax)
      mov eax,[edx].VirtualAddress
      ;����RVA�ڽ��е�ƫ��
      sub edi,eax                
      mov eax,[edx].PointerToRawData
      ;���Ͻ����ļ��еĵ���ʼλ��
      add eax,edi                
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

;-------------------------------------------
; �������ļ�ͷ���ļ�ƫ��ת��Ϊ�ڴ�ƫ����RVA
; lp_FileHeadΪ�ļ�ͷ����ʼ��ַ
; _dwOffsetΪ�������ļ�ƫ�Ƶ�ַ
;-------------------------------------------
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
    ;����ýڽ���RVA������Misc����Ҫԭ������Щ�ε�Miscֵ�Ǵ���ģ�
    add eax,[edx].SizeOfRawData 
    .if (edi>=[edx].PointerToRawData)&&(edi<eax)
      mov eax,[edx].PointerToRawData
      ;����RVA�ڽ��е�ƫ��
      sub edi,eax                
      mov eax,[edx].VirtualAddress
      ;���Ͻ����ļ��еĵ���ʼλ��
      add eax,edi                
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

;--------------------
; ���ڴ��л�ȡPE�ļ�����Ҫ��Ϣ
;--------------------
_getMainInfo  proc _lpFile,_lpPeHead,_dwSize
  local @szBuffer[1024]:byte
  local @szSecName[16]:byte

  pushad
  mov edi,_lpPeHead
  assume edi:ptr IMAGE_NT_HEADERS
  movzx ecx,[edi].FileHeader.Machine          ;����ƽ̨
  movzx edx,[edi].FileHeader.NumberOfSections ;�ڵ�����
  movzx ebx,[edi].FileHeader.Characteristics  ;�ڵ�����
  invoke wsprintf,addr @szBuffer,addr szMsg,\
         addr szFileName,ecx,edx,ebx,\
         [edi].OptionalHeader.ImageBase,\     ;������װ��ĵ�ַ
         [edi].OptionalHeader.AddressOfEntryPoint
  invoke SetWindowText,hWinEdit,addr @szBuffer;��ӵ��༭����

  ;��ʾÿ���ڵ���Ҫ��Ϣ
  invoke _appendInfo,addr szMsgSec
  movzx ecx,[edi].FileHeader.NumberOfSections
  add edi,sizeof IMAGE_NT_HEADERS
  assume edi:ptr IMAGE_SECTION_HEADER
  .repeat
    push ecx
    ;��ȡ�ڵ����ƣ�ע�ⳤ��Ϊ8�����Ʋ�����0��β
    invoke RtlZeroMemory,addr @szSecName,sizeof @szSecName
    push esi
    push edi
    mov ecx,8
    mov esi,edi
    lea edi,@szSecName
    cld
    @@:
    lodsb
    .if !al  ;�������Ϊ0������ʾΪ�ո�
      mov al,' '
    .endif
    stosb
    loop @B
    pop edi
    pop esi
    ;��ȡ�ڵ���Ҫ��Ϣ
    invoke wsprintf,addr @szBuffer,addr szFmtSec,\
           addr @szSecName,[edi].Misc.VirtualSize,\
           [edi].VirtualAddress,[edi].SizeOfRawData,\
           [edi].PointerToRawData,[edi].Characteristics
    invoke _appendInfo,addr @szBuffer
    add edi,sizeof IMAGE_SECTION_HEADER
    pop ecx
  .untilcxz

  assume edi:nothing
  popad
  ret
_getMainInfo endp

;--------------------
; ��ȡPE�ļ��ĵ����
;--------------------
_getImportInfo proc _lpFile,_lpPeHead,_dwSize
  local @szBuffer[1024]:byte
  local @szSectionName[16]:byte
  
  pushad
  mov edi,_lpPeHead
  assume edi:ptr IMAGE_NT_HEADERS
  mov eax,[edi].OptionalHeader.DataDirectory[8].VirtualAddress
  .if !eax
    invoke _appendInfo,addr szErrNoImport
    jmp _Ret
  .endif
  invoke _RVAToOffset,_lpFile,eax
  add eax,_lpFile
  mov edi,eax     ;��������������ļ�ƫ��λ��
  assume edi:ptr IMAGE_IMPORT_DESCRIPTOR
  invoke _getRVASectionName,_lpFile,[edi].OriginalFirstThunk
  invoke wsprintf,addr @szBuffer,addr szMsg1,eax  ;��ʾ����
  invoke _appendInfo,addr @szBuffer

  .while [edi].OriginalFirstThunk || [edi].TimeDateStamp ||\
                 [edi].ForwarderChain || [edi].Name1 ||\
                 [edi].FirstThunk
    invoke _RVAToOffset,_lpFile,[edi].Name1
    add eax,_lpFile
    invoke wsprintf,addr @szBuffer,addr szMsgImport,eax,\
           [edi].OriginalFirstThunk,[edi].TimeDateStamp,\
           [edi].ForwarderChain,[edi].FirstThunk
    invoke _appendInfo,addr @szBuffer

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
      ;����ŵ���
      .if dword ptr [ebx] & IMAGE_ORDINAL_FLAG32
        mov eax,dword ptr [ebx]
        and eax,0ffffh
        invoke wsprintf,addr @szBuffer,addr szMsg3,eax
      .else  ;�����Ƶ���                                      
        invoke _RVAToOffset,_lpFile,dword ptr [ebx]
        add eax,_lpFile
        assume eax:ptr IMAGE_IMPORT_BY_NAME
        movzx ecx,[eax].Hint
        invoke wsprintf,addr @szBuffer,\
              addr szMsg2,ecx,addr [eax].Name1
        assume eax:nothing
      .endif
      invoke _appendInfo,addr @szBuffer
      add ebx,4
    .endw
    add edi,sizeof IMAGE_IMPORT_DESCRIPTOR
  .endw
_Ret:
  assume edi:nothing
  popad
  ret
_getImportInfo endp

;--------------------
; ��ȡPE�ļ��ĵ�����
;--------------------
_getExportInfo proc _lpFile,_lpPeHead,_dwSize
  local @szBuffer[1024]:byte
  local @szSectionName[16]:byte
  local @lpAddressOfNames,@dwIndex,@lpAddressOfNameOrdinals
  
  pushad
  mov esi,_lpPeHead
  assume esi:ptr IMAGE_NT_HEADERS
  mov eax,[esi].OptionalHeader.DataDirectory[0].VirtualAddress
  .if !eax
    invoke _appendInfo,addr szErrNoExport
    jmp _Ret
  .endif
  invoke _RVAToOffset,_lpFile,eax
  add eax,_lpFile
  mov edi,eax     ;���㵼���������ļ�ƫ��λ��
  assume edi:ptr IMAGE_EXPORT_DIRECTORY
  invoke _RVAToOffset,_lpFile,[edi].nName
  add eax,_lpFile
  mov ecx,eax
  invoke _getRVASectionName,_lpFile,[edi].nName
  invoke wsprintf,addr @szBuffer,addr szMsgExport,\
         eax,ecx,[edi].nBase,[edi].NumberOfFunctions,\
         [edi].NumberOfNames,[edi].AddressOfFunctions,\
         [edi].AddressOfNames,[edi].AddressOfNameOrdinals
  invoke _appendInfo,addr @szBuffer

  invoke _RVAToOffset,_lpFile,[edi].AddressOfNames
  add eax,_lpFile
  mov @lpAddressOfNames,eax
  invoke _RVAToOffset,_lpFile,[edi].AddressOfNameOrdinals
  add eax,_lpFile
  mov @lpAddressOfNameOrdinals,eax
  invoke _RVAToOffset,_lpFile,[edi].AddressOfFunctions
  add eax,_lpFile
  mov esi,eax   ;�����ĵ�ַ��

  mov ecx,[edi].NumberOfFunctions
  mov @dwIndex,0
@@:
  pushad
  mov eax,@dwIndex
  push edi
  mov ecx,[edi].NumberOfNames
  cld
  mov edi,@lpAddressOfNameOrdinals
  repnz scasw
  .if ZERO?  ;�ҵ���������
    sub edi,@lpAddressOfNameOrdinals
    sub edi,2
    shl edi,1
    add edi,@lpAddressOfNames
    invoke _RVAToOffset,_lpFile,dword ptr [edi]
    add eax,_lpFile
  .else
    mov eax,offset szExportByOrd
  .endif
  pop edi
  ;�����ecx��
  mov ecx,@dwIndex
  add ecx,[edi].nBase
  invoke wsprintf,addr @szBuffer,addr szMsg4,\
         ecx,dword ptr [esi],eax
  invoke _appendInfo,addr @szBuffer
  popad
  add esi,4
  inc @dwIndex
  loop @B
_Ret:
  assume esi:nothing
  assume edi:nothing
  popad
  ret
_getExportInfo endp

;--------------------
; ��ȡPE�ļ����ض�λ��Ϣ
;--------------------
_getRelocInfo proc  _lpFile,_lpPeHead,_dwSize
  local @szBuffer[1024]:byte
  local @szSectionName[16]:byte

  pushad
  mov esi,_lpPeHead
  assume esi:ptr IMAGE_NT_HEADERS
  mov eax,[esi].OptionalHeader.DataDirectory[8*5].VirtualAddress
  .if !eax
    invoke _appendInfo,addr szMsgReloc4
    jmp _ret
  .endif
  push eax
  invoke _RVAToOffset,_lpFile,eax
  add eax,_lpFile
  mov esi,eax
  pop eax
  invoke _getRVASectionName,_lpFile,eax
  invoke wsprintf,addr @szBuffer,addr szMsgReloc1,eax
  invoke _appendInfo,addr @szBuffer
  assume esi:ptr IMAGE_BASE_RELOCATION
  ;ѭ������ÿ���ض�λ��
  .while [esi].VirtualAddress
    cld
    lodsd   ;eax=[esi].VirtualAddress
    mov ebx,eax
    lodsd   ;eax=[esi].SizeofBlock
    sub eax,sizeof IMAGE_BASE_RELOCATION  ;���ܳ���-����dd
    shr eax,1                             ;Ȼ�����2���õ��ض�λ������
                                          ;����2����Ϊ�ض�λ����word
    push eax
    invoke wsprintf,addr @szBuffer,addr szMsgReloc2,ebx,eax
    invoke _appendInfo,addr @szBuffer
    pop ecx                               ;�ض�λ������
    xor edi,edi
    .repeat
      push ecx
      lodsw
      mov cx,ax
      and cx,0f000h    ;�õ�����λ
      .if cx==03000h   ;�ض�λ��ַָ���˫�ֵ�32λ����Ҫ����
        and ax,0fffh
        movzx eax,ax
        add eax,ebx    ;�õ�������ǰ��ƫ�ƣ�
                       ;��ƫ�Ƽ���װ��ʱ�Ļ�ַ���Ǿ��Ե�ַ
      .else            ;���ض�λ�������壬��������Ϊ����
        mov eax,-1
      .endif
      invoke wsprintf,addr @szBuffer,addr szMsgReloc3,eax
      inc edi
      .if edi==8       ;ÿ��ʾ8����Ŀ����
        invoke lstrcat,addr @szBuffer,addr szCrLf
        xor edi,edi
      .endif
      invoke _appendInfo,addr @szBuffer
      pop ecx
    .untilcxz
    .if edi
      invoke _appendInfo,addr szCrLf
    .endif
  .endw
_ret:
  assume esi:nothing
  popad
  ret
_getRelocInfo endp
;--------------------
; ��PE�ļ�������
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

          ;����Ϊֹ�����ļ�����֤�Ѿ���ɡ�ΪPE�ṹ�ļ�
          ;�����������ּ�ӳ�䵽�ڴ��е����ݣ�����ʾ��Ҫ����
          invoke _getMainInfo,@lpMemory,esi,@dwFileSize
          ;��ʾ�����
          invoke _getImportInfo,@lpMemory,esi,@dwFileSize
          ;��ʾ������
          invoke _getExportInfo,@lpMemory,esi,@dwFileSize
          ;��ʾ�ض�λ��Ϣ
          invoke _getRelocInfo,@lpMemory,esi,@dwFileSize


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
  .elseif eax==WM_COMMAND     ;�˵�
    mov eax,wParam
    .if eax==IDM_EXIT       ;�˳�
      invoke EndDialog,hWnd,NULL 
    .elseif eax==IDM_OPEN   ;���ļ�
      call _openFile
    .elseif eax==IDM_1  ;���������˵���7��Ķ�����ɵģ���
      invoke MessageBox,NULL,offset szErrFormat,offset szErr,MB_ICONWARNING
    .elseif eax==IDM_2
      invoke MessageBox,NULL,offset szErrFormat,offset szErr,MB_ICONQUESTION	
    .elseif eax==IDM_3
      invoke MessageBox,NULL,offset szErrFormat,offset szErr,MB_YESNOCANCEL
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



