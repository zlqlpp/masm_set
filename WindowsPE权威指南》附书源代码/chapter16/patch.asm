;-------------------------
; һ�θ��ӵ�����PE�ļ���С����
; ���δ���ʹ����API������ַ��̬��ȡ�Լ��ض�λ����
; �����ܣ�ʵ�ִ���Ŀ¼�ķ���
; ���ߣ�����
; �������ڣ�2010.6.30
;-------------------------

    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc



_ProtoGetProcAddress  typedef proto :dword,:dword
_ProtoLoadLibrary     typedef proto :dword
_ProtoCreateDir       typedef proto :dword,:dword


_ApiGetProcAddress    typedef ptr _ProtoGetProcAddress
_ApiLoadLibrary       typedef ptr _ProtoLoadLibrary
_ApiCreateDir         typedef ptr _ProtoCreateDir


;����ӵ�Ŀ���ļ��Ĵ�������￪ʼ����APPEND_CODE_END������

    .code

jmp _NewEntry


szGetProcAddr  db  'GetProcAddress',0
szLoadLib      db  'LoadLibraryA',0
szCreateDir    db  'CreateDirectoryA',0   ;�÷�����kernel32.dll��
szDir          db  'c:\\BBBN',0           ;Ҫ������Ŀ¼


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

;-------------------------------------------
; ���ڴ���ɨ�� Kernel32.dll �Ļ�ַ
; ��ָ���Ļ�ַ����ߵ�ַ������
;-------------------------------------------

_getKernelBase proc _dwKernelRet
  local @dwReturn
  
  pushad
  mov @dwReturn,0

  ;�ض�λ
  call @F
@@:
  pop ebx
  sub ebx,offset @B

  ;�������ڴ������SEH�ṹ
  assume fs:nothing
  push ebp
  lea eax,[ebx+offset _ret]
  push eax
  lea eax,[ebx+offset _SEHHandler]
  push eax
  push fs:[0]
  mov fs:[0],esp

  ;����kernel32.dll�Ļ�ַ
  mov edi,_dwKernelRet
  and edi,0ffff0000h   ;�ҵ����ص�ַ���ڴ�����ͷ
  .while TRUE
    .if word ptr [edi]==IMAGE_DOS_SIGNATURE
      mov esi,edi
      add esi,[esi+3ch]
      .if word ptr [esi]==IMAGE_NT_SIGNATURE
        mov @dwReturn,edi
        .break
      .endif
    .endif
_ret:
    sub edi,010000h             ;����һ���ڴ�ҳ�棬��������
    .break .if edi<070000000h   ;ֱ����ַС��070000000h
  .endw  
  pop fs:[0]
  add esp,0ch
  popad
  mov eax,@dwReturn
  ret
_getKernelBase endp

;------------------------------------------------
; ���ڴ���ģ��ĵ������л�ȡĳ�� API ����ڵ�ַ
;------------------------------------------------
_getApi  proc  _hModule,_lpszApi
  local @dwReturn,@dwStringLen
  
  pushad
  mov @dwReturn,0
  call @F
@@:
  pop ebx
  sub ebx,offset @B

  ;�������ڴ������SEH�ṹ
  assume fs:nothing
  push ebp
  lea eax,[ebx+offset _ret]
  push eax
  lea eax,[ebx+offset _SEHHandler]
  push eax
  push fs:[0]
  mov fs:[0],esp

  ;����API�ַ����ĳ��ȣ�ע���β����0��
  mov edi,_lpszApi
  mov ecx,-1
  xor al,al
  cld
  repnz scasb
  mov ecx,edi
  sub ecx,_lpszApi
  mov @dwStringLen,ecx
  ;��DLL�ļ�ͷ������Ŀ¼�л�ȡ�������λ��
  mov esi,_hModule
  add esi,[esi+3ch]
  assume esi:ptr IMAGE_NT_HEADERS
  mov esi,[esi].OptionalHeader.DataDirectory.VirtualAddress
  add esi,_hModule
  assume esi:ptr IMAGE_EXPORT_DIRECTORY
  mov ebx,[esi].AddressOfNames
  add ebx,_hModule
  xor edx,edx
  .repeat
    push esi
    mov edi,[ebx]
    add edi,_hModule
    mov esi,_lpszApi
    mov ecx,@dwStringLen
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
  ;API��������->�������->��ַ����
  sub ebx,[esi].AddressOfNames
  sub ebx,_hModule
  shr ebx,1
  add ebx,[esi].AddressOfNameOrdinals
  add ebx,_hModule
  movzx eax,word ptr [ebx]
  shl eax,2
  add eax,[esi].AddressOfFunctions
  add eax,_hModule
  ;�ӵ�ַ��õ�����������ַ
  mov eax,[eax]
  add eax,_hModule
  mov @dwReturn,eax
_ret:
  pop fs:[0]
  add esp,0ch
  assume esi:nothing
  popad
  mov eax,@dwReturn
  ret
_getApi  endp

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
    end _NewEntry