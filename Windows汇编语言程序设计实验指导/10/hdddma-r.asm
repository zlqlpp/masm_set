;�����嵥: hdddma-r.asm(ʵģʽ�µ�Ӳ��DMA)
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



bmcr_base_addr  EQU    0C000H       ; DMA���ؼĴ����׵�ַ
numSect         EQU    1            ; ��ȡ1������
lbaSector       EQU    0            ; LBA=0
BM_COMMAND_REG  EQU    0            ; ��������Ĵ�����ƫ��
BM_STATUS_REG   EQU    2            ; ����״̬�Ĵ�����ƫ��
BM_PRD_ADDR_REG EQU    4            ; ��������������ָ��Ĵ�����ƫ��
pio_base_addr1  EQU    01F0H        ; ATA�豸���ƿ�Ĵ�������ַ
pio_base_addr2  EQU    03F0H        ; ATA���������Ĵ�������ַ

DSEG            SEGMENT USE16       ; 16λ���ݶ�
GDT             LABEL   BYTE                  ;ȫ����������
DUMMY           Desc    <>                    ;��������
Code            Desc    <0ffffh,,,ATCE,,>     ;�����������
DataD           Desc    <0ffffh,0,,ATDW,,>    ;Դ���ݶ�������
GDTLen          =       $-GDT                 ;ȫ������������
VGDTR           PDesc   <GDTLen-1,>           ;α������
Code_Sel        =       Code-GDT              ;�����ѡ����


ALIGN 2                        
_Buffer         db      512*numSect dup (0)   ; �ڴ滺����
_BufferLen      equ     $-_Buffer
ALIGN 4                        
prdBuf          dd      0           ; ��������������
                dd      0
prdBufAddr      dd      0           ; ����������������ַ
bufferaddr      dd      0           ; �ڴ滺������ַ
DSEG            ENDS                ; ���ݶν���

SSEG            SEGMENT PARA STACK  ; ��ջ��
                DB      512 DUP (0)
SSEG            ENDS                ; ��ջ�ν���

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
JUMP16          MACRO   Selector,Offset
                DB      0eah     ;������
                DW      Offset   ;16λƫ����
                DW      Selector ;��ֵ���ѡ����
                ENDM



outx            MACRO   Reg, Val    ; ��Reg�˿�д������Val
                mov     dx, Reg
                mov     al, Val
                out     dx, al
                ENDM

inx             MACRO   Reg         ; ��Reg�˿ڶ�������, �����AL��
                mov     dx, Reg
                in      al, dx
                ENDM
                
CSEG            SEGMENT USE16       ; �����
                ASSUME  CS:CSEG,DS:DSEG
; ���ATA״̬�Ĵ���, ֱ��BSY=0��DRQ=0
waitDeviceReady proc
waitReady:
                inx     pio_base_addr1+7    ; ��ȡATA״̬�Ĵ���
                and     al, 10001000b       ; BSY=1��DRQ=1,������ѯ
                jnz     waitReady
                ret
waitDeviceReady endp
; ����DMA��ʽ��ȡӲ������
ReadSectors     proc               
                ; Start/Stop=0, ֹͣ��ǰ��DMA����
                outx    bmcr_base_addr+BM_COMMAND_REG, 00h
                ; �������״̬�Ĵ�����Interrupt��Errorλ
                outx    bmcr_base_addr+BM_STATUS_REG, 00000110b
                ; ����һ����������������
                mov     eax, bufferaddr
                mov     prdBuf, eax                   ; Physical Address
                mov     word ptr prdBuf+4, _BufferLen ; Byte Count [15:1]
                mov     word ptr prdBuf+6, 8000h      ; EOT=1
                ; ���������������ĵ�ַд��PRDTR
                mov     eax, prdBufAddr
                mov     dx, bmcr_base_addr+BM_PRD_ADDR_REG
                out     dx, eax
                ; ��������Ĵ�����R/W=1, ��ʾд���ڴ�(��ȡӲ��)
                outx    bmcr_base_addr+BM_COMMAND_REG, 08h 
                ; �ȴ�Ӳ��BSY=0��DRQ=0
                call    waitDeviceReady
                ; �����豸/��ͷ�Ĵ�����DEV=0
                outx    pio_base_addr1+6, 00h
                ; �ȴ�Ӳ��BSY=0��DRQ=0
                call    waitDeviceReady
                ; �豸���ƼĴ�����nIEN=0, �����ж�
                outx    pio_base_addr2+6, 00
                ; ����ATA�Ĵ���
                outx    pio_base_addr1+1, 00h              ; =00
                outx    pio_base_addr1+2, numSect          ; ������
                outx    pio_base_addr1+3, lbaSector >> 0   ; LBA��7~0λ
                outx    pio_base_addr1+4, lbaSector >> 8   ; LBA��15~8λ
                outx    pio_base_addr1+5, lbaSector >> 16  ; LBA��23~16λ
                ; �豸/��ͷ�Ĵ���:LBA=1, DEV=0, LBA��27~24λ
                outx    pio_base_addr1+6, 01000000b or (lbaSector >> 24)   
                ; ����ATA����Ĵ���
                outx    pio_base_addr1+7, 0C8h             ; 0C8h=Read DMA
                ; ��ȡ��������Ĵ���������״̬�Ĵ���
                inx     bmcr_base_addr + BM_COMMAND_REG
                inx     bmcr_base_addr + BM_STATUS_REG
                ; ��������Ĵ�����R/W=1,Start/Stop=1, ����DMA���� 
                outx    bmcr_base_addr+BM_COMMAND_REG, 09h
                ; ���ڿ�ʼDMA���ݴ���
                ; �������״̬�Ĵ���, Interrupt=1ʱ,���ͽ���
                mov     ecx, 4000h
notAsserted:
                inx     bmcr_base_addr+BM_STATUS_REG
                and     al, 00000100b
                jz      notAsserted
                ; �������״̬�Ĵ�����Interruptλ
                outx    bmcr_base_addr+BM_STATUS_REG, 00000100b
                ; ��ȡ����״̬�Ĵ���
                inx     bmcr_base_addr+BM_STATUS_REG
                ; ��������Ĵ�����Start/Stop=��, ����DMA����
                outx    bmcr_base_addr+BM_COMMAND_REG, 00h
                ret
ReadSectors     endp               
              
Start           PROC
                mov     ax,DSEG
                mov     ds,ax                   ; dsָ�����ݶ�
                mov     es,ax                   ; esָ�����ݶ�

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
                cld


                mov     bx,16
                mov     ax,ds
                mul     bx                      ; ���㲢�������ݶλ�ַ
                add     ax, offset prdBuf       ; ���ݶλ�ַ+offset prdBuf
                adc     dx, 0                   ; dx:ax = prdBuf�������ַ
                mov     WORD PTR prdBufAddr, ax
                mov     WORD PTR prdBufAddr+2, dx

                mov     ax,ds
                mul     bx
                add     ax, offset _Buffer      ; �λ�ַ+offset _Buffer
                adc     dx, 0                   ; dx:ax = _Buffer�������ַ
                mov     WORD PTR bufferaddr, ax
                mov     WORD PTR bufferaddr+2, dx

                cli                             ; ���ж�
                call    ReadSectors             ; DMA��ʽ��ȡӲ������
                sti                             ; �����ж�

                call    ShowBuffer              ; ��ʾ����������
				
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

                mov     ax,4c00h
                int     21h
Start           ENDP

;�ַ���ʾ��ָ��Ķ���
EchoCh          MACRO   ascii
                mov     ah,2
                mov     dl,ascii
                int     21h
                ENDM
                
ShowBuffer      PROC
                lea     si,_Buffer     ; ��ʾ_Buffer����
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

CSEG            ENDS                           ; ����ν���
                END     start
