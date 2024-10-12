/* Test 2 (2023) | Taller de Bases de Datos (IN1078C) */

-- PREGUNTA 1 --
/*
 * 1.1. Cree un Trigger para que cada vez que se ingresa un nuevo desastre en bosque (INSERTA un registro
 * en la tabla DESASTRE_BOSQUE), se actualice el campo superficie_total_desastre del DESASTRE
 * correspondiente.
 * Se debe verificar que el valor de la superficie de desastre en bosque (superficie_desastre_bosque) en el
 * nuevo registro en la tabla DESASTRE_BOSQUE no puede ser mayor al valor del campo
 * superficie_bosque en la tabla BOSQUE para el registro correspondiente.
 */

-- Si la superficie de desastre en un bosque es menor o igual a la superficie del bosque correspondiente,
-- entonces, se actualiza la superficie total de desastre y se retorna NEW.
-- Si no es menor o igual, se retorna NULL.

CREATE OR REPLACE FUNCTION inserta_desastre_bosque()
    RETURNS TRIGGER AS $BODY$

DECLARE
	sup_bosque integer;
	
BEGIN
	SELECT INTO sup_bosque superficie_bosque
	FROM bosque
	WHERE cod_bosque = new.cod_bosque;
	
	IF (new.superficie_desastre_bosque <= sup_bosque) THEN
		UPDATE desastre
		SET superficie_total_desastre = superficie_total_desastre + new.superficie_desastre_bosque
		WHERE desastre.id_desastre = new.id_desastre; -- Siempre se debe poner el WHERE ya que sino se actualiza
													  -- toda la tabla.
		RETURN new;
	ELSE
		RAISE EXCEPTION 'La superficie de desastre es mayor a la superficie del bosque.';
		RETURN NULL;
	END IF;
		
END; $BODY$ LANGUAGE 'plpgsql';

CREATE TRIGGER inserta_desastre_bosque
BEFORE INSERT ON desastre_bosque
FOR EACH ROW EXECUTE FUNCTION inserta_desastre_bosque();

/*
 * 1.2. Cree un Trigger para que cada vez que se ingresa una nueva faena (INSERTA un registro en la tabla
 * FAENA), se actualice el campo superficie_total_faena del CONTRATISTA_FAENA correspondiente.
 * Se debe verificar que el valor de la superficie de la faena (superficie_faena) en el nuevo registro en la
 * tabla FAENA no puede ser mayor al valor del campo superficie_bosque en la tabla BOSQUE para el
 * registro correspondiente.
 */

CREATE OR REPLACE FUNCTION inserta_faena()
    RETURNS TRIGGER AS $BODY$
	
DECLARE
	sup_bosque integer;
	
BEGIN
	SELECT INTO sup_bosque superficie_bosque
	FROM bosque
	WHERE cod_bosque = new.cod_bosque;
	
	IF (new.superficie_faena <= sup_bosque) THEN
		UPDATE contratista_faena
		SET superficie_total_faena = superficie_total_faena + new.superficie_faena
		WHERE contratista_faena.rut_contratista = new.rut_contratista;
		RETURN new;
	ELSE
		RAISE EXCEPTION 'La superficie de faena es mayor a la superficie del bosque.';
		RETURN NULL;
	END IF;
		
END; $BODY$ LANGUAGE 'plpgsql';

CREATE TRIGGER inserta_faena
BEFORE INSERT ON faena
FOR EACH ROW EXECUTE FUNCTION inserta_faena();

/* 
 * 1.3. Cree un Trigger para que cada vez que se ingresa una nueva mantención en instalación (INSERTA un
 * registro en la tabla MANTENCION_INSTALACION), se actualice el campo
 * superficie_total_mantención del CONTRATISTA_MANTENCION correspondiente.
 * Se debe verificar que el valor de la superficie de mantención en instalación (superficie_mantencion en
 * el nuevo registro en la tabla MANTENCION_INSTALACION no puede ser mayor al valor del campo
 * superficie_instalacion en la tabla INSTALACION para el registro correspondiente.
 */

CREATE OR REPLACE FUNCTION inserta_mantencion_instalacion()
    RETURNS TRIGGER AS $BODY$
	
DECLARE
	sup_instalacion integer;
	
BEGIN
	SELECT INTO sup_instalacion superficie_instalacion
	FROM instalacion
	WHERE cod_instalacion = new.cod_instalacion;
	
	IF (new.superficie_mantencion <= sup_instalacion) THEN
		UPDATE contratista_mantencion
		SET superficie_total_mantencion = superficie_total_mantencion + new.superficie_mantencion
		WHERE contratista_mantencion.rut_contratista = new.rut_contratista;
		RETURN new;
	ELSE
		RAISE EXCEPTION 'La superficie de mantención en instalación es mayor a la superficie de instalación.';
		RETURN NULL;
	END IF;
		
END; $BODY$ LANGUAGE 'plpgsql';

CREATE TRIGGER inserta_mantencion_instalacion
BEFORE INSERT ON mantencion_instalacion
FOR EACH ROW EXECUTE FUNCTION inserta_mantencion_instalacion();

-- PREGUNTA 2 --
/*
 * 2.1. Cree un Trigger que se ejecute cada vez que se actualice un registro de una faena asociada a un bosque
 * (ACTUALIZA un registro en la tabla FAENA). Debe considerar que en la tabla FAENA se pueden haber
 * actualizado los campos superficie_faena y/o rut_contratista. Se debe realizar lo siguiente:
 * • Siempre que se actualice el campo superficie_faena, deberá verificar que el nuevo valor de superficie
 * de la faena no puede ser mayor al valor del campo superficie_bosque en la tabla BOSQUE. Si es mayor,
 * debe enviar un mensaje de error diciendo que el nuevo valor de superficie de faena no puede ser mayor
 * al valor de superficie del bosque y la operación no se puede realizar.
 * • Si se actualiza sólo el campo superficie faena y el contratista es el mismo (cambia el valor del campo
 * superficie_faena en la tabla FAENA), deberá actualizar el valor de la superficie total de faena en la
 * tabla CONTRATISTA_FAENA para el registro que corresponde (superficie_total_faena).
 * • Si se actualizó el contratista que realiza la faena (cambia el valor del campo rut_contratista en la tabla
 * FAENA) debe actualizar el campo superficie_total_faena de la tabla CONTRATISTA_FAENA para
 * el contratista anterior (old.rut_contratista) y para el nuevo contratista al que corresponde el registro
 * (new.rut_contratista).
 */

CREATE OR REPLACE FUNCTION actualiza_faena()
	RETURNS TRIGGER AS $$

DECLARE
 	superficie integer;
	
BEGIN
	SELECT INTO superficie superficie_bosque
	FROM bosque
	WHERE cod_bosque = new.cod_bosque;

	IF (new.superficie_faena > superficie) THEN
		RAISE EXCEPTION 'La superficie de faena no puede ser mayor a la superficie del bosque';
		RETURN NULL;
	ELSE
		IF (new.rut_contratista <> old.rut_contratista) THEN
			UPDATE contratista_faena
			SET superficie_total_faena = superficie_total_faena + new.superficie_faena
			WHERE rut_contratista = new.rut_contratista;

			UPDATE contratista_faena
			SET superficie_total_faena = superficie_total_faena - old.superficie_faena
			WHERE rut_contratista = old.rut_contratista;

			RETURN new;
		ELSE
			UPDATE contratista_faena
			SET superficie_total_faena = superficie_total_faena + new.superficie_faena - old.superficie_faena
			WHERE rut_contratista = old.rut_contratista;
			RETURN new;
		END IF;
	END IF;
	
END; $$ LANGUAGE 'plpgsql';

CREATE TRIGGER actualiza_faena
BEFORE UPDATE ON faena
FOR EACH ROW EXECUTE FUNCTION actualiza_faena();

/*
 * 2.2. Cree un Trigger que se ejecute cada vez que se actualice un registro de un desastre asociado a un bosque
 * (ACTUALIZA un registro en la tabla DESASTRE_BOSQUE). Debe considerar que en la tabla
 * DESASTRE_BOSQUE se pueden haber actualizado los campos superficie_desastre_bosque y/o
 * id_desastre. Se debe realizar lo siguiente:
 * • Siempre que se actualice el campo superficie_desastre_bosque, deberá verificar que el nuevo valor de
 * superficie del desastre en el bosque no puede ser mayor al valor del campo superficie_bosque en la
 * tabla BOSQUE. Si es mayor, debe enviar un mensaje de error diciendo que el nuevo valor de superficie
 * de desastre en el bosque no puede ser mayor al valor de superficie del bosque y la operación no se
 * puede realizar.
 * • Si se actualiza sólo el campo superficie desastre en el bosque y el identificador del desastre es el mismo
 * (cambia el valor del campo superficie_desastre_bosque en la tabla DESASTRE-BOSQUE), deberá
 * actualizar el valor de la superficie total de desastre en la tabla DESASTRE para el registro que
 * corresponde (superficie_total_desastre).
 * • Si se actualizó el identificador del desastre (cambia el valor del campo id_desastre en la tabla
 * DESASTRE_BOSQUE) debe actualizar el campo superficie_total_desastre de la tabla DESASTRE
 * para el desastre anterior (old.id_desastre) y para el nuevo desastre al que corresponde el registro
 * (new.id_desastre).
 */

CREATE OR REPLACE FUNCTION actualiza_desastre_bosque()
	RETURNS TRIGGER AS $$

DECLARE
	superficie integer;

BEGIN
	SELECT INTO superficie superficie_bosque
	FROM bosque
	WHERE cod_bosque = new.cod_bosque;

	IF (new.superficie_desastre_bosque > superficie) THEN
		RAISE EXCEPTION 'La superficie de desastre bosque no puede ser mayor a la superficie del bosque';
		RETURN NULL;
	ELSE
		IF (new.id_desastre <> old.id_desastre) THEN
			UPDATE desastre
			SET superficie_total_desastre = superficie_total_desastre + new.superficie_desastre_bosque
			WHERE id_desastre = new.id_desastre;
			UPDATE desastre
			SET superficie_total_desastre = superficie_total_desastre - old.superficie_desastre_bosque
			WHERE id_desastre = old.id_desastre;
			RETURN new;
		ELSE
			UPDATE desastre
			SET superficie_total_desastre = superficie_total_desastre + new.superficie_desastre_bosque -
											 old.superficie_desastre_bosque
			WHERE id_desastre = new.id_desastre;
			RETURN new;
		END IF;
	END IF;
	
END; $$ LANGUAGE 'plpgsql';

CREATE TRIGGER actualiza_desastre_bosque
BEFORE UPDATE ON desastre_bosque
FOR EACH ROW EXECUTE FUNCTION actualiza_desastre_bosque();

/*
 * 2.3. Cree un Trigger que se ejecute cada vez que se actualice un registro de una mantención asociada a una
 * instalación (ACTUALIZA un registro en la tabla MANTENCION_INSTALACION). Debe considerar que
 * en la tabla MANTENCION_INSALCION se pueden haber actualizado los campos superficie_mantencion
 * y/o rut_contratista. Se debe realizar lo siguiente:
 * • Siempre que se actualice el campo superficie_mantencion, deberá verificar que el nuevo valor de
 * superficie de la mantención en la instalación no puede ser mayor al valor del campo
 * superficie_instalación en la tabla INSTALACION. Si es mayor, debe enviar un mensaje de error
 * diciendo que el nuevo valor de superficie de mantencion no puede ser mayor al valor de superficie de
 * la instalación y la operación no se puede realizar.
 * • Si se actualiza sólo el campo superficie de mantencion y el rut del contratista es el mismo (cambia el
 * valor del campo superficie_mantencion en la tabla MANTENCION_INSTALACION), deberá
 * actualizar el valor de la superficie total de mantención en la tabla CONTRATISTA_MANTENCION
 * para el registro que corresponde (superficie_total_mantencion).
 * • Si se actualizó el rut del contratista (cambia el valor del campo rut_contratista en la tabla
 * MANTENCION_INSTALACIÓN debe actualizar el campo superficie_total_mantencion de la tabla
 * CONTRATISTA_MANTENCION para el contratista anterior (old.rut_contratista) y para el nuevo
 * contratista al que corresponde el registro (new.rut_contratista).
 */

CREATE OR REPLACE FUNCTION actualiza_mantencion_instalacion()
	RETURNS TRIGGER AS $$
	
DECLARE
	superficie integer;

BEGIN
	SELECT INTO superficie superficie_instalacion
	FROM instalacion
	WHERE cod_instalacion = new.cod_instalacion;

	IF (new.superficie_mantencion > superficie) THEN
		RAISE EXCEPTION 'La superficie de mantención de instalacion no puede ser mayor a la superficie de la instalacion';
		RETURN NULL;
	ELSE
		IF (new.rut_contratista <> old.rut_contratista) THEN
			UPDATE contratista_mantencion
			SET superficie_total_mantencion = superficie_total_mantencion + new.superficie_mantencion
			WHERE rut_contratista = new.rut_contratista;

			UPDATE contratista_mantencion
			SET superficie_total_mantencion = superficie_total_mantencion - old.superficie_mantencion
			WHERE rut_contratista = old.rut_contratista;

			RETURN new;
		ELSE
			UPDATE contratista_mantencion
			SET superficie_total_mantencion = superficie_total_mantencion + new.superficie_mantencion -
											   old.superficie_mantencion
			WHERE rut_contratista = old.rut_contratista;
			RETURN new;
		END IF;
	END IF;
	
END; $$ language 'plpgsql';

CREATE TRIGGER actualiza_mantencion_instalacion
BEFORE UPDATE ON mantencion_instalacion
FOR EACH ROW EXECUTE FUNCTION actualiza_mantencion_instalacion();

-- PREGUNTA 3 --
/*
 * 3.1. Cree una vista donde aparezca para cada predio la cantidad de instalaciones que tiene con la superficie total
 * de instalaciones, además de la cantidad faenas con la superficie total faenas.
 * Deben aparecer todos los predios con todos sus datos además de la cantidad de instalaciones, superficie
 * total de instalaciones, cantidad de faenas y superficie total de faenas.
 */

CREATE OR REPLACE VIEW datos_predios1 AS
	SELECT predio.*, cantidad_instalacion, sup_instalacion_predio, cantidad_faena, sup_faena_predio
	FROM predio LEFT JOIN (SELECT cod_predio, COUNT(cod_instalacion) AS cantidad_instalacion,
						   SUM(superficie_instalacion) AS sup_instalacion_predio
 						   FROM instalacion
						   GROUP BY cod_predio) AS instalaciones_predio USING (cod_predio)
				LEFT JOIN (SELECT cod_predio, COUNT(id_faena) AS cantidad_faena, SUM(superficie_faena) AS sup_faena_predio
 						   FROM faena JOIN bosque USING(cod_bosque)
						   GROUP BY cod_predio) AS faena_predio ON (faena_predio.cod_predio = predio.cod_predio);

/*
 * 3.2. Cree una vista donde aparezca para cada predio la cantidad de instalaciones que tiene con la superficie total
 * de instalaciones, además de la cantidad desastres en sus bosques, con la superficie total de desastre ocurrido
 * en sus bosques.
 * Deben aparecer todos los predios con todos sus datos además de la cantidad de instalaciones, superficie
 * total de instalaciones, cantidad de desastre en bosque y superficie total de desastre en bosque.
 */

CREATE OR REPLACE VIEW datos_predios2 AS
	SELECT predio.*, cantidad_instalacion, sup_instalacion_predio, cantidad_desastre_bosque, sup_desastre_bosque
	FROM predio LEFT JOIN (SELECT cod_predio, COUNT(cod_instalacion) AS cantidad_instalacion,
						   SUM(superficie_instalacion) AS sup_instalacion_predio
 						   FROM instalacion
						   GROUP BY cod_predio) AS instalaciones_predio USING (cod_predio)
				LEFT JOIN (SELECT cod_predio, COUNT(id_desastre) AS cantidad_desastre_bosque,
						   SUM(superficie_desastre_bosque) AS sup_desastre_bosque
 						   FROM desastre_bosque JOIN bosque USING(cod_bosque)
						   GROUP BY cod_predio) AS desastre_predio ON (desastre_predio.cod_predio = predio.cod_predio);

/*
 * 3.3. Cree una vista donde aparezca para cada predio la cantidad de mantenciones de sus instalaciones con la
 * superficie total de mantenciones en sus instalaciones, además de la cantidad bosques con la superficie total
 * de bosques que tiene.
 * Deben aparecer todos los predios con todos sus datos además de la cantidad de mantenciones, superficie
 * total de mantenciones del predio, cantidad de bosques y superficie total de bosques.
 */

CREATE OR REPLACE VIEW datos_predios3 AS
	SELECT predio.*, cantidad_mantencion, sup_mantencion_predio, cantidad_bosque, sup_bosque_predio
	FROM predio LEFT JOIN (SELECT cod_predio, COUNT(cod_mantencion) AS cantidad_mantencion,
						   SUM(superficie_mantencion) AS sup_mantencion_predio
 						   FROM instalacion JOIN mantencion_instalacion USING (cod_instalacion)
						   GROUP BY cod_predio) AS mantenciones_predio USING (cod_predio)
				LEFT JOIN (SELECT cod_predio, COUNT(cod_bosque) AS cantidad_bosque,
						   SUM(superficie_bosque) AS sup_bosque_predio
 						   FROM bosque
						   GROUP BY cod_predio) AS bosque_predio ON (bosque_predio.cod_predio = predio.cod_predio);