;------------------------
; �޵���������ݶΡ����ض�λ��Ϣ����ȫ�ֱ�����HelloWorld
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


;�����
    .code

jmp start

;����Ŀ�����������Ϣ��
dstDataDirectory dd 32 dup(0)  ; ԭʼĿ����������Ŀ¼��
dwModuleBase   dd  ?

szText         db  'HelloWorldPE',0
szGetProcAddr  db  'GetProcAddress',0
szLoadLib      db  'LoadLibraryA',0
szMessageBox   db  'MessageBoxA',0

user32_DLL     db  'user32.dll',0,0

dwImageBase    dd  ?  ;Ŀ����̻���ַ



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

_goThere  proc
   local _getProcAddress:_ApiGetProcAddress   ;���庯��
   local _loadLibrary:_ApiLoadLib
   local _messageBox:_ApiMessageBoxA


   local hKernel32Base:dword
   local hUser32Base:dword
   local lpGetProcAddr:dword
   local lpLoadLib:dword

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

    ;����Ŀ����̵����
    mov edi,offset dstDataDirectory
    add edi,ebx
    add edi,8  ;��λ���������

    mov eax,dword ptr [edi] ;��ȡVirtualAddress
    ;δ���жϣ����账���PE�ļ����е����
    add eax,dwImageBase[ebx] ;�����ڴ�ƫ��

    mov edi,eax     ;��������������ļ�ƫ��λ��
    assume edi:ptr IMAGE_IMPORT_DESCRIPTOR
    
    mov eax,dword ptr [edi].Name1 ;ȡ��һ����̬���ӿ������ַ������ڵ�RVAֵ
    add eax,dwImageBase[ebx]  ;���ڴ涨λֻ����ϻ���ַ����
    ;invoke _messageBox,NULL,eax,NULL,MB_OK

    ;��̬���ظ�dll
    invoke _loadLibrary,eax
    mov dwModuleBase[ebx],eax    


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
