;�����嵥: comiox.asm (˫������ͨ�ų���)
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
        
        mov     dx, 3fbh        ; ��·���ƼĴ�����ַ
        mov     al, 80h         
        out     dx, al          ; DLAB=1
        mov     dx, 3f8h        ; ��λ�����Ĵ���
        mov     al, 120         ; 9600�����ʵĳ�����8λ
        out     dx, al  
        mov     al, 00
        inc     dx              ; ��λ�����Ĵ���
        out     dx, al
        
        mov     al, 00011011b   ; żУ�顢1λֹͣλ, 8λ����λ
        mov     dx, 3fbh        ; ��·���ƼĴ�����ַ
        out     dx, al  
                                
        mov     al, 0           ; ��ֹ�ж�
        mov     dx, 3f9h        ; �ж�����Ĵ�����ַ
        out     dx, al

        mov     al, 03h
        cmp     loopBack, 0
        jz      NotLoopBack
        or      al, 10h         ; Loopback
NotLoopBack:
        mov     dx, 3fch        ; MODEM���ƼĴ�����ַ
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


