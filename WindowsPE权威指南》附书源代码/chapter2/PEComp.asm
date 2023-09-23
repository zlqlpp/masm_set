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


hProcessModuleTable dd ?


szFileName           db MAX_PATH dup(?)
szFileNameOpen1      db MAX_PATH dup(0)
szFileNameOpen2      db MAX_PATH dup(0)


szResultColName1 db  'PE数据结构相关字段',0
szResultColName2 db  '文件1的值(H)',0
szResultColName3 db  '文件2的值(H)',0
szBuffer         db  256 dup(0),0
bufTemp1         db  200 dup(0),0
bufTemp2         db  200 dup(0),0
szFilter1        db  'Excutable Files',0,'*.exe;*.com',0
                 db  0

.const
szDllEdit   db 'RichEd20.dll',0
szClassEdit db 'RichEdit20A',0
szFont      db '宋体',0
szExtPe     db 'PE File',0,'*.exe;*.dll;*.scr;*.fon;*.drv',0
            db 'All Files(*.*)',0,'*.*',0,0
szErr       db '文件格式错误!',0
szErrFormat db '这个文件不是PE格式的文件!',0
szSuccess   db '恭喜你，程序执行到这里是成功的。',0
szNotFound  db '无法查找',0


szRec1      db 'IMAGE_DOS_HEADER.e_magic',0
szRec2      db 'IMAGE_DOS_HEADER.e_cblp',0
szRec3      db 'IMAGE_DOS_HEADER.e_cp',0
szRec4      db 'IMAGE_DOS_HEADER.e_crlc',0
szRec5      db 'IMAGE_DOS_HEADER.e_cparhdr',0
szRec6      db 'IMAGE_DOS_HEADER.e_minalloc',0
szRec7      db 'IMAGE_DOS_HEADER.e_maxalloc',0
szRec8      db 'IMAGE_DOS_HEADER.e_ss',0
szRec9      db 'IMAGE_DOS_HEADER.e_sp',0
szRec10     db 'IMAGE_DOS_HEADER.e_csum',0
szRec11     db 'IMAGE_DOS_HEADER.e_ip',0
szRec12     db 'IMAGE_DOS_HEADER.e_cs',0
szRec13     db 'IMAGE_DOS_HEADER.e_lfarlc',0
szRec14     db 'IMAGE_DOS_HEADER.e_ovno',0
szRec15     db 'IMAGE_DOS_HEADER.e_res',0
szRec16     db 'IMAGE_DOS_HEADER.e_oemid',0
szRec17     db 'IMAGE_DOS_HEADER.e_oeminfo',0
szRec18     db 'IMAGE_DOS_HEADER.e_res2',0
szRec19     db 'IMAGE_DOS_HEADER.e_lfanew',0

szRec20     db 'IMAGE_NT_HEADERS.Signature',0

szRec21     db 'IMAGE_FILE_HEADER.Machine',0
szRec22     db 'IMAGE_FILE_HEADER.NumberOfSections',0
szRec23     db 'IMAGE_FILE_HEADER.TimeDateStamp',0
szRec24     db 'IMAGE_FILE_HEADER.PointerToSymbolTable',0
szRec25     db 'IMAGE_FILE_HEADER.NumberOfSymbols',0
szRec26     db 'IMAGE_FILE_HEADER.SizeOfOptionalHeader',0
szRec27     db 'IMAGE_FILE_HEADER.Characteristics',0

szRec28     db 'IMAGE_OPTIONAL_HEADER32.Magic',0
szRec29     db 'IMAGE_OPTIONAL_HEADER32.MajorLinkerVersion',0
szRec30     db 'IMAGE_OPTIONAL_HEADER32.MinorLinkerVersion',0
szRec31     db 'IMAGE_OPTIONAL_HEADER32.SizeOfCode',0
szRec32     db 'IMAGE_OPTIONAL_HEADER32.SizeOfInitializedData',0
szRec33     db 'IMAGE_OPTIONAL_HEADER32.SizeOfUninitializedData',0
szRec34     db 'IMAGE_OPTIONAL_HEADER32.AddressOfEntryPoint',0
szRec35     db 'IMAGE_OPTIONAL_HEADER32.BaseOfCode',0
szRec36     db 'IMAGE_OPTIONAL_HEADER32.BaseOfData',0
szRec37     db 'IMAGE_OPTIONAL_HEADER32.ImageBase',0
szRec38     db 'IMAGE_OPTIONAL_HEADER32.SectionAlignment',0
szRec39     db 'IMAGE_OPTIONAL_HEADER32.FileAlignment',0
szRec40     db 'IMAGE_OPTIONAL_HEADER32.MajorOperatingSystemVersion',0
szRec41     db 'IMAGE_OPTIONAL_HEADER32.MinorOperatingSystemVersion',0
szRec42     db 'IMAGE_OPTIONAL_HEADER32.MajorImageVersion',0
szRec43     db 'IMAGE_OPTIONAL_HEADER32.MinorImageVersion',0
szRec44     db 'IMAGE_OPTIONAL_HEADER32.MajorSubsystemVersion',0
szRec45     db 'IMAGE_OPTIONAL_HEADER32.MinorSubsystemVersion',0
szRec46     db 'IMAGE_OPTIONAL_HEADER32.Win32VersionValue',0
szRec47     db 'IMAGE_OPTIONAL_HEADER32.SizeOfImage',0
szRec48     db 'IMAGE_OPTIONAL_HEADER32.SizeOfHeaders',0
szRec49     db 'IMAGE_OPTIONAL_HEADER32.CheckSum',0
szRec50     db 'IMAGE_OPTIONAL_HEADER32.Subsystem',0
szRec51     db 'IMAGE_OPTIONAL_HEADER32.DllCharacteristics',0
szRec52     db 'IMAGE_OPTIONAL_HEADER32.SizeOfStackReserve',0
szRec53     db 'IMAGE_OPTIONAL_HEADER32.SizeOfStackCommit',0
szRec54     db 'IMAGE_OPTIONAL_HEADER32.SizeOfHeapReserve',0
szRec55     db 'IMAGE_OPTIONAL_HEADER32.SizeOfHeapCommit',0
szRec56     db 'IMAGE_OPTIONAL_HEADER32.LoaderFlags',0
szRec57     db 'IMAGE_OPTIONAL_HEADER32.NumberOfRvaAndSizes',0

szRec58     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(Export)',0
szRec59     db 'IMAGE_DATA_DIRECTORY.isize(Export)',0
szRec60     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(Import)',0
szRec61     db 'IMAGE_DATA_DIRECTORY.isize(Import)',0
szRec62     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(Resource)',0
szRec63     db 'IMAGE_DATA_DIRECTORY.isize(Resource)',0
szRec64     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(Exception)',0
szRec65     db 'IMAGE_DATA_DIRECTORY.isize(Exception)',0
szRec66     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(Security)',0
szRec67     db 'IMAGE_DATA_DIRECTORY.isize(Security)',0
szRec68     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(BaseReloc)',0
szRec69     db 'IMAGE_DATA_DIRECTORY.isize(BaseReloc)',0
szRec70     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(Debug)',0
szRec71     db 'IMAGE_DATA_DIRECTORY.isize(Debug)',0
szRec72     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(Architecture)',0
szRec73     db 'IMAGE_DATA_DIRECTORY.isize(Architecture)',0
szRec74     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(GlobalPTR)',0
szRec75     db 'IMAGE_DATA_DIRECTORY.isize(GlobalPTR)',0
szRec76     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(TLS)',0
szRec77     db 'IMAGE_DATA_DIRECTORY.isize(TLS)',0
szRec78     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(Load_Config)',0
szRec79     db 'IMAGE_DATA_DIRECTORY.isize(Load_Config)',0
szRec80     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(Bound_Import)',0
szRec81     db 'IMAGE_DATA_DIRECTORY.isize(Bound_Import)',0
szRec82     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(IAT)',0
szRec83     db 'IMAGE_DATA_DIRECTORY.isize(IAT)',0
szRec84     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(Delay_Import)',0
szRec85     db 'IMAGE_DATA_DIRECTORY.isize(Delay_Import)',0
szRec86     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(Com_Descriptor)',0
szRec87     db 'IMAGE_DATA_DIRECTORY.isize(Com_Descriptor)',0
szRec88     db 'IMAGE_DATA_DIRECTORY.VirtualAddress(Reserved)',0
szRec89     db 'IMAGE_DATA_DIRECTORY.isize(Reserved)',0

szRec90     db 'IMAGE_SECTION_HEADER%d.Name1',0
szRec91     db 'IMAGE_SECTION_HEADER%d.VirtualSize',0
szRec92     db 'IMAGE_SECTION_HEADER%d.VirtualAddress',0
szRec93     db 'IMAGE_SECTION_HEADER%d.SizeOfRawData',0
szRec94     db 'IMAGE_SECTION_HEADER%d.PointerToRawData',0
szRec95     db 'IMAGE_SECTION_HEADER%d.PointerToRelocations',0
szRec96     db 'IMAGE_SECTION_HEADER%d.PointerToLinenumbers',0
szRec97     db 'IMAGE_SECTION_HEADER%d.NumberOfRelocations',0
szRec98     db 'IMAGE_SECTION_HEADER%d.NumberOfLinenumbers',0
szRec99     db 'IMAGE_SECTION_HEADER%d.Characteristics',0


szOut1      db '%02x',0
szOut2      db '%04x',0
lpszHexArr  db  '0123456789ABCDEF',0

.data?
stLVC         LV_COLUMN <?>
stLVI         LV_ITEM   <?>

.code

;----------------
;初始化窗口程序
;----------------
_init proc
  local @stCf:CHARFORMAT
  
  invoke GetDlgItem,hWinMain,IDC_INFO
  mov hWinEdit,eax
  invoke LoadIcon,hInstance,ICO_MAIN
  invoke SendMessage,hWinMain,WM_SETICON,ICON_BIG,eax       ;为窗口设置图标
  invoke SendMessage,hWinEdit,EM_SETTEXTMODE,TM_PLAINTEXT,0 ;设置编辑控件
  invoke RtlZeroMemory,addr @stCf,sizeof @stCf
  mov @stCf.cbSize,sizeof @stCf
  mov @stCf.yHeight,9*20
  mov @stCf.dwMask,CFM_FACE or CFM_SIZE or CFM_BOLD
  invoke lstrcpy,addr @stCf.szFaceName,addr szFont
  invoke SendMessage,hWinEdit,EM_SETCHARFORMAT,0,addr @stCf
  invoke SendMessage,hWinEdit,EM_EXLIMITTEXT,0,-1
  ret
_init endp

;------------------
; 错误Handler
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
; 将内存偏移量RVA转换为文件偏移
;---------------------
_RVAToOffset proc _lpFileHead,_dwRVA
  local @dwReturn
  
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edi,_dwRVA
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  movzx ecx,[esi].FileHeader.NumberOfSections
  ;遍历节表
  .repeat
    mov eax,[edx].VirtualAddress
    add eax,[edx].SizeOfRawData  ;计算该节结束RVA
    .if (edi>=[edx].VirtualAddress)&&(edi<eax)
      mov eax,[edx].VirtualAddress
      sub edi,eax                ;计算RVA在节中的偏移
      mov eax,[edx].PointerToRawData
      add eax,edi                ;加上节在文件中的的起始位置
      jmp @F
    .endif
    add edx,sizeof IMAGE_SECTION_HEADER
  .untilcxz
  assume edx:nothing
  assume esi:nothing
  mov eax,-1
@@:
  mov @dwReturn,eax
  popad
  mov eax,@dwReturn
  ret
_RVAToOffset endp

;------------------------
; 获取RVA所在节的名称
;------------------------
_getRVASectionName  proc _lpFileHead,_dwRVA
  local @dwReturn
  
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edi,_dwRVA
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  movzx ecx,[esi].FileHeader.NumberOfSections
  ;遍历节表
  .repeat
    mov eax,[edx].VirtualAddress
    add eax,[edx].SizeOfRawData  ;计算该节结束RVA
    .if (edi>=[edx].VirtualAddress)&&(edi<eax)
      mov eax,edx
      jmp @F
    .endif
    add edx,sizeof IMAGE_SECTION_HEADER
  .untilcxz
  assume edx:nothing
  assume esi:nothing
  mov eax,offset szNotFound
@@:
  mov @dwReturn,eax
  popad
  mov eax,@dwReturn
  ret
_getRVASectionName  endp


;-------------------------
; 在ListView中增加一个列
; 输入：_dwColumn = 增加的列编号
;	_dwWidth = 列的宽度
;	_lpszHead = 列的标题字符串 
;-------------------------
_ListViewAddColumn	proc  uses ebx ecx _hWinView,_dwColumn,_dwWidth,_lpszHead
		local	@stLVC:LV_COLUMN

		invoke	RtlZeroMemory,addr @stLVC,sizeof LV_COLUMN
		mov	@stLVC.imask,LVCF_TEXT or LVCF_WIDTH or LVCF_FMT
		mov	@stLVC.fmt,LVCFMT_LEFT
		push	_lpszHead
		pop	@stLVC.pszText
		push	_dwWidth
		pop	@stLVC.lx
              push  _dwColumn
              pop   @stLVC.iSubItem
		invoke	SendMessage,_hWinView,LVM_INSERTCOLUMN,_dwColumn,addr @stLVC
		ret
_ListViewAddColumn	endp
;----------------------------------------------------------------------
; 在ListView中新增一行，或修改一行中某个字段的内容
; 输入：_dwItem = 要修改的行的编号
;	_dwSubItem = 要修改的字段的编号，-1表示插入新的行，>=1表示字段的编号
;-----------------------------------------------------------------------
_ListViewSetItem	proc uses ebx ecx _hWinView,_dwItem,_dwSubItem,_lpszText
              invoke  RtlZeroMemory,addr stLVI,sizeof LV_ITEM

              invoke lstrlen,_lpszText
              mov stLVI.cchTextMax,eax
              mov stLVI.imask,LVIF_TEXT
              push _lpszText
              pop stLVI.pszText
              push _dwItem
              pop stLVI.iItem
              push _dwSubItem
              pop stLVI.iSubItem

              .if _dwSubItem == -1
                 mov stLVI.iSubItem,0
                 invoke SendMessage,_hWinView,LVM_INSERTITEM,NULL,addr stLVI
              .else
                 invoke SendMessage,_hWinView,LVM_SETITEM,NULL,addr stLVI
              .endif
              
              ret

_ListViewSetItem	endp
;----------------------
; 清除ListView中的内容
; 删除所有的行和所有的列
;----------------------
_ListViewClear	proc uses ebx ecx _hWinView

		invoke	SendMessage,_hWinView,LVM_DELETEALLITEMS,0,0
		.while	TRUE
			invoke	SendMessage,_hWinView,LVM_DELETECOLUMN,0,0
			.break	.if ! eax
		.endw
		ret

_ListViewClear	endp

;---------------------
; 返回指定行列的值
; 结果在szBuffer中
;---------------------
_GetListViewItem   proc  _hWinView:DWORD,_dwLine:DWORD,_dwCol:DWORD,_lpszText
              local @stLVI:LV_ITEM
              
              invoke	RtlZeroMemory,addr @stLVI,sizeof LV_ITEM
              invoke RtlZeroMemory,_lpszText,512

              mov  @stLVI.cchTextMax,512
              mov  @stLVI.imask,LVIF_TEXT
              push   _lpszText
              pop  @stLVI.pszText
              push _dwCol
              pop  @stLVI.iSubItem

              invoke SendMessage,_hWinView,LVM_GETITEMTEXT,_dwLine,addr @stLVI
              ret
_GetListViewItem   endp
;---------------------
; 初始化结果表格
;---------------------
_clearResultView  proc uses ebx ecx
             invoke _ListViewClear,hProcessModuleTable

             ;添加表头
             mov ebx,1
             mov eax,200
             lea ecx,szResultColName1
             invoke _ListViewAddColumn,hProcessModuleTable,ebx,eax,ecx

             mov ebx,2
             mov eax,400
             lea ecx,szResultColName2
             invoke _ListViewAddColumn,hProcessModuleTable,ebx,eax,ecx

             mov ebx,3
             mov eax,400
             lea ecx,szResultColName3
             invoke _ListViewAddColumn,hProcessModuleTable,ebx,eax,ecx

             mov dwCount,0
             ret
_clearResultView  endp

;------------------------------------------
; 打开输入文件
;------------------------------------------
_OpenFile1	proc
		local	@stOF:OPENFILENAME
		local	@stES:EDITSTREAM

                ;如果打开之前还有文件句柄存在，则先关闭再赋值                
                .if hFile
                   invoke CloseHandle,hFile
                   mov hFile,0
                .endif
                ; 显示“打开文件”对话框
		invoke	RtlZeroMemory,addr @stOF,sizeof @stOF
		mov	@stOF.lStructSize,sizeof @stOF
		push	hWinMain
		pop	@stOF.hwndOwner
                push    hInstance
                pop     @stOF.hInstance
		mov	@stOF.lpstrFilter,offset szFilter1
		mov	@stOF.lpstrFile,offset szFileNameOpen1
		mov	@stOF.nMaxFile,MAX_PATH
		mov	@stOF.Flags,OFN_FILEMUSTEXIST or\
                                    OFN_HIDEREADONLY or OFN_PATHMUSTEXIST
		invoke	GetOpenFileName,addr @stOF
		.if	eax
                        invoke SetWindowText,hText1,addr szFileNameOpen1
		.endif
		ret

_OpenFile1	endp
;------------------------------------------
; 打开输入文件
;------------------------------------------
_OpenFile2	proc
		local	@stOF:OPENFILENAME
		local	@stES:EDITSTREAM

                ;如果打开之前还有文件句柄存在，则先关闭再赋值                
                .if hFile
                   invoke CloseHandle,hFile
                   mov hFile,0
                .endif
                ; 显示“打开文件”对话框
		invoke	RtlZeroMemory,addr @stOF,sizeof @stOF
		mov	@stOF.lStructSize,sizeof @stOF
		push	hWinMain
		pop	@stOF.hwndOwner
                push    hInstance
                pop     @stOF.hInstance
		mov	@stOF.lpstrFilter,offset szFilter1
		mov	@stOF.lpstrFile,offset szFileNameOpen2
		mov	@stOF.nMaxFile,MAX_PATH
		mov	@stOF.Flags,OFN_FILEMUSTEXIST or\
                                    OFN_HIDEREADONLY or OFN_PATHMUSTEXIST
		invoke	GetOpenFileName,addr @stOF
		.if	eax
                        invoke SetWindowText,hText2,addr szFileNameOpen2
		.endif
		ret

_OpenFile2	endp

;--------------------------
; 将_lpPoint位置处_dwSize个字节转换为16进制的字符串
; bufTemp1处为转换后的字符串
;--------------------------
_Byte2Hex     proc _dwSize
  local @dwSize:dword

  pushad
  mov esi,offset bufTemp2
  mov edi,offset bufTemp1
  mov @dwSize,0
  .repeat
    mov al,byte ptr [esi]

    mov bl,al
    xor edx,edx
    xor eax,eax
    mov al,bl
    mov cx,16
    div cx   ;结果高位在al中，余数在dl中


    xor bx,bx
    mov bl,al
    movzx edi,bx
    mov bl,byte ptr lpszHexArr[edi]
    mov eax,@dwSize
    mov byte ptr bufTemp1[eax],bl


    inc @dwSize

    xor bx,bx
    mov bl,dl
    movzx edi,bx

    ;invoke wsprintf,addr szBuffer,addr szOut2,edx
    ;invoke MessageBox,NULL,addr szBuffer,NULL,MB_OK

    mov bl,byte ptr lpszHexArr[edi]
    mov eax,@dwSize
    mov byte ptr bufTemp1[eax],bl

    inc @dwSize
    mov bl,20h
    mov eax,@dwSize
    mov byte ptr bufTemp1[eax],bl
    inc @dwSize
    inc esi
    dec _dwSize
    .break .if _dwSize==0
   .until FALSE

   mov bl,0
   mov eax,@dwSize
   mov byte ptr bufTemp1[eax],bl

   popad
   ret
_Byte2Hex    endp

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

;--------------------------------------------
; 在表格中增加一行
; _lpSZ为第一行要显示的字段名
; _lpSP1为第一个文件该字段的位置
; _lpSP2为第二个文件该字段的位置
; _Size为该字段的字节长度
;--------------------------------------------
_addLine proc _lpSZ,_lpSP1,_lpSP2,_Size
  pushad

  invoke _ListViewSetItem,hProcessModuleTable,dwCount,-1,\
               _lpSZ             ;在表格中新增加一行
  mov dwCount,eax

  xor ebx,ebx
  invoke _ListViewSetItem,hProcessModuleTable,dwCount,ebx,\
         _lpSZ                   ;显示字段名
  
  invoke RtlZeroMemory,addr szBuffer,50
  invoke MemCopy,_lpSP1,addr bufTemp2,_Size
  invoke _Byte2Hex,_Size

  ;将指定字段按照十六进制显示，格式：一个字节+一个空格
  invoke lstrcat,addr szBuffer,addr bufTemp1
  inc ebx
  invoke _ListViewSetItem,hProcessModuleTable,dwCount,ebx,\
                   addr szBuffer ;第一个文件中的值

  invoke RtlZeroMemory,addr szBuffer,50
  invoke MemCopy,_lpSP2,addr bufTemp2,_Size
  invoke _Byte2Hex,_Size
  invoke lstrcat,addr szBuffer,addr bufTemp1
  inc ebx
  invoke _ListViewSetItem,hProcessModuleTable,dwCount,ebx,\
                   addr szBuffer ;第二个文件中的值

  popad
  ret
_addLine  endp

;-----------------------
; IMAGE_DOS_HEADER头信息
;-----------------------
_Header1 proc 
  pushad

  invoke _addLine,addr szRec1,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec2,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec3,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec4,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec5,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec6,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec7,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec8,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec9,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec10,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec11,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec12,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec13,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec14,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec15,esi,edi,8
  add esi,8
  add edi,8
  invoke _addLine,addr szRec16,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec17,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec18,esi,edi,20
  add esi,20
  add edi,20
  invoke _addLine,addr szRec19,esi,edi,4
  popad
  ret
_Header1 endp

;-----------------------
; IMAGE_DOS_HEADER头信息
;-----------------------
_Header2 proc 
  pushad

  invoke _addLine,addr szRec20,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec21,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec22,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec23,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec24,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec25,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec26,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec27,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec28,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec29,esi,edi,1
  add esi,1
  add edi,1
  invoke _addLine,addr szRec30,esi,edi,1
  add esi,1
  add edi,1
  invoke _addLine,addr szRec31,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec32,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec33,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec34,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec35,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec36,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec37,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec38,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec39,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec40,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec41,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec42,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec43,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec44,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec45,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec46,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec47,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec48,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec49,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec50,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec51,esi,edi,2
  add esi,2
  add edi,2
  invoke _addLine,addr szRec52,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec53,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec54,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec55,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec56,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec57,esi,edi,4

  ;IMAGE_DATA_DIRECTORY

  add esi,4
  add edi,4
  invoke _addLine,addr szRec58,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec59,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec60,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec61,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec62,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec63,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec64,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec65,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec66,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec67,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec68,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec69,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec70,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec71,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec72,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec73,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec74,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec75,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec76,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec77,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec78,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec79,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec80,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec81,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec82,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec83,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec84,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec85,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec86,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec87,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec88,esi,edi,4
  add esi,4
  add edi,4
  invoke _addLine,addr szRec89,esi,edi,4


  popad
  ret
_Header2 endp

;---------------------------------------
; 节表
;  eax=节序号
;---------------------------------------
_Header3 proc 
  local _dwValue:dword
  pushad
  mov _dwValue,eax

  invoke wsprintf,addr szBuffer,addr szRec90,_dwValue   
  invoke _addLine,addr szBuffer,esi,edi,8
  add esi,8
  add edi,8
  invoke wsprintf,addr szBuffer,addr szRec91,_dwValue   
  invoke _addLine,addr szBuffer,esi,edi,4
  add esi,4
  add edi,4
  invoke wsprintf,addr szBuffer,addr szRec92,_dwValue   
  invoke _addLine,addr szBuffer,esi,edi,4
  add esi,4
  add edi,4
  invoke wsprintf,addr szBuffer,addr szRec93,_dwValue   
  invoke _addLine,addr szBuffer,esi,edi,4
  add esi,4
  add edi,4
  invoke wsprintf,addr szBuffer,addr szRec94,_dwValue   
  invoke _addLine,addr szBuffer,esi,edi,4
  add esi,4
  add edi,4
  invoke wsprintf,addr szBuffer,addr szRec95,_dwValue   
  invoke _addLine,addr szBuffer,esi,edi,4
  add esi,4
  add edi,4
  invoke wsprintf,addr szBuffer,addr szRec96,_dwValue   
  invoke _addLine,addr szBuffer,esi,edi,4
  add esi,4
  add edi,4
  invoke wsprintf,addr szBuffer,addr szRec97,_dwValue   
  invoke _addLine,addr szBuffer,esi,edi,2
  add esi,2
  add edi,2
  invoke wsprintf,addr szBuffer,addr szRec98,_dwValue   
  invoke _addLine,addr szBuffer,esi,edi,2
  add esi,2
  add edi,2
  invoke wsprintf,addr szBuffer,addr szRec99,_dwValue   
  invoke _addLine,addr szBuffer,esi,edi,4

  popad
  ret
_Header3 endp


;_goHere


;--------------------
; 打开PE文件并处理
;--------------------
_openFile proc
  local @stOF:OPENFILENAME
  local @hFile,@dwFileSize,@hMapFile,@lpMemory
  local @hFile1,@dwFileSize1,@hMapFile1,@lpMemory1
  local @bufTemp1[10]:byte
  local @dwTemp:dword


  invoke CreateFile,addr szFileNameOpen1,GENERIC_READ,\
         FILE_SHARE_READ or FILE_SHARE_WRITE,NULL,\
         OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE,NULL

  .if eax!=INVALID_HANDLE_VALUE
    mov @hFile,eax
    invoke GetFileSize,eax,NULL
    mov @dwFileSize,eax
    .if eax
      invoke CreateFileMapping,@hFile,\  ;内存映射文件
             NULL,PAGE_READONLY,0,0,NULL
      .if eax
        mov @hMapFile,eax
        invoke MapViewOfFile,eax,\
               FILE_MAP_READ,0,0,0
        .if eax
          mov @lpMemory,eax              ;获得文件在内存的映象起始位置
          assume fs:nothing
          push ebp
          push offset _ErrFormat
          push offset _Handler
          push fs:[0]
          mov fs:[0],esp

          ;检测PE文件是否有效
          mov esi,@lpMemory
          assume esi:ptr IMAGE_DOS_HEADER
          .if [esi].e_magic!=IMAGE_DOS_SIGNATURE  ;判断是否有MZ字样
            jmp _ErrFormat
          .endif
          add esi,[esi].e_lfanew    ;调整ESI指针指向PE文件头
          assume esi:ptr IMAGE_NT_HEADERS
          .if [esi].Signature!=IMAGE_NT_SIGNATURE ;判断是否有PE字样
            jmp _ErrFormat
          .endif
        .endif
      .endif
    .endif
  .endif

  invoke CreateFile,addr szFileNameOpen2,GENERIC_READ,\
         FILE_SHARE_READ or FILE_SHARE_WRITE,NULL,\
         OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE,NULL

  .if eax!=INVALID_HANDLE_VALUE
    mov @hFile1,eax
    invoke GetFileSize,eax,NULL
    mov @dwFileSize1,eax
    .if eax
      invoke CreateFileMapping,@hFile1,\  ;内存映射文件
             NULL,PAGE_READONLY,0,0,NULL
      .if eax
        mov @hMapFile1,eax
        invoke MapViewOfFile,eax,\
               FILE_MAP_READ,0,0,0
        .if eax
          mov @lpMemory1,eax              ;获得文件在内存的映象起始位置
          assume fs:nothing
          push ebp
          push offset _ErrFormat1
          push offset _Handler
          push fs:[0]
          mov fs:[0],esp

          ;检测PE文件是否有效
          mov esi,@lpMemory1
          assume esi:ptr IMAGE_DOS_HEADER
          .if [esi].e_magic!=IMAGE_DOS_SIGNATURE  ;判断是否有MZ字样
            jmp _ErrFormat1
          .endif
          add esi,[esi].e_lfanew    ;调整ESI指针指向PE文件头
          assume esi:ptr IMAGE_NT_HEADERS
          .if [esi].Signature!=IMAGE_NT_SIGNATURE ;判断是否有PE字样
            jmp _ErrFormat1
          .endif
        .endif
      .endif
    .endif
  .endif

  ;到此为止，两个内存文件的指针已经获取到了。
  ;@lpMemory和@lpMemory1分别指向两个文件头
  ;下面是从这个文件头开始，找出各数据结构的字段值，进行比较。

  ;调整ESI,EDI指向DOS头
  mov esi,@lpMemory
  assume esi:ptr IMAGE_DOS_HEADER
  mov edi,@lpMemory1
  assume edi:ptr IMAGE_DOS_HEADER
  invoke _Header1

  ;调整ESI,EDI指针指向PE文件头
  add esi,[esi].e_lfanew    
  assume esi:ptr IMAGE_NT_HEADERS
  add edi,[edi].e_lfanew    
  assume edi:ptr IMAGE_NT_HEADERS
  invoke _Header2

  movzx ecx,word ptr [esi+6]
  movzx eax,word ptr [edi+6]

  .if eax>ecx
     mov ecx,eax
  .endif

  ;调整ESI,EDI指针指向节表
  add esi,sizeof IMAGE_NT_HEADERS
  add edi,sizeof IMAGE_NT_HEADERS
  mov eax,1
  .repeat
    invoke _Header3
    dec ecx
    inc eax
    .break .if ecx==0
    add esi,sizeof IMAGE_SECTION_HEADER
    add edi,sizeof IMAGE_SECTION_HEADER
  .until FALSE

  
  jmp _ErrorExit  ;正常退出

_ErrFormat:
          invoke MessageBox,hWinMain,offset szErrFormat,NULL,MB_OK
_ErrorExit:
          pop fs:[0]
          add esp,0ch
          invoke UnmapViewOfFile,@lpMemory
          invoke CloseHandle,@hMapFile
          invoke CloseHandle,@hFile
          jmp @F
_ErrFormat1:
          invoke MessageBox,hWinMain,offset szErrFormat,NULL,MB_OK
_ErrorExit1:
          pop fs:[0]
          add esp,0ch
          invoke UnmapViewOfFile,@lpMemory1
          invoke CloseHandle,@hMapFile1
          invoke CloseHandle,@hFile1
@@:        
  ret
_openFile endp

;-----------------------
; 弹出PE对比窗口回调函数
;-----------------------
_resultProcMain   proc  uses ebx edi esi hProcessModuleDlg:HWND,wMsg,wParam,lParam
          mov eax,wMsg

          .if eax==WM_CLOSE
             invoke EndDialog,hProcessModuleDlg,NULL
          .elseif eax==WM_INITDIALOG
             invoke GetDlgItem,hProcessModuleDlg,IDC_MODULETABLE
             mov hProcessModuleTable,eax
             invoke GetDlgItem,hProcessModuleDlg,ID_TEXT1
             mov hText1,eax
             invoke GetDlgItem,hProcessModuleDlg,ID_TEXT2
             mov hText2,eax
             
             ;定义表格外观
             invoke SendMessage,hProcessModuleTable,LVM_SETEXTENDEDLISTVIEWSTYLE,\
                    0,LVS_EX_GRIDLINES or LVS_EX_FULLROWSELECT
             invoke ShowWindow,hProcessModuleTable,SW_SHOW
             ;清空表格内容
             invoke _clearResultView

          .elseif eax==WM_NOTIFY
            mov eax,lParam
            mov ebx,lParam
            ;更改各控件状态
            mov eax,[eax+NMHDR.hwndFrom]
            .if eax==hProcessModuleTable
                mov ebx,lParam
                .if [ebx+NMHDR.code]==NM_CUSTOMDRAW  ;绘画时
                  mov ebx,lParam
                  assume ebx:ptr NMLVCUSTOMDRAW  
                  .if [ebx].nmcd.dwDrawStage==CDDS_PREPAINT
                     invoke SetWindowLong,hProcessModuleDlg,DWL_MSGRESULT,\
                                                               CDRF_NOTIFYITEMDRAW
                     mov eax,TRUE
                  .elseif [ebx].nmcd.dwDrawStage==CDDS_ITEMPREPAINT

                     ;当每一单元格内容预画时，判断
                     ;两列的值是否一致
                     invoke _GetListViewItem,hProcessModuleTable,\
                                         [ebx].nmcd.dwItemSpec,1,addr bufTemp1
                     invoke _GetListViewItem,hProcessModuleTable,\
                                         [ebx].nmcd.dwItemSpec,2,addr bufTemp2
                     invoke lstrlen,addr bufTemp1
                     invoke _MemCmp,addr bufTemp1,addr bufTemp2,eax

                     ;如果一致，则将文本的背景色设置为浅红色，否则黑色
                     .if eax==1
                        mov [ebx].clrTextBk,0a0a0ffh
                     .else
                        mov [ebx].clrTextBk,0ffffffh
                     .endif
                     invoke SetWindowLong,hProcessModuleDlg,DWL_MSGRESULT,\
                                                                CDRF_DODEFAULT
                     mov eax,TRUE
                   .endif
                .elseif [ebx+NMHDR.code]==NM_CLICK
                    assume ebx:ptr NMLISTVIEW
                .endif
            .endif
          .elseif eax==WM_COMMAND
             mov eax,wParam
             .if ax==IDC_OK  ;刷新
                invoke _openFile
             .elseif ax==IDC_BROWSE1
                invoke _OpenFile1    ;用户选择第一个文件
             .elseif ax==IDC_BROWSE2
                invoke _OpenFile2    ;用户选择第二个文件
             .endif
         .else
             mov eax,FALSE
             ret
         .endif
         mov eax,TRUE
         ret
_resultProcMain    endp


;-------------------
; 窗口程序
;-------------------
_ProcDlgMain proc uses ebx edi esi hWnd,wMsg,wParam,lParam
  mov eax,wMsg
  .if eax==WM_CLOSE
    invoke EndDialog,hWnd,NULL
  .elseif eax==WM_INITDIALOG  ;初始化
    push hWnd
    pop hWinMain
    call _init
  .elseif eax==WM_COMMAND     ;菜单
    mov eax,wParam
    .if eax==IDM_EXIT       ;退出
      invoke EndDialog,hWnd,NULL 
    .elseif eax==IDM_OPEN   ;打开PE对比对话框
         invoke DialogBoxParam,hInstance,RESULT_MODULE,hWnd,\
               offset _resultProcMain,0
         invoke InvalidateRect,hWnd,NULL,TRUE
         invoke UpdateWindow,hWnd
    .elseif eax==IDM_1  
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



