//;程序清单：idot.c(嵌入MMX汇编指令计算向量的内积)
#include <stdlib.h>

signed char a[16] = {12, 24, 30, -12, 24, 0, -70, 123, -4, 19, 73, -80, 23, -69, -20, 45};
signed char b[16] = {70, 68, -79, 23, -6, 43, 39, -27, 100, -26, 36, 61, 0, 18, -105, 82};

int idot_product_char_c(signed char *a, signed char *b, int n) 
{ 
    int r = 0; 
    int i; 
    for (i = 0 ; i < n ; i++) 
    { 
        r = r + a[i] * b[i]; 
    } 
    return r; 
} 

int idot_product_char_mmx(signed char *a, signed char *b, int n) 
{ 
    int r; 
    int i; 

    _asm { 
        pxor    mm0,mm0             ; mm0清0
    }

    for (i = 0; i < n; i+=8) { 
        _asm {
            mov         ebx,a
            mov         ecx,b
            add         ebx,i
            add         ecx,i
            movq        mm1,qword ptr [ebx] ; mm1=a[7..0]
            movq        mm2,qword ptr [ecx] ; mm2=b[7..0]
            punpcklbw   mm6,mm1 ; mm6=a[3],0,a[2],0,a[1],0,a[0],0
            punpcklbw   mm7,mm2 ; mm7=b[3],0,b[2],0,b[1],0,b[0],0 
            psraw       mm6,8   ; mm6=0,a[3],0,a[2],0,a[1],0,a[0] 
            psraw       mm7,8   ; mm7=0,b[3],0,b[2],0,b[1],0,b[0] 
            punpckhbw   mm4,mm1 ; mm4=a[7],0,a[6],0,a[5],0,a[4],0 
            punpckhbw   mm5,mm2 ; mm5=b[7],0,b[6],0,b[5],0,b[4],0 
            psraw       mm4,8   ; mm4=0,a[7],0,a[6],0,a[5],0,a[4] 
            psraw       mm5,8   ; mm5=0,b[7],0,b[6],0,b[5],0,b[4]  
            pmaddwd     mm6,mm7 ; mm6=a[3]*b[3],a[2]*b[2],a[1]*b[1],a[0]*b[0]
            pmaddwd     mm4,mm5 ; mm4=a[7]*b[7],a[6]*b[6],a[5]*b[5],a[4]*b[4] 
            paddd       mm0,mm6 ; mm0+=a[3]*b[3],a[2]*b[2],a[1]*b[1],a[0]*b[0] 
            paddd       mm0,mm4 ; mm0+=a[7]*b[7],a[6]*b[6],a[5]*b[5],a[4]*b[4] 
        } 
    } 
    _asm { 
        movq        mm1,mm0 
        psrlq       mm1,32      ; mm1 = mm0 右移32位
        paddd       mm0,mm1     ; mm0和mm1的高32位、低32位分别相加 
        movd        r,mm0       ; 取mm0的低32位到r 
        emms 
    } 
    return r; 
} 

int main()
{
    int r1,r2;

    r1 = idot_product_char_c(a,b,16);
    r2 = idot_product_char_mmx(a,b,16);

    printf("idot_product_char_c() = %d\n", r1);
    printf("idot_product_char_mmx() = %d\n", r2);
}


