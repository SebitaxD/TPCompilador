%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include "y.tab.h"
#include "lib\pila.c"
#include "lib\funciones.c"
int yystopparser=0;
FILE  *yyin;
extern int yylineno;
char str_aux[50];
char str_aux2[50];
char inlistAux[50];
char inlistAux2[50];
int __buscar;
int __repe;
int tipoDatoID;
char conector[10];
char compara[10];
int cuerpoCont=0;
int auxDato;
int posEnTabla;
int isNegado=0;
int cuentaSent;
int tipoDatoIzq;
int tipoDatoDer;
int tipoDatoID;
int yyerror();
int yyparse();
int yylex();
%}
%union {
int intval;
float val;
char *str_val;
}

%token <str_val>ID
%token <int>CONST_ENT
%token <float>CONST_REAL
%token <str_val>CTE_STRING


%token IF WHILE DECVAR ENDDEC INTEGER FLOAT WRITE ELSE OP_ASIG
%token OP_SUMA OP_MULT OP_MAY OP_MAYEIGU OP_MEN OP_MENEIGU OP_IGUAL
%token OP_DIF PAR_A PAR_C LLAV_A LLAV_C OP_RESTA OP_DIV
%token PYC COMA AND NOT OR READ STRING 
%token COR_A COR_C INLIST BETWEEN
%right MENOS_UNARIO
%left OP_RESTA OP_SUMA
%%
iniciopro: DECVAR declaracion ENDDEC {auxOp=0;cantidadInlist=0;} programa   {
                                                            grabarTabla();
                                                            printf("\n---INTERMEDIA---(ARBOL RECORRIDO EN POSTORDEN)\n");
                                                            postOrden(&programaPtr,intermedia);
                                                            tree_print_dot(&programaPtr,graph);
                                                            generaAssembler(&programaPtr);
                                                           }

          | escrituraSinVar 



programa: sentencia 	                  {
                                          if(programaPtr!=NULL)
                                          {    
                                              sprintf(str_aux, "CUERPO%d",cuerpoCont++);
							                            programaPtr = crearNodo(str_aux, sentenciaPtr, NULL);
                                             
						                             	} else   
                                          {
							                                 programaPtr = sentenciaPtr;
			                                   }
                                         }
	      | programa sentencia          
                                          {
                                                if(programaPtr!=NULL)
                                          {     
                           
                                          sprintf(str_aux, "CUERPO%d",cuerpoCont++);
							                            programaPtr = crearNodo(str_aux, programaPtr, sentenciaPtr);
							                            } 
                                          else 
                                          {    
                                             
                                            sprintf(str_aux, "CUERPO%d",cuerpoCont++);
							                                   programaPtr = crearNodo(str_aux, sentenciaPtr,NULL);
			                                    }
                                          }

                                          

sentencia: asignacion PYC		{ sentenciaPtr = asigPtr;
                                          printf("\nREGLA 3: <sentencia>--><asignacion> PYC\n");}
          | ciclo                   {sentenciaPtr = cicloPtr;printf("\nREGLA 4: <sentencia>--><ciclo>\n");}
          | decisiones              {sentenciaPtr = decisionesPtr;printf("\nREGLA 5: <sentencia>--><decisiones>\n");}
          | escritura PYC           {sentenciaPtr = escrituraPtr;printf("\nREGLA 6: <sentencia>--><escritura> PYC\n");}
          | lectura PYC             {sentenciaPtr = lecturaPtr;printf("\nREGLA 7: <sentencia>--><lectura> PYC\n");}
               
               
declaracion: listadeclara                  {printf("\nREGLA 8: <declaracion>--><listadeclara> PYC\n");}      
            | declaracion listadeclara            {printf("\nREGLA 9: <declaracion>--> <declaracion> <listadeclara> PYC\n");}  

listadeclara : {_cantIds=0;} listvar OP_ASIG tdato      {agregarTipoDeDatoVarAtabla(auxDato);printf("\nREGLA 10: <listadeclara>--><listvar> OP_ASIG <tdato>\n");}

listvar : listvar PYC ID             {_cantIds++;colocarEnTablaSimb($<str_val>3,0,yylineno,0);printf("\nREGLA 11: <listvar>--><listvar> PYC ID\n");}
        | ID                        {_cantIds++;colocarEnTablaSimb($<str_val>1,0,yylineno,0);printf("\nREGLA 12: <listvar>-->ID\n");}

tdato: INTEGER                {auxDato = Integer ;printf("\nREGLA 13: <tdato>-->INTEGER\n");}
      | FLOAT                 {auxDato = Float ;printf("\nREGLA 14: <tdato>-->FLOAT\n");}
      | STRING                {auxDato = String ;printf("\nREGLA 15: <tdato>-->STRING\n");}

escrituraSinVar: escrituraSinVarSente {printf("\nREGLA 16: <escrituraSinVar>--><escrituraSinVarSente>\n");}
                 | escrituraSinVar escrituraSinVarSente  {printf("\nREGLA 17: <escrituraSinVar>--><escrituraSinVar> <escrituraSinVarSente>\n");}

escrituraSinVarSente: WRITE CTE_STRING PYC {printf("\nREGLA 18: <escrituraSinVarSente>-->WRITE CTE_STRING PYC\n");}

decisiones : IF PAR_A condicion conectLog condicion subrutIf4 PAR_C LLAV_A subrutIf programa LLAV_C subrutIf3  ELSE LLAV_A programa LLAV_C {  generaIntermediaIfConElse();
                                                                                                                                  printf("\nREGLA 19: <decisiones>-->IF PAR_A <condicion> <conectLog> <condicion> PAR_C LLAV_A <programa> LLAV_C ELSE LLAV_A <programa> LLAV_C\n");}
            
            
            | IF PAR_A subrutIf2 NOT condicion subrutIf PAR_C LLAV_A programa LLAV_C subrutIf3  ELSE LLAV_A programa LLAV_C {  generaIntermediaIfConElse();
                                                                                                                                    printf("\nREGLA 20: <decisiones>-->IF PAR_A NOT <condicion> PAR_C LLAV_A <programa> LLAV_C ELSE LLAV_A <programa> LLAV_C\n");}
            | IF PAR_A condicion subrutIf PAR_C  LLAV_A programa LLAV_C subrutIf3  ELSE LLAV_A programa LLAV_C { 
                                                                                                                              generaIntermediaIfConElse();
                                                                                                                              printf("\nREGLA 21: <decisiones>-->IF PAR_A <condicion> PAR_C LLAV_A <programa> LLAV_C ELSE LLAV_A <programa> LLAV_C\n");}                                                                                                                   
                                                                                           
            | IF PAR_A condicion conectLog condicion subrutIf4 PAR_C LLAV_A subrutIf programa  LLAV_C  { generaIntermediaIf();   
                                                                                                        printf("\nREGLA 22: <decisiones>-->IF PAR_A <condicion> <conectLog> <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
            
            | IF PAR_A subrutIf2 NOT condicion subrutIf PAR_C LLAV_A  programa LLAV_C  {generaIntermediaIf();  
                                                                                          printf("\nREGLA 23: <decisiones>-->IF PAR_A NOT <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
            | IF PAR_A condicion subrutIf PAR_C LLAV_A programa LLAV_C  {    generaIntermediaIf();             
                                                                            printf("\nREGLA 24: <decisiones>-->IF PAR_A <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
                                                                                     
subrutIf: /* vacio */ { 
                       if(programaPtr!=NULL)
                       {
                         ponerEnPila(&pilaPrograma,&programaPtr,sizeof(programaPtr));
                         programaPtr=NULL;
                       }
                       else
                       {
                       if(sentenciaPtr!=NULL)
                           ponerEnPila(&pilaPrograma,&sentenciaPtr,sizeof(sentenciaPtr));
                       }
                       ponerEnPila(&pilaCondicion,&condicionPtr,sizeof(condicionPtr));
                       isNegado=0;
                      }

subrutIf3: /* vacio */ { 
                        if(programaPtr!=NULL)
                        {
                         ponerEnPila(&pilaPrograma,&programaPtr,sizeof(programaPtr));
                         programaPtr=NULL;
                        }
                        else
                        {
                        if(sentenciaPtr!=NULL)
                           ponerEnPila(&pilaPrograma,&sentenciaPtr,sizeof(sentenciaPtr));
                        }
                       }
subrutIf2:/* vacio */ {isNegado=1;}

subrutIf4:/* vacio */ { 
                        if(!strcmp(conector,"OR"))
                            cuerpo = crearHoja("CONDMOR",SinTipo);
                        else
                            cuerpo = crearHoja("CONDMAND",SinTipo);
                        cuerpo = crearNodo("CUERPO",cuerpo,condicionPtrIzq);
                        condicionPtr = crearNodo(conector,cuerpo,condicionPtr);
                        //condicionPtr = crearNodo(conector,condicionPtrIzq,condicionPtr);
                      }

conectLog: AND  {condicionPtrIzq = condicionPtr; strcpy(conector,"AND"); printf("\nREGLA 25: <conectLog>-->AND\n");} 
           |OR  {condicionPtrIzq = condicionPtr; strcpy(conector,"OR"); printf("\nREGLA 26: <conectLog>-->OR\n");}
                  

ciclo : WHILE PAR_A condicion conectLog  condicion subrutIf4 subrutIf PAR_C LLAV_A programa LLAV_C {      generaIntermediaWhile();
                                                                                                printf("\nREGLA 27: <ciclo>-->WHILE PAR_A <condicion> AND <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
        | WHILE PAR_A NOT subrutIf2 condicion subrutIf PAR_C LLAV_A programa LLAV_C {generaIntermediaWhile();
                                                                                         printf("\nREGLA 28: <ciclo>-->WHILE PAR_A NOT <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
        | WHILE PAR_A condicion PAR_C subrutIf LLAV_A programa LLAV_C {   generaIntermediaWhile(); 
                                                                              printf("\nREGLA 29: <ciclo>-->WHILE PAR_A <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}

escritura : WRITE ID          {posEnTabla=chequearVarEnTabla($<str_val>2,yylineno);
                                    esVariableNumerica(posEnTabla,yylineno);
                                    escrituraPtr=crearNodo("WRITE",crearHoja($<str_val>2,tablaSimb[posEnTabla].tipoDeDato),NULL);
                                          printf("\nREGLA 30: <escritura>-->WRITE ID\n");}
          | WRITE CTE_STRING  { sprintf(str_aux, "_%s",$<str_val>2);
                                escrituraPtr=crearNodo("WRITE",crearHoja(str_aux,CteString),NULL);
                                    printf("\nREGLA 31: <escritura>-->WRITE CTE_STRING\n");}

lectura : READ ID             {posEnTabla=chequearVarEnTabla($<str_val>2,yylineno);
                                    lecturaPtr= crearNodo("READ",crearHoja($<str_val>2,tablaSimb[posEnTabla].tipoDeDato),NULL);
                                    printf("\nREGLA 32: <lectura>-->READ ID\n");}

condicion : opera oplog opera  {
                                 sacarDePila(&pilaOperadoresCond,&operDerPtr,sizeof(operDerPtr));
                                 sacarDePila(&pilaOperadoresCond,&operIzqPtr,sizeof(operDerPtr));
                                 if(isNegado)
                                    invertirCondicion(compara);
                                  tipoDatoIzq=verificarTipoDato(&operIzqPtr,yylineno);
                                  tipoDatoDer=verificarTipoDato(&operDerPtr,yylineno);
                                 errorDeCompatibilidadOperadores(tipoDatoIzq,tipoDatoDer,yylineno,"Los operadores de la condicion no son compatibles");
                                 condicionPtr=crearNodo(compara,operIzqPtr,operDerPtr);
                                 printf("\nREGLA 33:<condicion>--><opera> <oplog> <opera>\n");
                               }
            | funcionlist      { 
                                 condicionPtr = inlistBuscarPtr;
                                 printf("\nREGLA 34:<condicion>--><funcionList>\n");
                               }

opera: expresion        {sacarDePila(&pilaExpresion,&exprPtr,sizeof(exprPtr));
                          //auxCond =crearHoja($<str_val>1,CteInt);
                              ponerEnPila(&pilaOperadoresCond,&exprPtr,sizeof(exprPtr));}
      

oplog: OP_MAYEIGU          {strcpy(compara,"BLT");
                              printf("\nREGLA 35: <opera>-->OP_MAYEIGU\n");}
    | OP_MENEIGU           {strcpy(compara,"BGT");
                              printf("\nREGLA 36: <opera>-->OP_MENEIGU\n");}
    | OP_IGUAL             {strcpy(compara,"BNE");
                              printf("\nREGLA 37: <opera>-->OP_IGUAL\n");}
    | OP_MAY               {strcpy(compara,"BLE");
                              printf("\nREGLA 38: <opera>-->OP_MAY\n");}
    | OP_MEN               {strcpy(compara,"BGE");
                              printf("\nREGLA 39: <opera>-->OP_MEN\n");}
    | OP_DIF               {strcpy(compara,"BEQ");
                              printf("\nREGLA 40: <opera>-->OP_DIF\n");}
    ;

funcionlist: INLIST PAR_A ID {posEnTabla=chequearVarEnTabla($<str_val>3,yylineno);} PYC COR_A {
                                                                                    
                                                                                    sprintf(inlistAux, "__repe%d",++cantidadInlist);
                                                                                    sprintf(inlistAux2, "__buscar%d",cantidadInlist);
                                                                                    colocarEnTablaSimb("0",1, yylineno,CteInt);
                                                                                    auxInlist1=crearNodo("OP_ASIG",crearHoja(inlistAux,Integer),crearHoja("_0",CteInt));
                                                                                    tipoDatoID = tablaSimb[posEnTabla].tipoDeDato;
                                                                                    tDatoInlistVar=crearHoja($<str_val>3,tipoDatoID);
                                                                                    auxInlist2=crearNodo("OP_ASIG",crearHoja(inlistAux2,tipoDatoID),tDatoInlistVar);
                                                                                    colocarEnTablaSimb(inlistAux,0,yylineno,0);
                                                                                    tablaSimb[cuentaRegs-1].tipoDeDato = Integer;
                                                                                    colocarEnTablaSimb(inlistAux2,0,yylineno,0);
                                                                                    tablaSimb[cuentaRegs-1].tipoDeDato = tipoDatoID;
                                                                                    inlistPtr=crearNodo(".BUSCAR",auxInlist2,auxInlist1);
                                                                                    colocarEnTablaSimb("1",1, yylineno,CteInt);
                                                                                    } 
                                          
                                                                                                list COR_C PAR_C {
                                                                                                                  inlistBuscarPtr=crearNodo("BNE",inlistBuscarPtr,crearHoja("_1",CteInt));
                                                                                                                  printf("\nREGLA 41: <funcionlist>-->INLIST PAR_A ID PYC COR_A <list> COR_C PAR_C\n");
                                                                                                                 }
list: list PYC var      {   
                         tipoDatoIzq=verificarTipoDato(&inlistExprePtr,yylineno);
                         errorDeCompatibilidadOperadores(tipoDatoIzq,tipoDatoID,yylineno,"tipo de datos de los campos del inlist no compatibles con la variable a buscar");
                           auxInlist1=crearNodo("BNE",crearHoja(inlistAux2,tipoDatoID),inlistExprePtr);
                           auxInlist2=crearNodo("OP_ASIG",crearHoja(inlistAux,Integer),crearHoja("_1",CteInt));
                           auxInlist1=crearNodo("IF",auxInlist1,auxInlist2);
                           inlistBuscarPtr=crearNodo("BUSCAR",inlistBuscarPtr,auxInlist1);
                            printf("\nREGLA 42: <list>--><list> PYC <var>\n");
                        }
      | var             {      
                            tipoDatoIzq=verificarTipoDato(&inlistExprePtr,yylineno);
                            errorDeCompatibilidadOperadores(tipoDatoIzq,tipoDatoID,yylineno,"tipo de datos de los campos del inlist no compatibles con la variable a buscar");
                           auxInlist1=crearNodo("BNE",crearHoja(inlistAux2,tipoDatoID),inlistExprePtr);
                           auxInlist2=crearNodo("OP_ASIG",crearHoja(inlistAux,Integer),crearHoja("_1",CteInt));
                           auxInlist1=crearNodo("IF",auxInlist1,auxInlist2);
                           inlistBuscarPtr=crearNodo("BUSCAR",inlistPtr,auxInlist1);
                           printf("\nREGLA 43: <list>--><var>\n");
                        }

var: expresion           {
                           sacarDePila(&pilaExpresion,&inlistExprePtr,sizeof(exprPtr));
                       
                           printf("\nREGLA 44: <list>--><expresion>\n");
                         }

asignacion: ID OP_ASIG {strcpy(str_aux2,$<str_val>1);} expresion	    
                                                        {     
                                                          posEnTabla=chequearVarEnTabla($<str_val>1,yylineno); 
                                                          sacarDePila(&pilaExpresion,&exprPtr,sizeof(exprPtr));
                                                          asigPtr = crearNodo("OP_ASIG",crearHoja(str_aux2,tablaSimb[posEnTabla].tipoDeDato),exprPtr);
                                                          verificarTipoDato(&asigPtr,yylineno);
                                                          printf("\nREGLA 45: <asignacion>-->ID OP_ASIG <expresion>\n");
                                                         }
            | ID OP_ASIG {strcpy(str_aux2,$<str_val>1);} CTE_STRING       
                                                         {         
                                                          posEnTabla=chequearVarEnTabla($<str_val>1,yylineno);
                                                          asigPtr = crearNodo("OP_ASIG",crearHoja($<str_val>1,tablaSimb[posEnTabla].tipoDeDato),crearHoja($<str_val>4,CteString)) ;
                                                          verificarTipoDato(&asigPtr,yylineno);
                                                          printf("\nREGLA 46: <asignacion>-->ID OP_ASIG CTE_STRING\n");}	
expresion: termino                                       {
                                                          sacarDePila(&pilaTermino,&terminoPtr,sizeof(terminoPtr));
                                                          ponerEnPila(&pilaExpresion,&terminoPtr,sizeof(terminoPtr)); 
                                                          printf("\nREGLA 47: <expresion>--><termino>\n");}
		   | expresion OP_SUMA termino               {        
                                                          auxOp++;
                                                          sacarDePila(&pilaTermino,&terminoPtr,sizeof(terminoPtr));
                                                          sacarDePila(&pilaExpresion,&exprPtr,sizeof(exprPtr));
                                                          exprPtr = crearNodo("OP_SUMA",exprPtr,terminoPtr);
                                                          ponerEnPila(&pilaExpresion,&exprPtr,sizeof(exprPtr));    
                                                          printf("\nREGLA 48: <expresion>--><expresion> OP_SUMA <termino>\n");}
		   | expresion OP_RESTA termino              {        
                                                          auxOp++;
                                                          sacarDePila(&pilaTermino,&terminoPtr,sizeof(terminoPtr));
                                                          sacarDePila(&pilaExpresion,&exprPtr,sizeof(exprPtr));
                                                          exprPtr = crearNodo("OP_RESTA",exprPtr,terminoPtr);
                                                          ponerEnPila(&pilaExpresion,&exprPtr,sizeof(exprPtr));       
                                                          printf("\nREGLA 49: <expresion>--><expresion> OP_RESTA <termino>\n");
                                                         }
               | OP_RESTA expresion %prec MENOS_UNARIO 
                                                         { 
                                                          auxOp++;
                                                          sacarDePila(&pilaExpresion,&exprPtr,sizeof(exprPtr));
                                                          exprPtr=crearNodo("OP_RESTA",exprPtr,NULL);
                                                          ponerEnPila(&pilaExpresion,&exprPtr,sizeof(exprPtr));
                                                          printf("\nREGLA 50: <expresion>-->OP_RESTA <expresion>\n");
                                                         }
		   

termino:  factor                                         {
                                                          sacarDePila(&pilaFactor,&factorPtr,sizeof(factorPtr));
                                                          ponerEnPila(&pilaTermino,&factorPtr,sizeof(factorPtr)); 
                                                          printf("\nREGLA 51: <termino>--><factor>\n");}
		 | termino OP_MULT factor	               {            
                                                          auxOp++;
                                                          sacarDePila(&pilaTermino,&terminoPtr,sizeof(terminoPtr));
                                                          sacarDePila(&pilaFactor,&factorPtr,sizeof(factorPtr));
                                                          terminoPtr=crearNodo("OP_MULT",terminoPtr,factorPtr);
                                                          ponerEnPila(&pilaTermino,&terminoPtr,sizeof(terminoPtr)); 
                                                          printf("\nREGLA 52: <termino>--><termino> OP_MULT <factor>\n");}
		 | termino OP_DIV factor            	   {            
                                                          auxOp++;
                                                          sacarDePila(&pilaTermino,&terminoPtr,sizeof(terminoPtr));
                                                          sacarDePila(&pilaFactor,&factorPtr,sizeof(factorPtr));
                                                          terminoPtr=crearNodo("OP_DIV",terminoPtr,factorPtr); 
                                                          ponerEnPila(&pilaTermino,&terminoPtr,sizeof(terminoPtr));
                                                          printf("\nREGLA 53: <termino>--><termino> OP_DIV <factor>\n");
                                                         }
factor : CONST_ENT                                       {
                                                          sprintf(str_aux, "_%d",yylval.intval);
                                                          factorPtr = crearHoja(str_aux ,CteInt) ;
                                                          ponerEnPila(&pilaFactor,&factorPtr,sizeof(factorPtr));
                                                          printf("\nREGLA 54: <factor>-->CONST_ENT\n");
                                                         }
		| ID                                         {         
                                                          posEnTabla=chequearVarEnTabla(yylval.str_val,yylineno);
                                                          factorPtr = crearHoja(yylval.str_val,tablaSimb[posEnTabla].tipoDeDato);
                                                          ponerEnPila(&pilaFactor,&factorPtr,sizeof(factorPtr));
                                                          printf("\nREGLA 55: <factor>-->ID\n");
                                                         }
            | CONST_REAL                                 {
                                                          //sprintf(str_aux, "_%.5f",yylval.val);
                                                          sprintf(str_aux,"_%s",cteFlo);
                                                          factorPtr = crearHoja(str_aux,CteFloat) ;
                                                          ponerEnPila(&pilaFactor,&factorPtr,sizeof(factorPtr));
                                                          printf("\nREGLA 56: <factor>-->CONST_REAL\n");}
		| PAR_A   expresion  PAR_C                   {        
                                                          sacarDePila(&pilaExpresion,&exprPtr,sizeof(exprPtr));
                                                          ponerEnPila(&pilaFactor,&exprPtr,sizeof(exprPtr));             
                                                          printf("\nREGLA 57: <factor>-->PAR_A <expresion> PAR_C\n");}
            
                                                          
 
funcionbetween : BETWEEN PAR_A ID COMA COR_A expresion PYC expresion COR_C PAR_C	{printf("\nREGLA 62:<funcionbetween>-->BETWEEN PAR_A ID COMA COR_A <expresion> PYC <expresion> COR_C PAR_C\n");}
;         
   
                                           		
%%

