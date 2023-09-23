;------------------------
; ����ѹ���㷨
; ����
; 2006.2.28
;------------------------
    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc
include    user32.inc
includelib user32.lib
include    kernel32.inc
includelib kernel32.lib

;���ݶ�
    .data
szText     db  'encrypted complete!',0
szSrc      db  13h,15h,0A0h,00h,17h,01h,00h,0ffh
szDst      db  00h,00h,00h,00h,00h,00h,00h,00h

;�����
    .code
jmp start


EncryptionTable db 256 dup(0),0


;-----------------------------------------------------
; ������Χ�� _dwMin ��  _dwMax �����������
; ��������� _dwMin  = ���ޣ� _dwMax = ����
; ���ز����� eax = Rand_Number
; ���ù�ʽ�� Rand_Number = (Rand_Seed * X + Y) mod Z
; ����˵���� (1)�������� GetTickCount 
;                ��ȡ����������ӣ���ʵ��Ӧ���У�����
;                ��ķ������档
;           (2)Ҫ�����������X��Y����֮һ������������
;                ���� X = 23, Y = 7 �����ñ���������棩
;--------------------------------------------------------
_getRandom proc _dwMin:dword, _dwMax:dword
  local @dwRet:dword
  pushad

  ; ȡ����������ӣ���Ȼ�����ñ�ķ�������

  invoke GetTickCount
  mov ecx, 19    ; X = ecx = 19
  mul ecx    ; eax = eax * X
  add eax, 37    ; eax = eax + Y ��Y = 37��
  mov ecx, _dwMax   ; ecx = ����
  sub ecx, _dwMin   ; ecx = ���� - ����
  inc ecx    ; Z = ecx + 1 ���õ��˷�Χ��
  xor edx, edx    ; edx = 0
  div ecx    ; eax = eax mod Z ��������edx���棩
  add edx,_dwMin
  mov @dwRet, edx
  popad
  mov eax, @dwRet   ; eax = Rand_Number
  ret
_getRandom endp

_isExists proc _byte
  local @ret
  pushad
  mov esi,offset EncryptionTable
  mov ecx,0
  .while TRUE
    mov al,byte ptr [esi]
    .if al==0
      mov @ret,FALSE
      .break
    .endif
    mov ebx,_byte
    .if al==bl
      mov @ret,TRUE
      .break
    .endif

    inc esi
    inc ecx
    .if ecx==0ffh
      mov @ret,FALSE
      .break
    .endif
  .endw
  popad
  mov eax,@ret
  ret
_isExists endp

;---------------
; ��ȡһ�������ֽ�
;---------------
_getAByte  proc
  local @ret

  pushad
loc1:
  ; ȡ�����
  invoke _getRandom,1,255
  mov @ret,eax

  ; �ж�������Ƿ��ڻ�����
  invoke _isExists,eax
  .if eax
    jmp loc1
  .endif
  popad
  mov eax,@ret
  ret
_getAByte  endp


;-------------------------------
; ���������õĻ���
;-------------------------------
_encrptAlg proc
  local @temp
  local @dwCount
  pushad

  ;���ɼ��ܻ���
  mov @dwCount,0
  mov edi,offset EncryptionTable
  .while TRUE 
     invoke _getAByte
     mov byte ptr [edi],al
     inc edi
     inc @dwCount
     .break .if @dwCount==0ffh
  .endw
  popad
  ret
_encrptAlg endp


;-------------------------------
; �����㷨�������㷨���ֽ�������
; ��ڲ�����
;   _src:Ҫ���ܵ��ֽ�����ʼ��ַ
;   _dst:���ɼ��ܺ���ֽ�����ʼ��ַ
;   _size:Ҫ���ܵ��ֽ��������
;-------------------------------
_encrptIt  proc _src,_dst,_size
  local @ret
  
  pushad
  ;��ʼ���ջ�����ֽڽ��м���
  mov esi,_src
  mov edi,_dst
  .while TRUE
   mov al,byte ptr [esi]
   xor ebx,ebx
   mov bl,al
   mov al,byte ptr EncryptionTable[ebx]
   mov byte ptr [edi],al

   inc esi
   inc edi
   dec _size
   .break .if _size==0
  .endw
  popad
  ret
_encrptIt endp

start:
    invoke _encrptAlg
    invoke _encrptIt,addr szSrc,addr szDst,8
    nop
    invoke MessageBox,NULL,offset szText,NULL,MB_OK
    invoke ExitProcess,NULL
    end start
