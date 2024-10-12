/* Ejercicios Funciones con Cursores: Base de Datos "Ordenes Mantenimiento" - Taller de Bases de Datos (IN1078C) */

/* Ejemplo: Listar las órdenes de mantenimiento con el número total de repuesto que ha utilizado. */

CREATE OR REPLACE FUNCTION imprime_ordenes()
	RETURNS SETOF RECORD AS $$ -- Se usa SETOF para retornar varias filas

DECLARE
	-- Se define la variable ordenes de tipo CURSOR a través de un SELECT
	-- El SELECT contiene un campo de tipo entero que tendrá valores nulos inicialmente (cantidad_rep)
	ordenes CURSOR FOR SELECT cod_orden, rut, nombre_supervisor, nombre_empresa, fecha_orden, valor_total,
							  NULL::integer as cantidad_rep -- Se agrega columna de tipo entero que tendrá valores nulos
					   FROM orden_mantenimiento JOIN supervisor USING(rut) JOIN empresa USING(id_empresa);
	fila_cursor RECORD; -- Se define una variable de tipo RECORD (registro), porque el SELECT retorna varias columnas

BEGIN
	OPEN ordenes; --Se abre el cursor y se carga el resultado del SELECT en él
		LOOP -- Se usa para ir de registro en registro
			FETCH ordenes INTO fila_cursor; -- Recupera un registro del cursor y lo carga en la variable fila_cursor.
			EXIT WHEN NOT FOUND; -- El LOOP termina cuando ya no hay más registros
			
			SELECT INTO fila_cursor.cantidad_rep count(cod_repuesto) -- Se cuentan los repuestos
			FROM repuesto orden -- y el valor se pone en el campo cantidad_rep
			WHERE cod_orden = fila_cursor.cod_orden; -- para el codigo de orden que corresponde a la fila
			
			RETURN NEXT fila_cursor; -- Se retorna la fila que tiene un valor en el campo con el numero de repuestos
		END LOOP;
	CLOSE ordenes; -- Se cierra el cursor
	
	RETURN;

END; $$ LANGUAGE 'plpgsql';

-- Uso
SELECT * FROM imprime_ordenes() 
AS fila(cod_orden integer, rut integer, supervisor varchar, empresa varchar, fecha_orden date,
		valor_orden integer, cantidad_repuestos integer);

-- EJERCICIOS --
/*
 * 1. Cree una función que, dado un nombre de supervisor, retorne todas las ordenes
 * de mantenimiento que ha supervisado con un campo que diga si ha usado
 * repuestos o no ('ha usado repuestos' / 'no ha usado repuestos').
 */

CREATE OR REPLACE FUNCTION imprime_ordenes_supervisor(nombre_sup varchar)
	RETURNS SETOF RECORD AS $$

DECLARE
	ordenes_sup CURSOR FOR SELECT cod_orden, nombre_empresa, fecha_orden, valor_total, NULL::varchar AS usa_repuesto
						   FROM orden_mantenimiento JOIN supervisor USING(rut) JOIN empresa USING(id_empresa)
						   WHERE nombre_supervisor = nombre_sup;
	fila_cursor RECORD;
	
BEGIN
	OPEN ordenes_sup;
		LOOP
			FETCH ordenes_sup INTO fila_cursor;
			EXIT WHEN NOT FOUND;
		
			IF ((SELECT COUNT(cod_repuesto)
			 	 FROM repuesto_orden
			 	 WHERE cod_orden = fila_cursor.cod_orden) = 0) THEN
				fila_cursor.usa_repuesto = 'No ha usado repuestos';
			ELSE
				fila_cursor.usa_repuesto = 'Si ha usado repuestos';
			END IF;

			RETURN NEXT fila_cursor;
		END LOOP;
	CLOSE ordenes_sup;

	RETURN;

END; $$ LANGUAGE 'plpgsql';

-- Uso
SELECT * FROM imprime_ordenes_supervisor('Luis')
AS fila(cod_orden integer, empresa varchar, fecha_orden date, valor_orden integer, usa_repuestos varchar);

/*
 * 2. Cree una función que retorne el listado de todas las empresas, el número total de
 * ordenes de mantenimiento que tiene y la suma del valor total.
 */

CREATE OR REPLACE FUNCTION ordenes_empresas()
	RETURNS SETOF RECORD AS $$

DECLARE
	ordenes_emp CURSOR FOR SELECT id_empresa, nombre_empresa, NULL::integer AS cant_ordenes, NULL::integer AS valor_total_ord
						   FROM empresa JOIN orden_mantenimiento USING(id_empresa);
	fila_cursor RECORD;
	
BEGIN
	OPEN ordenes_emp;
		LOOP
			FETCH ordenes_emp INTO fila_cursor;
			EXIT WHEN NOT FOUND;

			SELECT INTO fila_cursor.cant_ordenes COUNT(cod_orden)
			FROM orden_mantenimiento
			WHERE cod_orden = fila_cursor.cod_orden;
			
			RETURN NEXT fila_cursor;
		END LOOP;
		
		LOOP
			FETCH ordenes_emp INTO fila_cursor;
			EXIT WHEN NOT FOUND;
			
			SELECT INTO fila_cursor.valor_total_ord SUM(valor_total)
			FROM orden_mantenimiento
			WHERE cod_orden = fila_cursor.cod_orden;
			
			RETURN NEXT fila_cursor;
		END LOOP;
	CLOSE ordenes_emp;

	RETURN;

END; $$ LANGUAGE 'plpgsql';

-- Uso
SELECT * FROM ordenes_empresas()
AS fila(id_empresa integer, nombre_empresa varchar, cant_ord integer, valor_total_o integer);