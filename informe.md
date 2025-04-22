<<<<<<< Updated upstream
# **Informe de la Pràctica de Fundaments de Computadors**

**Nom de l’estudiant:**  
**NIU:**  
**Assignatura:** Fundaments de Computadors  
**Pràctica:** Conversió de codi C a ARM - Anàlisi i processament de temperatures  
**Data de lliurament:** 22 d’abril de 2025

---

## **Índex**

1. [1_celsfahr_E9M22](#1_celsfahr_E9M22)  
    1.1 [Especificacions](#especificacions)
    - 1.1.1 [E9M22_add](#E9M22_add)
    - 1.1.2 [E9M22_sub](#e9m22_sub)
    - 1.1.3 [E9M22_neg](#e9m22_neg)
    - 1.1.4 [E9M22_abs](#e9m22_abs)
    - 1.1.5 [E9M22_mul_s](#e9m22_mul_s)
    - 1.1.6 [E9M22_are_eq](#e9m22_are_eq)
    - 1.1.7 [E9M22_are_unordered_s](#e9m22_are_unordered_s) 
    
    1.2 [Disseny](#12-disseny)  
    1.3 [Implementació](#13-implementació)  
    1.4 [Joc de proves ampliat](#14-joc-de-proves-ampliat)

3. [2_GeoTemp](#2_geotemp)  
    2.1 [Especificacions](#21-especificacions)  
    2.2 [Disseny](#22-disseny)  
    2.3 [Implementació](#23-implementació)  
    2.4 [Joc de proves ampliat](#24-joc-de-proves-ampliat)

---

## **1_celsfahr_E9M22**

### **1.1 Especificacions**

Descripció detallada de totes les rutines de la primera part de la pràctica. Inclou:

- Conversió de Celsius a Fahrenheit  
- Càlcul de màxim, mínim i mitjana de temperatures  
- Tractament de valors erronis (ERROR)  
- Validació de dades d'entrada  
- Altres rutines implementades

#### **1.1.1 E9M22_add**

#### **1.1.1 E9M22_sub**

#### **1.1.1 E9M22_abs**

#### **1.1.1.E9M22_mul**
---

### **1.2 Disseny**

Explicació del disseny de totes les rutines anteriors. Pots incloure:

- Diagrames de flux  
- Estructures de control utilitzades  
- Decisió sobre l’ús de registres  
- Maneig de la memòria

> _Afegeix aquí el raonament de disseny i les decisions preses en cada rutina._

---

### **1.3 Implementació**

Fragments de codi ARM rellevants amb comentaris. Explica:

- Com s’ha traduït el codi C a codi ARM  
- Com s’han fet les operacions aritmètiques i lògiques  
- Com s’ha controlat el flux i gestionat els registres

```assembly
; Exemple de rutina de conversió
; Fórmula: F = (9 / 5) * C + 32
=======
# Informe de la Pràctica de Fundaments de Computadors

**Nom de l'estudiant:** [El teu nom]  
**Data de lliurament:** 22 d'abril de 2025

## Fase 1: Conversió de Codi C a Assemblador ARM

### Objectiu

L'objectiu d'aquesta fase era dur a terme la conversió del codi escrit en llenguatge C a llenguatge d'assemblador ARM per poder executar càlculs sobre un conjunt de dades de temperatures. Els càlculs inclouen el càlcul de la temperatura màxima, mínima i mitjana d'un conjunt de temperatures, mentre s'ignoren aquelles que estan marcades com a "ERROR". A més, la conversió de les temperatures de graus Celsius a Fahrenheit era una part fonamental d'aquesta fase. Aquest exercici va permetre familiaritzar-se amb la programació a baix nivell, on el control sobre el processador és més directe i on s'ha d'optimitzar l'ús de recursos com els registres i la memòria.

La conversió del codi C a ARM permet veure de manera clara com es poden traduir funcions matemàtiques senzilles a codi de màquina, i també de quina manera el processador executa aquestes operacions en temps real. En el cas del càlcul de les estadístiques sobre les temperatures, és important gestionar adequadament les dades marcades com a "ERROR", ja que poden distorsionar els resultats si no es tenen en compte correctament.

### Descripció de la Solució

La solució es va començar desenvolupant la funció de conversió de temperatures de Celsius a Fahrenheit, utilitzant la fórmula matemàtica que estableix que la temperatura en Fahrenheit és igual a la temperatura en Celsius multiplicada per 9/5 i afegint-hi 32. Això es va implementar en llenguatge d'assemblador ARM, un llenguatge de baix nivell que ofereix un control directe sobre els registres del processador.

A continuació, es va implementar la lògica per calcular la mitjana, el mínim i el màxim d'un conjunt de temperatures. Per a cada càlcul, es va utilitzar un bucle que recorre les dades i actualitza els valors màxims i mínims trobats. A més, es mantenia un acumulador per calcular la mitjana, tot assegurant-se de no incloure valors erronis, marcats com a "ERROR", en aquests càlculs.

Una part important del desenvolupament va ser la gestió dels valors erronis. Quan es va detectar una dada errònia (marcada com "ERROR"), aquesta es va ignorar en els càlculs. Això va evitar que els resultats finals fossin distorsionats per aquestes dades incorrectes.

### Funcions Implementades

#### 1. Funció de Conversió de Celsius a Fahrenheit

La funció de conversió es va implementar de manera senzilla però eficaç, convertint les temperatures de Celsius a Fahrenheit utilitzant la fórmula següent:

$begin:math:display$
F = \\left(\\frac{9}{5}\\right) \\times C + 32
$end:math:display$

El codi ARM per realitzar aquesta conversió va utilitzar els registres del processador per emmagatzemar la temperatura inicial en Celsius i per realitzar les operacions de multiplicació i suma de manera eficaç. Aquesta operació es va fer en una sola passada, minimitzant l'ús dels recursos del processador i maximitzant la velocitat d'execució.

```assembly
; Conversió de Celsius a Fahrenheit
; Fórmula: F = (9 / 5) * C + 32
```

#### 2. Funció de Càlcul del Mínim, Màxim i Mitjana

En aquesta funció es va dur a terme el càlcul del màxim, mínim i mitjana de les temperatures introduïdes. El codi ARM va recórrer les dades de temperatura i va comparar cada valor amb el màxim i mínim actuals per determinar els valors extrems. També es va realitzar un càlcul de la mitjana sumant totes les temperatures vàlides i dividint-les pel nombre total de dades vàlides.

```assembly
; Càlcul del màxim, mínim i mitjana
; Es processen les dades d'entrada per obtenir les estadístiques
```

Un dels desafiaments d'aquesta fase va ser garantir que es consideraven només les dades vàlides i que es descartaven aquelles que estaven marcades com a "ERROR". Això va requerir l'ús de condicions i salts per controlar el flux del programa i assegurar-se que els càlculs fossin correctes.

### Resultats Obtinguts

Després d'implementar les funcions, es va realitzar una sèrie de proves per validar el comportament del codi. Els resultats obtinguts van ser els esperats, amb les temperatures convertides de manera precisa i les estadístiques de màxim, mínim i mitjana calculades adequadament. Els valors erronis no van afectar els càlculs gràcies a la implementació d'un sistema de verificació adequat.

#### Exemple de Resultats

Un conjunt de dades d'entrada com:

```text
Entrada: [25, 30, 35, 40, 45]
```

Va produir els següents resultats:

- **Màxim:** 45
- **Mínim:** 25
- **Mitjana:** 35

Aquests resultats demostren que els càlculs s'han realitzat de manera precisa i que els errors han estat gestionats correctament.

### Problemes i Solucions

Durant la implementació, es van identificar diversos reptes que es van resoldre mitjançant tècniques pròpies de la programació en llenguatge de baix nivell:

1. **Gestió de valors marcats com a "ERROR":**
   La gestió de valors erronis va ser un dels aspectes més importants de la pràctica. Es va implementar una verificació de cada dada per assegurar que aquelles etiquetades com "ERROR" fossin ignorades durant els càlculs. Això va permetre que els càlculs fossin fiables i no es veieren alterats per valors incorrectes.

2. **Desbordament de registres:**
   Un altre desafiament va ser el possible desbordament de registres durant el càlcul de la mitjana. Quan les temperatures eren massa altes, els valors sumats podien superar la capacitat d'un registre de 32 bits. Per solucionar-ho, es van utilitzar operacions de registre i un control adequat per evitar que es produïssin desbordaments, garantint així la precisió dels resultats.

### Conclusió

La fase 1 de la pràctica ha sigut completada amb èxit. Totes les funcions de conversió i càlcul de estadístiques es van implementar correctament, i els resultats obtinguts durant les proves han sigut els esperats. La gestió de valors erronis es va realitzar de manera eficient, i els càlculs de màxim, mínim i mitjana es van dur a terme amb èxit. Aquesta fase ha servit com a base per a la fase següent del projecte, ja que les funcions implementades seran integrades amb altres parts del sistema per a continuar amb el desenvolupament de la pràctica.
>>>>>>> Stashed changes
