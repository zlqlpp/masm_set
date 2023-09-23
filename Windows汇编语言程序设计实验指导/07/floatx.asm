;�����嵥: floatx.asm(SSE�����ȸ������˷�)
.686                            ; ����д��686�ſ���֧��SSE
.xmm                            ; ʹ��XMM�Ĵ���
.model flat,stdcall
option casemap:none
includelib      msvcrt.lib
printf          PROTO C format:ptr sbyte,:vararg
.data
align 16                                ; ����16�ֽڶ���
aArray  real4   100h dup(2.0)           ; ��1�����飬��256��Ԫ��, �����ȸ�ʽ
bArray  real4   100h dup(3.0)           ; ��2�����飬��256��Ԫ��, �����ȸ�ʽ
cArray  real4   100h dup(0.0)           ; ���, �����ȸ�ʽ, ÿ��Ԫ��ռ4�ֽ�
result  real8   0.0                     ; ˫���ȸ�����, ռ8�ֽ�
nIndex  equ     20
szFmt   byte    'cArray[%d]=%8.3f',0ah,0
.code                        
start:
        lea     esi,aArray              ; esiָ���1������
        lea     edi,bArray              ; ediָ���2������
        lea     edx,cArray              ; edxָ���3������
        mov     ecx,100h/4              ; ѭ��64�Σ�ÿ�οɼ���4��Ԫ��
Calx: 
        movaps  XMM0,[esi]              ; װ���1�������4��Ԫ�ص�XMM0
        movaps  XMM1,[edi]              ; װ���2�������4��Ԫ�ص�XMM1
        mulps   XMM0,XMM1               ; XMM0��XMM1�е�4��Ԫ�طֱ����
        movaps  [edx],XMM0              ; ��������cArray��
        add     edi,16                  ; ָ��aArray����һ��Ԫ��
        add     esi,16                  ; ָ��bArray����һ��Ԫ��
        add     edx,16                  ; ָ��cArray����һ��Ԫ��
        loop    Calx
        
        mov     esi,nIndex              ; nIndex=10
        FLD     cArray[esi*4]           ; ��cArray[20]ת��Ϊ˫���ȸ�����
        FSTP    result                  ; ˫���ȸ�����������result��
        invoke  printf,offset szFmt,esi,result
        ret
end     start

; ml /coff floatx.asm /link /subsystem:console