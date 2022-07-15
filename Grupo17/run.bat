flex Lexico.l
bison -dyv Sintactico.y

gcc lex.yy.c y.tab.c -o Grupo17.exe

Grupo17.exe Prueba.txt

@echo off
del Grupo17.exe
del lex.yy.c
del y.tab.c
del y.tab.h
del y.output

pause
