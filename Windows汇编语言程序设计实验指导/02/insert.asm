;程序清单：insert.asm(有序表插入算法)
.386
.model flat,stdcall
option casemap:none
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
.data
dArray          dword   50, 78, 99, 200, 451, 680, 718, 820, 1000, 2000
ITEMS           equ     ($-dArray)/4    ; 数组中元素的个数
                dword   ?    ; 插入一个元素后,dArray要延长,要占用这个双字
Element         dword   500             ; 要插入数组的数字
szFmt           byte    'dArray[%d]=%d', 0ah, 0 ; 输出结果格式字符串
.code
start:
                mov     eax, Element            ; EAX是要在数组中插入的数字
                mov     esi, 0                  ; ESI是要比较的元素的下标
c10:            
                cmp     dArray[esi*4], eax      ; 比较数组元素和要插入的数
                ja      c20                     ; 数组中的元素较大,不再比较
                                                
                inc     esi                     ; 下标加1
                cmp     esi, ITEMS              ; 是否数组元素全部已比较过
                jb      c10                     ; 没有,继续比较
                                                ; 全部比较过,则ESI=ITEMS
c20:            ; 插入位置为ESI, 从数组尾开始移动
                mov     edi, ITEMS-1            ; EDI是要移动的元素下标
c30:            
                cmp     edi, esi                ; EDI和ESI比较
                jl      c40                     ; EDI<ESI, 已移动完成
                mov     ebx, dArray[edi*4]      ; 先取出这个元素
                mov     dArray[edi*4+4], ebx    ; 向后移动1个位置
                dec     edi                     ; EDI指向上一个元素
                jmp     c30                     ; 继续移动
c40:            
                mov     dArray[esi*4], eax      ; 插入元素到下标为ESI的位置
                xor     edi, edi                ; 显示出各元素的值
c50:            
                invoke  printf, offset szFmt, edi, dArray[edi*4] ; 显示
                inc     edi                     ; EDI下标加1
                cmp     edi, ITEMS              ; 是否已全部显示完
                jbe     c50                     ; 继续显示
                ret
end             start
