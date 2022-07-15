#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "funciones.h"

char auxAssembE[50];
char msg[100];
char aux_str[50];

char cteFloat[50];
char auxAssembR[50];
int auxEntero = 0;
int esCondMultOR = 0;
int esCondMultAND = 0;
int esCondWhile = 0;
int etiqFalseIf = 0;
int etiqFinIf = 0;
int etiqTrueIf = 0;
int contEtiqWhile = 0;
int auxReal = 0;
int fueConDMultOR = 0;
int fueConDMultAND = 0;
int totalInlist = 0;
int ifInlist = 0;
int condMultInlistif = 0;
int condMultInlistOr = 0;
int noActivar = 0;

char etiqTrue[50];
char etiqFalse[50];
char etiqWhile[50];
char aux_str2[50];

void colocarEnTablaSimb(char *ptr, int esCte, int linea, int tDatoCte)
{
	int i = 0, dupli = 0;
	if (esCte)
		sprintf(aux_str, "_%s", ptr);
	while (i < cuentaRegs && !dupli)
	{
		if (!strcmp(tablaSimb[i].lexema, esCte ? aux_str : ptr))
			dupli = 1;
		i++;
	}
	if (!dupli)
	{
		tablaSimb[cuentaRegs].longitud = strlen(ptr);
		if (esCte)
		{
			strcpy(tablaSimb[cuentaRegs].valor, ptr);
			strcpy(tablaSimb[cuentaRegs].lexema, aux_str);
			tablaSimb[cuentaRegs].tipoDeDato = tDatoCte;
		}
		else
			strcpy(tablaSimb[cuentaRegs].lexema, ptr);

		cuentaRegs++;
	}
	else
	{
		if (!esCte)
		{
			sprintf(msg, "'%s' ya se encuentra declarada previamente.", ptr);
			mensajeDeError(ErrorSintactico, msg, linea);
		}
	}
}
void cambiarValor(char *auxValor)
{
	strcpy(tablaSimb[cuentaRegs - 1].valor, auxValor);
}
void replace(char *orig, char rep, char busc)
{
	char *aux = orig;
	if (!*orig)
	{
		*orig = 'v';
		*(orig + 1) = 'a';
	}
	else
	{
		//remplazo espacios por guiones
		while (*orig)
		{
			if (*orig == busc || *orig == ':')
				*orig = rep;
			orig++;
		}
		//borro guiones
		while (*aux)
		{
			*aux = *(aux + 1);
			aux++;
		}
		*(aux - 2) = '\0';
	}
}

void generaIntermediaIf()
{
	sacarDePila(&pilaCondicion, &condicionPtr, sizeof(condicionPtr));
	decisionesPtr = crearNodo("IF", condicionPtr, programaPtr);
	if (!sacarDePila(&pilaPrograma, &programaPtr, sizeof(programaPtr)))
		programaPtr = NULL;
}

void generaIntermediaIfConElse()
{
	sacarDePila(&pilaCondicion, &condicionPtr, sizeof(condicionPtr));
	sacarDePila(&pilaPrograma, &auxBloquePtr, sizeof(programaPtr));
	cuerpoElse = crearHoja("TRUE", SinTipo);
	cuerpo = crearNodo("CUERPO", auxBloquePtr, cuerpoElse);
	cuerpoIfPtr = crearNodo("CUERPOIF", cuerpo, programaPtr);
	//cuerpoIfPtr = crearNodo("CUERPOIF", auxBloquePtr, programaPtr);
	decisionesPtr = crearNodo("IF", condicionPtr, cuerpoIfPtr);
	if (!sacarDePila(&pilaPrograma, &programaPtr, sizeof(programaPtr)))
		programaPtr = NULL;
}
void generaIntermediaWhile()
{
	sacarDePila(&pilaCondicion, &condicionPtr, sizeof(condicionPtr));
	cuerpo = crearHoja("#Etiq", SinTipo);
	cuerpo = crearNodo("CUERPO", cuerpo, condicionPtr);
	cicloPtr = crearNodo("WHILE", cuerpo, programaPtr);
	//cicloPtr = crearNodo("WHILE", condicionPtr, programaPtr);
	if (!sacarDePila(&pilaPrograma, &programaPtr, sizeof(programaPtr)))
		programaPtr = NULL;
}

int chequearVarEnTabla(char *lexema, int linea)
{
	int pos = 0;
	pos = buscarEnTabla(lexema);
	//Si no existe en la tabla, error
	if (pos == -1)
	{
		sprintf(msg, "La variable '%s' debe ser declarada previamente en la seccion de declaracion de variables", lexema);
		mensajeDeError(ErrorSintactico, msg, linea);
	}
	//Si existe en la tabla, dejo que la compilacion siga
	return pos;
}

int buscarEnTabla(char *nombre)
{
	int i = 0, pos = -1;
	while (i < cuentaRegs)
	{
		if (!strcmp(tablaSimb[i].lexema, nombre))
		{
			pos = i;
		}
		i++;
	}
	return pos;
}

void mensajeDeError(enum tipoError error, const char *info, int linea)
{
	switch (error)
	{
	case ErrorLexico:
		printf("ERROR Lexico en la linea %d. Descripcion: %s\n", linea, info);
		break;

	case ErrorSintactico:
		printf("ERROR Sintactico en la linea %d. Descripcion: %s.\n", linea, info);
		break;
	}
	system("Pause");
	exit(1);
}

void agregarTiposDatosCte(int tDato)
{
	tablaSimb[cuentaRegs - 1].tipoDeDato = tDato;
}

void agregarTipoDeDatoVarAtabla(int tDato)
{
	int i = 0, actual = 0;
	while (actual < _cantIds)
	{
		tablaSimb[cuentaRegs - actual - 1].tipoDeDato = tDato;
		actual++;
	}
}

void grabarTabla()
{
	int i;
	fprintf(tab, "%-30s|%-30s|%-30s|%s\n", "NOMBRE", "TIPO", "VALOR", "LONGITUD");
	fprintf(tab, "---------------------------------------------------------------------------------------------------------------------------------------------\n");

	for (i = 0; i < cuentaRegs; i++)
	{
		fprintf(tab, "%-30s", tablaSimb[i].lexema);
		switch (tablaSimb[i].tipoDeDato)
		{
		case Float:
			fprintf(tab, "|%-30s|%-30s|%d", "FLOAT", "--", tablaSimb[i].longitud);
			break;
		case Integer:
			fprintf(tab, "|%-30s|%-30s|%d", "INTEGER", "--", tablaSimb[i].longitud);
			break;
		case String:
			fprintf(tab, "|%-30s|%-30s|%d", "STRING", "--", tablaSimb[i].longitud);
			break;
		case CteFloat:
			fprintf(tab, "|%-30s|%-30s|%d", "CTE_FLOAT", tablaSimb[i].valor, tablaSimb[i].longitud);
			break;
		case CteInt:

			fprintf(tab, "|%-30s|%-30s|%d", "CTE_INT", tablaSimb[i].valor, tablaSimb[i].longitud);
			break;
		case CteString:
			fprintf(tab, "|%-30s|%-30s|%d", "CTE_STRING", tablaSimb[i].valor, tablaSimb[i].longitud);
			break;
		}
		fprintf(tab, "\n");
	}
	fclose(tab);
}

void invertirCondicion(char *condicion)
{
	if (strcmp(condicion, "BEQ") == 0)
	{
		strcpy(condicion, "BNE");
	}
	else if (strcmp(condicion, "BNE") == 0)
	{
		strcpy(condicion, "BEQ");
	}
	else if (strcmp(condicion, "BGT") == 0)
	{
		strcpy(condicion, "BLT");
	}
	else if (strcmp(condicion, "BLT") == 0)
	{
		strcpy(condicion, "BGT");
	}
	else if (strcmp(condicion, "BGE") == 0)
	{
		strcpy(condicion, "BLE");
	}
	else if (strcmp(condicion, "BLE") == 0)
	{
		strcpy(condicion, "BGE");
	}
}

int verifRangoString(char *ptr, int linea)
{
	if ((strlen(ptr) - 2) > LIMITE) //-2 para que no cuente las comillas
	{
		sprintf(msg, "la cadena (%s) supera el rango permitido", ptr);
		mensajeDeError(ErrorLexico, msg, linea);
	}
	return 0;
}

void esVariableNumerica(int posDeTabla, int linea)
{
	int tDato = tablaSimb[posDeTabla].tipoDeDato;
	if (tDato != Integer && tDato != Float)
	{
		sprintf(msg, "Solo se muestran variables numericas:la variable (%s) no es una variable numerica", tablaSimb[posDeTabla].lexema);
		mensajeDeError(ErrorSintactico, msg, linea);
	}
}

void errorDeCompatibilidadOperadores(int tipoOperaIzq, int tipoOperaDer, int linea,char*descripcion)
{	
	if (!verificarCompatible(tipoOperaIzq,tipoOperaDer))
	{
		mensajeDeError(ErrorSintactico, descripcion, linea);
	}
}

int verifRangoID(char *ptr, int linea)
{
	if ((strlen(ptr)) > LIMITE)
	{
		sprintf(msg, "La variable: %s supera el rango permitido", ptr);
		mensajeDeError(ErrorLexico, msg, linea);
	}
	return 0;
}
int verifRangoCTE_ENT(char *ptr, int linea)
{
	if (strlen(ptr) > LIMITEENT || atoi(ptr) > 32767) //no hay numeros negativos en el lexico
	{
		sprintf(msg, "La constante: %s supera el rango permitido", ptr);
		mensajeDeError(ErrorLexico, msg, linea);
	}
	return 0;
}

int verifRangoCTE_REAL(char *ptr, int linea)
{
	if (atof(ptr) > 3.40282347e+38F || atof(ptr) < 3.40282347e-38F)
	{
		sprintf(msg, "la constante real: %s supera el rango permitido", ptr);
		mensajeDeError(ErrorLexico, msg, linea);
	}
	return 0;
}
void errorCaracter(char *ptr, int linea)
{
	sprintf(msg, "Caracter: %s invalido", ptr);
	mensajeDeError(ErrorLexico, msg, linea);
}

tNodo *crearNodo(const char *dato, tNodo *pIzq, tNodo *pDer)
{

	tNodo *nodo = malloc(sizeof(tNodo));
	tInfo info;
	strcpy(info.dato, dato);
	nodo->info = info;
	nodo->izq = pIzq;
	nodo->der = pDer;

	return nodo;
}

tNodo *crearHoja(char *dato, int tipo)
{
	tNodo *nodoNuevo = (tNodo *)malloc(sizeof(tNodo));

	strcpy(nodoNuevo->info.dato, dato);
	nodoNuevo->info.tipoDato = tipo;
	nodoNuevo->izq = NULL;
	nodoNuevo->der = NULL;

	return nodoNuevo;
}

tArbol *hijoMasIzq(tArbol *p)
{
	if (*p)
	{
		if ((*p)->izq)
			return hijoMasIzq(&(*p)->izq);
		else
			return p;
	}
	return NULL;
}

void enOrden(tArbol *p, FILE *pfIntermedia)
{
	if (*p)
	{
		enOrden(&(*p)->izq, pfIntermedia);
		verNodo((*p)->info.dato, pfIntermedia);
		enOrden(&(*p)->der, pfIntermedia);
	}
}

void postOrden(tArbol *p, FILE *pfIntermedia)
{
	if (*p)
	{
		postOrden(&(*p)->izq, pfIntermedia);
		postOrden(&(*p)->der, pfIntermedia);
		verNodo((*p)->info.dato, pfIntermedia);
	}
}

void verNodo(const char *p, FILE *pfIntermedia)
{
	printf("%s ", p);
	fprintf(pfIntermedia, "%s ", p);
}

void _tree_print_dot_subtree(int nro_padre, tNodo *padre, int nro, tArbol *nodo, FILE *stream)
{
	if (*nodo != NULL)
	{
		fprintf(stream, "x%d [label=<%s>];\n", nro, (*nodo)->info.dato);
		if (padre != NULL)
		{
			fprintf(stream, "x%d -> x%d;\n", nro_padre, nro);
		}
		_tree_print_dot_subtree(nro, *nodo, 2 * nro + 1, &(*nodo)->izq, stream);
		_tree_print_dot_subtree(nro, *nodo, 2 * nro + 2, &(*nodo)->der, stream);
	}
}

void tree_print_dot(tArbol *p, FILE *stream)
{
	fprintf(stream, "digraph BST {\n");
	if (*p)
		_tree_print_dot_subtree(-1, NULL, 0, &(*p), stream);
	fprintf(stream, "}");
}

void verificarTipo(tArbol *p, int tipoAux, int linea)
{
	int compatible, tipo;
	if (*p)
	{
		verificarTipo(&(*p)->izq, tipoAux, linea);
		verificarTipo(&(*p)->der, tipoAux, linea);
		if ((*p)->izq == NULL && (*p)->der == NULL)
		{
			tipo = (*p)->info.tipoDato;
			compatible = verificarCompatible(tipo, tipoAux);
			printf("   ");
		}
		if (!compatible)
		{
			mensajeDeError(ErrorSintactico, "tipos no compatibles", linea);
		}
	}
}
void modificarCteFloat(char *cteFlo)
{
	char *aux;
	sprintf(cteFloat, "%scteF", cteFlo);
	if (aux = strstr(cteFloat, "."))
	{
		*aux = '_';
		strcpy(cteFlo, cteFloat);
	}
}

int verificarTipoDato(tArbol *p, int linea)
{
	tArbol *pAux = hijoMasIzq(p); //tipo a comparar contra el resto
	int tipoAux = (*pAux)->info.tipoDato;
	verificarTipo(p, tipoAux, linea);
	return tipoAux;
}


int verificarCompatible(int tipo, int tipoAux)
{	
	
	if (tipo == tipoAux)
		return TRUE;
	if (tipo == CteInt && tipoAux == Integer || tipoAux == CteInt && tipo == Integer)
		return TRUE;
	if (tipo == CteFloat && tipoAux == Float || tipoAux == CteFloat && tipo == Float)
		return TRUE;
	if (tipo == CteString && tipoAux == String || tipoAux == CteString && tipo == String)
		return TRUE;
	return FALSE;
}

//  _NEWLINE            db  0DH,0AH,'$'  salto de linea va en @data

void generaAssembler(tArbol *intemedia)
{
	int i;
	totalInlist = cantidadInlist;
	FILE *pf = fopen("Final.asm", "w+");
	if (!pf)
	{
		printf("Error al guardar el archivo assembler.\n");
		exit(1);
	}
	crearPila(&pilaAssembler);
	crearPila(&pilaEtiquetas);
	crearPila(&pilaEtiquetasWhile);
	//includes
	fprintf(pf, "include macros2.asm\n");
	fprintf(pf, "include number.asm\n\n");
	fprintf(pf, ".MODEL LARGE\n.STACK 200h\n.386\n.DATA\n\n");
	fprintf(pf, "%-30s%-20s%-20s\n", "MAXTEXTSIZE", "equ", "40");

	for (i = 0; i < auxOp; i++)
	{
		sprintf(auxAssembR, "_auxR%d", i);
		sprintf(auxAssembE, "_auxE%d", i);
		fprintf(pf, "%-30s%-20s%-20s\n", auxAssembR, "dd", "0.0");
		fprintf(pf, "%-30s%-20s%-20s\n", auxAssembE, "dd", "0");
	}

	for (i = 0; i < cuentaRegs; i++)
	{

		if (tablaSimb[i].tipoDeDato == CteFloat)
			modificarCteFloat(tablaSimb[i].lexema);
		fprintf(pf, "%-30s", tablaSimb[i].lexema);

		switch (tablaSimb[i].tipoDeDato)
		{
		case Float:
			fprintf(pf, "%-20s%-20s", "dd", "?");
			break;
		case Integer:
			fprintf(pf, "%-20s%-20s", "dd", "?");
			break;
		case String:
			fprintf(pf, "%-20s%-20s","db" ,",'$', MAXTEXTSIZE dup (?)", "'$'");
			break;
		case CteFloat:
			fprintf(pf, "%-20s%-20s", "dd", tablaSimb[i].valor);
			break;
		case CteInt:
			fprintf(pf, "%-20s%-20s", "dd", tablaSimb[i].valor);
			break;
		case CteString:
			fprintf(pf, "%-20s%-20s%s%d dup(?)", "db", tablaSimb[i].valor, ",'$',", tablaSimb[i].longitud);
			break;
		}
		fprintf(pf, "\n");
	}
	fprintf(pf, "%-30s%-20s%-20s\n","_NEWLINE","db", "0DH,0AH,'$'");
	fprintf(pf, "\n.CODE\n.startup\n\tmov AX,@DATA\n\tmov DS,AX\nFINIT\n\n");

	fprintf(pf, "\n");

	recorrerIntermedia(intemedia, pf);

	fprintf(pf, "\nmov ax, 4c00h\nint 21h\n\n");
	fprintf(pf, "\nffree");

	//FUNCIONES PARA MANEJO DE ENTRADA/SALIDA Y CADENAS
	fprintf(pf, "\nstrlen proc\n\tmov bx, 0\n\tstrl01:\n\tcmp BYTE PTR [si+bx],'$'\n\tje strend\n\tinc bx\n\tjmp strl01\n\tstrend:\n\tret\nstrlen endp\n");
	fprintf(pf, "\ncopiar proc\n\tcall strlen\n\tcmp bx , MAXTEXTSIZE\n\tjle copiarSizeOk\n\tmov bx , MAXTEXTSIZE\n\tcopiarSizeOk:\n\tmov cx , bx\n\tcld\n\trep movsb\n\tmov al , '$'\n\tmov byte ptr[di],al\n\tret\ncopiar endp\n");
	//fprintf(pf, "\nconcat proc\n\tpush ds\n\tpush si\n\tcall strlen\n\tmov dx , bx\n\tmov si , di\n\tpush es\n\tpop ds\n\tcall strlen\n\tadd di, bx\n\tadd bx, dx\n\tcmp bx , MAXTEXTSIZE\n\tjg concatSizeMal\n\tconcatSizeOk:\n\tmov cx , dx\n\tjmp concatSigo\n\tconcatSizeMal:\n\tsub bx , MAXTEXTSIZE\n\tsub dx , bx\n\tmov cx , dx\n\tconcatSigo:\n\tpush ds\n\tpop es\n\tpop si\n\tpop ds\n\tcld\n\trep movsb\n\tmov al , '$'\n\tmov byte ptr[di],al\n\tret\nconcat endp\n");

	fprintf(pf, "\nEND");

	vaciarPila(&pilaAssembler);
	vaciarPila(&pilaEtiquetasWhile);
	vaciarPila(&pilaEtiquetas);

	fclose(pf);
}

void recorrerIntermedia(tArbol *arbol, FILE *pf)
{
	if (*arbol)
	{
		recorrerIntermedia(&(*arbol)->izq, pf);
		recorrerIntermedia(&(*arbol)->der, pf);
		tratarNodo(arbol, pf);
	}
}

void tratarNodo(tArbol *nodo, FILE *pf)
{
	int pos, i;
	tInfo infoHojaDer;
	tInfo infoHojaIzq;
	char auxDatoAr[100];
	if ((*nodo)->info.tipoDato == CteFloat)
		modificarCteFloat((*nodo)->info.dato);
	strcpy(auxDatoAr, (*nodo)->info.dato);
	pos = buscarEnTabla(auxDatoAr);
	if (pos != -1)
	{
		//printf("\n%s",(*nodo)->info.dato);
		ponerEnPila(&pilaAssembler, &(*nodo)->info, sizeof(tInfo));
	}
	else
	{
		if (!strcmp(auxDatoAr, "OP_ASIG"))
		{
			sacarDePila(&pilaAssembler, &infoHojaDer, sizeof(tInfo));

			switch (infoHojaDer.tipoDato)
			{
			case Integer:
			case CteInt:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				fprintf(pf, "fild \t%s\n", infoHojaDer.dato);
				fprintf(pf, "fistp \t%s\n", infoHojaIzq.dato);
				break;
			case Float:
			case CteFloat:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				fprintf(pf, "fld \t%s\n", infoHojaDer.dato);
				fprintf(pf, "fstp \t%s\n", infoHojaIzq.dato);
				break;
			case String:
			case CteString:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				fprintf(pf, "mov ax, @DATA\nmov ds, ax\nmov es, ax\n");
				fprintf(pf, "mov si, OFFSET\t%s\n", infoHojaDer.dato);
				fprintf(pf, "mov di, OFFSET\t%s\n", infoHojaIzq.dato);
				fprintf(pf, "call copiar\n");
				break;
			}
		}

		if (!strcmp(auxDatoAr, "OP_SUMA"))
		{
			sacarDePila(&pilaAssembler, &infoHojaDer, sizeof(tInfo));
			switch (infoHojaDer.tipoDato)
			{
			case CteFloat:
			case Float:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				fprintf(pf, "fld \t%s\n", infoHojaIzq.dato);
				fprintf(pf, "fadd \t%s\n", infoHojaDer.dato);
				sprintf(auxAssembR, "%s%d", "_auxR", auxReal);
				fprintf(pf, "fstp \t%s\n", auxAssembR);
				strcpy(infoHojaIzq.dato, auxAssembR); /// uso el infoHojaizq para no definir otro auxiliar
				infoHojaIzq.tipoDato = Float;
				ponerEnPila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				auxReal++;
				break;
			case CteInt:
			case Integer:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				fprintf(pf, "fild \t%s\n", infoHojaIzq.dato);
				fprintf(pf, "fiadd \t%s\n", infoHojaDer.dato);
				sprintf(auxAssembE, "%s%d", "_auxE", auxEntero);
				fprintf(pf, "fistp \t%s\n", auxAssembE);
				strcpy(infoHojaIzq.dato, auxAssembE);
				infoHojaIzq.tipoDato = Integer;
				ponerEnPila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				auxEntero++;
				break;
			}
		}

		if (!strcmp(auxDatoAr, "OP_MULT"))
		{
			sacarDePila(&pilaAssembler, &infoHojaDer, sizeof(tInfo));
			switch (infoHojaDer.tipoDato)
			{
			case CteFloat:
			case Float:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				fprintf(pf, "fld \t%s\n", infoHojaIzq.dato);
				fprintf(pf, "fmul \t%s\n", infoHojaDer.dato);
				sprintf(auxAssembR, "%s%d", "_auxR", auxReal);
				fprintf(pf, "fstp \t%s\n", auxAssembR);
				strcpy(infoHojaIzq.dato, auxAssembR); /// uso el infoHojaizq para no definir otro auxiliar
				infoHojaIzq.tipoDato = Float;
				ponerEnPila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				auxReal++;
				break;
			case CteInt:
			case Integer:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				fprintf(pf, "fild \t%s\n", infoHojaIzq.dato);
				fprintf(pf, "fimul \t%s\n", infoHojaDer.dato);
				sprintf(auxAssembE, "%s%d", "_auxE", auxEntero);
				fprintf(pf, "fistp \t%s\n", auxAssembE);
				strcpy(infoHojaIzq.dato, auxAssembE);
				infoHojaIzq.tipoDato = Integer;
				ponerEnPila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				auxEntero++;
				break;
			}
		}

		if (!strcmp(auxDatoAr, "OP_RESTA"))
		{
			//operador unario
			if (!(*nodo)->izq || !(*nodo)->der)
			{
				sacarDePila(&pilaAssembler, &infoHojaDer, sizeof(tInfo));
				printf("%s", infoHojaDer.dato);
				switch (infoHojaDer.tipoDato)
				{
				case CteFloat:
				case Float:
					fprintf(pf, "fld \t%s\n", infoHojaDer.dato);
					fprintf(pf, "fchs\n");
					sprintf(auxAssembR, "%s%d", "_auxR", auxReal);
					fprintf(pf, "fstp \t%s\n", auxAssembR);
					strcpy(infoHojaIzq.dato, auxAssembR); /// uso el infoHojaizq para no definir otro auxiliar
					infoHojaIzq.tipoDato = Float;
					ponerEnPila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
					auxReal++;
					break;
				case CteInt:
				case Integer:
					fprintf(pf, "fild \t%s\n", infoHojaDer.dato);
					fprintf(pf, "fchs \n");
					sprintf(auxAssembE, "%s%d", "_auxE", auxEntero);
					fprintf(pf, "fistp \t%s\n", auxAssembE);
					strcpy(infoHojaIzq.dato, auxAssembE);
					infoHojaIzq.tipoDato = Integer;
					ponerEnPila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
					auxEntero++;
					break;
				}
			}
			else //RESTA normal
			{
				sacarDePila(&pilaAssembler, &infoHojaDer, sizeof(tInfo));
				switch (infoHojaDer.tipoDato)
				{
				case CteFloat:
				case Float:
					sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
					fprintf(pf, "fld \t%s\n", infoHojaIzq.dato);
					fprintf(pf, "fsub \t%s\n", infoHojaDer.dato);
					sprintf(auxAssembR, "%s%d", "_auxR", auxReal);
					fprintf(pf, "fstp \t%s\n", auxAssembR);
					strcpy(infoHojaIzq.dato, auxAssembR); /// uso el infoHojaizq para no definir otro auxiliar
					infoHojaIzq.tipoDato = Float;
					ponerEnPila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
					auxReal++;
					break;
				case CteInt:
				case Integer:
					sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
					fprintf(pf, "fild \t%s\n", infoHojaIzq.dato);
					fprintf(pf, "fisub \t%s\n", infoHojaDer.dato);
					sprintf(auxAssembE, "%s%d", "_auxE", auxEntero);
					fprintf(pf, "fistp \t%s\n", auxAssembE);
					strcpy(infoHojaIzq.dato, auxAssembE);
					infoHojaIzq.tipoDato = Integer;
					ponerEnPila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
					auxEntero++;
					break;
				}
			}
		}

		if (!strcmp(auxDatoAr, "OP_DIV") || !strcmp(auxDatoAr, "DIV"))
		{
			sacarDePila(&pilaAssembler, &infoHojaDer, sizeof(tInfo));
			switch (infoHojaDer.tipoDato)
			{
			case CteFloat:
			case Float:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				if (!strcmp("_0", infoHojaDer.dato))
				{
					printf("ERROR Sintactico. Descripcion: stack overflow division por cero.\n");
					exit;
				}
				fprintf(pf, "fld \t%s\n",infoHojaDer.dato );
				fprintf(pf, "fdivr \t%s\n",infoHojaIzq.dato );
				sprintf(auxAssembR, "%s%d", "_auxR", auxReal);
				fprintf(pf, "fstp \t%s\n", auxAssembR);
				strcpy(infoHojaIzq.dato, auxAssembR); /// uso el infoHojaizq para no definir otro auxiliar
				infoHojaIzq.tipoDato = Float;
				ponerEnPila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				auxReal++;
				break;
			case CteInt:
			case Integer:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				if (!strcmp("_0", infoHojaDer.dato))
				{
					printf("\nERROR Sintactico. Descripcion: stack overflow division por cero.\n");
					exit;
				}
				fprintf(pf, "fild \t%s\n",infoHojaDer.dato );
				fprintf(pf, "fidivr \t%s\n",infoHojaIzq.dato );
				sprintf(auxAssembE, "%s%d", "_auxE", auxEntero);
				fprintf(pf, "fistp \t%s\n", auxAssembE);
				strcpy(infoHojaIzq.dato, auxAssembE);
				infoHojaIzq.tipoDato = Integer;
				ponerEnPila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				auxEntero++;
				break;
			}
		}

		if (!strcmp(auxDatoAr, "MOD"))
		{
			sacarDePila(&pilaAssembler, &infoHojaDer, sizeof(tInfo));
			switch (infoHojaDer.tipoDato)
			{
			case CteFloat:
			case Float:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				fprintf(pf, "fld \t%s\n", infoHojaDer.dato);
				fprintf(pf, "fld \t%s\n", infoHojaIzq.dato);
				fprintf(pf, "fprem \n");
				sprintf(auxAssembR, "%s%d", "_auxR", auxReal);
				fprintf(pf, "fstp \t%s\n", auxAssembR);
				strcpy(infoHojaIzq.dato, auxAssembR); /// uso el infoHojaizq para no definir otro auxiliar
				infoHojaIzq.tipoDato = Integer;
				ponerEnPila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				auxReal++;
				break;
			case CteInt:
			case Integer:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				fprintf(pf, "fild \t%s\n", infoHojaDer.dato);
				fprintf(pf, "fild \t%s\n", infoHojaIzq.dato);
				fprintf(pf, "fprem \n");
				sprintf(auxAssembE, "%s%d", "_auxE", auxEntero);
				fprintf(pf, "fistp \t%s\n", auxAssembE);
				strcpy(infoHojaIzq.dato, auxAssembE);
				infoHojaIzq.tipoDato = Integer;
				ponerEnPila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				auxEntero++;
				break;
			}
		}

		if (!strcmp(auxDatoAr, "OP_ASIG"))
		{
			if (!strncmp("__repe", (*nodo)->izq->info.dato, 6) && !strncmp("_1", (*nodo)->der->info.dato, 2))
			{
				fprintf(pf, "jmp \t%s%d\n", "BloqueTrue", etiqTrueIf + 1);
			}
		}

		if (!strcmp(auxDatoAr, "WRITE"))
		{
			sacarDePila(&pilaAssembler, &infoHojaDer, sizeof(tInfo));
			switch (infoHojaDer.tipoDato)
			{
			case Integer:
			case CteInt:
				fprintf(pf, "displayInteger \t%s,3\n", infoHojaDer.dato);
				fprintf(pf,"displayString _NEWLINE\n");
				break;
			case Float:
			case CteFloat:
				fprintf(pf, "displayFloat \t%s,3\n", infoHojaDer.dato);
				fprintf(pf,"displayString _NEWLINE\n");
				break;
			case String:
			case CteString:
				fprintf(pf, "displayString \t%s\n", infoHojaDer.dato);
				fprintf(pf,"displayString _NEWLINE\n");
				break;
			}
		}
		if (!strcmp(auxDatoAr, "TRUE"))
		{
			sacarDePila(&pilaEtiquetas, &etiqFalse, sizeof(etiqFalse));
			sprintf(etiqTrue, "%s%d", "finIf", ++etiqFinIf);
			ponerEnPila(&pilaEtiquetas, &etiqTrue, sizeof(etiqTrue));
			fprintf(pf, "jmp\t %s\n", etiqTrue);
			fprintf(pf, "%s:\n", etiqFalse);
		}

		if (!strcmp(auxDatoAr, "IF"))
		{
			if (!strcmp((*nodo)->der->info.dato, "CUERPOIF"))
			{
				sacarDePila(&pilaEtiquetas, &etiqTrue, sizeof(etiqTrue));
				fprintf(pf, "%s:\n", etiqTrue);
			}
			else
			{
				sacarDePila(&pilaEtiquetas, &etiqTrue, sizeof(etiqTrue));
				//fprintf(pf, "jmp \t%s\n", etiqTrue);
				fprintf(pf, "%s:\n", etiqTrue);
			}
		}

		if (!strcmp(auxDatoAr, "READ"))
		{
			sacarDePila(&pilaAssembler, &infoHojaDer, sizeof(tInfo));
			switch (infoHojaDer.tipoDato)
			{
			case Integer:
				fprintf(pf, "getInteger \t%s\n", infoHojaDer.dato);
				break;
			case Float:
				fprintf(pf, "getFloat \t%s\n", infoHojaDer.dato);
				break;
			case String:
				fprintf(pf, "getString \t%s\n", infoHojaDer.dato);
				break;
			}
		}

		if (!strcmp(auxDatoAr, "#Etiq"))
		{
			esCondWhile = 1;
			contEtiqWhile++;
			sprintf(etiqWhile, "%s%d", "etiqWhile", contEtiqWhile);
			ponerEnPila(&pilaEtiquetasWhile, &etiqWhile, sizeof(etiqWhile));
			fprintf(pf, "%s:\n", etiqWhile);
		}

		if (!strcmp(auxDatoAr, "WHILE"))
		{
			sacarDePila(&pilaEtiquetasWhile, &etiqWhile, sizeof(etiqWhile));
			fprintf(pf, "jmp \t %s\n", etiqWhile);
			sacarDePila(&pilaEtiquetas, &etiqWhile, sizeof(etiqWhile));
			fprintf(pf, "%s:\n", etiqWhile);
		}

		if (!strcmp(auxDatoAr, "CONDMOR"))
			esCondMultOR = 1;

		if (!strcmp(auxDatoAr, "CONDMAND"))
			esCondMultAND = 1;

		if (!strcmp(auxDatoAr, "BLE"))
		{
			cargarOperadores(pf);
			fprintf(pf, "fxch\nfcom\nfstsw\tax\nsahf\n");
			traducirCondiciones("jbe", "ja", pf, "etiq", &etiqTrueIf, "BloqueTrue");
		}

		if (!strcmp(auxDatoAr, "BGT"))
		{
			cargarOperadores(pf);
			fprintf(pf, "fxch\nfcom\nfstsw\tax\nsahf\n");
			traducirCondiciones("ja", "jbe", pf, "etiq", &etiqTrueIf, "BloqueTrue");
		}

		if (!strcmp(auxDatoAr, "BLT"))
		{
			cargarOperadores(pf);
			fprintf(pf, "fxch\nfcom\nfstsw\tax\nsahf\n");
			traducirCondiciones("jb", "jae", pf, "etiq", &etiqTrueIf, "BloqueTrue");
		}

		if (!strcmp(auxDatoAr, "BGE"))
		{
			cargarOperadores(pf);
			fprintf(pf, "fxch\nfcom\nfstsw\tax\nsahf\n");
			traducirCondiciones("jae", "jb", pf, "etiq", &etiqTrueIf, "BloqueTrue");
		}

		if (!strcmp(auxDatoAr, ".BUSCAR"))
		{
			if (fueConDMultAND)
			{
				condMultInlistif = 1;
				etiqTrueIf--;
				noActivar = 1;
			}
			if (fueConDMultOR)
			{
				condMultInlistOr = 1;
				etiqTrueIf--;
				noActivar = 1;
			}
		}

		if (!strcmp(auxDatoAr, "BNE"))
		{
			///PARA EL INLIST
			if (!strcmp("BUSCAR", (*nodo)->izq->info.dato))
			{
				sprintf(aux_str, "%s%d", "__repe", totalInlist - (cantidadInlist - 1));
				sacarDePila(&pilaAssembler, &aux_str2, sizeof(aux_str2));
				ponerEnPila(&pilaAssembler, &aux_str, sizeof(aux_str)); //intercamio op
				ponerEnPila(&pilaAssembler, &aux_str2, sizeof(aux_str2));
				cantidadInlist--;

				if (condMultInlistif)
				{
					condMultInlistif = 0;
					if (!noActivar)
					{
						esCondMultAND = 1;
						noActivar = 1;
					}
				}
				if (condMultInlistOr)
				{
					condMultInlistOr = 0;
					if (!noActivar)
					{
						esCondMultOR = 1;
						noActivar = 1;
					}
				}
			}
			cargarOperadores(pf);
			fprintf(pf, "fxch\nfcom\nfstsw\tax\nsahf\n");

			if (!strncmp("__buscar", (*nodo)->izq->info.dato, 8))
			{

				if (esCondMultAND)
				{
					condMultInlistif = 1;
					esCondMultAND = 0;
				}
				if (esCondMultOR)
				{
					condMultInlistOr = 1;
					esCondMultOR = 0;
				}

				traducirCondiciones("jne", "je", pf, "etiqInlist", &ifInlist, "BloqueTrueIn");
			}
			else
				traducirCondiciones("jne", "je", pf, "etiq", &etiqTrueIf, "BloqueTrue");
		}

		if (!strcmp(auxDatoAr, "BEQ"))
		{
			///PARA EL INLIST
			if (!strcmp("BUSCAR", (*nodo)->izq->info.dato))
			{
				sprintf(aux_str, "%s%d", "__repe", totalInlist - (cantidadInlist - 1));
				sacarDePila(&pilaAssembler, &aux_str2, sizeof(aux_str2));
				ponerEnPila(&pilaAssembler, &aux_str, sizeof(aux_str)); //intercamio op
				ponerEnPila(&pilaAssembler, &aux_str2, sizeof(aux_str2));
				cantidadInlist--;
			}
			cargarOperadores(pf);
			fprintf(pf, "fxch\nfcom\nfstsw\tax\nsahf\n");
			traducirCondiciones("je", "jne", pf, "etiq", &etiqTrueIf, "BloqueTrue");
		}
	}
}

//ifInlist

void cargarOperadores(FILE *pf)
{
	tInfo infoHojaDer;
	tInfo infoHojaIzq;
	sacarDePila(&pilaAssembler, &infoHojaDer, sizeof(tInfo));
	switch (infoHojaDer.tipoDato)
	{
	case Integer:
	case CteInt:
		sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
		fprintf(pf, "fild \t%s\n", infoHojaIzq.dato);
		fprintf(pf, "fild \t%s\n", infoHojaDer.dato);
		break;
	case Float:
	case CteFloat:
		fprintf(pf, "fld \t%s\n", infoHojaIzq.dato);
		fprintf(pf, "fld \t%s\n", infoHojaDer.dato);
		break;
	}
}

void traducirCondiciones(char *jump, char *jumpNegado, FILE *pf, char *etiqueta, int *numeracion, char *bloqueTrueInl)
{
	if (esCondMultAND)
	{
		fprintf(pf, "%s\t", jump);
		esCondMultAND = 0;
		fueConDMultAND = 1;
		(*numeracion)++;
		sprintf(etiqTrue, "%s%d", etiqueta, *numeracion);
		fprintf(pf, "%s\n", etiqTrue);
	}
	else
	{
		if (esCondMultOR)
		{
			(*numeracion)++;
			fueConDMultOR = 1;
			fprintf(pf, "%s\t", jumpNegado);
			fprintf(pf, "%s%d\n", bloqueTrueInl, (*numeracion));
			esCondMultOR = 0;
		}
		else
		{
			fprintf(pf, "%s\t", jump);
			if (!fueConDMultOR && !fueConDMultAND)
				(*numeracion)++;
			else
			{
				fueConDMultOR = 0;
				fueConDMultAND = 0;
			}
			sprintf(etiqTrue, "%s%d", etiqueta, (*numeracion));
			ponerEnPila(&pilaEtiquetas, &etiqTrue, sizeof(etiqTrue));
			fprintf(pf, "%s\n", etiqTrue);
			fprintf(pf, "%s%d:\n", bloqueTrueInl, (*numeracion));
		}
	}
}
