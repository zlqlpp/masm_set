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
include    winResult.inc
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
includelib winResult.lib


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
IDC_THESAME     equ 5009


.data
hInstance   dd ?
hRichEdit   dd ?
hWinMain    dd ?
hWinEdit    dd ?
dwCount     dd ?
dwColorRed  dd ?
hText1      dd ?
hText2      dd ?
hFile       dd ?


szNewBuffer      db  2048 dup(?)
szClassNameBuf db   512 dup (?)  ;��Ҫ���Ĵ�С
szWndTextBuf   db   512 dup (?)  ;��Ҫ���Ĵ�С
szName         db   '��װ - Photo',0

szBuffer       db   1024 dup(0) 
szOut1         db   '���ھ����%08x    ���������� %s      ',0
szOut2         db   '���ڱ��⣺ %s',0dh,0ah,0
szOut3         db   'ָ�����ƴ��ڵľ��Ϊ�� %08x  ',0dh,0ah,0


szMainClassNameBuf  db  512 dup(?)
szMainWndTextBuf    db  512 dup(?)
hParentWin          dd  ?   ;������
hWin                dd  ?   ;��ǰ����
hSubWin             dd  ?
@stPos             POINT   <?>


szFileName           db MAX_PATH dup(?)
szDstFile            db 'c:\bindC.exe',0
szFileNameOpen1      db 'd:\masm32\source\chapter13\patch.exe',MAX_PATH dup(0)
szFileNameOpen2      db 'c:\notepad.exe',MAX_PATH dup(0)

                     ;d:\masm32\source\chapter12\HelloWorld.exe

szResultColName1 db  'PE���ݽṹ����ֶ�',0
szResultColName2 db  '�ļ�1��ֵ(H)',0
szResultColName3 db  '�ļ�2��ֵ(H)',0
bufTemp1         db  200 dup(0),0
bufTemp2         db  200 dup(0),0
szFilter1        db  'Excutable Files',0,'*.exe;*.com',0
                 db  0

.const
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


;---------------------------
; ����0��ʾ��ͬ
;---------------------------
_MemComp  proc
   local @dwResult:dword

   pushad
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
_MemComp  endp

;-------------------------------------------
; ����ö�ٺ���
;-------------------------------------------
_EnumProc proc hTopWinWnd:DWORD,value:DWORD
      .if hTopWinWnd!=NULL
        invoke GetClassName,hTopWinWnd,addr szClassNameBuf,\  ;����
            sizeof szClassNameBuf
        invoke GetWindowText,hTopWinWnd,addr szWndTextBuf,\  ;������
            sizeof szWndTextBuf

        invoke wsprintf,addr szBuffer,addr szOut1,hTopWinWnd,addr szClassNameBuf
        invoke _appendInfo,addr szBuffer

        invoke wsprintf,addr szBuffer,addr szOut2,addr szWndTextBuf
        invoke _appendInfo,addr szBuffer
        invoke _appendInfo,addr szCrLf

        pushad
        mov esi,offset szName
        mov edi,offset szWndTextBuf
        mov ecx,10
        repe cmpsb
        jnz  @2
        mov eax,hTopWinWnd
        mov hWin,eax  
@2:
        popad

        inc dwCount
      .endif
      mov eax,hTopWinWnd ;�����ھ��Ϊ��ʱ����
      ret 
_EnumProc endp

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



;------------------------------------------
; �������ļ�
;------------------------------------------
_OpenFile1	proc
                invoke EnumWindows,addr _EnumProc,NULL  ;ö�ٶ��㴰��
                mov eax,hWin
                mov hParentWin,eax
                invoke wsprintf,addr szBuffer,addr szOut3,hWin
                invoke _appendInfo,addr szBuffer     
 

                invoke SetForegroundWindow,hWin
                invoke SetActiveWindow,hWin                
                invoke PostMessage,hWin,WM_KEYDOWN,VK_RETURN,NULL
                invoke Sleep,5000


                mov @stPos.x,500
                mov @stPos.y,400
                invoke WindowFromPoint,@stPos.x,@stPos.y
                mov hWin,eax
                invoke PostMessage,hWin,WM_KEYDOWN,VK_RETURN,NULL
                invoke Sleep,5000

                mov @stPos.x,500
                mov @stPos.y,400
                invoke WindowFromPoint,@stPos.x,@stPos.y
                mov hWin,eax
                invoke PostMessage,hWin,WM_KEYDOWN,VK_RETURN,NULL
                invoke Sleep,5000

                mov @stPos.x,500
                mov @stPos.y,400
                invoke WindowFromPoint,@stPos.x,@stPos.y
                mov hWin,eax
                invoke PostMessage,hWin,WM_KEYDOWN,VK_RETURN,NULL
                invoke Sleep,5000

                mov @stPos.x,500
                mov @stPos.y,400
                invoke WindowFromPoint,@stPos.x,@stPos.y
                mov hWin,eax
                invoke PostMessage,hWin,WM_KEYDOWN,VK_RETURN,NULL
                invoke Sleep,5000

                mov @stPos.x,500
                mov @stPos.y,400
                invoke WindowFromPoint,@stPos.x,@stPos.y
                mov hWin,eax
                invoke PostMessage,hWin,WM_KEYDOWN,VK_RETURN,NULL
                invoke Sleep,5000

                mov @stPos.x,500
                mov @stPos.y,400
                invoke WindowFromPoint,@stPos.x,@stPos.y
                mov hWin,eax
                invoke PostMessage,hWin,WM_KEYDOWN,VK_RETURN,NULL
                invoke Sleep,30000


                mov @stPos.x,500
                mov @stPos.y,400
                invoke WindowFromPoint,@stPos.x,@stPos.y
                mov hWin,eax
                invoke PostMessage,hWin,WM_KEYDOWN,VK_RETURN,NULL
                invoke Sleep,5000


                ;�򸸴��ڷ��͹ر���Ϣ
                mov @stPos.x,500
                mov @stPos.y,400
                invoke WindowFromPoint,@stPos.x,@stPos.y
                mov eax,hParentWin
                mov hWin,eax
                invoke SendMessage,hWin,WM_CLOSE,NULL,NULL 
                invoke Sleep,5000  


                ;invoke GetForegroundWindow
                ;mov hWin,eax       
                ;invoke PostMessage,hWin,WM_KEYDOWN,VK_RETURN,NULL
                ;invoke Sleep,5000

		ret

_OpenFile1	endp
;------------------------------------------
; �������ļ�
;------------------------------------------
_OpenFile2	proc
		ret

_OpenFile2	endp



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





;--------------------
; ��PE�ļ�������
;--------------------
_openFile proc
  local @stOF:OPENFILENAME
  local @hFile,@dwFileSize,@hMapFile,@lpMemory
  local @hFile1,@dwFileSize1,@hMapFile1,@lpMemory1
  local @bufTemp1[10]:byte
  local @dwTemp:dword,@dwTemp1:dword
  local @dwBuffer,@lpDst,@hDstFile
  
@@:        
  ret
_openFile endp



;-------------------
; ���ڳ���
;-------------------
_ProcDlgMain proc uses ebx edi esi hWnd,wMsg,wParam,lParam
  mov eax,wMsg
  .if eax==WM_CLOSE
    invoke FadeOutClose,hWnd
    invoke EndDialog,hWnd,NULL
  .elseif eax==WM_INITDIALOG  ;��ʼ��
    push hWnd
    pop hWinMain
    call _init
    invoke FadeInOpen,hWnd
  .elseif eax==WM_COMMAND     ;�˵�
    mov eax,wParam
    .if eax==IDM_EXIT       ;�˳�
      invoke FadeOutClose,hWnd
      invoke EndDialog,hWnd,NULL 
    .elseif eax==IDM_OPEN   ;���ļ�
        invoke _OpenFile1
    .elseif eax==IDM_1  
        invoke _OpenFile2
    .elseif eax==IDM_2
        ;���ڴ�ӳ���ļ�����һ�ݣ�������϶һ
        invoke _openFile
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



