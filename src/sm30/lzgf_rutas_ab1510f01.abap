*----------------------------------------------------------------------*
***INCLUDE LZGF_RUTAS_AB1510F01.
*----------------------------------------------------------------------*.
*&---------------------------------------------------------------------*
*& Form F_VALIDAR_ENTREGA
*&---------------------------------------------------------------------*
*& Evento 01 de la SM30 de ZENTREGA_AB1510: antes de grabar
*&---------------------------------------------------------------------*
FORM f_validar_entrega.

  DATA ls_entrega TYPE zentrega_ab1510.

* Recorro todas las filas de la SM30
  LOOP AT total.

*   Solo me interesan las nuevas o las modificadas
    IF <action> = neuer_eintrag OR <action> = aendern.

*     Paso la fila a mi estructura para poder leer los campos
      ls_entrega = <vim_total_struc>.

      IF ls_entrega-peso_kg <= 0.
        MESSAGE 'El peso de la entrega debe ser mayor que 0'
          TYPE 'S' DISPLAY LIKE 'E'.
*       Le digo a la SM30 que no grabe nada
        vim_abort_saving = 'X'.
        sy-subrc = 4.
        EXIT.
      ENDIF.

    ENDIF.

  ENDLOOP.

ENDFORM.