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
szClassNameBuf db   512 dup (?)  ;不要更改大小
szWndTextBuf   db   512 dup (?)  ;不要更改大小
szName         db   '安装 - Photo',256 dup(0)

szBuffer       db   1024 dup(0) 


szMainClassNameBuf  db  512 dup(?)
szMainWndTextBuf    db  512 dup(?)
hParentWin          dd  ?   ;父窗口
hWin                dd  ?   ;当前窗口
hSubWin             dd  ?
dwCount             dd  ?

@stPos             POINT   <?>

.code

;-------------------------------------------
; 窗口枚举函数
;-------------------------------------------
_EnumProc proc hTopWinWnd:DWORD,value:DWORD
      .if hTopWinWnd!=NULL
        invoke GetClassName,hTopWinWnd,addr szClassNameBuf,\  ;类名
            sizeof szClassNameBuf
        invoke GetWindowText,hTopWinWnd,addr szWndTextBuf,\  ;窗口名
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
      mov eax,hTopWinWnd ;当窗口句柄为空时结束
      ret 
_EnumProc endp


;------------------------------------------
; 向窗口发送消息
;------------------------------------------
_doIt	proc
                invoke EnumWindows,addr _EnumProc,NULL  ;枚举顶层窗口
                mov eax,hWin
                mov hParentWin,eax
 

                invoke Sleep,10000   ;先休眠10秒钟


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


                ;向父窗口发送关闭消息
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



