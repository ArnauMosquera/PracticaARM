# **Informe de la Pràctica de Fundaments de Computadors**

**Nom de l’estudiant:**  
**NIU:**  
**Assignatura:** Fundaments de Computadors  
**Pràctica:** Conversió de codi C a ARM - Anàlisi i processament de temperatures  
**Data de lliurament:** 22 d’abril de 2025

---

## **Índex**

1. [1_celsfahr_E9M22](#1_celsfahr_E9M22)  
    1.1 [Especificacions](#11-especificacions)  
    1.2 [Disseny](#12-disseny)  
    1.3 [Implementació](#13-implementació)  
    1.4 [Joc de proves ampliat](#14-joc-de-proves-ampliat)

2. [2_GeoTemp](#2_geotemp)  
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

> _Afegeix aquí una explicació clara de les funcionalitats i el comportament esperat de cada rutina._

####1.1.1.E9M22_add####
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
