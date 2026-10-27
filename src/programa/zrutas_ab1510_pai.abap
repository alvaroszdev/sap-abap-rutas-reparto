*&---------------------------------------------------------------------*
*& Include          ZRUTAS_AB1510_PAI
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Dynpro 9000 - Gestión de la ruta
*----------------------------------------------------------------------*
MODULE m_user_command_9000 INPUT.

* Copio el código del botón y limpio ok_code para la siguiente vez
  gv_okcode = ok_code.
  CLEAR ok_code.

  CASE gv_okcode.

    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.

    WHEN 'VER'.
*     Cargo la ruta que ha escrito el usuario
      TRY.
          CREATE OBJECT go_ruta
            EXPORTING
              iv_id_ruta = zruta_ab1510-id_ruta.

*         Relleno la cabecera de la pantalla y las entregas del ALV
          zruta_ab1510 = go_ruta->get_ruta( ).
          gt_entregas  = go_ruta->get_entregas( ).

        CATCH zcx_rutas_ab1510 INTO go_error.
*         Si la ruta no existe, limpio lo que hubiera de antes
          CLEAR: go_ruta, gt_entregas.
          MESSAGE go_error->get_text( ) TYPE 'I'.
      ENDTRY.

    WHEN 'REFRESCAR'.
*     Vuelvo a leer las entregas por si han cambiado
      IF go_ruta IS BOUND.
        gt_entregas = go_ruta->get_entregas( ).
      ENDIF.

    WHEN 'ASIGNAR'.
*     Sin ruta cargada no puedo asignar nada
      IF go_ruta IS NOT BOUND.
        MESSAGE 'Primero carga una ruta con Ver ruta' TYPE 'I'.
      ELSE.
*       Limpio la ventana para que salga vacía y la abro como popup
        CLEAR zentrega_ab1510.
        CALL SCREEN 9001 STARTING AT 10 5.
      ENDIF.

    WHEN 'ENTREGADA'.
*     Igual que asignar: necesito una ruta cargada
      IF go_ruta IS NOT BOUND.
        MESSAGE 'Primero carga una ruta con Ver ruta' TYPE 'I'.
      ELSE.
        CLEAR gv_entrega.
        CALL SCREEN 9002 STARTING AT 10 5.
      ENDIF.

    WHEN 'NUEVA'.
*     Solo el jefe de logística puede crear rutas:
*     compruebo si tiene autorización para su transacción
      AUTHORITY-CHECK OBJECT 'S_TCODE'
        ID 'TCD' FIELD 'ZRUTAS_JEFE_AB1510'.

      IF sy-subrc <> 0.
        MESSAGE 'Solo el jefe de logística puede crear rutas' TYPE 'I'.
      ELSE.
*       Vacío la cabecera para que la ventana salga limpia
        CLEAR zruta_ab1510.
        CALL SCREEN 9003 STARTING AT 10 5.
      ENDIF.
  ENDCASE.

ENDMODULE.

*----------------------------------------------------------------------*
* Dynpro 9001 - Asignar entrega
*----------------------------------------------------------------------*
MODULE m_exit_9001 INPUT.
* Cancelar: cierro la ventana sin comprobar nada
  CLEAR ok_code.
  LEAVE TO SCREEN 0.
ENDMODULE.

MODULE m_user_command_9001 INPUT.

  gv_okcode = ok_code.
  CLEAR ok_code.

  CASE gv_okcode.

    WHEN 'ACEPTAR'.
      TRY.
*         Le paso a la clase la entrega que ha escrito el usuario
          go_ruta->asignar_entrega( zentrega_ab1510 ).

*         Si llega aquí es que cabía: recargo el ALV y cierro la ventana
          gt_entregas = go_ruta->get_entregas( ).
          MESSAGE 'Entrega asignada a la ruta' TYPE 'S'.
          LEAVE TO SCREEN 0.

        CATCH zcx_rutas_ab1510 INTO go_error.
*         No cabe en el camión: aviso y dejo la ventana abierta
          MESSAGE go_error->get_text( ) TYPE 'I'.
      ENDTRY.

  ENDCASE.

ENDMODULE.

*----------------------------------------------------------------------*
* Dynpro 9002 - Marcar entrega como entregada
*----------------------------------------------------------------------*
MODULE m_exit_9002 INPUT.
* Cancelar: cierro la ventana sin comprobar nada
  CLEAR ok_code.
  LEAVE TO SCREEN 0.
ENDMODULE.

MODULE m_user_command_9002 INPUT.

  gv_okcode = ok_code.
  CLEAR ok_code.

  CASE gv_okcode.

    WHEN 'ACEPTAR'.
      TRY.
*         Le pido a la clase que marque la entrega
          go_ruta->marcar_entregada( gv_entrega ).

*         Ha ido bien: recargo el ALV y cierro la ventana
          gt_entregas = go_ruta->get_entregas( ).
          MESSAGE 'Entrega marcada como entregada' TYPE 'S'.
          LEAVE TO SCREEN 0.

        CATCH zcx_rutas_ab1510 INTO go_error.
*         No es de esta ruta: aviso y dejo la ventana abierta
          MESSAGE go_error->get_text( ) TYPE 'I'.
      ENDTRY.

  ENDCASE.

ENDMODULE.

*----------------------------------------------------------------------*
* Dynpro 9003 - Nueva ruta
*----------------------------------------------------------------------*
MODULE m_exit_9003 INPUT.
  CLEAR ok_code.
* Si cancelo, vuelvo a poner en pantalla la ruta que tenía cargada
  IF go_ruta IS BOUND.
    zruta_ab1510 = go_ruta->get_ruta( ).
  ENDIF.
  LEAVE TO SCREEN 0.
ENDMODULE.

MODULE m_user_command_9003 INPUT.

  gv_okcode = ok_code.
  CLEAR ok_code.

  CASE gv_okcode.

    WHEN 'ACEPTAR'.
      TRY.
*         La clase pide el número, graba la ruta y me devuelve su objeto
          go_ruta = zcl_rutas_ab1510=>crear_ruta( zruta_ab1510 ).

*         Cargo en pantalla la ruta nueva (todavía sin entregas)
          zruta_ab1510 = go_ruta->get_ruta( ).
          gt_entregas  = go_ruta->get_entregas( ).

          MESSAGE |Ruta { CONV i( zruta_ab1510-id_ruta ) } creada| TYPE 'S'.
          LEAVE TO SCREEN 0.

        CATCH zcx_rutas_ab1510 INTO go_error.
          MESSAGE go_error->get_text( ) TYPE 'I'.
      ENDTRY.

  ENDCASE.

ENDMODULE.