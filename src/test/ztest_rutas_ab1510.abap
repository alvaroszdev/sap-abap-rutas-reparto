REPORT ztest_rutas_ab1510.

* Pido la ruta y los datos de la entrega que quiero asignar
PARAMETERS: p_ruta TYPE zid_ruta_ab1510   OBLIGATORY,
            p_entr TYPE zid_entrega_ab1510 OBLIGATORY,
            p_peso TYPE zpeso_kg_ab1510    OBLIGATORY.

DATA: go_ruta    TYPE REF TO zcl_rutas_ab1510,
      gs_entrega TYPE zentrega_ab1510,
      go_error   TYPE REF TO zcx_rutas_ab1510.

START-OF-SELECTION.

  TRY.
*     Creo el objeto de la ruta (si no existe, salta al CATCH)
      CREATE OBJECT go_ruta
        EXPORTING
          iv_id_ruta = p_ruta.

      WRITE: / 'Kilos antes:', go_ruta->get_total_kilos( ).

*     Monto la entrega con lo que he metido en pantalla
      gs_entrega-id_entrega = p_entr.
      gs_entrega-peso_kg    = p_peso.
      gs_entrega-direccion  = 'Entrega de prueba'.

*     Intento asignarla (si no cabe, salta al CATCH)
      go_ruta->asignar_entrega( gs_entrega ).

      WRITE: / 'Entrega asignada. Kilos ahora:', go_ruta->get_total_kilos( ).

    CATCH zcx_rutas_ab1510 INTO go_error.
*     Muestro el texto de la excepción que haya saltado
      MESSAGE go_error->get_text( ) TYPE 'I'.
  ENDTRY.REPORT ztest_rutas_ab1510.

* Pido la ruta y los datos de la entrega que quiero asignar
PARAMETERS: p_ruta TYPE zid_ruta_ab1510   OBLIGATORY,
            p_entr TYPE zid_entrega_ab1510 OBLIGATORY,
            p_peso TYPE zpeso_kg_ab1510    OBLIGATORY.

DATA: go_ruta    TYPE REF TO zcl_rutas_ab1510,
      gs_entrega TYPE zentrega_ab1510,
      go_error   TYPE REF TO zcx_rutas_ab1510.

START-OF-SELECTION.

  TRY.
*     Creo el objeto de la ruta (si no existe, salta al CATCH)
      CREATE OBJECT go_ruta
        EXPORTING
          iv_id_ruta = p_ruta.

      WRITE: / 'Kilos antes:', go_ruta->get_total_kilos( ).

*     Monto la entrega con lo que he metido en pantalla
      gs_entrega-id_entrega = p_entr.
      gs_entrega-peso_kg    = p_peso.
      gs_entrega-direccion  = 'Entrega de prueba'.

*     Intento asignarla (si no cabe, salta al CATCH)
      go_ruta->asignar_entrega( gs_entrega ).

      WRITE: / 'Entrega asignada. Kilos ahora:', go_ruta->get_total_kilos( ).

    CATCH zcx_rutas_ab1510 INTO go_error.
*     Muestro el texto de la excepción que haya saltado
      MESSAGE go_error->get_text( ) TYPE 'I'.
  ENDTRY.