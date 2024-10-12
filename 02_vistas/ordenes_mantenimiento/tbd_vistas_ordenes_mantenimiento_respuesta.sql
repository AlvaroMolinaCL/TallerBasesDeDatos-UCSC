/* Ejercicio Vistas: Base de Datos "Ordenes Mantenimiento" */
/* Taller de Bases de Datos (IN1078C) */

/*
 * 1. Seleccione los datos de la o las órdenes de mantenimiento (cod_orden, 
 * fecha_orden, cantidad de repuestos) que han utilizado una mayor cantidad de 
 * repuestos.
 */

-- Sin uso de vista
SELECT cod_orden, fecha_orden, SUM(cantidad_repuesto)
FROM repuesto_orden JOIN orden_mantenimiento USING(cod_orden)
GROUP BY cod_orden, fecha_orden
HAVING SUM(cantidad_repuesto) = (SELECT MAX(cantidad_orden.cantidad)
                                 FROM (SELECT SUM(cantidad_repuesto) AS cantidad
                                       FROM repuesto_orden
                                       GROUP BY cod_orden) AS cantidad_orden);

-- Con uso de vista
CREATE OR REPLACE VIEW cantidad_repuestos_orden
AS (SELECT orden_mantenimiento.cod_orden, fecha_orden, SUM(cantidad_repuesto) AS cantidad 
    FROM orden_mantenimiento JOIN repuesto_orden USING(cod_orden)
    GROUP BY orden_mantenimiento.cod_orden);

-- Ejemplo de uso de vista creada anteriormente
SELECT cod_orden, fecha_orden, cantidad
FROM cantidad_repuestos_orden
WHERE cantidad = (SELECT MAX(cantidad) FROM cantidad_repuestos_orden);