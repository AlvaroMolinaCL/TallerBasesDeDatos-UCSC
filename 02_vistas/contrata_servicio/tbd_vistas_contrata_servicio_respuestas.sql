/* Ejercicios Vistas: Base de Datos "Contrata Servicio" */
/* Taller de Bases de Datos (IN1078C) */

/*
 * 1. Ejercicio 5 JOIN y Subquery: Seleccionar a todos los clientes 
 * junto  al  número  total  de  servicios  a  los  que  pueden  acceder 
 * (revisar  las  zonas  donde  está  disponible  cada  servicio  y  la  zona 
 * asociada al cliente). Ordernar de mayor a menor según el número 
 * de servicios.
 */

SELECT rut, cliente.nombre, COUNT(codigo_servicio) AS servicios
FROM cliente LEFT JOIN zona ON(zona = codigo)
     LEFT JOIN disponibilidad ON(codigo_zona = codigo)
GROUP BY rut
ORDER BY servicios DESC;

-- Vista
CREATE OR REPLACE VIEW vista_clientes
AS (SELECT rut, cliente.nombre, COUNT(codigo_servicio) AS servicios
    FROM cliente LEFT JOIN zona ON(zona = codigo)
         LEFT JOIN disponibilidad ON(codigo_zona = codigo)
    GROUP BY rut
    ORDER BY servicios DESC);

SELECT * FROM vista_clientes;

/*
 * 2. Cree las vistas necesarias para que se muestren unicamente los datos de las zonas 
 * de la ciudad de Concepción ("Concepcion" en la BD) y los servicios asociados a estas.
 */

-- Tablas de zona y servicio respectivamente
SELECT * FROM zona
WHERE ciudad = 'Concepcion';

SELECT DISTINCT servicio.* 
FROM servicio JOIN disponibilidad ON (servicio.codigo = codigo_servicio)
JOIN zona ON (zona.codigo = codigo_zona)
WHERE ciudad = 'Concepcion';

-- Vistas
CREATE OR REPLACE VIEW zona_concepcion
AS (SELECT * FROM zona
    WHERE ciudad = 'Concepcion');

CREATE OR REPLACE VIEW servicio_concepcion
AS (SELECT DISTINCT servicio.* 
    FROM servicio JOIN disponibilidad ON (servicio.codigo = codigo_servicio)
    JOIN zona ON (zona.codigo = codigo_zona)
    WHERE ciudad = 'Concepcion');

SELECT * FROM zona_concepcion;
SELECT * FROM servicio_concepcion;

/*
 * 3. Cree una vista de nombre "contratos_caducados" que contenga todos los contratos
 * que han caducado (contratos cuya fecha de términos e ha cumplido), y otra de nombre 
 * "contratos_activos" para todos los contratos que no han caducado. Ambas vistas deben
 * contener las mismas columnas de la tabla contrato.
 */

CREATE VIEW contratos_caducados
AS (SELECT * FROM contrato WHERE fecha_termino < CURRENT_DATE)

CREATE VIEW contratos_activos_2
AS (SELECT * FROM contrato WHERE fecha_termino >= CURRENT_DATE)

SELECT * FROM contratos_caducados;
SELECT * FROM contratos_activos_2;

/*
 * 4. Crear una vista que muestre todos los servicios junto a la cantidad de contratos.
 * La vista debe contener el código del servicio, el nombre del servicio y la cantidad 
 * de contratos; además debe ser nombrada como "servicios_contratos".
 */

-- Utilizar * en el COUNT contará tambien las filas con contrato nulo
SELECT servicio.codigo, servicio.nombre, COUNT(*) AS disponibles
FROM contrato RIGHT JOIN servicio ON (servicio = servicio.codigo)
GROUP BY servicio.codigo;

-- Contando los codigos de contrato, se ignoraran las filas con contratos nulos
SELECT servicio.codigo, servicio.nombre, COUNT(contrato.codigo) AS disponibles
FROM contrato RIGHT JOIN servicio ON (servicio = servicio.codigo)
GROUP BY servicio.codigo;

-- Vista
CREATE OR REPLACE VIEW servicios_contratos
AS (SELECT servicio.codigo, servicio.nombre, COUNT(contrato.codigo) AS disponibles
    FROM contrato RIGHT JOIN servicio ON (servicio = servicio.codigo)
    GROUP BY servicio.codigo);

SELECT * FROM servicios_contratos;

/*
 * 5. Cree una vista similar a la del ejercicio 5, pero esta vez solo deben considerarse 
 * los contratos activos (contratos que no han caducado). Nomrar la vista como 
 * "contratos_activos".
 */

-- No funciona ya que, debido al WHERE, son eliminadas las filas que no cumplen la condición
SELECT servicio.codigo, servicio.nombre, COUNT(contrato.codigo) AS disponibles
FROM contrato RIGHT JOIN servicio ON (servicio = servicio.codigo)
WHERE fecha_termino >= CURRENT_DATE 
GROUP BY servicio.codigo;

-- Utilizando subconsulta para filtrar antes del JOIN
CREATE OR REPLACE VIEW contratos_activos 
AS (SELECT servicio.codigo, servicio.nombre, COUNT(tablal.codigo) AS disponibles
	FROM (SELECT * FROM contrato
	      WHERE fecha_termino >= CURRENT_DATE) AS tablal
	RIGHT JOIN servicio ON (servicio = servicio.codigo)
	GROUP BY servicio.codigo);

SELECT * FROM contratos_activos;