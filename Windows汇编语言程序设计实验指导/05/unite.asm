;程序清单：unite.asm(C/汇编联合编程的子模块)
.386
.model flat
public  _strFormula                     ; 允许strFormula被C模块所使用
public  _xval, _yval, _zval             ; 允许xval,yval,zval被C模块所使用
; 在汇编中如果要共享C模块数据区的变量, 在变量名前前加下划线
; C模块中的x,y,z在汇编模块中写为_x, _y, _z
extrn   _x:sdword, _y:sdword, _z:sdword    ; _x, _y, _z在C模块中
.data
; 数据区的变量如果要和C模块共享, 需要在名字前加下划线.
; C模块使用这些变量时, 名字前不加下划线.
; 汇编模块中的_strFormula在C模块中写为strFormula
; 汇编模块中的_xval,_yval,_zval在C模块中写为xval,yval,zval
_strFormula     byte    "Pythagorean theorem: x*x+y*y=z*z", 0
_xval           sdword   3
_yval           sdword   4
_zval           sdword   5
.code
Verify1         proc    C
                mov     eax, _x         ; _x是全局变量x
                mul     eax             ; x*x -> eax
                mov     ecx, eax        ; x*x -> ecx
                mov     eax, _y         ; _y是全局变量y
                mul     eax             ; y*y -> eax
                add     ecx, eax        ; x*x+y*y -> ecx 
                mov     eax, _z         ; _z是全局变量z
                mul     eax             ; z*z -> eax
                cmp     eax, ecx        ; 比较x*x+y*y和z*z
                jz      IsEqual
                mov     eax, 0          ; 不等, 返回0
                ret     
IsEqual:                
                mov     eax, 1          ; 相等, 返回1
                ret   
Verify1         endp
; x,y,z作为函数参数从C传递到汇编模块
Verify2         proc    C       x:sdword, y:sdword, z:sdword
                mov     eax, x          ; x在堆栈中             
                mul     eax             ; x*x -> eax
                mov     ecx, eax        ; x*x -> ecx       
                mov     eax, y          ; y在堆栈中
                mul     eax             ; y*y -> eax
                add     ecx, eax        ; x*x+y*y -> ecx
                mov     eax, z          ; z在堆栈中
                mul     eax             ; z*z -> eax
                cmp     eax, ecx        ; 比较x*x+y*y和z*z
                jz      IsEqual2        
                mov     eax, 0          ; 不等, 返回0
                ret
IsEqual2:               
                mov     eax, 1          ; 相等, 返回1
                ret
                        
Verify2         endp
; x,y,z,pxxyy,pzz作为函数参数从C传递到汇编模块
Verify3         proc    C       uses esi edi \
                                x:sdword, y:sdword, z:sdword, \
                                pxxyy:ptr sdword, pzz:ptr sdword
;                push    esi             ; 子程序中用到ebx, esi, edi时
;                push    edi             ; 必须保存在堆栈中
                mov     eax, x          ; x在堆栈中             
                mul     eax             ; x*x -> eax
                mov     ecx, eax        ; x*x -> ecx       
                mov     eax, y          ; y在堆栈中
                mul     eax             ; y*y -> eax
                add     ecx, eax        ; x*x+y*y -> ecx
                mov     eax, z          ; z在堆栈中
                mul     eax             ; z*z -> eax
                mov     esi, pxxyy      ; pxxyy在堆栈中, 指向C模块中的xxyy
                mov     [esi], ecx      ; x*x+y*y -> xxyy
                mov     edi, pzz        ; pzz在堆栈中, 指向C模块中的zz
                mov     [edi], eax      ; z*z -> eax
;                pop     edi             ; 恢复edi
;                pop     esi             ; 恢复esi      
                ret   
Verify3         endp
; 此处定义的汇编格式的_XYZ结构与C模块中的_XYZ结构一致
_XYZ            struc
                x       sdword ?
                y       sdword ?
                z       sdword ?
                xxyy    sdword ?
                zz      sdword ?
_XYZ            ends
; pxyz作为函数参数从C传递到汇编模块
Verify4         proc    C       pxyz:ptr _XYZ
                push    ebx                        ; 子程序中用到
                push    esi                        ; ebx, esi, edi时
                push    edi                        ; 必须保存在堆栈中
                mov     ebx, pxyz                  ; ebx指向结构xyz
                mov     eax, (_XYZ PTR [ebx]).x    ; 从结构中取出x
                mul     eax                        ; x*x -> eax
                mov     ecx, eax                   ; x*x -> ecx
                mov     eax, (_XYZ PTR [ebx]).y    ; 从结构中取出y
                mul     eax                        ; y*y -> eax
                add     ecx, eax                   ; x*x+y*y -> ecx
                mov     eax, (_XYZ PTR [ebx]).z    ; 从结构中取出y
                mul     eax                        ; z*z -> eax
                lea     esi, (_XYZ PTR [ebx]).xxyy ; esi指向xyz.xxyy
                mov     [esi], ecx                 ; x*x+y*y -> xyz.xxyy
                lea     edi, (_XYZ PTR [ebx]).zz   ; edi指向xyz.zz
                mov     [edi], eax                 ; z*z -> xyz.zz
                pop     edi                        ; 恢复edi
                pop     esi                        ; 恢复esi
                pop     ebx                        ; 恢复ebx
                ret   
Verify4         endp
end
