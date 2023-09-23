//;程序清单: internal.c(程序内部缓冲区溢出)
#include <windows.h>
#include <stdio.h>
#include <string.h>

void copyString(char* s)
{
    char buf[10];

    strcpy (buf, s);
}

void hacked(void)
{
    printf("The program is hacked.\n");
    while (1) ;
}

int main(int argc, char* argv[])
{
    char badStr[] = "000011112222333344445555";
    DWORD *pEIP = (DWORD*)&badStr[16];
    
    *pEIP = (DWORD)hacked;

    copyString(badStr);
    return 0;
} 
