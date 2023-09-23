;�����嵥: thread.asm(�߳�ͬ����ʾ)
.386
.model flat, stdcall
option casemap :none
include     windows.inc
include     user32.inc
includelib  user32.lib
include     kernel32.inc
includelib  kernel32.lib

;��Դ�ļ����õ��ĳ���
DLG_MAIN        equ 1000
IDC_ROUNDS      equ 1001
IDC_COUNTER     equ 1002
IDC_SPEED       equ 1003
IDC_START       equ 1004
IDC_STOP        equ 1005
IDC_SYNC        equ 1006

;�����̵߳���Ŀ
THREADS         equ 10

.data
hInstance       dd  ?                   ;��ǰ����ʵ��
hWinDlg         dd  ?                   ;�Ի��򴰿ھ��
hWinStart       dd  ?                   ;"��ʼ����"��ť�Ĵ��ھ��
hWinStop        dd  ?                   ;"ֹͣ����"��ť�Ĵ��ھ��
hWinSync        dd  ?                   ;"ͬ��"��ѡ��Ĵ��ھ��
                
dwRunning       dd  THREADS dup (0)     ;10���̵߳����б�־,=1:��������
                
dwStopFlag      dd  1                   ;�̼߳��˱�־,=1ʱ�߳��Զ�ֹͣ
                
dwRounds        dd  ?                   ;ȫ���߳�����ɵ�����
dwCounter       dd  ?                   ;�����ĵ�ǰֵ
                
dwStartTick     dd  ?                   ;������ʼ��ʱ��(��λ:����)
dwCurrentTick   dd  ?                   ;��ǰʱ��(��λ:����)
                
szCounterMutex  db  'CounterMutex',0    ;��1��������������
szRoundsMutex   db  'RoundsMutex',0     ;��2��������������

hMutexCounter   dd  ?                   ;Ϊ����dwCounter�����õĻ�����
hMutexRounds    dd  ?                   ;Ϊ����dwRounds�����õĻ�����

.code
;��ʾ�����ĵ�ǰֵ������ɵ�������ÿ����ɵ�����
_ShowCounter    proc
        local   @dwSpeed                ;ÿ����ɵ�����

        invoke  GetTickCount
        mov     dwCurrentTick,eax       ;dwCurrentTick=GetTickCount()
        mov     eax,dwRounds
        mov     ebx,dwCurrentTick
        sub     ebx,dwStartTick         ;ebx=dwCurrentTick-dwStartTick

        cmp     ebx,0                   ;dwCurrentTick=dwStartTick,��������
        jz      div0
        mov     ecx,1000
        mul     ecx                     ;edx:eax=dwRounds*1000
        div     ebx                     ;eax=(dwRounds*1000)/ebx
div0:
        mov     @dwSpeed,eax
        
        ;��3���༭���зֱ���ʾdwCounter,dwRounds,@dwSpeed
        invoke  SetDlgItemInt,hWinDlg,IDC_COUNTER,dwCounter,FALSE
        invoke  SetDlgItemInt,hWinDlg,IDC_ROUNDS,dwRounds,FALSE
        invoke  SetDlgItemInt,hWinDlg,IDC_SPEED,@dwSpeed,FALSE
        ret
_ShowCounter    endp

;δ�����߳�ʱ, ����"��ʼ����"��ť, ��ֹ"ֹͣ����"��ť, ����"ͬ��"��ѡ��
_EnableStart    proc
        invoke  EnableWindow,hWinStart,TRUE
        invoke  EnableWindow,hWinStop,FALSE
        invoke  EnableWindow,hWinSync,TRUE
        ret
_EnableStart    endp

;�Ѵ������߳�, ��ֹ"��ʼ����"��ť, ����"ֹͣ����"��ť, ��ֹ"ͬ��"��ѡ��
_EnableStop     proc
        invoke  EnableWindow,hWinStart,FALSE
        invoke  EnableWindow,hWinStop,TRUE
        invoke  EnableWindow,hWinSync,FALSE
        ret
_EnableStop endp

;�ȴ�10���߳�ȫ�����н���
_WaitThreadStop proc
        xor ebx,ebx
        .while ebx < THREADS                ;ebx(i)��0ѭ����9
            .if dwRunning[ebx*4] == 0       ;��i���߳��Ƿ���������?
                inc     ebx                 ;��i���߳�δ����,�����һ��
            .else
                invoke  Sleep,10            ;��������,˯��10ms��������
            .endif
        .endw
        ret
_WaitThreadStop endp

;����ͬ�����߳�, _lParam=�̱߳��(x=0~9)
_ThreadWithSync proc    uses ebx esi edi,_lParam

        mov     ebx,_lParam
        mov     dwRunning[ebx*4],1          ;dwRunning[x]=1,�߳���������

        .while dwStopFlag == 0              ;dwStopFlag=1ʱ,�˳�whileѭ��

            ;��������̳߳���hMutexCounter������,�ȴ��û��������ͷ�
            ;WaitForSingleObjectִ�н�����,���̳߳���hMutexCounter������
            invoke  WaitForSingleObject,hMutexCounter,INFINITE
            
            ;����6��ָ��λ��hMutexCounter�������ı�����Χ
            ;��Щָ��ᱻ�����߳�ͬʱִ��
            mov     eax,dwCounter
            add     eax,1
            mov     dwCounter,eax               ;dwCounter++

            mov     eax,dwCounter
            sub     eax,1
            mov     dwCounter,eax               ;dwCounter--
            
            ;�ͷ�hMutexCounter������
            invoke  ReleaseMutex,hMutexCounter

            ;��hMutexRounds��������ֹ2���߳�ͬʱ����dwRounds
            invoke  WaitForSingleObject,hMutexRounds,INFINITE
            inc     dwRounds
            invoke  ReleaseMutex,hMutexRounds

        .endw

        mov ebx,_lParam
        mov dwRunning[ebx*4],0              ;dwRunning[x]=0,�߳��ѽ�������
        ret
_ThreadWithSync endp

;δ����ͬ�����߳�, _lParam=�̱߳��(x=0~9)
_ThreadWithoutSync  proc    uses ebx esi edi,_lParam

        mov     ebx,_lParam
        mov     dwRunning[ebx*4],1          ;dwRunning[x]=1,�߳���������

        .while dwStopFlag == 0              ;dwStopFlag=1ʱ,�˳�whileѭ��

            ;����6��ָ���dwCounter���и���,��ִ�й��̿��ܱ����,���´���
            mov     eax,dwCounter
            add     eax,1
            mov     dwCounter,eax           ;dwCounter++

            mov     eax,dwCounter
            sub     eax,1
            mov     dwCounter,eax           ;dwCounter--

            inc     dwRounds                ;dwRounds++
            
        .endw

        mov     ebx,_lParam
        mov     dwRunning[ebx*4],0          ;dwRunning[x]=0,�߳��ѽ�������
        ret
_ThreadWithoutSync  endp

;�Ի���Ĵ�����
_ProcDlgMain    proc    uses ebx edi esi hWnd,wMsg,wParam,lParam
        local   @dwThreadID
        local   @dwStartAddress

        mov eax,wMsg
        .if eax == WM_INITDIALOG                ;�Ի��򱻴���ʱ,���ʹ���Ϣ

            mov     eax,hWnd
            mov     hWinDlg,eax                 ;hWinDlg=hWnd
            
            ;���"��ʼ����"��ť��"ֹͣ����"��ť��"ͬ��"��ѡ��Ĵ��ھ��
            invoke  GetDlgItem,hWnd,IDC_START
            mov     hWinStart,eax
            invoke  GetDlgItem,hWnd,IDC_STOP
            mov     hWinStop,eax
            invoke  GetDlgItem,hWnd,IDC_SYNC
            mov     hWinSync,eax
            
            ;�̻߳�δ��ʼ����, ����"��ʼ����"��ť
            call    _EnableStart
            
            ;"ͬ��"��ѡ��ĳ�ʼ״̬��Ϊ"δѡ��"
            invoke  CheckDlgButton,hWnd,IDC_SYNC,BST_UNCHECKED
            
            ;����2��������
            invoke  CreateMutex,NULL,FALSE,offset szCounterMutex
            mov     hMutexCounter,eax
            invoke  CreateMutex,NULL,FALSE,offset szRoundsMutex
            mov     hMutexRounds,eax

        .elseif eax == WM_COMMAND

            mov     eax,wParam
            .if ax == IDC_START             ;"��ʼ����"��ť������
                mov     dwRounds,0          ;dwRounds=0
                mov     dwCounter,0         ;dwCounter=0
                mov     dwStopFlag,0        ;dwStopFlag=0
                
                invoke  GetTickCount
                mov     dwStartTick,eax     ;dwStartTick=������ʼʱ��
                
                ;���"ͬ��"��ѡ���Ƿ�ѡ��
                invoke  IsDlgButtonChecked,hWnd,IDC_SYNC
                .if eax == BST_CHECKED      
                    ;��ѡ��,ʹ��_ThreadWithSync�߳�
                    mov     @dwStartAddress,offset _ThreadWithSync
                .else
                    ;δѡ��,ʹ��_ThreadWithoutSync�߳�
                    mov     @dwStartAddress,offset _ThreadWithoutSync
                .endif

                ;ebx=0~9ѭ��,����10���߳�
                xor ebx,ebx
                .while ebx < THREADS
                    ;@dwStartAddress=�̺߳���
                    ;ebx=�̺߳�����_lParam
                    invoke  CreateThread,NULL,0,@dwStartAddress,ebx,\
                            NULL,addr @dwThreadID
                    invoke  CloseHandle,eax
                    inc     ebx
                .endw
                
                ;������ʱ��,ÿ100�������һ��WM_TIMER��Ϣ
                invoke  SetTimer,hWnd,1,100,NULL
                
                ;�߳��Ѿ���ʼ����, ����"��������"��ť
                call    _EnableStop
                
            .elseif ax == IDC_STOP              ;"��������"��ť������
                
                ;dwStopFlag=1,�̼߳�鵽�˱�־���ټ���
                mov     dwStopFlag,1        
                
                ;ɾ����ʱ��,���ٲ���WM_TIMER��Ϣ
                invoke  KillTimer,hWnd,1
                
                ;�ȴ�10���߳�ȫ������
                call    _WaitThreadStop
                
                ;��ʾ�����
                call    _ShowCounter
                
                ;�߳��Ѿ�ȫ������, ����"��ʼ����"��ť
                call    _EnableStart

            .endif

        .elseif eax == WM_TIMER

            ;��ʱ������ʱ,ÿ100�����յ�һ��WM_TIMER��Ϣ
            call    _ShowCounter                ;��ʾ��ǰ���

        .elseif eax == WM_CLOSE

            ;dwStopFlag=0,�߳�������,������رնԻ���
            .if dwStopFlag == 1
                invoke  EndDialog,hWnd,NULL     ;�����Ի���
            .endif

        .else

            mov     eax,FALSE                   ;��Ϣδ������, ����FALSE
            ret

        .endif
        
        mov     eax,TRUE                        ;��Ϣ�ѱ�����, ����TRUE
        ret
_ProcDlgMain    endp

_start:
        ;hInstance=GetModuleHandle(NULL)
        invoke  GetModuleHandle,NULL
        mov     hInstance,eax
        ;�����Ի���
        invoke  DialogBoxParam,eax,DLG_MAIN,NULL,offset _ProcDlgMain,NULL
        ;���̽���
        invoke  ExitProcess,NULL
end     _start
