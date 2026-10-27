
FUNCTION zfm_kilos_ruta_ab1510.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     REFERENCE(IV_ID_RUTA) TYPE  ZID_RUTA_AB1510
*"  EXPORTING
*"     REFERENCE(EV_KILOS) TYPE  ZPESO_KG_AB1510
*"     REFERENCE(EV_CARGA_MAX) TYPE  ZCARGA_MAX_AB1510
*"     REFERENCE(EV_PORCENTAJE) TYPE  I
*"  EXCEPTIONS
*"      RUTA_NO_EXISTE
*"----------------------------------------------------------------------

  DATA: lo_ruta  TYPE REF TO zcl_rutas_ab1510,
        lo_error TYPE REF TO zcx_rutas_ab1510,
        ls_ruta  TYPE zruta_ab1510.

  TRY.
*     Reutilizo mi clase: ella sabe cargar la ruta y sumar los kilos
      CREATE OBJECT lo_ruta
        EXPORTING
          iv_id_ruta = iv_id_ruta.

      ev_kilos = lo_ruta->get_total_kilos( ).
      ls_ruta  = lo_ruta->get_ruta( ).

*     Leo cuánto aguanta el camión de esta ruta
      SELECT SINGLE carga_max
        FROM zvehiculo_ab1510
        INTO ev_carga_max
        WHERE matricula = ls_ruta-matricula.

*     Porcentaje de ocupación (evito dividir entre 0)
      IF ev_carga_max > 0.
        ev_porcentaje = ev_kilos * 100 / ev_carga_max.
      ENDIF.

    CATCH zcx_rutas_ab1510 INTO lo_error.
*     Quien llame al FM recibirá sy-subrc = 1
      RAISE ruta_no_existe.
  ENDTRY.

ENDFUNCTION.