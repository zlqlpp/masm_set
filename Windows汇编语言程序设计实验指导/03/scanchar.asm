;�����嵥��scanchar.asm(�ַ�ɨ�����滻)
.386
.model flat,stdcall
option casemap:none
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
time            PROTO C :dword
.data
szStr   byte    'How do you do!', 0
nLen    dword   0               ; �ַ�������
szLen   byte    0ah, 'nLen = %d', 0ah, 0
.code
start:
        lea     edi, szStr      ; ָ��Ŀ���ַ���
        mov     al, 0
        repnz   scasb           ; ZF=1��ֹͣɨ��
        sub     edi, offset szStr
        mov     nLen, edi

        lea     edi, szStr      ; ָ��Ŀ���ַ���
        mov     ecx, nLen       ; szStrռ15���ֽ�
        cld                     ; ��ַ�ɵ�����
        mov     al, 'o'
        repnz   scasb           ; ZF=1��ֹͣɨ��
        jnz     c10

        mov     byte ptr [edi-1], 'O'   ; �滻��1��oΪO

c10:

        lea     edi, szStr      ; ָ��Ŀ���ַ���
        add     edi, nLen
        dec     edi             ; ָ�����1���ַ�'!'
        mov     ecx, nLen       ; szStrռ15���ֽ�
        std                     ; ��ַ�ɸ�����
        mov     al, ' '
        repnz   scasb           ; ZF=1��ֹͣɨ��
        jnz     c20

        mov     byte ptr [edi+1], '*'   ; �滻���1���ո�Ϊ*

c20:
        cld
        invoke  printf, offset szStr            ; ��ʾ�ַ���
        invoke  printf, offset szLen, nLen      ; ��ʾ�ַ�������
        ret
end     start

; �����������
; ml /coff scanchar.asm /link /subsystem:console