;------------------------
; 无导入表、无数据段、无重定位信息、无全局变量的HelloWorld
; 戚利
; 2010.6.27
;------------------------
    .386
    .model flat,stdcall
    option casemap:none

include    windows.inc


_QLGetProcAddress typedef proto :dword,:dword      ;声明函数
_ApiGetProcAddress  typedef ptr _QLGetProcAddress  ;声明函数引用

_QLLoadLib        typedef proto :dword
_ApiLoadLib       typedef ptr _QLLoadLib

_QLMessageBoxA    typedef proto :dword,:dword,:dword,:dword
_ApiMessageBoxA   typedef ptr _QLMessageBoxA


;代码段
    .code

jmp start

;保存目标程序的相关信息：
dstDataDirectory dd 32 dup(0)  ; 原始目标程序的数据目录表
dwModuleBase   dd  ?

szText         db  'HelloWorldPE',0
szGetProcAddr  db  'GetProcAddress',0
szLoadLib      db  'LoadLibraryA',0
szMessageBox   db  'MessageBoxA',0

user32_DLL     db  'user32.dll',0,0

dwImageBase    dd  ?  ;目标进程基地址



;------------------------------------
; 根据kernel32.dll中的一个地址获取它的基地址
;------------------------------------
_getKernelBase  proc _dwKernelRetAddress
   local @dwRet

   pushad

   mov @dwRet,0
   
   mov edi,_dwKernelRetAddress
   and edi,0ffff0000h  ;查找指令所在页的边界，以1000h对齐

   .repeat
     .if word ptr [edi]==IMAGE_DOS_SIGNATURE  ;找到kernel32.dll的dos头
        mov esi,edi
        add esi,[esi+003ch]
        .if word ptr [esi]==IMAGE_NT_SIGNATURE ;找到kernel32.dll的PE头标识
          mov @dwRet,edi
          .break
        .endif
     .endif
     sub edi,010000h
     .break .if edi<070000000h
   .until FALSE
   popad
   mov eax,@dwRet
   ret
_getKernelBase  endp   


;------------------------------------
; 根据kernel32.dll中的一个地址获取它的基地址
;------------------------------------
_getImageBase  proc _dwKernelRetAddress
   local @dwRet
   local @dwTemp
   pushad

   mov @dwRet,0
   
   mov edi,_dwKernelRetAddress
   and edi,0ffff0000h  ;查找指令所在页的边界，以1000h对齐
   mov eax,edi
   and eax,0ff000000h
   mov @dwTemp,eax
   .repeat
     .if word ptr [edi]==IMAGE_DOS_SIGNATURE  ;找到kernel32.dll的dos头
        mov esi,edi
        add esi,[esi+003ch]
        .if word ptr [esi]==IMAGE_NT_SIGNATURE ;找到kernel32.dll的PE头标识
          mov @dwRet,edi
          .break
        .endif
     .endif
     sub edi,010000h
     .break .if edi<@dwTemp
   .until FALSE
   popad
   mov eax,@dwRet
   ret
_getImageBase  endp   

;-------------------------------
; 获取指定字符串的API函数的调用地址
; 入口参数：_hModule为动态链接库的基址，_lpApi为API函数名的首址
; 出口参数：eax为函数在虚拟地址空间中的真实地址
;-------------------------------
_getApi proc _hModule,_lpApi
   local @ret
   local @dwLen

   pushad
   mov @ret,0
   ;计算API字符串的长度，含最后的零
   mov edi,_lpApi
   mov ecx,-1
   xor al,al
   cld
   repnz scasb
   mov ecx,edi
   sub ecx,_lpApi
   mov @dwLen,ecx

   ;从pe文件头的数据目录获取导出表地址
   mov esi,_hModule
   add esi,[esi+3ch]
   assume esi:ptr IMAGE_NT_HEADERS
   mov esi,[esi].OptionalHeader.DataDirectory.VirtualAddress
   add esi,_hModule
   assume esi:ptr IMAGE_EXPORT_DIRECTORY

   ;查找符合名称的导出函数名
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
   ;通过API名称索引获取序号索引再获取地址索引
   sub ebx,[esi].AddressOfNames
   sub ebx,_hModule
   shr ebx,1
   add ebx,[esi].AddressOfNameOrdinals
   add ebx,_hModule
   movzx eax,word ptr [ebx]
   shl eax,2
   add eax,[esi].AddressOfFunctions
   add eax,_hModule
   
   ;从地址表得到导出函数的地址
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
; 将内存偏移量RVA转换为文件偏移
; lp_FileHead为文件头的起始地址
; _dwRVA为给定的RVA地址
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
    add eax,[edx].SizeOfRawData        ;计算该节结束RVA，不用Misc的主要原因是有些段的Misc值是错误的！
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

_goThere  proc
   local _getProcAddress:_ApiGetProcAddress   ;定义函数
   local _loadLibrary:_ApiLoadLib
   local _messageBox:_ApiMessageBoxA


   local hKernel32Base:dword
   local hUser32Base:dword
   local lpGetProcAddr:dword
   local lpLoadLib:dword

   pushad

    ;获取kernel32.dll的基地址
    invoke _getKernelBase,eax

    mov hKernel32Base,eax

    ;从基地址出发搜索GetProcAddress函数的首址
    mov eax,offset szGetProcAddr
    add eax,ebx

    mov edi,hKernel32Base
    mov ecx,edi

    invoke _getApi,ecx,eax
    mov lpGetProcAddr,eax
    ;为函数引用赋值 GetProcAddress
    mov _getProcAddress,eax   

    ;使用GetProcAddress函数的首址，
    ;传入两个参数调用GetProcAddress函数，
    ;获得LoadLibraryA的首址
    mov eax,offset szLoadLib
    add eax,ebx
    invoke _getProcAddress,hKernel32Base,eax
    mov _loadLibrary,eax

    ;使用LoadLibrary获取user32.dll的基地址
    mov eax,offset user32_DLL
    add eax,ebx
    invoke _loadLibrary,eax

    mov hUser32Base,eax

    ;使用GetProcAddress函数的首址，
    ;获得函数MessageBoxA的首址
    mov eax,offset szMessageBox
    add eax,ebx
    invoke _getProcAddress,hUser32Base,eax
    mov _messageBox,eax

    ;调用函数MessageBoxA
    mov eax,offset szText
    add eax,ebx
    invoke _messageBox,NULL,eax,NULL,MB_OK



    ;获取目标进程的基地址
    mov eax,offset dwImageBase
    add eax,ebx

    push eax
    lea edx,_getImageBase
    add edx,ebx
    call edx
    mov dwImageBase[ebx],eax

    ;遍历目标进程导入表
    mov edi,offset dstDataDirectory
    add edi,ebx
    add edi,8  ;定位到导入表项

    mov eax,dword ptr [edi] ;获取VirtualAddress
    ;未做判断，假设处理的PE文件均有导入表
    add eax,dwImageBase[ebx] ;所在内存偏移

    mov edi,eax     ;计算引入表所在文件偏移位置
    assume edi:ptr IMAGE_IMPORT_DESCRIPTOR
    
    mov eax,dword ptr [edi].Name1 ;取第一个动态链接库名字字符串所在的RVA值
    add eax,dwImageBase[ebx]  ;在内存定位只需加上基地址即可
    ;invoke _messageBox,NULL,eax,NULL,MB_OK

    ;动态加载该dll
    invoke _loadLibrary,eax
    mov dwModuleBase[ebx],eax    


    popad
    ret
_goThere endp

start:
    ;取当前函数的堆栈栈顶值
    mov eax,dword ptr [esp]
    push eax
    call @F   ; 免去重定位
@@:
    pop ebx
    sub ebx,offset @B
    pop eax
    invoke _goThere
    jmpToStart   db 0E9h,0F0h,0FFh,0FFh,0FFh

    ret

    end start
