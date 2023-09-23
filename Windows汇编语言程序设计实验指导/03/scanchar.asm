;程序清单：scanchar.asm(字符扫描与替换)
.386
.model flat,stdcall
option casemap:none
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
time            PROTO C :dword
.data
szStr   byte    'How do you do!', 0
nLen    dword   0               ; 字符串长度
szLen   byte    0ah, 'nLen = %d', 0ah, 0
.code
start:
        lea     edi, szStr      ; 指向目标字符串
        mov     al, 0
        repnz   scasb           ; ZF=1则停止扫描
        sub     edi, offset szStr
        mov     nLen, edi

        lea     edi, szStr      ; 指向目标字符串
        mov     ecx, nLen       ; szStr占15个字节
        cld                     ; 地址由低至高
        mov     al, 'o'
        repnz   scasb           ; ZF=1则停止扫描
        jnz     c10

        mov     byte ptr [edi-1], 'O'   ; 替换第1个o为O

c10:

        lea     edi, szStr      ; 指向目标字符串
        add     edi, nLen
        dec     edi             ; 指向最后1个字符'!'
        mov     ecx, nLen       ; szStr占15个字节
        std                     ; 地址由高至低
        mov     al, ' '
        repnz   scasb           ; ZF=1则停止扫描
        jnz     c20

        mov     byte ptr [edi+1], '*'   ; 替换最后1个空格为*

c20:
        cld
        invoke  printf, offset szStr            ; 显示字符串
        invoke  printf, offset szLen, nLen      ; 显示字符串长度
        ret
end     start

; 编译链接命令：
; ml /coff scanchar.asm /link /subsystem:console