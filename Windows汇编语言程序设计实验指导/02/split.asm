;程序清单：split.asm(折半查找算法)
.386
.model flat,stdcall
option casemap:none
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
.data
dArray          dword   50, 78, 99, 200, 451, 680, 718, 820, 1000, 2000
ITEMS           equ     ($-dArray)/4    ; 数组中元素的个数
Element         dword   680             ; 在数组中查找的数字
Index           dword   ?               ; 在数组中的序号
Count           dword   ?               ; 查找的次数
szFmt           byte    'Index=%d Count=%d Element=%d', 0ah, 0 ; 格式字符串
szErrMsg        byte    'Not found, Count=%d Element=%d', 0ah, 0 
.code
start:
                mov     Index, -1               ; 赋初值, 假设找不到
                mov     Count, 0                ; 赋初值, 查找次数为0
                mov     ecx, 0                  ; ECX表示查找范围的下界
                mov     edx, ITEMS-1            ; EDX表示查找范围的上界
                mov     eax, Element            ; EAX是要在数组中查找的数字
b10:            
                cmp     ecx, edx                ; 下界是否超过上界
                jg      b40                     ; 如果下界超过上界, 未找到
                mov     esi, ecx                ; 取下界和上界的中点
                add     esi, edx                ; ESI=(ECX+EDX)
                shr     esi, 1                  ; ESI=(ECX+EDX)/2
                inc     Count                   ; 查找次数加1
                cmp     eax, dArray[esi*4]      ; 与中点上的元素比较
                jz      b30                     ; 相等, 查找结束
                jg      b20                     ; 较大, 移动下界
                mov     edx, esi                ; 较小, 移动上界
                dec     edx                     ; ESI元素已比较过, 不再比较
                jmp     b10                     ; 范围缩小后, 继续查找
b20:            
                mov     ecx, esi                ; 较大, 移动下界
                inc     ecx                     ; ESI元素已比较过, 不再比较
                jmp     b10                     ; 范围缩小后, 继续查找
b30:            
                mov     Index, esi              ; 找到, ESI是下标
                ; printf("Index=%d Count=%d Element=%d\n", 
                ;         Index, Count, dArray[Index]);
                invoke  printf, offset szFmt, Index, Count, dArray[esi*4]
                jmp     b50
b40:            
                ; printf("Not found, Count=%d Element=%d\n", Count, Element);
                invoke  printf, offset szErrMsg, Count, Element 
b50:            
                ret
end             start
