.386
.model flat,stdcall
option casemap:none

include    windows.inc
include    user32.inc
include    kernel32.inc
include    winResult.inc

includelib user32.lib
includelib kernel32.lib
includelib winResult.lib


.data


szNewBuffer      db  2048 dup(?)
szClassNameBuf db   512 dup (?)  ;��Ҫ���Ĵ�С
szWndTextBuf   db   512 dup (?)  ;��Ҫ���Ĵ�С
szName         db   '��װ - Photo',256 dup(0)

szBuffer       db   1024 dup(0) 


szMainClassNameBuf  db  512 dup(?)
szMainWndTextBuf    db  512 dup(?)
hParentWin          dd  ?   ;������
hWin                dd  ?   ;��ǰ����
hSubWin             dd  ?
dwCount             dd  ?

@stPos             POINT   <?>

.code

;-------------------------------------------
; ����ö�ٺ���
;-------------------------------------------
_EnumProc proc hTopWinWnd:DWORD,value:DWORD
      .if hTopWinWnd!=NULL
        invoke GetClassName,hTopWinWnd,addr szClassNameBuf,\  ;����
            sizeof szClassNameBuf
        invoke GetWindowText,hTopWinWnd,addr szWndTextBuf,\  ;������
            sizeof szWndTextBuf

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


;------------------------------------------
; �򴰿ڷ�����Ϣ
;------------------------------------------
_doIt	proc
                invoke EnumWindows,addr _EnumProc,NULL  ;ö�ٶ��㴰��
                mov eax,hWin
                mov hParentWin,eax
 

                invoke Sleep,10000   ;������10����


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

@ret:
		ret

_doIt	endp

start:
  invoke _doIt
  invoke ExitProcess,NULL
  end start



