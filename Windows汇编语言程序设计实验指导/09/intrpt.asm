;�����嵥: intrpt.asm(������ʽ�µ��жϴ������)
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

;���������ṹ���Ͷ���
Gate            STRUC
OffsetL         DW      0 ;32λƫ�Ƶĵ�16λ
Selector        DW      0 ;ѡ���
DCount          DB      0 ;˫�ּ���
GType           DB      0 ;����
OffsetH         DW      0 ;32λƫ�Ƶĸ�16λ
Gate            ENDS

;�洢������������ֵ˵��
ATDR            EQU     90h ;���ڵ�ֻ�����ݶ�����ֵ
ATDW            EQU     92h ;���ڵĿɶ�д���ݶ�����ֵ
ATDWA           EQU     93h ;���ڵ��ѷ��ʿɶ�д���ݶ�����ֵ
ATCE            EQU     98h ;���ڵ�ִֻ�д��������ֵ
ATCER           EQU     9ah ;���ڵĿ�ִ�пɶ����������ֵ
ATCCO           EQU     9ch ;���ڵ�ִֻ��һ�´��������ֵ
ATCCOR          EQU     9eh ;���ڵĿ�ִ�пɶ�һ�´��������ֵ
DA_386IGate EQU 8Eh ;386 �ж�������ֵ

DSEG            SEGMENT USE16         ;16λ���ݶ�

GDT             LABEL   BYTE          ;ȫ����������
DUMMY           Desc    <>            ;��������
Code            Desc    <0ffffh,,,ATCER,,>    ;�����������
DataV           Desc    <0ffffh,,,ATDW,,>     ;���ݶ�����������Ļ��������
DataP           Desc    <0ffffh,,,ATDWA,,>    ;���ݶ�������
Code32          Desc    <0ffffh,,,ATCER,40h,> ;�����������

GDTLen          =       $-GDT         ;ȫ������������
VGDTR           PDesc   <GDTLen-1,>           ;α������

; IDT
ALIGN 32
IDT             LABEL   BYTE
IDT_00_1F Gate 32 dup (<offset SpuriousHandler,Code32_Sel,0,DA_386IGate,0>)
IDT_20    Gate 1  dup (<offset IRQ0Handler,Code32_Sel,0,DA_386IGate,0>)
IDT_21    Gate 1  dup (<offset IRQ1Handler,Code32_Sel,0,DA_386IGate,0>)
IDT_22_7F Gate 94 dup (<offset SpuriousHandler,Code32_Sel,0,DA_386IGate,0>)
IDT_80    Gate 1  dup (<offset UserIntHandler,Code32_Sel,0,DA_386IGate,0>)

IDTLen          =       $-IDT         ;�ж�����������
VIDTR           PDesc   <IDTLen-1,>   ;α������

_SavedSP        dw      0
_SavedSS        dw      0
_SavedIDTR      dd      0       ; ���ڱ��� IDTR
                dd      0
                
DSEG            ENDS            ;���ݶζ������

PSEG            SEGMENT PARA STACK      ;����ģʽ��ʹ�õ����ݶ�
                db      512 dup (0)
TopOfStack      LABEL   BYTE

inkey           db      0
_tmp            db      0                

_SavedIMREG_M   db      0           ; �ж����μĴ���ֵ
_SavedIMREG_S   db      0           ; 
PSEG            ENDS

SSEG            SEGMENT PARA STACK      ;16λ��ջ��
                DB      512 DUP (0)
SSEG            ENDS                    ;��ջ�ζ������

Code_Sel        =       Code-GDT        ;16λ�����ѡ���
DataV_Sel       =       DataV-GDT       ;��Ļ���������ݶ�ѡ���
DataP_Sel       =       DataP-GDT       ;PSEG���ݶ�ѡ���
Code32_Sel      =       Code32-GDT      ;32λ����ζ�ѡ���

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

;16λƫ�ƵĶμ�ֱ��ת��ָ��ĺ궨��(��16λ�������ʹ��)
JUMP16  MACRO   Selector,Offset
        DB      0eah     ;������
        DW      Offset   ;16λƫ����
        DW      Selector ;��ֵ���ѡ���
        ENDM

CSEG    SEGMENT USE16         ;16λ�����
        ASSUME  CS:CSEG,DS:DSEG

Start   PROC
        mov     ax,DSEG
        mov     ds,ax
        mov     _SavedSP,ss
        mov     _SavedSS,sp

        ;׼��Ҫ���ص�GDTR��α������
        mov     bx,16
        mul     bx
        add     ax,OFFSET GDT           ;���㲢���û���ַ
        adc     dx,0                    ;�������ڶ���ʱ���ú�
        mov     WORD PTR VGDTR.Base,ax
        mov     WORD PTR VGDTR.Base+2,dx

        ;׼��Ҫ���ص�IDTR��α������
        mov     ax,SEG IDT
        mov     bx,16
        mul     bx
        add     ax,OFFSET IDT           ;���㲢���û���ַ
        adc     dx,0                    ;�������ڶ���ʱ���ú�
        mov     WORD PTR VIDTR.Base,ax
        mov     WORD PTR VIDTR.Base+2,dx

        ;���ô����������
        mov     ax,cs
        mul     bx
        mov     WORD PTR Code.BaseL,ax  ;����ο�ʼƫ��Ϊ0
        mov     BYTE PTR Code.BaseM,dl  ;����ν������ڶ���ʱ���ú�
        mov     BYTE PTR Code.BaseH,dh

        ;���ô������������32λ����Σ�
        mov     ax,seg SpuriousHandler
        mul     bx
        mov     WORD PTR Code32.BaseL,ax ;����ο�ʼƫ��Ϊ0
        mov     BYTE PTR Code32.BaseM,dl ;����ν������ڶ���ʱ���ú�
        mov     BYTE PTR Code32.BaseH,dh

        ;�������ݶ�����������Ļ��ʾ��������
        mov     ax,8000h
        mov     dx,000BH
        mov     WORD PTR DataV.BaseL,ax
        mov     BYTE PTR DataV.BaseM,dl
        mov     BYTE PTR DataV.BaseH,dh

        ;�������ݶ�������������ģʽ��ʹ�õ����ݶΣ�
        mov     ax,PSEG
        mul     bx             ;���㲢�������ݶλ�ַ
        mov     WORD PTR DataP.BaseL,ax
        mov     BYTE PTR DataP.BaseM,dl
        mov     BYTE PTR DataP.BaseH,dh

        ; ���� IDTR
        sidt    QWORD PTR _SavedIDTR

        ;����GDTR
        lgdt    QWORD PTR VGDTR
        cli                    ;���ж�
        EnableA20              ;�򿪵�ַ��A20

        lidt    QWORD PTR VIDTR
        
        ;�л���������ʽ
        mov     eax,cr0
        or      eax,1
        mov     cr0,eax
        ;��ָ��Ԥȡ����,���������뱣����ʽ
        JUMP16  Code_Sel,<OFFSET Virtual>

ALIGN 32
Virtual:        ;���ڿ�ʼ�ڱ�����ʽ������
        mov     ax,DataV_Sel
        mov     gs,ax          ;GSָ����Ļ��ʾ������
        mov     ax,DataP_Sel
        mov     ds,ax          ;DSָ��PSEG
        mov     ss,ax          ;SSָ��PSEG
        mov     sp,offset TopOfStack
        
        ; �����ж����μĴ���(IMREG)ֵ
        in      al,21h
        mov     _SavedIMREG_M,al
        
        in      al,0A1h
        mov     _SavedIMREG_S,al

        call    Init8259A

        int     080h
        
        sti
WaitLoop:
        mov     al,inkey
        mov     _tmp,al   
        cmp     _tmp,1
        jnz     WaitLoop
        
        cli

        call    SetRealmode8259A

        ;�л���ʵģʽ
        mov     eax,cr0
        and     al,11111110b
        mov     cr0,eax
        ;��ָ��Ԥȡ����,����ʵ��ʽ
        JUMP16  <SEG Real>,<OFFSET Real>

Init8259A:
        mov     al,011h
        out     020h,al    ; ��8259,ICW1.
        call    io_delay
            
        out     0A0h,al    ; ��8259,ICW1.
        call    io_delay
            
        mov     al,020h    ; IRQ0 ��Ӧ�ж����� 0x20
        out     021h,al    ; ��8259,ICW2.
        call    io_delay
            
        mov     al,028h    ; IRQ8 ��Ӧ�ж����� 0x28
        out     0A1h,al    ; ��8259,ICW2.
        call    io_delay
            
        mov     al,004h    ; IR2 ��Ӧ��8259
        out     021h,al    ; ��8259,ICW3.
        call    io_delay
            
        mov     al,002h    ; ��Ӧ��8259�� IR2
        out     0A1h,al    ; ��8259,ICW3.
        call    io_delay
            
        mov     al,001h
        out     021h,al    ; ��8259,ICW4.
        call    io_delay
            
        out     0A1h,al    ; ��8259,ICW4.
        call    io_delay
            
        mov     al,11111100b   ; ����������ʱ���������ж�
        out     021h,al        ; ��8259,OCW1.
        call    io_delay
            
        mov     al,11111111b   ; ���δ�8259�����ж�
        out     0A1h,al        ; ��8259,OCW1.
        call    io_delay
            
        ret
        
SetRealmode8259A:
        mov     al,011h
        out     020h,al    ; ��8259,ICW1.
        call    io_delay
            
        out     0A0h,al    ; ��8259,ICW1.
        call    io_delay
            
        mov     al,08h     ; IRQ0 ��Ӧ�ж����� 0x20
        out     021h,al    ; ��8259,ICW2.
        call    io_delay
            
        mov     al,70h     ; IRQ8 ��Ӧ�ж����� 0x28
        out     0A1h,al    ; ��8259,ICW2.
        call    io_delay
            
        mov     al,004h    ; IR2 ��Ӧ��8259
        out     021h,al    ; ��8259,ICW3.
        call    io_delay
            
        mov     al,002h    ; ��Ӧ��8259�� IR2
        out     0A1h,al    ; ��8259,ICW3.
        call    io_delay
            
        mov     al,001h
        out     021h,al    ; ��8259,ICW4.
        call    io_delay
            
        out     0A1h,al    ; ��8259,ICW4.
        call    io_delay
            
        mov     al,_SavedIMREG_M      ; �ָ��ж����μĴ���(IMREG)��ԭֵ
        out     021h,al        ; 
        call    io_delay

        mov     al,_SavedIMREG_S      ; �ָ��ж����μĴ���(IMREG)��ԭֵ
        out     0A1h,al        ; 
        call    io_delay

        ret
        
io_delay:
        nop
        nop
        nop
        nop
        ret
        
Real:           ;�����ֻص�ʵ��ʽ
        DisableA20

        mov     ax,DSEG
        mov     ds,ax
        mov     ss,_SavedSP
        mov     sp,_SavedSS

        lidt    QWORD PTR _SavedIDTR

        sti

        mov     ax,4c00h
        int     21h
Start   ENDP

CSEG    ENDS                   ;����ζ������

CSEG32  SEGMENT USE32
        ASSUME CS:CSEG32,DS:PSEG
IRQ0Handler:
        inc     byte ptr gs:[((80 * 0 + 70) * 2)] ; ��Ļ�� 0 ��,�� 70 �С�
        mov     al,20h
        out     20h,al                            ; ����EOI����8259
        iretd

IRQ1Handler:
        in      al,60h
        mov     inkey,al
        inc     byte ptr gs:[((80 * 1 + 70) * 2)] ; ��Ļ�� 1 ��,�� 70 �С�
        mov     al,20h
        out     20h,al                            ; ����EOI����8259
        iretd

UserIntHandler:
        mov     ah,0Ch                            ; 0000 �ڵ� 1100 ����
        mov     al,'I'
        mov     gs:[((80 * 2 + 70) * 2)],ax       ; ��Ļ�� 2 ��,�� 70 �С�
        iretd

SpuriousHandler:
        iretd
CSEG32  ENDS
        END     Start
