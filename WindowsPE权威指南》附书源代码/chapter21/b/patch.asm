;------------------------
; EXE�����õĲ�������
; ����
; 2010.6.27
;------------------------
    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc


_QLGetProcAddress typedef proto :dword,:dword      ;��������
_ApiGetProcAddress  typedef ptr _QLGetProcAddress  ;������������

_QLLoadLib        typedef proto :dword
_ApiLoadLib       typedef ptr _QLLoadLib

_QLMessageBoxA    typedef proto :dword,:dword,:dword,:dword
_ApiMessageBoxA   typedef ptr _QLMessageBoxA

_QLGetProcessID   typedef proto :dword
_ApiGetProcessID  typedef ptr _QLGetProcessID

_QLOpenProcess   typedef proto :dword,:dword,:dword
_ApiOpenProcess  typedef ptr _QLOpenProcess

_QLWriteProcessMemory   typedef proto :dword,:dword,:dword,:dword,:dword
_ApiWriteProcessMemory  typedef ptr _QLWriteProcessMemory

_QLVirtualProtectEx   typedef proto :dword,:dword,:dword,:dword,:dword
_ApiVirtualProtectEx  typedef ptr _QLVirtualProtectEx


;�����
    .code

jmp start

;����Ŀ�����������Ϣ��
dstDataDirectory dd 32 dup(0)   ; ԭʼĿ����������Ŀ¼��+0005h
EncryptionTable db 256 dup(0),0 ; ���ܻ��� +0085h
dwLastSectionSize    dd  ?      ; ���һ�ڶ����ĳߴ磨���ֽڼƣ�
dwModuleBase   dd  ?
dwIATValue     dd  ?
dbEncrptValue  db  ?
dwSections     dd  ?

szText         db  'HelloWorldPE',0
szGetProcAddr  db  'GetProcAddress',0
szLoadLib      db  'LoadLibraryA',0
szMessageBox   db  'MessageBoxA',0
szGetProcessID db  'GetProcessId',0
szOpenProcess  db  'OpenProcess',0
szVirtualProtectEx    db  'VirtualProtectEx',0
szWriteProcessMemory  db  'WriteProcessMemory',0

user32_DLL     db  'user32.dll',0,0

dwImageBase    dd  ?  ;Ŀ����̻���ַ
hProcessID     dd  ?
hProcess       dd  ?
hOldPageValue  dd  ?

;-------------------------------
; �����㷨�������㷨���ֽ�������
; ��ڲ�����
;   _src:Ҫ���ܵ��ֽ�����ʼ��ַ
;   _size:Ҫ���ܵ��ֽ��������
;-------------------------------
_UnEncrptIt  proc _src,_size,_writeProcessMemory
  local @ret
  local @dwTemp

  pushad
  ;��ʼ���ջ�����ֽڽ��м���
  mov esi,_src
  .while TRUE
    mov al,byte ptr [esi]
    mov edi,offset EncryptionTable
    add edi,ebx
    mov @dwTemp,0
    .while TRUE  ;���һ���������@dwTemp��
      mov cl,byte ptr [edi]
      .break .if al==cl ;����ҵ������˳�
      inc @dwTemp
      inc edi
    .endw
    
    ;�ý��ܺ���ֽڸ����ֽ���
    mov ecx,@dwTemp
    mov byte ptr dbEncrptValue[ebx],cl

    ;ʹ��Զ��д��
    push NULL
    push 1
    mov edx,offset dbEncrptValue
    add edx,ebx
    push edx
    push esi   ;??
    push hProcess[ebx]
    call _writeProcessMemory 

    inc esi
    dec _size
    .break .if _size==0
  .endw
  popad
  ret
_UnEncrptIt endp

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
        add esi,[esi+003ch]
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


;------------------------------------
; ����kernel32.dll�е�һ����ַ��ȡ���Ļ���ַ
;------------------------------------
_getImageBase  proc _dwKernelRetAddress
   local @dwRet
   local @dwTemp
   pushad

   mov @dwRet,0
   
   mov edi,_dwKernelRetAddress
   and edi,0ffff0000h  ;����ָ������ҳ�ı߽磬��1000h����
   mov eax,edi
   and eax,0ff000000h
   mov @dwTemp,eax
   .repeat
     .if word ptr [edi]==IMAGE_DOS_SIGNATURE  ;�ҵ�kernel32.dll��dosͷ
        mov esi,edi
        add esi,[esi+003ch]
        .if word ptr [esi]==IMAGE_NT_SIGNATURE ;�ҵ�kernel32.dll��PEͷ��ʶ
          mov @dwRet,edi
          .break
        .endif
     .endif
     sub edi,010000h
     .break .if edi<@dwTemp
   .until FALSE
   popad
   mov eax,@dwRet
   ret
_getImageBase  endp   

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
    add eax,[edx].SizeOfRawData        ;����ýڽ���RVA������Misc����Ҫԭ������Щ�ε�Miscֵ�Ǵ���ģ�
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


;------------------
; ����IAT��
; ����ȫ�ֱ�������
;   dwModuleBase  ģ��ĵ�ַ
;   dwImageBase   ���̻���ַ
;------------------
_updateIAT  proc _lpIID,_writeProcessMemory
   local @dwCount

   pushad
   mov @dwCount,0

   mov edi,_lpIID
   assume edi:ptr IMAGE_IMPORT_DESCRIPTOR

   ;��ȡ���������ַ���
   mov esi,[edi].OriginalFirstThunk
   add esi,dwImageBase[ebx]
   .while TRUE
     mov eax,[esi]
     .break .if !eax
     add eax,dwImageBase[ebx]
     add eax,2  ;����hint/name�е�hint

     ;��ʱeaxָ���˺����ַ���
     lea edx,_getApi   ;��ȡ������ַ
     add edx,ebx
     push eax
     push dwModuleBase[ebx]
     call edx
     ;add eax,dwImageBase[ebx]  ;��ȡ����VAֵ

     ;��������ַ����IAT��Ӧλ��
     push esi
     push eax
     mov esi,[edi].FirstThunk
     add esi,dwImageBase[ebx]  ;ESIָ��IAT��ʼ

     mov eax,@dwCount  ;��������Ӧƫ��
     sal eax,2
     add esi,eax
     pop eax


     mov dwIATValue[ebx],eax

     ;ʹ��Զ��д��
     push NULL
     push 4
     mov edx,offset dwIATValue
     add edx,ebx
     push edx
     push esi   ;??
     push hProcess[ebx]
     call _writeProcessMemory 

     ;mov dword ptr [esi],eax   ;������VAֵд��IAT
     pop esi

     inc @dwCount
     add esi,4
   .endw

   popad
   ret
_updateIAT endp



_goThere  proc
   local @first
   local _getProcAddress:_ApiGetProcAddress   ;���庯��
   local _loadLibrary:_ApiLoadLib
   local _messageBox:_ApiMessageBoxA
   local _getProcessID:_ApiGetProcessID
   local _openProcess:_ApiOpenProcess
   local _writeProcessMemory:_ApiWriteProcessMemory
   local _virtualProtectEx:_ApiVirtualProtectEx

   local hKernel32Base:dword
   local hUser32Base:dword
   local lpGetProcAddr:dword
   local lpLoadLib:dword

   local lpGetProcessID:dword
   local lpOpenProcess:dword
   local lpWriteProcessMemory:dword
   local lpVirtualProtectEx:dword


   pushad

    ;��ȡkernel32.dll�Ļ���ַ
    invoke _getKernelBase,eax

    mov hKernel32Base,eax

    ;�ӻ���ַ��������GetProcAddress��������ַ
    mov eax,offset szGetProcAddr
    add eax,ebx

    mov edi,hKernel32Base
    mov ecx,edi

    invoke _getApi,ecx,eax
    mov lpGetProcAddr,eax
    ;Ϊ�������ø�ֵ GetProcAddress
    mov _getProcAddress,eax   

    ;ʹ��GetProcAddress��������ַ��
    ;����������������GetProcAddress������
    ;���LoadLibraryA����ַ
    mov eax,offset szLoadLib
    add eax,ebx
    invoke _getProcAddress,hKernel32Base,eax
    mov _loadLibrary,eax

    ;ʹ��LoadLibrary��ȡuser32.dll�Ļ���ַ
    mov eax,offset user32_DLL
    add eax,ebx
    invoke _loadLibrary,eax

    mov hUser32Base,eax

    ;ʹ��GetProcAddress��������ַ��
    ;��ú���MessageBoxA����ַ
    mov eax,offset szMessageBox
    add eax,ebx
    invoke _getProcAddress,hUser32Base,eax
    mov _messageBox,eax


    mov eax,offset szGetProcessID
    add eax,ebx
    invoke _getProcAddress,hKernel32Base,eax
    mov _getProcessID,eax

    mov eax,offset szOpenProcess
    add eax,ebx
    invoke _getProcAddress,hKernel32Base,eax
    mov _openProcess,eax

    mov eax,offset szVirtualProtectEx
    add eax,ebx
    invoke _getProcAddress,hKernel32Base,eax
    mov _virtualProtectEx,eax

    mov eax,offset szWriteProcessMemory
    add eax,ebx
    invoke _getProcAddress,hKernel32Base,eax
    mov _writeProcessMemory,eax


    ;���ú���MessageBoxA
    mov eax,offset szText
    add eax,ebx
    invoke _messageBox,NULL,eax,NULL,MB_OK

    ;��ȡĿ����̵Ļ���ַ
    mov eax,offset dwImageBase
    add eax,ebx

    push eax
    lea edx,_getImageBase
    add edx,ebx
    call edx
    mov dwImageBase[ebx],eax


    ;��ԭĿ����̵�����Ŀ¼��
    mov esi,dwImageBase[ebx]
    add esi,[esi+3ch]
    add esi,78h
    push esi

    assume fs:nothing
    mov eax,fs:[20h]
    mov hProcessID[ebx],eax


    push hProcessID[ebx]
    push FALSE
    push PROCESS_ALL_ACCESS
    call _openProcess
    mov hProcess[ebx],eax  ;�ҵ��Ľ��̾����hProcess��

    

    ;�����ļ�ͷ����Ϊ�ɶ���д��ִ��
    lea edx,hOldPageValue
    add edx,ebx
    push edx
    push PAGE_EXECUTE_READWRITE
    ;��ȡSizeOfImage��С
    push esi
    mov esi,dwImageBase[ebx]
    add esi,[esi+3ch]
    assume esi:ptr IMAGE_NT_HEADERS
    mov edx,[esi].OptionalHeader.SizeOfImage
    pop esi
    push edx   ;����ҳ���С
    push dwImageBase[ebx]
    push hProcess[ebx]
    call _virtualProtectEx  

    pop esi
    push NULL
    push 16*8
    mov edx,offset dstDataDirectory
    add edx,ebx
    push edx
    push esi
    push hProcess[ebx]
    call _writeProcessMemory 

    ;��������
    mov edi,dwImageBase[ebx]
    assume edi:ptr IMAGE_DOS_HEADER
    add edi,[edi].e_lfanew
    assume edi:ptr IMAGE_NT_HEADERS
    ;��ȡ�ڵĸ���
    movzx eax,[edi].FileHeader.NumberOfSections
    mov dwSections[ebx],eax
    add edi,sizeof IMAGE_NT_HEADERS

    dec eax
    mov ecx,sizeof IMAGE_SECTION_HEADER   ;��λ�����һ����
    mul ecx
    add edi,eax   
    assume edi:ptr IMAGE_SECTION_HEADER

    mov @first,1

    .while TRUE
       mov esi,[edi].VirtualAddress
       add esi,dwImageBase[ebx]     ;Ҫ���ܵ���ʼ��ַ

       .if @first  ;��������һ�ڣ��������߸����˴˴��Ĵ�С��
                   ;����ʹ���ɲ������ߴ����ԭʼֵ
         mov ecx,dwLastSectionSize[ebx]
         mov @first,0
       .else       ;����������ڣ���ʹ��SizeOfRawData
         mov ecx,[edi].SizeOfRawData
       .endif

       push _writeProcessMemory
       push ecx
       push esi
       mov edx,offset _UnEncrptIt
       add edx,ebx
       call edx

       dec dwSections[ebx]
       sub edi,sizeof IMAGE_SECTION_HEADER
       .break .if dwSections[ebx]==0
    .endw


    ;����Ŀ����̵����
    mov edi,offset dstDataDirectory
    add edi,ebx
    add edi,8  ;��λ���������
    mov eax,dword ptr [edi] ;��ȡVirtualAddress

    ;δ���жϣ����账���PE�ļ����е����
    add eax,dwImageBase[ebx] ;�����ڴ�ƫ��

    mov edi,eax     ;��������������ļ�ƫ��λ��
    assume edi:ptr IMAGE_IMPORT_DESCRIPTOR
    .while [edi].Name1
       push edi
       mov eax,dword ptr [edi].Name1 ;ȡ��һ����̬���ӿ������ַ������ڵ�RVAֵ
       add eax,dwImageBase[ebx]      ;���ڴ涨λֻ����ϻ���ַ����

       ;��̬���ظ�dll
       invoke _loadLibrary,eax
       mov dwModuleBase[ebx],eax    

       ;�����Ӹ����ӿ�����ĺ���IAT��
       lea edx,offset _updateIAT
       add edx,ebx
       push _writeProcessMemory
       push edi
       call edx
       pop edi
       add edi,sizeof IMAGE_IMPORT_DESCRIPTOR
    .endw
    popad
    ret
_goThere endp

start:
    ;ȡ��ǰ�����Ķ�ջջ��ֵ
    mov eax,dword ptr [esp]
    push eax
    call @F   ; ��ȥ�ض�λ
@@:
    pop ebx
    sub ebx,offset @B
    pop eax
    invoke _goThere
    jmpToStart   db 0E9h,0F0h,0FFh,0FFh,0FFh

    ret

    end start
