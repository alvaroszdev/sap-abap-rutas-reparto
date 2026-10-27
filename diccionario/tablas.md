# Diccionario de datos

## Tablas

### ZVEHICULO_AB1510 — Camiones y furgonetas
Clase de entrega A · Clase de datos APPL0 (maestro)

| Campo | Clave | Elemento de datos | Tipo |
|---|---|---|---|
| MANDT | ✔ | MANDT | CLNT 3 |
| MATRICULA | ✔ | ZMATRICULA_AB1510 | CHAR 10 |
| MODELO | | ZMODELO_AB1510 | CHAR 40 |
| CARGA_MAX | | ZCARGA_MAX_AB1510 | DEC 10,2 |

### ZRUTA_AB1510 — Rutas
Clase de entrega A · Clase de datos APPL1 (movimiento)

| Campo | Clave | Elemento de datos | Tipo |
|---|---|---|---|
| MANDT | ✔ | MANDT | CLNT 3 |
| ID_RUTA | ✔ | ZID_RUTA_AB1510 | NUMC 10 |
| FECHA | | DATUM | DATS 8 |
| REPARTIDOR | | ZREPARTIDOR_AB1510 | CHAR 30 |
| MATRICULA | | ZMATRICULA_AB1510 | CHAR 10 |
| ESTADO | | ZESTADO_AB1510 | CHAR 1 |

### ZENTREGA_AB1510 — Entregas (paradas de la ruta)
Clase de entrega A · Clase de datos APPL1 (movimiento)

| Campo | Clave | Elemento de datos | Tipo |
|---|---|---|---|
| MANDT | ✔ | MANDT | CLNT 3 |
| ID_ENTREGA | ✔ | ZID_ENTREGA_AB1510 | NUMC 10 |
| ID_RUTA | | ZID_RUTA_AB1510 | NUMC 10 |
| CLIENTE | | KUNNR | CHAR 10 |
| DIRECCION | | ZDIRECCION_AB1510 | CHAR 60 |
| PESO_KG | | ZPESO_KG_AB1510 | DEC 10,2 |
| ENTREGADA | | XFELD | CHAR 1 |

## Claves externas

| Tabla | Campo | Tabla de verificación | Cardinalidad |
|---|---|---|---|
| ZRUTA_AB1510 | MATRICULA | ZVEHICULO_AB1510 | 1 : CN |
| ZENTREGA_AB1510 | ID_RUTA | ZRUTA_AB1510 | 1 : CN |