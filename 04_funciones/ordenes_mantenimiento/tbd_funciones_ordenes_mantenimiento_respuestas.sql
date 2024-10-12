/* Ejercicios Funciones: Base de Datos "Ordenes Mantenimiento" - Taller de Bases de Datos (IN1078C) */

/*
 * Ejemplo 1: El siguiente código crea una función que recibe dos parámetros de tipo entero y retorna
 * un entero.
 */

CREATE OR REPLACE FUNCTION ejemplo(integer, integer)
RETURNS integer AS $$

DECLARE
	numero1 ALIAS FOR $1; -- Le da un nombre al argumento 1
	numero2 ALIAS FOR $2; -- Le da un nombre al argumento 2
	constante CONSTANT integer := 100; -- Define una constante de tipo entero
	resultado integer; -- Define variable de tipo entero que se utilizará como retorno

BEGIN
	resultado = (numero1 * numero2) + constante;
	RETURN resultado;

END; $$ LANGUAGE 'plpgsql';

-- Uso
SELECT ejemplo(2, 2);

/*
 * Ejercicio 1: Escriba un procedimiento almacenado que calcule la potencia de un
 * número.
 */

CREATE OR REPLACE FUNCTION ejemplo_potencia(integer, integer)
RETURNS integer AS $$

DECLARE
	numero1 ALIAS FOR $1; -- Le da un nombre al argumento 1
	numero2 ALIAS FOR $2; -- Le da un nombre al argumento 2
	resultado integer; -- Define variable de tipo entero que se utilizará como retorno

BEGIN
	resultado = numero1^numero2;
	RETURN resultado;

END; $$ LANGUAGE 'plpgsql';

-- Uso
SELECT ejemplo_potencia(3, 3);

/*
 * Ejemplo 2: La siguiente función verifica en la tabla supervisor de la base de datos si un supervisor
 * existe o no.
 */

CREATE OR REPLACE FUNCTION buscar_supervisor(varchar) -- Se le va a pasar por parámetro
													  -- un argumento de tipo varchar.
RETURNS bool AS $$ -- Retorna un booleano (verdadero o falso).

DECLARE
	nombre_buscar ALIAS FOR $1; -- Le da un nombre al argumento 1.
	registro supervisor%ROWTYPE; -- Define la variable registro de tipo fila de la
								 -- tabla supervisor a través del símbolo % y luego la
								 -- palabra reservada ROWTYPE.

BEGIN
	SELECT INTO registro * FROM supervisor   -- Recupera el primer registro donde aparezca
	WHERE nombre_supervisor = nombre_buscar; -- el nombre_buscar o NULL si no lo encuentra.
	
	IF FOUND THEN 	 -- Se utiliza la variable FOUND para verificar si el SELECT
		RETURN true; -- retornó una fila. En ese caso retorna verdadero.
	END IF;
	
	RETURN false; -- Retorna falso si el SELECT no retornó una fila, es decir, no entró al IF.

END; $$ LANGUAGE 'plpgsql';

-- Uso
SELECT buscar_supervisor('Jose');

-- Ejercicios: Dada la base de datos de órdenes de mantenimiento

/*
 * a) Escriba una función que dado el nombre de un supervisor retorne la cantidad de órdenes
 * de mantenimiento que ha supervisado, o cero si no ha supervisado ninguna.
 */

CREATE OR REPLACE FUNCTION ordenes_supervisor(nombre_buscar varchar)
RETURNS integer AS $$

DECLARE
	cantidad_orden integer;

BEGIN
	IF ((SELECT buscar_supervisor(nombre_buscar)) = true) THEN
		SELECT INTO cantidad_orden COUNT(cod_orden)
		FROM orden_mantenimiento JOIN supervisor USING(rut)
		WHERE nombre_supervisor = nombre_buscar;
		RETURN cantidad_orden;
	ELSE
		RAISE EXCEPTION 'El supervisor no existe.';
	END IF;

END; $$ LANGUAGE 'plpgsql';

-- Uso
SELECT ordenes_supervisor('Maria');

/*
 * b) Escriba una función que, dada nombre de repuesto retorne en un texto en cuantas
 * órdenes de mantenimiento se ha utilizado y cuál es la cantidad total utilizada.
 * Ej. ‘El repuesto '||nombre repuesto||' se ha utilizado en '|XX||' ordenes de mantenimiento y
 * la cantidad total usada es '||YY;
 */

CREATE OR REPLACE FUNCTION busca_repuesto(varchar)
RETURNS bool AS $$

DECLARE
	nombre_buscar ALIAS FOR $1;
	codigo integer;

BEGIN
	SELECT INTO codigo cod_repuesto
	FROM repuesto
	WHERE nombre_repuesto = nombre_buscar;

	IF FOUND THEN
		RETURN true;
	END IF;

	RETURN false;

END; $$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION uso_repuesto(varchar)
RETURNS text AS $$

DECLARE
	nombre_buscar ALIAS FOR $1;
	cantidad_orden integer;
	suma_cantidad integer;

BEGIN
	IF ((SELECT * FROM busca_repuesto(nombre_buscar)) = true) THEN
		SELECT INTO cantidad_orden, suma_cantidad COUNT(cod_orden), COALESCE(SUM(cantidad_repuesto), 0)
		FROM repuesto_orden JOIN repuesto USING(cod_repuesto)
		WHERE nombre_repuesto = nombre_buscar;
		
		IF FOUND THEN
			RETURN 'El repuesto '||nombre_buscar||' se ha utilizado en '||cantidad_orden||' ordenes de mantenimiento y la cantidad usada es '||suma_cantidad;
		END IF;
	END IF;

END; $$ LANGUAGE 'plpgsql';

-- Uso
SELECT uso_repuesto('polea');

/*
 * c) Escriba una función que dado el nombre de una empresa entregue verdadero si la 
 * empresa tiene órdenes de mantenimiento (al menos una) y falso si no tiene.
 */

CREATE OR REPLACE FUNCTION busca_empresa(varchar)
RETURNS bool AS $$

DECLARE
	nombre_buscar ALIAS FOR $1;
	codigo integer;

BEGIN
	SELECT INTO codigo id_empresa
	FROM empresa
	WHERE nombre_empresa = nombre_buscar;

	IF FOUND THEN
		RETURN true;
	END IF;

	RETURN false;

END; $$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION empresa_tiene_ordenes(varchar)
RETURNS bool AS $$

DECLARE
	nombre_buscar ALIAS FOR $1;
	cantidad_ordenes_empresa integer;

BEGIN
	IF ((SELECT * FROM busca_empresa(nombre_buscar)) = true) THEN
		SELECT INTO cantidad_ordenes_empresa COUNT(cod_orden)
		FROM orden_mantenimiento JOIN empresa USING(id_empresa)
		WHERE nombre_empresa = nombre_buscar;

		IF (cantidad_ordenes_empresa >= 1) THEN
			RETURN true;
		ELSE
			RETURN false;
		END IF;
	END IF;

END; $$ LANGUAGE 'plpgsql';

-- Uso
SELECT empresa_tiene_ordenes('Prime');

/*
 * d) Escriba una función que, dado un nombre de supervisor y un nombre de empresa, 
 * retorne en un texto si la empresa tiene una o más órdenes de mantenimiento 
 * supervisadas por el supervisor con la cantidad de órdenes y el valor total. Si no, debe 
 * decir en un texto que la empresa no tiene órdenes de mantenimiento supervisadas por el 
 * supervisor.
 */

CREATE OR REPLACE FUNCTION ord_mant_supervisadas_empresa(nombre_sup_buscar varchar,
														 nombre_emp_buscar varchar)
RETURNS text AS $$

DECLARE
	cantidad_orden integer;
	valor_total_orden bigint;

BEGIN
	IF ((SELECT * FROM busca_empresa(nombre_emp_buscar)) AND
		(SELECT * FROM buscar_supervisor(nombre_sup_buscar)) = true) THEN
		SELECT INTO cantidad_orden, valor_total_orden COUNT(cod_orden), COALESCE(SUM(valor_total), 0)
		FROM orden_mantenimiento JOIN empresa USING(id_empresa) JOIN supervisor USING(rut)
		WHERE nombre_empresa = nombre_emp_buscar
		AND nombre_supervisor = nombre_sup_buscar;

		IF (cantidad_orden >= 1) THEN
			RETURN 'La empresa '||nombre_emp_buscar||' tiene '||cantidad_orden||' órdenes de mantenimiento
					supervisadas por '||nombre_sup_buscar||' con un valor total de '||valor_total_orden;
		ELSE
			RETURN 'La empresa '||nombre_emp_buscar||' no tiene órdenes de mantenimiento supervisadas
					por '||nombre_sup_buscar;
		END IF;
	ELSE
		RETURN 'La empresa o el supervisor indicados, no existen';
	END IF;

END; $$ LANGUAGE 'plpgsql';

-- Uso
SELECT ord_mant_supervisadas_empresa('Jose', 'Metal');