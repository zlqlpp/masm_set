;�����嵥��local.asm(�ֲ�����)
.386
.model flat, stdcall
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
.data
r               dword   10
s               dword   20
szMsgOut1       byte    'r=%d s=%d', 0ah, 0
szMsgOut2       byte    'u=%d v=%d', 0ah, 0
.code           
swap            proc    C  a:ptr dword, b:ptr dword  ; ʹ�ö�ջ���ݲ���
                local   temp1,temp2:dword
                mov     eax, a                   
                mov     ecx, [eax]
                mov     temp1, ecx              ; temp1 = *a
                mov     ebx, b                  
                mov     edx, [ebx]
                mov     temp2, edx              ; temp2 = *b
                mov     ecx, temp2
                mov     eax, a                   
                mov     [eax], ecx              ; *a = temp2
                mov     ebx, b                  
                mov     edx, temp1
                mov     [ebx], edx              ; *b = temp1
                ret
swap            endp
start           proc
                local   u,v:dword
                invoke  swap, offset r, offset s  
                invoke  printf, offset szMsgOut1, r, s
                mov     u, 70
                mov     v, 80
                invoke  swap, addr u, addr v 
                invoke  printf, offset szMsgOut2, u, v
                ret
start           endp
end             start
