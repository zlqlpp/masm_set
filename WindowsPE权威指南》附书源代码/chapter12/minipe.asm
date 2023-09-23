;---------------------------------
; miniPE����(133�ֽ�)
;
; �ó���ʹ��Borland��˾��Tasm��������������
; Tasm /m minipe.asm
; Tlink /t /3 minipe, minipe.exe       
; 2011.2.19
;--------------------------------

          .386



;���    ����        �ֶ���               �ֶ�������ֵ����      ����                                   �ֽ���               
;-------------------------------------------------------------------------------------------------------------------------------------------

IBase    equ 400000h                                            ;������minipe.exe�Ļ���ַ

             
HEADER   SEGMENT                                                ;����һ����
         ASSUME CS:HEADER,FS:NOTHING,ES:HEADER,DS:HEADER

CodeBase:

               ;************** PE DOS ͷ *****************

                DosSignature                dw 5a4dh            ;MZ��־                                 4D 5A
                                            dw 0ffffh           ;                                       FF FF

               ;************** PE ��׼ͷ *****************

                WinSignature                dd 4550h            ;PE��־                                 50 45 00 00
                Machine                     dw 014ch            ;Intel 80386                            4C 01       
                NumberOfSections            dw 1                ;�ڵĸ���                               01 01                
                  ;TimeDateStamp            dd 0                ;������ֵ 
                  ;PointerToSymbolTable     dd 0                ;������ֵ
                  ;NumberOfSymbols          dd 0                ;������ֵ
    user32                                  db "user32.dll",0   ;                                       75 73 65 72 33 32 2E 64 6C 6C 00
                                            db 0ffh             ;                                       FF
                SizeOfOptionalHeader        dw OptHeaderSize    ;��ѡͷ����С                           40 01                           
                Characteristics             dw 010fh            ;������־                               0F 01

               ;************** PE ��ѡͷ ****************

                Magic                       dw 10bh             ;                                       0B 01
                LinkerVersion               dw 0ffffh           ;������ֵ                               FF FF
                ;SizeOfCode                 dd 0                ;������ֵ                               
                ;SizeOfInitializedData      dd 0                ;������ֵ                                
                ;SizeOfUninitializedData    dd 0                ;������ֵ
                MessageBoxA                 db "MessageBoxA",0  ;                                       4D 65 73 73 61 67 65 42 6F 78 41 00                          
                AddressOfEntryPoint         dd start            ;��ʼ�����ַ                           44 00 00 00

;---------------------
; ��������������ʹ����
; ��תָ��jmp 00400018
; ִ��MessageBoxA����
;---------------------
next3:
                ;BaseOfCode                  dd 0               ;������ֵ
                ;BaseOfData                  dd 0               ;������ֵ   ����˫�������´������
  dw  15ffh                                                     ;��ָ��Ϊ��תָ��                       FF 15
  dd  IBase+IAT1                                                ;                                       7C 00 40 00
  ret                                                           ;��ָ��Ϊ1���ֽ�                        C3




                                             db 0ffh            ;                                       FF
                 ImageBase                   dd IBase           ;ӳ����ʼ��ַ                           00 00 40 00
                 SectionAlignment            dd 4               ;PE��־(3chλ��=��4��ʼ)                04 00 00 00
                 FileAlignment               dd 4               ;                                       04 00 00 00


;------------------
; ����ִ����ڣ�
;------------------
start:
                 ;OperatingSystemVersion      dd 0ffffffffh     ;����ֵ
                 ;ImageVersion                dd 0ffffffffh     ;������ֵ    ����˫�������´������

  mov eax,offset IBase+MessageBoxA                              ;��ָ��Ϊ5���ֽ�                        B8 20 00 40 00
  jmp short next1                                               ;��ָ��Ϊ2���ֽ�                        EB 03
                                              db 0ffh                                                   FF
                                              dw 4                                                      04 00
next1:
  push 0                                                        ;����ָ���ֽ�,��ڲ���4                 6A 00            
  push eax                                                      ;һ��ָ���ֽ�,��ڲ���3                 50
  push eax                                                      ;һ��ָ���ֽ�,��ڲ���2                 50    
  jmp short next2                                               ;����ָ���ֽ�                           EB 20


                 ;SubsystemVersion           dd 0ffff0004h      ;Win32 4.0
                 ;Win32VersionValue          dd 0ffffffffh      ;������ֵ
                 SizeOfImage                 dd IMAGE_SIZE      ;������ֵ,Ҫ�����SizeOfHeaders         89 00 00 00
                 SizeOfHeaders               dd PE_HEADER_SIZE  ;�ļ�ͷ��С                             85 00 00 00
                 OptHeaderSize=$-Magic
IAT:
                 CheckSum                    dd 0               ;������ֵ,  OriginalFirstThunk          00 00 00 00
                 Subsystem                   dw 2               ;           TimeDateStamp               02 00
                 DllCharacteristics          dw 0ffh            ;                                       FF 00
                 SizeOfStackReserve          dd IAT1            ;(Virtual Size),   ForwarderChain       7C 00 00 00
                 SizeOfStackCommit           dd user32          ;(Virtual Address),Name1                0C 00 00 00
                 SizeOfHeapReserve           dd IAT1            ;(Raw Data Size),  FirstThunk           7C 00 00 00
                 SizeOfHeapCommit            dd user32          ;(Raw Data Offset)                      0C 00 00 00
next2:
                 ;LoaderFlags                dd 0ffffffffh      ;������ֵ   һ��˫�������´������

  push 0                                                        ;����ָ���ֽ�,��ڲ���1                 6A 00 
  jmp short next3                                               ;����ָ���ֽ�,jmp _MessageBoxA          EB B8  

                 NumberOfRvaAndSizes         dd 2h              ;                                       02 00 00 00     

                ;************** ����Ŀ¼�� ****************

IAT1:
                 IDE_Export                  dd MessageBoxA-2,0 ;����Ŀ¼��һ�������                 1E 00 00 00 00 00 00 00
                 IDE_Import                  db IAT-CodeBase    ;����Ŀ¼�ڶ�������                 5C

                ;************ ����Ŀ¼����� **************
                ;************ PE�ļ�ͷ���� ****************
                ;************ ����PE�ļ����� **************

                 PE_HEADER_SIZE=$                               ;ȡ�÷���ƫ��ΪPE�ļ�ͷ��С
                 IMAGE_SIZE=PE_HEADER_SIZE+4                    ;ӳ���С=PE�ļ�ͷ��С+�ļ���������

HEADER           ENDS
                 END 
                            
