;�����嵥��inserts.asm(�ַ�������)
.386
.model flat,stdcall
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
scanf           PROTO C :dword,:vararg
strlen          PROTO C :dword
.data
szFmt           byte    'result = "%s"', 0ah, 0
szStr1          byte    80 dup(0)               ; ��1���ַ���
szStr2          byte    80 dup(0)               ; ��2���ַ���
nLen1           dword   0                       ; ��1���ַ����ĳ���
nLen2           dword   0                       ; ��2���ַ����ĳ���
nPos            dword   0                       ; ����λ��
szStr           byte    160 dup(0)              ; ����ַ���
szInFormat      byte    '%s %s %d', 0
.code
start:
        ; ����3������, szStr1, szStr2, nPos
        invoke  scanf, offset szInFormat, 
                offset szStr1, offset szStr2, offset nPos

        ; ���1���ַ����ĳ���
        invoke  strlen, offset szStr1
        mov     nLen1, eax

        ; ���2���ַ����ĳ���
        invoke  strlen, offset szStr2
        mov     nLen2, eax

        ; ���Ƶ�1���ַ���szStr1������ַ���szStr��
        lea     esi, szStr1
        lea     edi, szStr
        mov     ecx, nLen1
        cld
        rep     movsb

        ; szStr��nPos֮��Ĳ����ַ�������ƶ�nLen2���ֽ�
        ; Ϊ��2���ַ�������λ��
        mov     ecx, nLen1
        sub     ecx, nPos
        lea     esi, szStr
        add     esi, nLen1
        dec     esi
        mov     edi, esi
        add     edi, nLen2
        std
        rep     movsb

        ; ���Ƶ�2���ַ���szStr2������ַ���szStr+nPos��
        inc     esi
        mov     edi, esi
        lea     esi, szStr2
        mov     ecx, nLen2
        cld
        rep     movsb

        invoke  printf, offset szFmt, offset szStr
        ret
end     start
