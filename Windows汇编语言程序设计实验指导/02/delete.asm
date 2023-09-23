;程序清单：delete.asm(删除数组元素)
.386
.model flat,stdcall
option casemap:none
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
scanf           PROTO C :dword,:vararg
.data
dArray          dword   850, 7, 39, 200, 13, 60, 47, 0, 600, 240
nItems          dword   ($-dArray)/4    ; 数组中元素的个数
Element         dword   ?               ; 要删除的元素
szFmt           byte    'dArray[%d]=%d', 0ah, 0 ; 输出结果格式字符串
dElement        dword   ?
szPrompt        byte    'Input the element to delete: ', 0   ; 提示字符串
szScanfIn       byte    '%d', 0
szNotFound      byte    '%d is not found.', 0
.code
start:
                invoke  printf, offset szPrompt
                invoke  scanf, offset szScanfIn, offset Element

                mov     eax, Element            ; EAX是要在数组中删除的元素
                mov     esi, 0                  ; ESI是要比较的元素的下标
c10:            
                cmp     dArray[esi*4], eax      ; 是否要删除？
                jz      c20                     ; 相等，删除之
                                                
                inc     esi                     ; 下标加1
                cmp     esi, nItems             ; 是否数组元素全部已比较过
                jb      c10                     ; 没有,继续比较

                invoke  printf, offset szNotFound, Element

                jmp     c40                     ; 全部比较过, 没有找到
                                                
c20:
                dec     nItems
                mov     edi, esi                ; EDI是被覆盖的元素下标
c30:            
                cmp     edi, nItems             ; EDI和nItems比较
                jae     c40                     ; EDI>=nItems, 已移动完成
                mov     ebx, dArray[edi*4+4]    ; 先取出下一个元素
                mov     dArray[edi*4], ebx      ; 向前移动1个位置
                inc     edi                     ; EDI指向下一个元素
                jmp     c30                     ; 继续移动
c40:
                xor     edi, edi                ; 显示出各元素的值
c50:            
                invoke  printf, offset szFmt, edi, dArray[edi*4] ; 显示
                inc     edi                     ; EDI下标加1
                cmp     edi, nItems             ; 是否已全部显示完
                jb      c50                     ; 继续显示
                ret
end             start
