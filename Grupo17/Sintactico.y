%{
#include <stdio.h>
#include <stdlib.h>
//#include <conio.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;
int yylex();
int yyparse();
int yyerror();
%}

%token IF WHILE DECVAR ENDDEC INTEGER FLOAT WRITE ELSE OP_ASIG
%token OP_SUMA OP_MULT OP_MAY OP_MAYEIGU OP_MEN OP_MENEIGU OP_IGUAL
%token OP_DIF PAR_A PAR_C LLAV_A LLAV_C OP_RESTA OP_DIV
%token PYC COMA ID CONST_ENT CONST_REAL CTE_STRING AND NOT OR READ STRING 
%token COR_A COR_C INLIST BETWEEN DOS_PUNTOS

%%

iniciopro: DECVAR declaracion ENDDEC programa
          | escrituraSinVar 

programa: sentencia 	                  {printf("\nREGLA 1: <programa>--><sentencia>\n");}
	      | programa sentencia          

sentencia: asignacion PYC		{printf("\nREGLA 3: <sentencia>--><asignacion> PYC\n");}
          | ciclo                   {printf("\nREGLA 4: <sentencia>--><ciclo>\n");}
          | decisiones              {printf("\nREGLA 5: <sentencia>--><decisiones>\n");}
          | escritura PYC           {printf("\nREGLA 6: <sentencia>--><escritura> PYC\n");}
          | lectura PYC             {printf("\nREGLA 7: <sentencia>--><lectura> PYC\n");}         
               
declaracion: listadeclara                  {printf("\nREGLA 8: <declaracion>--><listadeclara> PYC\n");}      
            | declaracion listadeclara		{printf("\nREGLA 9: <declaracion>--><declaracion> <listadeclara> PYC\n");}            

listadeclara : listvar DOS_PUNTOS tdato      {printf("\nREGLA 10: <listadeclara>--><listvar> OP_ASIG <tdato>\n");}
;

listvar : listvar COMA ID             {printf("\nREGLA 11: <listvar>--><listvar> COMA ID\n");}
        | ID                        {printf("\nREGLA 12: <listvar>-->ID\n");}
		;

tdato: INTEGER                {printf("\nREGLA 13: <tdato>-->INTEGER\n");}
      | FLOAT                 {printf("\nREGLA 14: <tdato>-->FLOAT\n");}
      | STRING                {printf("\nREGLA 15: <tdato>-->STRING\n");}
	  ;

escrituraSinVar: escrituraSinVarSente {printf("\nREGLA 16: <escrituraSinVar>--><escrituraSinVarSente>\n");}
                 | escrituraSinVar escrituraSinVarSente
				 ;

escrituraSinVarSente: WRITE CTE_STRING PYC {printf("\nREGLA 18: <escrituraSinVarSente>-->WRITE CTE_STRING PYC\n");}
;

decisiones : IF PAR_A condicion AND condicion PAR_C LLAV_A programa LLAV_C ELSE LLAV_A programa LLAV_C {printf("\nREGLA 20: <decisiones>-->IF PAR_A <condicion> AND <condicion> PAR_C LLAV_A <programa> LLAV_C ELSE LLAV_A <programa> LLAV_C\n");}
            | IF PAR_A condicion OR condicion PAR_C LLAV_A programa LLAV_C ELSE LLAV_A programa LLAV_C {printf("\nREGLA 21: <decisiones>-->IF PAR_A <condicion> OR <condicion> PAR_C LLAV_A <programa> LLAV_C ELSE LLAV_A <programa> LLAV_C\n");}
            | IF PAR_A NOT condicion PAR_C LLAV_A programa LLAV_C ELSE LLAV_A programa LLAV_C {printf("\nREGLA 22: <decisiones>-->IF PAR_A NOT <condicion> PAR_C LLAV_A <programa> LLAV_C ELSE LLAV_A <programa> LLAV_C\n");}
            | IF PAR_A condicion PAR_C LLAV_A programa LLAV_C ELSE LLAV_A programa LLAV_C {printf("\nREGLA 23: <decisiones>-->IF PAR_A <condicion> PAR_C LLAV_A <programa> LLAV_C ELSE LLAV_A <programa> LLAV_C\n");}
            | IF PAR_A condicion AND condicion PAR_C LLAV_A programa LLAV_C  {printf("\nREGLA 24: <decisiones>-->IF PAR_A <condicion> AND <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
            | IF PAR_A condicion OR condicion PAR_C LLAV_A programa LLAV_C {printf("\nREGLA 25: <decisiones>-->IF PAR_A <condicion> OR <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
            | IF PAR_A NOT condicion PAR_C LLAV_A programa LLAV_C  {printf("\nREGLA 26: <decisiones>-->IF PAR_A NOT <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
            | IF PAR_A condicion PAR_C LLAV_A programa LLAV_C  {printf("\nREGLA 27: <decisiones>-->IF PAR_A <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
			;
            

ciclo : WHILE PAR_A condicion AND condicion PAR_C LLAV_A programa LLAV_C {printf("\nREGLA 28: <ciclo>-->WHILE PAR_A <condicion> AND <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
        | WHILE PAR_A condicion OR condicion PAR_C LLAV_A programa LLAV_C {printf("\nREGLA 29: <ciclo>-->WHILE PAR_A <condicion> OR <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
        | WHILE PAR_A NOT condicion PAR_C LLAV_A programa LLAV_C {printf("\nREGLA 30: <ciclo>-->WHILE PAR_A NOT <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
        | WHILE PAR_A condicion PAR_C LLAV_A programa LLAV_C {printf("\nREGLA 31: <ciclo>-->WHILE PAR_A <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
		;

escritura : WRITE ID          {printf("\nREGLA 32: <escritura>-->WRITE ID\n");}
          | WRITE CTE_STRING  {printf("\nREGLA 33: <escritura>-->WRITE CTE_STRING\n");}
		  ;

lectura : READ ID             {printf("\nREGLA 34: <lectura>-->READ ID\n");}
;

condicion : opera oplog opera   {printf("\nREGLA 35:<condicion>--><opera> <oplog> <opera>\n");}
            | funcionlist      {printf("\nREGLA 36:<condicion>--><funcionList>\n");}
			| funcionbetween	{printf("\nREGLA 47:<condicion>--><funcionBetween>\n");}
			;

opera: CONST_ENT        {printf("\nREGLA 37: <opera>-->CONST_ENT\n");}
      | CONST_REAL      {printf("\nREGLA 38: <opera>-->CONST_REAL\n");}
      | ID              {printf("\nREGLA 39: <opera>-->ID\n");}
      ;

oplog: OP_MAYEIGU       {printf("\nREGLA 40: <opera>-->OP_MAYEIGU\n");}
    | OP_MENEIGU         {printf("\nREGLA 41: <opera>-->OP_MENEIGU\n");}
    | OP_IGUAL             {printf("\nREGLA 42: <opera>-->OP_IGUAL\n");}
    | OP_MAY              {printf("\nREGLA 43: <opera>-->OP_MAY\n");}
    | OP_MEN             {printf("\nREGLA 44: <opera>-->OP_MEN\n");}
    | OP_DIF             {printf("\nREGLA 45: <opera>-->OP_DIF\n");}
    ;

funcionlist: INLIST PAR_A ID PYC COR_A list COR_C PAR_C {printf("\nREGLA 46: <funcionlist>-->INLIST PAR_A ID PYC COR_A <list> COR_C PAR_C\n");}
;

list: list PYC var      
      | var             {printf("\nREGLA 48: <list>--><var>\n");}
	  ;

var: expresion           {printf("\nREGLA 49: <list>--><expresion>\n");}
;

asignacion: ID OP_ASIG expresion	      {printf("\nREGLA 50: <asignacion>-->ID OP_ASIG <expresion>\n");}
            | ID OP_ASIG CTE_STRING       {printf("\nREGLA 51: <asignacion>-->ID OP_ASIG CTE_STRING\n");}
			;
            
		
expresion: termino                        {printf("\nREGLA 52: <expresion>--><termino>\n");}
		   | expresion OP_SUMA termino {printf("\nREGLA 53: <expresion>--><expresion> OP_SUMA <termino>\n");}
		   | expresion OP_RESTA termino {printf("\nREGLA 54: <expresion>--><expresion> OP_RESTA <termino>\n");}
		   ;
		   

termino:  factor                          {printf("\nREGLA 55: <termino>--><factor>\n");}
		 | termino OP_MULT factor	{printf("\nREGLA 56: <termino>--><termino> OP_MULT <factor>\n");}
		 | termino OP_DIV factor	{printf("\nREGLA 57: <termino>--><termino> OP_DIV <factor>\n");}
		 ;

factor : CONST_ENT                         {printf("\nREGLA 58: <factor>-->CONST_ENT\n");}
		| ID                            {printf("\nREGLA 59: <factor>-->ID\n");}
            | CONST_REAL                         {printf("\nREGLA 60: <factor>-->CONST_REAL\n");}
		| PAR_A expresion PAR_C             {printf("\nREGLA 61: <factor>-->PAR_A <expresion> PAR_C\n");}
		;
		
funcionbetween : BETWEEN PAR_A ID COMA COR_A expresion PYC expresion COR_C PAR_C	{printf("\nREGLA 62:<funcionbetween>-->BETWEEN PAR_A ID COMA COR_A <expresion> PYC <expresion> COR_C PAR_C\n");}
;
		
%%

