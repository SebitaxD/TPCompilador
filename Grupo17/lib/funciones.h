#ifndef FUNCIONES_H
#define FUNCIONES_H

enum tipoError
{
    ErrorSintactico,
    ErrorLexico
};
/* Tipos de datos para la tabla de simbolos */
#define Integer 1
#define Float 2
#define String 3
#define CteInt 4
#define CteFloat 5
#define CteString 6
#define SinTipo 7
#define SIN_MEM -4
#define NODO_OK -3
#define TRUE 1
#define FALSE 0
#define PILA_VAC 0
#define MIN(x,y) ((x<y)?x:y)
#define LIMITE 30
#define LIMITEENT 5
#define TAMANIO_TABLA 1000
#define TAM_NOMBRE 32

#include <stdlib.h>
#include <string.h>
#include <stdio.h>


/* Struct Arbol*/
	typedef struct {
		char dato[40];
		int tipoDato;		
	}tInfo;

/* Struct*/
typedef struct sNodo{
	tInfo info;
	struct sNodo *izq, *der;
}tNodo;


typedef tNodo* tArbol;
tInfo infoArbol;

FILE *graph;
FILE *tab;
FILE *intermedia;


typedef struct{
char lexema[50];
int tipoDeDato;
char valor[100];
int longitud;
}tSimbo;

tSimbo tablaSimb[TAMANIO_TABLA];
int cuentaRegs;
int _cantIds;
int auxOp;
int cantidadInlist;
char cteFlo[50];

int verifRangoString(char*ptr,int linea);
int verifRangoCTE_ENT(char*ptr,int linea);
int verifRangoCTE_REAL(char*ptr,int linea);
void colocarEnTablaSimb(char*ptr,int esCte,int linea,int tDatoCte);
int verifRangoID(char*ptr,int linea);
int comparaLexemas(char*ptr1,char*ptr2);
void errorCaracter(char*ptr,int linea);
void agregarTipoDeDatoVarAtabla(int tDato);
void agregarTiposDatosCte(int tDato);
int chequearVarEnTabla(char* nombre,int linea);
void mensajeDeError(enum tipoError error,const char* info, int linea);
void esVariableNumerica(int posDeTabla,int linea);
//void errorDeCompatibilidadOperadores(tArbol*operaIzq,tArbol*operaDer,int linea,char*descripcion);
void errorDeCompatibilidadOperadores(int tipoOperaIzq, int tipoOperaDer, int linea,char*descripcion);
int verificarTipoDato(tArbol * p,int linea);
void verificarTipo(tArbol* p,int tipoAux,int linea);
int verificarCompatible(int tipo,int tipoAux);
int buscarEnTabla(char * nombre);
void grabarTabla();
tNodo* crearNodo(const char* dato, tNodo *pIzq, tNodo *pDer);
void postOrden(tArbol *p,FILE* pfIntermedia);
tNodo* crearHoja(char* dato,int tipo);
tNodo *copiarDato(tNodo *);
tArbol * hijoMasIzq(tArbol *p);
void enOrden(tArbol *p,FILE* pfIntermedia);
void verNodo(const char *p,FILE* pfIntermedia);
void invertirSalto(tArbol *p);
void generaIntermediaIf();
void generaIntermediaIfConElse();
void generaIntermediaWhile();
void generaAssembler(tArbol* intemedia);
void recorrerIntermedia(tArbol *arbol,FILE * pf);
void tratarNodo(tArbol *nodo,FILE *pf);
void replace(char *orig, char rep, char busc);
void cambiarValor(char*auxValor);
void cargarOperadores(FILE*pf);
void traducirCondiciones(char *jump, char *jumpNegado,FILE*pf,char*etiqueta,int*ifInlist,char*bloqueTrueInl);


/*Punteros para arbol*/
tArbol 	asigPtr,			//Puntero de asignaciones
		exprPtr,			//Puntero de expresiones
		terminopfIntermediatr,			//Puntero de terminos
		factorPtr,			//Puntero de factores
		sentenciaPtr,		//Puntero de sentencia				
		auxBloquePtr, 
		terminoPtr,      
		condicionPtr,
		auxCond,
		operDerPtr,
		operIzqPtr,
		programaPtr,
		lecturaPtr,
		escrituraPtr,
		decisionesPtr,
		condiAuxPtr,
		cuerpoIfPtr,
		auxPtrIf2,
		condicionPtrIzq,
		cicloPtr,
		auxExprePtr,
		auxInlist1,
		auxInlist2,
		inlistPtr,
		inlistExprePtr,
		inlistBuscarPtr,
		cuerpoElse,
		cuerpo,
		tDatoInlistVar;

//PILA
typedef struct sNodoP
{
    void           *info;
    unsigned        tamInfo;
    struct sNodoP   *sig;
} tNodoP;
typedef tNodoP *tPila;

tPila pilaExpresion;
tPila pilaTermino;
tPila pilaFactor;
tPila pilaOperadoresCond;
tPila pilaPrograma;
tPila pilaCondicion;
tPila pilaProgramaFalso;
tPila pilaAssembler;
tPila pilaEtiquetas;
tPila pilaEtiquetasWhile;

void crearPila(tPila *p);
int  pilaLlena(const tPila *p, unsigned cantBytes);
int  ponerEnPila(tPila *p, const void *d, unsigned cantBytes);
int  verTope(const tPila *p, void *d, unsigned cantBytes);
int  pilaVacia(const tPila *p);
int  sacarDePila(tPila *p, void *d, unsigned cantBytes);
void vaciarPila(tPila *p);

#endif