/* Test 1 (2024) - Taller de Bases de Datos (IN1078C) */

-- PREGUNTA 1 --

/* 
 * 1. Seleccione los datos de todas las categorías con las cantidades totales vendidas de cada
 * producto que tiene stock bajo 50. Debe aparecer nombre de la categoría, nombre del producto y
 * cantidad total vendida de producto con stock bajo 50. Deben aparecer todas las categorías.
 */

SELECT nombre_categoria, nombre_producto, SUM(cantidad)
FROM categoria LEFT JOIN producto
     ON (producto.id_categoria = categoria.id_categoria AND stock < 50)
     LEFT JOIN detalle_venta USING (id_producto)
GROUP BY nombre_categoria, nombre_producto;

/*
 * 2. Seleccione los datos de todas las categorías con las cantidades totales compradas de cada
 * producto que tiene stock sobre 100. Debe aparecer nombre de la categoría, nombre del producto y
 * cantidad total comprada de producto con stock sobre 100. Deben aparecer todas las categorías.
 */

SELECT nombre_categoria, nombre_producto, SUM(cantidad)
FROM categoria LEFT JOIN producto
     ON (producto.id_categoria = categoria.id_categoria AND stock > 100)
     LEFT JOIN compra USING (id_producto)
GROUP BY nombre_categoria, nombre_producto;

/*
 * 3. Seleccione los datos de todas las tiendas con el monto total de ventas al contado que han
 * realizado sus empleados. Debe aparecer: nombre tienda, nombre empleado y monto total de ventas
 * al contado. Deben aparecer todas las tiendas.
 */

SELECT nombre_tienda, nombre_empleado, monto_total
FROM tienda LEFT JOIN (SELECT empleado.rut_empleado, id_tienda,
                       nombre_empleado, SUM(monto_venta) AS monto_total
                       FROM empleado JOIN venta USING (rut_empleado)
                       WHERE tipo_pago = 'contado'
                       GROUP BY empleado.rut_empleado) USING (id_tienda);

/*
 * 4. Seleccione los datos de todos los clientes con la cantidad total de los productos de las
 * ventas pagadas con credito. Debe aparecer: nombre cliente, id_venta, monto_venta y cantidad
 * total de los productos de las ventas pagadas con credito. Deben aparecer todos los clientes.
 */

SELECT nombre_cliente, id_venta, monto_venta, SUM(cantidad)
FROM cliente LEFT JOIN venta
     ON (venta.rut_cliente = cliente.rut_cliente AND tipo_pago = 'credito')
     LEFT JOIN detalle_venta USING (id_venta)
GROUP BY nombre_cliente, id_venta;

/*
 * 5. Seleccione los datos de todos los empleados con la cantidad total de los productos de sus
 * ventas que están en preparacion. Debe aparecer: nombre empleado, id_venta, fecha_venta y
 * cantidad total de los productos aun en preparacion. Deben aparecer todos los empleados.
 */

SELECT nombre_empleado, id_venta, fecha_venta, SUM(cantidad)
FROM empleado LEFT JOIN venta
     ON (venta.rut_empleado = empleado.rut_empleado AND estado_venta = 'en preparacion')
     LEFT JOIN detalle_venta USING (id_venta)
GROUP BY nombre_empleado, id_venta;

-- PREGUNTA 2 --

/*
 * 6. Seleccione los datos del o los proveedores a los cuales se le ha realizado el mayor número
 * de compras. Debe contener rut_proveedor, nombre proveedor, número de compras.
 */

SELECT rut_proveedor, nombre_proveedor, COUNT(id_compra)
FROM proveedor JOIN compra USING (rut_proveedor)
GROUP BY rut_proveedor
HAVING COUNT(id_compra) = (SELECT MAX(cantidad)
                           FROM (SELECT rut_proveedor, COUNT(id_compra) AS cantidad
                                 FROM compra
                                 GROUP BY rut_proveedor) AS cantidad_compra);

/*
 * 7. Seleccione los datos del o los empleados que han realizado un número de ventas mayor al
 * promedio del número de ventas de los empleados. Debe contener rut_empleado, nombre empleado,
 * número de ventas.
 */

SELECT rut_empleado, nombre_empleado, COUNT(id_venta)
FROM empleado JOIN venta USING (rut_empleado)
GROUP BY rut_empleado
HAVING COUNT(id_venta) > (SELECT AVG(cantidad)
                          FROM (SELECT rut_empleado, COUNT(id_venta) AS cantidad
                                FROM venta
                                GROUP BY rut_empleado) AS cantidad_venta);

/*
 * 8. Seleccione los datos del o los empleados que han realizado un número de compras menor al
 * promedio del número de compras de los empleados. Debe contener rut_empleado, nombre empleado,
 * número de compras.
 */

SELECT rut_empleado, nombre_empleado, COUNT(id_compra)
FROM empleado JOIN compra USING (rut_empleado)
GROUP BY rut_empleado
HAVING COUNT(id_compra) < (SELECT AVG(cantidad)
                           FROM (SELECT rut_empleado, COUNT(id_compra) AS cantidad
                           FROM compra
                           GROUP BY rut_empleado) AS cantidad_compra);

/*
 * 9. Seleccione los datos del o los clientes a los que se ha vendido el mayor número de ventas.
 * Debe contener rut cliente, nombre cliente, numero de ventas.
 */

SELECT rut_cliente, nombre_cliente, COUNT(id_venta)
FROM cliente JOIN venta USING (rut_cliente)
GROUP BY rut_cliente
HAVING COUNT(id_venta) = (SELECT MAX(cantidad)
                          FROM (SELECT rut_cliente, COUNT(id_venta) AS cantidad
                          FROM venta
                          GROUP BY rut_cliente) AS cantidad_venta);

-- PREGUNTA 3 --

/*
 * 10. Seleccione para cada producto la cantidad total que se ha comprado y el monto total que se
 * ha vendido (monto = suma del precio por la cantidad). Debe aparecer todos los productos con
 * id_producto, nombre_producto, nombre_categoria, cantidad total comprada y monto total vendido.
 */

SELECT producto.id_producto, nombre_producto, nombre_categoria,
       (SELECT SUM(cantidad)
        FROM compra
        WHERE id_producto = producto.id_producto) AS cantidad_comprada,
       (SELECT SUM(cantidad * precio)
        FROM detalle_venta
        WHERE id_producto = producto.id_producto) AS monto_vendido
FROM categoria JOIN producto USING (id_categoria);

/*
 * 11. Seleccione para cada empleado el monto total vendido y el monto total que ha comprado
 * (monto = suma del precio por la cantidad). Debe aparecer todos los empleados con rut, nombre,
 * empleado, nombre tienda, monto total vendido y monto total comprado.
 */

SELECT empleado.rut_empleado, nombre_empleado, nombre_tienda,
       (SELECT SUM(monto_venta)
        FROM venta
        WHERE rut_empleado = empleado.rut_empleado) AS monto_vendido,
       (SELECT SUM(cantidad * precio)
        FROM compra
        WHERE rut_empleado = empleado.rut_empleado) AS monto_comprado
FROM tienda JOIN empleado USING (id_tienda);

/*
 * 12. Seleccione para cada producto la cantidad total que se ha vendido y el monto total que se
 * ha comprado (monto = suma del precio por la cantidad). Debe aparecer todos los productos con
 * id_producto, nombre_producto, nombre_categoria, cantidad total vendida y monto total comprado.
 */

SELECT producto.id_producto, nombre_producto, nombre_categoria,
       (SELECT SUM(cantidad)
        FROM detalle_venta
        WHERE id_producto = producto.id_producto) AS cantidad_vendida,
       (SELECT SUM(cantidad * precio)
        FROM compra
        WHERE id_producto = producto.id_producto) AS monto_comprado
FROM categoria JOIN producto USING (id_categoria);

-- PREGUNTA 4 --

/*
 * 13. Seleccione la cantidad de ventas y el monto total de las ventas que se han realizado para
 * cada cliente por cada tienda durante el año 2024. Debe aparecer rut cliente, nombre cliente,
 * nombre tienda, cantidad ventas, monto total ventas. Deben aparecer todos los clientes.
 */

SELECT cliente.rut_cliente, nombre_cliente, nombre_tienda,
       COUNT(id_venta), SUM(monto_venta)
FROM cliente LEFT JOIN venta
     ON (venta.rut_cliente = cliente.rut_cliente AND date_part('year', fecha_venta) = 2024)
     LEFT JOIN empleado USING (rut_empleado) LEFT JOIN tienda USING (id_tienda)
GROUP BY nombre_tienda, cliente.rut_cliente;

/*
 * 14. Seleccione la cantidad de productos que se han comprado y el monto total de las compras
 * (monto = precio * cantidad) a cada proveedor por cada categoría durante el año 2024. Debe
 * aparecer rut proveedor, nombre proveedor, nombre categoría, cantidad productos y monto total
 * de las compras. Deben aparecer todos los proveedores.
 */

SELECT proveedor.rut_proveedor, nombre_proveedor, nombre_categoria,
       SUM(cantidad), SUM(cantidad * precio)
FROM proveedor LEFT JOIN compra 
     ON (compra.rut_proveedor = proveedor.rut_proveedor AND date_part('year', fecha_compra) = 2024)
     LEFT JOIN producto ON (compra.id_producto = producto.id_producto)
     LEFT JOIN categoria USING (id_categoria)
GROUP BY nombre_categoria, proveedor.rut_proveedor;