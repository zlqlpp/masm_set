;程序清单: real2pro.asm(实模式与保护模式之间的切换)
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

;存储段描述符类型值说明
ATDR            EQU     90h ;存在的只读数据段类型值
ATDW            EQU     92h ;存在的可读写数据段属性值
ATDWA           EQU     93h ;存在的已访问可读写数据段类型值
ATCE            EQU     98h ;存在的只执行代码段属性值
ATCER           EQU     9ah ;存在的可执行可读代码段属性值
ATCCO           EQU     9ch ;存在的只执行一致代码段属性值
ATCCOR          EQU     9eh ;存在的可执行可读一致代码段属性值

DSEG            SEGMENT USE16                 ;16位数据段
GDT             LABEL   BYTE                  ;全局描述符表
DUMMY           Desc    <>                    ;空描述符
Code            Desc    <0ffffh,,,ATCE,,>     ;代码段描述符
DataD           Desc    <0ffffh,0,,ATDW,,>    ;源数据段描述符
DataE           Desc    <0ffffh,,,ATDW,,>     ;目标数据段描述符
GDTLen          =       $-GDT                 ;全局描述符表长度
VGDTR           PDesc   <GDTLen-1,>           ;伪描述符
Code_Sel        =       Code-GDT              ;代码段选择子
DataD_Sel       =       DataD-GDT             ;源数据段选择子
DataE_Sel       =       DataE-GDT             ;目标数据段选择子
BufLen          =       64                    ;缓冲区字节长度
Buffer          DB      BufLen DUP(55h)       ;缓冲区
DSEG            ENDS                          ;数据段定义结束

ESEG            SEGMENT USE16                 ;16位数据段
Buffer2         DB      BufLen DUP(0)         ;缓冲区
ESEG            ENDS                          ;数据段定义结束

SSEG            SEGMENT PARA STACK            ;16位堆栈段
                DB      512 DUP (0)
SSEG            ENDS                          ;堆栈段定义结束

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

;字符显示宏指令的定义
EchoCh          MACRO   ascii
                mov     ah,2
                mov     dl,ascii
                int     21h
                ENDM

;16位偏移的段间直接转移指令的宏定义(在16位代码段中使用)
JUMP16          MACRO   Selector,Offset
                DB      0eah     ;操作码
                DW      Offset   ;16位偏移量
                DW      Selector ;段值或段选择子
                ENDM

CSEG            SEGMENT USE16                 ;16位代码段
                ASSUME  CS:CSEG,DS:DSEG
Start           PROC
                mov     ax,DSEG
                mov     ds,ax
                ;准备要加载到GDTR的伪描述符
                mov     bx,16
                mul     bx
                add     ax,OFFSET GDT          ;计算并设置基地址
                adc     dx,0                   ;界限已在定义时设置好
                mov     WORD PTR VGDTR.Base,ax
                mov     WORD PTR VGDTR.Base+2,dx
                ;设置代码段描述符
                mov     ax,cs
                mul     bx
                mov     WORD PTR Code.BaseL,ax ;代码段开始偏移为0
                mov     BYTE PTR Code.BaseM,dl ;代码段界限已在定义时设置好
                mov     BYTE PTR Code.BaseH,dh
                ;设置源数据段描述符
                mov     ax,ds
                mul     bx
                mov     WORD PTR DataD.BaseL,ax
                mov     BYTE PTR DataD.BaseM,dl
                mov     BYTE PTR DataD.BaseH,dh
                ;设置目标数据段描述符
                mov     ax,ESEG
                mul     bx
                mov     WORD PTR DataE.BaseL,ax
                mov     BYTE PTR DataE.BaseM,dl
                mov     BYTE PTR DataE.BaseH,dh
                ;加载GDTR
                lgdt    QWORD PTR VGDTR
                cli                            ;关中断
                EnableA20                      ;打开地址线A20
                
                ;切换到保护方式
                mov     eax,cr0
                or      eax,1
                mov     cr0,eax
                
                ;清指令预取队列,并真正进入保护方式
                JUMP16  Code_Sel,<OFFSET Virtual>
Virtual:        
                ;现在开始在保护方式下运行
                mov     ax,DataD_Sel
                mov     ds,ax                  ;加载源数据段描述符
                mov     ax,DataE_Sel
                mov     es,ax                  ;加载目标数据段描述符
                cld
                lea     esi,Buffer
                lea     edi,Buffer2            ;设置指针初值
                mov     ecx,BufLen/4           ;设置传送次数
                repz    movsd                  ;传送
                
                ;切换回实模式
                mov     eax,cr0
                and     al,11111110b
                mov     cr0,eax
                
                ;清指令预取队列,进入实方式
                JUMP16  <SEG Real>,<OFFSET Real>
Real:           
                ;现在又回到实方式
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

CSEG            ENDS                           ;代码段结束
                END     Start
