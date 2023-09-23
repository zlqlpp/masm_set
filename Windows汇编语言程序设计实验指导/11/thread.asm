;程序清单: thread.asm(线程同步演示)
.386
.model flat, stdcall
option casemap :none
include     windows.inc
include     user32.inc
includelib  user32.lib
include     kernel32.inc
includelib  kernel32.lib

;资源文件中用到的常量
DLG_MAIN        equ 1000
IDC_ROUNDS      equ 1001
IDC_COUNTER     equ 1002
IDC_SPEED       equ 1003
IDC_START       equ 1004
IDC_STOP        equ 1005
IDC_SYNC        equ 1006

;创建线程的数目
THREADS         equ 10

.data
hInstance       dd  ?                   ;当前程序实例
hWinDlg         dd  ?                   ;对话框窗口句柄
hWinStart       dd  ?                   ;"开始计数"按钮的窗口句柄
hWinStop        dd  ?                   ;"停止计数"按钮的窗口句柄
hWinSync        dd  ?                   ;"同步"复选框的窗口句柄
                
dwRunning       dd  THREADS dup (0)     ;10个线程的运行标志,=1:正在运行
                
dwStopFlag      dd  1                   ;线程检查此标志,=1时线程自动停止
                
dwRounds        dd  ?                   ;全部线程已完成的轮数
dwCounter       dd  ?                   ;计数的当前值
                
dwStartTick     dd  ?                   ;计数开始的时刻(单位:毫秒)
dwCurrentTick   dd  ?                   ;当前时刻(单位:毫秒)
                
szCounterMutex  db  'CounterMutex',0    ;第1个互斥锁的名称
szRoundsMutex   db  'RoundsMutex',0     ;第2个互斥锁的名称

hMutexCounter   dd  ?                   ;为保护dwCounter所设置的互斥锁
hMutexRounds    dd  ?                   ;为保护dwRounds所设置的互斥锁

.code
;显示计数的当前值、已完成的轮数、每秒完成的轮数
_ShowCounter    proc
        local   @dwSpeed                ;每秒完成的轮数

        invoke  GetTickCount
        mov     dwCurrentTick,eax       ;dwCurrentTick=GetTickCount()
        mov     eax,dwRounds
        mov     ebx,dwCurrentTick
        sub     ebx,dwStartTick         ;ebx=dwCurrentTick-dwStartTick

        cmp     ebx,0                   ;dwCurrentTick=dwStartTick,不做除法
        jz      div0
        mov     ecx,1000
        mul     ecx                     ;edx:eax=dwRounds*1000
        div     ebx                     ;eax=(dwRounds*1000)/ebx
div0:
        mov     @dwSpeed,eax
        
        ;在3个编辑框中分别显示dwCounter,dwRounds,@dwSpeed
        invoke  SetDlgItemInt,hWinDlg,IDC_COUNTER,dwCounter,FALSE
        invoke  SetDlgItemInt,hWinDlg,IDC_ROUNDS,dwRounds,FALSE
        invoke  SetDlgItemInt,hWinDlg,IDC_SPEED,@dwSpeed,FALSE
        ret
_ShowCounter    endp

;未创建线程时, 允许"开始计数"按钮, 禁止"停止计数"按钮, 允许"同步"复选框
_EnableStart    proc
        invoke  EnableWindow,hWinStart,TRUE
        invoke  EnableWindow,hWinStop,FALSE
        invoke  EnableWindow,hWinSync,TRUE
        ret
_EnableStart    endp

;已创建了线程, 禁止"开始计数"按钮, 允许"停止计数"按钮, 禁止"同步"复选框
_EnableStop     proc
        invoke  EnableWindow,hWinStart,FALSE
        invoke  EnableWindow,hWinStop,TRUE
        invoke  EnableWindow,hWinSync,FALSE
        ret
_EnableStop endp

;等待10个线程全部运行结束
_WaitThreadStop proc
        xor ebx,ebx
        .while ebx < THREADS                ;ebx(i)从0循环到9
            .if dwRunning[ebx*4] == 0       ;第i个线程是否正在运行?
                inc     ebx                 ;第i个线程未运行,检查下一个
            .else
                invoke  Sleep,10            ;正在运行,睡眠10ms后继续检查
            .endif
        .endw
        ret
_WaitThreadStop endp

;进行同步的线程, _lParam=线程编号(x=0~9)
_ThreadWithSync proc    uses ebx esi edi,_lParam

        mov     ebx,_lParam
        mov     dwRunning[ebx*4],1          ;dwRunning[x]=1,线程正在运行

        .while dwStopFlag == 0              ;dwStopFlag=1时,退出while循环

            ;如果其他线程持有hMutexCounter互斥锁,等待该互斥锁被释放
            ;WaitForSingleObject执行结束后,本线程持有hMutexCounter互斥锁
            invoke  WaitForSingleObject,hMutexCounter,INFINITE
            
            ;以下6条指令位于hMutexCounter互斥锁的保护范围
            ;这些指令不会被两个线程同时执行
            mov     eax,dwCounter
            add     eax,1
            mov     dwCounter,eax               ;dwCounter++

            mov     eax,dwCounter
            sub     eax,1
            mov     dwCounter,eax               ;dwCounter--
            
            ;释放hMutexCounter互斥锁
            invoke  ReleaseMutex,hMutexCounter

            ;用hMutexRounds互斥锁防止2个线程同时更新dwRounds
            invoke  WaitForSingleObject,hMutexRounds,INFINITE
            inc     dwRounds
            invoke  ReleaseMutex,hMutexRounds

        .endw

        mov ebx,_lParam
        mov dwRunning[ebx*4],0              ;dwRunning[x]=0,线程已结束运行
        ret
_ThreadWithSync endp

;未进行同步的线程, _lParam=线程编号(x=0~9)
_ThreadWithoutSync  proc    uses ebx esi edi,_lParam

        mov     ebx,_lParam
        mov     dwRunning[ebx*4],1          ;dwRunning[x]=1,线程正在运行

        .while dwStopFlag == 0              ;dwStopFlag=1时,退出while循环

            ;以下6条指令对dwCounter进行更新,其执行过程可能被打断,导致错误
            mov     eax,dwCounter
            add     eax,1
            mov     dwCounter,eax           ;dwCounter++

            mov     eax,dwCounter
            sub     eax,1
            mov     dwCounter,eax           ;dwCounter--

            inc     dwRounds                ;dwRounds++
            
        .endw

        mov     ebx,_lParam
        mov     dwRunning[ebx*4],0          ;dwRunning[x]=0,线程已结束运行
        ret
_ThreadWithoutSync  endp

;对话框的处理函数
_ProcDlgMain    proc    uses ebx edi esi hWnd,wMsg,wParam,lParam
        local   @dwThreadID
        local   @dwStartAddress

        mov eax,wMsg
        .if eax == WM_INITDIALOG                ;对话框被创建时,发送此消息

            mov     eax,hWnd
            mov     hWinDlg,eax                 ;hWinDlg=hWnd
            
            ;获得"开始计数"按钮、"停止计数"按钮、"同步"复选框的窗口句柄
            invoke  GetDlgItem,hWnd,IDC_START
            mov     hWinStart,eax
            invoke  GetDlgItem,hWnd,IDC_STOP
            mov     hWinStop,eax
            invoke  GetDlgItem,hWnd,IDC_SYNC
            mov     hWinSync,eax
            
            ;线程还未开始运行, 允许"开始计数"按钮
            call    _EnableStart
            
            ;"同步"复选框的初始状态设为"未选中"
            invoke  CheckDlgButton,hWnd,IDC_SYNC,BST_UNCHECKED
            
            ;创建2个互斥锁
            invoke  CreateMutex,NULL,FALSE,offset szCounterMutex
            mov     hMutexCounter,eax
            invoke  CreateMutex,NULL,FALSE,offset szRoundsMutex
            mov     hMutexRounds,eax

        .elseif eax == WM_COMMAND

            mov     eax,wParam
            .if ax == IDC_START             ;"开始计数"按钮被按下
                mov     dwRounds,0          ;dwRounds=0
                mov     dwCounter,0         ;dwCounter=0
                mov     dwStopFlag,0        ;dwStopFlag=0
                
                invoke  GetTickCount
                mov     dwStartTick,eax     ;dwStartTick=计数开始时刻
                
                ;检查"同步"复选框是否被选中
                invoke  IsDlgButtonChecked,hWnd,IDC_SYNC
                .if eax == BST_CHECKED      
                    ;被选中,使用_ThreadWithSync线程
                    mov     @dwStartAddress,offset _ThreadWithSync
                .else
                    ;未选中,使用_ThreadWithoutSync线程
                    mov     @dwStartAddress,offset _ThreadWithoutSync
                .endif

                ;ebx=0~9循环,创建10个线程
                xor ebx,ebx
                .while ebx < THREADS
                    ;@dwStartAddress=线程函数
                    ;ebx=线程函数的_lParam
                    invoke  CreateThread,NULL,0,@dwStartAddress,ebx,\
                            NULL,addr @dwThreadID
                    invoke  CloseHandle,eax
                    inc     ebx
                .endw
                
                ;创建定时器,每100毫秒产生一个WM_TIMER消息
                invoke  SetTimer,hWnd,1,100,NULL
                
                ;线程已经开始运行, 允许"结束计数"按钮
                call    _EnableStop
                
            .elseif ax == IDC_STOP              ;"结束计数"按钮被按下
                
                ;dwStopFlag=1,线程检查到此标志后不再计数
                mov     dwStopFlag,1        
                
                ;删除定时器,不再产生WM_TIMER消息
                invoke  KillTimer,hWnd,1
                
                ;等待10个线程全部结束
                call    _WaitThreadStop
                
                ;显示最后结果
                call    _ShowCounter
                
                ;线程已经全部结束, 允许"开始计数"按钮
                call    _EnableStart

            .endif

        .elseif eax == WM_TIMER

            ;定时器存在时,每100毫秒收到一个WM_TIMER消息
            call    _ShowCounter                ;显示当前结果

        .elseif eax == WM_CLOSE

            ;dwStopFlag=0,线程在运行,不允许关闭对话框
            .if dwStopFlag == 1
                invoke  EndDialog,hWnd,NULL     ;结束对话框
            .endif

        .else

            mov     eax,FALSE                   ;消息未被处理, 返回FALSE
            ret

        .endif
        
        mov     eax,TRUE                        ;消息已被处理, 返回TRUE
        ret
_ProcDlgMain    endp

_start:
        ;hInstance=GetModuleHandle(NULL)
        invoke  GetModuleHandle,NULL
        mov     hInstance,eax
        ;创建对话框
        invoke  DialogBoxParam,eax,DLG_MAIN,NULL,offset _ProcDlgMain,NULL
        ;进程结束
        invoke  ExitProcess,NULL
end     _start
