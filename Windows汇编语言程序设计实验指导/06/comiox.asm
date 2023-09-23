;程序清单: comiox.asm (双机串行通信程序)
.model small

.data
sendChar        db      0
recvChar        db      0
loopBack        db      0
szRecvMessage	db		' ', 0dh,0ah,'$'
szSendMessage	db		' ', 0dh,0ah,'$'

.code

ReadKb  proc
        mov		ah, 1
        int		16h
        cmp     ax, 0
        jz      NoKey

        mov		ah, 0
        int		16h
        cmp     al, 0
        jz      NoKey

        cmp     al, 0dh
        jz      NewLine
        
        cmp     al, 20h
        jb      NoKey

        mov     sendChar, al
        
        ret
NewLine:
        mov     sendChar, al


NoKey:
        ret
ReadKb  endp

SndChar proc
        mov     dx, 3fdh
        in      al, dx
        cmp     al, 0ffh
        jz      SndBusy
        test    al, 20h
        jz      SndBusy
        mov     al, sendChar
        mov     dx, 3f8h
        out     dx, al
        mov     sendChar, 0

		mov		szSendMessage, al
        mov		ah,9
        lea		dx, szSendMessage
        int		21h
        
SndBusy:
        ret
SndChar endp

RcvChar proc
        mov     dx, 3fdh
        in      al, dx
        test    al, 01h
        jz      NoChar
        test    al, 0eh
        jnz     NoChar

        mov     dx, 3f8h
        in      al, dx

        mov     recvChar, al
        
		mov		szRecvMessage, al
        mov		ah,9
        lea		dx, szRecvMessage
        int		21h
        
        ret
NoChar:
        ret
RcvChar endp

InitCom proc
        mov     dx, 3fdh
        in      al, dx
        mov     al, 0
        out     dx, al
        
        mov     dx, 3fbh        ; 线路控制寄存器地址
        mov     al, 80h         
        out     dx, al          ; DLAB=1
        mov     dx, 3f8h        ; 低位除数寄存器
        mov     al, 120         ; 9600波特率的除数低8位
        out     dx, al  
        mov     al, 00
        inc     dx              ; 高位除数寄存器
        out     dx, al
        
        mov     al, 00011011b   ; 偶校验、1位停止位, 8位数据位
        mov     dx, 3fbh        ; 线路控制寄存器地址
        out     dx, al  
                                
        mov     al, 0           ; 禁止中断
        mov     dx, 3f9h        ; 中断允许寄存器地址
        out     dx, al

        mov     al, 03h
        cmp     loopBack, 0
        jz      NotLoopBack
        or      al, 10h         ; Loopback
NotLoopBack:
        mov     dx, 3fch        ; MODEM控制寄存器地址
        out     dx, al

        ret
InitCom endp

main    proc

        mov     loopBack, 1

        call    InitCom
        
ReadLoop:
        
        cmp     sendChar, 0
        jz      GetChar1
        
        call    SndChar
        jmp     ReadCom2
GetChar1:
        call    ReadKb
ReadCom2:
        call    RcvChar
        
        jmp     ReadLoop
ExitLoop:
		
        ret
main    endp
end 	main


