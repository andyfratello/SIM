#pragma once

#include <iostream>
#include <list>
#include "mission.h"


class CSimulator;

//Afegiu els estats que siguin necessaris per a que funcioni correctament...
enum enumStateObject {sIDLE,sTRANSFERIR_A_AVIO,sTRANSFERIR_A_TERMINAL,sMOVE,sAPARCAT};

class CSimulationObject{    
    public:
        CSimulationObject(){};
        //Constructora base
        CSimulationObject(CSimulator* simulator,std::string nom){
          m_Simulator=simulator;
          m_nom=nom;
        };
        //Destructor de l'objecte
        virtual ~CSimulationObject(){};
        //Métode que el simulador us invocarà per a recollir els estadístics (print per consola)
        virtual void showStatistics()=0;
        //Retorna l'estat actual de l'objecte
        enumStateObject getState(){return m_state;};
        //Processar un esdeveniment de simulació, funció pura que us toca implementar
        virtual void processEvent (CSimulationEvent* event)=0;
        //Métode que el simulador invocarà a l'inici de la simulació, abans de que hi hagi cap esdeveniment a la llista d'esdeveniments
        virtual void simulationStart()=0;
        //Métode que el simulador us pot invocar a la finalització de l'estudi
        virtual void simulationEnd()=0;
        //Métode perqué demaneu els vostre preobjectes que us enviin un event que necessiteu, abans es deia enviamEvent
        void sendMeEvent(CSimulationEvent* event);
        //El meu nom
        std::string m_nom;
    protected:
        //Estableix l'estat de l'objecte
        void setState(enumStateObject estat){m_state=estat;};
        //Estat de simulació en el que es troba l'objecte
        enumStateObject m_state;
        //Punter al simulador
        CSimulator* m_Simulator;
};


