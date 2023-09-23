.386
.model flat,stdcall
option casemap:none

include    windows.inc
include    user32.inc
includelib user32.lib
include    kernel32.inc
includelib kernel32.lib
include    comdlg32.inc
includelib comdlg32.lib


ICO_MAIN equ 1000
DLG_MAIN equ 1000
IDC_INFO equ 1001
IDM_MAIN equ 2000
IDM_OPEN equ 2001
IDM_EXIT equ 2002
IDM_1    equ 4000
IDM_2    equ 4001
IDM_3    equ 4002

.data
hInstance   dd ?   ; ���̾��
hRichEdit   dd ?
hWinMain    dd ?   ; �������ھ��
hWinEdit    dd ?   ; ���ı�����
totalSize   dd ?   ; �ļ���С
lpMemory    dd ?   ; �ڴ�ӳ���ļ����ڴ����ʼλ��
szFileName  db MAX_PATH dup(?)               ;Ҫ�򿪵��ļ�·����������

lpServicesBuffer         db 100 dup(0)   ;��������
bufDisplay               db 50 dup(0)      ;������ASCII���ַ���ʾ
szBuffer                 db 200 dup(0)       ;��ʱ������
lpszFilterFmt4           db  '%08x  ',0
lpszManyBlanks           db  '  ',0
lpszBlank                db  ' ',0
lpszSplit                db  '-',0
lpszScanFmt              db  '%02x',0
lpszHexArr               db  '0123456789ABCDEF',0
lpszReturn               db  0dh,0ah,0
lpszDoubleReturn         db  0dh,0ah,0dh,0ah,0
lpszOut1                 db  '�ļ���С��%d',0
dwStop                   dd  0
.const
szDllEdit   db 'RichEd20.dll',0
szClassEdit db 'RichEdit20A',0
szFont      db '����',0
szExtPe     db 'PE File',0,'*.exe;*.dll;*.scr;*.fon;*.drv',0
            db 'All Files(*.*)',0,'*.*',0,0
szErr       db '�ļ���ʽ����!',0
szErrFormat db '�����ļ�ʱ���ִ���!',0


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
  mov @stCf.yHeight,14*1440/96
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


;--------------------
; ��PE�ļ�������
;--------------------
_openFile proc
  local @stOF:OPENFILENAME
  local @hFile,@hMapFile
  local @bufTemp1   ; ʮ�������ֽ���
  local @bufTemp2   ; ��һ��
  local @dwCount    ; ��������16�����¼�
  local @dwCount1   ; ��ַ˳��
  local @dwBlanks   ; ���һ�пո���

  invoke RtlZeroMemory,addr @stOF,sizeof @stOF
  mov @stOF.lStructSize,sizeof @stOF
  push hWinMain
  pop @stOF.hwndOwner
  mov @stOF.lpstrFilter,offset szExtPe
  mov @stOF.lpstrFile,offset szFileName
  mov @stOF.nMaxFile,MAX_PATH
  mov @stOF.Flags,OFN_PATHMUSTEXIST or OFN_FILEMUSTEXIST
  invoke GetOpenFileName,addr @stOF  ;���û�ѡ��򿪵��ļ�
  .if !eax
    jmp @F
  .endif
  invoke CreateFile,addr szFileName,GENERIC_READ,\
         FILE_SHARE_READ or FILE_SHARE_WRITE,NULL,\
         OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE,NULL
  .if eax!=INVALID_HANDLE_VALUE
    mov @hFile,eax
    invoke GetFileSize,eax,NULL     ;��ȡ�ļ���С
    mov totalSize,eax

    .if eax
      invoke CreateFileMapping,@hFile,\  ;�ڴ�ӳ���ļ�
             NULL,PAGE_READONLY,0,0,NULL
      .if eax
        mov @hMapFile,eax
        invoke MapViewOfFile,eax,\
               FILE_MAP_READ,0,0,0
        .if eax
          mov lpMemory,eax              ;����ļ����ڴ��ӳ����ʼλ��
          assume fs:nothing
          push ebp
          push offset _ErrFormat
          push offset _Handler
          push fs:[0]
          mov fs:[0],esp

          ;��ʼ�����ļ�

          ;��������ʼ��
          invoke RtlZeroMemory,addr @bufTemp1,10
          invoke RtlZeroMemory,addr @bufTemp2,20
          invoke RtlZeroMemory,addr lpServicesBuffer,100
          invoke RtlZeroMemory,addr bufDisplay,50

          mov @dwCount,1
          mov esi,lpMemory
          mov edi,offset bufDisplay
 
          ; ����һ��д��lpServicesBuffer
          mov @dwCount1,0
          invoke wsprintf,addr @bufTemp2,addr lpszFilterFmt4,@dwCount1
          invoke lstrcat,addr lpServicesBuffer,addr @bufTemp2

          ;�����һ�еĿո�����16�����ȣ�16��*3
          xor edx,edx
          mov eax,totalSize
          mov ecx,16
          div ecx
          mov eax,16
          sub eax,edx
          xor edx,edx
          mov ecx,3
          mul ecx
          mov @dwBlanks,eax

          ;invoke wsprintf,addr szBuffer,addr lpszOut1,totalSize
          ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK

          .while TRUE
             .if totalSize==0  ;���һ��
                ;���ո�
                 .while TRUE
                     .break .if @dwBlanks==0
                     invoke lstrcat,addr lpServicesBuffer,addr lpszBlank
                     dec @dwBlanks
                 .endw
                 ;�ڶ�����������м�Ŀո�
                 invoke lstrcat,addr lpServicesBuffer,addr lpszManyBlanks  
                 ;����������
                 invoke lstrcat,addr lpServicesBuffer,addr bufDisplay
                 ;�س����з���
                 invoke lstrcat,addr lpServicesBuffer,addr lpszReturn
                 .break
             .endif
             ;��al����ɿ�����ʾ��ascii���ַ�,ע�ⲻ���ƻ�al��ֵ
             mov al,byte ptr [esi]
             .if al>20h && al<7eh
                mov ah,al
             .else        ;�������ASCII��ֵ������ʾ��.��
                mov ah,2Eh
             .endif
             ;д������е�ֵ
             mov byte ptr [edi],ah

            ;win2k��֧��al�ֽڼ��𣬾������³����޹ʽ�����
            ;��������·������
            ;invoke wsprintf,addr @bufTemp1,addr lpszFilterFmt3,al
                         
             mov bl,al
             xor edx,edx
             xor eax,eax
             mov al,bl
             mov cx,16
             div cx   ;�����λ��al�У�������dl��

             ;����ֽڵ�ʮ�������ַ�����@bufTemp1�У������ڣ���7F \0��
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

             ; ���ڶ���д��lpServicesBuffer
             invoke lstrcat,addr lpServicesBuffer,addr @bufTemp1

             .if @dwCount==16   ;�ѵ�16���ֽڣ�
                ;�ڶ�����������м�Ŀո�
                invoke lstrcat,addr lpServicesBuffer,addr lpszManyBlanks
                ;��ʾ�������ַ� 
                invoke lstrcat,addr lpServicesBuffer,addr bufDisplay        
                ;�س�����
                invoke lstrcat,addr lpServicesBuffer,addr lpszReturn 

                ;д������
                invoke _appendInfo,addr lpServicesBuffer
                invoke RtlZeroMemory,addr lpServicesBuffer,100           

                .break .if dwStop==1

                ;��ʾ��һ�еĵ�ַ
                inc @dwCount1
                invoke wsprintf,addr @bufTemp2,addr lpszFilterFmt4,\
                                                            @dwCount1
                invoke lstrcat,addr lpServicesBuffer,addr @bufTemp2
                dec @dwCount1

                mov @dwCount,0
                invoke RtlZeroMemory,addr bufDisplay,50
                mov edi,offset bufDisplay
                ;Ϊ���ܺͺ����inc edi���ʹedi��ȷ��λ��bufDisplay��
                dec edi 
             .endif

             dec totalSize
             inc @dwCount
             inc esi
             inc edi
             inc @dwCount1
          .endw

          ;������һ��
          invoke _appendInfo,addr lpServicesBuffer

          
          ;�����ļ�����

          jmp _ErrorExit
 
_ErrFormat:
          invoke MessageBox,hWinMain,offset szErrFormat,NULL,MB_OK
_ErrorExit:
          pop fs:[0]
          add esp,0ch
          invoke UnmapViewOfFile,lpMemory
        .endif
        invoke CloseHandle,@hMapFile
      .endif
      invoke CloseHandle,@hFile
    .endif
  .endif
@@:        
  ret
_openFile endp
;-------------------
; ���ڳ���
;-------------------
_ProcDlgMain proc uses ebx edi esi hWnd,wMsg,wParam,lParam
  local @sClient

  mov eax,wMsg
  .if eax==WM_CLOSE
    invoke EndDialog,hWnd,NULL
  .elseif eax==WM_INITDIALOG  ;��ʼ��
    push hWnd
    pop hWinMain
    call _init
  .elseif eax==WM_COMMAND  ;�˵�
    mov eax,wParam
    .if eax==IDM_EXIT       ;�˳�
      invoke EndDialog,hWnd,NULL 
    .elseif eax==IDM_OPEN   ;���ļ�
      mov dwStop,0
      invoke CreateThread,NULL,0,addr _openFile,addr @sClient,0,NULL
      ;invoke _openFile
    .elseif eax==IDM_1 
      mov dwStop,1 
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
  invoke LoadLibrary,offset szDllEdit
  mov hRichEdit,eax
  invoke GetModuleHandle,NULL
  mov hInstance,eax
  invoke DialogBoxParam,hInstance,\
         DLG_MAIN,NULL,offset _ProcDlgMain,NULL
  invoke FreeLibrary,hRichEdit
  invoke ExitProcess,NULL
  end start
