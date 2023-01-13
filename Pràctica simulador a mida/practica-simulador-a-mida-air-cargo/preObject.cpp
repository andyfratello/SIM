#include "preObject.h"
#include "simulator.h"
#include "simulationobject.h"
#include "simulationevent.h"
#include <string>

using namespace std;

CPreObject::CPreObject(CSimulator* simulator,string nom):CSimulationObject(simulator,nom)
{
}

//Métode que el simulador us invocarà per a recollir els estadístics (print per consola)
void CPreObject::showStatistics()  {
    cout << m_nom <<  " No tinc estadístics";
};
    
//Processar un esdeveniment de simulació, funció pura que us toca implementar
void CPreObject::processEvent (CSimulationEvent* event)  {
    //No he de processar res de forma directe, però si creieu que heu de fer res ho feu.
}

//Métode que el simulador invocarà a l'inici de la simulació, abans de que hi hagi cap esdeveniment a la llista d'esdeveniments
void CPreObject::simulationStart()  {
    setState(sIDLE);
}
//Métode que el simulador us pot invocar a la finalització de l'estudi
void CPreObject::simulationEnd()  {

}