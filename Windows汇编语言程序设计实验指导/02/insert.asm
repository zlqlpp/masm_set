;�����嵥��insert.asm(���������㷨)
.386
.model flat,stdcall
option casemap:none
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
.data
dArray          dword   50, 78, 99, 200, 451, 680, 718, 820, 1000, 2000
ITEMS           equ     ($-dArray)/4    ; ������Ԫ�صĸ���
                dword   ?    ; ����һ��Ԫ�غ�,dArrayҪ�ӳ�,Ҫռ�����˫��
Element         dword   500             ; Ҫ�������������
szFmt           byte    'dArray[%d]=%d', 0ah, 0 ; ��������ʽ�ַ���
.code
start:
                mov     eax, Element            ; EAX��Ҫ�������в��������
                mov     esi, 0                  ; ESI��Ҫ�Ƚϵ�Ԫ�ص��±�
c10:            
                cmp     dArray[esi*4], eax      ; �Ƚ�����Ԫ�غ�Ҫ�������
                ja      c20                     ; �����е�Ԫ�ؽϴ�,���ٱȽ�
                                                
                inc     esi                     ; �±��1
                cmp     esi, ITEMS              ; �Ƿ�����Ԫ��ȫ���ѱȽϹ�
                jb      c10                     ; û��,�����Ƚ�
                                                ; ȫ���ȽϹ�,��ESI=ITEMS
c20:            ; ����λ��ΪESI, ������β��ʼ�ƶ�
                mov     edi, ITEMS-1            ; EDI��Ҫ�ƶ���Ԫ���±�
c30:            
                cmp     edi, esi                ; EDI��ESI�Ƚ�
                jl      c40                     ; EDI<ESI, ���ƶ����
                mov     ebx, dArray[edi*4]      ; ��ȡ�����Ԫ��
                mov     dArray[edi*4+4], ebx    ; ����ƶ�1��λ��
                dec     edi                     ; EDIָ����һ��Ԫ��
                jmp     c30                     ; �����ƶ�
c40:            
                mov     dArray[esi*4], eax      ; ����Ԫ�ص��±�ΪESI��λ��
                xor     edi, edi                ; ��ʾ����Ԫ�ص�ֵ
c50:            
                invoke  printf, offset szFmt, edi, dArray[edi*4] ; ��ʾ
                inc     edi                     ; EDI�±��1
                cmp     edi, ITEMS              ; �Ƿ���ȫ����ʾ��
                jbe     c50                     ; ������ʾ
                ret
end             start
