;------------------------
; ����comset.bin�ļ��������ֽڶ�Ӧ��ָ��
; ���ߣ�����
; �������ڣ�2010.6.2
;------------------------
    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc
include    user32.inc
includelib user32.lib
include    kernel32.inc
includelib kernel32.lib

;���ݶ�
    .data
szText     db  'Sucess!',0
szFile     db  'c:\comset.bin',0  ;���ɵ��ļ�
szBinary   db  00,00,00,00,00,90h,90h
hFile      dd  ?
dwSize     db  0ffh
dwWritten  dd  ?
;�����
    .code
start:
    invoke CreateFile,addr szFile,GENERIC_WRITE,\
            FILE_SHARE_READ,\
                0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
    mov hFile,eax
    .repeat
         mov al,dwSize
         mov byte ptr [szBinary],al
         invoke WriteFile,hFile,addr szBinary,7,addr dwWritten,NULL
         dec dwSize
         .break .if dwSize==0
    .until FALSE
    invoke CloseHandle,hFile    
    invoke MessageBox,NULL,offset szText,NULL,MB_OK
    invoke ExitProcess,NULL
    end start
