;------------------------
; 动态TLS演示
; 戚利
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

MAX_THREAD_COUNT equ 4

;数据段
    .data
hTlsIndex  dd  ?
dwThreadID dd  ?
hThreadID  dd  MAX_THREAD_COUNT dup(0)

dwCount    dd  ?

szBuffer   db  500 dup(0)
szOut1     db  '线程%d终止，用时：%d毫秒。',0
szErr1     db  '读取TLS槽数据时失败！',0
szErr2     db  '写入TLS槽数据时失败！',0



;代码段
    .code

;----------
; 初始化
;----------
_initTime  proc  
   local @dwStart

   pushad

   ;获得当前时间，
   ;将线程的创建时间与线程对象相关联
   invoke GetTickCount
   mov @dwStart,eax
   invoke TlsSetValue,hTlsIndex,@dwStart
   .if eax==0
     invoke MessageBox,NULL,addr szErr2,\
                                NULL,MB_OK
   .endif
   popad
   ret
_initTime endp

;----------
; 获取用时
;----------
_getLostTime  proc  
   local @dwTemp
   pushad

   ;获得当前时间，
   ;返回当前时间和线程创建时间的差值
   invoke GetTickCount
   mov @dwTemp,eax
   invoke TlsGetValue,hTlsIndex
   .if eax==0
     invoke MessageBox,NULL,addr szErr2,\
                                NULL,MB_OK
   .endif
   sub @dwTemp,eax
   popad
   mov eax,@dwTemp
   ret
_getLostTime endp


;----------
; 线程函数
;----------
_tFun   proc  uses ebx ecx edx esi edi,lParam
   local @dwCount
   local @tID
   pushad

   invoke _initTime

   ;模拟耗时操作
   mov @dwCount,1000*10000
   mov ecx,@dwCount
   .while ecx>0
     dec @dwCount
     dec ecx
   .endw 

   invoke GetCurrentThreadId
   mov @tID,eax
   invoke _getLostTime
   invoke wsprintf,addr szBuffer,\
                    addr szOut1,@tID,eax
   invoke MessageBox,NULL,addr szBuffer,\
                               NULL,MB_OK

   popad
   ret
_tFun   endp


start:
  ;通过在进程位数组中申请一个索引，
  ;初始化线程运行时间记录系统
  invoke TlsAlloc
  mov hTlsIndex,eax

  mov dwCount,MAX_THREAD_COUNT
  mov edi,offset hThreadID
  .while  dwCount>0
     invoke  CreateThread,NULL,0,\
                offset _tFun,NULL,\
                NULL,addr dwThreadID
     mov dword ptr [edi],eax
     add edi,4

     dec dwCount
  .endw
  
  ;等待结束线程
  mov dwCount,MAX_THREAD_COUNT
  mov edi,offset hThreadID
  .while  dwCount>0
     mov eax,dword ptr [edi]
     mov dwThreadID,eax
     push edi
     invoke WaitForSingleObject,eax,\
                              INFINITE
     invoke CloseHandle,dwThreadID
     pop edi

     add edi,4
     dec dwCount
  .endw

  ;通过释放线程局部存储索引，
  ;释放时间记录系统占用的资源
  invoke TlsFree,hTlsIndex

  end start
