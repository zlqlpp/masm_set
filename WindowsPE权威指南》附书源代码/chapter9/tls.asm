;------------------------
; ��̬TLS��ʾ
; ����
; 2010.2.28
;------------------------
    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc
include    user32.inc
includelib user32.lib
include    kernel32.inc
includelib kernel32.lib

    .data

szText  db 'HelloWorldPE',0,0,0,0  

; ����IMAGE_TLS_DIRECTORY

TLS_DIR     dd offset Tls1
            dd offset Tls2
            dd offset Tls3
            dd offset TlsCallBack
            dd 0
            dd 0
Tls1        dd 0
Tls2        dd 0
Tls3        dd 0
TlsCallBack dd  offset TLS
            dd     0
            dd     0

    .data?

TLSCalled db ?   ;�ؽ���־

    .code

start:
 
    invoke ExitProcess,NULL
    RET

    ; ���´��뽫����.code֮ǰִ��һ��
TLS:

    ; ����TLSCalled��һ�����ؽ���־����������¸ò��ִ���
    ; �ᱻִ�����Σ���ʹ���˸ñ�ʶ�󣬸ô���ֻ�ڿ�ʼ����ǰ
    ; ִ��һ��
    
    cmp byte ptr [TLSCalled],1
    je @exit
    mov byte ptr [TLSCalled],1
    invoke MessageBox,NULL,addr szText,NULL,MB_OK

@exit:

    RET

    end start  