;�����嵥: pciide.asm(��ȡPCI-IDE���ÿռ�)
.386P
DSEG            SEGMENT USE16       ;16λ���ݶ�
CfgSpace        DB      256 DUP(0)  ;PCI�豸��256�ֽ����ÿռ�
bus             DW      0           ;bus��,0~255
dev             DW      0           ;dev��,0~31
func            DW      0           ;func��,0~7
index           DW      0           ;index,0~63
DSEG            ENDS                ;���ݶν���

SSEG            SEGMENT PARA STACK  ;��ջ��
                DB      512 DUP (0)
SSEG            ENDS                ;��ջ�ν���

;�ַ���ʾ��ָ��Ķ���
EchoCh          MACRO   ascii
                mov     ah,2
                mov     dl,ascii
                int     21h
                ENDM

CSEG            SEGMENT USE16       ;�����
                ASSUME  CS:CSEG,DS:DSEG
; ����PCI-IDE�豸, ��ȡPCI���ÿռ�
FindPCIIDE      PROC
                ; bus�Ŵ�0ѭ����255
                mov     bus, 0
loop_bus:
                ; dev�Ŵ�0ѭ����31
                mov     dev, 0
loop_dev:
                ; func�Ŵ�0ѭ����7
                mov     func, 0
loop_func:
                ; index�Ŵ�0ѭ����63
                mov     index, 0
loop_index:
                ;����eaxΪһ��32λ˫��, д��0cf8h�˿�
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
                ;��0cf8h�˿ڶ�ȡ�����üĴ�����������CfgSpace[index*4]��
                lea     edi,CfgSpace[edx]
                mov     dx,0cf8h
                out     dx,eax          ;eaxд�뵽0cf8h�˿�
                mov     dx,0cfch
                in      eax,dx          ;��0cfch�˿ڶ���
                
                cld
                stosd                   ;���üĴ���������CfgSpace��     
                            
                inc     index
                cmp     index, 64
                jb      loop_index      ;index=0~63

                cmp     WORD PTR CfgSpace[0ah],0101h    ;��������Ĵ���
                jz      FindValidOne        ;BaseClass=01h,Sub-Class=01h
                                
                cmp     func,0              ;func=0ʱ,���Ϊ�๦���豸
                jnz     NotFunc0            ;func=1ʱ,�����

                test    CfgSpace[0eh],80h   ;Bit7=1,<bus,dev>�Ƕ๦���豸
                jz      NotMultiFunc        ;Bit7=0,����
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
                mov     ds,ax           ;dsָ�����ݶ�
                mov     es,ax           ;esָ�����ݶ�

                call    FindPCIIDE      ;����PCI-IDE�豸
                
                lea     si,CfgSpace     ;��ʾ���ÿռ��е�256�ֽ�����
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

CSEG            ENDS                           ;����ν���
                END     Start
