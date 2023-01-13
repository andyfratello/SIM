#include "resourceHandling.h"
#include "simulator.h"

using namespace std;

void CResourceHandling::simulationStart(){
    /*******
     * Quan tingueu clar els atributs es generarà un arxiu amb diferents missions (arribades o sortides d'aeronaus caracteritzades)
     * De moment sols es creant dos missions, podeu aprofitar per a fer proves canviant atributs de l'objecte missió
     * ******/
    this->m_Simulator->scheduleEvent(new CSimulationEvent(6,this,this,new CMission(1,2,false,false,false,0,98),eORDRE));
    this->m_Simulator->scheduleEvent(new CSimulationEvent(8,this,this,new CMission(2,1,true,false,false,1,98),eORDRE));
    this->m_Simulator->scheduleEvent(new CSimulationEvent(1006,this,this,new CMission(3,3,false,true,true,0,0),eORDRE));
    this->m_Simulator->scheduleEvent(new CSimulationEvent(2006,this,this,new CMission(4,3,false,true,true,0,0),eORDRE));
    this->m_Simulator->scheduleEvent(new CSimulationEvent(1506,this,this,new CMission(5,3,false,true,false,0,0),eORDRE));
    this->m_Simulator->scheduleEvent(new CSimulationEvent(1066,this,this,new CMission(6,3,true,true,true,1,100),eORDRE));
    /*********
     * La programació dels esdeveniments temporals s'expressen en aquest cas com les unitats que cal que passin 
     * a partir del temps actual perquè l'esdeveniment es consideri executat.
     * ******/
     
}