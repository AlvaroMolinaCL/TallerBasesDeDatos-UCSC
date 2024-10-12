/* Test 1 (2023) | Taller de Bases de Datos (IN1078C) */

-- PREGUNTA 1 --

/*
 * 1. Seleccione los datos de todos los predios con la superficie total de bosques de pino que
 * posee. Debe aparecer cod_predio, nombre_predio, superficie_pino. Deben aparecer todos los
 * predios ordenados de forma ascendente por nombre del predio.
 */

SELECT p.cod_predio, p.nombre_predio, (SELECT SUM(b.superficie_bosque)
								   	   FROM bosque b
								   	   WHERE b.cod_predio = p.cod_predio
								   	   AND b.especie_bosque = 'pino') AS superficie_pino
FROM predio p
ORDER BY nombre_predio;

/*
 * 2. Seleccione los datos de todos los predios con la cantidad total de instalaciones de tipo
 * bodega que tiene. Debe aparecer cod_predio, nombre_predio, cantidad_bodega. Deben aparecer
 * todos los predios ordenados de forma descendente por nombre del predio.
 */

SELECT p.cod_predio, p.nombre_predio, (SELECT COUNT(i.cod_instalacion)
								       FROM instalacion i
								       WHERE i.cod_predio = p.cod_predio
								       AND i.tipo_instalacion = 'bodega') AS cantidad_bodega
FROM predio p
ORDER BY p.nombre_predio DESC;

/*
 * 3. Seleccione los datos de todos los contratistas con la cantidad total de faenas de tipo
 * cosecha que ha realizado. Debe aparecer rut_contratista, nombre_contratista, cantidad_cosecha.
 * Deben aparecer todos los contratistas ordenados de forma descendente por su nombre.
 */

SELECT c.rut_contratista, c.nombre_contratista,
	  (SELECT COUNT(f.id_faena)
	   FROM faena f
	   WHERE f.rut_contratista = c.rut_contratista
	   AND f.tipo_faena = 'cosecha') AS cantidad_cosecha
FROM contratista c
ORDER BY nombre_contratista DESC;

/*
 * 4. Seleccione los datos de todos los contratistas con la superficie total de faenas de tipo
 * plantacion que ha realizado. Debe aparecer rut_contratista, nombre_contratista,
 * superficie_plantacion. Deben aparecer todos los contratistas ordenados de forma ascendente
 * por su nombre.
 */

SELECT c.rut_contratista, c.nombre_contratista, 
       (SELECT COALESCE(SUM(f.superficie_faena), 0)
		FROM faena f
		WHERE f.rut_contratista = c.rut_contratista
		AND tipo_faena = 'plantacion') AS superficie_plantacion
FROM contratista c
ORDER BY c.nombre_contratista ASC;

-- PREGUNTA 2 --

/*
 * 5. Seleccione los datos del o los bosques que han tenido una cantidad de incendios igual a la
 * mayor cantidad incendios que tienen los bosques. Debe aparecer cod_bosque, cod_predio,
 * nombre_predio, cantidad_incendios, total de superficie de desastre por incendio en el bosque.
 */

SELECT b.cod_bosque, p.cod_predio, p.nombre_predio, COUNT(d.id_desastre) AS cantidad_incendios,
	   SUM(db.superficie_desastre_bosque) AS total_sup_desastre_bosque
FROM predio p JOIN bosque b USING(cod_predio) JOIN desastre_bosque db USING(cod_bosque)
	 JOIN desastre d USING(id_desastre)
WHERE d.tipo_desastre = 'incendio'
GROUP BY b.cod_bosque, p.cod_predio
HAVING COUNT(d.id_desastre) = (SELECT MAX(cantidad_incendios)
							   FROM (SELECT db.cod_bosque,
								     COUNT(d.id_desastre) AS cantidad_incendios
									 FROM desastre_bosque db JOIN desastre d USING(id_desastre)
									 WHERE d.tipo_desastre = 'incendio'
									 GROUP BY db.cod_bosque) AS cantidad_incendios_bosque);

/*
 * 6. Seleccione los datos del o los bosques que han tenido una cantidad de plagas igual a la
 * mayor cantidad plagas que tienen los bosques. Debe aparecer cod_bosque, cod_predio,
 * nombre_predio, cantidad_plagas, total de superficie de desastre por plaga en el bosque.
 */

SELECT b.cod_bosque, p.cod_predio, p.nombre_predio, COUNT(d.id_desastre) AS cantidad,
	   SUM(db.superficie_desastre_bosque) AS total_sup_plaga
FROM predio p JOIN bosque b USING(cod_predio) JOIN desastre_bosque db USING(cod_bosque)
	 JOIN desastre d USING(id_desastre)
WHERE d.tipo_desastre ='plaga'
GROUP BY b.cod_bosque, p.cod_predio
HAVING COUNT(d.id_desastre) = (SELECT MAX(cantidad)
							   FROM (SELECT db.cod_bosque, COUNT(d.id_desastre) AS cantidad
								     FROM desastre_bosque db JOIN desastre d USING(id_desastre)
								     WHERE d.tipo_desastre = 'plaga'
								     GROUP BY db.cod_bosque) AS cantidad_plaga);

/*
 * 7. Seleccione los datos del o los bosques que han tenido una cantidad de plagas mayor o igual
 * al promedio de plagas que tienen los bosques. Debe aparecer cod_bosque, cod_predio,
 * nombre_predio, cantidad_plagas, total de superficie de desastre por plaga en el bosque.
 */

SELECT cod_bosque, cod_predio, nombre_predio, COUNT(id_desastre) AS cantidad,
	   SUM(superficie_desastre_bosque) AS total_sup_plaga
FROM predio JOIN bosque USING(cod_predio) JOIN desastre_bosque USING(cod_bosque)
	 JOIN desastre USING(id_desastre)
WHERE tipo_desastre = 'plaga'
GROUP BY cod_bosque, cod_predio
HAVING COUNT(id_desastre) >= (SELECT AVG(cantidad)
							  FROM (SELECT cod_bosque, COUNT(id_desastre) AS cantidad
									FROM desastre_bosque JOIN desastre USING(id_desastre)
									WHERE tipo_desastre = 'plaga'
									GROUP BY cod_bosque) AS cantidad_plaga);

/*
 * 8. Seleccione los datos del o los bosques que han tenido una cantidad de incendios menor al
 * promedio de incendios que tienen los bosques. Debe aparecer cod_bosque, cod_predio,
 * nombre_predio, cantidad_incendios, total de superficie de desastre por incendio en el bosque.
 */

SELECT cod_bosque, cod_predio, nombre_predio, COUNT(id_desastre) AS cantidad,
	   SUM(superficie_desastre_bosque) AS total_sup_incendio
FROM predio JOIN bosque USING(cod_predio) JOIN desastre_bosque USING(cod_bosque)
	 JOIN desastre USING(id_desastre)
WHERE tipo_desastre = 'incendio'
GROUP BY cod_bosque, cod_predio
HAVING COUNT(id_desastre) < (SELECT AVG(cantidad)
							 FROM (SELECT cod_bosque, COUNT(id_desastre) AS cantidad
								   FROM desastre_bosque JOIN desastre USING(id_desastre)
								   WHERE tipo_desastre = 'incendio'
							 	   GROUP BY cod_bosque) AS cantidad_incendio);

-- PREGUNTA 3 --

/*
 * 9. Seleccione para cada forestal la cantidad total de predios que tienen bosques de pino y no
 * tienen bosque de eucaliptus. Debe aparecer cod_forestal, nombre, cantidad predios. Deben
 * aparecer todas las forestales.
 */

SELECT f.cod_forestal, f.nombre, COUNT(p.cod_predio) AS cantidad_predios
FROM forestal f LEFT JOIN predio p USING(cod_forestal)
WHERE p.cod_predio IN(SELECT b.cod_predio
					  FROM bosque b
					  WHERE b.especie_bosque = 'pino')
AND p.cod_predio NOT IN(SELECT b.cod_predio
						FROM bosque b
						WHERE b.especie_bosque = 'eucaliptus')
GROUP BY f.cod_forestal;

/*
 * 10. Seleccione para cada forestal la cantidad total de predios que tienen instalaciones de
 * patio acopio y no tienen bosque de pino. Debe aparecer cod_forestal, nombre, cantidad predios.
 * Deben aparecer todas las forestales.
 */

SELECT cod_forestal, nombre, COUNT(cod_predio) AS cantidad_predios
FROM forestal LEFT JOIN (SELECT cod_predio, cod_forestal
						 FROM predio
						 WHERE cod_predio IN(SELECT DISTINCT cod_predio
											 FROM instalacion
											 WHERE tipo_instalacion = 'patio acopio')
						 AND   cod_predio NOT IN(SELECT DISTINCT cod_predio
											     FROM bosque
											     WHERE especie_bosque = 'pino'))
			  AS predio_condicion USING(cod_forestal)
GROUP BY cod_forestal;

/*
 * 11. Seleccione para cada forestal la cantidad total de predios que tienen instalaciones de
 * bodega y tienen bosque de pino. Debe aparecer cod_forestal, nombre, cantidad predios.
 * Deben aparecer todas las forestales.
 */

SELECT cod_forestal, nombre, COUNT(cod_predio) AS cantidad_predios
FROM forestal LEFT JOIN (SELECT cod_predio, cod_forestal
						 FROM predio
						 WHERE cod_predio IN(SELECT DISTINCT cod_predio
										     FROM instalacion
											 WHERE tipo_instalacion = 'bodega')
						 AND   cod_predio IN(SELECT DISTINCT cod_predio
											 FROM bosque
											 WHERE especie_bosque = 'pino'))
			  AS predio_condicion USING(cod_forestal)
GROUP BY cod_forestal;

-- PREGUNTA 4 --

/*
 * 12. Seleccione los datos de las forestales con la superficie total de predios, el valor
 * comercial total de los predios, la superficie de instalaciones y la cantidad total de bosques
 * de pino. Deben aparecer todas las forestales con cod_forestal, nombre, superficie total de
 * predios, valor comercial total de los predios, superficie de instalaciones, cantidad bosque de
 * pino.
 */

SELECT forestal.cod_forestal, forestal.nombre, SUM(superficie_total) AS superficie_total,
	   SUM(valor_comercial) AS valor_comercial,
	   SUM(superficie_instalacion) AS superficie_ins_total,
	   SUM(cantidad_bosque) AS cantidad_bosque_pino
FROM forestal LEFT JOIN (SELECT cod_forestal, cod_predio, superficie_total, valor_comercial,
						 (SELECT COALESCE(SUM(superficie_instalacion), 0)
						  FROM instalacion 
	  					  WHERE cod_predio = predio.cod_predio) AS superficie_instalacion,
       					 (SELECT COUNT(cod_bosque)
						  FROM bosque
						  WHERE cod_predio = predio.cod_predio
						  AND especie_bosque='pino') AS cantidad_bosque
						  FROM predio) AS cuenta_predio USING(cod_forestal)
GROUP BY forestal.cod_forestal;

/*
 * 13. Seleccione los datos de las forestales con la superficie total de predios, el valor
 * comercial total de los predios, la cantidad de instalaciones y la superficie total de bosques
 * de eucaliptus. Deben aparecer todas las forestales con cod_forestal, nombre, superficie total
 * de predios, valor comercial total de los predios, cantidad de instalaciones, superficie de
 * bosque de eucaliptus.
 */

SELECT forestal.cod_forestal, forestal.nombre, SUM(superficie_total) AS superficie_total,
	   SUM(valor_comercial) AS valor_comercial, SUM(cantidad_instalacion) AS cantidad_ins_total,
	   SUM(superficie_bosque_euc) AS superficie_bosque_eucaliptus
FROM forestal LEFT JOIN (SELECT cod_forestal, cod_predio, superficie_total, valor_comercial,
						 (SELECT COUNT (cod_instalacion)
						  FROM instalacion
						  WHERE cod_predio = predio.cod_predio) AS cantidad_instalacion,
       					 (SELECT SUM(superficie_bosque)
						  FROM bosque
						  WHERE cod_predio = predio.cod_predio
						  AND especie_bosque = 'eucaliptus') AS superficie_bosque_euc
						  FROM predio) AS cuenta_predio USING(cod_forestal)
GROUP BY forestal.cod_forestal;

/*
 * 14. Seleccione los datos de predios con la superficie total de bosques, la cantidad de
 * bosques, la cantidad de desastres en sus bosques y la superficie total de faenas de
 * plantacion. Deben aparecer todos los predios con cod_predio, nombre_predio, superficie total
 * de bosques, cantidad de bosques, cantidad total de desastres en sus bosques y superficie total
 * de plantacion.
 */

SELECT predio.cod_predio, predio.nombre_predio,
	   SUM(superficie_bosque) AS superficie_total_bosque,
	   COUNT(cod_bosque) AS cantidad_de_bosque,
	   SUM(cantidad_desastres) AS cantidad_des_total,
	   SUM(superficie_plantacion) AS superficie_plantacion
FROM predio LEFT JOIN (SELECT cod_predio, cod_bosque, superficie_bosque,
					   (SELECT COUNT(id_desastre)
					    FROM desastre_bosque
						WHERE cod_bosque = bosque.cod_bosque) AS cantidad_desastres,
                       (SELECT COALESCE(SUM(superficie_faena), 0)
					 	FROM faena
						WHERE cod_bosque = bosque.cod_bosque
						AND tipo_faena = 'plantacion') AS superficie_plantacion
                        FROM bosque) AS cuenta_bosque USING(cod_predio)
GROUP BY predio.cod_predio;

/*
 * 15. Seleccione los datos de predios con la superficie total de bosques, la cantidad de
 * bosques, la superficie de desastres en sus bosques y la cantidad total de faenas de cosecha.
 * Deben aparecer todos los predios con cod_predio, nombre_predio, superficie total de bosques,
 * cantidad de bosques, superficie total de desastres y cantidad faenas de cosecha.
 */

SELECT predio.cod_predio, predio.nombre_predio,
	   SUM(superficie_bosque) AS superficie_total_bosque,
	   COUNT(cod_bosque) AS cantidad_de_bosque,
	   SUM(superficie_desastres) AS superficie_des_total,
	   SUM(cantidad_cosecha) AS cantidad_cosecha
FROM predio LEFT JOIN (SELECT cod_predio, cod_bosque, superficie_bosque,
					   (SELECT COALESCE(SUM(superficie_desastre_bosque), 0)
						FROM desastre_bosque
						WHERE cod_bosque = bosque.cod_bosque) AS superficie_desastres,
                       (SELECT COUNT(id_faena)
						FROM faena
						WHERE cod_bosque = bosque.cod_bosque
						AND tipo_faena = 'cosecha') AS cantidad_cosecha
                        FROM bosque) AS cuenta_bosque USING(cod_predio)
GROUP BY predio.cod_predio;