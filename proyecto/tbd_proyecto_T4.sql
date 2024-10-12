/* Proyecto P. 2 - Sistemas de Base de Datos de Estadísticas de Cultura */
/* Taller de Bases de Datos (IN1078C) */

/*
 * T.4. Cree un trigger para que cada vez que se modifica la organización que administra un monumento
 * nacional, se verifique que la nueva organización se localice en la misma comuna que la organización anterior.
 */

-- Función que usará el Trigger
CREATE OR REPLACE FUNCTION verificar_comuna_organizacion()
	RETURNS TRIGGER AS $$
	
DECLARE
    comuna_anterior int;
    comuna_nueva int;
	
BEGIN
    SELECT INTO comuna_anterior entidad.cod_comuna
    FROM organizacion
    JOIN entidad ON(organizacion.id_organizacion = entidad.id_entidad)
    WHERE organizacion.id_organizacion = old.id_organizacion;
    
    SELECT INTO comuna_nueva entidad.cod_comuna
    FROM organizacion
    JOIN entidad ON(organizacion.id_organizacion = entidad.id_entidad)
    WHERE organizacion.id_organizacion = new.id_organizacion;
    
    IF (comuna_anterior <> comuna_nueva) THEN
        RAISE EXCEPTION 'La nueva organización debe localizarse en la misma comuna de la organización anterior.';
    END IF;
    
    RETURN NEW;

END; $$ LANGUAGE plpgsql;

-- Trigger que llama a la Función cuando se actualiza monumento_nacional
CREATE TRIGGER verificar_comuna_organizacion_t
BEFORE UPDATE ON monumento_nacional
FOR EACH ROW EXECUTE FUNCTION verificar_comuna_organizacion();