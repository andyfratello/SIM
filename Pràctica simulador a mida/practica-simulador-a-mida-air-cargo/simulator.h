#pragma once
#include <iostream>
#include <list>

#include "simulationobject.h"
#include "simulationevent.h"
#include "resourceHandling.h"

class CEventList;
class CSimulator{
    public:
      //Crearà el model i ho gestionarà tot
      CSimulator();
      //Destrueix el model
      ~CSimulator();
      void scheduleEvent(CSimulationEvent* event);
      CSimulationObject* m_predecessor1;
      CSimulationObject* m_predecessor2;
      CSimulationObject* m_predecessor3;
      CSimulationObject* m_successor1;
      CSimulationObject* m_successor2;
      CSimulationObject* m_successor3;
      CResourceHandling* air_cargo_unit;
      float getCurrentTime(){return m_currentTime;}
    protected:
      //Mostrarà els estadístics dels elements de simulació, farà una crida a tots els elements de simulació
      void showStatistics();
      //Executar la simulació
      void run();
      //Comprovació de final de simulació
      bool simulationFinished();
      //Inicialització de la simulació
      void simulationStart();
      //Fi de la simulació
      void simulationEnd();
      //Llista ordenada d'esdeveniments de simulació
      CEventList* m_eventList;
      //Llista dels objectes de simulació que composen el model
      std::list<CSimulationObject*> m_objectes; 
      //Temps de simulació
      float m_currentTime;
};

