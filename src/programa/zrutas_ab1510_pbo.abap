*&---------------------------------------------------------------------*
*& Include          ZRUTAS_AB1510_PBO
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Dynpro 9000 - Gestión de la ruta
*----------------------------------------------------------------------*
MODULE m_status_9000 OUTPUT.
* Pongo la barra de botones y el título de la pantalla
  SET PF-STATUS 'STATUS_9000'.
  SET TITLEBAR 'TITLE_9000'.
ENDMODULE.

MODULE m_alv_9000 OUTPUT.

  DATA: lo_columns TYPE REF TO cl_salv_columns_table,
        lo_column  TYPE REF TO cl_salv_column,
        lo_events  TYPE REF TO cl_salv_events_table.     " <-- NUEVO

* La primera vez creo el contenedor y el ALV
  IF go_container IS NOT BOUND.

    CREATE OBJECT go_container
      EXPORTING
        container_name = 'CC1'.

    TRY.
        cl_salv_table=>factory(
          EXPORTING
            r_container  = go_container
          IMPORTING
            r_salv_table = go_alv
          CHANGING
            t_table      = gt_entregas ).

*       Activo todos los botones del ALV
        go_alv->get_functions( )->set_all( 'X' ).

*       Ajusto el ancho de las columnas y oculto el mandante
        lo_columns = go_alv->get_columns( ).
        lo_columns->set_optimize( 'X' ).

        lo_column = lo_columns->get_column( 'MANDT' ).
        lo_column->set_visible( abap_false ).

*       XFELD no trae textos, así que le pongo yo el título a la columna
        lo_column = lo_columns->get_column( 'ENTREGADA' ).
        lo_column->set_short_text( 'Entregada' ).
        lo_column->set_medium_text( 'Entregada' ).
        lo_column->set_long_text( 'Entregada' ).

*       NUEVO: le digo al ALV que avise a mi clase cuando hagan doble clic
        lo_events = go_alv->get_event( ).
        SET HANDLER lcl_eventos=>on_double_click FOR lo_events.

        go_alv->display( ).

      CATCH cx_salv_msg cx_salv_not_found.
        MESSAGE 'Error al crear el ALV' TYPE 'I'.
    ENDTRY.

  ELSE.
*   Refresco completo: vuelve a calcular el ancho de las columnas
*   con los datos nuevos, no solo los valores
    go_alv->refresh( refresh_mode = if_salv_c_refresh=>full ).
  ENDIF.

ENDMODULE.

*----------------------------------------------------------------------*
* Dynpro 9001 - Asignar entrega
*----------------------------------------------------------------------*
MODULE m_status_9001 OUTPUT.
* Botones y título de la ventana de asignar entrega
  SET PF-STATUS 'STATUS_9001'.
  SET TITLEBAR 'TITLE_9001'.
ENDMODULE.

*----------------------------------------------------------------------*
* Dynpro 9002 - Marcar entrega como entregada
*----------------------------------------------------------------------*
MODULE m_status_9002 OUTPUT.
* Reutilizo los botones de la 9001 (Aceptar / Cancelar)
  SET PF-STATUS 'STATUS_9001'.
  SET TITLEBAR 'TITLE_9002'.
ENDMODULE.
*----------------------------------------------------------------------*
* Dynpro 9003 - Nueva ruta
*----------------------------------------------------------------------*
MODULE m_status_9003 OUTPUT.
* Reutilizo los botones Aceptar / Cancelar de la 9001
  SET PF-STATUS 'STATUS_9001'.
  SET TITLEBAR 'TITLE_9003'.
ENDMODULE.