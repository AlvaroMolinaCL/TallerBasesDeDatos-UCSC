/* Ejercicios Triggers: Base de Datos "Red Social Simple" */
/* Taller de Bases de Datos (IN1078C) */

/*
 * 1. VERIFICACION: 
 * Por políticas de los moderadores se ha decidido que la palabra 'idiota' no puede estar presente en las
 * descripciones de las portadas de los perfiles. Cree un trigger que verifique que no se incluye dicha palabra en la descripción
 * cuando se ingresa un nuevo perfil (INSERT en perfil). En caso de encontrar la palabra, se debe abortar
 * el ingreso del perfil, imprimiendo un mensaje de error aclaratorio.
 */

CREATE OR REPLACE FUNCTION verificador_descripcion()
	RETURNS TRIGGER AS $$

BEGIN 
	IF (new.descripcion_portada LIKE '%idiota%') THEN 
		RAISE EXCEPTION 'Palabras altizonantes en la descripción';
	ELSE 
		RETURN new;
	END IF;

END; $$ LANGUAGE 'plpgsql';

CREATE TRIGGER verificador_descripcion_t
BEFORE INSERT ON perfil
FOR EACH ROW EXECUTE PROCEDURE verificador_descripcion();

-- Prueba
INSERT INTO public.perfil
(codigo, descripcion_portada, nombre, alias, fecha_registro, ultimo_ingreso)
VALUES (101, 'Hola idiotwas!', 'Roberto Juanito', 'Gran Roberto', current_date, current_date);

/*
 * 2. MODIFICACION DE DATOS:
 * Se requiere que los nombres de los perfiles se ingrecen utilizando solamente caracteres en mayúscula.
 * Cree un trigger que asegure que esto se cumpla siempre que se ingresa un perfil nuevo
 * (INSERT en perfil)
 */

CREATE OR REPLACE FUNCTION mayusculador()
	RETURNS TRIGGER AS $$

BEGIN 
	new.nombre := UPPER(new.nombre);
	RETURN new;

END; $$ LANGUAGE 'plpgsql';

CREATE TRIGGER mayusculador_t
BEFORE INSERT ON perfil
FOR EACH ROW EXECUTE PROCEDURE mayusculador();

/*
 * 3. ACTUALIZACION DE CAMPO EN OTRA TABLA:
 * Se ha decidido mantener un contador de respuestas para cada publicación registrada
 * (campo cantidad_respuestas en publicacion). Cree un Trigger que mantenga dicho campo actualizado 
 * cada vez que se elimina una respuesta (DELETE en respuesta).
 *
 */

-- Creacion de columna
ALTER TABLE public.publicacion ADD cantidad_respuestas integer NOT NULL DEFAULT 0;

-- Calculo de columna
UPDATE publicacion
SET cantidad_respuestas = (SELECT count(codigo)
						   FROM respuesta
						   WHERE publicacion.codigo = respuesta.publicacion);
						   
CREATE OR REPLACE FUNCTION actualizador_cantidad_delete()
	RETURNS TRIGGER AS $$

BEGIN
	UPDATE publicacion
	SET cantidad_respuestas = cantidad_respuestas - 1
	WHERE codigo = old.publicacion;

	RETURN NULL;

END; $$ LANGUAGE 'plpgsql';

CREATE TRIGGER actualizador_cantidad_delete_t
AFTER DELETE ON respuesta
FOR EACH ROW EXECUTE PROCEDURE actualizador_cantidad_delete();

/*
 * 4. PREVENIR INGRESO DE DATOS:
 * Para promover el debate en la red social, se ha decidido impedir todos los bloqueos.
 * Cree un trigger que asegure que se cumpla con esta nueva politica (INSERT en bloquea).
 * Nota: No utilizar excepciones
 */

CREATE OR REPLACE FUNCTION no_bloqueos()
	RETURNS TRIGGER AS $no_bloqueos$

BEGIN
	RETURN NULL;
	
END; $no_bloqueos$ LANGUAGE 'plpgsql';

CREATE TRIGGER no_bloqueos_T
BEFORE INSERT ON bloquea
FOR EACH ROW EXECUTE PROCEDURE no_bloqueos();

-- Prueba
INSERT INTO public.bloquea (bloqueado,bloqueador,fecha,razon) 
VALUES (3 , 1, current_timestamp, 'Prueba que no debe poder ingresarse');