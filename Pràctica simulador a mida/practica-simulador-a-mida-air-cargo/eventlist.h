#pragma once

class CSimulationEvent;
class CSimulator;

struct struct__item{
    struct__item* pre;
    struct__item* post;
    CSimulationEvent* info;
    struct__item(CSimulationEvent* event);
};

class CEventList{
    friend class CSimulator;
    protected:
    CEventList();
    ~CEventList(){};
    CSimulationEvent* remove();
    //Insereix un esdeveniment
    void insert(CSimulationEvent* event);
    //Es buida la llista?
    bool isEmpty();
    //Elimina esdeveniments de la llista
    void reset();
    struct__item* first;
};