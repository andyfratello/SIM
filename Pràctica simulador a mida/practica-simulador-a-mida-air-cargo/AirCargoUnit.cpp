#include "AirCargoUnit.h"
#include "simulator.h"
#include "simulationobject.h"
#include "simulationevent.h"
#include <random>
#include <array>
#include <string>
#include <map>

using namespace std;

AirCargoUnit::AirCargoUnit(CSimulator* simulator,string nom,CSimulationObject* predecessor1,CSimulationObject* predecessor2,CSimulationObject* predecessor3,CSimulationObject* successor1,CSimulationObject* successor2,CSimulationObject* successor3):CResourceHandling(simulator,nom)
{
    //Atenció els que tingueu més d'un predecessor i un successor
    m_predecessor1=predecessor1;
    m_predecessor2=predecessor2;
    m_predecessor3=predecessor3;
    m_successor1=successor1;
    m_successor2=successor2;
    m_successor3=successor3;

    m_missioActiva=NULL;
    m_cicle=0;
    m_starts=0;
    m_destiAvio=false;
    m_tempsTransferencia;
    m_missions;
    m_numMissions=0;
}

//Métode que el simulador us invocarà per a recollir els estadístics (print per consola)
void AirCargoUnit::showStatistics()  {
    // cout << m_nom <<  " No tinc estadístics, això penalitzarà";
    for (const auto &m : m_tempsTransferencia) {
        cout << "En la missió número " << m.first + 1 << " el temps de transferència ha sigut de " << m.second << " minuts" << endl;
    }
};
    
float triangular_random(float a, float b, float c) {
  float u = (float)rand() / RAND_MAX;
  float fc = (c - a) / (b - a);

  if (u < fc) {
    return a + sqrt(u * (b - a) * (c - a));
  } else {
    return b - sqrt((1 - u) * (b - a) * (b - c));
  }
}

//Processar un esdeveniment de simulació, funció pura que us toca implementar
void AirCargoUnit::processEvent (CSimulationEvent* event)  {
    switch(this->getState()) {
        case sIDLE:
            cout << "++++++++++++++++++++++++sIDLE++++++++++++++++++++++++" << endl;
            switch(event->getEventType()) {
                case eORDRE: {
                    cout << "en estat IDLE i rebo una missió" << endl;
                    float dist = triangular_random(1, 5, 2.5);
                    m_missioActiva=event->getMission();
                    m_cicle=0;
                    CSimulationEvent* e = new CSimulationEvent(m_Simulator->getCurrentTime()+dist,this,this,event->getMission(),eMOVEMENT);
                    m_Simulator->scheduleEvent(e);
                    setState(sMOVE);
                    break;
                }
                default:
                    break;
            }
            break;
        case sMOVE:
            cout << "++++++++++++++++++++++++sMOVE++++++++++++++++++++++++" << endl;
            switch(event->getEventType()) {
                case eORDRE: {
                    if (this->m_missioActiva != NULL) { // Sí
                        cout << "Encuar missió" << endl;
                        m_missions.push_back(m_missioActiva);
                    } else { // No
                        cout << "Invalidar element" << endl;
                        float dist = triangular_random(1, 5, 2);
                        m_cicle=0;
                        CSimulationEvent* e = new CSimulationEvent(m_Simulator->getCurrentTime()+dist,this,this,event->getMission(),eMOVEMENT);
                        m_Simulator->scheduleEvent(e);
                    }
                    break;
                }
                case eMOVEMENT: {
                    if (this->m_missioActiva != NULL) { // Sí
                        cout << "en estat MOVE i missió activa" << endl;
                        m_cicle++;
                        if (m_missioActiva->isLanding()) { // Sí
                            cout << "avio isLanding()" << endl;
                            float dist = triangular_random(1, 5, 2);
                            if (m_cicle == 1) { // Sí
                                cout << "primer cicle" << endl;
                                m_starts=1;
                                m_predecessor1->sendMeEvent(new CSimulationEvent(m_Simulator->getCurrentTime()+dist,m_predecessor1,this,event->getMission(),eSTART));
                                setState(sAPARCAT);
                            } else { // No
                                cout << "descarregar" << endl;
                                CSimulationEvent* e = new CSimulationEvent(m_Simulator->getCurrentTime()+dist,this,this,event->getMission(),eFI_TRANSFERENCIA);
                                m_Simulator->scheduleEvent(e);
                                setState(sTRANSFERIR_A_TERMINAL);
                            }
                        } else { // No
                            cout << "avio !isLanding()" << endl;
                            float dist = triangular_random(1, 5, 2);
                            if (m_cicle == 1) { // Sí
                                cout << "#num cicle " << m_cicle << endl;
                                cout << "Carrega terminal" << endl;
                                CSimulationEvent* e = new CSimulationEvent(m_Simulator->getCurrentTime()+dist,this,this,event->getMission(),eFI_TRANSFERENCIA);
                                m_Simulator->scheduleEvent(e);
                                setState(sTRANSFERIR_A_TERMINAL);
                            } else { // No
                                cout << "*num cicle " << m_cicle << endl;
                                cout << "primer cicle" << endl;
                                m_starts=2;
                                cout << "m'envien START predecessor2 i predecessor3" << endl;
                                m_predecessor2->sendMeEvent(new CSimulationEvent(m_Simulator->getCurrentTime()+dist,m_predecessor2,this,event->getMission(),eSTART));
                                m_predecessor3->sendMeEvent(new CSimulationEvent(m_Simulator->getCurrentTime()+dist,m_predecessor3,this,event->getMission(),eSTART));                               
                                setState(sAPARCAT);
                            }
                        }
                    } else { // No
                        setState(sIDLE);
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        case sAPARCAT:
            cout << "++++++++++++++++++++++++sAPARCAT++++++++++++++++++++++++" << endl;
            switch(event->getEventType()) {
                case eSTART: {
                    cout << "en estat APARCAT i rebo START del predecessor" << endl;
                    m_starts--;
                    float dist = triangular_random(1, 5, 2);
                    float temps = m_Simulator->getCurrentTime() - m_Simulator->getCurrentTime()+dist;
                    if (m_starts == 0) { // Comença a fer missió
                        if (m_missioActiva->isLanding()) {
                            cout << "APARCAT Avio a terra" << endl;
                            CSimulationEvent* e = new CSimulationEvent(m_Simulator->getCurrentTime()+dist,this,m_successor1,event->getMission(),eFI_TRANSFERENCIA);                    
                            m_Simulator->scheduleEvent(e);
                        } else {
                            cout << "APARCAT Avio a l'aire" << endl;
                            float dist = triangular_random(1, 5, 2);
                            CSimulationEvent* e = new CSimulationEvent(m_Simulator->getCurrentTime()+dist,this,m_successor2,event->getMission(),eFI_TRANSFERENCIA);                    
                            m_Simulator->scheduleEvent(e);
                            CSimulationEvent* e1 = new CSimulationEvent(m_Simulator->getCurrentTime()+dist,this,m_successor3,event->getMission(),eFI_TRANSFERENCIA);                    
                            m_Simulator->scheduleEvent(e1);
                        }
                        m_tempsTransferencia.insert(pair<int, float>(m_numMissions, temps));
                        m_numMissions++;
                        cout << "Inserta transf. Temps transferencia: " << dist << endl;
                        setState(sTRANSFERIR_A_AVIO);
                    } else { 
                        cout << "descarregar" << endl;
                        setState(sAPARCAT);
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        case sTRANSFERIR_A_AVIO:
            cout << "++++++++++++++++++++++++sTRANSFERIR_A_AVIO++++++++++++++++++++++++" << endl;
            switch(event->getEventType()) {
                case eFI_TRANSFERENCIA: {
                    float dist = triangular_random(1, 5, 2);
                    m_cicle = 0;
                    m_missioActiva=event->getMission();
                    CSimulationEvent* e = new CSimulationEvent(m_Simulator->getCurrentTime()+dist,this,this,m_missioActiva,eMOVEMENT);
                    m_Simulator->scheduleEvent(e);
                    setState(sMOVE);
                    break;
                }
                case eORDRE: {
                    float dist = triangular_random(1, 5, 2);
                    m_cicle = 0;
                    m_missioActiva=event->getMission();
                    CSimulationEvent* e = new CSimulationEvent(m_Simulator->getCurrentTime()+dist,this,this,m_missioActiva,eMOVEMENT);
                    m_Simulator->scheduleEvent(e);
                    setState(sMOVE);
                    break;
                }
                default:
                    break;
            }
            break;
        case sTRANSFERIR_A_TERMINAL:
            cout << "++++++++++++++++++++++++sTRANSFERIR_A_TERMINAL++++++++++++++++++++++++" << endl;
            switch(event->getEventType()) {
                case eFI_TRANSFERENCIA: {
                    cout << "Transferencia a terminal " << endl << endl;
                    float dist = triangular_random(1, 5, 2);
                    m_missioActiva=event->getMission();
                    CSimulationEvent* e = new CSimulationEvent(m_Simulator->getCurrentTime()+dist,this,this,event->getMission(),eMOVEMENT);
                    m_Simulator->scheduleEvent(e);
                    setState(sMOVE);
                    break;
                }
                case eORDRE: {
                    cout << "sTRANSFERIR_A_TERMINAL Encuar missió" << endl;
                    m_missions.push_back(m_missioActiva);
                    cout << m_missions.size() << endl;
                    setState(sTRANSFERIR_A_TERMINAL);
                    break;
                }
                default:
                    break;
            }
            break;   
    }
}

//Métode que el simulador invocarà a l'inici de la simulació, abans de que hi hagi cap esdeveniment a la llista d'esdeveniments
void AirCargoUnit::simulationStart(){
    //Invoquem al pare pq ens crearà les missions de tot el dia, però no les veurem pq estaran com esdeveniments de simulació
    CResourceHandling::simulationStart();
    setState(sIDLE);
}
//Métode que el simulador us pot invocar a la finalització de l'estudi
void AirCargoUnit::simulationEnd()  {
    showStatistics();
}