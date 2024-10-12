/* Proyecto P. 2 - Sistemas de Base de Datos de Estadísticas de Cultura */
/* Taller de Bases de Datos (IN1078C) */

/*
 * F.4. Escriba una función que liste el número de trabajadores(as) de museos por sexo, según región.
 * (referencia tabla 5.9 sin considerar %).
 */

CREATE OR REPLACE FUNCTION listar_trabajadores_museos_por_region()
	RETURNS TABLE (nom_region varchar,
     			   cant_total_trabajadores bigint,
     			   cant_trabajadores_hombres bigint,
     			   cant_trabajadores_mujeres bigint) AS $$
	 
BEGIN
    RETURN QUERY
	
    SELECT region.nom_region, COALESCE(total.cant_total_trabajadores, 0) AS cant_total_trabajadores,
           COALESCE(hombres.cant_trabajadores_hombre, 0) AS cant_trabajadores_hombres,
           COALESCE(mujeres.cant_trabajadores_mujeres, 0) AS cant_trabajadores_mujeres
    FROM region LEFT JOIN (SELECT region.cod_region,
               					   COUNT(persona_natural.id_persona_natural) AS cant_total_trabajadores
        				   FROM trabaja_museo JOIN persona_natural USING(id_persona_natural)
        						JOIN entidad ON(id_persona_natural = id_entidad)
        						JOIN comuna USING(cod_comuna) JOIN provincia USING(cod_provincia)
        						JOIN region USING(cod_region)
        				   GROUP BY region.cod_region) AS total USING(cod_region)
    			 LEFT JOIN (SELECT region.cod_region,
               						COUNT(persona_natural.id_persona_natural) AS cant_trabajadores_hombre
        					FROM trabaja_museo JOIN persona_natural USING(id_persona_natural)
        						 JOIN entidad ON(id_persona_natural = id_entidad)
        						 JOIN comuna USING(cod_comuna) JOIN provincia USING(cod_provincia)
        						 JOIN region USING(cod_region)
        					WHERE persona_natural.sexo = 'hombre'
        					GROUP BY region.cod_region) AS hombres USING(cod_region)
    			 LEFT JOIN (SELECT region.cod_region,
               						COUNT(persona_natural.id_persona_natural) AS cant_trabajadores_mujeres
        					FROM trabaja_museo JOIN persona_natural USING(id_persona_natural)
        						 JOIN entidad ON(id_persona_natural = id_entidad)
        						 JOIN comuna USING(cod_comuna) JOIN provincia USING(cod_provincia)
        						 JOIN region USING(cod_region)
        					WHERE persona_natural.sexo = 'mujer'
        					GROUP BY region.cod_region) AS mujeres USING(cod_region)
    ORDER BY region.nom_region;
	
END; $$ LANGUAGE plpgsql VOLATILE;

/* Uso */
SELECT * FROM listar_trabajadores_museos_por_region();