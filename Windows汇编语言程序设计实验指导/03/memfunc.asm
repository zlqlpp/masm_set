;�����嵥��memfunc.asm(�ڴ�鴦��)
.386
.model flat,stdcall
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
.data
szFmt   byte    'Array[%2d]=%4d', 0ah, 0
Array   dword   1, 2, 4, 8, 16, 16, 32, 64, 128, 512, 1024
.code
start:
;              +0   +4   +8  +12  +16  +20  +24  +28  +32  +36  +40
;Array  dword   1,   2,   4,   8,  16,  16,  32,  64, 128, 512,1024
        ; ���5��Ԫ����ǰ�ƶ�4���ֽ�, ��Ϊ:
;Array  dword   1,   2,   4,   8,  16,  32,  64, 128, 512,1024,1024

        mov     edi, offset Array+20       ; EDI��Ŀ�����ݿ���׵�ַ
        mov     esi, offset Array+24        ; ESI��Դ���ݿ���׵�ַ
        mov     ecx, 20         ; ���ݿ�ĳ���
        cld                     ; ��ַ�ɵ�����
        rep     movsb           ; ��������

;              +0   +4   +8  +12  +16  +20  +24  +28  +32  +36  +40
;Array  dword   1,   2,   4,   8,  16,  32,  64, 128, 512,1024,1024
;       ; ���2��Ԫ������ƶ�4���ֽ�
;Array  dword   1,   2,   4,   8,  16,  32,  64, 128, 512, 512,1024

        mov     edi, offset Array+36       ; EDI��Ŀ�����ݿ���׵�ַ
        mov     esi, offset Array+32        ; ESI��Դ���ݿ���׵�ַ
        mov     ecx, 8      ; ���ݿ�ĳ���
		std
        rep     movsb           ; ��������

;              +0   +4   +8  +12  +16  +20  +24  +28  +32  +36  +40
;Array  dword   1,   2,   4,   8,  16,  32,  64, 128, 512, 512,1024
;                                                     ^^ �滻Ϊ256
        mov     Array+32, 256

        lea     esi, Array      ; ESIָ������ĵ�1��Ԫ��
        xor     ebx, ebx        ; EBXΪ�����±�i
        cld                     ; ��ַ�ɵ�����
f20:    
        lodsd                   ; ȡ��1��Ԫ����AX, ESI��4. 
                                ; printf(szFmt, i, Array[i]);
        invoke  printf, offset szFmt, ebx, eax
        inc     ebx             ; �����±��1
        cmp     ebx, 11         ; �����й���11��Ԫ��, ����±�=10
        jb      f20             ; ����������һ��Ԫ��
        ret
end     start
