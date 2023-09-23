//程序清单：united.c(C/汇编联合编程的主模块)
#include "stdio.h"
extern int xval, yval, zval;    /* 说明xval,yval,zval的类型 */ 
extern char strFormula[];       /* 说明strFormula的类型 */
extern int x, y, z;             /* 允许x,y,z被汇编模块所使用 */
struct _XYZ {           /* 结构_XYZ在C模块和汇编模块之间传递参数 */
        int x, y, z;    /* x,y,z: 从C模块传递到汇编模块 */
        int xxyy;       /* xxyy:  从汇编模块传递到C模块, xxyy = x*x+y*y */
        int zz;         /* zz:    从汇编模块传递到C模块*/
};
/* 以下4个函数/子程序位于汇编模块中, 用extern说明 */
/* x,y,z作为全局变量, 返回1表示x*x+y*y=z*z */
extern int Verify1(void);
/* x,y,z作为函数参数, 返回1表示x*x+y*y=z*z */
extern int Verify2(int x, int y, int z);
/* x,y,z作为函数参数, x*x+y*y和z*z分别保存在pxxyy和pzz指向的整数中 */
extern void Verify3(int x, int y, int z, int *pxxyy, int *pzz);
/* pxyz作为函数参数, 传递一个指向_XYZ结构的指针到汇编模块 */
extern void Verify4(struct _XYZ *pxyz);
/*
 * strFormula, xval, yval, zval 定义在汇编模块的数据区中,
 * 在前面已通过extern说明它们的类型
 */
void test0()
{
        printf("%s\n", strFormula);
        printf("Ex: x=%d y=%d z=%d\n", xval, yval, zval);
}
/*
 * Verify1子程序访问C模块的全局变量x,y,z来验证公式x*x+y*y=z*z
 * 在前面已通过extern允许汇编模块访问全局变量x,y,z
 */
void test1()
{
        int ret = Verify1();
        printf("Verify1() = %d\n\n", ret);
}
/*
 * x,y,z通过函数参数的形式传递给Verify2子程序
 */
void test2()
{
        int ret = Verify2(x, y, z);
        printf("Verify2(%d, %d, %d) = %d\n\n", x, y, z, ret);
}
/*
 * x,y,z,xxyy的地址,zz的地址一共5个参数传递给Verify3子程序
 * Verify3子程序求出x*x+y*y放入xxyy中, 求出z*z放入zz中
 */
void test3()
{
        int xxyy;
        int zz;
        Verify3(x, y, z, &xxyy, &zz);
        printf("Verify3(%d, %d, %d, 0x%p, 0x%p)\n", x, y, z, &xxyy, &zz);
        printf("xxyy=%d, zz=%d\n\n", xxyy, zz);
}
/*
 * 结构xyz的地址作为函数参数传递给Verify4子程序
 * Verify4子程序从结构xyz中取出x, y, z
 * 求出x*x+y*y放入xyz.xxyy中, 求出z*z放入xyz.zz中
 */
void test4()
{
        struct _XYZ xyz;
        xyz.x = x;
        xyz.y = y;
        xyz.z = z;
        Verify4(&xyz);
        printf("Verify4(0x%p)\n", &xyz);
        printf("xyz.xxyy=%d, xyz.zz=%d\n\n", xyz.xxyy, xyz.zz);
}
int x, y, z;
int main()
{
        test0();
        printf("input x y z: ");
        scanf("%d %d %d", &x, &y, &z);
        printf("x=%d, y=%d, z=%d\n\n", x, y, z);
        test1();
        test2();
        test3();
        test4();
        return 0;
}
