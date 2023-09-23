 ;程序清单: task.asm(任务切换)
INCLUDE         386SCD.INC

RDataSeg        SEGMENT PARA USE16              ;实方式数据段
                ;全局描述符表
GDT             LABEL   BYTE
                ;空描述符
DUMMY           Desc    <>
                ;规范段描述符
Normal          Desc    <0ffffh,,,ATDW,,>
                ;视频缓冲区段描述符(DPL=3)
VideoBuf        Desc    <0ffffh,8000h,0bh,ATDW+DPL3,,>
EFFGDT          LABEL   BYTE
                ;演示任务的局部描述符表段的描述符
DemoLDTab       Desc    <DemoLDTLen-1,DemoLDTSeg,,ATLDT,,>
                ;演示任务的任务状态段描述符
DemoTSS         Desc    <DemoTSSLen-1,DemoTSSSeg,,AT386TSS,,>
                ;临时任务的任务状态段描述符
TempTSS         Desc    <TempTSSLen-1,TempTSSSeg,,AT386TSS+DPL2,,>
                ;临时代码段描述符
TempCode        Desc    <0ffffh,TempCodeSeg,,ATCE,,>
                ;子程序代码段描述符
SubR            Desc    <SubRLen-1,SubRSeg,,ATCE,D32,>
GDNum           =       ($-EFFGDT)/8            ;需处理基地址的描述符个数
GDTLen          =       $-GDT                   ;全局描述符表长度

VGDTR           PDesc   <GDTLen-1,>             ;GDT伪描述符
SPVar           DW      ?                       ;用于保存实方式下的SP
SSVar           DW      ?                       ;用于保存实方式下的SS
RDataSeg        ENDS

Normal_Sel      =       Normal-GDT
Video_Sel       =       VideoBuf-GDT
DemoLDT_Sel     =       DemoLDTab-GDT
DemoTSS_Sel     =       DemoTSS-GDT
TempTSS_Sel     =       TempTSS-GDT
TempCode_Sel    =       TempCode-GDT
SubR_Sel        =       SubR-GDT

DemoLDTSeg      SEGMENT PARA USE16              ;局部描述符表数据段(16位)
DemoLDT         LABEL   BYTE                    ;局部描述符表
                ;0级堆栈段描述符(32位段)
DemoStack0      Desc    <DemoStack0Len-1,DemoStack0Seg,,ATDW,D32,>
                ;2级堆栈段描述符(32位段)
DemoStack2      Desc    <DemoStack2Len-1,DemoStack2Seg,,ATDW+DPL2,D32,>
                ;演示任务代码段描述符(32位段,DPL=2)
DemoCode        Desc    <DemoCodeLen-1,DemoCodeSeg,,ATCE+DPL2,D32,>
                ;演示任务数据段描述符(32位段,DPL=3)
DemoData        Desc    <DemoDataLen-1,DemoDataSeg,,ATDW+DPL3,D32,>
                ;把LDT作为普通数据段描述的描述符(DPL=2)
ToDLDT          Desc    <DemoLDTLen-1,DemoLDTSeg,,ATDW+DPL2,,>
                ;把TSS作为普通数据段描述的描述符(DPL=2)
ToTTSS          Desc    <TempTSSLen-1,TempTSSSeg,,ATDW+DPL2,,>
DemoLDNum       =       ($-DemoLDT)/(8) ;需处理基地址的LDT描述符数
                ;指向子程序SubRB代码段的调用门(DPL=3)
ToSubR          Gate    <SubRB,SubR_Sel,,AT386CGate+DPL3,>
                ;指向临时任务Temp的任务门(DPL=3)
ToTempT         Gate    <,TempTSS_Sel,,ATTaskGate+DPL3,>
DemoLDTLen      =       $-DemoLDT
DemoLDTSeg      ENDS                            ;局部描述符表段定义结束

DemoStack0_Sel  =       DemoStack0-DemoLDT+TIL
DemoStack2_Sel  =       DemoStack2-DemoLDT+TIL+RPL2
DemoCode_Sel    =       DemoCode-DemoLDT+TIL+RPL2
DemoData_Sel    =       DemoData-DemoLDT+TIL
ToDLDT_Sel      =       ToDLDT-DemoLDT+TIL
ToTTSS_Sel      =       ToTTSS-DemoLDT+TIL
ToSubR_Sel      =       ToSubR-DemoLDT+TIL+RPL2
ToTempT_Sel     =       ToTempT-DemoLDT+TIL

DemoTSSSeg      SEGMENT PARA USE16              ;任务状态段TSS
                DD      0                       ;链接字
                DD      DemoStack0Len           ;0级堆栈指针
                DW      DemoStack0_Sel,0        ;0级堆栈选择符
                DD      0                       ;1级堆栈指针(实例不使用)
                DW      0,0                     ;1级堆栈选择符(实例不使用)
                DD      0                       ;2级堆栈指针
                DW      0,0                     ;2级堆栈选择符
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
                DW      0                       ;调试陷阱标志
                DW      $+2                     ;指向I/O许可位图
                DB      0ffh                    ;I/O许可位图结束标志
DemoTSSLen      =       $
DemoTSSSeg      ENDS                            ;任务状态段TSS结束

DemoStack0Seg   SEGMENT PARA USE32              ;演示任务0级堆栈段(32位段)
DemoStack0Len   =       1024
                DB      DemoStack0Len DUP(0)
DemoStack0Seg   ENDS                            ;演示任务0级堆栈段结束

DemoStack2Seg   SEGMENT PARA USE32             ;演示任务2级堆栈段(32位段)
DemoStack2Len   =       512
                DB      DemoStack2Len DUP(0)
DemoStack2Seg   ENDS                            ;演示任务2级堆栈段结束

DemoDataSeg     SEGMENT PARA USE32              ;演示任务数据段(32位段)
Message         DB      'EDI=',0
tableH2A        DB      '0123456789ABCDEF'
DemoDataLen     =       $
DemoDataSeg     ENDS                            ;演示任务数据段结束

SubRSeg         SEGMENT PARA USE32              ;子程序代码段(32位)
                ASSUME  CS:SubRSeg
SubRB           PROC    FAR
                push    ebp
                mov     ebp,esp
                push    edi
                mov     esi,DWORD PTR [ebp+12]  ;从0级栈中取出显示串偏移
                mov     ah,47h                  ;设置显示属性
SubR1:          
                lodsb
                or      al,al
                jz      SubR2
                stosw
                jmp     short SubR1
SubR2:                
                mov     ah,4eh                  ;设置显示属性
                mov     edx,DWORD PTR [ebp+16]  ;从0级栈中取出显示值
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
SubRSeg         ENDS                            ;子程序代码段结束

DemoCodeSeg     SEGMENT PARA USE32              ;演示任务的32位代码段
                ASSUME  CS:DemoCodeSeg,DS:DemoDataSeg
DemoBegin       PROC    FAR
                ;把要复制的参数个数置入调用门
                mov     BYTE PTR fs:ToSubR.DCount,2
                ;向2级堆栈中压入参数
                push    EDI
                push    OFFSET Message
                ;通过调用门调用SubRB
                CALL32  ToSubR_Sel,0

                ;通过任务门切换到临时任务
                JUMP32  ToTempT_Sel,0
                jmp     DemoBegin
DemoBegin       ENDP
DemoCodeLen     =       $
DemoCodeSeg     ENDS                            ;演示任务的32位代码段结束

TempTSSSeg      SEGMENT PARA USE16              ;临时任务的任务状态段TSS
TempTask        TSS     <>
                DB      0ffh                    ;I/O许可位图结束标志
TempTSSLen      =       $
TempTSSSeg      ENDS

TempCodeSeg     SEGMENT PARA USE16              ;临时任务的代码段
                ASSUME  CS:TempCodeSeg
Virtual         PROC    FAR
                mov     ax,TempTSS_Sel          ;装载TR
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
                JUMP16  DemoTSS_Sel,0           ;直接切换到演示任务
                inc     byte ptr es:[0h]
                loop    Virtual0
                
                clts                            ;清任务切换标志
                mov     eax,cr0                 ;准备返回实模式
                and     al,11111110b
                mov     cr0,eax
                JUMP16  <SEG Real>,<OFFSET Real>
Virtual         ENDP
TempCodeSeg     ENDS


RStackSeg       SEGMENT PARA STACK              ;实方式堆栈段
                DB      512 DUP (0)
RStackSeg       ENDS                            ;堆栈段结束

RCodeSeg        SEGMENT PARA USE16
                ASSUME  CS:RCodeSeg,DS:RDataSeg,ES:RDataSeg
Start           PROC
                mov     ax,RDataSeg
                mov     ds,ax
                mov     SSVar,ss
                mov     SPVar,sp

                cld
                call    InitGDT                 ;初始化全局描述符表GDT

                call    InitLDT                 ;初始化局部描述符表LDT

                lgdt    QWORD PTR VGDTR         ;装载GDTR并切换到保护方式
                cli
                mov     eax,cr0
                or      al,1
                mov     cr0,eax
                JUMP16  <TempCode_Sel>,<OFFSET Virtual>
Real:           
                mov     ax,RDataSeg             ;又回到实方式
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

