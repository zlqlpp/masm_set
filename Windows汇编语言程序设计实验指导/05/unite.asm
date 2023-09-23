;�����嵥��unite.asm(C/������ϱ�̵���ģ��)
.386
.model flat
public  _strFormula                     ; ����strFormula��Cģ����ʹ��
public  _xval, _yval, _zval             ; ����xval,yval,zval��Cģ����ʹ��
; �ڻ�������Ҫ����Cģ���������ı���, �ڱ�����ǰǰ���»���
; Cģ���е�x,y,z�ڻ��ģ����дΪ_x, _y, _z
extrn   _x:sdword, _y:sdword, _z:sdword    ; _x, _y, _z��Cģ����
.data
; �������ı������Ҫ��Cģ�鹲��, ��Ҫ������ǰ���»���.
; Cģ��ʹ����Щ����ʱ, ����ǰ�����»���.
; ���ģ���е�_strFormula��Cģ����дΪstrFormula
; ���ģ���е�_xval,_yval,_zval��Cģ����дΪxval,yval,zval
_strFormula     byte    "Pythagorean theorem: x*x+y*y=z*z", 0
_xval           sdword   3
_yval           sdword   4
_zval           sdword   5
.code
Verify1         proc    C
                mov     eax, _x         ; _x��ȫ�ֱ���x
                mul     eax             ; x*x -> eax
                mov     ecx, eax        ; x*x -> ecx
                mov     eax, _y         ; _y��ȫ�ֱ���y
                mul     eax             ; y*y -> eax
                add     ecx, eax        ; x*x+y*y -> ecx 
                mov     eax, _z         ; _z��ȫ�ֱ���z
                mul     eax             ; z*z -> eax
                cmp     eax, ecx        ; �Ƚ�x*x+y*y��z*z
                jz      IsEqual
                mov     eax, 0          ; ����, ����0
                ret     
IsEqual:                
                mov     eax, 1          ; ���, ����1
                ret   
Verify1         endp
; x,y,z��Ϊ����������C���ݵ����ģ��
Verify2         proc    C       x:sdword, y:sdword, z:sdword
                mov     eax, x          ; x�ڶ�ջ��             
                mul     eax             ; x*x -> eax
                mov     ecx, eax        ; x*x -> ecx       
                mov     eax, y          ; y�ڶ�ջ��
                mul     eax             ; y*y -> eax
                add     ecx, eax        ; x*x+y*y -> ecx
                mov     eax, z          ; z�ڶ�ջ��
                mul     eax             ; z*z -> eax
                cmp     eax, ecx        ; �Ƚ�x*x+y*y��z*z
                jz      IsEqual2        
                mov     eax, 0          ; ����, ����0
                ret
IsEqual2:               
                mov     eax, 1          ; ���, ����1
                ret
                        
Verify2         endp
; x,y,z,pxxyy,pzz��Ϊ����������C���ݵ����ģ��
Verify3         proc    C       uses esi edi \
                                x:sdword, y:sdword, z:sdword, \
                                pxxyy:ptr sdword, pzz:ptr sdword
;                push    esi             ; �ӳ������õ�ebx, esi, ediʱ
;                push    edi             ; ���뱣���ڶ�ջ��
                mov     eax, x          ; x�ڶ�ջ��             
                mul     eax             ; x*x -> eax
                mov     ecx, eax        ; x*x -> ecx       
                mov     eax, y          ; y�ڶ�ջ��
                mul     eax             ; y*y -> eax
                add     ecx, eax        ; x*x+y*y -> ecx
                mov     eax, z          ; z�ڶ�ջ��
                mul     eax             ; z*z -> eax
                mov     esi, pxxyy      ; pxxyy�ڶ�ջ��, ָ��Cģ���е�xxyy
                mov     [esi], ecx      ; x*x+y*y -> xxyy
                mov     edi, pzz        ; pzz�ڶ�ջ��, ָ��Cģ���е�zz
                mov     [edi], eax      ; z*z -> eax
;                pop     edi             ; �ָ�edi
;                pop     esi             ; �ָ�esi      
                ret   
Verify3         endp
; �˴�����Ļ���ʽ��_XYZ�ṹ��Cģ���е�_XYZ�ṹһ��
_XYZ            struc
                x       sdword ?
                y       sdword ?
                z       sdword ?
                xxyy    sdword ?
                zz      sdword ?
_XYZ            ends
; pxyz��Ϊ����������C���ݵ����ģ��
Verify4         proc    C       pxyz:ptr _XYZ
                push    ebx                        ; �ӳ������õ�
                push    esi                        ; ebx, esi, ediʱ
                push    edi                        ; ���뱣���ڶ�ջ��
                mov     ebx, pxyz                  ; ebxָ��ṹxyz
                mov     eax, (_XYZ PTR [ebx]).x    ; �ӽṹ��ȡ��x
                mul     eax                        ; x*x -> eax
                mov     ecx, eax                   ; x*x -> ecx
                mov     eax, (_XYZ PTR [ebx]).y    ; �ӽṹ��ȡ��y
                mul     eax                        ; y*y -> eax
                add     ecx, eax                   ; x*x+y*y -> ecx
                mov     eax, (_XYZ PTR [ebx]).z    ; �ӽṹ��ȡ��y
                mul     eax                        ; z*z -> eax
                lea     esi, (_XYZ PTR [ebx]).xxyy ; esiָ��xyz.xxyy
                mov     [esi], ecx                 ; x*x+y*y -> xyz.xxyy
                lea     edi, (_XYZ PTR [ebx]).zz   ; ediָ��xyz.zz
                mov     [edi], eax                 ; z*z -> xyz.zz
                pop     edi                        ; �ָ�edi
                pop     esi                        ; �ָ�esi
                pop     ebx                        ; �ָ�ebx
                ret   
Verify4         endp
end
