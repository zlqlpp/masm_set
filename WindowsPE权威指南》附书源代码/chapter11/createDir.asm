;-------------------------
; һ���򵥵Ĳ���API��ں�����̬��õ�С����
; ������ʹ�ö�̬�������hDllKernel32�Ļ�ַ��
; ���ӻ�ַ���������Ӧ�ĺ������Լ�ƫ��
; ʵ�ִ���Ŀ¼�ķ������Ի�����ʾ��������
; ���ߣ�����
; �������ڣ�2010.6.26
;-------------------------

.386
.model flat,stdcall
option casemap:none

include     windows.inc
include     user32.inc
includelib  user32.lib

_ProtoGetProcAddress  typedef proto :dword,:dword
_ProtoLoadLibrary     typedef proto :dword
_ProtoMessageBox      typedef proto :dword,:dword,:dword,:dword

_ApiGetProcAddress    typedef ptr _ProtoGetProcAddress
_ApiLoadLibrary       typedef ptr _ProtoLoadLibrary
_ApiMessageBox        typedef ptr _ProtoMessageBox

.data

CreateDir       dd   ?             ;CreateDirectoryA��������ʵ��ַ
lpCreateDir     dd   ?             ;δ��
jmpCreateDir    db   0ffh,025h     ;����һ����תָ���������תjmp 
jmpCDOffset     dd   ?             ;���������Ҫ��ת����ƫ�ƣ���ƫ��ָ��CreateDir��

hDllKernel32    dd   ?              ;���kernel32.dll��ַ
hDllUser32      dd   ?
dwEsp           dd   ?
szBuffer        db   256 dup(0)


_GetProcAddress _ApiGetProcAddress  ?
_LoadLibrary    _ApiLoadLibrary     ?
_MessageBox     _ApiMessageBox      ?

.const

szLoadLibrary     db  'LoadLibraryA',0
szGetProcAddress  db  'GetProcAddress',0
szUser32          db  'user32.dll',0
szMessageBox      db  'MessageBoxA',0        ;�÷�����user32.dll��
szCreateDir       db  'CreateDirectoryA',0   ;�÷�����kernel32.dll��

szDir             db  'c:\\BBBN',0         ;Ҫ������Ŀ¼
szCaption         db  '��̬����API����ʾ��',0
szText	          db  '����һ��c�̸�Ŀ¼�£����Ƿ���Ŀ¼BBBN�ĳ��֣�',0
szFmt             db  'return address=%08x',0

.code

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

_GetKernelBase proc _dwKernelRet
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
_GetKernelBase endp

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


start:
  mov eax,dword ptr [esp]  ;��kernel32�е�һ����ַ�Ӷ�ջ��ȡ����
  mov dwEsp,eax
  mov eax,offset CreateDir
  mov jmpCDOffset,eax
  
  invoke _GetKernelBase,dwEsp

  .if eax
    mov hDllKernel32,eax
    invoke _getApi,hDllKernel32,addr szGetProcAddress   ;��ȡGetProcAddress�������ڴ��ַ
    mov _GetProcAddress,eax
    .if _GetProcAddress
      invoke _GetProcAddress,hDllKernel32,addr szCreateDir  ;��ȡ����Ŀ¼�������ڴ��ַ������
      mov CreateDir,eax

      push NULL
      mov eax,offset szDir
      push eax
      mov eax,offset jmpCreateDir
      call eax


      invoke _GetProcAddress,hDllKernel32,addr szLoadLibrary  ;��ȡLoadLibrary�������ڴ��ַ
      mov _LoadLibrary,eax
      .if eax
        invoke _LoadLibrary,addr szUser32                     ;װ��user32.dll
        mov hDllUser32,eax
        invoke _GetProcAddress,hDllUser32,addr szMessageBox   ;���MessageBox�������ڴ��ַ������
        mov _MessageBox,eax
      .endif
    .endif

    .if _MessageBox
      push MB_OK
      mov eax,offset szCaption
      push eax
      mov eax,offset szText
      push eax
      push 00000000
      call _MessageBox
    .endif
  .endif

  ;��windows2000�У���Ҫ�Ƚ�user32.dll���ؽ����̿ռ�
  invoke wsprintf,addr szBuffer,addr szFmt,eax

  ;���ǹؼ��������ʹ��retָ��أ����ջ�н�������kernel32��ĳ����ַ
  ret   

           end start
