;程序清单: intrpt.asm(保护方式下的中断处理过程)
.386P
;存储段描述符结构类型定义
Desc            STRUC
LimitL          DW      0 ;段界限(BIT0-15)
BaseL           DW      0 ;段基地址(BIT0-15)
BaseM           DB      0 ;段基地址(BIT16-23)
Attributes      DB      0 ;段属性
LimitH          DB      0 ;段界限(BIT16-19)(含段属性的高4位)
BaseH           DB      0 ;段基地址(BIT24-31)
Desc            ENDS

;伪描述符结构类型定义(用于装入全局或中断描述符表寄存器)
PDesc           STRUC
Limit           DW      0 ;16位界限
Base            DD      0 ;32位基地址
PDesc           ENDS

;门描述符结构类型定义
Gate            STRUC
OffsetL         DW      0 ;32位偏移的低16位
Selector        DW      0 ;选择符
DCount          DB      0 ;双字计数
GType           DB      0 ;类型
OffsetH         DW      0 ;32位偏移的高16位
Gate            ENDS

;存储段描述符类型值说明
ATDR            EQU     90h ;存在的只读数据段类型值
ATDW            EQU     92h ;存在的可读写数据段属性值
ATDWA           EQU     93h ;存在的已访问可读写数据段类型值
ATCE            EQU     98h ;存在的只执行代码段属性值
ATCER           EQU     9ah ;存在的可执行可读代码段属性值
ATCCO           EQU     9ch ;存在的只执行一致代码段属性值
ATCCOR          EQU     9eh ;存在的可执行可读一致代码段属性值
DA_386IGate EQU 8Eh ;386 中断门类型值

DSEG            SEGMENT USE16         ;16位数据段

GDT             LABEL   BYTE          ;全局描述符表
DUMMY           Desc    <>            ;空描述符
Code            Desc    <0ffffh,,,ATCER,,>    ;代码段描述符
DataV           Desc    <0ffffh,,,ATDW,,>     ;数据段描述符（屏幕缓冲区）
DataP           Desc    <0ffffh,,,ATDWA,,>    ;数据段描述符
Code32          Desc    <0ffffh,,,ATCER,40h,> ;代码段描述符

GDTLen          =       $-GDT         ;全局描述符表长度
VGDTR           PDesc   <GDTLen-1,>           ;伪描述符

; IDT
ALIGN 32
IDT             LABEL   BYTE
IDT_00_1F Gate 32 dup (<offset SpuriousHandler,Code32_Sel,0,DA_386IGate,0>)
IDT_20    Gate 1  dup (<offset IRQ0Handler,Code32_Sel,0,DA_386IGate,0>)
IDT_21    Gate 1  dup (<offset IRQ1Handler,Code32_Sel,0,DA_386IGate,0>)
IDT_22_7F Gate 94 dup (<offset SpuriousHandler,Code32_Sel,0,DA_386IGate,0>)
IDT_80    Gate 1  dup (<offset UserIntHandler,Code32_Sel,0,DA_386IGate,0>)

IDTLen          =       $-IDT         ;中断描述符表长度
VIDTR           PDesc   <IDTLen-1,>   ;伪描述符

_SavedSP        dw      0
_SavedSS        dw      0
_SavedIDTR      dd      0       ; 用于保存 IDTR
                dd      0
                
DSEG            ENDS            ;数据段定义结束

PSEG            SEGMENT PARA STACK      ;保护模式下使用的数据段
                db      512 dup (0)
TopOfStack      LABEL   BYTE

inkey           db      0
_tmp            db      0                

_SavedIMREG_M   db      0           ; 中断屏蔽寄存器值
_SavedIMREG_S   db      0           ; 
PSEG            ENDS

SSEG            SEGMENT PARA STACK      ;16位堆栈段
                DB      512 DUP (0)
SSEG            ENDS                    ;堆栈段定义结束

Code_Sel        =       Code-GDT        ;16位代码段选择符
DataV_Sel       =       DataV-GDT       ;屏幕缓冲区数据段选择符
DataP_Sel       =       DataP-GDT       ;PSEG数据段选择符
Code32_Sel      =       Code32-GDT      ;32位代码段段选择符

;打开A20地址线
EnableA20       MACRO
        push    ax
        in      al,92h
        or      al,00000010b
        out     92h,al
        pop     ax
        ENDM

;关闭A20地址线
DisableA20      MACRO
        push    ax
        in      al,92h
        and     al,11111101b
        out     92h,al
        pop     ax
        ENDM

;16位偏移的段间直接转移指令的宏定义(在16位代码段中使用)
JUMP16  MACRO   Selector,Offset
        DB      0eah     ;操作码
        DW      Offset   ;16位偏移量
        DW      Selector ;段值或段选择符
        ENDM

CSEG    SEGMENT USE16         ;16位代码段
        ASSUME  CS:CSEG,DS:DSEG

Start   PROC
        mov     ax,DSEG
        mov     ds,ax
        mov     _SavedSP,ss
        mov     _SavedSS,sp

        ;准备要加载到GDTR的伪描述符
        mov     bx,16
        mul     bx
        add     ax,OFFSET GDT           ;计算并设置基地址
        adc     dx,0                    ;界限已在定义时设置好
        mov     WORD PTR VGDTR.Base,ax
        mov     WORD PTR VGDTR.Base+2,dx

        ;准备要加载到IDTR的伪描述符
        mov     ax,SEG IDT
        mov     bx,16
        mul     bx
        add     ax,OFFSET IDT           ;计算并设置基地址
        adc     dx,0                    ;界限已在定义时设置好
        mov     WORD PTR VIDTR.Base,ax
        mov     WORD PTR VIDTR.Base+2,dx

        ;设置代码段描述符
        mov     ax,cs
        mul     bx
        mov     WORD PTR Code.BaseL,ax  ;代码段开始偏移为0
        mov     BYTE PTR Code.BaseM,dl  ;代码段界限已在定义时设置好
        mov     BYTE PTR Code.BaseH,dh

        ;设置代码段描述符（32位代码段）
        mov     ax,seg SpuriousHandler
        mul     bx
        mov     WORD PTR Code32.BaseL,ax ;代码段开始偏移为0
        mov     BYTE PTR Code32.BaseM,dl ;代码段界限已在定义时设置好
        mov     BYTE PTR Code32.BaseH,dh

        ;设置数据段描述符（屏幕显示缓冲区）
        mov     ax,8000h
        mov     dx,000BH
        mov     WORD PTR DataV.BaseL,ax
        mov     BYTE PTR DataV.BaseM,dl
        mov     BYTE PTR DataV.BaseH,dh

        ;设置数据段描述符（保护模式下使用的数据段）
        mov     ax,PSEG
        mul     bx             ;计算并设置数据段基址
        mov     WORD PTR DataP.BaseL,ax
        mov     BYTE PTR DataP.BaseM,dl
        mov     BYTE PTR DataP.BaseH,dh

        ; 保存 IDTR
        sidt    QWORD PTR _SavedIDTR

        ;加载GDTR
        lgdt    QWORD PTR VGDTR
        cli                    ;关中断
        EnableA20              ;打开地址线A20

        lidt    QWORD PTR VIDTR
        
        ;切换到保护方式
        mov     eax,cr0
        or      eax,1
        mov     cr0,eax
        ;清指令预取队列,并真正进入保护方式
        JUMP16  Code_Sel,<OFFSET Virtual>

ALIGN 32
Virtual:        ;现在开始在保护方式下运行
        mov     ax,DataV_Sel
        mov     gs,ax          ;GS指向屏幕显示缓冲区
        mov     ax,DataP_Sel
        mov     ds,ax          ;DS指向PSEG
        mov     ss,ax          ;SS指向PSEG
        mov     sp,offset TopOfStack
        
        ; 保存中断屏蔽寄存器(IMREG)值
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

        ;切换回实模式
        mov     eax,cr0
        and     al,11111110b
        mov     cr0,eax
        ;清指令预取队列,进入实方式
        JUMP16  <SEG Real>,<OFFSET Real>

Init8259A:
        mov     al,011h
        out     020h,al    ; 主8259,ICW1.
        call    io_delay
            
        out     0A0h,al    ; 从8259,ICW1.
        call    io_delay
            
        mov     al,020h    ; IRQ0 对应中断向量 0x20
        out     021h,al    ; 主8259,ICW2.
        call    io_delay
            
        mov     al,028h    ; IRQ8 对应中断向量 0x28
        out     0A1h,al    ; 从8259,ICW2.
        call    io_delay
            
        mov     al,004h    ; IR2 对应从8259
        out     021h,al    ; 主8259,ICW3.
        call    io_delay
            
        mov     al,002h    ; 对应主8259的 IR2
        out     0A1h,al    ; 从8259,ICW3.
        call    io_delay
            
        mov     al,001h
        out     021h,al    ; 主8259,ICW4.
        call    io_delay
            
        out     0A1h,al    ; 从8259,ICW4.
        call    io_delay
            
        mov     al,11111100b   ; 仅仅开启定时器、键盘中断
        out     021h,al        ; 主8259,OCW1.
        call    io_delay
            
        mov     al,11111111b   ; 屏蔽从8259所有中断
        out     0A1h,al        ; 从8259,OCW1.
        call    io_delay
            
        ret
        
SetRealmode8259A:
        mov     al,011h
        out     020h,al    ; 主8259,ICW1.
        call    io_delay
            
        out     0A0h,al    ; 从8259,ICW1.
        call    io_delay
            
        mov     al,08h     ; IRQ0 对应中断向量 0x20
        out     021h,al    ; 主8259,ICW2.
        call    io_delay
            
        mov     al,70h     ; IRQ8 对应中断向量 0x28
        out     0A1h,al    ; 从8259,ICW2.
        call    io_delay
            
        mov     al,004h    ; IR2 对应从8259
        out     021h,al    ; 主8259,ICW3.
        call    io_delay
            
        mov     al,002h    ; 对应主8259的 IR2
        out     0A1h,al    ; 从8259,ICW3.
        call    io_delay
            
        mov     al,001h
        out     021h,al    ; 主8259,ICW4.
        call    io_delay
            
        out     0A1h,al    ; 从8259,ICW4.
        call    io_delay
            
        mov     al,_SavedIMREG_M      ; 恢复中断屏蔽寄存器(IMREG)的原值
        out     021h,al        ; 
        call    io_delay

        mov     al,_SavedIMREG_S      ; 恢复中断屏蔽寄存器(IMREG)的原值
        out     0A1h,al        ; 
        call    io_delay

        ret
        
io_delay:
        nop
        nop
        nop
        nop
        ret
        
Real:           ;现在又回到实方式
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

CSEG    ENDS                   ;代码段定义结束

CSEG32  SEGMENT USE32
        ASSUME CS:CSEG32,DS:PSEG
IRQ0Handler:
        inc     byte ptr gs:[((80 * 0 + 70) * 2)] ; 屏幕第 0 行,第 70 列。
        mov     al,20h
        out     20h,al                            ; 发送EOI到主8259
        iretd

IRQ1Handler:
        in      al,60h
        mov     inkey,al
        inc     byte ptr gs:[((80 * 1 + 70) * 2)] ; 屏幕第 1 行,第 70 列。
        mov     al,20h
        out     20h,al                            ; 发送EOI到主8259
        iretd

UserIntHandler:
        mov     ah,0Ch                            ; 0000 黑底 1100 红字
        mov     al,'I'
        mov     gs:[((80 * 2 + 70) * 2)],ax       ; 屏幕第 2 行,第 70 列。
        iretd

SpuriousHandler:
        iretd
CSEG32  ENDS
        END     Start
