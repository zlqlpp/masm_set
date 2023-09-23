;程序清单：recurse.asm(计算幂的递归程序)
.386
.model flat,stdcall
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
.data
szOut           byte    'x=%d n=%d x(n)=%d', 0ah, 0
.code           
power           proc    C  x:dword, n:dword
                cmp     n, 0
                jle     exitrecurse
                mov     ebx, n                  ; EBX = n
                dec     ebx                     ; EBX = n-1
                invoke  power, x, EBX           ; EAX = x(n-1)
                imul    x                       ; EAX = EAX * x
                ret                             ;     = x(n-1) * x = x(n)
exitrecurse: 
                mov     eax, 1                  ; n = 0时, x(n) = 1
                ret
power           endp
start           proc
                local   x,n,p:dword
                mov     x, 3
                mov     n, 5
                invoke  power, x, n             ; EAX = x(n)
                mov     p, eax
                ; printf ("x=%d n=%d x(n)=%d\n" , x, n, p)
                invoke  printf, offset szOut, x, n, p   
                ret
start           endp
end             start
