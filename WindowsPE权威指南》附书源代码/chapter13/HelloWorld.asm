;------------------------
; �ҵĵ�һ������WIN32�Ļ�����
; ����
; 2006.2.28
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
szOut     db  'Value is:%d',0
szBuffer  db  256 dup(0)
szDataBuffer db 256 dup(0)


szLINI         db '.\_tmp.ini',0
szFailRead     db 'youarefail',0

szSectionName   db  'DPatchPEInfo.exe',0  ;��Բ�ͬ�ĳ����޸Ĵ˴���ֵ
szKeyName1    db  'majorImageVersion',0
szKeyName2    db  'minorImageVersion',0
szKeyName3    db  'downloadfile',0

;�����
    .code
start:

    invoke GetPrivateProfileString,addr szSectionName,\
                                   addr szKeyName3,\
                                   addr szFailRead,\
                                   addr szDataBuffer,\
                                   sizeof szDataBuffer,\
                                   addr szLINI  ;ȡ�ļ���

    invoke MessageBox,NULL,offset szDataBuffer,NULL,MB_OK

    invoke GetPrivateProfileInt,addr szSectionName,\
                                   addr szKeyName1,\
                                   0,\
                                   addr szLINI  ;ȡ�ļ���
    invoke wsprintf,addr szBuffer,addr szOut,eax
    invoke MessageBox,NULL,offset szBuffer,NULL,MB_OK


    invoke ExitProcess,NULL
    end start
