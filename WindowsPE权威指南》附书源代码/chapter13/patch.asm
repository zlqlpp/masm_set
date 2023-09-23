;-------------------------
; ��������
; ���δ���ʹ����API������ַ��̬��ȡ�Լ��ض�λ����
; �����ܣ������Ի���
; ���ߣ�����
; �������ڣ�2011.2.22
;-------------------------

    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc

;ע��˴�����̬���������κ�������̬���ӿ�

_ProtoGetProcAddress  typedef proto :dword,:dword
_ProtoLoadLibrary     typedef proto :dword

_ApiGetProcAddress    typedef ptr _ProtoGetProcAddress
_ApiLoadLibrary       typedef ptr _ProtoLoadLibrary


;-------------------------------------------
; ���������������������̬���ӿ�ĺ���������
;-------------------------------------------


_ProtoMessageBox       typedef proto :dword,:dword,:dword,:dword
_ApiMessageBox         typedef ptr _ProtoMessageBox


;����ӵ�Ŀ���ļ��Ĵ�������￪ʼ����APPEND_CODE_END������

    .code

jmp _NewEntry

; ��������Ϊ������Ҫ������
; �������в���������ʹ�õ�
szGetProcAddr  db  'GetProcAddress',0
szLoadLib      db  'LoadLibraryA',0

;------------------------------------------------------
; ��������������ȫ�ֱ����Ķ���
;------------------------------------------------------

szUser32Dll    db  'user32.dll',0
szMessageBox   db  'MessageBoxA',0   ;�÷�����kernel32.dll��
szHello        db  'HelloWorldPE',0  ;Ҫ������Ŀ¼


;-----------------------------
; ���� Handler
;-----------------------------
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

;------------------------------------
; ��ȡkernel32.dll�Ļ���ַ
;------------------------------------
_getKernelBase  proc
   local @dwRet

   pushad

   assume fs:nothing
   mov eax,fs:[30h] ;��ȡPEB���ڵ�ַ
   mov eax,[eax+0ch] ;��ȡPEB_LDR_DATA �ṹָ��
   mov esi,[eax+1ch] ;��ȡInInitializationOrderModuleList ����ͷ
   ;��һ��LDR_MODULE�ڵ�InInitializationOrderModuleList��Ա��ָ��
   lodsd             ;��ȡ˫������ǰ�ڵ��̵�ָ��
   mov eax,[eax+8]   ;��ȡkernel32.dll�Ļ���ַ
   mov @dwRet,eax
   popad
   mov eax,@dwRet
   ret
_getKernelBase  endp   

;-------------------------------
; ��ȡָ���ַ�����API�����ĵ��õ�ַ
; ��ڲ�����_hModuleΪ��̬���ӿ�Ļ�ַ
;           _lpApiΪAPI����������ַ
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

;------------------------
; �������ܲ���
; ��������������
;      _kernel:kernel32.dll�Ļ���ַ
;      _getAddr:����GetProcAddress��ַ
;      _loadLib:����LoadLibraryA��ַ
;------------------------
_patchFun  proc _kernel,_getAddr,_loadLib

    ;------------------------------------------------------
    ; �������ܴ���ֲ���������
    ;------------------------------------------------------

    local hUser32Base:dword
    local _messageBox:_ApiMessageBox    


    pushad


    ;------------------------------------------------------
    ; �������ܴ��룬����ֻ��һ������������Ϊ�����Ի���
    ;------------------------------------------------------


    ;��ȡuser32.dll�Ļ���ַ
    mov eax,offset szUser32Dll
    add eax,ebx

    mov edx,_loadLib
    push eax
    call edx
    mov hUser32Base,eax


    ;ʹ��GetProcAddress��������ַ��
    ;����������������GetProcAddress������
    ;���MessageBoxA����ַ
    mov eax,offset szMessageBox
    add eax,ebx
   
    mov edx,_getAddr
    mov ecx,hUser32Base
    push eax
    push ecx
    call edx
    mov _messageBox,eax
    
    ;���ú���MessageBox !!
    mov eax,offset szHello
    add eax,ebx
    mov edx,_messageBox

    push MB_OK
    push NULL
    push eax
    push NULL
    call edx


    popad
    ret
_patchFun  endp


_start  proc
    local hKernel32Base:dword  ;���kernel32.dll��ַ

    local _getProcAddress:_ApiGetProcAddress  ;���庯��
    local _loadLibrary:_ApiLoadLibrary

    pushad

    ;��ȡkernel32.dll�Ļ���ַ
    lea edx,_getKernelBase
    add edx,ebx
    call edx
    mov hKernel32Base,eax

    ;�ӻ���ַ��������GetProcAddress��������ַ
    mov eax,offset szGetProcAddr
    add eax,ebx

    mov edi,hKernel32Base
    mov ecx,edi
    lea edx,_getApi
    add edx,ebx

    push eax
    push ecx
    call edx
    mov _getProcAddress,eax

    ;�ӻ���ַ��������LoadLibraryA��������ַ
    mov eax,offset szLoadLib
    add eax,ebx

    mov edi,hKernel32Base
    mov ecx,edi
    lea edx,_getApi
    add edx,ebx

    push eax
    push ecx
    call edx
    mov _loadLibrary,eax

    ;���ò�������
    lea edx,_patchFun
    add edx,ebx

    push _loadLibrary
    push _getProcAddress
    push hKernel32Base
    call edx

    popad
    ret
_start  endp

; EXE�ļ��µ���ڵ�ַ

_NewEntry:
    call @F   ; ��ȥ�ض�λ
@@:
    pop ebx
    sub ebx,offset @B

    invoke _start
    jmpToStart   db 0E9h,0F0h,0FFh,0FFh,0FFh
    ret
    end _NewEntry