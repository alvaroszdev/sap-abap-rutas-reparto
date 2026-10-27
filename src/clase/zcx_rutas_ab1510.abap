class ZCX_RUTAS_AB1510 definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  constants ZCX_RUTAS_AB1510 type SOTR_CONC value '000C2952AA851FD1B48A12750819D7A6' ##NO_TEXT.
  constants SOBRECARGA type SOTR_CONC value '000C2952AA851FD1B48A129A0C0137A6' ##NO_TEXT.
  constants RUTA_NO_EXISTE type SOTR_CONC value '000C2952AA851FD1B48A129A0C0157A6' ##NO_TEXT.
  constants ENTREGA_NO_EXISTE type SOTR_CONC value '000C2952AA851FE1B4B08A642CDE85D4' ##NO_TEXT.
  constants ERROR_CREAR type SOTR_CONC value '000C2952AA851FE1B4B1852E5E968652' ##NO_TEXT.
  constants PESO_INCORRECTO type SOTR_CONC value '000C2952AA851FE1B4C8CE4B4376CE60' ##NO_TEXT.
  constants FECHA_PASADA type SOTR_CONC value '000C2952AA851FE1B4C8CE4B4376EE60' ##NO_TEXT.
  constants ENTREGA_YA_EXISTE type SOTR_CONC value '000C2952AA851FE1B4C8F053CC1A0E73' ##NO_TEXT.

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional .

*----------------------------------------------------------------------*
* Textos de la excepción (pestaña Txt. de la SE24)
*----------------------------------------------------------------------*
* SOBRECARGA         La carga supera la capacidad del vehículo
* RUTA_NO_EXISTE     La ruta indicada no existe
* ENTREGA_NO_EXISTE  La entrega no pertenece a esta ruta
* ERROR_CREAR        No se ha podido crear la ruta
* PESO_INCORRECTO    El peso de la entrega debe ser mayor que 0
* FECHA_PASADA       La fecha de la ruta no puede ser anterior a hoy
* ENTREGA_YA_EXISTE  Ya existe una entrega con ese número.