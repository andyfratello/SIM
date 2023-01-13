#pragma once
#include "simulationobject.h"
#include "simulator.h"

class CPostObject:public CSimulationObject{
    public:
    CPostObject(CSimulator* simulator,std::string nom);
    ~CPostObject(){}
    //Métode que el simulador us invocarà per a recollir els estadístics (print per consola)
    void showStatistics();
    //Processar un esdeveniment de simulació, funció pura que us toca implementar
    void processEvent (CSimulationEvent* event);
    //Métode que el simulador invocarà a l'inici de la simulació, abans de que hi hagi cap esdeveniment a la llista d'esdeveniments
    void simulationStart();
    //Métode que el simulador us pot invocar a la finalització de l'estudi
    void simulationEnd();
};