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

;�ļ��е�ICOͷ��
ICON_DIR_ENTRY STRUCT  
    bWidth     db   ?   ; ���
    bHeight     db   ?   ; �߶�
    bColorCount  db  ?   ; ��ɫ��
    bReserved    db  ?   ; �����֣�����Ϊ0
    wPlanes      dw  ?  ; ��ɫ��
    wBitCount    dw  ?  ;ÿ�����ص�λ��
    dwBytesInRes  dd  ?  ;��Դ����
    dwImageOffset  dd  ?  ;��Դ���ļ�ƫ��
ICON_DIR_ENTRY ENDS

;PE��ICOͷ��
PE_ICON_DIR_ENTRY STRUCT
    bWidth     db   ?   ; ���
    bHeight     db   ?   ; �߶�
    bColorCount  db  ?   ; ��ɫ��
    bReserved    db  ?   ; �����֣�����Ϊ0
    wPlanes      dw  ?  ; ��ɫ��
    wBitCount    dw  ?  ;ÿ�����ص�λ��
    dwBytesInRes  dd  ?  ;��Դ����
    dwImageOffset  dw  ?  ;��Դ���ļ�ƫ��
PE_ICON_DIR_ENTRY ENDS

.data
hInstance   dd ?
hRichEdit   dd ?
hWinMain    dd ?
hWinEdit    dd ?
hFile       dd ? ;�ļ����
szFileName  db MAX_PATH dup(?)
szFileName1 db MAX_PATH dup(?)
szBuffer    db  200 dup(0)
dwICO       dd ?   ;ICO�ļ��ĸ���
lpMemory    dd ?   ;ָ���ļ���ָ��
dwIcoDataSize dd ?  ;ͼ�����ݵĴ�С


lpPEIconDE    PE_ICON_DIR_ENTRY  <?>
lpIconDE      ICON_DIR_ENTRY     <?>

lpszOffsetArray  dd  500 dup(0)  ;ͼ�����ݵ�ƫ�Ƶ�ַ
                                 ;�ӵڶ���ͼ���ַ��ʼ

.const
szDllEdit   db 'RichEd20.dll',0
szClassEdit db 'RichEdit20A',0
szFont      db '����',0
szExtPe     db 'PE File',0,'*.exe;*.dll;*.scr;*.fon;*.drv',0
            db 'All Files(*.*)',0,'*.*',0,0
szErr       db '�ļ���ʽ����!',0
szErrFormat db '����ļ�����PE��ʽ���ļ�!',0
szSuccess   db '��ϲ�㣬����ִ�е������ǳɹ��ġ�',0
szNotFound  db '�޷�����',0

szOut1         db '-----------------------------------------------------------------',0dh,0ah
               db '�������PE�ļ���%s',0dh,0ah,0

szFile         db '  >>�½��ļ�%s',0dh,0ah,0
szLevel3       db 'ͼ����%4d�����ļ�λ�ã�0x%08x  ��Դ���ȣ�%d',0dh,0ah,0
szLevel31      db '  >> ͼ��%4d�����ļ�λ�ã�0x%08x  ��Դ���ȣ�%d',0dh,0ah,0
szFinished     db '  >> ���д�롣',0dh,0ah,0dh,0ah,0
szICOHeader    db '  >> ���ICOͷ����Ϣ',0dh,0ah,0

szNoResource   db 'δ������Դ��!',0
szNoIconArray  db '��Դ����û�з���ͼ���飡',0
szOut10        db '��Դ������ͼ����%d����',0dh,0ah
               db '----------------------------------------------------------------',0dh,0ah,0dh,0ah,0 
szOut11        db 'g%d.ico',0
szOut12        db '%d',0
szOut13        db '  >>ͼ����%4d�й���ͼ�꣺%d����',0dh,0ah,0


     
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
  mov @stCf.yHeight,9*20
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

;---------------------------------
; ���ڴ�ƫ����RVAת��Ϊ�ļ�ƫ��
; lp_FileHeadΪ�ļ�ͷ����ʼ��ַ
; _dwRVAΪ������RVA��ַ
;---------------------------------
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
  ;�����ڱ�
  .repeat
    mov eax,[edx].VirtualAddress
    ;����ýڽ���RVA������Misc����Ҫԭ������Щ�ε�Miscֵ�Ǵ���ģ�
    add eax,[edx].SizeOfRawData 
    .if (edi>=[edx].VirtualAddress)&&(edi<eax)
      mov eax,[edx].VirtualAddress
      ;����RVA�ڽ��е�ƫ��
      sub edi,eax                
      mov eax,[edx].PointerToRawData
      ;���Ͻ����ļ��еĵ���ʼλ��
      add eax,edi                
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

;-------------------------------------------
; �������ļ�ͷ���ļ�ƫ��ת��Ϊ�ڴ�ƫ����RVA
; lp_FileHeadΪ�ļ�ͷ����ʼ��ַ
; _dwOffsetΪ�������ļ�ƫ�Ƶ�ַ
;-------------------------------------------
_OffsetToRVA proc _lpFileHead,_dwOffset
  local @dwReturn
  
  pushad
  mov esi,_lpFileHead
  assume esi:ptr IMAGE_DOS_HEADER
  add esi,[esi].e_lfanew
  assume esi:ptr IMAGE_NT_HEADERS
  mov edi,_dwOffset
  mov edx,esi
  add edx,sizeof IMAGE_NT_HEADERS
  assume edx:ptr IMAGE_SECTION_HEADER
  movzx ecx,[esi].FileHeader.NumberOfSections
  ;�����ڱ�
  .repeat
    mov eax,[edx].PointerToRawData 
    ;����ýڽ���RVA������Misc����Ҫԭ������Щ�ε�Miscֵ�Ǵ���ģ�
    add eax,[edx].SizeOfRawData 
    .if (edi>=[edx].PointerToRawData)&&(edi<eax)
      mov eax,[edx].PointerToRawData
      ;����RVA�ڽ��е�ƫ��
      sub edi,eax                
      mov eax,[edx].VirtualAddress
      ;���Ͻ����ļ��еĵ���ʼλ��
      add eax,edi                
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
_OffsetToRVA endp

;------------------------
; ��ȡRVA���ڽڵ�����
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
  ;�����ڱ�
  .repeat
    mov eax,[edx].VirtualAddress
    add eax,[edx].SizeOfRawData  ;����ýڽ���RVA
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

;-------------------------------
; ��ȡָ���ַ�����API�����ĵ��õ�ַ
; ��ڲ�����_hModuleΪ��̬���ӿ�Ļ�ַ��_lpApiΪAPI����������ַ
; ���ڲ�����eaxΪ�����������ַ�ռ��е���ʵ��ַ
;-------------------------------
_getApi proc _hModule,_lpApi
   local @ret
   local @dwLen

   pushad
   mov @ret,0
   ;����API�ַ����ĳ��ȣ���������
   mov edi,_lpApi
   mov ecx,-1
   xor al,al
   cld
   repnz scasb
   mov ecx,edi
   sub ecx,_lpApi
   mov @dwLen,ecx

   ;��pe�ļ�ͷ������Ŀ¼��ȡ�������ַ
   mov esi,_hModule
   add esi,[esi+3ch]
   assume esi:ptr IMAGE_NT_HEADERS
   mov esi,[esi].OptionalHeader.DataDirectory.VirtualAddress
   add esi,_hModule
   assume esi:ptr IMAGE_EXPORT_DIRECTORY

   ;���ҷ������Ƶĵ���������
   mov ebx,[esi].AddressOfNames
   add ebx,_hModule
   xor edx,edx
   .repeat
     push esi
     mov edi,[ebx]
     add edi,_hModule
     mov esi,_lpApi
     mov ecx,@dwLen
     repz cmpsb
     .if ZERO?
       pop esi
       jmp @F
     .endif
     pop esi
     add ebx,4
     inc edx
   .until edx>=[esi].NumberOfNames
   jmp _ret
@@:
   ;ͨ��API����������ȡ��������ٻ�ȡ��ַ����
   sub ebx,[esi].AddressOfNames
   sub ebx,_hModule
   shr ebx,1
   add ebx,[esi].AddressOfNameOrdinals
   add ebx,_hModule
   movzx eax,word ptr [ebx]
   shl eax,2
   add eax,[esi].AddressOfFunctions
   add eax,_hModule
   
   ;�ӵ�ַ��õ����������ĵ�ַ
   mov eax,[eax]
   add eax,_hModule
   mov @ret,eax

_ret:
   assume esi:nothing
   popad
   mov eax,@ret
   ret
_getApi endp

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

;-------------------------------
;��ͼ������д���ļ�
;
;������_lpFile �ļ��ڴ���ʼ��ַ
;����: _lpRes ��Դ����ʼ��ַ
;������_nubmerΪͼ��˳��
;-------------------------------
_getFinnalData proc _lpFile,_lpRes,_number
  local @ret,@dwTemp
  local @szBuffer[1024]:byte
  local @szResName[256]:byte
  local @dwTemp1,@dwTemp2,@dwTemp3
  local @lpMem
  
  pushad
  mov @ret,0

  mov dwICO,0
  
  mov esi,_lpRes     ;ָ���һ��Ŀ¼��

  ;����Ŀ¼��ĸ���
  assume esi:ptr IMAGE_RESOURCE_DIRECTORY
  mov cx,[esi].NumberOfNamedEntries
  add cx,[esi].NumberOfIdEntries
  movzx ecx,cx
 
  ;����Ŀ¼ͷ��λ��Ŀ¼��
  add esi,sizeof IMAGE_RESOURCE_DIRECTORY
  assume esi:ptr IMAGE_RESOURCE_DIRECTORY_ENTRY
  .while ecx>0

    ;�鿴IMAGE_RESOURCE_DIRECTORY_ENTRY.OffsetToData
    mov ebx,[esi].OffsetToData
    .if ebx & 80000000h ;������λΪ1
        and ebx,7fffffffh     ;������Ŀ¼
        add ebx,_lpRes
        mov eax,[esi].Name1 
        ;����ǰ����ƶ������Դ���ͣ����� 
        .if eax & 80000000h   
            jmp _next         
        .else        ;����ǰ���Ŷ������Դ����

           ;��һ�㣬eaxָ������Դ���
           .if eax==03h  ;�жϱ���Ƿ�Ϊͼ��

             ;�ƶ����ڶ���Ŀ¼
             ;����Ŀ¼��ĸ���
             mov esi,ebx
             assume esi:ptr IMAGE_RESOURCE_DIRECTORY
             mov cx,[esi].NumberOfNamedEntries
             add cx,[esi].NumberOfIdEntries
             movzx ecx,cx
             mov dwICO,ecx

             mov ecx,dwICO

             ;�����ڶ���Ŀ¼ͷ��λ���ڶ���Ŀ¼��
             add esi,sizeof IMAGE_RESOURCE_DIRECTORY
             assume esi:ptr IMAGE_RESOURCE_DIRECTORY_ENTRY

             mov @dwTemp1,0
             .while ecx>0
               push ecx
               push esi
               
               ;ֱ�ӷ��ʵ����ݣ���ȡ�������ļ���ƫ�Ƽ���С
               add @dwTemp1,1

               ;�ж�����Ƿ��ָ����һ��
               mov eax,_number
               .if @dwTemp1!=eax
                 jmp _loop
               .endif

               ;���һ�£��������������
   
               mov ebx,[esi].OffsetToData
               .if ebx & 80000000h ;���λΪ1
                  and ebx,7fffffffh
                  add ebx,_lpRes   ;������

                  ;�ƶ���������Ŀ¼������Ŀ¼��������Ϊ1
                  mov esi,ebx
                  assume esi:ptr IMAGE_RESOURCE_DIRECTORY
                  add esi,sizeof IMAGE_RESOURCE_DIRECTORY
                  assume esi:ptr IMAGE_RESOURCE_DIRECTORY_ENTRY  

                  ;��ַָ��������
                  mov ebx,[esi].OffsetToData
                  add ebx,_lpRes
                    
                  assume ebx:ptr IMAGE_RESOURCE_DATA_ENTRY
                  mov eax,[ebx].OffsetToData
                  mov edx,[ebx].Size1
                  mov @dwTemp3,edx
                  invoke _RVAToOffset,_lpFile,eax
                  mov @dwTemp2,eax

                  invoke wsprintf,addr szBuffer,addr szLevel31,\
                              @dwTemp1,@dwTemp2,@dwTemp3
                  invoke _appendInfo,addr szBuffer 

                  mov eax,_lpFile
                  add eax,@dwTemp2
                  mov @lpMem,eax
                    
                  ;��@dwTemp2��ʼ��@dwTemp3���ֽ�д���ļ�
                  invoke WriteFile,hFile,@lpMem,\
                          @dwTemp3,addr @dwTemp,NULL
                  invoke _appendInfo,addr szFinished 

                  pop esi
                  pop ecx
                  mov @ret,1
                  jmp _ret 
               .endif

_loop:         pop esi
               pop ecx
               add esi,sizeof IMAGE_RESOURCE_DIRECTORY_ENTRY
               dec ecx
             .endw
             jmp _next        
           .else
             jmp _next
           .endif
           
        .endif
    .endif
_next:
    add esi,sizeof IMAGE_RESOURCE_DIRECTORY_ENTRY
    dec ecx
  .endw

  .if dwICO==0
    invoke _appendInfo,addr szNoIconArray
  .endif
_ret:
  assume esi:nothing
  assume ebx:nothing
  popad
  mov eax,@ret
  ret
_getFinnalData endp

;-------------------------------
;ͨ��PE ICOͷ��ȡICO����
;
;����1���ļ���ʼ
;����2����Դ��ʼ
;����3��PE ICOͷ��ʼ
;����4����ţ��ɴ˹�������ļ���g12.ico��
;����5��PE ICOͷ��С
;-------------------------------
_getIcoData proc _lpFile,_lpRes,_number,_off,_size
  local @dwTemp,@dwCount,@dwTemp1
  local @lpMem,@dwForward 

  pushad
  invoke wsprintf,addr szFileName1,addr szOut11,_number
  invoke wsprintf,addr szBuffer,addr szFile,\
                                 addr szFileName1
  invoke _appendInfo,addr szBuffer
  ;���ڴ�д���ļ��Թ����
  invoke CreateFile,addr szFileName1,GENERIC_WRITE,\
             FILE_SHARE_READ,\
             0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
  mov hFile,eax
  

  ;��λ�ļ�ָ��
  mov eax,_lpFile
  add eax,_off
  mov lpMemory,eax
  mov @lpMem,eax

  ;д��6���ֽ��ļ�ͷ
  invoke WriteFile,hFile,lpMemory,6,addr @dwTemp,NULL

  ;���ͼ�������ͼ��ĸ���  
  mov esi,dword ptr [lpMemory]
  add esi,4
  xor ecx,ecx
  mov cx,word ptr [esi]
  mov @dwCount,ecx
  invoke wsprintf,addr szBuffer,addr szOut13,\
                                    _number,@dwCount
  invoke _appendInfo,addr szBuffer

  ;���һ��ͼ���������ļ��е�ƫ��
  xor edx,edx
  mov eax,@dwCount
  mov cx,2   ;ÿһ����¼��2���ֽ�
  mul cx
  add eax,_size
  mov @dwForward,eax  ;��һ��

  ;��λ��ICOͼ������ʼ
  mov esi,dword ptr [lpMemory]
  add esi,6
  assume esi:ptr PE_ICON_DIR_ENTRY
  mov dwIcoDataSize,0

  mov eax,@dwCount
  mov @dwTemp1,eax
  .while @dwTemp1>0
     push esi

     ;��PE�еĴ󲿷ָ�ֵ�������һ���ֶ���
     mov al,[esi].bWidth
     mov lpIconDE.bWidth,al

     mov al,[esi].bHeight
     mov lpIconDE.bHeight,al

     mov al,[esi].bColorCount
     mov lpIconDE.bColorCount,al

     mov al,[esi].bReserved
     mov lpIconDE.bReserved,al

     mov ax,[esi].wPlanes
     mov lpIconDE.wPlanes,ax

     mov ax,[esi].wBitCount
     mov lpIconDE.wBitCount,ax

     mov eax,[esi].dwBytesInRes
     mov lpIconDE.dwBytesInRes,eax
     

     ;��ֵ��Ҫ��������¼ͼ���������ļ�ƫ�ơ�
     ;��һ��ͼ��ĸ�ֵ���ļ�ICOͷ��С
     
     ;�Ժ��ͼ��ĸ�ֵ����һ���������ݳ���
     mov eax,dwIcoDataSize
     add @dwForward,eax
     mov eax,@dwForward
     mov lpIconDE.dwImageOffset,eax

    
     invoke WriteFile,hFile,addr lpIconDE,\
              sizeof ICON_DIR_ENTRY,addr @dwTemp,NULL

     mov eax,[esi].dwBytesInRes ;Ϊ��һ�μ����ַ��׼��
     mov dwIcoDataSize,eax
     pop esi
     add esi,sizeof PE_ICON_DIR_ENTRY    
     dec @dwTemp1
  .endw ;��ѭ�����������е�ͷ����Ϣ�Ѿ���ϡ�

  invoke _appendInfo,addr szICOHeader

  ;��ʼ��һ��ѭ����������ͼ������д���ļ�
  mov esi,dword ptr [lpMemory]
  add esi,6
  assume esi:ptr PE_ICON_DIR_ENTRY

  mov eax,@dwCount
  mov @dwTemp1,eax
  .while @dwTemp1>0
     push esi

     xor eax,eax
     mov ax,[esi].dwImageOffset  ;ȡ��ͼ���˳��

     ;д���ļ�ͼ������
     ;����eaxΪͼ�����ݴ�С
     invoke _getFinnalData,_lpFile,_lpRes,eax

     pop esi
     add esi,sizeof PE_ICON_DIR_ENTRY    
     dec @dwTemp1
  .endw ;��ѭ�����������е�ͷ����Ϣ�Ѿ���ϣ�ֻ������ƫ�Ƶ�ַ
  
  invoke CloseHandle,hFile

  popad

  ret
_getIcoData endp


;-------------------------
;������Դ�����ͼ������Դ  
;_lpFile���ļ���ַ
;_lpRes����Դ���ַ
;-------------------------
_processRes  proc _lpFile,_lpRes
  local @szBuffer[1024]:byte
  local @szResName[256]:byte
  local @dwTemp1,@dwTemp2,@dwTemp3
  

  pushad

  mov dwICO,0
  
  mov esi,_lpRes     ;ָ��Ŀ¼��

  ;����Ŀ¼��ĸ���
  assume esi:ptr IMAGE_RESOURCE_DIRECTORY
  mov cx,[esi].NumberOfNamedEntries
  add cx,[esi].NumberOfIdEntries
  movzx ecx,cx
 
  ;����Ŀ¼ͷ��λ��Ŀ¼��
  add esi,sizeof IMAGE_RESOURCE_DIRECTORY
  assume esi:ptr IMAGE_RESOURCE_DIRECTORY_ENTRY
  .while ecx>0

    ;�鿴IMAGE_RESOURCE_DIRECTORY_ENTRY.OffsetToData
    mov ebx,[esi].OffsetToData
    .if ebx & 80000000h ;������λΪ1
        and ebx,7fffffffh     ;������Ŀ¼
        add ebx,_lpRes
        mov eax,[esi].Name1 
        ;����ǰ����ƶ������Դ���ͣ����� 
        .if eax & 80000000h   
            jmp _next         
        .else        ;����ǰ���Ŷ������Դ����

           ;��һ�㣬eaxָ������Դ���
           .if eax==0eh  ;�жϱ���Ƿ�Ϊͼ����

             ;�ƶ����ڶ���Ŀ¼
             ;����Ŀ¼��ĸ���
             mov esi,ebx
             assume esi:ptr IMAGE_RESOURCE_DIRECTORY
             mov cx,[esi].NumberOfNamedEntries
             add cx,[esi].NumberOfIdEntries
             movzx ecx,cx
             mov dwICO,ecx

             invoke wsprintf,addr szBuffer,addr szOut10,\
                                             dwICO
             invoke _appendInfo,addr szBuffer   
             mov ecx,dwICO

             ;�����ڶ���Ŀ¼ͷ��λ���ڶ���Ŀ¼��
             add esi,sizeof IMAGE_RESOURCE_DIRECTORY
             assume esi:ptr IMAGE_RESOURCE_DIRECTORY_ENTRY
             mov @dwTemp1,0
             .while ecx>0
               push ecx
               push esi
               
               ;ֱ�ӷ��ʵ����ݣ���ȡ�������ļ���ƫ�Ƽ���С
               add @dwTemp1,1
               mov ebx,[esi].OffsetToData
               .if ebx & 80000000h ;���λΪ1
                  and ebx,7fffffffh
                  add ebx,_lpRes   ;������

                  ;�ƶ���������Ŀ¼������Ŀ¼��������Ϊ1
                  mov esi,ebx
                  assume esi:ptr IMAGE_RESOURCE_DIRECTORY
                  add esi,sizeof IMAGE_RESOURCE_DIRECTORY
                  assume esi:ptr IMAGE_RESOURCE_DIRECTORY_ENTRY  

                  ;��ַָ��������
                  mov ebx,[esi].OffsetToData
                  add ebx,_lpRes
                    
                  assume ebx:ptr IMAGE_RESOURCE_DATA_ENTRY
                  mov eax,[ebx].OffsetToData
                  mov edx,[ebx].Size1
                  mov @dwTemp3,edx
                  invoke _RVAToOffset,_lpFile,eax
                  mov @dwTemp2,eax
                  invoke wsprintf,addr szBuffer,addr szLevel3,\
                              @dwTemp1,@dwTemp2,@dwTemp3
                  invoke _appendInfo,addr szBuffer 
  
                  ;������ICO�ļ�
                  ;����1���ļ���ʼ
                  ;����2����Դ��ʼ
                  ;����3��PE ICOͷ��ʼ
                  ;����4�����
                  ;����5��PE ICOͷ��С
                  invoke _getIcoData,_lpFile,_lpRes,\
                                   @dwTemp1,@dwTemp2,@dwTemp3
                              
               .endif

               pop esi
               pop ecx
               add esi,sizeof IMAGE_RESOURCE_DIRECTORY_ENTRY
               dec ecx
             .endw
             jmp _next        
           .else
             jmp _next
           .endif
           
        .endif
    .endif
_next:
    add esi,sizeof IMAGE_RESOURCE_DIRECTORY_ENTRY
    dec ecx
  .endw

  .if dwICO==0
    invoke _appendInfo,addr szNoIconArray
  .endif
  assume esi:nothing
  assume ebx:nothing
  popad
  ret
_processRes endp


;--------------------
; ��ȡPE�ļ�����Դ��Ϣ
;--------------------
_getResource proc  _lpFile,_lpPeHead,_dwSize
  local @szBuffer[1024]:byte
  pushad
  ;ͨ��PEͷ��λ��Դ������RVA
  mov esi,_lpPeHead
  assume esi:ptr IMAGE_NT_HEADERS
  mov eax,[esi].OptionalHeader.DataDirectory[8*2].VirtualAddress
  .if !eax
     invoke _appendInfo,addr szNoResource
     jmp _ret
  .endif
  push eax
  ;����Դ�����ļ���ƫ��
  invoke _RVAToOffset,_lpFile,eax
  add eax,_lpFile
  mov esi,eax
  pop eax

  ;��������������ֱ��ʾ
  ;1���ļ�ͷλ��
  ;2����Դ��λ��
  invoke _processRes,_lpFile,esi
_ret:
  assume esi:nothing
  popad
  ret
_getResource endp

;--------------------
; ��PE�ļ�������
;--------------------
_openFile proc
  local @stOF:OPENFILENAME
  local @hFile,@dwFileSize,@hMapFile,@lpMemory

  invoke SendMessage,hWinEdit,WM_SETTEXT,NULL,0
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
    invoke GetFileSize,eax,NULL
    mov @dwFileSize,eax
    .if eax
      invoke CreateFileMapping,@hFile,\  ;�ڴ�ӳ���ļ�
             NULL,PAGE_READONLY,0,0,NULL
      .if eax
        mov @hMapFile,eax
        invoke MapViewOfFile,eax,\
               FILE_MAP_READ,0,0,0
        .if eax
          ;����ļ����ڴ��ӳ����ʼλ��
          mov @lpMemory,eax
          assume fs:nothing
          push ebp
          push offset _ErrFormat
          push offset _Handler
          push fs:[0]
          mov fs:[0],esp

          ;���PE�ļ��Ƿ���Ч
          mov esi,@lpMemory
          assume esi:ptr IMAGE_DOS_HEADER

          ;�ж��Ƿ���MZ����
          .if [esi].e_magic!=IMAGE_DOS_SIGNATURE
            jmp _ErrFormat
          .endif

          ;����ESIָ��ָ��PE�ļ�ͷ
          add esi,[esi].e_lfanew
          assume esi:ptr IMAGE_NT_HEADERS
          ;�ж��Ƿ���PE����
          .if [esi].Signature!=IMAGE_NT_SIGNATURE
            jmp _ErrFormat
          .endif

          ;����Ϊֹ�����ļ�����֤�Ѿ���ɡ�ΪPE�ṹ�ļ�

          invoke wsprintf,addr szBuffer,addr szOut1,\
                          addr szFileName
          invoke _appendInfo,addr szBuffer

          ;��ʾ��Դ����Ϣ
          invoke _getResource,@lpMemory,esi,@dwFileSize

          jmp _ErrorExit
 
_ErrFormat:
          invoke MessageBox,hWinMain,offset szErrFormat,\
                                                 NULL,MB_OK
_ErrorExit:
          pop fs:[0]
          add esp,0ch
          invoke UnmapViewOfFile,@lpMemory
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
  mov eax,wMsg
  .if eax==WM_CLOSE
    invoke EndDialog,hWnd,NULL
  .elseif eax==WM_INITDIALOG  ;��ʼ��
    push hWnd
    pop hWinMain
    call _init
  .elseif eax==WM_COMMAND     ;�˵�
    mov eax,wParam
    .if eax==IDM_EXIT       ;�˳�
      invoke EndDialog,hWnd,NULL 
    .elseif eax==IDM_OPEN   ;���ļ�
      call _openFile
    .elseif eax==IDM_1  ;���������˵���7��Ķ�����ɵģ���
      invoke MessageBox,NULL,offset szErrFormat,offset szErr,MB_ICONWARNING
    .elseif eax==IDM_2
      invoke MessageBox,NULL,offset szErrFormat,offset szErr,MB_ICONQUESTION	
    .elseif eax==IDM_3
      invoke MessageBox,NULL,offset szErrFormat,offset szErr,MB_YESNOCANCEL
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



