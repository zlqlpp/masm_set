;�����嵥��split.asm(�۰�����㷨)
.386
.model flat,stdcall
option casemap:none
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
.data
dArray          dword   50, 78, 99, 200, 451, 680, 718, 820, 1000, 2000
ITEMS           equ     ($-dArray)/4    ; ������Ԫ�صĸ���
Element         dword   680             ; �������в��ҵ�����
Index           dword   ?               ; �������е����
Count           dword   ?               ; ���ҵĴ���
szFmt           byte    'Index=%d Count=%d Element=%d', 0ah, 0 ; ��ʽ�ַ���
szErrMsg        byte    'Not found, Count=%d Element=%d', 0ah, 0 
.code
start:
                mov     Index, -1               ; ����ֵ, �����Ҳ���
                mov     Count, 0                ; ����ֵ, ���Ҵ���Ϊ0
                mov     ecx, 0                  ; ECX��ʾ���ҷ�Χ���½�
                mov     edx, ITEMS-1            ; EDX��ʾ���ҷ�Χ���Ͻ�
                mov     eax, Element            ; EAX��Ҫ�������в��ҵ�����
b10:            
                cmp     ecx, edx                ; �½��Ƿ񳬹��Ͻ�
                jg      b40                     ; ����½糬���Ͻ�, δ�ҵ�
                mov     esi, ecx                ; ȡ�½���Ͻ���е�
                add     esi, edx                ; ESI=(ECX+EDX)
                shr     esi, 1                  ; ESI=(ECX+EDX)/2
                inc     Count                   ; ���Ҵ�����1
                cmp     eax, dArray[esi*4]      ; ���е��ϵ�Ԫ�رȽ�
                jz      b30                     ; ���, ���ҽ���
                jg      b20                     ; �ϴ�, �ƶ��½�
                mov     edx, esi                ; ��С, �ƶ��Ͻ�
                dec     edx                     ; ESIԪ���ѱȽϹ�, ���ٱȽ�
                jmp     b10                     ; ��Χ��С��, ��������
b20:            
                mov     ecx, esi                ; �ϴ�, �ƶ��½�
                inc     ecx                     ; ESIԪ���ѱȽϹ�, ���ٱȽ�
                jmp     b10                     ; ��Χ��С��, ��������
b30:            
                mov     Index, esi              ; �ҵ�, ESI���±�
                ; printf("Index=%d Count=%d Element=%d\n", 
                ;         Index, Count, dArray[Index]);
                invoke  printf, offset szFmt, Index, Count, dArray[esi*4]
                jmp     b50
b40:            
                ; printf("Not found, Count=%d Element=%d\n", Count, Element);
                invoke  printf, offset szErrMsg, Count, Element 
b50:            
                ret
end             start
