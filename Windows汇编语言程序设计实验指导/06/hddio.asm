;�����嵥��hddio.asm(PIO��ʽ��ȡӲ������)
.386
.model flat,stdcall
option casemap:none
includelib      msvcrt.lib
includelib      kernel32.lib
printf          PROTO C format:ptr sbyte,:vararg
CreateFileA     PROTO stdcall,
                lpFileName:NEAR32,dwDesiredAccess:dword,dwShareMode:dword,
                lpSecurityAttributes:NEAR32,dwCreationDisposition:dword,
                dwFlagsAndAttributes:dword,hTemplateFile:dword  
CloseHandle     PROTO stdcall,hObject:dword
; �����ǳ������õ���һЩ����
GENERIC_READ            EQU     80000000h
OPEN_EXISTING           EQU     3
FILE_ATTRIBUTE_NORMAL   EQU     00000080h
INvalID_HANDLE_valUE    EQU     -1
NULL                    EQU     0

pio_base_addr1          EQU     01F0H
pio_base_addr2          EQU     03F0H
numSect                 EQU     1               ; �������������
lbaSector               EQU     0               ; �������LBA

.data                        
driverStr       byte    "\\.\giveio",0          ; �豸�ļ���
errStr          byte    'Load giveio.sys first!',0ah,0
_Buffer         byte    512*numSect dup (2)     ; ���ڱ���������������
_BufferLen      equ     $-_Buffer
szFmt           byte    '%02X ',0
szCRLF          byte    0dh, 0ah, 0

outx            MACRO   port,val
                mov     dx,port
                mov     al,val
                out     dx,al
                ENDM

inx             MACRO   port
                mov     dx,port
                in      al,dx
                ENDM
.code
AllowIo         proc
                invoke  CreateFileA,                   ; ���ļ�
                        offset driverStr,              ; �ļ���
                        GENERIC_READ,                  ; ֻ����ʽ��
                        0, 
                        NULL, 
                        OPEN_EXISTING,                 ; ���Ѵ��ڵ��ļ�
                        0, 
                        0
                cmp     eax,INvalID_HANDLE_valUE
                jz      OpenFail                       ; ���ܴ�,�˳�
                invoke  CloseHandle,eax                ; �ر��ļ�
                mov     eax,1                          ; ����1,��ʾTRUE
                ret
OpenFail:
                mov     eax,0                          ; ����0,��ʾFALSE
                ret
AllowIo         endp
start:
                call    AllowIo                        ; �Ƿ���Խ���I/O?
                cmp     eax,0                          ; eax=0,���ܽ���I/O
                jnz     AllowIoLoadOk                  ; �˳�
                invoke  printf,offset errStr           ; ��ʾ��ʾ��Ϣ
                ret
AllowIoLoadOk:    


                ; SRST=1, ��λӲ��
                outx    pio_base_addr2+6,04h           ; SRST=1

                outx    pio_base_addr2+6,00h           ; SRST=0

                ; �ȴ���ֱ��BSY=0����DRQ=0.
waitReady:
                inx     pio_base_addr1+7               ; read primary status
                and     al,10001000b                   ; busy,or data request
                jnz     waitReady

                ; ����feature port�Ĵ���
                outx    pio_base_addr1+1,00h
                ; ����sector count�Ĵ���, Ҫ��д��������
                outx    pio_base_addr1+2,numSect
                ; ����sector numbert�Ĵ���, LBA(7:0)
                outx    pio_base_addr1+3,((lbaSector shr 0) and 0ffh)
                ; ����cylinder low�Ĵ���,   LBA(15:8)
                outx    pio_base_addr1+4,((lbaSector shr 8) and 0ffh)   ; 
                ; ����cylinder high�Ĵ���,  LBA(23:16)
                outx    pio_base_addr1+5,((lbaSector shr 16) and 0ffh)  ; 
                ; ����device/head�Ĵ���, LBA=1, DEV=0, LBA(27:24)
                outx    pio_base_addr1+6,01000000b or ((lbaSector shr 24) and 0fh)   
                ; ����command�Ĵ���, 20h��ʾREAD SECTOR(S)
                outx    pio_base_addr1+7,020h 

                ; �ȴ���ֱ��DRDY=1, DSC=1, DRQ=1.
waitHDD:                
                inx     pio_base_addr1+7
                cmp     al,01011000b
                jnz     waitHDD

                ; ÿ����������256�Σ�ÿ�ζ���2���ֽڣ�˳�򱣴���_Buffer��
                lea     edi,_Buffer
                cld
                mov     ecx,numSect*256
Read2Bytes:
                mov     dx,pio_base_addr1
                in      ax,dx
                stosw
                loop    Read2Bytes

                ; ��ʾ_Buffer����
                call    DisplayBuffer
                                
                ret
                
DisplayBuffer   proc
                lea     esi,_Buffer
                mov     ecx,_BufferLen
                xor     eax,eax
                xor     ebp,ebp
                cld
DisplayByte:
                push    ecx                
                lodsb
                invoke  printf,offset szFmt,eax
                inc     ebp 
                test    ebp, 0fh
                jnz     DisplayCRLF
                invoke  printf,offset szCRLF
DisplayCRLF:               
                pop     ecx
                loop    DisplayByte
                ret
DisplayBuffer   endp                
end             start

; ���롢ִ�й���
;    c:\asm\bin\asmvars.bat
;    ml /coff hddio.asm /link /subsystem:console
;    allowio -load c:\asm\bin\giveio.sys
;    hddio
