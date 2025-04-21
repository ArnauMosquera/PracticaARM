/*-----------------------------------------------------------------
|   Selecció implementació (C/ARM) rutines de coma flotant E9M22.
|   HA DE COINCIDIR amb el seleccionat a E9M22_impl.i.
| -----------------------------------------------------------------
|   pere.millan@urv.cat
|   (Març 2025)
| ----------------------------------------------------------------
|   Programador/a 1: albert.marti@estudiants.urv.cat
|   Programador/a 2: arnau.mosquera@estudiants.urv.cat
|-----------------------------------------------------------------*/

#ifndef E9M22_IMPL_H
#define E9M22_IMPL_H

/******************************************************/
/* Rutines de CONVERSIÓ de valors E9M22 <-> float/int */
/******************************************************/

#define E9M22_to_float  E9M22_to_float_c_   // Versió en C
#define float_to_E9M22  float_to_E9M22_c_   // Versió en C
#define E9M22_to_int    E9M22_to_int_c_     // Versió en C
#define int_to_E9M22    int_to_E9M22_c_     // Versió en C

/*************************************************/
/* Operacions ARITMÈTIQUES en Coma Flotant E9M22 */
/*************************************************/

#define E9M22_add   E9M22_add_c_    // Versió en C
#define E9M22_sub   E9M22_sub_s     // Versió assemblador (IMPLEMENTADA)
#define E9M22_mul   E9M22_mul_c_    // Versió en C
#define E9M22_div   E9M22_div_c_    // Versió en C
#define E9M22_neg   E9M22_neg_s     // Versió assemblador (IMPLEMENTADA)
#define E9M22_abs   E9M22_abs_s     // Versió assemblador (IMPLEMENTADA)

/*************************************************************/
/* Operacions de COMPARACIÓ de números en Coma Flotant E9M22 */
/*************************************************************/

#define E9M22_are_eq        E9M22_are_eq_s      // Versió assemblador (IMPLEMENTADA)
#define E9M22_are_ne        E9M22_are_ne_c_     // Versió en C
#define E9M22_are_unordered E9M22_are_unordered_c_  // Versió en C
#define E9M22_is_gt         E9M22_is_gt_c       //Versió en C
#define E9M22_is_ge         E9M22_is_ge_c_      // Versió en C
#define E9M22_is_lt         E9M22_is_lt_c_      // Versió en C
//#define E9M22_is_le         E9M22_is_le_c      // Versió en C

/**********************************************************/
/* Funcions auxiliars: NORMALITZACIÓ i ARRODONIMENT E9M22 */
/**********************************************************/

#define E9M22_normalize_and_round E9M22_normalize_and_round_c_  // Versió en C
#define E9M22_round              E9M22_round_c_                 // Versió en C

/****************************************************************/
/* Funcions AUXILIARS per treballar amb els bits de codificació */
/****************************************************************/

#define count_leading_zeros   count_leading_zeros_c_    // Versió en C
#define count_trailing_zeros  count_trailing_zeros_c_   // Versió en C

#endif /* E9M22_IMPL_H */
