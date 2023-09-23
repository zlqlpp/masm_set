;程序清单：cpuid.asm(读取CPU标识)
.586
.model flat,stdcall
Option casemap:none
includelib      msvcrt.lib
printf          PROTO C :dword,:vararg
.data
szVendorID      byte  13 dup (0)
szFormatStr     byte  'VendorID = %s; Processor SN = %08X%08X', 0ah
.code
start:
                mov     eax, 0
                cpuid

                mov     dword ptr szVendorID, ebx
                mov     dword ptr szVendorID+4, edx
                mov     dword ptr szVendorID+8, ecx
                 
                mov     eax, 3
                cpuid

                invoke  printf, offset szFormatStr, 
                        offset szVendorID, ecx, edx

                ret
end             start
