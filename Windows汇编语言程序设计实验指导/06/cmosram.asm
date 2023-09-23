;�����嵥��cmosram.asm(��ȡʵʱ��)
.386
.model flat,stdcall
option casemap:none
includelib      msvcrt.lib
includelib      kernel32.lib
printf          PROTO C format:ptr sbyte,:vararg
CreateFileA     PROTO stdcall,
                lpFileName:NEAR32, dwDesiredAccess:dword, dwShareMode:dword,
                lpSecurityAttributes:NEAR32, dwCreationDisposition:dword,
                dwFlagsAndAttributes:dword, hTemplateFile:dword  
CloseHandle     PROTO stdcall, hObject:dword
; �����ǳ������õ���һЩ����
GENERIC_READ            EQU     80000000h
OPEN_EXISTING           EQU     3
FILE_ATTRIBUTE_NORMAL   EQU     00000080h
INVALID_HANDLE_VALUE    EQU     -1
NULL                    EQU     0
.data
driverStr       byte    "\\.\giveio", 0         ; �豸�ļ���
errStr          byte    'Load giveio.sys first!', 0ah, 0
cmosIndex       byte    9, 8, 7, 4, 2, 0        ; ��/��/��/ʱ/��/�������
cmosData        dword   6 dup (?)               ; ��/��/��/ʱ/��/��
fmtStr          byte    '20%02d/%02d/%02d %02d:%02d:%02d', 0ah, 0
.code
AllowIo         proc
                invoke  CreateFileA,                    ; ���ļ�
                        offset driverStr,               ; �ļ���
                        GENERIC_READ,                   ; ֻ����ʽ��
                        0,  
                        NULL,  
                        OPEN_EXISTING,                  ; ���Ѵ��ڵ��ļ�
                        0,  
                        0
                cmp     eax, INVALID_HANDLE_VALUE
                jz      OpenFail                        ; ���ܴ�, �˳�
                invoke  CloseHandle, eax                ; �ر��ļ�
                mov     eax, 1                          ; ����1, ��ʾTRUE
                ret
OpenFail:
                mov     eax, 0                          ; ����0, ��ʾFALSE
                ret
AllowIo         endp
start:
                call    AllowIo                         ; �Ƿ���Խ���I/O?
                cmp     eax, 0                          ; eax=0,���ܽ���I/O
                jnz     AllowIoLoadOk                   ; �˳�
                invoke  printf, offset errStr           ; ��ʾ��ʾ��Ϣ
                ret
AllowIoLoadOk:                
                mov     ecx, 6                          ; һ��Ҫ��ȡ6���ֽ�
                mov     esi, 0                          ; �����±��ʼ��Ϊ0
GetCmos:        
                mov     al, cmosIndex[esi]              ; ȡ������
                out     70h, al                         ; ��������
                in      al, 71h                         ; ��ȡ����
                ; ��ȡ����������BCD���ʽ
                ; ���� al=56h ��ʾ 56 ��
                mov     ah, al                          ; al->ah, ah=56h
                shr     ah, 4                           ; ȡ��4λ��ah�� 
                and     al, 0fh                         ; al��4λ����, 
                aad                                     ; ah*10+al->al
                mov     byte ptr cmosData[esi*4], al    ; ����
                inc     esi                             ; ������1
                loop    GetCmos                         ; ����ȡ��
                                                        ; ��/��/��/ʱ/��/��
                invoke  printf,                         ; ��ʾ���
                        offset fmtStr, 
                        cmosData[0*4],                  ; �� 
                        cmosData[1*4],                  ; ��
                        cmosData[2*4],                  ; ��
                        cmosData[3*4],                  ; ʱ
                        cmosData[4*4],                  ; ��
                        cmosData[5*4]                   ; ��
                ret
end             start
