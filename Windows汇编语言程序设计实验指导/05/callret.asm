;�����嵥��callret.asm(�ӳ���ĵ����뷵��)
.386
.model flat,stdcall
option casemap:none
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
.data
szFmt           byte    '%d + %d = %d', 0ah, 0 ;��������ʽ�ַ���
X               dword   ?
Y               dword   ?
Z               dword   ?
.code
AddProc1        proc                            ; ʹ�üĴ�����Ϊ����
                mov     eax, esi                ; EAX = ESI + EDI
                add     eax, edi
                ret
AddProc1        endp
AddProc2        proc                            ; ʹ�ñ�����Ϊ����
                push    eax                     ; ����EAX��ֵ
                mov     eax, X
                add     eax, Y
                mov     Z, eax                  ; Z = X + Y
                pop     eax                     ; �ָ�EAX��ֵ
                ret
AddProc2        endp
start:          
                mov     esi, 10                 ; 
                mov     edi, 20                 ; Ϊ�ӳ���׼������
                call    AddProc1                ; �����ӳ���
                                                ; �����EAX��
                mov     X, 50                   ; 
                mov     Y, 60                   ; Ϊ�ӳ���׼������
                call    AddProc2                ; �����ӳ���
                                                ; �����Z��
                invoke  printf, offset szFmt, 
                        esi, edi, eax           ; ��ʾ��1�μӷ����
                invoke  printf, offset szFmt, 
                        X, Y, Z                 ; ��ʾ��2�μӷ����
                ret
end             start
