/* Test 1 (2020) | Taller de Bases de Datos (IN1078C) */

/*
 * 1. Seleccione los datos de cada cliente con el monto total de los movimientos de su cuenta corriente 
 * que son de tipo_movimiento ‘cargo’, con los siguientes datos: rut, nombre, numero_cuenta, monto 
 * total cargos. Deben aparecer todos los clientes.
 */

-- Al filtrar por cargo se eliminan las entidades que no tienen tipo cargo
SELECT rut, nombre, numero_cuenta, SUM(monto) AS monto
FROM cliente LEFT JOIN cuenta_corriente USING(rut)
LEFT JOIN movimiento_cuenta USING(numero_cuenta)
WHERE tipo_movimiento = 'cargo'
GROUP BY rut, numero_cuenta;

-- Se reemplaza la tabla movimiento_cuenta por una que solo registre los cargos
SELECT rut, nombre, numero_cuenta, SUM(monto) AS monto
FROM cliente LEFT JOIN cuenta_corriente USING(rut)
LEFT JOIN (SELECT numero_cuenta, monto
		   FROM movimiento_cuenta
		   WHERE tipo_movimiento = 'cargo') AS tablal
USING(numero_cuenta)
GROUP BY rut, numero_cuenta;

/*
 * 2. Seleccione los datos de los movimientos de la cuenta corriente que tiene el mayor saldo
 * con los siguientes datos: numero_cuenta, rut, saldo_cuenta, id_movimiento, monto, tipo_movimiento. 
 * Ordenados de mayor a menor por monto.
 */

SELECT numero_cuenta, rut, saldo_cuenta      -- cuenta_corriente
       id_movimiento, monto, tipo_movimiento -- movimiento_cuenta
FROM cuenta_corriente JOIN movimiento_cuenta USING(numero_cuenta)
WHERE saldo_cuenta = (SELECT MAX(saldo_cuenta) FROM cuenta_corriente)
ORDER BY monto DESC;

-- Buscar el mayor
SELECT MAX(saldo_cuenta) FROM cuenta_corriente;

/*
 * 3. Seleccione los datos de la cuenta corriente que registra 2 o más movimientos de tipo_movimiento 
 * 'abono', con: numero_cuenta, nombre_banco, rut, nombre cliente, saldo_cuenta.
 */

SELECT cuenta_corriente.numero_cuenta, 
	   banco.nombre, cliente.rut, cliente.nombre, saldo_cuenta
FROM banco JOIN cliente USING(codigo)
JOIN cuenta_corriente USING(rut)
JOIN movimiento_cuenta USING(numero_cuenta)
WHERE tipo_movimiento = 'abono'
GROUP BY cuenta_corriente.numero_cuenta, cliente.rut, banco.codigo
HAVING COUNT(id_movimiento) >= 2;

-- Otra opción calculando por separado
SELECT numero_cuenta, cliente.nombre, cliente.rut, banco.nombre, saldo_cuenta
FROM banco JOIN cliente USING(codigo)
JOIN cuenta_corriente USING(rut)
WHERE numero_cuenta IN (SELECT numero_cuenta FROM movimiento_cuenta
						WHERE tipo_movimiento = 'abono'
					    GROUP BY numero_cuenta
						HAVING COUNT(id_movimiento) >= 2);

SELECT numero_cuenta FROM movimiento_cuenta
WHERE tipo_movimiento = 'abono'
GROUP BY numero_cuenta
HAVING COUNT(id_movimiento) >= 2;

/*
 * 4. Listar todos los clientes con la suma de los saldos de sus cuentas corrientes y de sus tarjetas
 * de crédito. Deben aparecer todos los clientes con rut, nombre, salto total (suma de todos los 
 * saldos de cuentas y tarjetas).
 */

-- Tarjeta de credito
SELECT SUM(saldo_tarjeta) AS mt, rut
FROM tarjeta_credito
GROUP BY rut;

-- Cuenta corriente
SELECT SUM(saldo_cuenta) AS mt, rut
FROM cuenta_corriente
GROUP BY rut;

-- Respuesta
SELECT rut, nombre, COALESCE(mt,0) + COALESCE(mc,0) AS saldo_total
FROM cliente LEFT JOIN (SELECT SUM(saldo_tarjeta) AS mt, rut
						FROM tarjeta_credito
						GROUP BY rut) AS t1 USING(rut)
LEFT JOIN (SELECT SUM(saldo_cuenta) AS mc, rut
		   FROM cuenta_corriente
		   GROUP BY rut) AS t2 USING(rut);
		  
/*
 * 5. Seleccione para cada cliente los montos totales comprados en sus tarjetas de credito, por año.
 * Deben aparecer todos los clientes con: rut, nombre, numero_tarjeta, año, total comprado. Ordenado por 
 * rut.
 */
		  
-- Solo clientes con compras
SELECT cliente.rut, cliente.nombre,
       tarjeta_credito.numero_tarjeta, 
       date_part('year',movimiento_tarjeta.fecha),
       SUM(monto) AS total
FROM cliente JOIN tarjeta_credito USING(rut)
JOIN movimiento_tarjeta USING(numero_tarjeta)
WHERE tipo_movimiento = 'compra'
GROUP BY cliente.rut, 
         tarjeta_credito.numero_tarjeta,
         date_part('year', movimiento_tarjeta.fecha);

-- Outer JOIN para que aparezca todo
SELECT cliente.rut, cliente.nombre, -- Desde tabla cliente
       tarjeta_credito.numero_tarjeta, 
	   anio,
	   total
FROM cliente LEFT JOIN tarjeta_credito USING(rut)
LEFT JOIN (SELECT cliente.rut,  
	       date_part('year', movimiento_tarjeta.fecha) AS anio,
	       SUM(monto) AS total
	FROM cliente JOIN tarjeta_credito USING(rut)
	JOIN movimiento_tarjeta USING(numero_tarjeta)
	WHERE tipo_movimiento = 'compra'
	GROUP BY cliente.rut, 
	         tarjeta_credito.numero_tarjeta,
	         date_part('year', movimiento_tarjeta.fecha)) AS tablal USING(rut);

/*
 * 6. Seleccione todos los clientes con la suma de los saldos de sus tarjetas de crédito y de sus 
 * cuentas corrientes. Deben aparecer todos los clientes con rut, nombre, saldo total tarjetas, saldo 
 * total cuentas.
 */
	        
SELECT cliente.rut, cliente.nombre,
	   total_tarjeta, total_cuentas
FROM cliente LEFT JOIN (SELECT rut, SUM(saldo_cuenta) AS total_cuentas
						FROM cuenta_corriente GROUP BY rut) AS cc USING(rut)
LEFT JOIN (SELECT rut, SUM(saldo_tarjeta) AS total_tarjeta
           FROM tarjeta_credito GROUP BY rut) AS tc USING(rut);
           
/*
 * 7. Seleccione para cada banco el nombre del cliente que tiene un menor saldo en su cuenta_corriente. 
 * Debe aparecer el codigo, nombre cliente que tiene el menor saldo en cuenta corriente.
 */

-- Menor saldo de cuenta por banco
SELECT codigo, MIN(saldo_cuenta) AS el_saldo
FROM banco JOIN cliente USING(codigo)
JOIN cuenta_corriente USING(rut);

-- Respuesta
SELECT codigo, cliente.nombre
FROM cliente JOIN cuenta_corriente USING(rut)
JOIN (SELECT codigo, MIN(saldo_cuenta) AS el_saldo
	  FROM banco JOIN cliente USING(codigo)
	  JOIN cuenta_corriente USING(rut)
	  GROUP BY codigo) AS tablal 
	  USING(codigo)
WHERE saldo_cuenta = el_saldo;

/*
 * 8. Listar los datos de los clientes que están utilizando más de la mitad del monto aprobado de su línea
 * de crédito. Debe aparecer rut, nombre cliente, numero_cuenta,  id_linea, monto_aprobado, porcentaje de
 * utilización.
 */

SELECT rut, nombre, numero_cuenta,
	   id_linea, monto_aprobado,
	   ((monto_utilizado / monto_aprobado) * 100)
FROM cliente JOIN cuenta_corriente USING(rut) JOIN linea_credito USING(numero_cuenta)
WHERE monto_utilizado > monto_aprobado / 2;

/*
 * 9. Seleccione para cada banco la cantidad total de clientes que tienen tarjeta de crédito y cuenta
 * corriente (ambos productos). Debe aparecer código, nombre del banco, cantidad de clientes.
 */
	  
SELECT codigo, banco.nombre, COUNT(rut)
FROM banco LEFT JOIN cliente USING(codigo)
WHERE rut IN (SELECT DISTINCT rut FROM cuenta_corriente)
AND   rut IN (SELECT DISTINCT rut FROM tarjeta_credito)
GROUP BY codigo;

/*
 * 10. Seleccione todos los clientes que no tuvieron movimientos en sus tarjetas de crédito el año 
 * 2018. Debe aparecer rut, nombre cliente, número de tarjeta.
 */

-- Clientes que tienen movimientos en su tarjeta de credito el 2018
SELECT DISTINCT rut
FROM movimiento_tarjeta JOIN tarjeta_credito USING(numero_tarjeta)
WHERE fecha >= '01-01-2018'
AND fecha < '01-01-2019';

-- Se debe utilizar LEFT JOIN en caso de que intere tambien los clientes
-- que no han hecho movimientos el 2018 porque no tienen tc
SELECT rut, nombre, numero_tarjeta
FROM cliente JOIN tarjeta_credito USING(rut)
WHERE rut NOT IN (SELECT DISTINCT rut
				  FROM movimiento_tarjeta JOIN tarjeta_credito USING(numero_tarjeta)
				  WHERE fecha >= '01-01-2018'
				  AND fecha < '01-01-2019');

/*
 * 11. Seleccione los datos de la o las cuentas corrientes que tuvieron, el año 2018, una cantidad
 * de movimientos mayor a la cantidad promedio de los movimientos de las cuentas el año 2018. Debe
 * aparecer numero_cuenta, rut, saldo_cuenta.
 */

SELECT numero_cuenta, rut, saldo_cuenta
FROM cuenta_corriente JOIN movimiento_cuenta USING(numero_cuenta)
WHERE date_part('year', fecha) = 2018
GROUP BY numero_cuenta
HAVING COUNT(id_movimiento) >
(SELECT trunc(AVG(cantidad), 0) AS promedio
 FROM  (SELECT numero_cuenta, COUNT(id_movimiento) AS cantidad
		FROM movimiento_cuenta
		WHERE date_part('year', fecha) = 2018
		GROUP BY numero_cuenta) AS cantidad_movto);

/*
 * 12. Listar todos los clientes que tienen cuenta corriente que registran movimientos, pero no 
 * tienen línea de crédito. Debe aparecer rut, nombre, numero_cuenta, nombre del banco, saldo_cuenta.
 */

-- Clientes que tienen cuenta corriente con movimientos
SELECT DISTINCT rut
FROM cuenta_corriente JOIN movimiento_cuenta USING(numero_cuenta);
			 
SELECT rut, cliente.nombre,         -- cliente
	   numero_cuenta, saldo_cuenta, -- cuenta_corriente
	   banco.nombre 				-- banco
FROM cliente JOIN cuenta_corriente USING(rut)
JOIN banco USING(codigo)
WHERE rut IN (SELECT DISTINCT rut
			  FROM cuenta_corriente JOIN movimiento_cuenta USING(numero_cuenta))
AND numero_cuenta NOT IN (SELECT numero_cuenta FROM linea_credito);

/*
 * 13. Seleccione la cantidad total de movimientos por tipo de movimiento ocurridos mensualmente en cada
 * tarjeta de crédito durante el año 2019. Debe aparecer numero_tarjeta, tipo_movimiento, mes, cantidad de
 * movimientos.
 */
                                                             
SELECT numero_tarjeta, tipo_movimiento,
	   date_part('month', fecha), COUNT(id_movimiento)
FROM tarjeta_credito JOIN movimiento_tarjeta USING(numero_tarjeta)
WHERE date_part('year', fecha) = 2019
GROUP BY numero_tarjeta, tipo_movimiento, date_part('month', fecha);

/*
 * 14. Seleccione los datos de las cuentas corrientes que tuvieron un monto total de cargos mayor al
 * monto total de abonos, durante el año 2019. Debe aparecer el numero_cuenta, rut, saldo_cuenta,
 * monto total cargos, monto total abonos.
 */

SELECT numero_cuenta, rut, saldo_cuenta,
	   (SELECT SUM(monto) FROM movimiento_cuenta 
		WHERE date_part('year', fecha) = 2019 AND tipo_movimiento = 'cargo'
		AND numero_cuenta = cuenta_corriente.numero_cuenta) AS total_cargos, 
	   (SELECT SUM(monto) FROM movimiento_cuenta 
		WHERE date_part('year', fecha) = 2019 AND tipo_movimiento = 'abono'
	    AND numero_cuenta = cuenta_corriente.numero_cuenta) AS total_abonos
FROM cuenta_corriente
WHERE (SELECT SUM(monto) FROM movimiento_cuenta 
	   WHERE date_part('year', fecha) = 2019 AND tipo_movimiento = 'cargo'
	   AND numero_cuenta = cuenta_corriente.numero_cuenta) >
	  (SELECT SUM(monto) FROM movimiento_cuenta 
	   WHERE date_part('year', fecha) = 2019 AND tipo_movimiento = 'abono'
	   AND numero_cuenta = cuenta_corriente.numero_cuenta);
			 
/*
 * 15. Seleccione para cada cliente la cantidad total de movimientos en cuentas corrientes y en en tarjetas de
 * crédito. Deben aparecer todos los clientes con rut, nombre, cantidad movimientos en tarjetas, cantidad
 * movimientos en cuentas.
 */

SELECT rut, nombre, 
	   m_tc AS cantidad_movimientos_t,
	   m_cc AS cantidad_movimientos_c
FROM cliente
LEFT JOIN (SELECT rut, COUNT(DISTINCT id_movimiento) AS m_cc
	  	   FROM cuenta_corriente JOIN movimiento_cuenta USING(numero_cuenta)
		   GROUP BY rut) AS tabla_1 USING(rut)
LEFT JOIN (SELECT rut, COUNT(DISTINCT id_movimiento) AS m_tc
	  	   FROM tarjeta_credito JOIN movimiento_tarjeta USING(numero_tarjeta)
	  	   GROUP BY rut) AS tabla_2 USING(rut);
	   
SELECT rut, COUNT(DISTINCT id_movimiento) AS m_cc
FROM cuenta_corriente JOIN movimiento_cuenta USING(numero_cuenta)
GROUP BY rut; 

SELECT rut, COUNT(DISTINCT id_movimiento) AS m_tc
FROM tarjeta_credito JOIN movimiento_tarjeta USING(numero_tarjeta)
GROUP BY rut;

/*
 * 16. Seleccione los gastos que han realizado los clientes considerando que los gastos corresponden al
 * total de los cargos en sus cuentas corrientes, al total compras en sus tarjetas de crédito, y al total de pagos
 * de su línea de crédito. Debe aparecer rut, nombre, total cargos, total compras, total pagos linea.
 */

SELECT rut, nombre,
(SELECT SUM(movimiento_cuenta.monto)::integer AS cargo_cuenta
 FROM  cuenta_corriente JOIN movimiento_cuenta USING(numero_cuenta)
 WHERE tipo_movimiento = 'cargo'
 AND   rut = cliente.rut),
(SELECT SUM(movimiento_cuenta.monto)::integer AS pago_linea_cuenta
 FROM  cuenta_corriente JOIN movimiento_cuenta USING(numero_cuenta)
 WHERE tipo_movimiento = 'pago_linea'
 AND   rut = cliente.rut),
(SELECT SUM(movimiento_tarjeta.monto) AS compra_tarjeta
 FROM  tarjeta_credito JOIN movimiento_tarjeta USING(numero_tarjeta)
 WHERE tipo_movimiento = 'compra'
 AND   rut = cliente.rut)
FROM cliente