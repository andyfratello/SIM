globals [
  AiguaTotal
]

turtles-own[
  Vida
  Velocitat
  Inanició
  FertilitatCount
  Fertilitat
  Reproduccio
  ReproduccioCount
  Inanicio
  Cries
  posX
  posY
  Pair
  PairCount
]

patches-own[
  Aigua;color 95
  Terra; color 65
  cau; color 34
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

talps-own [
  direccio
  Vida
  Velocitat
  Inanició
  FertilitatCount
  Fertilitat
  Reproduccio
  ReproduccioCount
  Inanicio
  Cries
  posX
  posY
  Pair
  PairCount
]

to setup

  clear-all
  reset-ticks
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


  create-Guineus GuineusTotal[
    setxy random-xcor random-ycor
    set shape "wolf"
    set color blue
    set size 6
  ]
  create-Talps TalpsTotal[
    setxy random-xcor random-ycor
    set shape "bug"
    set color orange
    set size 6
    set Vida 250
    set Fertilitat false ; Boolea conforme es fertil
    set FertilitatCount 0 ; Contador de cicles fins ser fertil
    set Reproduccio false ; Boolea conforme s'esta fent l
    set ReproduccioCount 0 ; Contador de cicles fins acabar reproduccio
    set Inanicio 0
    set Cries false
    set Pair false
    set PairCount  0
  ]
  create-Carnivores CarnivoresTotal[
    setxy random-xcor random-ycor
    set shape "plant"
    set color blue
    set size 6
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

end

to granota-morir [qui]
  die
end

to papallona-morir [qui]
  die
end

to aranya-morir [qui]
  die
end

to talps-morir [qui]
  ifelse [breed] of qui = Granotes [
    ifelse cries = true [ die ] 
    [
      set penalitzacio-granotes penalitzacio-granotes + 1
    ]
  ]
  [
    ifelse [breed] of qui = Guineus [
      die
    ]
    [
      ifelse [breed] of qui = Aranyes [
        set penalitzacio-aranyes penalitzacio-aranyes + 1
      ]
      [
        ifelse [breed] of qui = Papallones [
          set penalitzacio-papallones penalitzacio-papallones + 1
        ]
        [
          ifelse [breed] of qui = Flors [
            set penalitzacio-flors penalitzacio-flors + 1
          ]
          [
            ifelse [breed] of qui = Carnivores [
              set penalitzacio-carnivores penalitzacio-carnivores + 1
            ]
            [
              ifelse [breed] of qui = Fenomens [
                die
              ]
              [
                
              ]
            ]
          ]
        ]
      ]
    ]
  ]
  
end

to talps-moure
  ifelse (Fertilitat = true)[
      set color pink
    ]
    [
       ifelse (Reproduccio = true)[
        set color white
      ]
      [
        set color orange
      ]
    ]
    
    set Vida Vida + 1
    if (Vida >= 50000) [
       die
    ]
    if (Pair = true) [
      ifelse (PairCount = 5) [
       set Pair  false
       set PairCount  0 
      ] 
      [
        set PairCount PairCount + 1
      ]
    ]
    ifelse (Cries = true) [ 
    set color yellow
      if (Vida >= 250) [
        set Cries false     
        set color orange
      ]
    ]
    [                      
      set Inanicio Inanicio + 1
      if (Inanicio >= 1000) [
        die
      ]
      
      ifelse (Fertilitat = false) [
        ifelse (FertilitatCount >= 1000)[
          set Fertilitat true
          set FertilitatCount 0
        ]
        [
          set FertilitatCount FertilitatCount + 1
        ]
      ]
      [
        ifelse (FertilitatCount >= 100)[
          set Fertilitat false
          set FertilitatCount 0
        ]
        [
          set FertilitatCount FertilitatCount + 1
        ]
      ]      

      ifelse(Reproduccio = true)[
        
        ifelse (ReproduccioCount = 250)[    
          set Reproduccio false
          set ReproduccioCount 0
        ]
        [
          set ReproduccioCount ReproduccioCount + 1
        ]
      ]
      [
      talps-moureon
      ]
    ]
end

to go
  ask turtles [
    moure-generic
    eat-generic
  ]
  tick
end

to moure-generic 
   ifelse breed = Flors or breed = Carnivores or breed = Talps[
  ]
  [
    rt random-float 90 - random-float 90
    fd 1
  ]
  if breed = Talps
  [
    talps-moure
  ]
end

to talps-cau
  ask patch-here [
      set cau true
      set pcolor 34
  ]

  set posX xcor - 1
  set posY ycor - 1
  if (min-pxcor < posX and min-pycor < posY and [terra] of  patch posX posY = true)[ 
    ask patch posX posY [
      set cau true
      set pcolor 34
    ]
  ]

  set posX xcor - 1
  set posY ycor
  if (min-pxcor < posX and [terra] of  patch posX posY = true)[ 
    ask patch posX posY [
      set cau true
      set pcolor 34
    ]
  ]

  set posX xcor - 1
  set posY ycor + 1
  if (min-pxcor < posX and max-pycor > posY and [terra] of  patch posX posY = true)[ 
    ask patch posX posY [
      set cau true
      set pcolor 34
    ]
  ]

  set posX xcor + 1
  set posY ycor - 1
  if (max-pxcor > posX and min-pycor < posY and [terra] of  patch posX posY = true)[ 
    ask patch posX posY [
      set cau true
      set pcolor 34
    ]
  ]

  set posX xcor + 1
  set posY ycor
  if (max-pxcor > posX and [terra] of  patch posX posY = true)[ ;x+1, y
    ask patch posX posY [
      set cau true
      set pcolor 34
    ]
  ]

  set posX xcor + 1
  set posY ycor + 1
  if (max-pxcor > posX and max-pycor > posY and [terra] of  patch posX posY = true)[ 
    ask patch posX posY [
      set cau true
      set pcolor 34
    ]
  ]

  set posX xcor
  set posY ycor + 1
  if (max-pycor > posY and [terra] of  patch posX posY = true)[ 
    ask patch posX posY [
      set cau true
      set pcolor 34
    ]
  ]

  set posX xcor
  set posY ycor - 1
  if (min-pycor < posY and [terra] of  patch posX posY = true)[ 
    ask patch posX posY [
      set cau true
      set pcolor 34
    ]
  ]

    hatch 10[
      set shape "bug"
      set color yellow
      set size 6
      set Vida 0
      set Fertilitat false
      set FertilitatCount 0
      set Reproduccio false
      set ReproduccioCount 0
      set Cries true
      set Inanicio 0
    ]
end

to talps-buscapresa
  let objectiug min-one-of Granotes in-radius 15 [ distance myself ]
  ifelse objectiug != nobody [ face objectiug ]
  [
    let objectiup min-one-of Papallones in-radius 15 [ distance myself ]
    ifelse objectiup != nobody [ face objectiup ]
    [
      let objectiua min-one-of Aranyes in-radius 15 [ distance myself ]
      ifelse objectiua != nobody [ face objectiua ]
      [
        rt random-float 90 - random-float 90
      ]
    ]
  ]
  ifelse ((pxcor + 2 < max-pxcor) and (pxcor - 2 > min-pxcor) and (pycor + 2 < max-pycor) and (pycor - 2 > min-pycor)) [
    ifelse([aigua] of patch-ahead 2 = false) [
            fd 2
    ]
    [
      rt 180
      fd 2
    ]
  ]
  [
    rt random-float 90 - random-float 90
    fd 2
  ]
end

to talps-moureon
  if ([aigua] of patch-here = true) [die]
  if (Pair = false) [
  ifelse (Fertilitat = true) [ 
      ifelse (count Talps-here >= 2 and count Talps-here with [Fertilitat = True] >= 2) [

        show count Talps-here with [Fertilitat = True]
        ;set Reproduccio true
        ask Talps-here [
          set Fertilitat false
        ]
        set Reproduccio true
        talps-cau
      ]
      [
        let visio patches in-radius 15
        let objectiu one-of visio with [any? Talps-here]
        ifelse objectiu != nobody [
          ifelse objectiu = self [
            talps-buscapresa
          ]
          [
            face objectiu
            ifelse ((pxcor + 2 <= max-pxcor) and (pxcor - 2 >= min-pxcor) and (pycor + 2 <= max-pycor) and (pycor - 2 >= min-pycor)) [
              if ([aigua] of patch-ahead 2 = false) [
              fd 2
              ]
            ]
            [
              rt random-float 90 - random-float 90
              fd 2
            ]
          ]
        ]
        [
          talps-buscapresa
        ]
      ]
    talps-buscapresa
  ]
  [
    talps-buscapresa
  ]
  ]
end

to talps-menjar
  ifelse (count Granotes-here > 0)[
    let presa one-of Granotes-here
    if presa != nobody [
      ask presa [granota-morir myself]
      set pair true
      set Inanicio 0
      ;beep
    ]
  ]
  [
    ifelse (count Papallones-here > 0)[
      let presa one-of Papallones-here
      if presa != nobody [
        ask presa [ papallona-morir myself ]
        set pair true
        set Inanicio 0
        ;beep
      ]
    ]
    [
      let presa one-of Aranyes-here
      if presa != nobody [
        ask presa [aranya-morir myself]
        set pair true
        set Inanicio 0
        ;beep
      ]
    ]
  ]
end

to eat-generic 
  if breed = Papallones and (count Flors-here > 0)
  [
    set color red
  ]
  if breed = Aranyes and (count Papallones-here > 0)
  [
    let presa one-of papallones-here
    ask presa[ morir]
    ;beep
  ]
  if breed = Talps
  [
    talps-menjar
  ]
  if breed = Granotes and (count Talps-here > 0)
  [
    let presa one-of Talps-here
    ask presa[ talps-morir myself ]
    ;beep
  ]
  if breed = Carnivores and (count Papallones-here > 0 or count Aranyes-here > 0)
  [

    ifelse (count Aranyes-here > 0)[
      let presa one-of Aranyes-here
      ask presa [morir]
      ;beep
    ]
    [
      let presa one-of Papallones-here
      ask presa[ morir]
      ;beep
    ]
  ]
  if breed = Guineus and (count Talps-here > 0 or count Granotes-here > 0)
  [
    ifelse (count Talps-here > 0)[
      let presa one-of Talps-here
      ask presa[ morir]
      ;beep
    ]
    [
      let presa one-of Granotes-here
      ask presa[ morir]
      ;beep
    ]
  ]
end

to morir
  set color red
  die
end
