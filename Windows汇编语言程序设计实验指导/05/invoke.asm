;�����嵥��invoke.asm(invokeαָ��)
.386
.model flat,stdcall
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
.data
szFmt           byte    '%d - %d = %d', 0ah, 0  ;��������ʽ�ַ���
.code
SubProc1        proc    c  a:dword, b:dword     ; ʹ�ö�ջ���ݲ���, C����
                mov     eax, a                  ; ȡ����1������
                sub     eax, b                  ; ȡ����2������
                ret                             ;
SubProc1        endp
SubProc2        proc    stdcall a:dword, b:dword; ʹ�ö�ջ���ݲ���, stdcall����
                mov     eax, a                  ; ȡ����1������
                sub     eax, b                  ; ȡ����2������
                ret                             ;
SubProc2        endp
start:
                invoke  SubProc1, 100, 40       ; ����SubProc1
                invoke  printf, offset szFmt, 
                        100, 40, eax            ; ��ʾ��1�μ������
                invoke  SubProc2, 200, 5        ; ����SubProc2
                invoke  printf, offset szFmt, 
                        200, 5, eax             ; ��ʾ��2�μ������
                ret
end             start
