;------------------------
; DLL��̬���ӿ�
; �ṩ�˼�������Ч��
; ����
; 2010.6.27
;------------------------
    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc
include    user32.inc
includelib user32.lib
include    kernel32.inc
includelib kernel32.lib

MAX_XYSTEPS equ 50
DELAY_VALUE equ 50   ; ����Ч��ʹ�õĲ���
X_STEP_SIZE equ 10
Y_STEP_SIZE equ 9
X_START_SIZE equ 20
Y_START_SIZE equ 10

LMA_ALPHA equ 2
LMA_COLORKEY equ 1
WS_EX_LAYERED equ 80000h

;��������
_QLFadeInOpen typedef proto :dword
;������������   
_ApiFadeInOpen  typedef ptr _QLFadeInOpen


_QLFadeOutClose        typedef proto :dword
_ApiFadeOutClose       typedef ptr _QLFadeOutClose

;���ݶ�
    .data
dwCount  dd  ?
Value    dd  ?
Xsize    dd  ?
Ysize    dd  ?
sWth     dd  ?
sHth     dd  ?
Xplace   dd  ?
Yplace   dd  ?
counts   dd  ?
pSLWA    dd  ?
User32   db  'user32.dll',0
SLWA     db  'SetLayeredWindowAttributes',0


realDLL  db  'c:\windows\winResult.dll',0
hDLL     dd  ?
szFadeIn db  'FadeInOpen',0
szFadeOut db 'FadeOutClose',0
szHello  db  'HelloWorldPE',0

_fadeOutClose _ApiFadeOutClose ?
_fadeInOpen   _ApiFadeInOpen   ?


;�����
    .code
;------------------
; DLL���
;------------------
DllEntry   proc  _hInstance,_dwReason,_dwReserved
        invoke LoadLibrary,offset realDLL
        mov hDLL,eax
        invoke GetProcAddress,hDLL,addr szFadeIn
        mov _fadeInOpen,eax
        invoke GetProcAddress,hDLL,addr szFadeOut
        mov _fadeOutClose,eax
        
        mov eax,TRUE
        ret
DllEntry   endp

;-------------------------------
;  ˽�к���
;-------------------------------
TopXY proc wDim:DWORD,sDim:DWORD
     shr sDim,1 
     shr wDim,1
     mov eax,wDim
     sub sDim,eax
     mov eax,sDim
     ret
TopXY endp
;-----------------------------------------------------------
; ���ڶ�������Ч��
;-----------------------------------------------------------
AnimateOpen proc hWin:DWORD

    LOCAL Rct:RECT

    invoke GetWindowRect,hWin,ADDR Rct
    mov Xsize,X_START_SIZE
    mov Ysize,Y_START_SIZE
    invoke GetSystemMetrics,SM_CXSCREEN
    mov sWth,eax
    invoke TopXY,Xsize,eax
    mov Xplace,eax
    invoke GetSystemMetrics,SM_CYSCREEN
    mov sHth,eax
    invoke TopXY,Ysize,eax
    mov Yplace,eax
    mov counts,MAX_XYSTEPS
aniloop:
    invoke MoveWindow,hWin,Xplace,Yplace,Xsize,Ysize,FALSE
    invoke ShowWindow,hWin,SW_SHOWNA
    invoke Sleep,DELAY_VALUE
    invoke ShowWindow,hWin,SW_HIDE
    add Xsize,X_STEP_SIZE
    add Ysize,Y_STEP_SIZE
    invoke TopXY,Xsize,sWth
    mov Xplace,eax
    invoke TopXY,Ysize,sHth
    mov Yplace,eax
    dec counts
    jnz aniloop
    mov eax,Rct.left
    mov ecx,Rct.right
    sub ecx,eax
    mov Xsize,ecx
    mov eax,Rct.top
    mov ecx,Rct.bottom
    sub ecx,eax
    mov Ysize,ecx
    invoke TopXY,Xsize,sWth
    mov Xplace,eax
    invoke TopXY,Ysize,sHth
    mov Yplace,eax
    invoke MoveWindow,hWin,Xplace,Yplace,Xsize,Ysize,TRUE 
    invoke ShowWindow,hWin,SW_SHOW
    ret 
AnimateOpen endp


;-------------------------
; ���ڶ����˳�Ч��
;-------------------------
AnimateClose proc hWin:DWORD

    LOCAL Rct:RECT


    invoke ShowWindow,hWin,SW_HIDE
    invoke GetWindowRect,hWin,ADDR Rct
    mov eax,Rct.left
    mov ecx,Rct.right
    sub ecx,eax
    mov Xsize,ecx
    mov eax,Rct.top
    mov ecx,Rct.bottom
    sub ecx,eax
    mov Ysize,ecx
    invoke GetSystemMetrics,SM_CXSCREEN
    mov sWth,eax
    invoke TopXY,Xsize,eax
    mov Xplace,eax
    invoke GetSystemMetrics,SM_CYSCREEN
    mov sHth,eax
    invoke TopXY,Ysize,eax
    mov Yplace,eax
    mov counts,MAX_XYSTEPS
aniloop:
    invoke MoveWindow,hWin,Xplace,Yplace,Xsize,Ysize,FALSE 
    invoke ShowWindow,hWin,SW_SHOWNA
    invoke Sleep,DELAY_VALUE
    invoke ShowWindow,hWin,SW_HIDE
    sub Xsize,X_STEP_SIZE
    sub Ysize,Y_STEP_SIZE
    invoke TopXY,Xsize,sWth
    mov Xplace,eax
    invoke TopXY,Ysize,sHth
    mov Yplace,eax
    dec counts
    jnz aniloop

    ret 

AnimateClose endp

;--------------------------------------------
; ���ڵ���Ч�������ٳֵ�API����
;--------------------------------------------
FadeInOpen proc hWin:DWORD
    invoke MessageBox,NULL,addr szHello,\ ;���벹��
                            NULL,MB_OK    
    invoke _fadeInOpen,hWin
    ret 

FadeInOpen endp

;--------------------------------------------
; ���ڵ���Ч������������2000/XP���ϲ���ϵͳ
;--------------------------------------------
FadeOutClose proc hWin:DWORD

    invoke GetWindowLongA,hWin,GWL_EXSTYLE
    or eax,WS_EX_LAYERED
    invoke SetWindowLongA,hWin,GWL_EXSTYLE,eax
    invoke GetModuleHandleA,ADDR User32
    invoke GetProcAddress,eax,ADDR SLWA
    mov pSLWA,eax
    push LMA_ALPHA
    push 255
    push 0
    push hWin
    call pSLWA
    mov Value,255
doloop:
    push LMA_COLORKEY + LMA_ALPHA
    push Value
    push Value
    push hWin
    call pSLWA
    invoke Sleep,DELAY_VALUE
    sub Value,15
    cmp Value,0
    jne doloop
    ret
FadeOutClose endp

      End DllEntry







