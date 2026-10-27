*&---------------------------------------------------------------------*
*& Include          ZRUTAS_AB1510_TOP
*&---------------------------------------------------------------------*
*& Datos globales
*&---------------------------------------------------------------------*

* Tablas para poder usar sus campos directamente en las dynpros
TABLES: zruta_ab1510,       " Cabecera de la ruta en la 9000
        zentrega_ab1510.    " Datos de la entrega en la 9001

* Código de función de las pantallas
DATA: ok_code   TYPE sy-ucomm,
      gv_okcode TYPE sy-ucomm.

* Mi clase de rutas y su excepción
DATA: go_ruta  TYPE REF TO zcl_rutas_ab1510,
      go_error TYPE REF TO zcx_rutas_ab1510.

* ALV de entregas dentro del Custom Control CC1
DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv       TYPE REF TO cl_salv_table,
      gt_entregas  TYPE STANDARD TABLE OF zentrega_ab1510.

* Entrega que quiero marcar como entregada (dynpro 9002)
DATA: gv_entrega TYPE zid_entrega_ab1510.