;�����嵥��delete.asm(ɾ������Ԫ��)
.386
.model flat,stdcall
option casemap:none
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
scanf           PROTO C :dword,:vararg
.data
dArray          dword   850, 7, 39, 200, 13, 60, 47, 0, 600, 240
nItems          dword   ($-dArray)/4    ; ������Ԫ�صĸ���
Element         dword   ?               ; Ҫɾ����Ԫ��
szFmt           byte    'dArray[%d]=%d', 0ah, 0 ; ��������ʽ�ַ���
dElement        dword   ?
szPrompt        byte    'Input the element to delete: ', 0   ; ��ʾ�ַ���
szScanfIn       byte    '%d', 0
szNotFound      byte    '%d is not found.', 0
.code
start:
                invoke  printf, offset szPrompt
                invoke  scanf, offset szScanfIn, offset Element

                mov     eax, Element            ; EAX��Ҫ��������ɾ����Ԫ��
                mov     esi, 0                  ; ESI��Ҫ�Ƚϵ�Ԫ�ص��±�
c10:            
                cmp     dArray[esi*4], eax      ; �Ƿ�Ҫɾ����
                jz      c20                     ; ��ȣ�ɾ��֮
                                                
                inc     esi                     ; �±��1
                cmp     esi, nItems             ; �Ƿ�����Ԫ��ȫ���ѱȽϹ�
                jb      c10                     ; û��,�����Ƚ�

                invoke  printf, offset szNotFound, Element

                jmp     c40                     ; ȫ���ȽϹ�, û���ҵ�
                                                
c20:
                dec     nItems
                mov     edi, esi                ; EDI�Ǳ����ǵ�Ԫ���±�
c30:            
                cmp     edi, nItems             ; EDI��nItems�Ƚ�
                jae     c40                     ; EDI>=nItems, ���ƶ����
                mov     ebx, dArray[edi*4+4]    ; ��ȡ����һ��Ԫ��
                mov     dArray[edi*4], ebx      ; ��ǰ�ƶ�1��λ��
                inc     edi                     ; EDIָ����һ��Ԫ��
                jmp     c30                     ; �����ƶ�
c40:
                xor     edi, edi                ; ��ʾ����Ԫ�ص�ֵ
c50:            
                invoke  printf, offset szFmt, edi, dArray[edi*4] ; ��ʾ
                inc     edi                     ; EDI�±��1
                cmp     edi, nItems             ; �Ƿ���ȫ����ʾ��
                jb      c50                     ; ������ʾ
                ret
end             start
