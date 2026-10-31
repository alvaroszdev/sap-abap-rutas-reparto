interface ZIF_VALIDAR_ENTREGA_AB1510
  public .

  interfaces IF_BADI_INTERFACE .

* Se ejecuta antes de grabar una entrega nueva en una ruta.
* Si la entrega no cumple la regla, la implementación lanza
* ZCX_RUTAS_AB1510 y la entrega no se graba.
  methods VALIDAR
    importing
      !IS_ENTREGA  type ZENTREGA_AB1510
      !IT_ENTREGAS type ZTT_ENTREGA_AB1510
    raising
      ZCX_RUTAS_AB1510 .

endinterface.