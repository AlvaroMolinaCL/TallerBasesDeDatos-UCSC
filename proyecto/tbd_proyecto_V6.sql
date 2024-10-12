/* Proyecto P. 2 - Sistemas de Base de Datos de Estadísticas de Cultura */
/* Taller de Bases de Datos (IN1078C) */

/*
 * V.6. Cree una vista que contenga para cada región la cantidad de monumentos nacionales y la cantidad de
 * patrimonios naturales que tiene.
 */

CREATE OR REPLACE VIEW cant_monum_nac_patr_naturales AS
(SELECT region.*, COALESCE(monum_nac.cant_monumentos_nacionales, 0) AS cant_monumentos_nacionales,
	    COALESCE(patr_nat.cant_patrimonios_naturales, 0) AS cant_patrimonios_naturales
 FROM region LEFT JOIN (SELECT region.cod_region, COUNT(id_monumento) AS cant_monumentos_nacionales
        			    FROM region JOIN provincia USING(cod_region) JOIN comuna USING(cod_provincia)
						    JOIN entidad USING(cod_comuna)
							JOIN organizacion ON entidad.id_entidad = organizacion.id_organizacion
            				JOIN monumento_nacional USING(id_organizacion)
        			    GROUP BY region.cod_region) monum_nac ON region.cod_region = monum_nac.cod_region
  			 LEFT JOIN (SELECT region.cod_region, COUNT(id_patrimonio_natural) AS cant_patrimonios_naturales
        			    FROM region JOIN provincia USING(cod_region) JOIN comuna USING(cod_provincia)
				            JOIN entidad USING(cod_comuna)
            				JOIN organizacion ON entidad.id_entidad = organizacion.id_organizacion
            				JOIN patrimonio_natural USING(id_organizacion)
        				GROUP BY region.cod_region) patr_nat ON region.cod_region = patr_nat.cod_region);

-- Uso
SELECT * FROM cant_monum_nac_patr_naturales;