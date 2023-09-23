1   ;------------------------
2   ; for Angry Angel 3.0 unzip File Header
3   ; 戚利
4   ; 2011.2.19
5   ;------------------------
6       .386
7       .model flat,stdcall
8       option casemap:none
9   
10   include    windows.inc
11   include    user32.inc
12   includelib user32.lib
13   include    kernel32.inc
14   includelib kernel32.lib
15   include    comdlg32.inc
16   includelib comdlg32.lib
17   
18   
19   TOTAL_SIZE   equ  162h
20   
21   ;数据段
22       .data
23   szFileSource   db   'c:\worm2.exe',0
24   szFileDest     db   'c:\worm2_bak.exe',0
25   dwTotalSize    dd   0
26   hFileSrc       dd   0
27   hFileDst       dd   0
28   dwTemp         dd   0
29   dwTemp1        dd   0
30   dwTemp2        dd   0
31   szCaption      db  'Got you',0
32   szText         db  'OK!？^_^',0
33   szBuffer       db   TOTAL_SIZE dup(0)
34   szBuffer1      db   0ffffh dup(0)
35   
36   ;代码段
37       .code
38   
39   start:
40   
41       ;打开文件worm2.exe
42       invoke CreateFile,addr szFileSource,GENERIC_READ,\
43              FILE_SHARE_READ,\
44              0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
45       mov hFileSrc,eax
46       ;创建另外一个文件worm2_bak.exe
47       invoke CreateFile,addr szFileDest,GENERIC_WRITE,\
48              FILE_SHARE_READ,\
49              0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
50       mov hFileDst,eax
51   
52       ;解压缩头部
53       invoke ReadFile,hFileSrc,addr szBuffer,\
54              TOTAL_SIZE,addr dwTemp,0
55   
56       mov esi,offset szBuffer
57       mov edi,offset szBuffer1
58       mov ecx,TOTAL_SIZE
59       mov dwTemp2,0
60   @@0:
61       lodsb
62       mov bl,al
63       sub bl,0
64       jz  @@1
65       stosb
66       inc dwTemp2
67       dec ecx
68       jecxz @F 
69       jmp @@0
70   @@1:
71       dec ecx
72       jecxz @F
73       lodsb
74       push ecx
75       xor ecx,ecx
76       mov cl,al
77       add dwTemp2,ecx
78       mov al,0
79       rep stosb
80       pop ecx
81   
82       dec ecx
83       jecxz  @F
84       jmp @@0
85   @@:     
86       invoke WriteFile,hFileDst,addr szBuffer1,\
87                                  dwTemp2,addr dwTemp1,NULL
88   
89       ;关闭文件
90       invoke CloseHandle,hFileDst
91       invoke CloseHandle,hFileSrc
92   
93       invoke MessageBox,NULL,offset szText,\
94                                    offset szCaption,MB_OK
95       invoke ExitProcess,NULL
96       end start
