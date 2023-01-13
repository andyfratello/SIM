#include "eventlist.h"
#include "simulationevent.h"

using namespace std;

struct__item::struct__item(CSimulationEvent* event){
    info=event;
    pre=nullptr;
    post=nullptr;
}

CEventList::CEventList(){
    first=nullptr;
}

CSimulationEvent* CEventList::remove(){
    if (first!=nullptr){
        CSimulationEvent* event=first->info;
        first=first->post;
        return event;
    }
    return nullptr;
}

bool CEventList::isEmpty(){
    return (first==nullptr);
}

void CEventList::reset(){
    struct__item* rec=first;
    while (rec!=nullptr){
        delete rec->info;
        rec=rec->post;
    }
    first=nullptr;
}

//Podeu millorar la inserció d'esdeveniments, atenent al que hem explicat a classe?
void CEventList::insert(CSimulationEvent* event){
    if (first==nullptr){//No hi ha elements
        first=new struct__item(event);
    }
    else{
        struct__item* rec=first;
        struct__item* darrer;
        while (rec!=nullptr && event->getTime() > rec->info->getTime() ){
            darrer=rec;
            rec=rec->post;
        }
        struct__item* bin=new struct__item(event);
        if (rec==nullptr){//Final de la llista
            darrer->post=bin;
            bin->pre=darrer;
        }
        else{
            if (rec==first){//Primer de la llista
                first->pre=bin;
                bin->post=first;
                first=bin;
            }
            else{//Intermig
                bin->pre=darrer;              
                bin-> post=darrer->post;
                darrer->post=bin;
            }
        }
    }
}
