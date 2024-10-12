/* Ejercicios Subconsultas: Base de Datos "Libros y Editoriales" - Taller de Bases de Datos (IN1078C) */

/*
 * 1. Consulta simple: seleccione todos los libros registrados,
 * mostrando solo el título y su autor.
 */

SELECT titulo, autor
FROM libro;

/*
 * 2. Consulta simple con más de una tabla: seleccione los libros
 * registrados, junto a la siguiente información: título, nombre del
 * autor, año y tipo de libro.
 */

SELECT titulo, tipo, nombre, anio
FROM libro, autor
WHERE autor = seudonimo;

/*
 * 3. Consulta de varias tablas y con condiciones: seleccione los
 * autores que han sido publicados por la editorial “Editorial Azul”.
 * Debe aparecer solo el seudónimo del autor y el título del libro,
 * además de estar ordenados alfabéticamente por el autor.
 */

SELECT autor.nombre, seudonimo
FROM libro, autor, publicacion, editorial
WHERE seudonimo = autor
AND id_libro = id
AND editorial = editorial.nombre
AND editorial.nombre = 'Editorial Azul'
ORDER BY autor.nombre;

/*
 * 4. Agrupación: seleccione todas las editoriales junto a la cantidad
 * de publicaciones que han realizado.
 */

SELECT editorial, COUNT(*) AS cantidad
FROM publicacion
GROUP BY editorial;

-- ¿Cúantas publicaciones hay registradas cada año?
SELECT anio AS año, COUNT(*) AS cantidad
FROM publicacion
GROUP BY anio;

-- ¿Cuántas publicaciones se han confeccionado en diferentes formatos?
SELECT formato, COUNT(*) AS cantidad
FROM publicacion
GROUP BY formato;

/*
 * 5. Subconsulta: ¿Existen libros no publicados por las editoriales
 * registradas? Si es así, lístelos.
 */

SELECT id, titulo
FROM libro
WHERE id NOT IN (SELECT id_libro FROM publicacion);

/*
 * 6. Agrupación y subconsultas: seleccione todas las
 * bibliotecas junto a la cantidad total de libros impresos que hay en
 * sus estanterías.
 */

SELECT biblioteca, SUM(cantidad) AS cantidad_libros
FROM publicacion_biblioteca
GROUP BY biblioteca;

-- ¿Cuál biblioteca tiene una menor cantidad de libros impresos?
SELECT tablal.biblioteca, tablal.cantidad_libros
FROM (SELECT pb.biblioteca, SUM(cantidad) AS cantidad_libros
      FROM publicacion_biblioteca pb
      GROUP BY pb.biblioteca) AS tablal
WHERE tablal.cantidad_libros = (SELECT MIN(cantidad_l)
                                FROM (SELECT SUM(cantidad) AS cantidad_l
                                      FROM publicacion_biblioteca
                                      GROUP BY biblioteca));

-- ¿Que bibliotecas tienen una variedad de libros mayor al promedio?
SELECT tablal.biblioteca, tablal.cant_variedad_libros
FROM (SELECT pb.biblioteca, COUNT(isbn) AS cant_variedad_libros
      FROM publicacion_biblioteca pb
      GROUP BY pb.biblioteca) AS tablal
WHERE tablal.cant_variedad_libros > (SELECT AVG(variedad_libros)
                                     FROM (SELECT COUNT(isbn) AS variedad_libros
                                           FROM publicacion_biblioteca
                                           GROUP BY biblioteca));