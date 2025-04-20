# 🎥 Guions vídeos explicatius – Pràctica ARM

## 👥 Equip: PracticaARMequipXXXX
- Alumne 1: _Nom Cognom_ – correu@estudiants.urv.cat
- Alumne 2: _Nom Cognom_ – correu@estudiants.urv.cat

---

## ✅ FASE 1 – Conversió Celsius/Fahrenheit

### 🎙️ Vídeo Alumne 1 – Funcions de conversió i demo

**Durada:** 2:30  
**Enfocament:** Explicació de `Celsius2Fahrenheit` i `Fahrenheit2Celsius`, demo i resultats

#### 🔹 Text a dir:

"Hola! Em dic [Nom] i aquest és el meu vídeo de la Fase 1 de la pràctica ARM. En aquesta fase hem fet la conversió entre Celsius i Fahrenheit utilitzant el format de coma flotant E9M22.

He implementat les funcions `Celsius2Fahrenheit` i `Fahrenheit2Celsius`. La primera fa la operació `(input * 9/5) + 32`, i la segona és `((input - 32) * 5/9)`. Les constants com 9/5 i 32.0 estan codificades en E9M22 en la secció .data.

Les operacions com multiplicació i suma les fem cridant les rutines `E9M22_mul`, `E9M22_add`, etc. Ho fem tot en llenguatge ensamblador ARM (GAS).

Ara us ensenyo el fitxer demo, `demo_CelsFahr.s`, on cridem aquestes funcions amb valors reals. En executar el programa amb GDB, podem veure que `temp1F` és 95.3780 °F, que és el valor esperat.

Aquest exercici m'ha ajudat molt a entendre com es criden funcions i es treballa amb valors codificats en ensamblador.

Moltes gràcies."

---

### 🎙️ Vídeo Alumne 2 – Rutines E9M22 pròpies

**Durada:** 2:30  
**Enfocament:** Implementació de rutines com `neg`, `abs`, `sub`, `are_eq`, etc.

#### 🔹 Text a dir:

"Hola, em dic [Nom] i en aquest vídeo us explicaré les rutines que hem implementat per operar amb nombres en format E9M22.

He programat les rutines `E9M22_neg_s`, que fa una XOR amb 0x80000000 per canviar el signe, i `E9M22_abs_s`, que fa una AND amb 0x7FFFFFFF per eliminar el bit de signe.

També he fet `E9M22_sub_s`, que fa la negació del segon operand i suma, i `E9M22_are_eq_s`, que compara dos valors amb `cmp` i retorna 1 si són iguals.

Aquestes funcions estan escrites al fitxer `E9M22_s.s`, i les he integrat al sistema mitjançant els fitxers `E9M22_impl.h` i `.i`, substituint les versions en C.

Quan he executat els tests amb GDB, he comprovat que el percentatge d'èxit era del 100%. Això indica que les funcions ASM estan ben implementades.

Ha estat una bona manera d'aprendre a manipular bits i fer operacions bàsiques sense float."

---

## ✅ FASE 2 – Processament de taula de temperatures

### 🎙️ Vídeo Alumne 1 – `avgmaxmin_city`

**Durada:** 2:30  
**Enfocament:** Recórrer una fila de la matriu i calcular mitjana, mínim i màxim

#### 🔹 Text a dir:

"Hola, soc [Nom] i aquest és el meu vídeo de la Fase 2 de la pràctica. En aquesta part he treballat amb la funció `avgmaxmin_city`, que calcula la temperatura mitjana, màxima i mínima per una ciutat concreta.

El paràmetre `id_city` serveix per seleccionar la fila de la matriu `ttemp`, i recorrem totes les columnes (els 12 mesos) amb un bucle. A cada iteració sumem la temperatura al `avg`, i actualitzem `max` i `min` si cal.

Les comparacions es fan amb les funcions `E9M22_is_gt` i `E9M22_is_lt`. Després de sumar, dividim per 12 amb `E9M22_div`.

Finalment, guardem els valors a l'estructura `mmres` usant `str` per als floats i `strh` per als índexs. Els desplaçaments estan definits a `avgmaxmintemp.i`.

He provat el funcionament amb els tests oficials i funciona correctament."

---

### 🎙️ Vídeo Alumne 2 – `avgmaxmin_month`

**Durada:** 2:30  
**Enfocament:** Recórrer una columna de la matriu (mes)

#### 🔹 Text a dir:

"Hola, soc [Nom], i en aquest vídeo explicaré la rutina `avgmaxmin_month`, que també forma part de la Fase 2.

Aquesta funció calcula les temperatures mitjana, màxima i mínima per a un mes concret. Per fer-ho, recorro totes les files de la matriu, és a dir, cada ciutat, i accedeixo a la columna `id_month`.

El codi calcula `offset = i * 48 + id_month * 4`, i llegeix la temperatura. Cada valor s'acumula a `avg` i es compara amb `max` i `min`.

Dividim entre el nombre de files (`nrows`) convertit a E9M22 amb `int_to_E9M22`. Guardem els resultats a `mmres` igual que abans.

He verificat els resultats amb GDB, i el percentatge d'èxit és correcte. Aquesta funció mostra com es pot accedir a matrius bidimensionals en ASM."

---

## 💪 Recomanacions

- Grava amb OBS o qualsevol capturador
- Mostra codi + resultat a Insight/GDB
- Fes servir una veu clara i mostra el teu entès del codi
- No passis de 2:30 minuts
