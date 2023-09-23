;程序清单：invoke.asm(invoke伪指令)
.386
.model flat,stdcall
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
.data
szFmt           byte    '%d - %d = %d', 0ah, 0  ;输出结果格式字符串
.code
SubProc1        proc    c  a:dword, b:dword     ; 使用堆栈传递参数, C规则
                mov     eax, a                  ; 取出第1个参数
                sub     eax, b                  ; 取出第2个参数
                ret                             ;
SubProc1        endp
SubProc2        proc    stdcall a:dword, b:dword; 使用堆栈传递参数, stdcall规则
                mov     eax, a                  ; 取出第1个参数
                sub     eax, b                  ; 取出第2个参数
                ret                             ;
SubProc2        endp
start:
                invoke  SubProc1, 100, 40       ; 调用SubProc1
                invoke  printf, offset szFmt, 
                        100, 40, eax            ; 显示第1次减法结果
                invoke  SubProc2, 200, 5        ; 调用SubProc2
                invoke  printf, offset szFmt, 
                        200, 5, eax             ; 显示第2次减法结果
                ret
end             start
