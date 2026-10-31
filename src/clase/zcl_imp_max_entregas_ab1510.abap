class ZCL_IMP_MAX_ENTREGAS_AB1510 definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces ZIF_VALIDAR_ENTREGA_AB1510 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IMP_MAX_ENTREGAS_AB1510 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IMP_MAX_ENTREGAS_AB1510->ZIF_VALIDAR_ENTREGA_AB1510~VALIDAR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_ENTREGA                     TYPE        ZENTREGA_AB1510
* | [--->] IT_ENTREGAS                    TYPE        ZTT_ENTREGA_AB1510
* | [!CX!] ZCX_RUTAS_AB1510
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_validar_entrega_ab1510~validar.

*   Regla de esta empresa: como mucho 5 entregas por ruta
    CONSTANTS lc_max_entregas TYPE i VALUE 5.

*   it_entregas son las que la ruta ya tiene; si ya hay 5, no cabe otra
    IF lines( it_entregas ) >= lc_max_entregas.
      RAISE EXCEPTION TYPE zcx_rutas_ab1510
        EXPORTING
          textid = zcx_rutas_ab1510=>max_entregas.
    ENDIF.

  ENDMETHOD.
ENDCLASS.