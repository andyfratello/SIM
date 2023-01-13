#include "simulationobject.h"
#include "simulator.h"
#include "simulationobject.h"
#include "simulationevent.h"
#include <string>

using namespace std;
  
//Métode perqué demaneu els vostre preobjectes que us enviin un event que necessiteu, abans es deia enviamEvent
void CSimulationObject::sendMeEvent(CSimulationEvent* event){
    m_Simulator->scheduleEvent(event);
}
      