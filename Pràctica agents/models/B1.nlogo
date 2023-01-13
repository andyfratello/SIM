extensions [array]

globals [
  AiguaTotal
  penalitzacio-papallones
  penalitzacio-aranyes
  penalitzacio-granotes
  penalitzacio-guineus
  penalitzacio-talps
  penalitzacio-flors
]


turtles-own[
  Vida
  Velocitat
  Inanició
  Fertilitat
  PeriodeFertilitat
  Cries
  MaduresaCries
]

Carnivores-own[
  HeMenjat
  nouMovX
  nouMovY
  ok
  randPos
  randNum
  pos_expansio
  rPx
  rPy
  threshold
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
  create-Guineus GuineusTotal[
    setxy random-xcor random-ycor
    set shape "wolf"
    set color blue
    set size 6
  ]
  create-Talps TalpsTotal[
    setxy random-xcor random-ycor
    set shape "bug"
    set color blue
    set size 6
  ]
  create-Carnivores CarnivoresTotal[
    setxy random-xcor random-ycor
    set shape "plant"
    set color blue
    set size 6
    set Vida 0
    set Inanició 0
    set HeMenjat 0
    set nouMovX xcor + 0
    set nouMovY ycor + 5
    set pos_expansio []
    set pos_expansio fput (list int 0 int 5) pos_expansio
    set pos_expansio fput (list int 1 int 4) pos_expansio
    set pos_expansio fput (list int 2 int 3) pos_expansio
    set pos_expansio fput (list int 3 int 2) pos_expansio
    set pos_expansio fput (list int 4 int 1) pos_expansio
    set pos_expansio fput (list int 5 int 0) pos_expansio
    set pos_expansio fput (list int 4 int -1) pos_expansio
    set pos_expansio fput (list int 3 int -2) pos_expansio
    set pos_expansio fput (list int 2 int -3) pos_expansio
    set pos_expansio fput (list int 1 int -4) pos_expansio
    set pos_expansio fput (list int 0 int -5) pos_expansio
    set pos_expansio fput (list int -1 int -4) pos_expansio
    set pos_expansio fput (list int -2 int -3) pos_expansio
    set pos_expansio fput (list int -3 int -2) pos_expansio
    set pos_expansio fput (list int -4 int -1) pos_expansio
    set pos_expansio fput (list int -5 int 0) pos_expansio
    set pos_expansio fput (list int -4 int 1) pos_expansio
    set pos_expansio fput (list int -3 int 2) pos_expansio
    set pos_expansio fput (list int -2 int 3) pos_expansio
    set pos_expansio fput (list int -1 int 4) pos_expansio
    set randPos []
  ]
  create-Flors FlorsTotal[
    setxy random-xcor random-ycor
    set shape "flower"
    set color blue
    set size 6
  ]
  create-Aranyes AranyesTotal[
    setxy random-xcor random-ycor
    set shape "spider"
    set color blue
    set size 6
  ]
  create-Granotes GranotesTotal[
    setxy random-xcor random-ycor
    set shape "turtle"
    set color blue
    set size 6
  ]
  create-Papallones PapallonesTotal[
    setxy random-xcor random-ycor
    set shape "butterfly"
    set color blue
    set size 6
  ]
  create-Fenomens FenomenTotal[
    setxy random-xcor random-ycor
    set shape "arrow"
    set color blue
    set size 10
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
  ask turtles[
    moure-generic
    eat-generic
  ]
  tick

  ask Carnivores[
    carnivores-parir
    carnivores-hemenjat
    carnivores-vida
    carnivores-inanicio
  ]
end


to carnivores-parir;
  if (Vida = 30000 or Vida = 60000 or Vida = 90000)
  [
    carnivores-on-apareix
    hatch-Carnivores 1 [
      setxy nouMovX nouMovY
      set Vida 0
      set Inanició 0
      set HeMenjat 0
    ]
    carnivores-on-apareix
    hatch-Carnivores 1 [
      setxy nouMovX nouMovY
      set Vida 0
      set Inanició 0
      set HeMenjat 0
    ]
    carnivores-on-apareix
    hatch-Carnivores 1 [
      setxy nouMovX nouMovY
      set Vida 0
      set Inanició 0
      set HeMenjat 0
    ]
  ]
end


to carnivores-on-apareix
  set ok 0
  set threshold 0
  while [(ok = 0) and threshold < 5] [
    set randNum random 20
    set randPos item randNum pos_expansio

    set rPx item 0 randPos
    set rPy item 1 randPos
    if (((xcor + rPx) > -500 and (xcor + rPx) < 500) and ((ycor + rPy) > -500 and (ycor + rPy) < 500)) [ ;Mirar si posicio dins dels marges
      set nouMovX rPx + xcor
      set nouMovY rPy + ycor
      set ok 1
    ]

    while [([pcolor] of patch nouMovX nouMovY = 95) and (ok = 1)] [ ;Navegació per el riu
      set nouMovX nouMovX + 1
      print ok
      ifelse (((nouMovX) > -500 and (nouMovX) < 500) and ((nouMovY) > -500 and (nouMovY) < 500))[
        set ok 1
      ]
      [
        set ok 0
      ]
    ]

    if ([pcolor] of patch nouMovX nouMovY = 34) [ ;Cas Intenta apareixer sobre un cau
      set ok 0
    ]

    if ([pcolor] of patch nouMovX nouMovY = 9) [  ;Cas destroçar teranyina
      ask patch nouMovX nouMovY [ set pcolor green ]
    ]

    if (count Carnivores-at nouMovX nouMovY > 0) [ ;Si ja esta ocupat no ens interesa apareixer
      set ok 0
    ]
    set threshold threshold + 1
  ]

end

to carnivores-vida;
  set Vida Vida + 1
  if(Vida = 100000)[
    ask Carnivores-here [morir-carnivores myself]
  ]
  if(Aigua)[
    ask Carnivores-here [morir-carnivores myself]
  ]
  if (Cau) [ ;Cas Intenta apareixer sobre un cau
    ask Carnivores-here [morir-carnivores myself]
  ]
end


to carnivores-hemenjat;
  ifelse breed = Carnivores and ((count Papallones-here with [Vida > 100] > 0 and (count Papallones-here with [Vida > 100] < 5)) or (count Aranyes-here with [Vida > 1000]> 0 and (count Aranyes-here with[Vida > 1000] < 5)))  [
    ask Carnivores-here [carnivores-menjar]
    set HeMenjat 1
  ]
  [
    set HeMenjat 0
  ]
end

;
to carnivores-menjar;

    ifelse (count Aranyes-here > 0 )[
      while [(count Aranyes-here > 0)]
      [
        let presa one-of Aranyes-here
        ask presa [morir-aranyes myself]
      ]
      beep
    ]
    [
      while [(count Papallones-here > 0)][
        let presa one-of Papallones-here
        ask presa [morir-papallones myself]
      ]
      beep
    ]

end


to morir-aranyes [qui]

end

to morir-papallones [qui]

end

to carnivores-inanicio;
  ifelse (HeMenjat = 1)[
    set Inanició 0
  ]
  [
    set Inanició Inanició + 1
  ]

  if (Inanició = 90000)
  [
    ask Carnivores-here [morir-carnivores myself]
  ]
end




to morir-carnivores [qui]
  if (qui = one-of Aranyes) [
     set penalitzacio-aranyes penalitzacio-aranyes + 1
  ]
    if (qui = one-of Papallones) [
     set penalitzacio-papallones penalitzacio-papallones + 1
  ]
    if (qui = one-of Talps) [
     set penalitzacio-talps penalitzacio-talps + 1
  ]
    if (qui = one-of Guineus) [
     set penalitzacio-guineus penalitzacio-guineus + 1
  ]
    if (qui = one-of Flors) [
     set penalitzacio-flors penalitzacio-flors + 1
  ]
    if (qui = one-of Granotes) [
     set penalitzacio-granotes penalitzacio-granotes + 1
  ]
    if (qui = one-of Carnivores) [
    ask myself [die]
  ] if (qui = one-of Fenomens) [
     if (Aigua or [pcolor] of patch-here = 34)[
        ask myself [die]
     ]
  ]

end








to moure-generic ; turtle procedure
   ifelse breed = Flors or breed = Carnivores[
  ]
  [
   rt random-float 90 - random-float 90
   fd 1
  ]
end




to eat-generic ;

  if breed = Papallones and (count Flors-here > 0)
  [
    set color red
  ]
  if breed = Aranyes and (count Papallones-here > 0)
  [
    let presa one-of papallones-here

    ask presa[ morir]
    beep
  ]
  if breed = Talps and (count Aranyes-here > 0)
  [
    let presa one-of Aranyes-here
    ask presa[ morir]
    beep
  ]
  if breed = Granotes and (count Talps-here > 0)
  [
    let presa one-of Talps-here
    ask presa[ morir]
    beep
  ]
  if breed = Carnivores and ((count Papallones-here > 0 and (count Papallones-here + count Guineus-here < 5)) or (count Aranyes-here > 0 and (count Aranyes-here + count Guineus-here < 5)))[
    ifelse (count Aranyes-here > 0 )[
      let presa one-of Aranyes-here
      ask presa [morir]
      beep
    ]
    [
      let presa one-of Papallones-here
      ask presa[ morir]
      beep
    ]
  ]
  if breed = Guineus and (count Talps-here > 0 or count Granotes-here > 0)
  [
    ifelse (count Talps-here > 0)[
      let presa one-of Talps-here
      ask presa[ morir]
      beep
    ]
    [
      let presa one-of Granotes-here
      ask presa[ morir ]
      beep
    ]
  ]
end

to morir
  set color red
  die
end
@#$#@#$#@
GRAPHICS-WINDOW
315
55
5328
5069
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
1
1
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
1
5
0.0
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
1
20
0.0
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
1
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
1
200
1.0
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
1
100
3.0
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
1
50
1.0
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
1
100
1.0
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
NIL
NIL
NIL
1

BUTTON
120
547
183
580
Go
Go
T
1
T
OBSERVER
NIL
NIL
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
614
291
1398
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
316
10
396
55
Guineus
count Guineus
17
1
11

MONITOR
411
10
492
55
Carnivores
count Carnivores
17
1
11

MONITOR
509
10
587
55
Flors
count flors
17
1
11

MONITOR
604
10
681
55
Talps
count Talps
17
1
11

MONITOR
698
10
775
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
La visibilitat de les especies és una circunferència de radi 17 - velocitat màxima de desplaçament.

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
El dia **23 d'abril** presentàreu l’estratègia que heu implementat per la vostra espècie, i presentar el **powerpoint/pdf del vostre agent** (3' per grup)

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
NetLogo 6.0.4
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
