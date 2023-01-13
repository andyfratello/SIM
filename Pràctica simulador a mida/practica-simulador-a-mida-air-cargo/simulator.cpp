#include "simulator.h"
#include "simulationevent.h"
#include "eventlist.h"
#include "preObject.h"
#include "postObject.h"
#include "AirCargoUnit.h"
#include <map>


CSimulator::CSimulator(){
    //Aquest mètode el podeu canviar si ho creieu necessari
    std::cout << "Exemple amb dos elements \n";
    m_predecessor1=new CPreObject(this,"PreObjecte1");
    m_predecessor2=new CPreObject(this,"PreObjecte2");
    m_predecessor3=new CPreObject(this,"PreObjecte3");
    m_successor1=new CPostObject(this,"PostObjecte1");
    m_successor2=new CPostObject(this,"PostObjecte2");
    m_successor3=new CPostObject(this,"PostObjecte3");

    air_cargo_unit=new AirCargoUnit(this,"AirCargoUnit",m_predecessor1,m_predecessor2,m_predecessor3,m_successor1,m_successor2,m_successor3);
    run();
}
CSimulator::~CSimulator(){
    //Eliminem objectes que formen part del model
    while (m_objectes.size()>0)
    {
        delete m_objectes.front();
        m_objectes.pop_front();
    }
    //Eliminem la llista d'esdeveniments
    m_eventList->reset();
    delete m_eventList;
}
void CSimulator::run(){
    std::cout << "Iniciem el run\n";
    simulationStart();
    while (!simulationFinished())
    {
        CSimulationEvent* event=(CSimulationEvent*)this->m_eventList->remove();
        if (event->getTime()<getCurrentTime()){
            std::cout << "Tens un problema amb els temps dels events";
        }
        if (event->isValid()){
          m_currentTime=event->getTime();
          event->executed();
        }
        delete event;
    }
    std::cout << "Fi de la simulación\n";
    simulationEnd();
    std::cout << "Hem mostrat els estadístics\n";
}

void CSimulator::simulationStart()
{
    m_eventList=new CEventList();
    //Feu allò que creieu necessari en base el que hem explicat a teoria i hem vist dins de Flexsim.
    air_cargo_unit->simulationStart();
}

void CSimulator::simulationEnd()
{
   air_cargo_unit->simulationEnd();
}

bool CSimulator::simulationFinished(){
    return this->m_eventList->isEmpty();
}

void CSimulator::scheduleEvent(CSimulationEvent* event){
    m_eventList->insert(event);
}
