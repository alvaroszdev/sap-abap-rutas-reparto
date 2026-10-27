*&---------------------------------------------------------------------*
*& Include          ZRUTAS_AB1510_CLS
*&---------------------------------------------------------------------*

CLASS lcl_eventos DEFINITION.
  PUBLIC SECTION.
*   Método que se ejecuta cuando el usuario hace doble clic en el ALV
    CLASS-METHODS on_double_click
      FOR EVENT double_click OF cl_salv_events_table
      IMPORTING row column.
ENDCLASS.

CLASS lcl_eventos IMPLEMENTATION.
  METHOD on_double_click.

    DATA: ls_entrega TYPE zentrega_ab1510,
          lv_texto   TYPE string,
          lv_estado  TYPE string.

*   Cojo la fila en la que ha pinchado el usuario
    READ TABLE gt_entregas INTO ls_entrega INDEX row.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

*   Traduzco la X a algo que se entienda
    IF ls_entrega-entregada = 'X'.
      lv_estado = 'ENTREGADA'.
    ELSE.
      lv_estado = 'PENDIENTE'.
    ENDIF.

*   Monto el detalle y lo enseño
    lv_texto = |Entrega { CONV i( ls_entrega-id_entrega ) }: |
            && |{ ls_entrega-direccion } - |
            && |{ ls_entrega-peso_kg NUMBER = USER } kg - { lv_estado }|.

    MESSAGE lv_texto TYPE 'I'.

  ENDMETHOD.
ENDCLASS.