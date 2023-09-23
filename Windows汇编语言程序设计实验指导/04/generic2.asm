;程序清单: generic2.asm(对话框及窗口控件)
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
            ; 是否已经存在标题为"Chat 1"的窗口?
            .if  eax == NULL
                ; 如果不存在，设定本对话框的标题为"Chat 1"
                invoke  lstrcpy,addr szMyTitle,addr szChat1
                invoke  lstrcpy,addr szOtherTitle,addr szChat2
            .else
                ; 如果已存在，设定本对话框的标题为"Chat 2"
                invoke  lstrcpy,addr szMyTitle,addr szChat2
                invoke  lstrcpy,addr szOtherTitle,addr szChat1
            .endif
            invoke  SetWindowText,hWinMain,addr szMyTitle
            ; 设定本对话框的图标
            invoke  LoadIcon,hInstance,ICO_MAIN
            invoke  SendMessage,hWnd,WM_SETICON,ICON_BIG,eax
            ; 用户名编辑框允许最多输入11个字符
            invoke  SendDlgItemMessage,hWinMain,IDC_USER,
                                       EM_SETLIMITTEXT,11,0
            ; 发送文本编辑框允许最多输入250个字符
            invoke  SendDlgItemMessage,hWinMain,IDC_TEXT,
                                       EM_SETLIMITTEXT,250,0
        .elseif eax ==  WM_COMMAND
            mov     eax,wParam
            ; 输入用户名后，允许"Login"按钮
            .if ax == IDC_USER
                invoke  GetDlgItemText,hWinMain,IDC_USER,
                                       addr szUserName,sizeof szUserName
                invoke  GetDlgItem,hWinMain,IDC_LOGIN
                .if szUserName && (bLogin == 0)
                    invoke  EnableWindow,eax,TRUE
                .else
                    invoke  EnableWindow,eax,FALSE
                .endif
            ; 输入聊天语句后，允许"Send"按钮
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
                ; Login后，禁止Login按钮, 允许Logout按钮、发送文本编辑框
                invoke  GetDlgItem,hWinMain,IDC_LOGIN
                invoke  EnableWindow,eax,FALSE
                invoke  GetDlgItem,hWinMain,IDC_LOGOUT
                invoke  EnableWindow,eax,TRUE
                invoke  GetDlgItem,hWinMain,IDC_TEXT
                invoke  EnableWindow,eax,TRUE
            .elseif ax ==   IDC_LOGOUT
                mov     bLogin, 0
                ; 允许Login按钮, 禁止Logout按钮、发送文本编辑框、发送按钮
                invoke  GetDlgItem,hWinMain,IDC_LOGIN
                invoke  EnableWindow,eax,TRUE
                invoke  GetDlgItem,hWinMain,IDC_LOGOUT
                invoke  EnableWindow,eax,FALSE
                invoke  GetDlgItem,hWinMain,IDC_TEXT
                invoke  EnableWindow,eax,FALSE
                invoke  GetDlgItem,hWinMain,IDOK
                invoke  EnableWindow,eax,FALSE
            .elseif ax ==   IDOK
                ; 构造一个字符串，包括用户名和待发送的文本
                invoke  wsprintfA,addr @szBuffer,addr szFmt,
                                  addr szUserName,addr szText
                ; 将字符串添加到列表框的第1行
                invoke  SendDlgItemMessage,hWinMain,IDC_INFO,
                                           LB_INSERTSTRING,0,addr @szBuffer
                ; 查找到另一个对话框窗口
                invoke  FindWindow,NULL,addr szOtherTitle
                mov     hwndOther,eax
                ; 将字符串添加到另一个对话框的列表框的第1行
                invoke  SendDlgItemMessage,hwndOther,IDC_INFO,
                                           LB_INSERTSTRING,0,addr @szBuffer
                ; 清除发送文本编辑框中的内容
                invoke  SetDlgItemText,hWinMain,IDC_TEXT,NULL
                ; 将输入焦点设置到发送文本编辑框上
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
