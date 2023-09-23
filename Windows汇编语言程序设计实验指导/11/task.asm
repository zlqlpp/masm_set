 ;�����嵥: task.asm(�����л�)
INCLUDE         386SCD.INC

RDataSeg        SEGMENT PARA USE16              ;ʵ��ʽ���ݶ�
                ;ȫ����������
GDT             LABEL   BYTE
                ;��������
DUMMY           Desc    <>
                ;�淶��������
Normal          Desc    <0ffffh,,,ATDW,,>
                ;��Ƶ��������������(DPL=3)
VideoBuf        Desc    <0ffffh,8000h,0bh,ATDW+DPL3,,>
EFFGDT          LABEL   BYTE
                ;��ʾ����ľֲ���������ε�������
DemoLDTab       Desc    <DemoLDTLen-1,DemoLDTSeg,,ATLDT,,>
                ;��ʾ���������״̬��������
DemoTSS         Desc    <DemoTSSLen-1,DemoTSSSeg,,AT386TSS,,>
                ;��ʱ���������״̬��������
TempTSS         Desc    <TempTSSLen-1,TempTSSSeg,,AT386TSS+DPL2,,>
                ;��ʱ�����������
TempCode        Desc    <0ffffh,TempCodeSeg,,ATCE,,>
                ;�ӳ�������������
SubR            Desc    <SubRLen-1,SubRSeg,,ATCE,D32,>
GDNum           =       ($-EFFGDT)/8            ;�账�����ַ������������
GDTLen          =       $-GDT                   ;ȫ������������

VGDTR           PDesc   <GDTLen-1,>             ;GDTα������
SPVar           DW      ?                       ;���ڱ���ʵ��ʽ�µ�SP
SSVar           DW      ?                       ;���ڱ���ʵ��ʽ�µ�SS
RDataSeg        ENDS

Normal_Sel      =       Normal-GDT
Video_Sel       =       VideoBuf-GDT
DemoLDT_Sel     =       DemoLDTab-GDT
DemoTSS_Sel     =       DemoTSS-GDT
TempTSS_Sel     =       TempTSS-GDT
TempCode_Sel    =       TempCode-GDT
SubR_Sel        =       SubR-GDT

DemoLDTSeg      SEGMENT PARA USE16              ;�ֲ������������ݶ�(16λ)
DemoLDT         LABEL   BYTE                    ;�ֲ���������
                ;0����ջ��������(32λ��)
DemoStack0      Desc    <DemoStack0Len-1,DemoStack0Seg,,ATDW,D32,>
                ;2����ջ��������(32λ��)
DemoStack2      Desc    <DemoStack2Len-1,DemoStack2Seg,,ATDW+DPL2,D32,>
                ;��ʾ��������������(32λ��,DPL=2)
DemoCode        Desc    <DemoCodeLen-1,DemoCodeSeg,,ATCE+DPL2,D32,>
                ;��ʾ�������ݶ�������(32λ��,DPL=3)
DemoData        Desc    <DemoDataLen-1,DemoDataSeg,,ATDW+DPL3,D32,>
                ;��LDT��Ϊ��ͨ���ݶ�������������(DPL=2)
ToDLDT          Desc    <DemoLDTLen-1,DemoLDTSeg,,ATDW+DPL2,,>
                ;��TSS��Ϊ��ͨ���ݶ�������������(DPL=2)
ToTTSS          Desc    <TempTSSLen-1,TempTSSSeg,,ATDW+DPL2,,>
DemoLDNum       =       ($-DemoLDT)/(8) ;�账�����ַ��LDT��������
                ;ָ���ӳ���SubRB����εĵ�����(DPL=3)
ToSubR          Gate    <SubRB,SubR_Sel,,AT386CGate+DPL3,>
                ;ָ����ʱ����Temp��������(DPL=3)
ToTempT         Gate    <,TempTSS_Sel,,ATTaskGate+DPL3,>
DemoLDTLen      =       $-DemoLDT
DemoLDTSeg      ENDS                            ;�ֲ���������ζ������

DemoStack0_Sel  =       DemoStack0-DemoLDT+TIL
DemoStack2_Sel  =       DemoStack2-DemoLDT+TIL+RPL2
DemoCode_Sel    =       DemoCode-DemoLDT+TIL+RPL2
DemoData_Sel    =       DemoData-DemoLDT+TIL
ToDLDT_Sel      =       ToDLDT-DemoLDT+TIL
ToTTSS_Sel      =       ToTTSS-DemoLDT+TIL
ToSubR_Sel      =       ToSubR-DemoLDT+TIL+RPL2
ToTempT_Sel     =       ToTempT-DemoLDT+TIL

DemoTSSSeg      SEGMENT PARA USE16              ;����״̬��TSS
                DD      0                       ;������
                DD      DemoStack0Len           ;0����ջָ��
                DW      DemoStack0_Sel,0        ;0����ջѡ���
                DD      0                       ;1����ջָ��(ʵ����ʹ��)
                DW      0,0                     ;1����ջѡ���(ʵ����ʹ��)
                DD      0                       ;2����ջָ��
                DW      0,0                     ;2����ջѡ���
                DD      0                       ;CR3
                DW      DemoBegin,0             ;EIP
                DD      0                       ;EFLAGS
                DD      0                       ;EAX
                DD      0                       ;ECX
                DD      0                       ;EDX
                DD      0                       ;EBX
                DD      DemoStack2Len           ;ESP
                DD      0                       ;EBP
                DD      0                       ;ESI
                DD      (80*4+50)*2             ;EDI
                DW      Video_Sel,0             ;ES
                DW      DemoCode_Sel,0          ;CS
                DW      DemoStack2_Sel,0        ;SS
                DW      DemoData_Sel,0          ;DS
                DW      ToDLDT_Sel,0            ;FS
                DW      ToTTSS_Sel,0            ;GS
                DW      DemoLDT_Sel,0           ;LDTR
                DW      0                       ;���������־
                DW      $+2                     ;ָ��I/O���λͼ
                DB      0ffh                    ;I/O���λͼ������־
DemoTSSLen      =       $
DemoTSSSeg      ENDS                            ;����״̬��TSS����

DemoStack0Seg   SEGMENT PARA USE32              ;��ʾ����0����ջ��(32λ��)
DemoStack0Len   =       1024
                DB      DemoStack0Len DUP(0)
DemoStack0Seg   ENDS                            ;��ʾ����0����ջ�ν���

DemoStack2Seg   SEGMENT PARA USE32             ;��ʾ����2����ջ��(32λ��)
DemoStack2Len   =       512
                DB      DemoStack2Len DUP(0)
DemoStack2Seg   ENDS                            ;��ʾ����2����ջ�ν���

DemoDataSeg     SEGMENT PARA USE32              ;��ʾ�������ݶ�(32λ��)
Message         DB      'EDI=',0
tableH2A        DB      '0123456789ABCDEF'
DemoDataLen     =       $
DemoDataSeg     ENDS                            ;��ʾ�������ݶν���

SubRSeg         SEGMENT PARA USE32              ;�ӳ�������(32λ)
                ASSUME  CS:SubRSeg
SubRB           PROC    FAR
                push    ebp
                mov     ebp,esp
                push    edi
                mov     esi,DWORD PTR [ebp+12]  ;��0��ջ��ȡ����ʾ��ƫ��
                mov     ah,47h                  ;������ʾ����
SubR1:          
                lodsb
                or      al,al
                jz      SubR2
                stosw
                jmp     short SubR1
SubR2:                
                mov     ah,4eh                  ;������ʾ����
                mov     edx,DWORD PTR [ebp+16]  ;��0��ջ��ȡ����ʾֵ
                mov     ecx,8
SubR3:          
                rol     edx,4
                mov     al,dl
                and     al,0fh
                movzx   ebx,al
                mov     al,ds:tableH2A[ebx]
                stosw
                loop    SubR3
                pop     edi
                add     edi,160
                pop     ebp
                ret     8
SubRB           ENDP
SubRLen         =       $
SubRSeg         ENDS                            ;�ӳ������ν���

DemoCodeSeg     SEGMENT PARA USE32              ;��ʾ�����32λ�����
                ASSUME  CS:DemoCodeSeg,DS:DemoDataSeg
DemoBegin       PROC    FAR
                ;��Ҫ���ƵĲ����������������
                mov     BYTE PTR fs:ToSubR.DCount,2
                ;��2����ջ��ѹ�����
                push    EDI
                push    OFFSET Message
                ;ͨ�������ŵ���SubRB
                CALL32  ToSubR_Sel,0

                ;ͨ���������л�����ʱ����
                JUMP32  ToTempT_Sel,0
                jmp     DemoBegin
DemoBegin       ENDP
DemoCodeLen     =       $
DemoCodeSeg     ENDS                            ;��ʾ�����32λ����ν���

TempTSSSeg      SEGMENT PARA USE16              ;��ʱ���������״̬��TSS
TempTask        TSS     <>
                DB      0ffh                    ;I/O���λͼ������־
TempTSSLen      =       $
TempTSSSeg      ENDS

TempCodeSeg     SEGMENT PARA USE16              ;��ʱ����Ĵ����
                ASSUME  CS:TempCodeSeg
Virtual         PROC    FAR
                mov     ax,TempTSS_Sel          ;װ��TR
                ltr     ax
                
                mov     ax,Video_Sel
                mov     es,ax
                mov     ax,Normal_Sel
                mov     ds,ax
                mov     fs,ax
                mov     gs,ax
                mov     ss,ax
                
                xor     edi,edi
                mov     ecx,25*80
                mov     ax,0720h
                cld
                rep     stosw
                
                mov     byte ptr es:[0h], '0'
                mov     ecx,5
Virtual0:       
                JUMP16  DemoTSS_Sel,0           ;ֱ���л�����ʾ����
                inc     byte ptr es:[0h]
                loop    Virtual0
                
                clts                            ;�������л���־
                mov     eax,cr0                 ;׼������ʵģʽ
                and     al,11111110b
                mov     cr0,eax
                JUMP16  <SEG Real>,<OFFSET Real>
Virtual         ENDP
TempCodeSeg     ENDS


RStackSeg       SEGMENT PARA STACK              ;ʵ��ʽ��ջ��
                DB      512 DUP (0)
RStackSeg       ENDS                            ;��ջ�ν���

RCodeSeg        SEGMENT PARA USE16
                ASSUME  CS:RCodeSeg,DS:RDataSeg,ES:RDataSeg
Start           PROC
                mov     ax,RDataSeg
                mov     ds,ax
                mov     SSVar,ss
                mov     SPVar,sp

                cld
                call    InitGDT                 ;��ʼ��ȫ����������GDT

                call    InitLDT                 ;��ʼ���ֲ���������LDT

                lgdt    QWORD PTR VGDTR         ;װ��GDTR���л���������ʽ
                cli
                mov     eax,cr0
                or      al,1
                mov     cr0,eax
                JUMP16  <TempCode_Sel>,<OFFSET Virtual>
Real:           
                mov     ax,RDataSeg             ;�ֻص�ʵ��ʽ
                mov     ds,ax
                mov     sp,SPVar
                mov     ss,SSVar
                sti
                mov     ax,4c00h
                int     21h
Start           ENDP

InitGDT         PROC
                mov     cx,GDNum
                mov     si,OFFSET EFFGDT
                mov     bx,16
InitG:          
                mov     ax,[si].BaseL
                mul     bx
                mov     WORD PTR [si].BaseL,ax
                mov     BYTE PTR [si].BaseM,dl
                mov     BYTE PTR [si].BaseH,dh
                add     si,8
                loop    InitG

                mov     ax,ds
                mul     bx
                add     ax,offset GDT
                adc     dx,0
                mov     WORD PTR VGDTR.Base,ax
                mov     WORD PTR VGDTR.Base+2,dx
                ret
InitGDT         ENDP

InitLDT         PROC
                mov     ax,DemoLDTSeg
                mov     es,ax
                mov     si,OFFSET DemoLDT
                mov     cx,DemoLDNum
                mov     bx,16
InitL:
                mov     ax,WORD PTR es:[si].BaseL
                mul     bx
                mov     WORD PTR es:[si].BaseL,ax
                mov     BYTE PTR es:[si].BaseM,dl
                mov     BYTE PTR es:[si].BaseH,dh
                add     si,8
                loop    InitL
                ret
InitLDT         ENDP
RCodeSeg        ENDS
                END     Start

