;------------------------
; PE�ļ�ͷ�еĶ�λ
; ����
; 2006.2.28
;------------------------
    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc
include    user32.inc
includelib user32.lib

include    kernel32.inc
includelib kernel32.lib

include    imagehlp.inc
includelib imagehlp.lib

;���ݶ�
    .data
szText     db  'HelloWorld',0
szOut      db  '��ַΪ:%08x',0
szBuffer   db  256 dup(0)

szExeFile  db  'c:\windows\system32\kernel32.dll',0
szOut1     db  'kernel32.dll��У���Ϊ��%08x',0
dwCheckSum dd ?


;�����
    .code
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

;-------------------
; ͨ������API��������У���
; kernel32.dll��У���Ϊ��0011e97e
;-------------------
_checkSum1 proc _lpExeFile 
   local @cSum,@hSum
   local @ret

   pushad
   invoke MapFileAndCheckSum,_lpExeFile,\
                 addr @hSum,addr @cSum
   mov eax,@cSum
   mov @ret,eax 

   popad  
   mov eax,@ret
   ret
_checkSum1 endp

;-------------------
; �Լ���д�������У���
;-------------------
_checkSum2 proc _lpExeFile
   local hFile,dwSize,hBase
   local @size
   local @ret

   pushad
   ;���ļ�
   invoke CreateFile,_lpExeFile,GENERIC_READ,\
                  FILE_SHARE_READ,NULL,OPEN_EXISTING,\
                  FILE_ATTRIBUTE_NORMAL,0
   mov hFile,eax
   invoke GetFileSize,hFile,NULL
   mov dwSize,eax
   ;Ϊ�ļ������ڴ棬������
   invoke VirtualAlloc,NULL,dwSize,\
                  MEM_COMMIT,PAGE_READWRITE
   mov hBase,eax
   invoke ReadFile,hFile,hBase,dwSize,addr @size,NULL
   ;�ر��ļ�
   invoke CloseHandle,hFile

   ;��һ������CheckSum����   
   mov ebx,hBase
   assume ebx:ptr IMAGE_DOS_HEADER
   mov ebx,[ebx].e_lfanew
   add ebx,hBase
   assume ebx:ptr IMAGE_NT_HEADERS
   mov [ebx].OptionalHeader.CheckSum,0
   assume ebx:ptr nothing

   
   mov ecx,dwSize
   mov esi,hBase
   
   ;�ڶ��������ֽ�λ�ӣ��������
   push ecx
   inc ecx
   shr ecx,1
   xor ebx,ebx
   clc
loc1:
   lodsw
   adc bx,ax
   loop loc1
   
   invoke VirtualFree,hBase,dwSize,MEM_DECOMMIT
 
   ;�����������ļ�����   
   pop eax
   add eax,ebx   
   mov @ret,eax
@exit:
   popad  
   mov eax,@ret
   ret
_checkSum2 endp


start:
    ;PEHeader.exe�������������VA
    invoke _rDDEntry,00400000h,01h,0,0 
    invoke wsprintf,addr szBuffer,addr szOut,eax
    invoke MessageBox,NULL,offset szBuffer,NULL,MB_OK

    ;PEHeader.exe������������ļ���ַFOA
    invoke _rDDEntry,00400000h,01h,0,3 
    invoke wsprintf,addr szBuffer,addr szOut,eax
    invoke MessageBox,NULL,offset szBuffer,NULL,MB_OK

    ;PEHeader.exe��2���ڱ������ڴ��VA��ַ
    invoke _rSection,00400000h,01h,0,0 
    invoke wsprintf,addr szBuffer,addr szOut,eax
    invoke MessageBox,NULL,offset szBuffer,NULL,MB_OK

    ;PEHeader.exe��2���ڱ������ļ���ƫ��
    invoke _rSection,00400000h,01h,0,3 
    invoke wsprintf,addr szBuffer,addr szOut,eax
    invoke MessageBox,NULL,offset szBuffer,NULL,MB_OK

    ;����У���
    invoke _checkSum1,addr szExeFile
    mov dwCheckSum,eax
    invoke _checkSum2,addr szExeFile
    .if eax==dwCheckSum
      invoke wsprintf,addr szBuffer,addr szOut1,eax
      invoke MessageBox,NULL,offset szBuffer,NULL,MB_OK
    .endif


    invoke ExitProcess,NULL
    end start
