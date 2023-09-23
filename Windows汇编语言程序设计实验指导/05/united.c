//�����嵥��united.c(C/������ϱ�̵���ģ��)
#include "stdio.h"
extern int xval, yval, zval;    /* ˵��xval,yval,zval������ */ 
extern char strFormula[];       /* ˵��strFormula������ */
extern int x, y, z;             /* ����x,y,z�����ģ����ʹ�� */
struct _XYZ {           /* �ṹ_XYZ��Cģ��ͻ��ģ��֮�䴫�ݲ��� */
        int x, y, z;    /* x,y,z: ��Cģ�鴫�ݵ����ģ�� */
        int xxyy;       /* xxyy:  �ӻ��ģ�鴫�ݵ�Cģ��, xxyy = x*x+y*y */
        int zz;         /* zz:    �ӻ��ģ�鴫�ݵ�Cģ��*/
};
/* ����4������/�ӳ���λ�ڻ��ģ����, ��extern˵�� */
/* x,y,z��Ϊȫ�ֱ���, ����1��ʾx*x+y*y=z*z */
extern int Verify1(void);
/* x,y,z��Ϊ��������, ����1��ʾx*x+y*y=z*z */
extern int Verify2(int x, int y, int z);
/* x,y,z��Ϊ��������, x*x+y*y��z*z�ֱ𱣴���pxxyy��pzzָ��������� */
extern void Verify3(int x, int y, int z, int *pxxyy, int *pzz);
/* pxyz��Ϊ��������, ����һ��ָ��_XYZ�ṹ��ָ�뵽���ģ�� */
extern void Verify4(struct _XYZ *pxyz);
/*
 * strFormula, xval, yval, zval �����ڻ��ģ�����������,
 * ��ǰ����ͨ��extern˵�����ǵ�����
 */
void test0()
{
        printf("%s\n", strFormula);
        printf("Ex: x=%d y=%d z=%d\n", xval, yval, zval);
}
/*
 * Verify1�ӳ������Cģ���ȫ�ֱ���x,y,z����֤��ʽx*x+y*y=z*z
 * ��ǰ����ͨ��extern������ģ�����ȫ�ֱ���x,y,z
 */
void test1()
{
        int ret = Verify1();
        printf("Verify1() = %d\n\n", ret);
}
/*
 * x,y,zͨ��������������ʽ���ݸ�Verify2�ӳ���
 */
void test2()
{
        int ret = Verify2(x, y, z);
        printf("Verify2(%d, %d, %d) = %d\n\n", x, y, z, ret);
}
/*
 * x,y,z,xxyy�ĵ�ַ,zz�ĵ�ַһ��5���������ݸ�Verify3�ӳ���
 * Verify3�ӳ������x*x+y*y����xxyy��, ���z*z����zz��
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
 * �ṹxyz�ĵ�ַ��Ϊ�����������ݸ�Verify4�ӳ���
 * Verify4�ӳ���ӽṹxyz��ȡ��x, y, z
 * ���x*x+y*y����xyz.xxyy��, ���z*z����xyz.zz��
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
