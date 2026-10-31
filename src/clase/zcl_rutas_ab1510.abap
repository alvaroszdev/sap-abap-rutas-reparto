CLASS zcl_rutas_ab1510 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !iv_id_ruta TYPE zid_ruta_ab1510
      RAISING
        zcx_rutas_ab1510 .
    METHODS get_total_kilos
      RETURNING
        VALUE(rv_kilos) TYPE zpeso_kg_ab1510 .
    METHODS asignar_entrega
      IMPORTING
        !is_entrega TYPE zentrega_ab1510
      RAISING
        zcx_rutas_ab1510 .
    METHODS get_ruta
      RETURNING
        VALUE(rs_ruta) TYPE zruta_ab1510 .
    METHODS get_entregas
      RETURNING
        VALUE(rt_entregas) TYPE ztt_entrega_ab1510 .
    METHODS marcar_entregada
      IMPORTING
        !iv_id_entrega TYPE zid_entrega_ab1510
      RAISING
        zcx_rutas_ab1510 .
    CLASS-METHODS crear_ruta
      IMPORTING
        !is_ruta       TYPE zruta_ab1510
      RETURNING
        VALUE(ro_ruta) TYPE REF TO zcl_rutas_ab1510
      RAISING
        zcx_rutas_ab1510 .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA gs_ruta TYPE zruta_ab1510 .
    DATA gs_vehiculo TYPE zvehiculo_ab1510 .
ENDCLASS.



CLASS ZCL_RUTAS_AB1510 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RUTAS_AB1510->ASIGNAR_ENTREGA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_ENTREGA                     TYPE        ZENTREGA_AB1510
* | [!CX!] ZCX_RUTAS_AB1510
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD asignar_entrega.

    DATA: lv_total    TYPE zpeso_kg_ab1510,
          ls_entrega  TYPE zentrega_ab1510,
          lt_entregas TYPE ztt_entrega_ab1510,                  " <-- NUEVO
          lo_badi     TYPE REF TO zbadi_validar_entrega_ab1510.

*   Una entrega sin peso o con peso negativo no tiene sentido
    IF is_entrega-peso_kg <= 0.
      RAISE EXCEPTION TYPE zcx_rutas_ab1510
        EXPORTING
          textid = zcx_rutas_ab1510=>peso_incorrecto.
    ENDIF.

*   Si el número ya existe (en esta ruta o en otra), no la piso
    SELECT SINGLE id_entrega
      FROM zentrega_ab1510
      INTO @DATA(lv_existe)
      WHERE id_entrega = @is_entrega-id_entrega.

    IF sy-subrc = 0.
      RAISE EXCEPTION TYPE zcx_rutas_ab1510
        EXPORTING
          textid = zcx_rutas_ab1510=>entrega_ya_existe.
    ENDIF.

*   NUEVO: dejo que las implementaciones de la BAdI añadan sus reglas.
*   Si alguna no se cumple, lanza ZCX y la entrega no se graba.
    lt_entregas = get_entregas( ).
    GET BADI lo_badi.

    CALL BADI lo_badi->validar
      EXPORTING
        is_entrega  = is_entrega
        it_entregas = lt_entregas.

*   Calculo cuántos kilos llevaría el camión con esta entrega
    lv_total = get_total_kilos( ) + is_entrega-peso_kg.

*   Si se pasa de lo que aguanta el camión, no la meto
    IF lv_total > gs_vehiculo-carga_max.
      RAISE EXCEPTION TYPE zcx_rutas_ab1510
        EXPORTING
          textid = zcx_rutas_ab1510=>sobrecarga.
    ENDIF.

*   Copio la entrega y le pongo mi ruta
    ls_entrega = is_entrega.
    ls_entrega-id_ruta = gs_ruta-id_ruta.

*   Ahora solo inserto: las entregas existentes no se tocan desde aquí
    INSERT zentrega_ab1510 FROM ls_entrega.

    IF sy-subrc = 0.
      COMMIT WORK AND WAIT.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RUTAS_AB1510->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID_RUTA                     TYPE        ZID_RUTA_AB1510
* | [!CX!] ZCX_RUTAS_AB1510
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.



*   Leo la ruta que me piden
    SELECT SINGLE *
      FROM zruta_ab1510
      INTO gs_ruta
      WHERE id_ruta = iv_id_ruta.

*   Si no la encuentro, no tiene sentido crear el objeto
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_rutas_ab1510
        EXPORTING
          textid = zcx_rutas_ab1510=>ruta_no_existe.
    ENDIF.

*   Leo el camión que lleva esta ruta para saber su carga máxima
    SELECT SINGLE *
      FROM zvehiculo_ab1510
      INTO gs_vehiculo
      WHERE matricula = gs_ruta-matricula.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_RUTAS_AB1510=>CREAR_RUTA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_RUTA                        TYPE        ZRUTA_AB1510
* | [<-()] RO_RUTA                        TYPE REF TO ZCL_RUTAS_AB1510
* | [!CX!] ZCX_RUTAS_AB1510
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD crear_ruta.

    DATA: ls_ruta   TYPE zruta_ab1510,
          lv_numero TYPE zid_ruta_ab1510.

*   No dejo planificar rutas en el pasado
    IF is_ruta-fecha < sy-datum.
      RAISE EXCEPTION TYPE zcx_rutas_ab1510
        EXPORTING
          textid = zcx_rutas_ab1510=>fecha_pasada.
    ENDIF.

*   Pido el siguiente número libre al rango de la SNRO
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'ZRUTAB1510'
      IMPORTING
        number                  = lv_numero
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_rutas_ab1510
        EXPORTING
          textid = zcx_rutas_ab1510=>error_crear.
    ENDIF.

*   Monto la ruta: número nuevo y siempre empieza planificada
    ls_ruta         = is_ruta.
    ls_ruta-id_ruta = lv_numero.
    ls_ruta-estado  = 'P'.

    INSERT zruta_ab1510 FROM ls_ruta.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_rutas_ab1510
        EXPORTING
          textid = zcx_rutas_ab1510=>error_crear.
    ENDIF.

    COMMIT WORK AND WAIT.

*   Devuelvo ya el objeto de la ruta creada, listo para usar
    CREATE OBJECT ro_ruta
      EXPORTING
        iv_id_ruta = lv_numero.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RUTAS_AB1510->GET_ENTREGAS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_ENTREGAS                    TYPE        ZTT_ENTREGA_AB1510
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_entregas.
*   Leo todas las entregas que pertenecen a esta ruta, ordenadas
    SELECT *
      FROM zentrega_ab1510
      INTO TABLE rt_entregas
      WHERE id_ruta = gs_ruta-id_ruta
      ORDER BY id_entrega.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RUTAS_AB1510->GET_RUTA
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_RUTA                        TYPE        ZRUTA_AB1510
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ruta.
*   Devuelvo los datos de la ruta que cargué en el constructor
    rs_ruta = gs_ruta.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RUTAS_AB1510->GET_TOTAL_KILOS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_KILOS                       TYPE        ZPESO_KG_AB1510
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_total_kilos.

*   Sumo el peso de todas las entregas que tiene esta ruta
    SELECT SUM( peso_kg )
      FROM zentrega_ab1510
      INTO rv_kilos
      WHERE id_ruta = gs_ruta-id_ruta.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_RUTAS_AB1510->MARCAR_ENTREGADA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ID_ENTREGA                  TYPE        ZID_ENTREGA_AB1510
* | [!CX!] ZCX_RUTAS_AB1510
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD marcar_entregada.

    DATA ls_entrega TYPE zentrega_ab1510.

*   Primero compruebo que la entrega existe y es de esta ruta
    SELECT SINGLE *
      FROM zentrega_ab1510
      INTO ls_entrega
      WHERE id_entrega = iv_id_entrega
        AND id_ruta    = gs_ruta-id_ruta.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_rutas_ab1510
        EXPORTING
          textid = zcx_rutas_ab1510=>entrega_no_existe.
    ENDIF.

*   Si ya estaba entregada no hace falta tocar nada
    IF ls_entrega-entregada = 'X'.
      RETURN.
    ENDIF.

*   Ahora sí, la marco como entregada
    UPDATE zentrega_ab1510
      SET entregada = 'X'
      WHERE id_entrega = iv_id_entrega
        AND id_ruta    = gs_ruta-id_ruta.

    IF sy-subrc = 0.
      COMMIT WORK AND WAIT.
    ENDIF.

  ENDMETHOD.
ENDCLASS.