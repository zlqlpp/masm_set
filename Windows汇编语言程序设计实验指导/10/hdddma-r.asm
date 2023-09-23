;程序清单: hdddma-r.asm(实模式下的硬盘DMA)
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



bmcr_base_addr  EQU    0C000H       ; DMA主控寄存器首地址
numSect         EQU    1            ; 读取1个扇区
lbaSector       EQU    0            ; LBA=0
BM_COMMAND_REG  EQU    0            ; 主控命令寄存器的偏移
BM_STATUS_REG   EQU    2            ; 主控状态寄存器的偏移
BM_PRD_ADDR_REG EQU    4            ; 物理区域描述符指针寄存器的偏移
pio_base_addr1  EQU    01F0H        ; ATA设备控制块寄存器基地址
pio_base_addr2  EQU    03F0H        ; ATA命令命令块寄存器基地址

DSEG            SEGMENT USE16       ; 16位数据段
GDT             LABEL   BYTE                  ;全局描述符表
DUMMY           Desc    <>                    ;空描述符
Code            Desc    <0ffffh,,,ATCE,,>     ;代码段描述符
DataD           Desc    <0ffffh,0,,ATDW,,>    ;源数据段描述符
GDTLen          =       $-GDT                 ;全局描述符表长度
VGDTR           PDesc   <GDTLen-1,>           ;伪描述符
Code_Sel        =       Code-GDT              ;代码段选择子


ALIGN 2                        
_Buffer         db      512*numSect dup (0)   ; 内存缓冲区
_BufferLen      equ     $-_Buffer
ALIGN 4                        
prdBuf          dd      0           ; 物理区域描述符
                dd      0
prdBufAddr      dd      0           ; 物理区域描述符地址
bufferaddr      dd      0           ; 内存缓冲区地址
DSEG            ENDS                ; 数据段结束

SSEG            SEGMENT PARA STACK  ; 堆栈段
                DB      512 DUP (0)
SSEG            ENDS                ; 堆栈段结束

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
JUMP16          MACRO   Selector,Offset
                DB      0eah     ;操作码
                DW      Offset   ;16位偏移量
                DW      Selector ;段值或段选择子
                ENDM



outx            MACRO   Reg, Val    ; 向Reg端口写入数据Val
                mov     dx, Reg
                mov     al, Val
                out     dx, al
                ENDM

inx             MACRO   Reg         ; 从Reg端口读入数据, 存放在AL中
                mov     dx, Reg
                in      al, dx
                ENDM
                
CSEG            SEGMENT USE16       ; 代码段
                ASSUME  CS:CSEG,DS:DSEG
; 检查ATA状态寄存器, 直到BSY=0和DRQ=0
waitDeviceReady proc
waitReady:
                inx     pio_base_addr1+7    ; 读取ATA状态寄存器
                and     al, 10001000b       ; BSY=1或DRQ=1,继续查询
                jnz     waitReady
                ret
waitDeviceReady endp
; 采用DMA方式读取硬盘扇区
ReadSectors     proc               
                ; Start/Stop=0, 停止以前的DMA传输
                outx    bmcr_base_addr+BM_COMMAND_REG, 00h
                ; 清除主控状态寄存器的Interrupt和Error位
                outx    bmcr_base_addr+BM_STATUS_REG, 00000110b
                ; 建立一个物理区域描述符
                mov     eax, bufferaddr
                mov     prdBuf, eax                   ; Physical Address
                mov     word ptr prdBuf+4, _BufferLen ; Byte Count [15:1]
                mov     word ptr prdBuf+6, 8000h      ; EOT=1
                ; 物理区域描述符的地址写入PRDTR
                mov     eax, prdBufAddr
                mov     dx, bmcr_base_addr+BM_PRD_ADDR_REG
                out     dx, eax
                ; 主控命令寄存器的R/W=1, 表示写入内存(读取硬盘)
                outx    bmcr_base_addr+BM_COMMAND_REG, 08h 
                ; 等待硬盘BSY=0和DRQ=0
                call    waitDeviceReady
                ; 设置设备/磁头寄存器的DEV=0
                outx    pio_base_addr1+6, 00h
                ; 等待硬盘BSY=0和DRQ=0
                call    waitDeviceReady
                ; 设备控制寄存器的nIEN=0, 允许中断
                outx    pio_base_addr2+6, 00
                ; 设置ATA寄存器
                outx    pio_base_addr1+1, 00h              ; =00
                outx    pio_base_addr1+2, numSect          ; 扇区号
                outx    pio_base_addr1+3, lbaSector >> 0   ; LBA第7~0位
                outx    pio_base_addr1+4, lbaSector >> 8   ; LBA第15~8位
                outx    pio_base_addr1+5, lbaSector >> 16  ; LBA第23~16位
                ; 设备/磁头寄存器:LBA=1, DEV=0, LBA第27~24位
                outx    pio_base_addr1+6, 01000000b or (lbaSector >> 24)   
                ; 设置ATA命令寄存器
                outx    pio_base_addr1+7, 0C8h             ; 0C8h=Read DMA
                ; 读取主控命令寄存器和主控状态寄存器
                inx     bmcr_base_addr + BM_COMMAND_REG
                inx     bmcr_base_addr + BM_STATUS_REG
                ; 主控命令寄存器的R/W=1,Start/Stop=1, 启动DMA传输 
                outx    bmcr_base_addr+BM_COMMAND_REG, 09h
                ; 现在开始DMA数据传送
                ; 检查主控状态寄存器, Interrupt=1时,传送结束
                mov     ecx, 4000h
notAsserted:
                inx     bmcr_base_addr+BM_STATUS_REG
                and     al, 00000100b
                jz      notAsserted
                ; 清除主控状态寄存器的Interrupt位
                outx    bmcr_base_addr+BM_STATUS_REG, 00000100b
                ; 读取主控状态寄存器
                inx     bmcr_base_addr+BM_STATUS_REG
                ; 主控命令寄存器的Start/Stop=０, 结束DMA传输
                outx    bmcr_base_addr+BM_COMMAND_REG, 00h
                ret
ReadSectors     endp               
              
Start           PROC
                mov     ax,DSEG
                mov     ds,ax                   ; ds指向数据段
                mov     es,ax                   ; es指向数据段

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
                cld


                mov     bx,16
                mov     ax,ds
                mul     bx                      ; 计算并设置数据段基址
                add     ax, offset prdBuf       ; 数据段基址+offset prdBuf
                adc     dx, 0                   ; dx:ax = prdBuf的物理地址
                mov     WORD PTR prdBufAddr, ax
                mov     WORD PTR prdBufAddr+2, dx

                mov     ax,ds
                mul     bx
                add     ax, offset _Buffer      ; 段基址+offset _Buffer
                adc     dx, 0                   ; dx:ax = _Buffer的物理地址
                mov     WORD PTR bufferaddr, ax
                mov     WORD PTR bufferaddr+2, dx

                cli                             ; 关中断
                call    ReadSectors             ; DMA方式读取硬盘扇区
                sti                             ; 允许中断

                call    ShowBuffer              ; 显示缓冲区内容
				
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

                mov     ax,4c00h
                int     21h
Start           ENDP

;字符显示宏指令的定义
EchoCh          MACRO   ascii
                mov     ah,2
                mov     dl,ascii
                int     21h
                ENDM
                
ShowBuffer      PROC
                lea     si,_Buffer     ; 显示_Buffer内容
                cld
                mov     bp,_BufferLen/16
NextLine:       mov     cx,16
NextCh:         lodsb
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
                ret
ShowBuffer      ENDP
                
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

CSEG            ENDS                           ; 代码段结束
                END     start
