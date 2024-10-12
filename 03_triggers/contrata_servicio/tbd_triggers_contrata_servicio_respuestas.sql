/* Ejercicios Triggers: Base de Datos "Contrata Servicio" - Taller de Bases de Datos (IN1078C) */

/* 
 * 1. Cree un trigger que verifique que la fecha de inicio y fecha de
 * término ingresadas o actualizadas en la tabla contrato, tienen
 * sentido cronológico (trigger para INSERT y UPDATE, cuando se
 * actualiza alguna fecha).
 */

-- Funcion asociada al Trigger
CREATE OR REPLACE FUNCTION verifica_fecha_before()
RETURNS TRIGGER AS $$

BEGIN
	IF (new.fecha_inicio > new.fecha_termino) THEN 
		RAISE EXCEPTION 'Fechas no coinciden';
		RETURN NULL;
	ELSE
		RETURN new;
	END IF;	
END
$$ LANGUAGE 'plpgsql';

-- Trigger para INSERT
CREATE TRIGGER verificador_fecha_before_t
BEFORE INSERT ON contrato
FOR EACH ROW 
EXECUTE PROCEDURE verifica_fecha_before();

-- Trigger para UPDATE
CREATE TRIGGER verificador_fecha_before_update_t
BEFORE UPDATE OF fecha_inicio, fecha_termino ON contrato
FOR EACH ROW 
EXECUTE PROCEDURE verifica_fecha_before();

-- Eliminar Trigger
DROP TRIGGER verificador_fecha_before_t;

-- Probando
INSERT INTO contrato (codigo, fecha_inicio, fecha_termino, cliente, vendedor, servicio) 
VALUES (9, '2022-01-01', '2021-01-01', 7679982, 13586124, 5);
INSERT INTO contrato (codigo, fecha_inicio, fecha_termino, cliente, vendedor, servicio) 
VALUES (9, '2022-01-01', '2022-07-01', 7679982, 13586124, 5);

/*
 * 2. Cree un trigger que permita mantener actualizado el campo
 * contratos en la tabla VENDEDOR para cada vez que se borra,
 * inserta o actualiza un registro en la tabla CONTRATO (INSERT,
 * DELETE y UPDATE).
 */

-- Insert
CREATE OR REPLACE FUNCTION actualiza_contratos_insert()
RETURNS TRIGGER AS $$
DECLARE 
	numero_contratos integer;

BEGIN
	-- Numero de contratos del vendedor
	SELECT INTO numero_contratos COUNT(codigo)
	FROM contrato
	WHERE vendedor = new.vendedor;

	-- Se actualiza el campo
	UPDATE vendedor
	SET contratos = numero_contratos
	WHERE rut = new.vendedor;

	RETURN new;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER actualizador_contratos_insert_t
AFTER INSERT ON contrato
FOR EACH ROW 
EXECUTE PROCEDURE actualiza_contratos_insert();

-- Probando
INSERT INTO contrato (codigo, fecha_inicio, fecha_termino, cliente, vendedor, servicio) 
VALUES (10, '2022-05-01', '2023-06-01', 7679982, 13586124, 5);

-- Update
CREATE OR REPLACE FUNCTION actualiza_contratos_update()
RETURNS TRIGGER AS $$
DECLARE 
	numero_contratos_anterior integer;
	numero_contratos integer;

BEGIN
	-- Numero de contratos del anterior vendedor
	SELECT INTO numero_contratos_anterior COUNT(codigo)
	FROM contrato
	WHERE vendedor = old.vendedor;

	-- Numero de contratos del nuevo vendedor
	SELECT INTO numero_contratos COUNT(codigo)
	FROM contrato
	WHERE vendedor = new.vendedor;

	-- Se actualiza el campo para ambos vendedores
	UPDATE vendedor
	SET contratos = numero_contratos_anterior
	WHERE rut = old.vendedor;

	UPDATE vendedor
	SET contratos = numero_contratos
	WHERE rut = new.vendedor;

	RETURN new;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER actualizador_contratos_update_t
AFTER UPDATE OF vendedor ON contrato
FOR EACH ROW 
EXECUTE PROCEDURE actualiza_contratos_update();

-- Delete
CREATE OR REPLACE FUNCTION actualiza_contratos_delete()
RETURNS TRIGGER AS $$
DECLARE 
	numero_contratos integer;

BEGIN
	-- Numero de contratos 
	SELECT INTO numero_contratos COUNT(codigo)
	FROM contrato
	WHERE vendedor = old.vendedor;

	-- Se actualiza el campo para ambos vendedores
	UPDATE vendedor
	SET contratos = numero_contratos
	WHERE rut = old.vendedor;

	RETURN new;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER actualizador_contratos_delete_t
AFTER DELETE ON contrato
FOR EACH ROW 
EXECUTE PROCEDURE actualiza_contratos_delete();

/* 
 * 3. Se implementan nuevas políticas de la empresa:
 * - Los contratos activos con más de 60 dias desde su firma no
 *   podran ser finalizados anticipadamente ni podrán ser modificados.
 * - Los contratos que ya han finalizado no podrán ser modificados.
 * Implemente los triggers necesarios para que se reflejen estas
 * políticas.
 */

CREATE OR REPLACE FUNCTION no_actualizacion()
RETURNS TRIGGER AS $$

DECLARE
	diferencia integer;
	
BEGIN
	IF (old.fecha_termino < current_date) THEN
		RAISE EXCEPTION 'Contrato ya terminado. No se puede modificar';
		RETURN NULL;
	ELSE
		diferencia := old.fecha_termino - current_date;
	
		IF (diferencia > 60) THEN
			RAISE EXCEPTION 'Vigencia de contrato mayor a 60 días. Imposible de repactar';
			RETURN NULL;
		ELSE
			RETURN new;
		END IF;
	END IF;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER no_actualizacion_t
BEFORE UPDATE ON contrato
FOR EACH ROW 
EXECUTE PROCEDURE no_actualizacion();

/*
 * 4. Cree un trigger que verifique que los servicios contratados por
 * cada cliente estén disponibles en su zona de residencia. En caso
 * de que no esté disponible, el contrato no podrá firmarse.
 */

CREATE OR REPLACE FUNCTION verificador_servicio()
RETURNS TRIGGER AS $$

DECLARE 
	zona_cliente integer;
	auxiliar record; -- Variable auxiliar de tipo record
BEGIN
	SELECT INTO zona_cliente zona
	FROM cliente 
	WHERE rut = new.cliente;

	/*
	PERFORM  *
	FROM disponibilidad
	WHERE codigo_servicio = new.servicio
	AND codigo_zona = zona_cliente;
	*/

	SELECT INTO auxiliar *
	FROM disponibilidad
	WHERE codigo_servicio = new.servicio
	AND codigo_zona = zona_cliente;

	IF FOUND THEN
		RETURN new;
	ELSE
		RAISE EXCEPTION 'No existe en la zona 2';
		RETURN NULL;
	END IF;
END
$$ LANGUAGE 'plpgsql';

-- Sin auxiliar
CREATE OR REPLACE FUNCTION verificador_servicio2()
RETURNS TRIGGER AS $$

DECLARE 
	zona_cliente integer;
BEGIN
	SELECT INTO zona_cliente zona
	FROM cliente 
	WHERE rut = new.cliente;

	PERFORM  *
	FROM disponibilidad
	WHERE codigo_servicio = new.servicio
	AND codigo_zona = zona_cliente;

	IF FOUND THEN
		RETURN new;
	ELSE
		RAISE EXCEPTION 'No existe en la zona 2';
		RETURN NULL;
	END IF;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER verificador_servicio_t
BEFORE INSERT ON contrato
FOR EACH ROW 
EXECUTE PROCEDURE verificador_servicio();

-- Si
INSERT INTO public.contrato (codigo,fecha_inicio,fecha_termino,cliente,vendedor,servicio) VALUES
	 (11,'2022-05-23','2022-05-23',7679982,13586124,6);
-- No
INSERT INTO public.contrato (codigo,fecha_inicio,fecha_termino,cliente,vendedor,servicio) VALUES
	 (13,'2022-05-23','2022-05-23',7679982,13586124,8);