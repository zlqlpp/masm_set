;-------------------------------------------
; ��patch.ext����������뵽ָ��exe�ļ�����������
; ��Ҫ��ʾ���ʹ�ó����޸�PE�ļ���ʽ���Ӷ������
; Ҫʵ�ֵĹ���
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
szBuffer    db 1024 dup(?)
dwFunctions db 1024 dup(11h)  ;��¼ÿ����̬���ӿ����õĺ���������
                                         ;����,������������0
szBuffer1   db 1024 dup(0)
szBuffer2   db 1024 dup(0)
bufTemp1         db  200 dup(0),0
bufTemp2         db  200 dup(0),0


dwPatchDataSize      dd ?  ;�������ݶδ�С
dwPatchDataStart     dd ?  ;����������ʼ��ַ
dwPatchMemDataStart  dd ?  ;�������ݶ����ڴ��е���ʼ��ַ
dwDstDataSize        dd ?  ;Ŀ�����ݶδ�С
dwDstDataStart       dd ?  ;Ŀ��������ʼ��ַ
dwDstRawDataSize     dd ?  ;Ŀ���������ļ��ж����Ĵ�С
dwDstMemDataStart     dd ? ;Ŀ�����ݶ����ڴ��е���ʼ��ַ
dwStartAddressinDstDS dd ? ;�����ӵĲ������ݶ���Ŀ���ļ��е���ʼλ��
dwDataLeft            dd ? ;���ݶ�ʣ��ռ�

dwPatchImportSegSize      dd ?  ;������������ڶεĴ�С
dwPatchImportSegStart     dd ?  ;������������ڶε���ʼ��ַ
dwDstImportSegSize        dd ?  ;Ŀ�굼������ڶδ�С
dwDstImportSegStart       dd ?  ;Ŀ�굼������ڶ�������ʼ��ַ
dwDstImportSegRawSize     dd ?  ;Ŀ�굼������ڶ��������ļ��ж����Ĵ�С
dwDstImportInFileStart    dd ?  ;Ŀ�굼������ļ��е���ʼ��ַ
dwPatchImportInFileStart  dd ?  ;������������ļ��е���ʼλ��
dwPatchImportSize         dd ?  ;����������С
dwDstImportSize           dd ?  ;Ŀ�굼����С
dwNewImportSize           dd ?  ;���ɵ����ļ��ĵ�����С  �������������������С���жϿռ乻��������Ҫ�ֶ�
dwPatchDLLCount           dd ?  ;���������е���DLL�ĸ���
dwPatchFunCount           dd ?  ;���������е��ú����ĸ���
dwDstDLLCount             dd ?  ;Ŀ������е���DLL�ĸ���
dwDstFunCount             dd ?  ;Ŀ������е��ú����ĸ���
dwThunkSize               dd ?  ;IAT��originalFirstThunkָ������Ĵ�С�������ļ��е����ĵ�1���ִ�С
dwFunDllConstSize         dd ?  ;�������Ͷ�̬���ӿ��������Ĵ�С��
dwImportSpace2            dd ?  ;���ļ��е����ĵ�2���ִ�С
dwImportLeft              dd ?  ;��������ڶ�ʣ��ռ�

dwPatchCodeSegSize      dd ?  ;�����������ڶεĴ�С
dwPatchCodeSegStart     dd ?  ;�����������ڶε���ʼ��ַ
dwDstCodeSegSize        dd ?  ;Ŀ��������ڶδ�С
dwDstCodeSegStart       dd ?  ;Ŀ��������ڶ�������ʼ��ַ
dwDstCodeSegRawSize     dd ?  ;Ŀ��������ڶ��������ļ��ж����Ĵ�С
dwPatchCodeSize         dd ?  ;���������С
dwDstCodeSize           dd ?  ;Ŀ������С
dwPatchCodeSegMemStart  dd ?  ;�����������ڶ��������ڴ����ʼ��ַ
dwDstCodeSegMemStart    dd ?  ;Ŀ��������ڶ��������ڴ����ʼ��ַ
dwModiCommandCount      dd ?  ;����������Ҫ�����ĵ�ַ����
dwDataInMemStart        dd ?  ;���������ļ����ڴ��е���ʼ��ַ


lpDstMemory             dd ?  ;���ļ����ڴ����ʼ��ַ
lpPImportInNewFile      dd ?  ;��������������ļ��е�λ��
lpImportChange          dd 200 dup(0)   ;��ʽ���ĸ��ֽ�Ϊԭֵ���ĸ��ֽ�Ϊ����ֵ�����ŷ�
lpOriginalFirstThunk    dd ?  ;originalFirstThunk��ָ���λ��
lpNewImport             dd ?  ;�µ�������ļ��е���ʼλ��
lpNewData               dd ?  ;�������������ļ��е���ʼλ��
lpNewEntryPoint         dd ?  ;�������������ļ��е���ʼλ��



dwPatchImageBase             dd ?  ;��������װ�صĻ���ַ��
dwDstImageBase               dd ?  ;Ŀ�����װ�صĻ���ַ��
dwPatchEntryPoint            dd ?  ;����������ڵ�ַ
dwDstEntryPoint              dd ?  ;Ŀ�������ڵ�ַ

hFile1                  dd ?   
hFile2                  dd ?
hFile                   dd ?




.const
szDllEdit   db 'RichEd20.dll',0
szClassEdit db 'RichEdit20A',0
szFont      db '����',0


szFile1     db 'd:\masm32\source\chapter10\patch.exe',256 dup(0)
szFile2     db 'c:\explorer.exe',256 dup(0)
szDstFile   db 'c:\bind.exe',256 dup(0)  ;�����ļ�
               ;c:\Documents and Settings\Administrator\����\mspaint.exe
               ;d:\masm32\source\chapter10\HelloWorld.exe



szErr       db '�ļ���ʽ����!',0
szErrFormat db 'ִ���з����˴���!�������',0
szSuccess   db '��ϲ�㣬����ִ�е������ǳɹ��ġ�',0
szNotFound  db '�޷�����',0
szoutLine   db '----------------------------------------------------------------------------------------',0dh,0ah,0
szErr110      db '>> δ�ҵ��ɴ�����ݵĽڣ�',0dh,0ah,0
szErr11      db '>> Ŀ�����ݶοռ䲻�������������ɲ�����������ݣ�',0dh,0ah,0

szOut11      db '�������ݶε���Ч���ݴ�СΪ��%08x',0dh,0ah,0
szOut12      db '�������ݶ����ļ��е���ʼλ�ã�%08x',0dh,0ah,0
szOut2217    db '�������ݶ����ڴ��е���ʼ��ַ��%08x',0dh,0ah,0
szOut13      db 'Ŀ�����ݶε���Ч���ݴ�СΪ��%08x',0dh,0ah,0
szOut14      db 'Ŀ�����ݶ����ļ��е���ʼλ�ã�%08x',0dh,0ah,0
szOut15      db 'Ŀ�����ݶ����ļ��ж����Ĵ�С��%08x',0dh,0ah,0
szOut16      db 'Ŀ���ļ������ݶ����пռ䣬ʣ��ռ��СΪ��%08x,��Ҫ��С��%08x���������ݶ���Ŀ���ļ��д�ŵ���ʼλ�ã�%08x',0dh,0ah,0
szOut17      db 'Ŀ�����ݶ����ڴ��е���ʼ��ַ��%08x',0dh,0ah,0
szOut18      db 'Ŀ�����װ���ַ�ͳ���ִ����ڣ�%08x:%08x',0dh,0ah,0
szOut19      db '���������ļ����ڴ��е���ʼ��ַ��%08x',0dh,0ah,0
szOut1911    db '�ϲ��Ժ�ĵ��������',0dh,0ah,0
szOut1912    db '   DLL����%s      Name1ԭʼֵ��%08x      Name1����ֵ��%08x',0dh,0ah,0 
szOut1913    db '   ��������%s     �ļ���ʼλ��ԭʼֵ��%08x      �ļ���ʼλ������ֵ��%08x',0dh,0ah,0 
szOut1915    db '   Dll����%s     FirstThunkԭʼֵ��%08x   FirtThunk����ֵ��%08x',0dh,0ah,0 
szOut1916    db '   Dll����%s     OriginalFirstThunkԭʼֵ��%08x   OriginalFirtThunk����ֵ��%08x',0dh,0ah,0 
szOut1917    db '����Ŀ¼���жԵ�����ֵ��޸�',0dh,0ah,0
szOut1918    db '   �������ʼλ��   ԭʼֵ��%08x   ����ֵ��%08x   ',0dh,0ah,0
szOut1919    db '   ������С       ԭʼֵ��%08x   ����ֵ��%08x   ',0dh,0ah,0



szErr20      db '>> δ�ҵ��ɴ�����ݵĽڣ�',0dh,0ah,0
szErr21      db '>> Ŀ��οռ䲻�������������ɲ��������������ݣ�',0dh,0ah,0

szOut221      db '������������ڶε���Ч���ݴ�СΪ��%08x',0dh,0ah,0
szOut22      db '������������ڶ����ļ��е���ʼλ�ã�%08x',0dh,0ah,0
szOut23      db 'Ŀ�굼������ڶε���Ч���ݴ�СΪ��%08x',0dh,0ah,0
szOut24      db 'Ŀ�굼������ڶ����ļ��е���ʼλ�ã�%08x',0dh,0ah,0
szOut25      db 'Ŀ�굼������ڶ����ļ��ж����Ĵ�С��%08x',0dh,0ah,0
szOut26      db 'Ŀ���ļ��ĵ���������Ķ����пռ䡣ʣ��ռ��СΪ:%08x,��Ҫ��С��%08x���ϲ��Ժ�ĵ������Ŀ���ļ��д�ŵ���ʼλ��Ϊ��%08x',0dh,0ah,0
szOut27      db '��������������ӿ������%08x',0dh,0ah,0
szOut28      db '����������ú���������%08x',0dh,0ah,0
szOut29      db '����������ö�̬���ӿ⼰ÿ����̬���ӿ���ú���������ϸ��',0dh,0ah,0
szOut2210     db 'Ŀ�����������ӿ������%08x',0dh,0ah,0
szOut2211     db 'Ŀ�������ú���������%08x',0dh,0ah,0
szOut2212     db 'Ŀ�������ö�̬���ӿ⼰ÿ����̬���ӿ���ú���������ϸ��',0dh,0ah,0
szOut2213     db '�����ļ����뺯�����Ͷ�̬���ӿ����ַ��������Ĵ�С��%08x',0dh,0ah,0
szOut2214     db 'Ŀ���ļ���ԭ�е����ռ䣺%08x�����������е��뺯�������������Ĵ�С��%08x  ǰ�������ں��ߣ���bind�ɼ�������',0dh,0ah,0
szOut2215     db '�����ļ��к������Ͷ�̬���ӿ��ַ����Ĵ�С��%08x',0dh,0ah,0
szOut2216     db '�ϲ��Ժ��ļ�������С������ṹ����%08x',0dh,0ah,0
szOut2911     db 'Ŀ�굼������ļ��е���ʼ��ַ��%08x',0dh,0ah,0
szOut2912     db '������������ļ��е���ʼ��ַ��%08x',0dh,0ah,0
szOut2601     db 'Ŀ���ļ��ĵ���������Ķ����޿ռ䡣�����ݶ���ʣ��ռ䣬���СΪ:%08x,��Ҫ��С��%08x���ϲ��Ժ�ĵ������Ŀ���ļ��д�ŵ���ʼλ��Ϊ��%08x',0dh,0ah,0

szErr30      db '>> δ�ҵ��ɴ�����ݵĽڣ�',0dh,0ah,0
szErr31      db '>> Ŀ��οռ䲻�������������ɲ������뼰������ݣ�',0dh,0ah,0

szOut331      db '�����������ڶε���Ч���ݴ�СΪ��%08x',0dh,0ah,0
szOut332      db '�����������ڶ����ļ��е���ʼλ�ã�%08x',0dh,0ah,0
szOut33      db 'Ŀ��������ڶε���Ч���ݴ�СΪ��%08x',0dh,0ah,0
szOut34      db 'Ŀ��������ڶ����ļ��е���ʼλ�ã�%08x',0dh,0ah,0
szOut35      db 'Ŀ��������ڶ����ļ��ж����Ĵ�С��%08x',0dh,0ah,0
szOut36      db 'Ŀ���ļ��Ĵ��������Ķ����пռ䡣ʣ��ռ��СΪ:%08x,��Ҫ��С��%08x���ϲ��Ժ�Ĵ�����Ŀ���ļ��д�ŵ���ʼλ��Ϊ��%08x',0dh,0ah,0
szOut37      db '�����������ڴ��е���ʼλ�ã�%08x',0dh,0ah,0
szOut38      db 'Ŀ��������ڴ��е���ʼλ�ã�%08x',0dh,0ah,0
szOut39      db '��������װ�ػ���ַ��%08x',0dh,0ah,0
szOut3310     db '��������ָ���������ַ��Ҫ�����ĸ�����%08x',0dh,0ah,0
szOut3311     db '��������ָ���������ַ��Ҫ�����б�',0dh,0ah,0
szOut3312     db 'Ŀ�������ö�̬���ӿ⼰ÿ����̬���ӿ���ú���������ϸ��',0dh,0ah,0
szOut3313     db '�ļ�ƫ�ƣ�%08x   ָ�%xh     ��������%08x   ƫ�ƣ�%08x  ���������ֵ��%08x',0dh,0ah,0
szOut3314     db '�ļ�ƫ�ƣ�%08x   ָ�%xh     ��������%08x   ���������ֵ��%08x',0dh,0ah,0

szOut001      db '�����ļ���%s',0
szOut002      db 'Ŀ���ļ���%s',0


szOut123     db '%04x',0
szCrLf      db 0dh,0ah,0
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

    ;invoke wsprintf,addr szBuffer,addr szOut332,edx
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
; ȡ����������ļ���ƫ��
; _lpHeaderָ���ڴ���PE�ļ�����ʼ
; ����ֵ��eax��
;-------------------
getImportInFileStart proc _lpHeader
   local @dwSize
   pushad
   
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume esi:ptr IMAGE_NT_HEADERS
   mov eax,[esi].OptionalHeader.DataDirectory[8].VirtualAddress

   invoke _RVAToOffset,_lpHeader,eax
   mov @dwSize,eax
   popad
   mov eax,@dwSize
   ret
getImportInFileStart endp

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
  mov dword ptr dwFunctions[ebx*4],0  ;��dwFunctions���дһ����˫�ֱ�ʾ����
@@:
  assume edi:nothing
  popad
  mov eax,@dwDlls
  mov ebx,@dwFunctions
  ret
_getImportFunctions endp

;---------------------------------
; ��ȡPE�ļ��ĵ������õĺ�����
; �붯̬���ӿ���ַ���������С
;---------------------------------
_getFunDllSize proc _lpFile
  local @szBuffer[1024]:byte
  local @szSectionName[16]:byte
  local _lpPeHead
  local @dwDlls,@dwFuns,@dwFunctions
  local @dwSize
  
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

  mov @dwSize,0

  .while [edi].OriginalFirstThunk || [edi].TimeDateStamp ||\
         [edi].ForwarderChain || [edi].Name1 || [edi].FirstThunk
    mov @dwFuns,0
    invoke _RVAToOffset,_lpFile,[edi].Name1
    add eax,_lpFile
    push edi
    push ecx
    push ebx
    
    mov edi,eax
    mov cx,0
    .repeat
       mov bl,byte ptr[edi]
       inc cx

       .if bl!=0   ;��Ϊ0����ʾδ����
         inc @dwSize
       .else       ;��0����@dwSize���һ����Ϊÿ��DLL�������������
         add @dwSize,2
         .break
       .endif
       inc edi          
    .until FALSE
    pop ebx
    pop ecx
    pop edi

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
      .if dword ptr [ebx] & IMAGE_ORDINAL_FLAG32 ;����ŵ��룬���ַ�������
        mov eax,dword ptr [ebx]
        and eax,0ffffh
      .else                                      ;�����Ƶ���
        invoke _RVAToOffset,_lpFile,dword ptr [ebx]
        add eax,_lpFile
        assume eax:ptr IMAGE_IMPORT_BY_NAME
        push edi
        push ecx
        push ebx

        mov edi,eax
        add edi,2
        add @dwSize,2    ;�������
        mov cx,0
        .repeat
          mov bl,byte ptr[edi]
          inc cx
          .if bl!=0   ;��Ϊ0����ʾδ����
            inc @dwSize
          .else       ;��0���򿴿�����ֵ�Ƿ�Ϊż��������ǣ���@dwSize���һ����Ϊż����������Ϊ������
            test cx,1
            jz @1          
            add @dwSize,2  ;�ַ�����Ϊż��
            jmp @2
@1:         add @dwSize,1  ;�ַ�����Ϊ����
@2:         .break
          .endif
          inc edi          
        .until FALSE

        pop ebx
        pop ecx
        pop edi

        assume eax:nothing
      .endif
      add ebx,4
    .endw
    add edi,sizeof IMAGE_IMPORT_DESCRIPTOR
  .endw
@@:
  assume edi:nothing
  popad
  mov eax,@dwSize
  ret
_getFunDllSize endp


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
; ȡ�������ڽ����ļ��ж����Ժ�Ĵ�С
; _lpHeaderָ���ڴ���PE�ļ�����ʼ
; ����ֵ��eax��
;-------------------
getCodeSegRawSize proc _lpHeader
   local @dwSize
   pushad
   
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume esi:ptr IMAGE_NT_HEADERS
   mov eax,[esi].OptionalHeader.AddressOfEntryPoint

   invoke _getRVASectionRawSize,_lpHeader,eax
   mov @dwSize,eax   
   popad
   mov eax,@dwSize
   ret
getCodeSegRawSize endp

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
; ��ȡ����ַ
;-------------------------
getImageBase  proc  _lpFile
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
   mov eax,[edi].ImageBase
   mov @ret,eax
   popad
   mov eax,@ret
   ret
getImageBase endp

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

;------------------------------
;����E9hָ�����Ĳ�����
;��ڣ�ediָ����뿪ʼ  ecx���볤��
;���ڣ�eaxҪ�����Ĳ���������
;------------------------------
get_E9h  proc _lpFile,_lpFile1
   local @value,@value1,@off
   local @ret
   local @valueNew
   pushad
   mov @ret,0

   .repeat
     mov bl,byte ptr [edi]
     .if bl==0E9h
       ;ȡ����һ����   E9 43 02 04 00
       mov ebx,dword ptr [edi+1]
       mov @value,ebx

       .if ebx==0FFFFFFF0h
         mov ebx,edi
         add ebx,5             ;����E9ָ����5���ֽ�
         sub ebx,lpDstMemory
         ;���ڴ��еĵ�ַ
         invoke _OffsetToRVA,_lpFile1,ebx
         mov edx,eax
         mov eax,dwDstEntryPoint
         sub eax,edx
         mov @valueNew,eax
         mov edx,0e9h
         pushad
         invoke wsprintf,addr szBuffer,addr szOut3314,ebx,edx,@value,@valueNew
         invoke _appendInfo,addr szBuffer
         popad
         ;���������еĲ�������ַ
         mov eax,@valueNew
         mov dword ptr [edi+1],eax         

         inc @ret
       .endif
     .endif
     dec ecx
     .break .if ecx==0
     inc edi
   .until FALSE

   popad
   mov eax,@ret
   ret
get_E9h  endp
;------------------------------
;����A3hָ�����Ĳ�����
;��ڣ�ediָ����뿪ʼ  ecx���볤��
;���ڣ�eaxҪ�����Ĳ���������
;------------------------------
get_A3h  proc _lpFile
   local @value,@value1,@off
   local @ret
   local @valueNew
   pushad
   mov @ret,0
   mov eax,dwPatchImageBase     ;��������ַ:040000h
   add eax,dwPatchMemDataStart  ;�������ݶ���ʼ��ַ��003000h
   mov @value1,eax
   .repeat
     mov bl,byte ptr [edi]
     .if bl==0a3h
       ;ȡ����һ����   A3 43 02 04 00
       mov ebx,dword ptr [edi+1]
       mov @value,ebx
       mov eax,@value            ;����RVA�о������ݶ���ʼ��ƫ����@off���Ա������µ�RVA��ַ
       sub eax,@value1
       mov @off,eax

       and ebx,0ffff0000h
       ;�жϸ�˫���Ƿ���ImageBase��ʼ
       mov edx,dwPatchImageBase
       and edx,0FFFF0000h
       .if ebx==edx
         mov ebx,edi
         sub ebx,lpDstMemory
         mov edx,0a3h
         push ecx
         mov eax,dwDataInMemStart   ;�������ļ����������ڴ�ĵ�ַ@valueNew
         add eax,@off
         mov @valueNew,eax
         invoke wsprintf,addr szBuffer,addr szOut3313,ebx,edx,@value,@off,@valueNew
         invoke _appendInfo,addr szBuffer
         pop ecx
         
         ;���������еĲ�������ַ
         mov eax,@valueNew
         mov dword ptr [edi+1],eax         

         inc @ret
       .endif
     .endif
     dec ecx
     .break .if ecx==0
     inc edi
   .until FALSE

   popad
   mov eax,@ret
   ret
get_A3h  endp
;------------------------------
;����B8hָ�����Ĳ�����
;��ڣ�ediָ����뿪ʼ  ecx���볤��
;���ڣ�eaxҪ�����Ĳ���������
;------------------------------
get_B8h  proc _lpFile
   local @value,@value1,@off
   local @ret
   local @valueNew
   pushad
   mov @ret,0
   mov eax,dwPatchImageBase     ;��������ַ:040000h
   add eax,dwPatchMemDataStart  ;�������ݶ���ʼ��ַ��003000h
   mov @value1,eax
   .repeat
     mov bl,byte ptr [edi]
     .if bl==0B8h
       ;ȡ����һ����   B8 43 02 04 00
       mov ebx,dword ptr [edi+1]
       mov @value,ebx
       mov eax,@value            ;����RVA�о������ݶ���ʼ��ƫ����@off���Ա������µ�RVA��ַ
       sub eax,@value1
       mov @off,eax

       and ebx,0ffff0000h
       ;�жϸ�˫���Ƿ���ImageBase��ʼ
       mov edx,dwPatchImageBase
       and edx,0FFFF0000h
       .if ebx==edx
         mov ebx,edi
         sub ebx,lpDstMemory
         mov edx,0b8h
         push ecx
         mov eax,dwDataInMemStart   ;�������ļ����������ڴ�ĵ�ַ@valueNew
         add eax,@off
         mov @valueNew,eax
         invoke wsprintf,addr szBuffer,addr szOut3313,ebx,edx,@value,@off,@valueNew
         invoke _appendInfo,addr szBuffer
         pop ecx
         
         ;���������еĲ�������ַ
         mov eax,@valueNew
         mov dword ptr [edi+1],eax         

         inc @ret
       .endif
     .endif
     dec ecx
     .break .if ecx==0
     inc edi
   .until FALSE

   popad
   mov eax,@ret
   ret
get_B8h  endp
;------------------------------
;����68hָ�����Ĳ�����
;��ڣ�ediָ����뿪ʼ  ecx���볤��
;���ڣ�eaxҪ�����Ĳ���������
;------------------------------
get_68h  proc _lpFile
   local @value,@value1,@off
   local @ret
   local @valueNew
   pushad
   mov @ret,0
   mov eax,dwPatchImageBase     ;��������ַ:040000h
   add eax,dwPatchMemDataStart  ;�������ݶ���ʼ��ַ��003000h
   mov @value1,eax
   .repeat
     mov bl,byte ptr [edi]
     .if bl==68h
       ;ȡ����һ����   68 43 02 04 00
       mov ebx,dword ptr [edi+1]
       mov @value,ebx
       mov eax,@value            ;����RVA�о������ݶ���ʼ��ƫ����@off���Ա������µ�RVA��ַ
       sub eax,@value1
       mov @off,eax

       and ebx,0ffff0000h
       ;�жϸ�˫���Ƿ���ImageBase��ʼ
       mov edx,dwPatchImageBase
       and edx,0FFFF0000h
       .if ebx==edx
         mov ebx,edi
         sub ebx,lpDstMemory
         mov edx,68h
         push ecx
         mov eax,dwDataInMemStart   ;�������ļ����������ڴ�ĵ�ַ@valueNew
         add eax,@off
         mov @valueNew,eax
         invoke wsprintf,addr szBuffer,addr szOut3313,ebx,edx,@value,@off,@valueNew
         invoke _appendInfo,addr szBuffer
         pop ecx
         
         ;���������еĲ�������ַ
         mov eax,@valueNew
         mov dword ptr [edi+1],eax         

         inc @ret
       .endif
     .endif
     dec ecx
     .break .if ecx==0
     inc edi
   .until FALSE

   popad
   mov eax,@ret
   ret
get_68h  endp

;---------------------------------
; ����ԭ��������ֵ��ȡָ��FF 25�²�������ֵ
;---------------------------------
getNewValue  proc  _lpFile,_lpFile1,_dwValue
   local @value,@value1,@lpNewJmp,@newValue
   local @ret
   pushad

   ;��ȡvalue2
   mov eax,_dwValue
   sub eax,dwPatchImageBase
   mov ebx,_lpFile

   ;��ȡ��λ�����ڵ�ֵ
   invoke _RVAToOffset,_lpFile,eax
   mov esi,eax
   add esi,_lpFile
   mov eax,dword ptr [esi]
   
   mov esi,offset lpImportChange       
   .repeat 
     mov ebx,dword ptr [esi]
     .if ebx==eax
       add esi,4
       mov eax,dword ptr [esi]
       mov @newValue,eax
       .break           
     .else
       add esi,8
     .endif
   .until FALSE 
   ;����value2������¼�ҵ���λ��@lpNewJmp
   mov esi,dwDstImportInFileStart
   add esi,lpDstMemory
   mov eax,@newValue
   .repeat
     mov ebx,dword ptr [esi]
     .if ebx==eax   ;�ҵ���ֵ
       sub esi,lpDstMemory
       mov @lpNewJmp,esi
       .break       
     .else
       add esi,4
     .endif
   .until FALSE
   ;������λ�������ļ��е��ڴ��еĵ�ַ
   mov eax,@lpNewJmp
   invoke _OffsetToRVA,_lpFile1,eax
   mov @ret,eax
   popad
   mov eax,@ret
   ret
getNewValue  endp
;------------------------------
;����FF 25ָ�����Ĳ�����  �ò������뵼��������й�ϵ
;��ڣ�ediָ����뿪ʼ  ecx���볤��
;���ڣ�eaxҪ�����Ĳ���������
;  ���ȣ�ͨ������������FF 25ָ���Ĳ���������ԭ���������Ӧλ�õ�ֵvalue
;  ��Σ�ͨ����ѯ�ڴ�lpImportChange�е����ֵ��ȡ�µ�value2
;  ��󣬴�dwDstImportInFileStart��ʼ����value2����¼��λ��lpNewJump
;  ��ȡ����lpNewJumpֵͨ������_OffsetToRVAת����ΪFF 25�����������ֵ
;------------------------------
get_FF25h  proc _lpFile,_lpFile1
   local @value,@value1,@off
   local @ret
   local @valueNew

   
   pushad
   mov @ret,0
   mov eax,dwPatchImageBase     ;��������ַ:040000h
   add eax,dwPatchMemDataStart  ;�������ݶ���ʼ��ַ��003000h
   mov @value1,eax
   .repeat
     mov bx,word ptr [edi]
     .if bx==25FFh
       ;ȡ����һ����   FF 25 43 02 04 00
       mov ebx,dword ptr [edi+2]
       mov @value,ebx
       and ebx,0ffff0000h
       ;�жϸ�˫���Ƿ���ImageBase��ʼ
       mov edx,dwPatchImageBase
       and edx,0FFFF0000h
       .if ebx==edx
         mov ebx,edi
         sub ebx,lpDstMemory
         mov edx,25FFh
         push ecx
         invoke getNewValue,_lpFile,_lpFile1,@value   ;��ȡ�µ�ֵ
         add eax,dwDstImageBase
         mov @value1,eax
         invoke wsprintf,addr szBuffer,addr szOut3314,ebx,edx,@value,@value1
         invoke _appendInfo,addr szBuffer
         pop ecx
         
         ;���������еĲ�������ַ
         mov eax,@value1
         mov dword ptr [edi+2],eax         

         inc @ret
       .endif
     .endif

     dec ecx
     .break .if ecx==0
     inc edi
   .until FALSE
   popad
   mov eax,@ret
   ret
get_FF25h  endp
;------------------------------
;����FF 35ָ�����Ĳ�����
;��ڣ�ediָ����뿪ʼ  ecx���볤��
;���ڣ�eaxҪ�����Ĳ���������
;------------------------------
get_FF35h  proc _lpFile
   local @value,@value1,@off
   local @ret
   local @valueNew
   pushad
   mov @ret,0
   mov eax,dwPatchImageBase     ;��������ַ:040000h
   add eax,dwPatchMemDataStart  ;�������ݶ���ʼ��ַ��003000h
   mov @value1,eax
   .repeat
     mov bx,word ptr [edi]
     .if bx==35FFh
       ;ȡ����һ����   FF 35 43 02 04 00
       mov ebx,dword ptr [edi+2]
       mov @value,ebx
       mov eax,@value            ;����RVA�о������ݶ���ʼ��ƫ����@off���Ա������µ�RVA��ַ
       sub eax,@value1
       mov @off,eax
       and ebx,0ffff0000h
       ;�жϸ�˫���Ƿ���ImageBase��ʼ
       mov edx,dwPatchImageBase
       and edx,0FFFF0000h
       .if ebx==edx
         mov ebx,edi
         sub ebx,lpDstMemory
         mov edx,35FFh
         push ecx
         mov eax,dwDataInMemStart   ;�������ļ����������ڴ�ĵ�ַ@valueNew
         add eax,@off
         mov @valueNew,eax
         invoke wsprintf,addr szBuffer,addr szOut3313,ebx,edx,@value,@off,@valueNew
         invoke _appendInfo,addr szBuffer
         pop ecx
         
         ;���������еĲ�������ַ
         mov eax,@valueNew
         mov dword ptr [edi+2],eax         

         inc @ret
       .endif
     .endif

     dec ecx
     .break .if ecx==0
     inc edi
   .until FALSE
   popad
   mov eax,@ret
   ret
get_FF35h  endp


;------------------------------
;����FF 05ָ�����Ĳ�����
;��ڣ�ediָ����뿪ʼ  ecx���볤��
;���ڣ�eaxҪ�����Ĳ���������
;------------------------------
get_FF05h  proc _lpFile
   local @value,@value1,@off
   local @ret
   local @valueNew
   pushad
   mov @ret,0
   mov eax,dwPatchImageBase     ;��������ַ:040000h
   add eax,dwPatchMemDataStart  ;�������ݶ���ʼ��ַ��003000h
   mov @value1,eax
   .repeat
     mov bx,word ptr [edi]
     .if bx==05FFh
       ;ȡ����һ����   FF 05 43 02 04 00
       mov ebx,dword ptr [edi+2]
       mov @value,ebx
       mov eax,@value            ;����RVA�о������ݶ���ʼ��ƫ����@off���Ա������µ�RVA��ַ
       sub eax,@value1
       mov @off,eax
       and ebx,0ffff0000h
       ;�жϸ�˫���Ƿ���ImageBase��ʼ
       mov edx,dwPatchImageBase
       and edx,0FFFF0000h
       .if ebx==edx
         mov ebx,edi
         sub ebx,lpDstMemory
         mov edx,05FFh
         push ecx
         mov eax,dwDataInMemStart   ;�������ļ����������ڴ�ĵ�ַ@valueNew
         add eax,@off
         mov @valueNew,eax
         invoke wsprintf,addr szBuffer,addr szOut3313,ebx,edx,@value,@off,@valueNew
         invoke _appendInfo,addr szBuffer
         pop ecx
         
         ;���������еĲ�������ַ
         mov eax,@valueNew
         mov dword ptr [edi+2],eax         

         inc @ret
       .endif
     .endif

     dec ecx
     .break .if ecx==0
     inc edi
   .until FALSE
   popad
   mov eax,@ret
   ret
get_FF05h  endp

;------------------------------
;����03 05ָ�����Ĳ�����
;��ڣ�ediָ����뿪ʼ  ecx���볤��
;���ڣ�eaxҪ�����Ĳ���������
;------------------------------
get_0305h  proc _lpFile
   local @value,@value1,@off
   local @ret
   local @valueNew
   pushad
   mov @ret,0
   mov eax,dwPatchImageBase     ;��������ַ:040000h
   add eax,dwPatchMemDataStart  ;�������ݶ���ʼ��ַ��003000h
   mov @value1,eax
   .repeat
     mov bx,word ptr [edi]
     .if bx==0503h
       ;ȡ����һ����   03 05 43 02 04 00
       mov ebx,dword ptr [edi+2]
       mov @value,ebx
       mov eax,@value            ;����RVA�о������ݶ���ʼ��ƫ����@off���Ա������µ�RVA��ַ
       sub eax,@value1
       mov @off,eax
       and ebx,0ffff0000h
       ;�жϸ�˫���Ƿ���ImageBase��ʼ
       mov edx,dwPatchImageBase
       and edx,0FFFF0000h
       .if ebx==edx
         mov ebx,edi
         sub ebx,lpDstMemory
         mov edx,0503h
         push ecx
         mov eax,dwDataInMemStart   ;�������ļ����������ڴ�ĵ�ַ@valueNew
         add eax,@off
         mov @valueNew,eax
         invoke wsprintf,addr szBuffer,addr szOut3313,ebx,edx,@value,@off,@valueNew
         invoke _appendInfo,addr szBuffer
         pop ecx
         
         ;���������еĲ�������ַ
         mov eax,@valueNew
         mov dword ptr [edi+2],eax         

         inc @ret
       .endif
     .endif

     dec ecx
     .break .if ecx==0
     inc edi
   .until FALSE
   popad
   mov eax,@ret
   ret
get_0305h  endp

;------------------------
; ���ݶ�
;------------------------
_dealData   proc _lpFile1,_lpFile2
  local @bufTemp1[10]:byte
  local @dwTemp:dword,@dwTemp1:dword

  pushad
  ;����Ϊֹ�������ڴ��ļ���ָ���Ѿ���ȡ���ˡ�_lpFile1��_lpFile2�ֱ�ָ�������ļ�ͷ
  ;�����Ǵ�����ļ�ͷ��ʼ���ҳ������ݽṹ���ֶ�ֵ�����бȽϡ�


  ;��ȡ�����ļ����ݶεĴ�С
  invoke getDataSize,_lpFile1
  mov dwPatchDataSize,eax

  .if eax==0  ;δ�ҵ�������ݵĽ�
    invoke _appendInfo,addr szErr110
  .else
    invoke wsprintf,addr szBuffer,addr szOut11,eax
    invoke _appendInfo,addr szBuffer
  .endif



  ;��ȡ�����ļ����ݶ����ļ��е���ʼλ��
  invoke getDataStart,_lpFile1
  mov dwPatchDataStart,eax

  invoke wsprintf,addr szBuffer,addr szOut12,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡ�������ݶ����ڴ��е���ʼλ��
  invoke getDataStartInMem,_lpFile1
  mov dwPatchMemDataStart,eax

  invoke wsprintf,addr szBuffer,addr szOut2217,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡĿ���ļ����ݶεĴ�С
  invoke getDataSize,_lpFile2
  mov dwDstDataSize,eax

  invoke wsprintf,addr szBuffer,addr szOut13,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡĿ���ļ����ݶ����ڴ��е���ʼλ��
  invoke getDataStart,_lpFile2
  mov dwDstDataStart,eax

  invoke wsprintf,addr szBuffer,addr szOut14,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡĿ���ļ����ݶ����ļ��ж����Ĵ�С
  invoke getRawDataSize,_lpFile2
  mov dwDstRawDataSize,eax

  invoke wsprintf,addr szBuffer,addr szOut15,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡĿ�����ݶ����ڴ��е���ʼλ��
  invoke getDataStartInMem,_lpFile2
  mov dwDstMemDataStart,eax

  invoke wsprintf,addr szBuffer,addr szOut17,eax
  invoke _appendInfo,addr szBuffer


  ;�ӱ��ڵ����һ��λ������ǰ����������ȫ0�ַ�
  mov eax,dwDstDataStart
  add eax,dwDstRawDataSize  ;��λ�����ڵ����һ���ֽ�
  mov ecx,dwPatchDataSize
  mov esi,_lpFile2
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
    mov lpNewData,eax

    sub eax,dwPatchDataSize
    mov dwStartAddressinDstDS,eax

    mov @dwTemp,0

    mov esi,_lpFile2
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
    mov eax,@dwTemp
    mov dwDataLeft,eax

    invoke wsprintf,addr szBuffer,addr szOut16,@dwTemp,dwPatchDataSize,@dwTemp1
    invoke _appendInfo,addr szBuffer

 
    ;���������ݿ�����Ŀ���ļ�ָ��λ�ô�                 ��1��
    mov edi,lpDstMemory
    add edi,@dwTemp1

    mov esi,_lpFile1
    add esi,dwPatchDataStart
    mov ecx,dwPatchDataSize
    rep movsb

    ;��¼���ļ������ݶ���ʼλ�����ڴ��еĵ�ַ

    invoke getImageBase,_lpFile2
    mov dwDstImageBase,eax
    invoke _OffsetToRVA,_lpFile2,@dwTemp1
    add eax,dwDstImageBase
    mov dwDataInMemStart,eax
    invoke wsprintf,addr szBuffer,addr szOut19,eax
    invoke _appendInfo,addr szBuffer

  .else       ;���ݶοռ䲻��
    invoke _appendInfo,addr szErr11
  .endif

  invoke _appendInfo,addr szoutLine


  popad
  ret
_dealData   endp


;------------------------
; �������������FirstThunk����
; ָ��lpImportChange�������Ҫ������ֵ�������Ժ��ֵ���������
;------------------------
pasteImport_fun2 proc _lpFile,_lpFile1
  local @szBuffer[1024]:byte
  local @szSectionName[16]:byte
  local _lpPeHead
  local @dwDlls,@dwFuns,@dwFunctions
  local @dwSize,@newValue
  
  pushad
  mov esi,_lpFile
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew    ;����esiָ��ָ��PE�ļ�ͷ
  assume esi:ptr IMAGE_NT_HEADERS
  mov eax,[esi].OptionalHeader.DataDirectory[8].VirtualAddress
  .if !eax
    jmp @F
  .endif
  invoke _RVAToOffset,_lpFile,eax
  add eax,_lpFile
  mov esi,eax     ;��������������ļ�ƫ��λ��
  assume esi:ptr IMAGE_IMPORT_DESCRIPTOR
  invoke _getRVASectionName,_lpFile,[esi].OriginalFirstThunk

  mov @dwSize,0

  .while [esi].OriginalFirstThunk || [esi].TimeDateStamp ||\
         [esi].ForwarderChain || [esi].Name1 || [esi].FirstThunk

    invoke _RVAToOffset,_lpFile,[esi].FirstThunk
    mov edi,eax
    add edi,_lpFile  ;��λ��FirstThunkָ�������



    .while dword ptr [edi]
       mov eax,dword ptr [edi]
       inc @dwSize

       ;��ѯlpImportChange,�ҵ�����ֵ
       pushad
       mov esi,offset lpImportChange       
       .repeat 
         mov ebx,dword ptr [esi]
         .if ebx==eax
           add esi,4
           mov eax,dword ptr [esi]
           mov @newValue,eax
           .break           
         .else
           add esi,8
         .endif
       .until FALSE 
       ;���������FirstThunkֵд�����ļ�   ��7��
       mov edi,dwDstImportInFileStart
       add edi,lpDstMemory
       mov eax,@dwSize
       dec eax
       mov bl,4
       mul bl
       add edi,eax

       mov eax,@newValue
       mov dword ptr [edi],eax
       popad

       add edi,4
    .endw

    ;д����ṹ
    inc @dwSize
    mov edi,dwDstImportInFileStart
    add edi,lpDstMemory
    mov eax,@dwSize
    dec eax
    mov bl,4
    mul bl
    add edi,eax
    mov dword ptr [edi],0 
    add esi,sizeof IMAGE_IMPORT_DESCRIPTOR
  .endw
  add edi,4
  mov lpOriginalFirstThunk,edi

@@:
  assume esi:nothing
  popad
  mov eax,@dwSize
  ret
pasteImport_fun2 endp

;-----------------------
; ��ȡָ����ŵĶ�̬���ӿ�FirstThunk���ڴ��ַ
;-----------------------
getNewFirstThunk  proc  _lpFile,_lpFile1,_dwSize
  local @ret
  local @dwSize,@dwTemp


  pushad
  mov eax,_dwSize
  mov esi,dwDstImportInFileStart
  add esi,lpDstMemory
  dec _dwSize
  .repeat
    .break .if _dwSize==0
    mov eax,dword ptr [esi]    
    .if eax==0
      dec _dwSize
    .endif
    add esi,4
  .until FALSE

  sub esi,lpDstMemory
  invoke _OffsetToRVA,_lpFile1,esi
  mov @ret,eax   
  popad
  mov eax,@ret
  ret
getNewFirstThunk endp

;-----------------------
; ��ȡָ����ŵĶ�̬���ӿ�OriginalFirstThunk���ڴ��ַ
;-----------------------
getNewOriginalFirstThunk  proc  _lpFile,_lpFile1,_dwSize
  local @ret
  local @dwSize,@dwTemp


  pushad
  mov esi,lpOriginalFirstThunk
  dec _dwSize
  .repeat
    .break .if _dwSize==0
    mov eax,dword ptr [esi]    
    .if eax==0
      dec _dwSize
    .endif
    add esi,4
  .until FALSE

  sub esi,lpDstMemory
  invoke _OffsetToRVA,_lpFile1,esi
  mov @ret,eax   
  popad
  mov eax,@ret
  ret
getNewOriginalFirstThunk endp
;------------------------
; ���ص�_dwSize��DLL��̬���ӿ������
; ����λ�õĵ�ַ
;------------------------
getDllName proc _lpFile,_lpFile1,_dwSize
  local @szBuffer[1024]:byte
  local @szSectionName[16]:byte
  local _lpCurrent
  local @dwDlls,@dwFuns,@dwFunctions
  local @dwSize
  local @dwTemp,@dwTemp1

  pushad
  mov esi,_lpFile
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
  assume esi:ptr IMAGE_NT_HEADERS
  mov eax,[esi].OptionalHeader.DataDirectory[8].VirtualAddress
  .if !eax
    jmp @F
  .endif
  invoke _RVAToOffset,_lpFile,eax
  add eax,_lpFile
  mov esi,eax     ;��������������ļ�ƫ��λ��
  assume esi:ptr IMAGE_IMPORT_DESCRIPTOR
  invoke _getRVASectionName,_lpFile,[esi].OriginalFirstThunk

  mov @dwSize,0

  .while [esi].OriginalFirstThunk || [esi].TimeDateStamp ||\
         [esi].ForwarderChain || [esi].Name1 || [esi].FirstThunk
    inc @dwSize
    mov eax,_dwSize
    .if eax==@dwSize
       invoke _RVAToOffset,_lpFile,[esi].Name1
       add eax,_lpFile
       mov @dwSize,eax
       .break
    .endif
    add esi,sizeof IMAGE_IMPORT_DESCRIPTOR
  .endw

@@:
  assume esi:nothing
  popad
  mov eax,@dwSize
  ret
getDllName endp

;------------------------
; �������������OriginalFirstThunk����
; ָ��lpImportChange�������Ҫ������ֵ�������Ժ��ֵ���������
;------------------------
pasteImport_fun3 proc _lpFile,_lpFile1
  local @szBuffer[1024]:byte
  local @szSectionName[16]:byte
  local _lpPeHead
  local @dwDlls,@dwFuns,@dwFunctions
  local @dwSize,@newValue
  local @dwTemp,@dwTemp1
  
  pushad
  mov esi,_lpFile
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew    ;����esiָ��ָ��PE�ļ�ͷ
  assume esi:ptr IMAGE_NT_HEADERS
  mov eax,[esi].OptionalHeader.DataDirectory[8].VirtualAddress
  .if !eax
    jmp @F
  .endif
  invoke _RVAToOffset,_lpFile,eax
  add eax,_lpFile
  mov esi,eax     ;��������������ļ�ƫ��λ��
  assume esi:ptr IMAGE_IMPORT_DESCRIPTOR
  invoke _getRVASectionName,_lpFile,[esi].OriginalFirstThunk

  mov @dwSize,0

  .while [esi].OriginalFirstThunk || [esi].TimeDateStamp ||\
         [esi].ForwarderChain || [esi].Name1 || [esi].FirstThunk

    invoke _RVAToOffset,_lpFile,[esi].OriginalFirstThunk
    mov edi,eax
    add edi,_lpFile  ;��λ��OriginalFirstThunkָ�������



    .while dword ptr [edi]
       mov eax,dword ptr [edi]
       inc @dwSize

       ;��ѯlpImportChange,�ҵ�����ֵ
       pushad
       mov esi,offset lpImportChange       

       .repeat 
         mov ebx,dword ptr [esi]
         .if ebx==eax
           add esi,4
           mov eax,dword ptr [esi]
           mov @newValue,eax
           .break           
         .else
           add esi,8
         .endif
       .until FALSE 
       ;���������ֵ@newValueд�����ļ�        ��8��
       mov edi,lpOriginalFirstThunk
       mov eax,@dwSize
       dec eax
       mov bl,4
       mul bl
       add edi,eax

       mov eax,@newValue
       mov dword ptr [edi],eax
       popad

       add edi,4
    .endw

    ;д����ṹ
    inc @dwSize
    mov edi,lpOriginalFirstThunk
    mov eax,@dwSize
    dec eax
    mov bl,4
    mul bl
    add edi,eax
    mov dword ptr [edi],0    

    add esi,sizeof IMAGE_IMPORT_DESCRIPTOR
  .endw


  mov edi,lpPImportInNewFile  ;��������������ļ��е�λ��
  add edi,lpDstMemory
  assume edi:ptr IMAGE_IMPORT_DESCRIPTOR
  mov ecx,dwPatchDLLCount

  mov @dwSize,0
  .repeat
    inc @dwSize
    ;��ȡ�ļ�ƫ����
    mov ebx,dword ptr [edi].FirstThunk   ;@dwTemp�д����FirstThunk�ĳ�ʼֵ
    mov @dwTemp,ebx
    
    ;��FirstThunkָ��������в��ң�@dwSizeΪ�ڼ�����̬���ӿ⡣ʵ���Ͼ����ҵڼ���Ϊ���ƫ�Ƶ�ַ
    invoke getNewFirstThunk,_lpFile,_lpFile1,@dwSize
    mov @dwTemp1,eax                     ;@dwTemp1�д����FirstThunk������ֵ     (9)
    mov dword ptr [edi].FirstThunk,eax   ;����

    invoke getDllName,_lpFile,_lpFile1,@dwSize

    ;��ʾ�������ǰ��.Name1ֵ����ĺ��.Name1ֵ
    pushad
    invoke wsprintf,addr szBuffer,addr szOut1915,eax,@dwTemp,@dwTemp1
    invoke _appendInfo,addr szBuffer    
    popad

    mov ebx,dword ptr [edi].OriginalFirstThunk   ;@dwTemp�д����OriginalFirstThunk�ĳ�ʼֵ
    mov @dwTemp,ebx
    
    ;��FirstThunkָ��������в��ң�@dwSizeΪ�ڼ�����̬���ӿ⡣ʵ���Ͼ����ҵڼ���Ϊ���ƫ�Ƶ�ַ
    invoke getNewOriginalFirstThunk,_lpFile,_lpFile1,@dwSize
    mov @dwTemp1,eax                     ;@dwTemp1�д����OriginalFirstThunk������ֵ   (10)
    mov dword ptr [edi].OriginalFirstThunk,eax   ;����

    invoke getDllName,_lpFile,_lpFile1,@dwSize

    ;��ʾ�������ǰ��.Name1ֵ����ĺ��.Name1ֵ
    pushad
    invoke wsprintf,addr szBuffer,addr szOut1916,eax,@dwTemp,@dwTemp1
    invoke _appendInfo,addr szBuffer    
    popad



    add edi,sizeof IMAGE_IMPORT_DESCRIPTOR
    dec ecx
    .break .if ecx==0
  .until FALSE  
  
@@:
  assume esi:nothing
  popad
  mov eax,@dwSize
  ret
pasteImport_fun3 endp

;------------------------
; ����������������������뼰��������
; _offΪ���ļ��д�Ų����������������λ��
;------------------------
pasteImport_fun proc _lpFile,_lpFile1,_off
  local @szBuffer[1024]:byte
  local @szSectionName[16]:byte
  local _lpPeHead
  local @dwDlls,@dwFuns,@dwFunctions
  local @dwSize,@dwTemp,@dwTemp1
  local @lpFirstThunk,@lpImportChange
  
  pushad
  mov esi,_lpFile
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
  assume esi:ptr IMAGE_NT_HEADERS
  mov eax,[esi].OptionalHeader.DataDirectory[8].VirtualAddress
  .if !eax
    jmp @F
  .endif
  invoke _RVAToOffset,_lpFile,eax
  add eax,_lpFile
  mov esi,eax     ;��������������ļ�ƫ��λ��
  assume esi:ptr IMAGE_IMPORT_DESCRIPTOR
  invoke _getRVASectionName,_lpFile,[esi].OriginalFirstThunk

  mov edi,_off

  ;��ʼ��@lpFirstThunk��ʹ��ָ��ԭĿ���ļ��ĵ����λ�ã��˴�������ת�ƣ�
  mov eax,dwDstImportInFileStart
  add eax,lpDstMemory
  mov @lpFirstThunk,eax

  ;Ϊ���������ֵ�ṹ��ֵ
  mov eax,offset lpImportChange
  mov @lpImportChange,eax

  mov @dwSize,0

  
  .while [esi].OriginalFirstThunk || [esi].TimeDateStamp ||\
         [esi].ForwarderChain || [esi].Name1 || [esi].FirstThunk

    ;��ȡIMAGE_THUNK_DATA�б�EBX
    .if [esi].OriginalFirstThunk
      mov eax,[esi].OriginalFirstThunk
    .else
      mov eax,[esi].FirstThunk
    .endif
    invoke _RVAToOffset,_lpFile,eax
    add eax,_lpFile
    mov ebx,eax

    push edi
    mov edi,@lpFirstThunk

    .while dword ptr [ebx]
      .if dword ptr [ebx] & IMAGE_ORDINAL_FLAG32 ;����ŵ��룬���ַ�������
        mov eax,dword ptr [ebx]
        ; ����ֵԭ��д��ԭĿ���ļ����������λ��
        mov dword ptr [edi],eax
      .else                                      ;�����Ƶ���
        invoke _RVAToOffset,_lpFile,dword ptr [ebx]
        add eax,_lpFile
        assume eax:ptr IMAGE_IMPORT_BY_NAME
        push esi
        push ecx
        push ebx


        push edi
        mov edi,_off
        mov esi,eax

        ;��ʾÿ��������ƫ����������ֵ
        pushad 
        ;��������ƫ��
        mov eax,esi
        sub eax,_lpFile
        invoke _OffsetToRVA,_lpFile,eax
        mov @dwTemp,eax
        ;Ŀ�����ƫ��
        mov eax,edi
        sub eax,lpDstMemory
        invoke _OffsetToRVA,_lpFile1,eax
        mov @dwTemp1,eax
        
        add esi,2

        ;������ǰ��ֵ���������ֵ���е�lpImportChange��   ��6��
        mov edi,offset lpImportChange
        mov eax,@dwSize
        mov bl,4
        mul bl
        add edi,eax
        mov eax,@dwTemp
        mov dword ptr [edi],eax
        inc @dwSize

        mov edi,offset lpImportChange
        mov eax,@dwSize
        mov bl,4
        mul bl
        add edi,eax
        mov eax,@dwTemp1 
        mov dword ptr [edi],eax
        inc @dwSize

        invoke wsprintf,addr szBuffer,addr szOut1913,esi,@dwTemp,@dwTemp1
        invoke _appendInfo,addr szBuffer    

        popad

        mov bx,word ptr [esi]  ; �������
        mov word ptr [edi],bx
        add esi,2
        add edi,2
        add _off,2
        mov cx,0
        .repeat
          mov bl,byte ptr[esi]
          inc cx
          .if bl!=0   ;��Ϊ0����ʾδ����
            mov byte ptr [edi],bl
            inc edi
            inc _off
          .else       ;��0���򿴿�����ֵ�Ƿ�Ϊż��������ǣ���@dwSize���һ����Ϊż����������Ϊ������
            test cx,1
            jz @1   
            mov byte ptr [edi],0   ;�ַ�����Ϊż����д������
            inc _off
            inc edi
            mov byte ptr [edi],0
            inc _off
            inc edi
            jmp @2
@1:         mov byte ptr [edi],0   ;�ַ�����Ϊ������дһ����
            inc _off
            inc edi
@2:         .break
          .endif
          inc esi          
        .until FALSE
        pop edi

        pop ebx
        pop ecx
        pop esi

        assume eax:nothing
      .endif
      add edi,4
      add ebx,4
    .endw
    mov dword ptr [edi],0  ;д��0�ֽ�
    add edi,4
    mov @lpFirstThunk,edi  ;����ָ��
    pop edi

    add esi,sizeof IMAGE_IMPORT_DESCRIPTOR
  .endw
  ;���������FirstThunk���������ֵ
  invoke pasteImport_fun2,_lpFile,_lpFile1
  invoke pasteImport_fun3,_lpFile,_lpFile1

@@:
  assume esi:nothing
  popad
  mov eax,@dwSize
  ret
pasteImport_fun endp


;------------------------
; ������������������뼰��������
; _offΪ���ļ��д�Ų������������λ��
;------------------------
pasteImport proc _lpFile,_lpFile1,_off
  local @szBuffer[1024]:byte
  local @szSectionName[16]:byte
  local _lpCurrent
  local @dwDlls,@dwFuns,@dwFunctions
  local @dwSize
  local @dwTemp,@dwTemp1

  pushad
  mov esi,_lpFile
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
  assume esi:ptr IMAGE_NT_HEADERS
  mov eax,[esi].OptionalHeader.DataDirectory[8].VirtualAddress
  .if !eax
    jmp @F
  .endif
  invoke _RVAToOffset,_lpFile,eax
  add eax,_lpFile
  mov esi,eax     ;��������������ļ�ƫ��λ��
  assume esi:ptr IMAGE_IMPORT_DESCRIPTOR
  invoke _getRVASectionName,_lpFile,[esi].OriginalFirstThunk

  mov edi,_off

  mov @dwSize,0

  .while [esi].OriginalFirstThunk || [esi].TimeDateStamp ||\
         [esi].ForwarderChain || [esi].Name1 || [esi].FirstThunk
    mov @dwFuns,0
    invoke _RVAToOffset,_lpFile,[esi].Name1
    add eax,_lpFile
    push esi
    push ecx
    push ebx
    
    mov esi,eax
    mov cx,0
    .repeat
       mov bl,byte ptr[esi]
       mov byte ptr [edi],bl
       inc edi
 
       inc cx

       .if bl==0 ;��0
         .break
       .endif
       inc esi          
    .until FALSE
    pop ebx
    pop ecx
    pop esi
    mov byte ptr [edi],0   ;ÿ��DLL���ƺ�������0
    inc edi
    add esi,sizeof IMAGE_IMPORT_DESCRIPTOR
  .endw
  mov _lpCurrent,edi

  ;�����������ָ��̬���ӿⳣ���ַ�����RVAֵ      ��5��
  mov edi,lpPImportInNewFile
  add edi,lpDstMemory
  assume edi:ptr IMAGE_IMPORT_DESCRIPTOR
  mov ecx,dwPatchDLLCount

  ;esiָ�����ļ���DLL�����ַ�����ʼ
  mov esi,_off
  .repeat
    ;��ȡ�ļ�ƫ����
    mov ebx,dword ptr [edi].Name1
    mov @dwTemp,ebx

    mov eax,esi
    sub eax,lpDstMemory
    ;��ȡ��Ŀ���ļ��ڴ��е�ƫ����
    invoke _OffsetToRVA,_lpFile1,eax
    mov @dwTemp1,eax

    ;��ʾ�������ǰ��.Name1ֵ����ĺ��.Name1ֵ     
    pushad
    invoke _appendInfo,addr szCrLf
    invoke _appendInfo,addr szOut1911  
    invoke _appendInfo,addr szCrLf 
    invoke wsprintf,addr szBuffer,addr szOut1912,esi,@dwTemp,@dwTemp1
    invoke _appendInfo,addr szBuffer    
    popad

    ;����.Name1��ֵ
    mov dword ptr [edi].Name1,eax
    add edi,sizeof IMAGE_IMPORT_DESCRIPTOR

    ;���¼���esi��ֵ
    .repeat
      mov bl,byte ptr[esi]
      inc esi
      .if bl==0
        inc esi
        .break
      .endif
    .until FALSE
    dec ecx
    .break .if ecx==0
  .until FALSE  

  ;�����������������ò���


  invoke pasteImport_fun,_lpFile,_lpFile1,_lpCurrent 


  ;��������Ŀ¼���жԵ���������(RVA��ַ�ʹ�С)
  mov esi,lpDstMemory
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
  assume esi:ptr IMAGE_NT_HEADERS
  mov ebx,[esi].OptionalHeader.DataDirectory[8].VirtualAddress
  mov ecx,[esi].OptionalHeader.DataDirectory[8].isize
  mov eax,lpNewImport
  invoke _OffsetToRVA,_lpFile1,eax
  mov [esi].OptionalHeader.DataDirectory[8].VirtualAddress,eax
  mov edx,dwNewImportSize  ;������С
  mov [esi].OptionalHeader.DataDirectory[8].isize,edx

  ;���
  invoke _appendInfo,addr szCrLf  
  invoke _appendInfo,addr szOut1917  
  invoke _appendInfo,addr szCrLf 
  pushad
  invoke wsprintf,addr szBuffer,addr szOut1918,ebx,eax
  popad
  invoke _appendInfo,addr szBuffer    
  pushad
  invoke wsprintf,addr szBuffer,addr szOut1919,ecx,edx
  popad
  invoke _appendInfo,addr szBuffer    
  invoke _appendInfo,addr szCrLf  
  
@@:
  assume esi:nothing
  popad
  mov eax,@dwSize
  ret
pasteImport endp




;------------------------
; �����
;------------------------
_dealImport   proc _lpFile1,_lpFile2
  local @bufTemp1[10]:byte
  local @dwTemp:dword,@dwTemp1:dword

  pushad
  ;��ȡ������������ڽڵĴ�С
  invoke getImportSegSize,_lpFile1
  mov dwPatchImportSegSize,eax

  invoke wsprintf,addr szBuffer,addr szOut221,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡ������������ڽ����ļ��е���ʼλ��
  invoke getImportSegStart,_lpFile1
  mov dwPatchImportSegStart,eax

  invoke wsprintf,addr szBuffer,addr szOut22,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡ������������ļ��е���ʼλ��
  invoke getImportInFileStart,_lpFile1
  mov dwPatchImportInFileStart,eax

  invoke wsprintf,addr szBuffer,addr szOut2912,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡĿ�굼������ڽڵĴ�С
  invoke getImportSegSize,_lpFile2
  mov dwDstImportSegSize,eax

  invoke wsprintf,addr szBuffer,addr szOut23,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡĿ�굼������ڽ����ļ��е���ʼλ��
  invoke getImportSegStart,_lpFile2
  mov dwDstImportSegStart,eax

  invoke wsprintf,addr szBuffer,addr szOut24,eax
  invoke _appendInfo,addr szBuffer


  ;��ȡĿ�굼������ļ��е���ʼλ��
  invoke getImportInFileStart,_lpFile2
  mov dwDstImportInFileStart,eax

  invoke wsprintf,addr szBuffer,addr szOut2911,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡĿ�굼������ڽڵĴ�С
  invoke getImportSegRawSize,_lpFile2
  mov dwDstImportSegRawSize,eax

  invoke wsprintf,addr szBuffer,addr szOut25,eax
  invoke _appendInfo,addr szBuffer


  ;��ȡ���������dll�������functions����
  invoke _getImportFunctions,_lpFile1
  mov dwPatchDLLCount,eax
  mov dwPatchFunCount,ebx
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
  invoke _getImportFunctions,_lpFile2
  mov dwDstDLLCount,eax
  mov dwDstFunCount,ebx
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
  mov eax,dwDstDLLCount
  add eax,dwPatchDLLCount
  inc eax                  ;���ļ����ö�̬���ӿ����+1
  mov edx,0
  mov bx,14h
  mul bx                   ;eax�д�����µ�����С
  mov dwNewImportSize,eax

  ;�������Ͷ�̬���ӿ����ĳ�����С
  mov eax,0
  invoke _getFunDllSize,_lpFile1
  mov dwFunDllConstSize,eax

  add eax,dwNewImportSize   ;Ŀ���ļ���������ڽڱ�����ڵĿ��пռ��С
  mov dwImportSpace2,eax

  ;Ŀ�굼����С����0�ṹ
  mov eax,dwDstDLLCount
  inc eax
  mov edx,0
  mov bx,14h
  mul bx
  mov dwDstImportSize,eax

  ;����������С����0�ṹ
  mov eax,dwPatchDLLCount
  inc eax
  mov edx,0
  mov bx,14h
  mul bx
  mov dwPatchImportSize,eax
  

  ;���㲹������IAT���originalFirstThunkָ������Ĵ�С֮��
  mov eax,dwPatchFunCount
  add eax,dwPatchDLLCount
  mov edx,0
  mov bx,8
  mul bx
  mov dwThunkSize,eax

  
  invoke wsprintf,addr szBuffer,addr szOut2214,dwDstImportSize,dwThunkSize
  invoke _appendInfo,addr szBuffer



  invoke wsprintf,addr szBuffer,addr szOut2213,dwFunDllConstSize
  invoke _appendInfo,addr szBuffer

  invoke wsprintf,addr szBuffer,addr szOut2216,dwNewImportSize
  invoke _appendInfo,addr szBuffer
  

  ;��Ŀ�굼������ڽڵ����һ��λ������ǰ����������ȫ0�ַ�
  mov eax,dwDstImportSegStart
  add eax,dwDstImportSegRawSize  ;��λ�����ڵ����һ���ֽ�
  mov ecx,dwImportSpace2
  mov esi,_lpFile2
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
    mov esi,_lpFile2
    add esi,eax
    dec esi
    .repeat
      mov bl,byte ptr [esi]
      .break .if bl!=0
      inc @dwTemp
      dec esi
      dec eax
    .until FALSE
    mov eax,@dwTemp1
    mov lpNewImport,eax

    mov eax,@dwTemp  ;ʣ��ռ�
    mov dwImportLeft,eax
    
    invoke wsprintf,addr szBuffer,addr szOut26,@dwTemp,dwImportSpace2,@dwTemp1
    invoke _appendInfo,addr szBuffer

    ;��Ŀ���ļ��ĵ�����Ƶ�ָ��λ��         ��4��
    mov esi,_lpFile2
    add esi,dwDstImportInFileStart

    mov edi,lpDstMemory
    add edi,@dwTemp1
    mov ecx,dwDstImportSize
    rep movsb

    ;��ʱediָ���������һ��λ�ã���ǰ����14h����IMAGE_IMPORT_DESCRIPTOR�ṹ
    sub edi,14h

    push edi   ;���㲹������������ļ���ƫ��
    sub edi,lpDstMemory
    mov lpPImportInNewFile,edi
    pop edi

    ;������������Ƶ�����������λ��          ��5��
    mov esi,_lpFile1
    add esi,dwPatchImportInFileStart
    mov ecx,dwPatchImportSize
    rep movsb

    ;�����������������
    ;�Ӳ���������ö�̬���ӿⳣ�����ݣ���ӵ����ļ�
    invoke pasteImport,_lpFile1,_lpFile2,edi        


  .else       ;�����οռ䲻��
    ;�����������ڶοռ䲻�������Կ������ݶοռ��Ƿ����
    mov eax,dwDataLeft
    sub eax,dwPatchDataSize
    .if eax>dwImportSpace2   ;���ݶλ��пռ�
      mov @dwTemp,eax
      mov dwImportLeft,eax
      mov eax,lpNewData
      sub eax,dwImportSpace2
      mov @dwTemp1,eax
      mov lpNewImport,eax
      invoke wsprintf,addr szBuffer,addr szOut2601,@dwTemp,dwImportSpace2,@dwTemp1
      invoke _appendInfo,addr szBuffer      
            
      ;��Ŀ���ļ��ĵ�����Ƶ�ָ��λ��         ��4��
      mov esi,_lpFile2
      add esi,dwDstImportInFileStart

      mov edi,lpDstMemory
      add edi,@dwTemp1
      mov ecx,dwDstImportSize
      rep movsb

      ;��ʱediָ���������һ��λ�ã���ǰ����14h����IMAGE_IMPORT_DESCRIPTOR�ṹ
      sub edi,14h

      push edi   ;���㲹������������ļ���ƫ��
      sub edi,lpDstMemory
      mov lpPImportInNewFile,edi
      pop edi

      ;������������Ƶ�����������λ��          ��5��
      mov esi,_lpFile1
      add esi,dwPatchImportInFileStart
      mov ecx,dwPatchImportSize
      rep movsb

      ;�����������������
      ;�Ӳ���������ö�̬���ӿⳣ�����ݣ���ӵ����ļ�
      invoke pasteImport,_lpFile1,_lpFile2,edi        

    .else
      invoke _appendInfo,addr szErr21  ;���ݶοռ�Ҳ���������˳�
      jmp @ret
    .endif
  .endif

  invoke _appendInfo,addr szoutLine


@ret:
  popad
  ret
_dealImport   endp

;------------------------
; �����
;------------------------
_dealCode   proc _lpFile1,_lpFile2
  local @bufTemp1[10]:byte
  local @dwTemp:dword,@dwTemp1:dword
  pushad
  ;����ESI,EDIָ��DOSͷ
  mov esi,_lpFile1
  assume esi:ptr IMAGE_DOS_HEADER
  mov edi,_lpFile2
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

  invoke _appendInfo,addr szCrLf

  ;��ȡ�����ļ�����ڵ�ַ
  invoke getEntryPoint,_lpFile1
  mov dwPatchEntryPoint,eax
  invoke getEntryPoint,_lpFile2
  mov dwDstEntryPoint,eax


  ;��ȡ�����������ڽڵĴ�С
  invoke getCodeSegSize,_lpFile1
  mov dwPatchCodeSegSize,eax

  invoke wsprintf,addr szBuffer,addr szOut331,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡ�����������ڽ����ļ��е���ʼλ��
  invoke getCodeSegStart,_lpFile1
  mov dwPatchCodeSegStart,eax

  invoke wsprintf,addr szBuffer,addr szOut332,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡ�����������ڽ����ڴ��е���ʼλ��
  invoke _OffsetToRVA,_lpFile1,dwPatchCodeSegStart
  mov dwPatchCodeSegMemStart,eax

  invoke wsprintf,addr szBuffer,addr szOut37,eax
  invoke _appendInfo,addr szBuffer



  ;��ȡĿ��������ڽڵĴ�С
  invoke getCodeSegSize,_lpFile2
  mov dwDstCodeSegSize,eax

  invoke wsprintf,addr szBuffer,addr szOut33,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡĿ��������ڽ����ļ��е���ʼλ��
  invoke getCodeSegStart,_lpFile2
  mov dwDstCodeSegStart,eax

  invoke wsprintf,addr szBuffer,addr szOut34,eax
  invoke _appendInfo,addr szBuffer

  ;��ȡĿ��������ڽڵĴ�С
  invoke getCodeSegRawSize,_lpFile2
  mov dwDstCodeSegRawSize,eax

  invoke wsprintf,addr szBuffer,addr szOut35,eax
  invoke _appendInfo,addr szBuffer


  ;��ȡĿ��������ڽ����ڴ��е���ʼλ��
  invoke _OffsetToRVA,_lpFile1,dwDstCodeSegStart
  mov dwDstCodeSegMemStart,eax

  invoke wsprintf,addr szBuffer,addr szOut38,eax
  invoke _appendInfo,addr szBuffer

  ;��Ŀ��������ڽڵ����һ��λ������ǰ����������ȫ0�ַ�
  mov eax,dwDstImportSegStart
  mov ebx,dwDstCodeSegStart
  .if eax==ebx   ;����������ڶκ͵�������ڶ���ͬһ����
     mov eax,lpNewImport
  .else
     mov eax,dwDstCodeSegStart
     add eax,dwDstCodeSegRawSize  ;��λ�����ڵ����һ���ֽ�
  .endif

  mov ecx,dwPatchCodeSegSize   ;��������ĳ���
  mov esi,_lpFile2
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
    mov ebx,dwDstCodeSegStart
    .if eax==ebx   ;����������ڶκ͵�������ڶ���ͬһ����
       mov eax,dwImportLeft
       sub eax,dwImportSpace2
       mov @dwTemp,eax
    .else
       mov eax,dwDstCodeSegStart
       add eax,dwDstCodeSegRawSize  ;��λ�����ڵ����һ���ֽ�

       mov esi,_lpFile2
       add esi,eax
       dec esi
       .repeat
         mov bl,byte ptr [esi]
         .break .if bl!=0
         inc @dwTemp
         dec esi
         dec eax
       .until FALSE
    .endif  
  
    mov eax,@dwTemp1
    mov lpNewEntryPoint,eax
    invoke wsprintf,addr szBuffer,addr szOut36,@dwTemp,dwPatchCodeSegSize,@dwTemp1
    invoke _appendInfo,addr szBuffer

    ;������εĴ��븴�Ƶ�Ŀ���ļ��С�   ��2��

    mov edi,lpDstMemory
    add edi,@dwTemp1

    mov esi,_lpFile1
    add esi,dwPatchCodeSegStart
    mov ecx,dwPatchCodeSegSize
    rep movsb
  .else       ;����οռ䲻��
    invoke _appendInfo,addr szErr31
    jmp @ret
  .endif

  invoke _appendInfo,addr szoutLine

  ;��ȡ��������װ�ػ���ַ
  invoke getImageBase,_lpFile1
  mov dwPatchImageBase,eax
  invoke wsprintf,addr szBuffer,addr szOut39,eax
  invoke _appendInfo,addr szBuffer

  invoke _appendInfo,addr szCrLf

                                      ;������FF 25ָ��������ָ��Ĳ�����  ��3��

  mov edi,lpDstMemory   ;����68ָ��
  add edi,@dwTemp1
  mov ecx,dwPatchCodeSegSize
  invoke get_68h,_lpFile1    ;���������Ĳ�������ַ  
  mov dwModiCommandCount,eax

  mov edi,lpDstMemory   ;����A3ָ��
  add edi,@dwTemp1
  mov ecx,dwPatchCodeSegSize
  invoke get_A3h,_lpFile1    ;���������Ĳ�������ַ  
  add dwModiCommandCount,eax

  mov edi,lpDstMemory   ;����B8ָ��
  add edi,@dwTemp1
  mov ecx,dwPatchCodeSegSize
  invoke get_B8h,_lpFile1    ;���������Ĳ�������ַ  
  add dwModiCommandCount,eax

  mov edi,lpDstMemory   ;����FF 05ָ��
  add edi,@dwTemp1
  mov ecx,dwPatchCodeSegSize
  invoke get_FF05h,_lpFile1
  add dwModiCommandCount,eax

  mov edi,lpDstMemory   ;����03 05ָ��
  add edi,@dwTemp1
  mov ecx,dwPatchCodeSegSize
  invoke get_0305h,_lpFile1
  add dwModiCommandCount,eax

  mov edi,lpDstMemory   ;����FF 35ָ��
  add edi,@dwTemp1
  mov ecx,dwPatchCodeSegSize
  invoke get_FF35h,_lpFile1
  add dwModiCommandCount,eax

  mov edi,lpDstMemory   ;����FF 25ָ��  �������Ƚ�����
  add edi,@dwTemp1
  mov ecx,dwPatchCodeSegSize
  invoke get_FF25h,_lpFile1,_lpFile2
  add dwModiCommandCount,eax

  mov edi,lpDstMemory   ;����E9ָ��
  add edi,@dwTemp1
  mov ecx,dwPatchCodeSegSize
  invoke get_E9h,_lpFile1,_lpFile2    ;���������Ĳ�������ַ  
  add dwModiCommandCount,eax
  
  invoke wsprintf,addr szBuffer,addr szOut3310,dwModiCommandCount
  invoke _appendInfo,addr szBuffer  

  ;����PE�ļ���ڵ�ַ
   mov edi,lpDstMemory
   assume edi:ptr IMAGE_DOS_HEADER

   add edi,[edi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume edi:ptr IMAGE_NT_HEADERS
   add edi,4
   add edi,sizeof IMAGE_FILE_HEADER
   assume edi:ptr IMAGE_OPTIONAL_HEADER32
   mov ebx,lpNewEntryPoint

   invoke _OffsetToRVA,_lpFile2,ebx
   mov [edi].AddressOfEntryPoint,eax  

@ret:
  popad
  ret
_dealCode   endp

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

;--------------------
; ��PE�ļ�������
;--------------------
_OpenFile proc
  local @stOF:OPENFILENAME
  local @hFile,@dwFileSize,@hMapFile,@lpMemory
  local @hFile1,@dwFileSize1,@hMapFile1,@lpMemory1
  local @bufTemp1[10]:byte
  local @dwTemp:dword,@dwTemp1:dword
  local @dwBuffer,@lpDst,@hDstFile

  invoke wsprintf,addr szBuffer,addr szOut001,addr szFile1
  invoke _appendInfo,addr szBuffer  
  invoke _appendInfo,addr szCrLf  

  invoke wsprintf,addr szBuffer,addr szOut002,addr szFile2
  invoke _appendInfo,addr szBuffer  
  invoke _appendInfo,addr szCrLf  
  invoke _appendInfo,addr szCrLf  
  
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


  ;��ȡĿ���ļ���С

  ;ΪĿ���ļ������ڴ�
  invoke GlobalAlloc,GHND,@dwFileSize1
  mov @hDstFile,eax
  invoke GlobalLock,@hDstFile
  mov lpDstMemory,eax   ;��ָ���@lpDst
  ;��Ŀ���ļ��������ڴ�����
  invoke MemCopy,@lpMemory1,lpDstMemory,@dwFileSize1

  invoke _dealData,@lpMemory,@lpMemory1
  invoke _dealImport,@lpMemory,@lpMemory1
 
  invoke _dealCode,@lpMemory,@lpMemory1

  invoke writeToFile,lpDstMemory,@dwFileSize1

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



