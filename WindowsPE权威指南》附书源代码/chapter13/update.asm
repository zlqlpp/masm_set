;------------------------
; ������������
; ����
; 2010.11.28
;------------------------
    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc
include    user32.inc
includelib user32.lib
include    kernel32.inc
includelib kernel32.lib
include    urlmon.inc
includelib urlmon.lib

;���ݶ�
    .data
szINI          db '���������ļ���http://10.112.132.100/version.ini',0
szIsNewVesion  db '�����Ѿ������°汾',0
szLINI         db '.\_tmp.ini',0

hProcessID   dd ?  ;�������ͷ�ʱ���޸Ĵ˴�������ֵ  
oldMajor     dw 0  ; �ֱ��ǣ���������̺ţ����ξɰ汾��ֵ
oldMinor     dw 0

hProcess     dd ?
newMajor     dw 0
newMinor     dw 0

szOut1     db '%s_%d_%d.exe',0
szOut2     db '���ز����ļ�:http://10.112.132.100/soft/%s',0 ;Ҫ���ص�EXE�ļ�
szFailRead db 256 dup(0)
szSectionName   db  'DPatchPEInfo.exe',0  ;��Բ�ͬ�ĳ����޸Ĵ˴���ֵ
szKeyName1    db  'majorImageVersion',0
szKeyName2    db  'minorImageVersion',0
szKeyName3    db  'downloadfile',0


stStartUp	STARTUPINFO		<?>
stProcInfo	PROCESS_INFORMATION	<?> 

szExeFile     db  256 dup(0)
szBuffer      db  256 dup(0)
szDataBuffer  db  256 dup(0)
;�����
    .code


start:
    invoke MessageBox,NULL,offset szINI,NULL,MB_OK
    ;����ini�ļ�
    invoke URLDownloadToFile,0, \
                      addr szINI,
                      addr szLINI,0,0
    ;�򿪷���ini�ļ�
    invoke GetPrivateProfileInt,addr szSectionName,\
                                addr szKeyName1,\
                                0,\
                                addr szLINI
    mov newMajor,ax
    invoke GetPrivateProfileInt,addr szSectionName,\
                                addr szKeyName2,\
                                0,\
                                addr szLINI
    mov newMinor,ax

    ;�ж��Ƿ����°汾PE

    mov ax,newMajor
    mov bx,newMinor

    .if ax==oldMajor && bx==oldMinor

      ;��ʾ�Ѿ������°汾 
      invoke MessageBox,NULL,offset szIsNewVesion,NULL,MB_OK

    .else
       ;���°汾�������ظ�PE����ʵʩ�滻

       ;ȡ�ļ���DPatchPEInfo.exe_1_0.exe

       invoke RtlZeroMemory,addr szDataBuffer,256
       invoke GetPrivateProfileString,addr szSectionName,\
                                   addr szKeyName3,\
                                   NULL,\
                                   addr szDataBuffer,\
                                   sizeof szDataBuffer,\
                                   addr szLINI  ;ȡ�ļ���

       invoke wsprintf,addr szBuffer,addr szOut2,\
                                   addr szDataBuffer

       invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK

       ;����exe�ļ�
       invoke URLDownloadToFile,0, \
                      addr szBuffer,
                      addr szDataBuffer,0,0


       ;������ǰ������
       invoke OpenProcess,PROCESS_ALL_ACCESS,\
                     FALSE,hProcessID
       mov hProcess,eax
       invoke Sleep,1000

       invoke TerminateProcess,hProcess,0
       invoke CloseHandle,hProcess

       invoke Sleep,1000
       ;�����ص��ļ��滻ΪPE�ļ�
       invoke DeleteFile,addr szSectionName
       invoke CopyFile,addr szDataBuffer,addr szSectionName,\
                                                  TRUE
       invoke Sleep,1000
       ;����PE����
       invoke GetStartupInfo,addr stStartUp
       invoke CreateProcess,NULL,addr szSectionName,NULL,NULL,\
                      NULL,NORMAL_PRIORITY_CLASS,NULL,NULL,\
                      offset stStartUp,offset stProcInfo 
    .endif

    invoke ExitProcess,NULL
    end start
