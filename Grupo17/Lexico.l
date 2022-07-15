%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
#include "lib\funciones.h"
#include "math.h"
#include <string.h>

FILE  *yyin;
char *yyltext;
char auxValor[50];
int yyerror();
int yyparse();
int yylex();
%}
%option noyywrap  
%option yylineno 



LETRA			[A-Za-z]
DIGITO			[0-9]
ESPACIO			[" "]

CTE_STRING		\".+\"      
CONST_ENT	({DIGITO})+
CONST_REAL	  ({DIGITO})*"."({DIGITO})+|({DIGITO})+"."({DIGITO})*
CARACTERCOM		@|\?|\"|\(|\)|\-|\.|\,|\+|\t|\n|\/|\_|\:|\;|¿|\*|{LETRA}|{DIGITO}|{ESPACIO} 
COMENTARIO  	("-")(\/)({CARACTERCOM})*(("-")(\/)({CARACTERCOM})*(\/)("-"))?({CARACTERCOM})*(\/)("-")
ID			({LETRA})({LETRA}|{DIGITO})*

IF			"if"
INLIST  "inlist"
BETWEEN "between"
WHILE		"while"
DECVAR		"DECVAR"
ENDDEC		"ENDDEC"
INTEGER		"integer"
STRING    "string"
FLOAT		"float"
WRITE		"write"
ELSE		"else"
AND     "AND"
OR      "OR"
NOT     "NOT"
READ    "read"
  
OP_ASIG		[:]
OP_SUMA		[+]
OP_MULT		[*]
OP_MAY		[>]
OP_MAYEIGU	">="
OP_MEN		[<]
OP_MENEIGU	"<="
OP_IGUAL	"=="
OP_DIF		"!="
OP_RESTA  [-]
OP_DIV    [/]

PAR_A	[(]
PAR_C	[)]
LLAV_A	[{]
LLAV_C	[}]
COR_A   [[]
COR_C   []]
PYC		[;]

COMA		[,]

%%
	
{IF}		      {return IF;}
{INLIST}      {return INLIST;}
{BETWEEN}      {return BETWEEN;}
{ELSE}        {return ELSE;}
{WHILE}       {return WHILE;}
{DECVAR}	    {return DECVAR;}
{READ}        {return READ;}
{NOT}         {return NOT;}
{OR}          {return OR;}
{AND}         {return AND;}
{ENDDEC}	    {return ENDDEC;}
{INTEGER}	    {return INTEGER;}
{STRING}      {return STRING;}
{FLOAT}		    {return FLOAT;}
{WRITE}		    {return WRITE;}
{ELSE}		    {return ELSE;}
{CONST_ENT}   {yylval.intval = atoi(yytext) ;verifRangoCTE_ENT(yytext,yylineno);colocarEnTablaSimb(yytext,1,yylineno,CteInt); 
                                                                                    return CONST_ENT;}
{CONST_REAL}  { strcpy(cteFlo,yytext);  yylval.val = atof(yytext); printf("%s",yytext); verifRangoCTE_REAL(yytext,yylineno);colocarEnTablaSimb(yytext,1,yylineno,CteFloat);
                                                                            return CONST_REAL;}

{PAR_A}		{return PAR_A;}
{ID}	        {yylval.str_val = strdup(yytext); verifRangoID(yytext,yylineno);return ID;}
{PAR_C}		{return PAR_C;}
{LLAV_A}	{return LLAV_A;}
{LLAV_C}	{return LLAV_C;}


{PYC}		  {return PYC;}
{COR_A}   {return COR_A;}
{COR_C}   {return COR_C;}
{COMA}			  {return COMA;}
{CTE_STRING}	{strcpy(auxValor,yytext);replace(yytext,'_',' '); yylval.str_val = strdup(yytext);verifRangoString(yytext,yylineno);colocarEnTablaSimb(yytext,1,yylineno,CteString);
                                                                                cambiarValor(auxValor);return CTE_STRING;}


{OP_ASIG}		{return OP_ASIG;}
{OP_SUMA}		{return OP_SUMA;}
{OP_RESTA}		{return OP_RESTA;}
{OP_MULT}		{return OP_MULT;}
{OP_DIV}		{return OP_DIV;}
{OP_MAY}		{return OP_MAY;}
{OP_MAYEIGU}	{return OP_MAYEIGU;}
{OP_MEN}		{return OP_MEN;}
{OP_MENEIGU}	{return OP_MENEIGU;}
{OP_IGUAL}		{return OP_IGUAL;}
{OP_DIF}		{return OP_DIF;}

{COMENTARIO} 

"\r" 
"\n"
"\t"		
" "
.                  errorCaracter(yytext,yylineno);
%%


int main(int argc,char *argv[])
{ 
  crearPila(&pilaExpresion);
  crearPila(&pilaOperadoresCond);
  crearPila(&pilaTermino);
  crearPila(&pilaFactor);
  crearPila(&pilaPrograma);
  crearPila(&pilaCondicion);

  cuentaRegs=0;
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	  printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
    return 1;
  }
  if((tab = fopen("ts.txt", "wt")) == NULL)
      {
        printf("\nNo se puedo crear el archivo tabla_de_simbolos.bin\n");
      return 1;
      }
  /*
  if ((graph = fopen("graph.dot", "wt")) == NULL)
          {
            printf("\nNo se puede abrir el archivo \n");
            return 1;
          }
    */
  if ((intermedia = fopen("intermedia.txt", "wt")) == NULL)
          {
            printf("\nNo se puede abrir el archivo \n");
            return 1;
          }
	yyparse();
  vaciarPila(&pilaExpresion);
  vaciarPila(&pilaOperadoresCond);
  vaciarPila(&pilaTermino);
  vaciarPila(&pilaFactor);
  vaciarPila(&pilaPrograma);
  vaciarPila(&pilaCondicion);
  fclose(yyin);
  //fclose(graph);
  fclose(intermedia);
  return 0;
}

int yyerror(void)
    { 
      printf("\nlinea %d: Error sintactico\n",yylineno);
	    system ("Pause");
	  exit (1);
     }

