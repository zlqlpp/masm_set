;�����嵥: generic2.asm(�Ի��򼰴��ڿؼ�)
.386
.model flat, stdcall
option casemap :none   ; case sensitive
include     windows.inc
include     user32.inc
include     kernel32.inc
includelib  user32.lib
includelib  kernel32.lib
ICO_MAIN    equ 1000
DLG_MAIN    equ 2000
IDC_USER    equ 2001
IDC_LOGIN   equ 2002
IDC_LOGOUT  equ 2003
IDC_INFO    equ 2004
IDC_TEXT    equ 2005
.data
hInstance       dword   ?
hWinMain        dword   ?
bLogin          dword   0
szUserName      byte    12 dup (?)
szText          byte    256 dup (?)
szMyTitle       byte    20 dup (?)
szOtherTitle    byte    20 dup (?)
szFmt           byte    '[%s]: %s',0
szChat1         byte    'Chat 1',0
szChat2         byte    'Chat 2',0
hwndOther       dword   ?
.code
_ProcDlgMain    proc    uses ebx edi esi hWnd,wMsg,wParam,lParam
local   @szBuffer[512]:byte
        mov     eax,wMsg
        .if eax ==  WM_INITDIALOG
            push    hWnd
            pop     hWinMain
            invoke  FindWindow,NULL,addr szChat1
            ; �Ƿ��Ѿ����ڱ���Ϊ"Chat 1"�Ĵ���?
            .if  eax == NULL
                ; ��������ڣ��趨���Ի���ı���Ϊ"Chat 1"
                invoke  lstrcpy,addr szMyTitle,addr szChat1
                invoke  lstrcpy,addr szOtherTitle,addr szChat2
            .else
                ; ����Ѵ��ڣ��趨���Ի���ı���Ϊ"Chat 2"
                invoke  lstrcpy,addr szMyTitle,addr szChat2
                invoke  lstrcpy,addr szOtherTitle,addr szChat1
            .endif
            invoke  SetWindowText,hWinMain,addr szMyTitle
            ; �趨���Ի����ͼ��
            invoke  LoadIcon,hInstance,ICO_MAIN
            invoke  SendMessage,hWnd,WM_SETICON,ICON_BIG,eax
            ; �û����༭�������������11���ַ�
            invoke  SendDlgItemMessage,hWinMain,IDC_USER,
                                       EM_SETLIMITTEXT,11,0
            ; �����ı��༭�������������250���ַ�
            invoke  SendDlgItemMessage,hWinMain,IDC_TEXT,
                                       EM_SETLIMITTEXT,250,0
        .elseif eax ==  WM_COMMAND
            mov     eax,wParam
            ; �����û���������"Login"��ť
            .if ax == IDC_USER
                invoke  GetDlgItemText,hWinMain,IDC_USER,
                                       addr szUserName,sizeof szUserName
                invoke  GetDlgItem,hWinMain,IDC_LOGIN
                .if szUserName && (bLogin == 0)
                    invoke  EnableWindow,eax,TRUE
                .else
                    invoke  EnableWindow,eax,FALSE
                .endif
            ; ����������������"Send"��ť
            .elseif ax ==   IDC_TEXT
                invoke  GetDlgItemText,hWinMain,IDC_TEXT,
                                       addr szText,sizeof szText
                invoke  GetDlgItem,hWinMain,IDOK
                .if szText
                    invoke  EnableWindow,eax,TRUE
                .else
                    invoke  EnableWindow,eax,FALSE
                .endif
            .elseif ax ==   IDC_LOGIN
                mov     bLogin, 1
                ; Login�󣬽�ֹLogin��ť, ����Logout��ť�������ı��༭��
                invoke  GetDlgItem,hWinMain,IDC_LOGIN
                invoke  EnableWindow,eax,FALSE
                invoke  GetDlgItem,hWinMain,IDC_LOGOUT
                invoke  EnableWindow,eax,TRUE
                invoke  GetDlgItem,hWinMain,IDC_TEXT
                invoke  EnableWindow,eax,TRUE
            .elseif ax ==   IDC_LOGOUT
                mov     bLogin, 0
                ; ����Login��ť, ��ֹLogout��ť�������ı��༭�򡢷��Ͱ�ť
                invoke  GetDlgItem,hWinMain,IDC_LOGIN
                invoke  EnableWindow,eax,TRUE
                invoke  GetDlgItem,hWinMain,IDC_LOGOUT
                invoke  EnableWindow,eax,FALSE
                invoke  GetDlgItem,hWinMain,IDC_TEXT
                invoke  EnableWindow,eax,FALSE
                invoke  GetDlgItem,hWinMain,IDOK
                invoke  EnableWindow,eax,FALSE
            .elseif ax ==   IDOK
                ; ����һ���ַ����������û����ʹ����͵��ı�
                invoke  wsprintfA,addr @szBuffer,addr szFmt,
                                  addr szUserName,addr szText
                ; ���ַ�����ӵ��б��ĵ�1��
                invoke  SendDlgItemMessage,hWinMain,IDC_INFO,
                                           LB_INSERTSTRING,0,addr @szBuffer
                ; ���ҵ���һ���Ի��򴰿�
                invoke  FindWindow,NULL,addr szOtherTitle
                mov     hwndOther,eax
                ; ���ַ�����ӵ���һ���Ի�����б��ĵ�1��
                invoke  SendDlgItemMessage,hwndOther,IDC_INFO,
                                           LB_INSERTSTRING,0,addr @szBuffer
                ; ��������ı��༭���е�����
                invoke  SetDlgItemText,hWinMain,IDC_TEXT,NULL
                ; �����뽹�����õ������ı��༭����
                invoke  GetDlgItem,hWinMain,IDC_TEXT
                invoke  SetFocus,eax
            .else
                mov     eax,FALSE
                ret
            .endif
        .elseif eax ==  WM_CLOSE
            invoke  EndDialog,hWinMain,NULL
        .else
            mov     eax,FALSE
            ret
        .endif
        mov     eax,TRUE
        ret
_ProcDlgMain    endp

_start:
        invoke  GetModuleHandle,NULL
        mov     hInstance,eax
        invoke  DialogBoxParam,eax,DLG_MAIN,NULL,offset _ProcDlgMain,0
        invoke  ExitProcess,NULL
end     _start
