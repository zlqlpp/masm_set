;程序清单: floatx.asm(SSE单精度浮点数乘法)
.686                            ; 必须写成686才可以支持SSE
.xmm                            ; 使用XMM寄存器
.model flat,stdcall
option casemap:none
includelib      msvcrt.lib
printf          PROTO C format:ptr sbyte,:vararg
.data
align 16                                ; 按照16字节对齐
aArray  real4   100h dup(2.0)           ; 第1个数组，共256个元素, 单精度格式
bArray  real4   100h dup(3.0)           ; 第2个数组，共256个元素, 单精度格式
cArray  real4   100h dup(0.0)           ; 结果, 单精度格式, 每个元素占4字节
result  real8   0.0                     ; 双精度浮点数, 占8字节
nIndex  equ     20
szFmt   byte    'cArray[%d]=%8.3f',0ah,0
.code                        
start:
        lea     esi,aArray              ; esi指向第1个数组
        lea     edi,bArray              ; edi指向第2个数组
        lea     edx,cArray              ; edx指向第3个数组
        mov     ecx,100h/4              ; 循环64次，每次可计算4个元素
Calx: 
        movaps  XMM0,[esi]              ; 装入第1个数组的4个元素到XMM0
        movaps  XMM1,[edi]              ; 装入第2个数组的4个元素到XMM1
        mulps   XMM0,XMM1               ; XMM0、XMM1中的4个元素分别相乘
        movaps  [edx],XMM0              ; 保存结果到cArray中
        add     edi,16                  ; 指向aArray的下一组元素
        add     esi,16                  ; 指向bArray的下一组元素
        add     edx,16                  ; 指向cArray的下一组元素
        loop    Calx
        
        mov     esi,nIndex              ; nIndex=10
        FLD     cArray[esi*4]           ; 将cArray[20]转换为双精度浮点数
        FSTP    result                  ; 双精度浮点数保存在result中
        invoke  printf,offset szFmt,esi,result
        ret
end     start

; ml /coff floatx.asm /link /subsystem:console