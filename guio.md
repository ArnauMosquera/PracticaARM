# 🎥 Guions vídeos explicatius – Pràctica ARM

## 👥 Equip: PracticaARMequipXXXX
- Alumne 1: _Nom Cognom_ – correu@estudiants.urv.cat
- Alumne 2: _Nom Cognom_ – correu@estudiants.urv.cat

---

## ✅ FASE 1 – Conversió Celsius/Fahrenheit

### 🎙️ Vídeo Alumne 1 – Funcions de conversió i demo

**Durada:** 2:30  
**Enfocament:** Explicació de `Celsius2Fahrenheit` i `Fahrenheit2Celsius`, demo i resultats

#### 🔹 Estructura del vídeo:

1. **Intro (0:00–0:20)**  
   Presentació personal + resum objectiu

2. **Explicació del codi ASM (0:20–1:10)**  
   - Operació `(input * 9/5) + 32`
   - Constants definides amb `.word`
   - Crida a `E9M22_mul` i `E9M22_add`

3. **Execució i comprovació (1:10–2:10)**  
   - Mostrar `demo_CelsFahr.s`
   - Executar `make debug` i `p /x temp1F`
   - Verificar que el resultat és correcte

4. **Tancament (2:10–2:30)**  
   Breu reflexió sobre l’aprenentatge

---

### 🎙️ Vídeo Alumne 2 – Rutines E9M22 pròpies

**Durada:** 2:30  
**Enfocament:** Implementació de rutines com `neg`, `abs`, `sub`, `are_eq`, etc.

#### 🔹 Estructura del vídeo:

1. **Intro (0:00–0:20)**  
   Presentació i introducció

2. **Explicació codi (`E9M22_s.s`) (0:20–1:40)**  
   - `E9M22_neg_s` amb XOR
   - `E9M22_abs_s` amb AND
   - `E9M22_sub_s` amb neg + add
   - Comparacions simples amb `cmp`

3. **Test de funcionament (1:40–2:10)**  
   - Percentatge d’èxit a `gdb`

4. **Tancament (2:10–2:30)**  
   Conclusions sobre treball amb bits

---

## ✅ FASE 2 – Processament de taula de temperatures

### 🎙️ Vídeo Alumne 1 – `avgmaxmin_city`

**Durada:** 2:30  
**Enfocament:** Recórrer una fila de la matriu i calcular mitjana, mínim i màxim

#### 🔹 Estructura del vídeo:

1. **Intro (0:00–0:20)**  
   Presentació + funció que explicaràs

2. **Descripció de la funció (0:20–1:40)**  
   - Com accedir a `ttemp[id_city][i]`
   - Ús de `E9M22_add`, `is_gt`, `is_lt`
   - Càlcul de mitjana (`div per 12`)

3. **Assignació a estructura `mmres` (1:40–2:10)**  
   - Ús de `str`, `strh` amb `MM_...`

4. **Tancament (2:10–2:30)**  
   Aprenentatge sobre matrius i ASM

---

### 🎙️ Vídeo Alumne 2 – `avgmaxmin_month`

**Durada:** 2:30  
**Enfocament:** Recórrer una columna de la matriu (mes)

#### 🔹 Estructura del vídeo:

1. **Intro (0:00–0:20)**  
   Presentació + resum de la funció

2. **Descripció de bucle per files (0:20–1:30)**  
   - Accés a `ttemp[i][id_month]`
   - Multiplicació per 48, desplaçament de columnes

3. **Comparacions i càlcul (1:30–2:10)**  
   - `E9M22_add`, `div` amb `int_to_E9M22(nrows)`
   - Guardar resultats amb `str` i `strh`

4. **Tancament (2:10–2:30)**  
   Comentari final sobre comprensió de matrius en ASM

---

## 🛠️ Recomanacions generals

- Mostra el codi mentre parles
- Usa `Insight` o `GDB` per demostrar els resultats
- No sobrepassis els 2:30 minuts
- Sigues clar, breu i segur

---

