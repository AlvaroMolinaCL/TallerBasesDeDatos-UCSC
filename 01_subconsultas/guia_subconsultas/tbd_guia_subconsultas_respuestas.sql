/* Ejercicios Guía Subconsultas - Taller de Bases de Datos (IN1078C) */

/*
 * a) Listar todos los repuestos (cod_repuesto, nombre_repuesto, valor_repuesto, stock_repuesto)
 * que tienen un stock menor al stock promedio de todos los repuestos.
 */

SELECT *
FROM repuesto
WHERE stock_repuesto < (SELECT AVG(stock_repuesto)
						FROM repuesto);

/*
 * b) Listar todos los repuestos (cod_repuesto, nombre_repuesto, valor_repuesto, stock_repuesto)
 * que tienen un valor mayor al valor promedio de todos los repuestos.
 */

SELECT *
FROM repuesto
WHERE valor_repuesto > (SELECT AVG(valor_repuesto)
						FROM repuesto);

/*
 * c) Listar todas las órdenes de mantenimiento (cod_orden, fecha_orden, id_empresa, rut,
 * valor_total) que tienen un valor total menor al valor promedio de todas las órdenes.
 */

SELECT *
FROM orden_mantenimiento
WHERE valor_total < (SELECT AVG(valor_total)
					 FROM orden_mantenimiento);

/*
 * d) Seleccione los datos de la o las empresas (id_empresa, nombre_empresa, cantidad de órdenes)
 * que han solicitado la mayor cantidad de órdenes de mantenimiento.
 */

SELECT *
FROM (SELECT e.*, COUNT(om.cod_orden) AS cantidad_ordenes
	  FROM orden_mantenimiento om, empresa e
	  WHERE om.id_empresa = e.id_empresa
	  GROUP BY e.id_empresa) AS emp
WHERE emp.cantidad_ordenes = (SELECT MAX(cantidad_ordenes)
							  FROM (SELECT e.*, COUNT(om.cod_orden) AS cantidad_ordenes
	  								FROM orden_mantenimiento om, empresa e
	  								WHERE om.id_empresa = e.id_empresa
	  								GROUP BY e.id_empresa) AS emp);

/*
 * e) Seleccione los datos de la o las órdenes de mantenimiento (cod_orden, fecha_orden, cantidad
 * de repuestos) que han utilizado una mayor cantidad de repuestos.
 */

SELECT *
FROM (SELECT ro.cod_orden, om.fecha_orden, SUM(ro.cantidad_repuesto) AS cantidad_repuestos
	  FROM repuesto_orden ro, orden_mantenimiento om
	  WHERE ro.cod_orden = om.cod_orden
	  GROUP BY om.cod_orden, ro.cod_orden) AS ord
WHERE ord.cantidad_repuestos = (SELECT MAX(cantidad_repuestos)
								FROM (SELECT ro.cod_orden, om.fecha_orden,
									  SUM(ro.cantidad_repuesto) AS cantidad_repuestos
	  								  FROM repuesto_orden ro, orden_mantenimiento om
	  							      WHERE ro.cod_orden = om.cod_orden
	  							      GROUP BY om.cod_orden, ro.cod_orden) AS ord);

/*
 * f) Seleccione los datos del o los supervisores (rut, nombre_supervisor, cantidad de órdenes)
 * que han supervisado la menor cantidad de órdenes de mantenimiento.
 */

SELECT *
FROM (SELECT s.*, COUNT(om.rut) AS cantidad_ordenes
	  FROM supervisor s, orden_mantenimiento om
	  WHERE s.rut = om.rut
	  GROUP BY s.rut) AS sup
WHERE sup.cantidad_ordenes = (SELECT MIN(cantidad_ordenes)
							  FROM (SELECT s.*, COUNT(om.rut) AS cantidad_ordenes
									FROM supervisor s, orden_mantenimiento om
									WHERE s.rut = om.rut
									GROUP BY s.rut) AS sup);