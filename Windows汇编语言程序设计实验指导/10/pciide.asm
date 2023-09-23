;程序清单: pciide.asm(获取PCI-IDE配置空间)
.386P
DSEG            SEGMENT USE16       ;16位数据段
CfgSpace        DB      256 DUP(0)  ;PCI设备的256字节配置空间
bus             DW      0           ;bus号,0~255
dev             DW      0           ;dev号,0~31
func            DW      0           ;func号,0~7
index           DW      0           ;index,0~63
DSEG            ENDS                ;数据段结束

SSEG            SEGMENT PARA STACK  ;堆栈段
                DB      512 DUP (0)
SSEG            ENDS                ;堆栈段结束

;字符显示宏指令的定义
EchoCh          MACRO   ascii
                mov     ah,2
                mov     dl,ascii
                int     21h
                ENDM

CSEG            SEGMENT USE16       ;代码段
                ASSUME  CS:CSEG,DS:DSEG
; 搜索PCI-IDE设备, 获取PCI配置空间
FindPCIIDE      PROC
                ; bus号从0循环到255
                mov     bus, 0
loop_bus:
                ; dev号从0循环到31
                mov     dev, 0
loop_dev:
                ; func号从0循环到7
                mov     func, 0
loop_func:
                ; index号从0循环到63
                mov     index, 0
loop_index:
                ;构造eax为一个32位双字, 写入0cf8h端口
                ;(1 << 31)|(bus << 16)|(dev << 11)|(func << 8)|(index << 2)
                movzx   eax,bus         ;eax=bus                
                movzx   ebx,dev         ;ebx=dev                
                movzx   ecx,func        ;ecx=func
                movzx   edx,index       ;dex=index
                shl     eax,16          ;eax=(bus<<16)
                shl     ebx,11          ;ebx=(dev<<11)
                shl     ecx,8           ;ecx=(func<<8)
                shl     edx,2           ;edx=(index<<2)
                or      eax,80000000h   ;eax=(1<<31)||(bus<<16)
                or      eax,ebx         ;eax=..||(dev << 11)
                or      eax,ecx         ;eax=..||(func << 8)
                or      eax,edx         ;eax=..||(index << 2)
                ;从0cf8h端口读取的配置寄存器将保存在CfgSpace[index*4]中
                lea     edi,CfgSpace[edx]
                mov     dx,0cf8h
                out     dx,eax          ;eax写入到0cf8h端口
                mov     dx,0cfch
                in      eax,dx          ;从0cfch端口读入
                
                cld
                stosd                   ;配置寄存器保存在CfgSpace中     
                            
                inc     index
                cmp     index, 64
                jb      loop_index      ;index=0~63

                cmp     WORD PTR CfgSpace[0ah],0101h    ;检查类代码寄存器
                jz      FindValidOne        ;BaseClass=01h,Sub-Class=01h
                                
                cmp     func,0              ;func=0时,检查为多功能设备
                jnz     NotFunc0            ;func=1时,不检查

                test    CfgSpace[0eh],80h   ;Bit7=1,<bus,dev>是多功能设备
                jz      NotMultiFunc        ;Bit7=0,不是
NotFunc0:
                inc     func
                cmp     func, 8
                jb      loop_func       ;index=0~7
NotMultiFunc:
                inc     dev
                cmp     dev, 32
                jb      loop_dev        ;dev=0~31

                inc     bus
                cmp     bus, 256
                jb      loop_bus        ;bus=0~255
                
FindValidOne:
                ret
FindPCIIDE      ENDP
                
Start           PROC
                mov     ax,DSEG
                mov     ds,ax           ;ds指向数据段
                mov     es,ax           ;es指向数据段

                call    FindPCIIDE      ;搜索PCI-IDE设备
                
                lea     si,CfgSpace     ;显示配置空间中的256字节数据
                cld
                mov     bp,256/16
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
