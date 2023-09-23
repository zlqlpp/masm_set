//; 程序清单：inline.c(嵌入汇编)
#include "stdio.h"
#pragma warning (disable:4101)
// disable warning about unreferenced local variables
struct Misc {
  char  misc1;   // 1 bytes
  short misc2;   // 2 bytes
  int   misc3;   // 4 bytes
  long  misc4;   // 4 bytes
};
char    myChar;
short   myShort=-5;
int main()
{
        int     myInt=20;
        long    myLong;
        __int64 myLongLong;
        int     myLongArray[10];
        struct  Misc myMisc;

        _asm    mov     myChar, '9'
        _asm {
                mov     eax, LENGTH myInt;       // 1
                mov     eax, TYPE myInt;         // 4
                mov     eax, SIZE myInt;         // 4
                mov     eax, LENGTH myLongArray; // 10
                mov     eax, TYPE myLongArray;   // 4
                mov     eax, SIZE myLongArray;   // 40
                mov     eax, LENGTH myMisc;      // 1
                mov     eax, TYPE myMisc;        // 12
                mov     eax, SIZE myMisc;        // 12
                mov     eax, TYPE myChar;        // 1
                mov     eax, TYPE myShort;       // 2
                mov     eax, TYPE myLong;        // 4
                mov     eax, TYPE myLongLong;    // 8
                add     myInt, 30
                mov     ax, myShort
                mov     myMisc.misc2, ax
                movsx   eax, myMisc.misc2
                lea     ebx, myMisc
                mov     [ebx].misc3, eax
                mov     myLongArray[2*4], 200
        }

        printf("myChar=%c myInt=%d myMisc.misc3=%d myLongArray[2]=%d\n",
                myChar, myInt, myMisc.misc3, myLongArray[2]);
        return 0;
}
