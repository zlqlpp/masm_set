;�����嵥: real2pro.asm(ʵģʽ�뱣��ģʽ֮����л�)
.386P
;�洢���������ṹ���Ͷ���
Desc            STRUC
LimitL          DW      0 ;�ν���(BIT0-15)
BaseL           DW      0 ;�λ���ַ(BIT0-15)
BaseM           DB      0 ;�λ���ַ(BIT16-23)
Attributes      DB      0 ;������
LimitH          DB      0 ;�ν���(BIT16-19)(�������Եĸ�4λ)
BaseH           DB      0 ;�λ���ַ(BIT24-31)
Desc            ENDS

;α�������ṹ���Ͷ���(����װ��ȫ�ֻ��ж���������Ĵ���)
PDesc           STRUC
Limit           DW      0 ;16λ����
Base            DD      0 ;32λ����ַ
PDesc           ENDS

;�洢������������ֵ˵��
ATDR            EQU     90h ;���ڵ�ֻ�����ݶ�����ֵ
ATDW            EQU     92h ;���ڵĿɶ�д���ݶ�����ֵ
ATDWA           EQU     93h ;���ڵ��ѷ��ʿɶ�д���ݶ�����ֵ
ATCE            EQU     98h ;���ڵ�ִֻ�д��������ֵ
ATCER           EQU     9ah ;���ڵĿ�ִ�пɶ����������ֵ
ATCCO           EQU     9ch ;���ڵ�ִֻ��һ�´��������ֵ
ATCCOR          EQU     9eh ;���ڵĿ�ִ�пɶ�һ�´��������ֵ

DSEG            SEGMENT USE16                 ;16λ���ݶ�
GDT             LABEL   BYTE                  ;ȫ����������
DUMMY           Desc    <>                    ;��������
Code            Desc    <0ffffh,,,ATCE,,>     ;�����������
DataD           Desc    <0ffffh,0,,ATDW,,>    ;Դ���ݶ�������
DataE           Desc    <0ffffh,,,ATDW,,>     ;Ŀ�����ݶ�������
GDTLen          =       $-GDT                 ;ȫ������������
VGDTR           PDesc   <GDTLen-1,>           ;α������
Code_Sel        =       Code-GDT              ;�����ѡ����
DataD_Sel       =       DataD-GDT             ;Դ���ݶ�ѡ����
DataE_Sel       =       DataE-GDT             ;Ŀ�����ݶ�ѡ����
BufLen          =       64                    ;�������ֽڳ���
Buffer          DB      BufLen DUP(55h)       ;������
DSEG            ENDS                          ;���ݶζ������

ESEG            SEGMENT USE16                 ;16λ���ݶ�
Buffer2         DB      BufLen DUP(0)         ;������
ESEG            ENDS                          ;���ݶζ������

SSEG            SEGMENT PARA STACK            ;16λ��ջ��
                DB      512 DUP (0)
SSEG            ENDS                          ;��ջ�ζ������

;��A20��ַ��
EnableA20       MACRO
                push    ax
                in      al,92h
                or      al,00000010b
                out     92h,al
                pop     ax
                ENDM

;�ر�A20��ַ��
DisableA20      MACRO
                push    ax
                in      al,92h
                and     al,11111101b
                out     92h,al
                pop     ax
                ENDM

;�ַ���ʾ��ָ��Ķ���
EchoCh          MACRO   ascii
                mov     ah,2
                mov     dl,ascii
                int     21h
                ENDM

;16λƫ�ƵĶμ�ֱ��ת��ָ��ĺ궨��(��16λ�������ʹ��)
JUMP16          MACRO   Selector,Offset
                DB      0eah     ;������
                DW      Offset   ;16λƫ����
                DW      Selector ;��ֵ���ѡ����
                ENDM

CSEG            SEGMENT USE16                 ;16λ�����
                ASSUME  CS:CSEG,DS:DSEG
Start           PROC
                mov     ax,DSEG
                mov     ds,ax
                ;׼��Ҫ���ص�GDTR��α������
                mov     bx,16
                mul     bx
                add     ax,OFFSET GDT          ;���㲢���û���ַ
                adc     dx,0                   ;�������ڶ���ʱ���ú�
                mov     WORD PTR VGDTR.Base,ax
                mov     WORD PTR VGDTR.Base+2,dx
                ;���ô����������
                mov     ax,cs
                mul     bx
                mov     WORD PTR Code.BaseL,ax ;����ο�ʼƫ��Ϊ0
                mov     BYTE PTR Code.BaseM,dl ;����ν������ڶ���ʱ���ú�
                mov     BYTE PTR Code.BaseH,dh
                ;����Դ���ݶ�������
                mov     ax,ds
                mul     bx
                mov     WORD PTR DataD.BaseL,ax
                mov     BYTE PTR DataD.BaseM,dl
                mov     BYTE PTR DataD.BaseH,dh
                ;����Ŀ�����ݶ�������
                mov     ax,ESEG
                mul     bx
                mov     WORD PTR DataE.BaseL,ax
                mov     BYTE PTR DataE.BaseM,dl
                mov     BYTE PTR DataE.BaseH,dh
                ;����GDTR
                lgdt    QWORD PTR VGDTR
                cli                            ;���ж�
                EnableA20                      ;�򿪵�ַ��A20
                
                ;�л���������ʽ
                mov     eax,cr0
                or      eax,1
                mov     cr0,eax
                
                ;��ָ��Ԥȡ����,���������뱣����ʽ
                JUMP16  Code_Sel,<OFFSET Virtual>
Virtual:        
                ;���ڿ�ʼ�ڱ�����ʽ������
                mov     ax,DataD_Sel
                mov     ds,ax                  ;����Դ���ݶ�������
                mov     ax,DataE_Sel
                mov     es,ax                  ;����Ŀ�����ݶ�������
                cld
                lea     esi,Buffer
                lea     edi,Buffer2            ;����ָ���ֵ
                mov     ecx,BufLen/4           ;���ô��ʹ���
                repz    movsd                  ;����
                
                ;�л���ʵģʽ
                mov     eax,cr0
                and     al,11111110b
                mov     cr0,eax
                
                ;��ָ��Ԥȡ����,����ʵ��ʽ
                JUMP16  <SEG Real>,<OFFSET Real>
Real:           
                ;�����ֻص�ʵ��ʽ
                DisableA20
                sti

                mov     ax,DSEG
                mov     ds,ax
                mov     ax,ESEG
                mov     es,ax
                
                mov     di,OFFSET Buffer2
                cld
                mov     bp,BufLen/16
NextLine:       mov     cx,16
NextCh:         mov     al, es:[di]
                inc     di
                push    ax
                shr     al,4
                call    ToASCII
                EchoCh  al
                pop     ax
                call    ToASCII
                EchoCh  al
                EchoCh  ' '
                loop    NextCh
                EchoCh  0dh
                EchoCh  0ah
                dec     bp
                jnz     NextLine

                mov     ax,4c00h
                int     21h
Start           ENDP

ToASCII         PROC
                and     al,0fh
                cmp     al,10
                jae     Over10
                add     al,'0'
                ret
Over10:
                add     al,'A'-10
                ret
ToASCII         ENDP

CSEG            ENDS                           ;����ν���
                END     Start
