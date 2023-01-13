#pragma once
#include "resourceHandling.h"
#include "simulator.h"
#include "simulationobject.h"
#include <map>
#include <vector>

class AirCargoUnit:public CResourceHandling{
    public:
    AirCargoUnit(CSimulator* simulator,std::string nom,CSimulationObject* pre1,CSimulationObject* pre2,CSimulationObject* pre3,CSimulationObject* post1,CSimulationObject* post2,CSimulationObject* post3);
    ~AirCargoUnit(){}
    //Métode que el simulador us invocarà per a recollir els estadístics (print per consola)
    void showStatistics();
    //Processar un esdeveniment de simulació, funció pura que us toca implementar
    void processEvent (CSimulationEvent* event);
    //Métode que el simulador invocarà a l'inici de la simulació, abans de que hi hagi cap esdeveniment a la llista d'esdeveniments
    void simulationStart();
    //Métode que el simulador us pot invocar a la finalització de l'estudi
    void simulationEnd();
    private:
    CSimulationObject* m_predecessor1;
    CSimulationObject* m_predecessor2;
    CSimulationObject* m_predecessor3;
    CSimulationObject* m_successor1;
    CSimulationObject* m_successor2;
    CSimulationObject* m_successor3;
    CMission* m_missioActiva;
    int m_cicle;
    int m_starts;
    bool m_destiAvio;
    std::map<int, float> m_tempsTransferencia;
    std::vector<CMission*> m_missions;
    int m_numMissions;
};