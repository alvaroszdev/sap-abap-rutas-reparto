*----------------------------------------------------------------------*
***INCLUDE LZGF_RUTAS_AB1510F02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form F_VALIDAR_RUTA
*&---------------------------------------------------------------------*
*& Evento 01 de la SM30 de ZRUTA_AB1510: antes de grabar
*&---------------------------------------------------------------------*
FORM f_validar_ruta.

  DATA ls_ruta TYPE zruta_ab1510.

  LOOP AT total.

*   Solo las rutas nuevas: las antiguas pueden tener fecha pasada
    IF <action> = neuer_eintrag.

      ls_ruta = <vim_total_struc>.

      IF ls_ruta-fecha < sy-datum.
        MESSAGE 'La fecha de la ruta no puede ser anterior a hoy'
          TYPE 'S' DISPLAY LIKE 'E'.
        vim_abort_saving = 'X'.
        sy-subrc = 4.
        EXIT.
      ENDIF.

    ENDIF.

  ENDLOOP.

ENDFORM.