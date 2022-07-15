include macros2.asm
include number.asm

.MODEL LARGE
.STACK 200h
.386
.DATA

MAXTEXTSIZE                   equ                 40                  
_auxR0                        dd                  0.0                 
_auxE0                        dd                  0                   
_auxR1                        dd                  0.0                 
_auxE1                        dd                  0                   
_auxR2                        dd                  0.0                 
_auxE2                        dd                  0                   
_auxR3                        dd                  0.0                 
_auxE3                        dd                  0                   
_auxR4                        dd                  0.0                 
_auxE4                        dd                  0                   
_auxR5                        dd                  0.0                 
_auxE5                        dd                  0                   
_auxR6                        dd                  0.0                 
_auxE6                        dd                  0                   
_auxR7                        dd                  0.0                 
_auxE7                        dd                  0                   
_auxR8                        dd                  0.0                 
_auxE8                        dd                  0                   
_auxR9                        dd                  0.0                 
_auxE9                        dd                  0                   
_auxR10                       dd                  0.0                 
_auxE10                       dd                  0                   
_auxR11                       dd                  0.0                 
_auxE11                       dd                  0                   
_auxR12                       dd                  0.0                 
_auxE12                       dd                  0                   
_auxR13                       dd                  0.0                 
_auxE13                       dd                  0                   
_auxR14                       dd                  0.0                 
_auxE14                       dd                  0                   
var3                          dd                  ?                   
var9                          dd                  ?                   
var4                          dd                  ?                   
var6                          dd                  ?                   
var7                          dd                  ?                   
a                             dd                  ?                   
b                             dd                  ?                   
c                             dd                  ?                   
e                             dd                  ?                   
f                             dd                  ?                   
d                             dd                  ?                   
z                             dd                  ?                   
_Ingrese_Variable_b_          db                  "Ingrese Variable b:",'$',19 dup(?)
_10                           dd                  10                  
_3                            dd                  3                   
_2                            dd                  2                   
_8                            dd                  8                   
_0_99cteF                     dd                  0.99                
_2_58cteF                     dd                  2.58                
_49_cteF                      dd                  49.                 
_fin_operaciones              db                  "fin operaciones"   ,'$',15 dup(?)
_5                            dd                  5                   
_Ciclo_while                  db                  "Ciclo while"       ,'$',11 dup(?)
_0                            dd                  0                   
_fin_Ciclo_while              db                  "fin Ciclo while"   ,'$',15 dup(?)
_Inlist                       db                  "Inlist"            ,'$',6 dup(?)
_Ingrese_Variable_Var4_       db                  "Ingrese Variable Var4:",'$',22 dup(?)
__repe1                       dd                  ?                   
__buscar1                     dd                  ?                   
_1                            dd                  1                   
_7                            dd                  7                   
_12                           dd                  12                  
_34                           dd                  34                  
_48                           dd                  48                  
_encontro_var4                db                  "encontro var4"     ,'$',13 dup(?)
_no_encontro_var4             db                  "no encontro var4"  ,'$',16 dup(?)
_If_negado                    db                  "If negado"         ,'$',9 dup(?)
_Ingrese_Variable_e_          db                  "Ingrese Variable e:",'$',19 dup(?)
_e_es_mayor_a_5               db                  "e es mayor a 5"    ,'$',14 dup(?)
_e_no_es_mayor_a_5            db                  "e no es mayor a 5" ,'$',17 dup(?)
_NEWLINE                      db                  0DH,0AH,'$'         

.CODE
.startup
	mov AX,@DATA
	mov DS,AX
FINIT


displayString 	_Ingrese_Variable_b_
displayString _NEWLINE
getInteger 	b
fild 	_10
fistp 	a
fild 	_3
fimul 	_2
fistp 	_auxE0
fild 	a
fiadd 	_auxE0
fistp 	_auxE1
fild 	_2
fiadd 	_2
fistp 	_auxE2
fild 	_auxE2
fidivr 	_8
fistp 	_auxE3
fild 	_auxE1
fisub 	_auxE3
fistp 	_auxE4
fild 	_auxE4
fiadd 	b
fistp 	_auxE5
fild 	_auxE5
fistp 	z
displayInteger 	z,3
displayString _NEWLINE
fld 	_2_58cteF
fmul 	_49_cteF
fstp 	_auxR0
fld 	_0_99cteF
fadd 	_auxR0
fstp 	_auxR1
fld 	_auxR1
fstp 	var9
displayFloat 	var9,3
displayString _NEWLINE
displayString 	_fin_operaciones
displayString _NEWLINE
fild 	a
fild 	_8
fxch
fcom
fstsw	ax
sahf
je	BloqueTrue1
fild 	b
fild 	_5
fxch
fcom
fstsw	ax
sahf
jbe	etiq1
BloqueTrue1:
displayString 	_Ciclo_while
displayString _NEWLINE
etiqWhile1:
fild 	a
fild 	_0
fxch
fcom
fstsw	ax
sahf
jbe	etiq2
fild 	b
fild 	_0
fxch
fcom
fstsw	ax
sahf
jbe	etiq2
BloqueTrue2:
fild 	a
fisub 	_2
fistp 	_auxE6
fild 	_auxE6
fistp 	a
fild 	b
fisub 	_2
fistp 	_auxE7
fild 	_auxE7
fistp 	b
displayInteger 	a,3
displayString _NEWLINE
jmp 	 etiqWhile1
etiq2:
displayString 	_fin_Ciclo_while
displayString _NEWLINE
jmp	 finIf1
etiq1:
displayString 	_Inlist
displayString _NEWLINE
displayString 	_Ingrese_Variable_Var4_
displayString _NEWLINE
getInteger 	var4
fild 	var4
fistp 	__buscar1
fild 	_0
fistp 	__repe1
fild 	_2
fimul 	b
fistp 	_auxE8
fild 	_auxE8
fiadd 	_7
fistp 	_auxE9
fild 	__buscar1
fild 	_auxE9
fxch
fcom
fstsw	ax
sahf
jne	etiqInlist1
BloqueTrueIn1:
fild 	_1
fistp 	__repe1
jmp 	BloqueTrue3
etiqInlist1:
fild 	__buscar1
fild 	_12
fxch
fcom
fstsw	ax
sahf
jne	etiqInlist2
BloqueTrueIn2:
fild 	_1
fistp 	__repe1
jmp 	BloqueTrue3
etiqInlist2:
fild 	_34
fiadd 	d
fistp 	_auxE10
fild 	_auxE10
fimul 	a
fistp 	_auxE11
fild 	_auxE11
fiadd 	b
fistp 	_auxE12
fild 	__buscar1
fild 	_auxE12
fxch
fcom
fstsw	ax
sahf
jne	etiqInlist3
BloqueTrueIn3:
fild 	_1
fistp 	__repe1
jmp 	BloqueTrue3
etiqInlist3:
fild 	__buscar1
fild 	_48
fxch
fcom
fstsw	ax
sahf
jne	etiqInlist4
BloqueTrueIn4:
fild 	_1
fistp 	__repe1
jmp 	BloqueTrue3
etiqInlist4:
fild 	__repe1
fild 	_1
fxch
fcom
fstsw	ax
sahf
jne	etiq3
BloqueTrue3:
displayString 	_encontro_var4
displayString _NEWLINE
jmp	 finIf2
etiq3:
displayString 	_no_encontro_var4
displayString _NEWLINE
finIf2:
finIf1:
displayString 	_If_negado
displayString _NEWLINE
displayString 	_Ingrese_Variable_e_
displayString _NEWLINE
getInteger 	e
fild 	e
fild 	_5
fxch
fcom
fstsw	ax
sahf
jae	etiq4
BloqueTrue4:
displayString 	_e_es_mayor_a_5
displayString _NEWLINE
jmp	 finIf3
etiq4:
displayString 	_e_no_es_mayor_a_5
displayString _NEWLINE
finIf3:

mov ax, 4c00h
int 21h


ffree
strlen proc
	mov bx, 0
	strl01:
	cmp BYTE PTR [si+bx],'$'
	je strend
	inc bx
	jmp strl01
	strend:
	ret
strlen endp

copiar proc
	call strlen
	cmp bx , MAXTEXTSIZE
	jle copiarSizeOk
	mov bx , MAXTEXTSIZE
	copiarSizeOk:
	mov cx , bx
	cld
	rep movsb
	mov al , '$'
	mov byte ptr[di],al
	ret
copiar endp

END