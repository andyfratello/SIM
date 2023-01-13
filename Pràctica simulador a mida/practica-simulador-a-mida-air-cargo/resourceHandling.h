#pragma once

#include <iostream>
#include "simulationobject.h"
#include "resourceHandling.h"
#include <list>
#include "mission.h"


class CSimulator;

class CResourceHandling:public CSimulationObject{    
    public:
        CResourceHandling(){};
        //Constructora base
        CResourceHandling(CSimulator* simulator,std::string nom):CSimulationObject(simulator,nom){
        };
        //Destructor de l'objecte
        virtual ~CResourceHandling(){};
        //Métode que el simulador us invocarà per a recollir els estadístics (print per consola)
        virtual void showStatistics()=0;
        //Processar un esdeveniment de simulació, funció pura que us toca implementar
        virtual void processEvent (CSimulationEvent* event)=0;
        //Métode que el simulador invocarà a l'inici de la simulació, abans de que hi hagi cap esdeveniment a la llista d'esdeveniments
        virtual void simulationStart()=0;
        //Métode que el simulador us pot invocar a la finalització de l'estudi
        virtual void simulationEnd()=0;        
};
