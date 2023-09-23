;程序清单：inserts.asm(字符串插入)
.386
.model flat,stdcall
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
scanf           PROTO C :dword,:vararg
strlen          PROTO C :dword
.data
szFmt           byte    'result = "%s"', 0ah, 0
szStr1          byte    80 dup(0)               ; 第1个字符串
szStr2          byte    80 dup(0)               ; 第2个字符串
nLen1           dword   0                       ; 第1个字符串的长度
nLen2           dword   0                       ; 第2个字符串的长度
nPos            dword   0                       ; 插入位置
szStr           byte    160 dup(0)              ; 结果字符串
szInFormat      byte    '%s %s %d', 0
.code
start:
        ; 输入3个参数, szStr1, szStr2, nPos
        invoke  scanf, offset szInFormat, 
                offset szStr1, offset szStr2, offset nPos

        ; 求第1个字符串的长度
        invoke  strlen, offset szStr1
        mov     nLen1, eax

        ; 求第2个字符串的长度
        invoke  strlen, offset szStr2
        mov     nLen2, eax

        ; 复制第1个字符串szStr1到结果字符串szStr中
        lea     esi, szStr1
        lea     edi, szStr
        mov     ecx, nLen1
        cld
        rep     movsb

        ; szStr中nPos之后的部分字符串向后移动nLen2个字节
        ; 为第2个字符串留出位置
        mov     ecx, nLen1
        sub     ecx, nPos
        lea     esi, szStr
        add     esi, nLen1
        dec     esi
        mov     edi, esi
        add     edi, nLen2
        std
        rep     movsb

        ; 复制第2个字符串szStr2到结果字符串szStr+nPos处
        inc     esi
        mov     edi, esi
        lea     esi, szStr2
        mov     ecx, nLen2
        cld
        rep     movsb

        invoke  printf, offset szFmt, offset szStr
        ret
end     start
