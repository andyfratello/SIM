#include <iostream>
#include <list>
#include "simulationevent.h"
#include "mission.h"
#include "simulationobject.h"
#include <iostream>
#include <string>

CSimulationEvent::CSimulationEvent(float time,CSimulationObject* provider,CSimulationObject* consumer,CMission* mission,enumEventType eventType)
{//Inicialitzacions
  m_consumer=consumer;
  m_provider=provider;
  m_mission=mission;
  m_eventTime=time;
  m_eventType=eventType;
  m_valid=true;
};

void CSimulationEvent::executed(){
  m_consumer->processEvent(this);
  std::cout << trace();
}

std::string CSimulationEvent::trace(){
  return std::to_string(m_eventTime)+": [" + m_provider->m_nom+" -> "+m_consumer->m_nom+"] \n";  
}
