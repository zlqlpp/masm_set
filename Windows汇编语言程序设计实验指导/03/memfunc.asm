;程序清单：memfunc.asm(内存块处理)
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
        ; 最后5个元素向前移动4个字节, 变为:
;Array  dword   1,   2,   4,   8,  16,  32,  64, 128, 512,1024,1024

        mov     edi, offset Array+20       ; EDI是目标数据块的首地址
        mov     esi, offset Array+24        ; ESI是源数据块的首地址
        mov     ecx, 20         ; 数据块的长度
        cld                     ; 地址由低至高
        rep     movsb           ; 传送数据

;              +0   +4   +8  +12  +16  +20  +24  +28  +32  +36  +40
;Array  dword   1,   2,   4,   8,  16,  32,  64, 128, 512,1024,1024
;       ; 最后2个元素向后移动4个字节
;Array  dword   1,   2,   4,   8,  16,  32,  64, 128, 512, 512,1024

        mov     edi, offset Array+36       ; EDI是目标数据块的首地址
        mov     esi, offset Array+32        ; ESI是源数据块的首地址
        mov     ecx, 8      ; 数据块的长度
		std
        rep     movsb           ; 传送数据

;              +0   +4   +8  +12  +16  +20  +24  +28  +32  +36  +40
;Array  dword   1,   2,   4,   8,  16,  32,  64, 128, 512, 512,1024
;                                                     ^^ 替换为256
        mov     Array+32, 256

        lea     esi, Array      ; ESI指向数组的第1个元素
        xor     ebx, ebx        ; EBX为数组下标i
        cld                     ; 地址由低至高
f20:    
        lodsd                   ; 取出1个元素至AX, ESI加4. 
                                ; printf(szFmt, i, Array[i]);
        invoke  printf, offset szFmt, ebx, eax
        inc     ebx             ; 数组下标加1
        cmp     ebx, 11         ; 数组中共有11个元素, 最大下标=10
        jb      f20             ; 继续处理下一个元素
        ret
end     start
