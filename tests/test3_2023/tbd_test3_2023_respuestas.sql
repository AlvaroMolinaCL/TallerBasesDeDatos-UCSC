/* Test 3 (2023) | Taller de Bases de Datos (IN1078C) */

-- PREGUNTA 1 --
/*
 * 1.1. Escriba una función que retorne para cada predio que tiene instalaciones y tiene bosques los siguientes
 * datos: código del predio, nombre forestal, superficie predio, cantidad instalaciones de tipo ‘patio acopio’,
 * superficie total de instalaciones de tipo ‘patio acopio’, cantidad de bosques y superficie total de bosques.
 */

CREATE OR REPLACE FUNCTION datos_predio()
	RETURNS SETOF RECORD AS $$

DECLARE
	d_predio CURSOR FOR (SELECT cod_predio, nombre, superficie_total, 0::integer AS patios_acopio,
 						 		0::integer AS sup_patios_acopio, 0::integer AS bosques, 0::integer AS sup_bosques
 						 FROM forestal JOIN predio USING(cod_forestal)
 						 WHERE cod_predio IN (SELECT cod_predio FROM bosque)
						 AND cod_predio IN (SELECT cod_predio from instalacion));
	resultado record;
	
BEGIN
	OPEN d_predio;
	LOOP FETCH d_predio INTO resultado;
	EXIT WHEN NOT FOUND;
	
	SELECT INTO resultado.patios_acopio, resultado.sup_patios_acopio
 				COUNT(cod_instalacion), SUM(superficie_instalacion)
	FROM instalacion
	WHERE instalacion.cod_predio = resultado.cod_predio
	AND tipo_instalacion = 'patio acopio';
	
	SELECT INTO resultado.bosques, resultado.sup_bosques
				COUNT(cod_bosque), SUM(superficie_bosque)
	FROM bosque
	WHERE bosque.cod_predio = resultado.cod_predio;
	
	RETURN NEXT resultado;
	END LOOP;
	CLOSE d_predio;
	
END; $$ LANGUAGE 'plpgsql' VOLATILE;

-- Uso
SELECT * FROM datos_predio() AS(codigo integer, forestal varchar, superficie_total integer,
								patios_acopio integer, sup_patios_acopio integer, bosques integer, sup_bosques integer);

/*
 * 1.2. Escriba una función que retorne para cada bosque que tiene faenas y tiene desastres en bosque los siguientes
 * datos: código del bosque, nombre predio, superficie bosque, cantidad de faenas de tipo ‘cosecha’, superficie
 * total de faenas de tipo ‘cosecha’, cantidad de desastres en bosques y superficie total de desastres en bosques.
 */

CREATE OR REPLACE FUNCTION verifica_bosque_faena()
	RETURNS SETOF RECORD AS $$

DECLARE
	reg_predio CURSOR FOR(SELECT b.cod_bosque, p.nombre_predio, b.superficie_bosque, 0::integer AS
								 cantidad_faenas_cosecha, 0::integer AS superficie_total_faenas_cosechas,
 								 0::integer AS cantidad_desastre_bosque, 0::integer AS superficie_total_desastre_bosque
 						  FROM predio p JOIN bosque b USING(cod_predio)
 						  WHERE b.cod_bosque IN(SELECT cod_bosque FROM faena)
 						  AND b.cod_bosque IN(SELECT cod_bosque FROM desastre_bosque));
	fila record;
	
BEGIN
	FOR fila IN reg_predio LOOP

	SELECT INTO fila.cantidad_faenas_cosecha, fila.superficie_total_faenas_cosechas
				COUNT(id_faena), SUM(superficie_faena)
	FROM faena
	WHERE tipo_faena = 'cosecha'
	AND cod_bosque = fila.cod_bosque;
	
	SELECT INTO fila.cantidad_desastre_bosque, fila.superficie_total_desastre_bosque
				COUNT(id_desastre), SUM(superficie_desastre_bosque)
	FROM desastre_bosque
	WHERE cod_bosque = fila.cod_bosque;
	
	RETURN NEXT fila;
 	END LOOP;

END; $$ LANGUAGE 'plpgsql';

-- Uso
SELECT * FROM verifica_bosque_faena() AS (cod_bosque integer, nombre_predio varchar, superficie_bosque
										  integer, cantidad_faenas_cosecha integer,
										  superficie_total_faenas_cosechas integer, cantidad_desastre_bosque integer,
										  superficie_total_desastre_bosque integer);

-- PREGUNTA 2 --
/*
 * 2.1. Escriba una función que verifique si un nombre de predio pasado por parámetro existe o no. Debe retornar
 * verdadero (TRUE) si el predio existe y falso (FALSE) si no existe.
 */

CREATE OR REPLACE FUNCTION verificar_predio(nombre varchar)
	RETURNS BOOL AS $$

BEGIN
	IF EXISTS(SELECT nombre_predio
			  FROM predio
			  WHERE nombre_predio = nombre) THEN
		RETURN true;
	ELSE
		RETURN false;
	END IF;

END; $$ LANGUAGE 'plpgsql';

/*
 * 2.2. Escriba una función que verifique si el nombre de un contratista de mantención pasado por parámetro existe
 * o no. Debe retornar verdadero (TRUE) si el contratista de mantención existe y falso (FALSE) si no existe.
 */

CREATE OR REPLACE FUNCTION buscar_contratista(nombre varchar)
	RETURNS BOOL AS $$

DECLARE
	verifica_nombre varchar;

BEGIN
	SELECT INTO verifica_nombre nombre_contratista
	FROM contratista_mantencion
	WHERE nombre_contratista = nombre;
	
	IF FOUND THEN
		RETURN true;
	END IF;
	
	RETURN false;

END; $$ LANGUAGE 'plpgsql';

/*
 * 2.3. Escriba una función que verifique si un nombre de forestal pasado por parámetro existe o no. Debe retornar
 * verdadero (TRUE) si la forestal existe y falso (FALSE) si no existe.
 */

CREATE OR REPLACE FUNCTION comprobar_forestal(varchar)
	RETURNS VARCHAR AS $BODY$

DECLARE
	nombre_buscado alias FOR $1;
	buscador VARCHAR;

BEGIN
	SELECT INTO buscador nombre
	FROM forestal
	WHERE forestal.nombre = nombre_buscado;
	
	IF FOUND THEN
		RETURN 'true';
	ELSE
		RETURN 'false';
	END IF;

END; $BODY$ LANGUAGE 'plpgsql';

-- PREGUNTA 3 --
/*
 * 3.1. Construya una función que dado un código de instalación y tipo de instalación pasados por parámetro
 * realice lo siguiente:
 * a) Verifique que existe una instalación con el código pasado por parámetro y que es del tipo pasado por
 * parámetro.
 * Si la instalación no existe o no es del tipo pasado por parámetro debe retornar ‘La instalación XXXX
 * no existe o no es del tipo YYY. Verifique los datos de entrada’.
 * b) Si la instalación existe y es del tipo de instalación pasado por parámetro, debe verificar si tiene
 * mantenciones asociadas. Si no tiene mantenciones asociadas debe retornar ‘La instalación XXXX aún
 * no tiene mantenciones registrados’.
 * c) Si la instalación existe y es del tipo de instalación pasado por parámetro, y además tiene mantenciones
 * registradas debe retornar ‘A la instalación XXXX se le han realizado ZZ mantenciones’.
 * Donde:
 * • XXXX es el código de la instalación.
 * • YYY es el tipo de la instalación.
 * • ZZ cantidad de mantenciones realizadas a la instalación.
 */

CREATE OR REPLACE FUNCTION verifica_tipo_instalacion(instalacion_codigo integer,
													 instalacion_tipo varchar(20))
	RETURNS TEXT AS $$

DECLARE
	aux_cant_mantencion integer;

BEGIN
	IF EXISTS(SELECT cod_instalacion, tipo_instalacion
			  FROM instalacion
			  WHERE cod_instalacion = instalacion_codigo
			  AND tipo_instalacion = instalacion_tipo) THEN
		aux_cant_mantencion := (SELECT COUNT(*)
								FROM mantencion_instalacion
								WHERE cod_instalacion = instalacion_codigo);
		IF(aux_cant_mantencion > 0) THEN
			RETURN 'A la instalación '||instalacion_codigo||' se le han realizado '||aux_cant_mantencion||'
					mantenciones';
		ELSE
			RETURN 'La instalación '||instalacion_codigo||' aún no tiene mantenciones registradas';
		END IF;
	ELSE
		RETURN 'La instalación '||instalacion_codigo||' no existe o no es del tipo '||instalacion_tipo||'.
				Verifique los datos de entrada';
	END IF;

END; $$ LANGUAGE 'plpgsql';

/*
 * 3.2. Construya una función que dado un código de bosque y especie de bosque pasados por parámetro realice
 * lo siguiente:
 * a) Verifique que existe un bosque con el código pasado por parámetro y que es de la especie pasada por
 * parámetro.
 * Si el bosque no existe o no es de la especie pasada por parámetro debe retornar ‘El bosque XXXX no
 * existe o no es de la especie YYY. Verifique los datos de entrada’.
 * b) Si el bosque existe y es de la especie pasada por parámetro, debe verificar si tiene faenas registradas.
 * Si no tiene faenas registradas debe retornar ‘El bosque XXXX aún no tiene faenas registradas’.
 * c) Si el bosque existe y es de la especie pasada por parámetro, y además tiene faenas registradas debe
 * retornar ‘Al bosque XXXX se le han realizado ZZ faenas’.
 * Donde:
 * • XXXX es el código del bosque.
 * • YYY es la especie de bosque.
 * • ZZ cantidad de faenas realizadas al bosque.
 */

CREATE OR REPLACE FUNCTION verificar_bosque_especie(cod_bosque_param integer,
													especie_param varchar)
	RETURNS TEXT AS $$

DECLARE
	cod_bosque_aux integer;
	cantidad_faenas integer;

BEGIN
	SELECT INTO cod_bosque_aux cod_bosque bo.cod_bosque
	FROM bosque bo
	WHERE bo.cod_bosque = cod_bosque_param
	AND bo.especie_bosque = especie_param;
	
	IF NOT FOUND THEN
		RETURN 'El bosque '||cod_bosque_param||' no existe o no es de la especie '||especie_param||'. Verifique
				los datos de entrada';
	ELSE
		SELECT COUNT(id_faena) INTO cantidad_faenas
		FROM faena
		WHERE id_faena = cod_bosque_param;
		
		IF(cantidad_faenas > 0) THEN
			RETURN 'El bosque '||cod_bosque_param||' ha sido afectado por '||cantidad_faenas||' faenas';
		ELSE
			RETURN 'El bosque '||cod_bosque_param||' aún no tiene faenas registradas';
		END IF;
	END IF;

END; $$ LANGUAGE 'plpgsql';

/*
 * 3.3. Construya una función que dado un código de bosque y código de predio pasados por parámetro realice
 * lo siguiente:
 * a) Verifique que existe un bosque con el código de bosque pasado por parámetro y que corresponde al
 * predio pasado por parámetro.
 * Si el bosque no existe o no es del predio pasado por parámetro debe retornar ‘El bosque XXXX no
 * existe o no es del predio YYY. Verifique los datos de entrada’.
 * b) Si el bosque existe y es del predio pasado por parámetro, debe verificar si tiene registrados desastres
 * en bosque. Si no tiene desastres en bosque registrados debe retornar ‘El bosque XXXX aún no tiene
 * desastres en bosques registrados’.
 * c) Si el bosque existe y es del predio pasado por parámetro, y además tiene desastres en bosque
 * registrados debe retornar ‘El bosque XXXX ha sido afectado por ZZ desastres en bosque’.
 * Donde:
 * • XXXX es el código del bosque.
 * • YYY es el código del predio.
 * • ZZ cantidad de desastres en bosque que lo han afectado.
 */

CREATE OR REPLACE FUNCTION verificar_bosque_predio(cod_bosque_param integer,
												   cod_predio_param integer)
	RETURNS TEXT AS $$

DECLARE
	cod_bosque_aux integer;
	cantidad_desastres integer;

BEGIN
	SELECT bo.cod_bosque INTO cod_bosque_au
	FROM bosque bo
	WHERE bo.cod_bosque = cod_bosque_param
	AND bo.cod_predio = cod_predio_param;
	
	IF (NOT FOUND) THEN
		RETURN CONCAT('El bosque ', cod_bosque_param, ' no existe o no es del predio ', cod_predio_param,
					  '. Verifique los datos de entrada');
	ELSE
		SELECT COUNT(dbos.id_desastre) INTO cantidad_desastres
		FROM desastre_bosque dbos
		WHERE dbos.cod_bosque = cod_bosque_param;
		
		IF(cantidad_desastres > 0) THEN
			RETURN CONCAT('El bosque ', cod_bosque_param, ' ha sido afectado por ', cantidad_desastres, '
						   desastres en bosque');
		ELSE
			RETURN CONCAT('El bosque ', cod_bosque_param, ' aún no tiene desastres en bosques registrados');
		END IF;
	END IF;

END; $$ LANGUAGE 'plpgsql';