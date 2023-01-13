#pragma once
#include <string>

class CSimulationObject;
class CSimulationEvent;

class CMission
{
public:
    CMission(){
    }
    //registra de quan l'entitat entra en el sistema
    CMission(int id,int tipus,bool finger,bool cold, bool toBCN,int pmr,int cap){
      m_id=id;
      m_tipus_aeronau=tipus;
      m_finger=finger;
      m_frozen=cold;
      m_landing=toBCN;
      m_PMR=pmr;
      m_perCapacity=cap;
    }
    virtual ~CMission(){}
    int  getId(){return m_id;}//Retorna l'identificador de la missió
    int  getType(){return m_tipus_aeronau;}//Retorna el tipus d'aeronau
    bool inFinger(){return m_finger;}//Està aparcat a finger ? o en remot (false)
    bool isFrozen(){return m_frozen;}//Fa fred ? o una calor de l'òstia (false)
    bool isLanding(){return m_landing;}//És un vol que ha aterrat (return true) o que vol despegar (false)
    int  getPMR(){return m_PMR;}//Retorna el nombre de PMRs que viatgen en l'aeronau
    int  percentageCapacity(){return m_perCapacity;}//Retorna el percentatge de la capacitat de l'aeronau (atenció inclou PMR)

private:
    //Actualitza la traça d'esdeveniments on aquesta entitat s'ha vist implicat
    void traceEvent(CSimulationEvent* event);
    int m_id;
    int m_tipus_aeronau;
    bool m_finger;
    bool m_frozen;
    bool m_landing;
    int m_PMR;
    int m_perCapacity;
};
