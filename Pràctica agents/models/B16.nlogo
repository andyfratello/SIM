globals [
  AiguaTotal

  penalització-Guineus
  penalització-Talps
  penalització-Carnivores
  penalització-Flors
  penalització-Aranyes
  penalització-Papallones
  penalització-Fenomens
]

turtles-own[
  Vida
  Velocitat
  Inanició
  Fertilitat
  PeriodeFertilitat
  Cries
  MaduresaCries
  Protegint

]

Granotes-own[
  Feeding
  Reproduction
  CyclesReproduction
  Movement
]

patches-own[
  Aigua;color 95
  Terra; color 65
  Cau; color 34
  Teranyina; color 9
]

breed [Guineus Guineu]
breed [Talps Talp]
breed [Carnivores Carnivora]
breed [Flors Flor]
breed [Aranyes Aranya]
breed [Granotes Granota]
breed [Papallones Papallona]
breed [Fenomens Fenomen]

to setup
  clear-all
  reset-ticks

  set penalització-Guineus 0
  set penalització-Talps 0
  set penalització-Carnivores 0
  set penalització-Flors 0
  set penalització-Aranyes 0
  set penalització-Papallones 0
  set penalització-Fenomens 0

  create-Guineus GuineusTotal[
    setxy random-xcor random-ycor
    set shape "wolf"
    set color blue
    set size 6
    set vida 0;;25000
    set velocitat 8
    set inanició 1000
    set fertilitat 0
    set periodeFertilitat 10000
    set cries 0
    set maduresaCries 0
  ]
  create-Talps TalpsTotal[
    setxy random-xcor random-ycor
    set shape "bug"
    set color blue
    set size 6
    set vida 0;;50000
    set velocitat 2
    set inanició 1000
    set fertilitat 0
    set periodeFertilitat 1000
    set cries 0
    set maduresaCries 0
  ]
  create-Carnivores CarnivoresTotal[
    setxy random-xcor random-ycor
    set shape "plant"
    set color blue
    set size 6
    set vida 0;;100000
    set velocitat 0
    set inanició 90000
    set fertilitat 0
    set periodeFertilitat 30000
    set cries 0
    set maduresaCries 0
  ]
  create-Flors FlorsTotal[
    setxy random-xcor random-ycor
    set shape "flower"
    set color blue
    set size 6
    set vida 0;;5000
    set velocitat 0
    set inanició 5000
    set fertilitat 0
    set periodeFertilitat 1000
    set cries 0
    set maduresaCries 0
  ]
  create-Aranyes AranyesTotal[
    setxy random-xcor random-ycor
    set shape "spider"
    set color blue
    set size 6
    set vida 0;;2000
    set velocitat 2
    set inanició 1500
    set fertilitat 0
    set periodeFertilitat 800
    set cries 0
    set maduresaCries 0
  ]
  create-Granotes GranotesTotal[
    setxy random-xcor random-ycor ;;35 35
    set shape "turtle"
    set color blue
    set size 6
    set vida 250;;5000
    set velocitat 5
    set inanició 500
    set periodeFertilitat 1000
    set fertilitat 0
    set cries 0
    set CyclesReproduction 0
    set maduresaCries 0
    set Reproduction 0
    set Movement 1
    set Feeding 0
    set protegint 0
  ]

  create-Papallones PapallonesTotal[
    setxy random-xcor random-ycor
    set shape "butterfly"
    set color blue
    set size 6
    set vida 0;;5000
    set velocitat 1
    set inanició 1000
    set periodeFertilitat 1000
    set fertilitat 0
    set cries 0
    set maduresaCries 0
  ]
  create-Fenomens FenomenTotal[
    setxy random-xcor random-ycor
    set shape "arrow"
    set color blue
    set size 10
    set vida 0;;1000
    set velocitat 10
    set inanició 1000
    set periodeFertilitat 1000
    set fertilitat 0
    set cries 0
    set maduresaCries 0
  ]

  ask Patches [
    set aigua false;color 95
    set terra true; color 65
    set cau false; color 34
    set teranyina false; color 965
    set pcolor 65
    set aiguatotal aiguatotal - 900

    if (pxcor > 0 and pxcor < 150 and pycor > 0 and pycor < 150)[
      set pcolor 95
      set aigua true
      set terra false
      ask neighbors [
        set pcolor 95
        set aigua true
        set terra false
        ask neighbors [
          set pcolor 95
          set aigua true
          set terra false
          ask neighbors [
            set pcolor 95
            set aigua true
            set terra false
          ]
        ]

      ]
    ]
  ]

end



to go
  ask turtles [

    if breed = Granotes[
      granota-velocitat
      if (vida > 250) [
        granota-moure
        granota-fertilitat
      ]
      decrementar-granota
      if (vida >= 5000) or (inanició <= 0) [ granota-morir-nosaltres ]
    ]

  ]
  tick
end

to granota-velocitat
  ifelse [ aigua] of patch-here [set velocitat 5 ][set velocitat 2]
end

to granota-fertilitat
  ifelse (periodeFertilitat > 0)[
    set periodeFertilitat periodeFertilitat - 1
  ]
  [
    set periodeFertilitat 1000  set fertilitat 50
  ]
  ifelse fertilitat > 0 [
    set fertilitat fertilitat - 1
  ]
  [
    ;set color blue
  ] ;; si no es fertil es retorna al seu color inicial
  if (vida <= 250) [
    ; set color black
  ]
end



to decrementar-granota
  set vida vida + 1
  set inanició inanició - 1

  if (protegint > 0)[ set protegint (protegint - 1)]
  if (Feeding > 0)  [ set Feeding (Feeding - 1)]
  if (CyclesReproduction > 0) [ set CyclesReproduction (CyclesReproduction - 1)]

  if (protegint = 0) and (Feeding = 0) and (CyclesReproduction = 0) [ set Movement 1 ]
  if vida = 250 [set inanició 500]

end


to granota-moure
  let rotate -1 ;;rotacio en la posicio
  let posx 0 ;;posicio x on decidirem mourens
  let posy 0 ;;posicio y on decidirem mourens
  let myposx xcor ;;posició x de la granota que es mou
  let myposy ycor ;;posició y de la granota que es mou
  let velocitatGranota velocitat ;;velocitat de la granota que es mou

  let fertilitatGranota fertilitat ;;valor de la variable fertilitat de la granota que es mou
  let myCyclesReproduction CyclesReproduction
  let myInanició inanició
  let myMovement Movement
  let myFeeding Feeding
  let myProtegint protegint
  let socAlaigua 0
  if([ aigua] of patch-here) [
    set socAlaigua 1
  ]


  ;;s'executa només si em puc moure
  ifelse (myMovement = 1 or myProtegint > 0) [

    ask patches in-radius (17 - velocitatGranota) [ ; per tots els patch dins el radi...


      if(myInanició > 250) [
       if (socAlaigua = 1) and (count Granotes-here with [fertilitat > 0] > 0) and (fertilitatGranota > 0) and (myCyclesReproduction = 0)[
          let parella one-of Granotes-here with [fertilitat > 0]
          let fertilitatParella 0
          let gestacioParella 0
          ask parella[ set fertilitatParella fertilitat]
          ask parella[ set gestacioParella CyclesReproduction]
          ifelse (((distancexy myposx myposy) <= velocitatGranota) and (fertilitatParella > 0) and (myself != parella) and (gestacioParella = 0) and (pcolor = 95)) [
            set posx [xcor] of parella
            set posy [ycor] of parella
            set myCyclesReproduction 100
            ask parella [
              set CyclesReproduction 100
              set Movement 0
            ]
          ]
          [
            if (pcolor = 95) and (fertilitatParella > 0) and (myself != parella) and (gestacioParella = 0) [
              let objx [xcor] of parella
              let objy [ycor] of parella

              if (objx = myposx) [
                ifelse (objy > myposy) [
                  set rotate 0
                ]
                [
                  set rotate 180
                ]
              ]
              if (objy = myposy) [
                ifelse (objx > myposx) [
                  set rotate 90
                ]
                [
                  set rotate 270
                ]
              ]
              if (objy > myposy) and (objx > myposx) [
                set rotate 45
              ]
              if (objy < myposy) and (objx > myposx) [
                set rotate 135
              ]
              if (objy < myposy) and (objx < myposx) [
                set rotate 225
              ]
              if (objy > myposy) and (objx < myposx) [
                set rotate 315
              ]
            ]
          ]

        ]

        if socAlaigua = 0 and posx = 0 and posy = 0[
          if (pcolor = 95) and  (distancexy myposx myposy) <= velocitatGranota [
            set posx pxcor
            set posy pycor
          ]
          if (pcolor = 95) and  (distancexy myposx myposy) > velocitatGranota [
            let objx pxcor
            let objy  pycor

            if (objx = myposx) [
              ifelse (objy > myposy) [
                set rotate 0
              ]
              [
                set rotate 180
              ]
            ]
            if (objy = myposy) [
              ifelse (objx > myposx) [
                set rotate 90
              ]
              [
                set rotate 270
              ]
            ]
            ;;cuadrant superior dret
            if (objy > myposy) and (objx > myposx) [
              set rotate 45
            ]
            ;;cuadrant inferior dret
            if (objy < myposy) and (objx > myposx) [
              set rotate 135
            ]
            ;;cuadrant inferior esquerre
            if (objy < myposy) and (objx < myposx) [
              set rotate 225
            ]
            ;;cuadrantsuperior esquerre
            if (objy > myposy) and (objx < myposx) [
              set rotate 315
            ]
          ]
        ]

      ]
      if myInanició < 250  [
        if (count Papallones-here > 0) and (count Papallones-here < 5) and (distancexy myposx myposy) <= velocitatGranota  and (pcolor != 95)[
          let presa one-of papallones-here
          set posx [xcor] of presa
          set posy [ycor] of presa
          ask presa [papallones-morir myself]
          set myFeeding 3
        ]
        if (count Aranyes-here > 0) and (count Aranyes-here < 5) and (distancexy myposx myposy) <= velocitatGranota and (myFeeding = 0)[
          let presa one-of aranyes-here
          set posx [xcor] of presa
          set posy [ycor] of presa
          ask presa [aranyes-morir myself]
          set myFeeding 3
        ]
        if (count Talps-here with [vida >= 250] != 0) and (count Talps-here with [vida < 250] > 0) and (distancexy myposx myposy) <= velocitatGranota and (myFeeding = 0)[
          let presa one-of talps-here with [vida < 250]
          set posx [xcor] of presa
          set posy [ycor] of presa
          ask presa [talps-morir myself]
          set myFeeding 3
        ]
        ifelse (posx = 0 and posy = 0 and rotate = -1) and (myProtegint = 0) and (count Papallones-here > 0) and (count Papallones-here < 5) and (pcolor != 95) and (myFeeding = 0) [
          ;;coordenades del objectiu
          let presa one-of papallones-here
          let objx [xcor] of presa
          let objy [ycor] of presa

          if (objx = myposx) [
            ifelse (objy > myposy) [
              set rotate 0
            ]
            [
              set rotate 180
            ]
          ]
          if (objy = myposy) [
            ifelse (objx > myposx) [
              set rotate 90
            ]
            [
              set rotate 270
            ]
          ]
          ;;cuadrant superior dret
          if (objy > myposy) and (objx > myposx) [
            set rotate 45
          ]
          ;;cuadrant inferior dret
          if (objy < myposy) and (objx > myposx) [
            set rotate 135
          ]
          ;;cuadrant inferior esquerre
          if (objy < myposy) and (objx < myposx) [
            set rotate 225
          ]
          ;;cuadrantsuperior esquerre
          if (objy > myposy) and (objx < myposx) [
            set rotate 315
          ]
        ]
        [
          ifelse (posx = 0 and posy = 0 and rotate = -1) and (myProtegint = 0) and (count Aranyes-here > 0) and (count Aranyes-here < 5)  [
            let presa one-of aranyes-here


            ;;coordenades del objectiu
            let objx [xcor] of presa
            let objy [ycor] of presa


            if (objx = myposx) [
              ifelse (objy > myposy) [
                set rotate 0
              ]
              [
                set rotate 180
              ]
            ]
            if (objy = myposy) [
              ifelse (objx > myposx) [
                set rotate 90
              ]
              [
                set rotate 270
              ]
            ]
            if (objy > myposy) and (objx > myposx) [
              set rotate 45
            ]
            if (objy < myposy) and (objx > myposx) [
              set rotate 135
            ]
            if (objy < myposy) and (objx < myposx) [
              set rotate 225
            ]
            if (objy > myposy) and (objx < myposx) [
              set rotate 315
            ]
          ]
          [
            if (posx = 0 and posy = 0 and rotate = -1) and (myProtegint = 0) and (count Talps-here with [vida >= 250] != 0) and (count Talps-here with [vida < 250] > 0)  [
              let presa one-of talps-here with [vida < 250]

              let objx [xcor] of presa
              let objy [ycor] of presa


              if (objx = myposx) [
                ifelse (objy > myposy) [
                  set rotate 0
                ]
                [
                  set rotate 180
                ]
              ]
              if (objy = myposy) [
                ifelse (objx > myposx) [
                  set rotate 90
                ]
                [
                  set rotate 270
                ]
              ]
              if (objy > myposy) and (objx > myposx) [
                set rotate 45
              ]
              if (objy < myposy) and (objx > myposx) [
                set rotate 135
              ]
              if (objy < myposy) and (objx < myposx) [
                set rotate 225
              ]
              if (objy > myposy) and (objx < myposx) [
                set rotate 315
              ]
            ]
          ]
        ]

      ]
    ]



    ifelse (posx != 0 or posy != 0 or rotate != -1)[
      ifelse (posx != 0 or posy != 0) [
        setxy posx posy
      ]
      [
        set heading rotate
        fd velocitatGranota
      ]
      if (myCyclesReproduction > 0) [
        set Movement 0
        set CyclesReproduction 100
        set fertilitat 0
      ]
      if (myFeeding > 0) [
        set Movement 0
        set Feeding 3
        set inanició 500
      ]
    ]
    [
      if Movement = 1 [
        rt random-float 90 - random-float 90
        fd velocitatGranota ;; velocitat de 5 a l'aigua
      ]
    ]
  ]

  [
    if ( myCyclesReproduction - 1) = 0 [
      let padreMovement Movement
      let padreVida vida
      let padreInanició inanició
      let padrePeriodeFertilitat periodeFertilitat

      set Reproduction 0
      set cries 0
      set vida 0
      set inanició 500
      set periodeFertilitat 1000
      set fertilitat 0
      set CyclesReproduction 0
      set Movement 1
      set protegint 0

      hatch-Granotes 50
        ;;tornem els paràmetres al pare
        set vida padreVida
        set inanició padreInanició
        set periodeFertilitat padrePeriodeFertilitat
        set cries 0
        set CyclesReproduction 0
        set Reproduction 0
        set protegint 250
        set Movement 0
      ]


  ]

end





to granota-morir-nosaltres
  die
end



to granotes-morir[ qui ]

  let numQui 0

  ask qui [
    if breed = Aranyes [ set numQui 1 ]
    if breed = Guineus [ set numQui 2 ]
    if breed = Talps [ set numQui 3 ]
    if breed = Carnivores [ set numQui 4 ]
    if breed = Flors [ set numQui 5 ]
    if breed = Papallones [ set numQui 6 ]
    if breed = Fenomens [ set numQui 7 ]
  ]

  if numQui = 1  [
    ifelse ([ aigua] of patch-here) and (vida < 250)
    [
      die
    ]
    [
      ;ask qui [ set color red ]
      set penalització-Aranyes penalització-Aranyes + 1
    ]
  ]

  if numQui = 2 or numQui = 3 [
    ifelse ([ aigua] of patch-here) or ([ cau] of patch-here)
    [
      beep
      die
      ;;ask qui [set color red]
    ]
    [
      beep
      ;ask qui [set color pink]
      if qui = Guineus [set penalització-Guineus penalització-Guineus + 1]
      if qui = Talps [set penalització-Talps penalització-Talps + 1 ]
    ]
  ]

  if numQui = 4 or numQui = 5 or numQui = 6 or numQui = 7[ ;;Especies que no ens poden matar
                                                           ;ask qui [ set color red ]
    if qui = Carnivores [ set penalització-Carnivores penalització-Carnivores + 1]
    if qui = Flors [ set penalització-Flors penalització-Flors + 1]
    if qui = Papallones [ set penalització-Papallones penalització-Papallones + 1]
    if qui = Fenomens [ set penalització-Fenomens penalització-Fenomens + 1]
  ]

end


;;metodes dels altres ..............................................................................................................................................


to papallones-morir[ qui ]
  die
end

to talps-morir[ qui ]
  die
end

to aranyes-morir[ qui ]
  die
end
@#$#@#$#@
GRAPHICS-WINDOW
312
116
5325
5130
-1
-1
5.0
1
10
1
1
1
0
0
0
1
-500
500
-500
500
0
0
1
cicles
30.0

SLIDER
17
84
189
117
GuineusTotal
GuineusTotal
0
1000
64.0
1
1
NIL
HORIZONTAL

SLIDER
17
126
189
159
TalpsTotal
TalpsTotal
0
20
20.0
1
1
NIL
HORIZONTAL

SLIDER
17
174
189
207
CarnivoresTotal
CarnivoresTotal
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
18
227
190
260
FlorsTotal
FlorsTotal
0
200
172.0
1
1
NIL
HORIZONTAL

SLIDER
15
282
187
315
PapallonesTotal
PapallonesTotal
0
900
212.0
1
1
NIL
HORIZONTAL

SLIDER
14
335
186
368
GranotesTotal
GranotesTotal
2
500
173.0
1
1
NIL
HORIZONTAL

SLIDER
15
396
187
429
AranyesTotal
AranyesTotal
0
1000
89.0
1
1
NIL
HORIZONTAL

BUTTON
20
548
86
581
Setup
Setup
NIL
1
T
OBSERVER
NIL
9
NIL
NIL
1

BUTTON
21
587
84
620
Go
Go
T
1
T
OBSERVER
NIL
4
NIL
NIL
1

SLIDER
18
45
190
78
FenomenTotal
FenomenTotal
0
1
0.0
1
1
NIL
HORIZONTAL

PLOT
14
692
291
1476
Ecosistema
NIL
NIL
0.0
10.0
0.0
250.0
true
true
"" ""
PENS
"Ecosistema" 1.0 0 -16777216 true "" "plot count turtles"
"Flors" 1.0 0 -7500403 true "" "plot count Flors"
"Carnivores" 1.0 0 -2674135 true "" "plot count Carnivores"
"Aranyes" 1.0 0 -955883 true "" "plot count Aranyes"
"Papallones" 1.0 0 -6459832 true "" "plot count Papallones"
"Talps" 1.0 0 -1184463 true "" "plot count Talps"
"Granotes" 1.0 0 -10899396 true "" "plot count Granotes"
"Guineus" 1.0 0 -13840069 true "" "plot count Guineus"

MONITOR
314
10
394
55
Guineus
count Guineus
17
1
11

MONITOR
409
10
490
55
Carnivores
count Carnivores
17
1
11

MONITOR
507
10
585
55
Flors
count flors
17
1
11

MONITOR
602
10
679
55
Talps
count Talps
17
1
11

MONITOR
696
10
773
55
Papallones
count Papallones
17
1
11

MONITOR
789
10
866
55
Aranyes
count Aranyes
17
1
11

MONITOR
884
10
962
55
Granotes
count Granotes
17
1
11

BUTTON
198
536
285
569
GO 1 step
go
NIL
1
T
OBSERVER
NIL
1
NIL
NIL
1

BUTTON
196
574
293
607
Go 10 steps
go go go go go\ngo go go go go
NIL
1
T
OBSERVER
NIL
2
NIL
NIL
1

BUTTON
195
617
299
650
Go 100 steps
let steps 100\nloop [\n    go\n    set steps steps - 1\n    if steps <= 0 [ stop ]\n]
NIL
1
T
OBSERVER
NIL
3
NIL
NIL
1

@#$#@#$#@
# ECOSISTEMA 

En aquest model hi conviuran 7 espècies conegudes i 1 fenomen desconegut sobre un espai de 500x500 patches.

## COM ES DESENVOLUPARÀ 

Cadascun dels equips haurà de desenvolupar el seu agent per tal de que sense violar les restriccions imposades en el document de la pràctica pugui garantir la no extinció de l’espècie modelada amb NetLogo.

Els mètodes que siguin específics d'una espècie hauran de nombrar-se amb el prefixe -espècie, així un métode que es digui menjar per a l'espècie talp i guineu tindrà el nom de **talp-menja** i **guineu-menja**

Les espècies poden protegir-se mitjançant l'unió amb espècies no depradores seves o fent un grup de cinc individus que es moguin conjuntament en el mateix patch

Per a matar una espècie es comunicarà mitjançant el missatge genèric **especie-morir**, és a dir cada espècie s'ha de preocupar de morir-se invocant el métode **die** quan li notifiquin que és morta previa comprovació de que realment ha de morir-se.

## ESPÈCIES

### Comú a totes les espècies
Quan un depredador coincideix amb una presa, la presa mort instàntaniament si el depredador decideix menjar-se-la.
Mentre una espècie menja no es pot moure i pot ser menjada.
La visibilitat de les especies és una circunferència de radi la seva velocitat màxima de desplaçament.

### Aranya
**Velocitat màxima**: 2 p/c
**Vida:**: 2000 c
**Mort per inanició**: 1500 cicles
**Dieta**: Menja papallones i capgrossos, i aranyes més joves si porta més de 300 cicles sense menjar, pot menjar-se tots els capgrossos d’un patch, necessiten 5 cicles per menjar.
**Reproducció**:Per parella cada 800c inicien un període de fertilitat de 25 cicles, tenen 100 cries que es mouen a 3p/c i no necessiten menjar res fins que són madures (200 cicles després de néixer)
**Habitat**
Les aranyes adultes (més de 1000 cicles) poden nedar i construeixen una sola teranyina de 5x5 patches en qualsevol mitja aigua o terra.
Les aranyes petites s'ofeguen

### TALP
**Velocitat màxima**: 2 p/c
**Vida:**: 50000 c
**Mort per inanició**: 1000 cicles
**Dieta**: Menja papallones, granotes i aranyes necessiten 5 cicles per menjar.
**Reproducció**:Per parella cada 1000c inicien un període de fertilitat de 100 cicles, tenen 10 cries que no es mouen mentre són al cau i no necessiten menjar res fins que són madures (250 cicles després de néixer) moment en que deixen el cau.
**Habitat**
Els talps fan un cau cada cop que s'aparellen, sempre sobre terra ferma, i mida màxima de 3x3 patches on les cries estan segures, sols les granotes i els talps poden entrar en un cau.
Els talps i les seves cries s’ofeguen si entren en contacte amb l'aigua.
Els caus envoltats de plantes carnívores esdevenen una gàbia d'on no podrà sortir el talp.

### PLANTA CARINIVORA
**Velocitat màxima**: 0 p/c
**Vida:**: 100000 c
**Reproducció**: Reproducció, broten 3 noves plantes a una distància de 5 patches de la planta mare, aquest fet el poden realitzar cada 30000 cicles.
**Dieta**: Menja papallones i aranyes, poden morir per inanició després de 90000 cicles, no necessiten cicles per menjar.
**Habitat**
Sempre sobre terra ferma


### GUINEU
**Velocitat màxima**: 8 p/c
**Vida:**: 25000 c
**Mort per inanició**: 1000 cicles
**Dieta**: Menja Talps i granotes necessita 25 cicles per menjar
**Reproducció**:Per parella cada 10000c inicien un període de fertilitat de 100 cicles. El període de gestació és de 100 cicles més. 
La camada és de 3 cries que triguen 500 cicles per a madurar i que es mouen amb els seus pares mentre siguin petites.
Després de criar les parelles es separen i els fills es mouen amb algun dels pares fins que són adults.
**Habitat**
No entren a l'aigua i no poden travessar les plantes carnívores.

### GRANOTA
**Velocitat màxima**: 5 p/c dins l'aigua i 2 p/c fora de l'aigua
**Vida:**: 5000 c
**Mort per inanició**: 500 cicles
**Dieta**: Menja Aranyes, Papallones i Talps petits necessita 3 cicles per menjar.
**Reproducció**:Per parella cada 1000c inicien un període de fertilitat de 50 cicles. El període de gestació és de 100 cicles més, moment en que eclosionen 100 capgrossos que necessiten 250 cicles per a ser una granota madura, com a capgrossos no necessiten menjar però tampoc poden sortir de l'aigua i no es mouen.
**Habitat**
Poden viure dins l'aigua on estan sempre segures i surten de l'aigua per a menjar, tot i que poden menjar aranyes que estiguin dins l'aigua.


### PAPALLONA
**Velocitat màxima**: 15 p/c 
**Vida:**: 5000 c
**Mort per inanició**: 1000 cicles
**Dieta**: Pol·len necessiten 10 cicles per a nodrir-se no poden abandonar la flor fins que passin els 10 cicles.
**Reproducció**:Per parella cada 1000c inicien un període de fertilitat de 50 cicles. El període de gestació és de 10 cicles més, durant aquest cicle poden fer una posta de 10 larves per cicle en un mateix patch, cada posta necessita 100 cicles per a ser papallona. Mentre no siguin papallones no es podran moure.
**Habitat**
No es coneix cap limitació d'habitat però si cauen en una teranyina no es poden moure durant 100 cicles.

### FLORS
**Velocitat màxima**: 0 p/c 
**Vida:**: 5000 c o quan es crea un cau en el mateix patch
**Productores de pol·len** necessiten 100 cicles per a poder produir pol·len. Només admet tres papallones simultàniament.
**Dieta**: 
**Reproducció**:Espontània, cada 1000 cicles sorgeixen 1 flor a una distància màxima de 3 patch
**Habitat**
No creixen sobre aigua ni sobre caus

### FENOMEN MISTERIÒS
**Velocitat màxima**: 10 p/c 
**Vida**: Podeu executar 1000 cops el vostre fenomen, si aconseguiu matar alguna individu no perdeu vida
**Habitat**: Pot canviar les condicions de l'habitat d'un patch sempre que estigui en aquest patch i per a fer-ho necessita que passin 5 cicles.

## AVALUACIÓ

### INTEGRACIÓ 
El proper **9 d'abril** lliurareu el vostre agent en un arxiu de text pla a jordi.montero@upc.edu amb el subjecte del correu netlogo-numerogrup per a poder integrar els diferents elements i observar el seu comportament, i **haureu de pujar la presentació i arxiu adjuntat per correu electrònic a l'entrada de la pràctica que es crearà en el racó**

### PRESENTACIÓ 
El dia **16 d'abril** presentàreu l’estratègia que heu implementat per la vostra espècie, i presentar el **powerpoint/pdf del vostre agent** (3' per grup)

### COMPETICIÓ
S'executaran diferents models que integraren diferents espècies que poden ser del mateix o diferents grups.


### COM ES VALORARÀ LA PRÀCTICA

* Es valorarà de forma positiva l'ús de les funcions de suport que ofereix netlogo.
* La implementació d'una estratègia que permeti la defensa de la vostra espècie mitjançant la col·laboració d'individus.
* Ajustar-se a les restriccions que es defineixen en aquest document.
* La presentació a classe de forma individualitzada de l'estrategia desenvolupada.
* El tipus d'agent que s'implementi
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

spider
true
0
Circle -6459832 true false 96 96 108
Line -7500403 true 180 105 225 60
Line -7500403 true 225 60 255 105
Line -7500403 true 165 165 225 120
Line -7500403 true 225 120 255 150
Line -7500403 true 120 135 60 105
Line -7500403 true 60 105 60 135
Line -7500403 true 135 180 45 180
Line -7500403 true 45 180 60 225
Line -7500403 true 105 165 75 150
Line -7500403 true 75 150 75 180
Line -7500403 true 195 120 225 90
Line -7500403 true 225 90 240 120
Circle -16777216 false false 101 146 67
Circle -1184463 true false 101 146 67
Circle -16777216 true false 105 165 30
Circle -16777216 true false 135 165 30

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
