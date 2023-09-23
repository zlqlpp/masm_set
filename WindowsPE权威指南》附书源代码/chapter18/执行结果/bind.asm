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
include    winResult.inc
include    ole32.inc

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
includelib winResult.lib
includelib ole32.lib



ICO_MAIN equ 1000
DLG_MAIN equ 1000
IDC_INFO equ 1001
IDM_MAIN equ 2000
IDM_OPEN equ 2001
IDM_EXIT equ 2002
IDM_1    equ 4000
IDM_2    equ 4001
IDM_3    equ 4002
RESULT_MODULE   equ 5000
ID_TEXT1        equ 5001
ID_TEXT2        equ 5002
IDC_MODULETABLE equ 5003
IDC_OK          equ 5004
ID_STATIC       equ 5005
ID_STATIC1      equ 5006
IDC_BROWSE1     equ 5007
IDC_BROWSE2     equ 5008
IDC_LIST        equ 5010
IDC_MOVE1       equ 5011
IDC_MOVE2       equ  5012
IDC_MOVE3       equ  5013
IDC_MOVE4       equ  5014
IDC_MOVE5       equ  5015
IDC_MOVE6       equ  5016

TOTAL_FILE_COUNT  equ   100        ;�����������ļ��������
BinderFileStruct  STRUCT
  inExeSequence   byte   ?         ;Ϊ0��ʾ��ִ���ļ���Ϊ1��ʾ����ִ������
  dwFileOff       dword   ?        ;�������е���ʼƫ��
  dwFileSize      dword    ?       ;�ļ���С
  name1           db   256 dup(0)  ;�ļ���������Ŀ¼
BinderFileStruct  ENDS

.data
hInstance   dd ?
hRichEdit   dd ?
hWinMain    dd ?
hWinEdit    dd ?
dwCount     dd ?
dwColorRed  dd ?
hText1      dd ?
hText2      dd ?
hFile       dd ?
dwNumber    dd ?
dwCount1    dd ?

hModuleListBox  dd  ?

dwFileSizeHigh dd ?
dwFileSizeLow dd ?
dwFileCount dd ?
dwFolderCount dd ?
dwFileSize    dd ?
dwFileOff     dd ?
dwBindFileCount dd ?        ;���󶨵��ļ���Ŀ

dwPatchCodeSize   dd  ?     ;���������С
dwNewFileSize     dd  ?     ;���ļ���С=Ŀ���ļ���С+���������С
dwNewPatchCodeSize  dd ?    ;�������밴8λ�����Ĵ�С
dwPatchCodeSegStart  dd ?   ;�����������ڽ����ļ��е���ʼ��ַ
dwSectionCount       dd ?   ;Ŀ���ļ��ڵĸ���
dwSections           dd ?   ;���нڱ��С
dwNewHeaders         dd ?   ;���ļ�ͷ�Ĵ�С
dwFileAlign          dd ?   ;�ļ���������
dwFirstSectionStart  dd ?   ;Ŀ���ļ���һ�ھ����ļ���ʼ��ƫ����
dwOff                dd ?   ;���ļ���ԭ��������Ĳ���
dwValidHeadSize      dd ?   ;Ŀ���ļ�PEͷ����Ч���ݳ���
dwHeaderSize         dd ?   ;�ļ�ͷ����
dwBlock1             dd ?   ;ԭPEͷ����Ч���ݳ���+�����������Ч���ݳ���
dwPE_SECTIONSize     dd ?   ;PEͷ+�ڱ��С
dwSectionsLeft       dd ?   ;Ŀ���ļ����н����ݵĴ�С
dwNewSectionSize     dd ?   ;�����ӽڶ����ĳߴ�
dwNewSectionOff      dd ?   ;�����ӽ����������ļ��е�ƫ��
dwDstSizeOfImage     dd ?   ;Ŀ���ļ��ڴ�ӳ��Ĵ�С
dwNewSizeOfImage     dd ?   ;�����ӵĽ����ڴ�ӳ���еĴ�С
dwNewFileAlignSize   dd ?   ;�ļ������Ĵ�С
dwSectionsAlignLeft  dd ?   ;Ŀ���ļ������ļ��ж����Ĵ�С
dwLastSectionAlignSize  dd ?   ;Ŀ���ļ����һ�ڶ��������մ�С����������
dwLastSectionStart      dd ?   ;Ŀ���ļ����һ�����ļ��е�ƫ��
dwSectionAlign          dd ?   ;�ڶ�������
dwVirtualAddress        dd ?   ;���һ�ڵ���ʼRVA
dwEIPOff                dd ?   ;��EIPָ��;�EIPָ��ľ���



dwDstEntryPoint      dd ?   ;�ɵ���ڵ�ַ
dwNewEntryPoint      dd ?   ;�µ���ڵ�ַ

lpPatchPE         dd  ?   ;���������PE��־���ļ��е�λ�ã���Ϊ��0��ʼ���������λ��Ҳ��DOSͷ�Ĵ�С
lpDstMemory       dd  ?   ;�ڴ��д�����ļ����ݵ���ʼ��ַ
lpOthers          dd  ?   ;�����������ļ��е���ʼλ��


lpBinderList1     dd  13ach        ;���б���host.exe�ļ��е�λ�ã������Ҳ��
lpBinderList2     dd  8be8h     


hProcessModuleTable dd ?


szFilter   db '*.*',0
szXie      db '\',0
szPath     db 'c:\ql',256 dup(0)
szFileName           db MAX_PATH dup(?)
szDstFile            db 'c:\host.exe',0
szFileNameOpen1      db 'c:\FlexHEX',MAX_PATH dup(0)    ; Ҫ�󶨵�Ŀ¼
szFileNameOpen2      db 'd:\masm32\source\chapter15\host.exe',MAX_PATH dup(0)   ; ��������

                     ;d:\masm32\source\chapter12\HelloWorld.exe

szResultColName1 db  '���',0
szResultColName2 db  'Ҫ������ļ�',0
szResultColName3 db  '�Ƿ����ִ������',0
szBuffer         db  256 dup(0),0
bufTemp1         db  512 dup(0),0
bufTemp2         db  512 dup(0),0
bufTemp3         db  512 dup(0),0
szFilter1        db  'Excutable Files',0,'*.exe;*.com',0
                 db  0

.const
szDllEdit   db 'RichEd20.dll',0
szClassEdit db 'RichEdit20A',0
szFont      db '����',0
szExtPe     db 'PE File',0,'*.exe;*.dll;*.scr;*.fon;*.drv',0
            db 'All Files(*.*)',0,'*.*',0,0
szErr       db '�ļ���ʽ����!',0
szErrFormat db '����ļ�����PE��ʽ���ļ�!',0
szNotFound  db '�޷�����',0
szTooManyFiles db '�ļ�̫�࣬��������ʧ�ܣ��볢�Լ����ļ�����',0
szSuccess    db '����ɹ�����鿴Ŀ���ļ�c:\host.exe',0
szNewSection db 'PEBindQL',0
sz1          db '%d',0

szCrLf      db 0dh,0ah,0

szOut100       db '��������δ�С��%08x',0dh,0ah,0
szOut104       db '��϶һ�Ĵ�СΪ��%08x',0dh,0ah,0
szOut101       db 'Ŀ��PE�ļ�ͷ����Ч���ݳ���Ϊ��%08x ',0dh,0ah,0
szOut102       db 'Ŀ��PE�ļ�ͷ��Ч���ݳ��ȶ�����ֵΪ��%08x',0dh,0ah,0
szOut103       db '���ļ���PEͷ������λ�������ļ�ƫ�ƣ�%08x��',0dh,0ah,0
szOut105       db 'ԭ�ļ���СΪ��%08x   �Ӳ���������ļ��Ĵ�СΪ��%08x',0dh,0ah,0
szOut106       db 'Ŀ��PE����ڵ�ַΪ��%08x',0dh,0ah,0
szOut107       db '������Ҫ�������ļ�ƫ�Ƶ�ַ���£�',0dh,0ah,0
szOut108       db '   ������%s     ԭʼƫ�ƣ�%08x     �������ƫ�ƣ�%08x',0dh,0ah,0
szOut109       db '���ļ���PEͷʵ�ʴ�СΪ��%08x',0dh,0ah,0
szOut110       db '�ڱ�������λ���ļ���ƫ�ƣ�%08x',0dh,0ah,0
szOut111       db 'Ŀ��������нڱ�ռ�õ��ֽ�����%08x',0dh,0ah,0
szOut112       db '���������е�E9ָ���Ĳ���������Ϊ��%08x',0dh,0ah,0
szOut113       db 'Ŀ��PEͷ�����ݵ���Ч����Ϊ:%08x',0dh,0ah,0
szOut114       db '�����ڰ����ļ��������ȶ����Ժ�Ĵ�СΪ:%08x',0dh,0ah,0
szOut115       db '��PE�ļ�����ڵ�ַΪ��%08x',0dh,0ah,0

szOut121       db 'PE�ļ���С��%08x   �����Ժ�Ĵ�С��%08x',0dh,0ah,0
szOut122       db 'Ŀ���ļ����һ�����ļ��е���ʼƫ�ƣ�%08x',0dh,0ah,0
szOut123       db 'Ŀ���ļ����һ�ڶ����Ĵ�С��%08x',0dh,0ah,0
szOut124       db '���ļ���С��%08x',0dh,0ah,0

szOut1      db '��������%s',0dh,0ah,0
szOut2      db 'Ŀ��PE����%s',0dh,0ah,0
szOutErr    db '����γ��ȴ���0DA8h����϶һ�Ŀռ䲻�㣡',0dh,0ah,0
lpszHexArr  db  '0123456789ABCDEF',0

.data?
stLVC         LV_COLUMN <?>
stLVI         LV_ITEM   <?>

.code

include _BrowseFolder.asm

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

  ;��ʾ���б���
  
  invoke SendMessage,hModuleListBox,LB_ADDSTRING,\
                     0,_lpszFile
  inc dwFileCount
  invoke CreateFile,_lpszFile,GENERIC_READ,FILE_SHARE_READ,0,\
   OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
  .if eax != INVALID_HANDLE_VALUE
   mov @hFile,eax
   invoke GetFileSize,eax,NULL

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


;--------------------------------------
; ��ȡĿ��PEͷ�����ݵ���Ч����
;--------------------------------------
getValidHeadSize proc _lpFileHead
  local @dwReturn
  local @dwTemp
  
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  mov eax,[edx].PointerToRawData     ;ָ���һ���ڵ���ʼ
  mov @dwTemp,eax

  dec eax
  mov esi,eax
  add esi,_lpFileHead
  mov @dwReturn,0
  .repeat
    mov bl,byte ptr [esi]
    .if bl!=0
      .break
    .endif
    dec esi
    inc @dwReturn
  .until FALSE
  mov eax,@dwTemp
  sub eax,@dwReturn
  add eax,2          ;Ϊ��Ч������������0�ַ�������������Ч����Ϊ�ַ�����������0����
  mov @dwReturn,eax

  popad
  mov eax,@dwReturn

  ret
getValidHeadSize endp

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

;------------------------------------------
; ������Ŀ¼
;------------------------------------------
_OpenFile1	proc
		local	@stOF:OPENFILENAME
		local	@stES:EDITSTREAM

                invoke GetCurrentDirectory,sizeof szPath,addr szPath
                invoke _BrowseFolder,NULL,addr szPath
                .if eax
                  invoke SetWindowText,hText1,addr szPath
                .endif
                invoke wsprintf,addr szBuffer,addr szOut1,addr szPath
                invoke _appendInfo,addr szBuffer
                invoke SendMessage,hModuleListBox,LB_RESETCONTENT,0,0
                invoke _FindFile,addr szPath
		ret

_OpenFile1	endp
;------------------------------------------
; �������ļ�
;------------------------------------------
_OpenFile2	proc
		local	@stOF:OPENFILENAME
		local	@stES:EDITSTREAM

                ;�����֮ǰ�����ļ�������ڣ����ȹر��ٸ�ֵ                
                .if hFile
                   invoke CloseHandle,hFile
                   mov hFile,0
                .endif
                ; ��ʾ�����ļ����Ի���
		invoke	RtlZeroMemory,addr @stOF,sizeof @stOF
		mov	@stOF.lStructSize,sizeof @stOF
		push	hWinMain
		pop	@stOF.hwndOwner
                push    hInstance
                pop     @stOF.hInstance
		mov	@stOF.lpstrFilter,offset szFilter1
		mov	@stOF.lpstrFile,offset szFileNameOpen2
		mov	@stOF.nMaxFile,MAX_PATH
		mov	@stOF.Flags,OFN_FILEMUSTEXIST or\
                                    OFN_HIDEREADONLY or OFN_PATHMUSTEXIST
		invoke	GetOpenFileName,addr @stOF
		.if	eax
                        invoke SetWindowText,hText2,addr szFileNameOpen2
		.endif
                invoke wsprintf,addr szBuffer,addr szOut2,addr szFileNameOpen2
                invoke _appendInfo,addr szBuffer
                invoke _appendInfo,addr szCrLf
		ret

_OpenFile2	endp


;-------------------------
; ��ListView������һ����
; ���룺_dwColumn = ���ӵ��б��
;	_dwWidth = �еĿ��
;	_lpszHead = �еı����ַ��� 
;-------------------------
_ListViewAddColumn	proc  uses ebx ecx _hWinView,_dwColumn,_dwWidth,_lpszHead
		local	@stLVC:LV_COLUMN

		invoke	RtlZeroMemory,addr @stLVC,sizeof LV_COLUMN
		mov	@stLVC.imask,LVCF_TEXT or LVCF_WIDTH or LVCF_FMT
		mov	@stLVC.fmt,LVCFMT_LEFT
		push	_lpszHead
		pop	@stLVC.pszText
		push	_dwWidth
		pop	@stLVC.lx
              push  _dwColumn
              pop   @stLVC.iSubItem
		invoke	SendMessage,_hWinView,LVM_INSERTCOLUMN,_dwColumn,addr @stLVC
		ret
_ListViewAddColumn	endp
;----------------------------------------------------------------------
; ��ListView������һ�У����޸�һ����ĳ���ֶε�����
; ���룺_dwItem = Ҫ�޸ĵ��еı��
;	_dwSubItem = Ҫ�޸ĵ��ֶεı�ţ�-1��ʾ�����µ��У�>=1��ʾ�ֶεı��
;-----------------------------------------------------------------------
_ListViewSetItem	proc uses ebx ecx _hWinView,_dwItem,_dwSubItem,_lpszText
              invoke  RtlZeroMemory,addr stLVI,sizeof LV_ITEM

              invoke lstrlen,_lpszText
              mov stLVI.cchTextMax,eax
              mov stLVI.imask,LVIF_TEXT
              push _lpszText
              pop stLVI.pszText
              push _dwItem
              pop stLVI.iItem
              push _dwSubItem
              pop stLVI.iSubItem

              .if _dwSubItem == -1
                 mov stLVI.iSubItem,0
                 invoke SendMessage,_hWinView,LVM_INSERTITEM,NULL,addr stLVI
              .else
                 invoke SendMessage,_hWinView,LVM_SETITEM,NULL,addr stLVI
              .endif
              
              ret

_ListViewSetItem	endp
;----------------------
; ���ListView�е�����
; ɾ�����е��к����е���
;----------------------
_ListViewClear	proc uses ebx ecx _hWinView

		invoke	SendMessage,_hWinView,LVM_DELETEALLITEMS,0,0
		.while	TRUE
			invoke	SendMessage,_hWinView,LVM_DELETECOLUMN,0,0
			.break	.if ! eax
		.endw
		ret

_ListViewClear	endp

;---------------------
; ����ָ�����е�ֵ
; �����szBuffer��
;---------------------
_GetListViewItem   proc  _hWinView:DWORD,_dwLine:DWORD,_dwCol:DWORD,_lpszText
              local @stLVI:LV_ITEM
              
              invoke	RtlZeroMemory,addr @stLVI,sizeof LV_ITEM
              invoke RtlZeroMemory,_lpszText,512

              mov  @stLVI.cchTextMax,512
              mov  @stLVI.imask,LVIF_TEXT
              push   _lpszText
              pop  @stLVI.pszText
              push _dwCol
              pop  @stLVI.iSubItem

              invoke SendMessage,_hWinView,LVM_GETITEMTEXT,_dwLine,addr @stLVI
              ret
_GetListViewItem   endp
;---------------------
; ��ʼ��������
;---------------------
_clearResultView  proc uses ebx ecx
             invoke _ListViewClear,hProcessModuleTable

             ;��ӱ�ͷ
             mov ebx,1
             mov eax,100
             lea ecx,szResultColName1
             invoke _ListViewAddColumn,hProcessModuleTable,ebx,eax,ecx

             mov ebx,2
             mov eax,600
             lea ecx,szResultColName2
             invoke _ListViewAddColumn,hProcessModuleTable,ebx,eax,ecx

             mov ebx,3
             mov eax,200
             lea ecx,szResultColName3
             invoke _ListViewAddColumn,hProcessModuleTable,ebx,eax,ecx

             mov dwCount,0
             ret
_clearResultView  endp

;--------------------------------------------
; �ڱ��������һ��
; _lpSZΪ��һ��Ҫ��ʾ���ֶ���
; _lpSP1Ϊ��һ���ļ����ֶε�λ��
; _lpSP2Ϊ�ڶ����ļ����ֶε�λ��
; _SizeΪ���ֶε��ֽڳ���
;--------------------------------------------
_addLine proc _lpSZ1,_lpSZ2
  pushad

  inc dwNumber
  invoke _ListViewSetItem,hProcessModuleTable,dwNumber,-1,\
               addr bufTemp1             ;�ڱ����������һ��
  mov dwCount,eax
  invoke RtlZeroMemory,addr bufTemp1,200
  invoke wsprintf,addr bufTemp1,addr sz1,dwNumber

  xor ebx,ebx
  invoke _ListViewSetItem,hProcessModuleTable,dwCount,ebx,\
         addr bufTemp1                  ; 
  
  inc ebx
  invoke _ListViewSetItem,hProcessModuleTable,dwCount,ebx,\
                   _lpSZ1 ;�ļ���
  inc ebx
  invoke _ListViewSetItem,hProcessModuleTable,dwCount,ebx,\
                   _lpSZ2 ;�Ƿ���ִ������

  popad
  ret
_addLine  endp



;--------------------------
; ��_lpPointλ�ô�_dwSize���ֽ�ת��Ϊ16���Ƶ��ַ���
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

    ;invoke wsprintf,addr szBuffer,addr szOut2,edx
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

_MemCmp  proc _lp1,_lp2,_size
   local @dwResult:dword

   pushad
   mov esi,_lp1
   mov edi,_lp2
   mov ecx,_size
   .repeat
     mov al,byte ptr [esi]
     mov bl,byte ptr [edi]
     .break .if al!=bl
     inc esi
     inc edi
     dec ecx
     .break .if ecx==0
   .until FALSE
   .if ecx!=0
     mov @dwResult,1
   .else 
     mov @dwResult,0
   .endif
   popad
   mov eax,@dwResult
   ret
_MemCmp  endp


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
;--------------
;
;--------------------
writeToFile proc _lpFile,_dwSize
  local @dwWritten
  pushad
  invoke CreateFile,addr szDstFile,GENERIC_WRITE,\
            FILE_SHARE_READ,\
                0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
  mov hFile,eax
  invoke WriteFile,hFile,_lpFile,_dwSize,addr @dwWritten,NULL
  invoke CloseHandle,hFile      
  popad
  ret
writeToFile endp

;-------------------------------------
; �ı�Ŀ��PE�ڵ��ļ�ƫ������
;-------------------------------------
changeRawOffset proc _lpHeader0,_lpHeader
  local @dwSize,@dwSectionSize
  local @ret
  local @dwTemp,@dwTemp1
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

  

  mov edi,lpDstMemory
  assume edi:ptr IMAGE_DOS_HEADER
  add edi,[edi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
  assume edi:ptr IMAGE_NT_HEADERS
   
  pushad
  invoke _appendInfo,addr szCrLf
  invoke _appendInfo,addr szOut107
  popad

  add edi,sizeof IMAGE_NT_HEADERS   ;ediָ��ڱ�λ��
  .repeat
     assume edi:ptr IMAGE_SECTION_HEADER
     mov ebx,[edi].PointerToRawData  ;ȡ�����ļ��е�ƫ��
     mov @dwTemp,ebx
     add ebx,dwOff      ;������ֵ
     mov @dwTemp1,ebx
     mov dword ptr [edi].PointerToRawData,ebx

     ; ��ʾ
     pushad
     mov eax,[edi].VirtualAddress
     inc eax
     invoke _getRVASectionName,_lpHeader,eax
     invoke wsprintf,addr szBuffer,addr szOut108,eax,@dwTemp,@dwTemp1
     invoke _appendInfo,addr szBuffer 
     popad  

     dec @dwSectionSize
     add edi,sizeof IMAGE_SECTION_HEADER
     .break .if @dwSectionSize==0
  .until FALSE
   

  popad 
  ret
changeRawOffset  endp


;-------------------------
; ���¼��㱻ѡ���ļ��Ĵ�С
;-------------------------
_calcFileSize  proc
  local @dwCount
  local @hFile1

  pushad

  mov dwFileSizeLow,0
  mov dwFileSizeHigh,0
  invoke SendMessage,hProcessModuleTable,\
        LVM_GETITEMCOUNT,0,0
  mov dwBindFileCount,eax
  mov @dwCount,0
  .repeat
    ;��ȡָ����ָ���е���Ϣ�����ļ�·��
    invoke RtlZeroMemory,addr szBuffer,512
    invoke _GetListViewItem,hProcessModuleTable,\
          @dwCount,1,addr szBuffer
    ;���ļ������ļ���С
    invoke CreateFile,addr szBuffer,GENERIC_READ,\
         FILE_SHARE_READ or FILE_SHARE_WRITE,NULL,\
         OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE,NULL

    .if eax!=INVALID_HANDLE_VALUE
      mov @hFile1,eax
      invoke GetFileSize,eax,NULL
      add dwFileSizeLow,eax
      adc dwFileSizeHigh,0
    .endif 
    invoke CloseHandle,@hFile1
    inc @dwCount
    mov eax,dwBindFileCount
    .break .if @dwCount==eax
  .until FALSE

  popad
  ret
_calcFileSize  endp


;--------------------
; �����б�
; ��ڲ�����
;  _dwNumber   ���ļ�˳�ţ���λ��
;  _inExe      �Ƿ���ִ���б���
;  _dwOff      �����ļ�ƫ��
;  _Size       �ļ���С
;  _lpSZ       ·��  d:\masm32\source\a\b\c\host.exe
;              ע�����Ǿ���·����Ҫ�����ʱ����Ϊ��Ե�ǰĿ¼�����·��a\b\c\host.exe
;--------------------
_writeToBinderList  proc  _dwNumber,_inExe,_dwOff,_Size,_lpSZ
  local @dwSize
  local @dwTemp

  pushad


  mov eax,lpDstMemory      ;�����������б���д�������ļ�������
  add eax,lpBinderList1
  add eax,4
  mov esi,eax

  xor edx,edx               ;��λָ��
  mov eax,_dwNumber
  mov ebx,sizeof BinderFileStruct
  mul ebx
  add esi,eax

  assume esi:ptr BinderFileStruct

  mov eax,lpDstMemory      ;�����������б���д�������ļ�������
  add eax,lpBinderList2
  add eax,4
  mov edi,eax

  xor edx,edx
  mov eax,_dwNumber         ;��λָ��
  mov ebx,sizeof BinderFileStruct
  mul ebx
  add edi,eax

  assume edi:ptr BinderFileStruct


  mov eax,_inExe
  mov byte ptr [esi].inExeSequence,al
  mov eax,_dwOff
  mov [esi].dwFileOff,eax
  mov eax,_Size
  mov [esi].dwFileSize,eax



  pushad
  invoke lstrlen,_lpSZ
  mov @dwSize,eax
  invoke lstrlen,addr szPath    ;��ȡ��ǰĿ¼�ַ����ĳ���
  mov @dwTemp,eax
  inc @dwTemp         ;����б��
  popad
  mov eax,_lpSZ        ;������ǰĿ¼
  add eax,@dwTemp
  mov _lpSZ,eax
  mov eax,@dwSize
  sub eax,@dwTemp
  invoke MemCopy,_lpSZ,addr [esi].name1,eax
     
  mov eax,_inExe
  mov byte ptr [edi].inExeSequence,al
  mov eax,_dwOff
  mov [edi].dwFileOff,eax
  mov eax,_Size
  mov [edi].dwFileSize,eax

  mov eax,@dwSize
  sub eax,@dwTemp
  invoke MemCopy,_lpSZ,addr [edi].name1,eax

  popad
  ret
_writeToBinderList endp

;--------------------
; ��PE�ļ�������
;--------------------
_openFile proc
  local @stOF:OPENFILENAME
  local @hFile,@dwFileSize,@hMapFile,@lpMemory
  local @hFile1,@dwFileSize1,@hMapFile1,@lpMemory1
  local @bufTemp1[10]:byte
  local @dwTemp:dword,@dwTemp1:dword
  local @dwBuffer,@lpDst,@hDstFile
  local @dwCount,@dwInExe
  

  ;���������򣬲�ӳ�䵽�ڴ��ļ�
  invoke CreateFile,addr szFileNameOpen2,GENERIC_READ,\
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

  ;���ļ��Ĵ�С�����ļ��������ȶ���

  ;���¼����ļ���С
  invoke _calcFileSize

  mov eax,dwFileSizeLow
  add eax,@dwFileSize1
  adc dwFileSizeHigh,0

  mov eax,dwFileSizeHigh
  .if eax>0  ;���ӵ��ֽ���̫�󣬳�������ʧ��
    invoke MessageBox,NULL,addr szTooManyFiles,NULL,MB_OK
    jmp _ErrFormat1
  .endif
  mov eax,dwBindFileCount
  .if eax>TOTAL_FILE_COUNT  ;�ļ�̫�࣬��������ʧ��
    invoke MessageBox,NULL,addr szTooManyFiles,NULL,MB_OK
    jmp _ErrFormat1
  .endif
 
  invoke getFileAlign,@lpMemory1
  mov dwFileAlign,eax
  xchg eax,ecx
  mov eax,@dwFileSize1
  invoke _align
  mov dwNewFileAlignSize,eax

  invoke wsprintf,addr szBuffer,addr szOut121,@dwFileSize1,dwNewFileAlignSize
  invoke _appendInfo,addr szBuffer 

  ;�����һ�����ļ��е�ƫ��
  invoke getLastSectionStart,@lpMemory1
  mov dwLastSectionStart,eax

  invoke wsprintf,addr szBuffer,addr szOut122,eax
  invoke _appendInfo,addr szBuffer 

  ;�����һ�ڴ�С
  mov eax,dwNewFileAlignSize
  sub eax,dwLastSectionStart
  add eax,dwFileSizeLow
  ;����ֵ�����ļ��������ȶ���
  mov ecx,dwFileAlign
  invoke _align
  mov dwLastSectionAlignSize,eax      ;���һ�ڸ����������ļ����´�С

  invoke wsprintf,addr szBuffer,addr szOut123,eax
  invoke _appendInfo,addr szBuffer 


  ;�����ļ���С
  mov eax,dwLastSectionStart
  add eax,dwLastSectionAlignSize
  mov dwNewFileSize,eax

  invoke wsprintf,addr szBuffer,addr szOut124,eax
  invoke _appendInfo,addr szBuffer 
 

  ;�����ڴ�ռ�
  invoke GlobalAlloc,GHND,dwNewFileSize
  mov @hDstFile,eax
  invoke GlobalLock,@hDstFile
  mov lpDstMemory,eax   ;��ָ���@lpDst

  
  ;��Ŀ���ļ��������ڴ�����
  mov ecx,@dwFileSize1   
  invoke MemCopy,@lpMemory1,lpDstMemory,ecx


  ;���������ļ�
  
  ;�����б������ݵ���Ŀ
  invoke SendMessage,hProcessModuleTable,\
        LVM_GETITEMCOUNT,0,0
  mov dwBindFileCount,eax
  mov @dwCount,0

  mov edi,lpDstMemory
  add edi,dwNewFileAlignSize

  .repeat
    push edi
    ;��ȡָ����ָ���е���Ϣ�����ļ�·��
    invoke RtlZeroMemory,addr szBuffer,512
    invoke _GetListViewItem,hProcessModuleTable,\
          @dwCount,1,addr szBuffer
    ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK    
    

    invoke CreateFile,addr szBuffer,GENERIC_READ,\
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
          .endif
        .endif
      .endif
    .endif    

    
    invoke RtlZeroMemory,addr bufTemp1,512
    invoke _GetListViewItem,hProcessModuleTable,\
          @dwCount,2,addr bufTemp1    
    invoke atodw,addr bufTemp1
    mov @dwInExe,eax         ;�Ƿ���EXEִ������

    ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK

    mov eax,lpDstMemory      ;�����������б���д�������ļ�������
    add eax,lpBinderList1
    xchg ebx,eax
    mov eax,dwBindFileCount
    mov dword ptr [ebx],eax
   
    mov eax,lpDstMemory
    add eax,lpBinderList2
    xchg ebx,eax
    mov eax,dwBindFileCount
    mov dword ptr [ebx],eax


    pop edi
    mov edx,edi              ;ȡ�ļ���Ŀ���е�ƫ��ֵ
    sub edx,lpDstMemory
   
    ;�����ֵд�������б�    ˳��   �Ƿ���EXE����    ƫ��   �ļ���С   �ļ���
    invoke _writeToBinderList,@dwCount,@dwInExe,edx,@dwFileSize,addr szBuffer
    
    mov esi,@lpMemory
    ;���ļ����ݿ�����Ŀ���ļ�
    mov ecx,@dwFileSize
    rep movsb
    
    ;ȡ��ӳ��
    push edi
    invoke UnmapViewOfFile,@lpMemory
    invoke CloseHandle,@hMapFile
    invoke CloseHandle,@hFile
    pop edi

    inc @dwCount
    nop
    mov eax,dwBindFileCount
    .break .if @dwCount==eax
  .until FALSE


  ;---------------------------����Ϊֹ�����ݿ������  

  ;����




  ;����SizeOfRawData
  invoke _getRVACount,lpDstMemory
  xor edx,edx
  dec eax
  mov ecx,sizeof IMAGE_SECTION_HEADER
  mul ecx

  mov edi,lpDstMemory
  assume edi:ptr IMAGE_DOS_HEADER
  add edi,[edi].e_lfanew
  add edi,sizeof IMAGE_NT_HEADERS  
  add edi,eax
  assume edi:ptr IMAGE_SECTION_HEADER
  mov eax,dwLastSectionAlignSize
  mov [edi].SizeOfRawData,eax

  ;����Miscֵ
  invoke getSectionAlign,@lpMemory1
  mov dwSectionAlign,eax
  xchg eax,ecx
  mov eax,dwLastSectionAlignSize
  invoke _align
  mov [edi].Misc,eax

  ;����VirtualAddress

  mov eax,[edi].VirtualAddress  ;ȡԭʼRVAֵ
  mov dwVirtualAddress,eax

  mov edi,lpDstMemory
  assume edi:ptr IMAGE_DOS_HEADER
  add edi,[edi].e_lfanew    
  assume edi:ptr IMAGE_NT_HEADERS
  ;����SizeOfImage
  mov eax,dwLastSectionAlignSize
  mov ecx,dwSectionAlign
  invoke _align
  ;��ȡ���һ���ڵ�VirtualAddress
  add eax,dwVirtualAddress
  mov [edi].OptionalHeader.SizeOfImage,eax  
  
  
 
  ;�����ļ�����д�뵽c:\bindC.exe
  invoke writeToFile,lpDstMemory,dwNewFileSize
 
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
_openFile endp

;-------------------
; �������ڳ���
;-------------------
_resultProcMain   proc  uses ebx edi esi hProcessModuleDlg:HWND,wMsg,wParam,lParam
          local @dwCount
          local @lpLFI:LVFINDINFO
          local @stLVI:LV_ITEM

          mov eax,wMsg

          .if eax==WM_CLOSE
             invoke EndDialog,hProcessModuleDlg,NULL
          .elseif eax==WM_INITDIALOG
             invoke GetDlgItem,hProcessModuleDlg,IDC_MODULETABLE
             mov hProcessModuleTable,eax
             invoke GetDlgItem,hProcessModuleDlg,ID_TEXT1
             mov hText1,eax
             invoke GetDlgItem,hProcessModuleDlg,ID_TEXT2
             mov hText2,eax

             invoke GetDlgItem,hProcessModuleDlg,IDC_LIST
             mov hModuleListBox,eax

             invoke SendMessage,hProcessModuleTable,LVM_SETEXTENDEDLISTVIEWSTYLE,\
                    0,LVS_EX_GRIDLINES or LVS_EX_FULLROWSELECT
             invoke ShowWindow,hProcessModuleTable,SW_SHOW
             invoke _clearResultView
             mov dwNumber,0

          .elseif eax==WM_NOTIFY
            mov eax,lParam
            mov ebx,lParam
            ;���ĸ��ؼ�״̬
            mov eax,[eax+NMHDR.hwndFrom]
            .if eax==hProcessModuleTable
                mov ebx,lParam
                .if [ebx+NMHDR.code]==NM_CUSTOMDRAW  ;�滭ʱ
                  mov ebx,lParam
                  assume ebx:ptr NMLVCUSTOMDRAW  
                  .if [ebx].nmcd.dwDrawStage==CDDS_PREPAINT
                     invoke SetWindowLong,hProcessModuleDlg,DWL_MSGRESULT,CDRF_NOTIFYITEMDRAW
                     mov eax,TRUE
                  .elseif [ebx].nmcd.dwDrawStage==CDDS_ITEMPREPAINT

                     invoke _GetListViewItem,hProcessModuleTable,[ebx].nmcd.dwItemSpec,1,\
                        addr bufTemp1
                     invoke _GetListViewItem,hProcessModuleTable,[ebx].nmcd.dwItemSpec,2,\
                        addr bufTemp2
                     invoke atodw,addr bufTemp2
                     
                     ;invoke lstrlen,addr bufTemp1
                     ;invoke _MemCmp,addr bufTemp1,addr bufTemp2,eax
                     
                     .if eax==1
                        mov [ebx].clrTextBk,0a0a0ffh
                     .else
                        mov [ebx].clrTextBk,0ffffffh
                     .endif
                     invoke SetWindowLong,hProcessModuleDlg,DWL_MSGRESULT,CDRF_DODEFAULT
                     mov eax,TRUE
                   .endif
                .elseif [ebx+NMHDR.code]==NM_CLICK
                    assume ebx:ptr NMLISTVIEW
                .endif
            .endif
          .elseif eax==WM_COMMAND
             mov eax,wParam
             .if ax==IDC_OK  ;ִ������
                invoke _openFile
                invoke MessageBox,NULL,addr szSuccess,NULL,MB_OK
             .elseif ax==IDC_BROWSE1
                invoke _OpenFile1
             .elseif ax==IDC_BROWSE2
                invoke _OpenFile2
             .elseif ax==IDC_MOVE1   ;ȫ��ѡ��
                ; ��listbox�е�����ֵ����������
                 mov dwNumber,0
                 invoke _clearResultView
                 invoke SendMessage,hModuleListBox,\
                        LB_GETCOUNT,0,0
                 mov dwCount1,eax

                 invoke wsprintf,addr bufTemp2,addr sz1,dwCount1        ;������ִ������
                 invoke _appendInfo,addr bufTemp2
                 invoke _appendInfo,addr szCrLf

                 mov @dwCount,0
                 .repeat
                   invoke RtlZeroMemory,addr szBuffer,512
                   invoke SendMessage,hModuleListBox,\
                        LB_GETTEXT,@dwCount,addr szBuffer
                   invoke _appendInfo,addr szCrLf
                   invoke _appendInfo,addr szBuffer
                   invoke _appendInfo,addr szCrLf

                   invoke wsprintf,addr bufTemp3,addr sz1,0        ;������ִ������
                   invoke _addLine,addr szBuffer,addr bufTemp3
                   
                   inc @dwCount
                   dec dwCount1
                   mov eax,dwCount1
                   .break .if eax==0
                 .until FALSE
             .elseif ax==IDC_MOVE2   ;ȫ��ѡ�У�����EXE�ļ�������ִ������
                ; ��listbox�е�����ֵ����������
                 mov dwNumber,0
                 invoke _clearResultView
                 invoke SendMessage,hModuleListBox,\
                        LB_GETCOUNT,0,0
                 mov dwCount1,eax

                 invoke wsprintf,addr bufTemp2,addr sz1,dwCount1        ;������ִ������
                 invoke _appendInfo,addr bufTemp2
                 invoke _appendInfo,addr szCrLf

                 mov @dwCount,0
                 .repeat
                   invoke RtlZeroMemory,addr szBuffer,512
                   invoke SendMessage,hModuleListBox,\
                        LB_GETTEXT,@dwCount,addr szBuffer
                   invoke _appendInfo,addr szCrLf
                   invoke _appendInfo,addr szBuffer
                   invoke _appendInfo,addr szCrLf

                   invoke _isExeFile,addr szBuffer
                   .if eax==0
                     invoke wsprintf,addr bufTemp3,addr sz1,0        ;������ִ������
                     invoke _addLine,addr szBuffer,addr bufTemp3
                   .else
                     invoke wsprintf,addr bufTemp3,addr sz1,1        ;������ִ������
                     invoke _addLine,addr szBuffer,addr bufTemp3
                   .endif
                   inc @dwCount
                   dec dwCount1
                   mov eax,dwCount1
                   .break .if eax==0
                 .until FALSE
             .elseif ax==IDC_MOVE3   ;ѡ��һ��
                ; ��listbox�е�����ֵ����������
                invoke RtlZeroMemory,addr szBuffer,512
                invoke SendMessage,hModuleListBox,LB_GETCURSEL,0,0
                invoke SendMessage,hModuleListBox,\
                      LB_GETTEXT,eax,addr szBuffer
                invoke _appendInfo,addr szCrLf
                invoke _appendInfo,addr szBuffer
                invoke _appendInfo,addr szCrLf

                invoke wsprintf,addr bufTemp3,addr sz1,0        ;������ִ������
                invoke _addLine,addr szBuffer,addr bufTemp3
             .elseif ax==IDC_MOVE4   ;ѡ��һ��������ִ������
                ; ��listbox�е�����ֵ����������
                invoke RtlZeroMemory,addr szBuffer,512
                invoke SendMessage,hModuleListBox,LB_GETCURSEL,0,0
                invoke SendMessage,hModuleListBox,\
                      LB_GETTEXT,eax,addr szBuffer
                invoke _appendInfo,addr szCrLf
                invoke _appendInfo,addr szBuffer
                invoke _appendInfo,addr szCrLf

                invoke wsprintf,addr bufTemp3,addr sz1,1        ;������ִ������
                invoke _addLine,addr szBuffer,addr bufTemp3     
             .elseif ax==IDC_MOVE5   ;�Ƴ���ǰѡ��
                invoke SendDlgItemMessage,hProcessModuleDlg,\   ;��ȡ��ǰ���ѡ�е���
                        IDC_MODULETABLE,LVM_GETSELECTIONMARK,0,0 
                .if eax!=-1
                  invoke SendDlgItemMessage,hProcessModuleDlg,\
                         IDC_MODULETABLE,LVM_DELETEITEM,eax,0
                  dec dwNumber
                .endif
             .elseif ax==IDC_MOVE6   ;ȫ��ȡ��
                 invoke _clearResultView
                 mov dwNumber,0
             .endif
         .else
             mov eax,FALSE
             ret
         .endif
         mov eax,TRUE
         ret
_resultProcMain    endp


;-------------------
;�򿪶Աȴ���
;-------------------
_doComp proc
  pushad

  popad
  ret
_doComp endp
;-------------------
; ���ڳ���
;-------------------
_ProcDlgMain proc uses ebx edi esi hWnd,wMsg,wParam,lParam
  mov eax,wMsg
  .if eax==WM_CLOSE
    invoke FadeOutClose,hWnd
    invoke EndDialog,hWnd,NULL
  .elseif eax==WM_INITDIALOG  ;��ʼ��
    push hWnd
    pop hWinMain
    call _init
    invoke FadeInOpen,hWnd
  .elseif eax==WM_COMMAND     ;�˵�
    mov eax,wParam
    .if eax==IDM_EXIT       ;�˳�
      invoke FadeOutClose,hWnd
      invoke EndDialog,hWnd,NULL 
    .elseif eax==IDM_OPEN   ;���ļ�
        invoke _OpenFile1
    .elseif eax==IDM_1  
        invoke _OpenFile2
    .elseif eax==IDM_2
        ;���ڴ�ӳ���ļ�����һ�ݣ�������϶һ
         invoke DialogBoxParam,hInstance,RESULT_MODULE,hWnd,\
               offset _resultProcMain,0
         invoke InvalidateRect,hWnd,NULL,TRUE
         invoke UpdateWindow,hWnd
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
  invoke InitCommonControls
  invoke LoadLibrary,offset szDllEdit
  mov hRichEdit,eax
  invoke GetModuleHandle,NULL
  mov hInstance,eax
  invoke DialogBoxParam,hInstance,\
         DLG_MAIN,NULL,offset _ProcDlgMain,NULL
  invoke FreeLibrary,hRichEdit
  invoke ExitProcess,NULL
  end start



