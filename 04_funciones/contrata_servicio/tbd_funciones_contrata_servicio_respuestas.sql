/* Ejercicios Funciones: Base de Datos "Contrata Servicio" - Taller de Bases de Datos (IN1078C) */

-- FUNCIONES MATEMÁTICAS --

/*
 * 1. Cree una función que calcule el factorial de un número entero 
 * ingresado (n!).
 */

CREATE OR REPLACE FUNCTION factorial(n int)
RETURNS integer AS $$

DECLARE
	al integer;
	i integer;
	
BEGIN
	al := 1;
	i := 1;
	
	FOR i IN 1 .. n LOOP
		al = al * i;
	END LOOP;
	
	RETURN al;
	
END; $$LANGUAGE 'plpgsql';

-- Uso
SELECT factorial(2);

-- BASE DE DATOS "CONTRATA SERVICIO" --

/*
 * 3. Cree una función que, ingresando el rut de un cliente, retorne el
 * número de contratos vigentes que mantiene. Si el rut ingresado no
 * corresponde a un cliente válido, se debe retornar -1.
 */

CREATE OR REPLACE FUNCTION contratos_vigentes(el_rut int)
RETURNS integer AS $$

DECLARE
	contador integer;
	
BEGIN
	PERFORM *
	FROM cliente
	WHERE rut = el_rut;

	IF (FOUND) THEN
		contador := (SELECT COUNT(*)
					 FROM contrato
					 WHERE cliente = el_rut
					 AND fecha_termino >= CURRENT_DATE
					 GROUP BY cliente);
		RETURN contador;
	ELSE
		RETURN -1;
	END IF;
	
END; $$LANGUAGE 'plpgsql';

-- Uso
SELECT contratos_vigentes(11297644);
SELECT contratos_vigentes(12221178);

/*
 * 4. Cree una funcion que verifique si un servicio pasado por
 * parámetro está disponible en una zona especificada por
 * parámetro. La función debe retornar mediante texto el resultado,
 * indicando tambien la zona y el servicio que se ingresó.
 */

CREATE OR REPLACE FUNCTION verificar_disp_serv(cod_serv smallint, cod_zona smallint)
RETURNS text AS $$

DECLARE
	
BEGIN
	PERFORM *
	FROM disponibilidad
	WHERE codigo_servicio = cod_serv
	AND codigo_zona = cod_zona;
	
	IF (FOUND) THEN
		RETURN 'El servicio '||servicio.nombre||' se encuentra disponible en la zona '||zona.nombre;
	ELSE
		RETURN 'El servicio '||servicio.nombre||' no se encuentra disponible en la zona '||zona.nombre;
	END IF;
	
END; $$LANGUAGE 'plpgsql';

-- Uso
SELECT verificar_disp_serv(1, 3);