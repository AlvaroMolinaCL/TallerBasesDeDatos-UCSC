/* Ejercicio Triggers: Base de Datos "Ordenes Mantenimiento" - Taller de Bases de Datos (IN1078C) */

/*
 * 1. Construya un trigger en la tabla REPUESTO_ORDEN para que cada vez que se INSERTA un nuevo repuesto a 
 * una orden de mantenimiento, se actualice el campo valor_total correspondiente en la tabla 
 * ORDEN_MANTENIMIENTO.
 */

CREATE OR REPLACE FUNCTION inserta_rep_orden()
RETURNS TRIGGER AS $$

DECLARE
    valor_rep integer;

BEGIN
    SELECT INTO valor_rep valor_repuesto
    FROM repuesto
    WHERE cod_repuesto = new.cod_repuesto;
    
    UPDATE orden_mantenimiento
    SET valor_total = valor_total + (new.cantidad_repuesto * valor_rep)
    WHERE orden_mantenimiento.cod_orden = new.cod_orden;
    
    RETURN new;

END; $$ LANGUAGE 'plpgsql';

CREATE TRIGGER inserta_rep_orden
BEFORE INSERT ON repuesto_orden
FOR EACH ROW EXECUTE PROCEDURE inserta_rep_orden();

/*
 * 2. Realice las modificaciones necesarias para que en el trigger anterior se verifique previamente que la 
 * cantidad de repuesto del nuevo registro, es menor o igual al stock_repuesto en la tabla REPUESTO.
 */

CREATE OR REPLACE FUNCTION inserta_rep_orden()
RETURNS TRIGGER AS $$

DECLARE
    valor_rep integer;
    stock_rep integer;

BEGIN
    SELECT INTO valor_rep, stock_rep valor_repuesto, stock_repuesto
    FROM repuesto
    WHERE cod_repuesto = new.cod_repuesto;
    
    IF (new.cantidad_repuesto <= stock_rep) THEN
        UPDATE orden_mantenimiento
        SET valor_total = valor_total + (new.cantidad_repuesto * valor_rep)
        WHERE orden_mantenimiento.cod_orden = new.cod_orden;
        
        RETURN new;
    ELSE
        RAISE EXCEPTION 'No hay suficiente stock';
        
        RETURN NULL;
    END IF;

END; $$ LANGUAGE 'plpgsql';

CREATE TRIGGER inserta_rep_orden
BEFORE INSERT ON repuesto_orden
FOR EACH ROW EXECUTE PROCEDURE inserta_rep_orden();

/*
 * 3. Nuevamente realice las modificaciones necesarias para que en el trigger anterior, si la cantidad de repuesto es 
 * menor o igual al stock del repuesto, además de actualizar el valor_total, reste del stock la cantidad utilizada.
 */

CREATE OR REPLACE FUNCTION inserta_rep_orden()
RETURNS TRIGGER AS $$

DECLARE
    valor_rep integer;
    stock_rep integer;

BEGIN
    SELECT INTO valor_rep, stock_rep valor_repuesto, stock_repuesto
    FROM repuesto
    WHERE cod_repuesto = new.cod_repuesto;
    
    IF (new.cantidad_repuesto <= stock_rep) THEN
	    UPDATE orden_mantenimiento
	    SET valor_total = valor_total + (new.cantidad_repuesto * valor_rep)
	    WHERE orden_mantenimiento.cod_orden = new.cod_orden;
	    
        UPDATE repuesto
	    SET stock_repuesto = stock_rep - new.cantidad_repuesto
	    WHERE repuesto.cod_repuesto = new.cod_repuesto;
	    
        RETURN new;
    ELSE
	    RAISE EXCEPTION 'No hay suficiente stock';
	    
        RETURN NULL;
    END IF;

END; $$ LANGUAGE 'plpgsql';

CREATE TRIGGER inserta_rep_orden
BEFORE INSERT ON repuesto_orden
FOR EACH ROW EXECUTE PROCEDURE inserta_rep_orden();

/*
 * 4. Realice un trigger similar al anterior pero que actualice los valores de valor_total y stock_repuesto, cada 
 * vez que se ELIMINA un registro en REPUESTO_ORDEN.
 */

CREATE OR REPLACE FUNCTION elimina_rep_orden()
RETURNS TRIGGER AS $$

DECLARE
    valor_rep integer;
    stock_rep integer;

BEGIN
    SELECT INTO valor_rep, stock_rep valor_repuesto, stock_repuesto
    FROM repuesto
    WHERE cod_repuesto = old.cod_repuesto;
    
    UPDATE orden_mantenimiento
    SET valor_total = valor_total - (old.cantidad_repuesto * valor_rep)
    WHERE orden_mantenimiento.cod_orden = old.cod_orden;
    
    UPDATE repuesto
    SET stock_repuesto = stock_rep + old.cantidad_repuesto
    WHERE repuesto.cod_repuesto = old.cod_repuesto;
    
    RETURN NULL;

END; $$ LANGUAGE 'plpgsql';

CREATE TRIGGER elimina_rep_orden
BEFORE DELETE ON repuesto_orden
FOR EACH ROW EXECUTE PROCEDURE elimina_rep_orden();

/*
 * 5. Realice un trigger similar al anterior pero que actualice el valor de valor_total en 
 * ORDEN_MANTENIMIENTO y stock_repuesto en REPUESTO, cada vez que se ACTUALIZA el valor de 
 * cantidad_repuesto en REPUESTO_ORDEN. Debe considerar que el valor de cantidad_repuesto puede 
 * disminuir o puede aumentar.
 */

CREATE OR REPLACE FUNCTION actualiza_rep_orden()
RETURNS TRIGGER AS $$

DECLARE
    valor_rep integer;
    stock_rep integer;
    cant_rep integer;

BEGIN
    SELECT INTO valor_rep, stock_rep, cant_rep valor_repuesto, stock_repuesto, cantidad_repuesto
    FROM repuesto, repuesto_orden
    
    IF (new.cantidad_repuesto <= stock_rep) THEN
	    WHERE cod_repuesto = new.cod_repuesto;
	    
        UPDATE orden_mantenimiento
	    SET valor_total = valor_total + (new.cantidad_repuesto * valor_rep)
	    WHERE orden_mantenimiento.cod_orden = new.cod_orden;
	    
        UPDATE repuesto
	    SET stock_repuesto = stock_rep - new.cantidad_repuesto
	    WHERE repuesto.cod_repuesto = new.cod_repuesto;
	
        RETURN new;
    ELSE
	    RAISE EXCEPTION 'No hay suficiente stock';
	    
        RETURN NULL;
    END IF;
    
    IF (old.cantidad_repuesto >= stock_rep) THEN
	    WHERE cod_repuesto = old.cod_repuesto;
	    
        UPDATE orden_mantenimiento
	    SET valor_total = valor_total - (old.cantidad_repuesto * valor_rep)
	    WHERE orden_mantenimiento.cod_orden = old.cod_orden;
	    
        UPDATE repuesto
	    SET stock_repuesto = stock_rep + old.cantidad_repuesto
	    WHERE repuesto.cod_repuesto = old.cod_repuesto;
	    
        RETURN NULL;
    END IF;

END; $$ LANGUAGE 'plpgsql';

CREATE TRIGGER actualiza_rep_orden
BEFORE UPDATE ON repuesto_orden
FOR EACH ROW EXECUTE PROCEDURE actualiza_rep_orden();