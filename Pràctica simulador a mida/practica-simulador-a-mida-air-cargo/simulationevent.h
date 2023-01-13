#pragma once
#include "simulationobject.h"
#include <string>



class CMission;

//Afegiu els enumerats que considereu necessaris...
enum enumEventType {eORDRE,eMOVEMENT,eFI_TRANSFERENCIA,eSTART};
/*
* eORDRE --> el recurs rep una missió
* eMOURE --> el recurs es mou
* eAPARCAR --> el recurs aparca
* eSTART --> el recurs pot arrancar les seves operacions
*/

class CSimulationEvent{
    public:
        CSimulationEvent(){};
        CSimulationEvent(float time,CSimulationObject* provider,CSimulationObject* consumer,CMission* mission,enumEventType eventType);
        ~CSimulationEvent(){};
        float getTime(){return m_eventTime;};
        CSimulationObject* getProvider(){return m_provider;};
        CSimulationObject* getConsumer(){return m_consumer;};
        CMission* getMission(){return m_mission;};
        enumEventType getEventType(){return m_eventType;};
        void executed();
        std::string trace();
        void invalidateEvent(){m_valid=false;}
        bool isValid(){return m_valid;}
    protected:
        CSimulationObject* m_provider;
        CSimulationObject* m_consumer;
        CMission* m_mission;
        enumEventType m_eventType;
        float m_eventTime;
        bool m_valid;
};
