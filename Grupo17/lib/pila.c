#include "funciones.h"

void crearPila(tPila *p)
{
    *p=NULL;
}

int  ponerEnPila(tPila *p, const void *d, unsigned cantBytes)
{
    tNodoP*nue=malloc(sizeof(tNodoP));
    if(!nue)
        return SIN_MEM;
    nue->info=malloc(cantBytes);
    if(!nue->info)
    {
        free(nue);
        return SIN_MEM;
    }
    nue->tamInfo=cantBytes;
    memcpy(nue->info,d,cantBytes);
    nue->sig=*p;
    *p=nue;
    return NODO_OK;
}

int  sacarDePila(tPila *p, void *d, unsigned cantBytes)
{
    tNodoP*aux;
    if(!*p)
        return PILA_VAC;
    aux=*p;
    memcpy(d,aux->info,MIN(cantBytes,aux->tamInfo));
    *p=aux->sig;
    free(aux->info);
    free(aux);
    return NODO_OK;
}

int  pilaLlena(const tPila *p, unsigned cantBytes)
{
    tNodoP*nue=malloc(sizeof(tNodoP));
    if(!nue)
        return 1;
    nue->info=malloc(cantBytes);
    if(!nue->info)
    {
        free(nue);
        return 1;
    }
    free(nue->info);
    free(nue);
    return 0;
}

int  verTope(const tPila *p, void *d, unsigned cantBytes)
{
    if(!*p)
        return PILA_VAC;
    memcpy(d,(*p)->info,MIN(cantBytes,(*p)->tamInfo));
    return 1;
}
int  pilaVacia(const tPila *p)
{
    return !*p;
}

void vaciarPila(tPila *p)
{
    tNodoP*aux;
    while(*p)
    {
        aux=*p;
        *p=aux->sig;
        free(aux->info);
        free(aux);
    }
}
