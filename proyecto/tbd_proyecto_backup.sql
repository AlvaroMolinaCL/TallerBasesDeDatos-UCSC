--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.4

-- Started on 2024-09-28 23:44:06

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 250 (class 1255 OID 16398)
-- Name: listar_trabajadores_museos_por_region(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.listar_trabajadores_museos_por_region() RETURNS TABLE(nom_region character varying, cant_total_trabajadores bigint, cant_trabajadores_hombres bigint, cant_trabajadores_mujeres bigint)
    LANGUAGE plpgsql
    AS $$
	 
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
	
END; $$;


ALTER FUNCTION public.listar_trabajadores_museos_por_region() OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 16399)
-- Name: verificar_comuna_organizacion(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.verificar_comuna_organizacion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	
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

END; $$;


ALTER FUNCTION public.verificar_comuna_organizacion() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16400)
-- Name: actividad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actividad (
    id_actividad integer NOT NULL,
    nombre_actividad character varying NOT NULL,
    modalidad character varying NOT NULL,
    numero_version integer NOT NULL,
    id_entidad integer NOT NULL,
    CONSTRAINT actividad_modalidad_check CHECK (((modalidad)::text = ANY (ARRAY[('presencial'::character varying)::text, ('virtual'::character varying)::text, ('ambas'::character varying)::text])))
);


ALTER TABLE public.actividad OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16406)
-- Name: acude_museo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.acude_museo (
    id_persona_natural integer NOT NULL,
    id_museo integer NOT NULL,
    fecha date NOT NULL
);


ALTER TABLE public.acude_museo OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16409)
-- Name: ambito_patrimonio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ambito_patrimonio (
    ambito character varying NOT NULL
);


ALTER TABLE public.ambito_patrimonio OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16414)
-- Name: anio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.anio (
    anio integer NOT NULL
);


ALTER TABLE public.anio OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16417)
-- Name: artesania; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artesania (
    id_artesania integer NOT NULL,
    nombre_producto character varying NOT NULL,
    anio_sello integer,
    id_persona_natural integer NOT NULL,
    rut integer NOT NULL
);


ALTER TABLE public.artesania OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16422)
-- Name: artesano; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artesano (
    id_persona_natural integer NOT NULL,
    rut_artesano integer NOT NULL,
    disciplina character varying NOT NULL,
    CONSTRAINT artesano_disciplina_check CHECK (((disciplina)::text = ANY (ARRAY[('alfarería y cerámica'::character varying)::text, ('cesteria'::character varying)::text, ('cantería y piedras'::character varying)::text, ('huesos-cuernos-conchas'::character varying)::text, ('instrumentos musicales y luthier'::character varying)::text, ('madera'::character varying)::text, ('marroquinería y talabartería (cueros)'::character varying)::text, ('metales y orfebrería'::character varying)::text, ('papel'::character varying)::text, ('textilería'::character varying)::text, ('vidrio'::character varying)::text, ('otros'::character varying)::text])))
);


ALTER TABLE public.artesano OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16428)
-- Name: atiende_anio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.atiende_anio (
    id_biblioteca_escolar integer NOT NULL,
    anio integer NOT NULL,
    nivel_medio integer DEFAULT 0,
    nivel_basico integer DEFAULT 0
);


ALTER TABLE public.atiende_anio OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16433)
-- Name: biblioteca; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biblioteca (
    id_biblioteca integer NOT NULL,
    nombre_bib character varying NOT NULL
);


ALTER TABLE public.biblioteca OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16438)
-- Name: biblioteca_escolar_cra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biblioteca_escolar_cra (
    id_biblioteca integer NOT NULL,
    codigo_est integer
);


ALTER TABLE public.biblioteca_escolar_cra OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16441)
-- Name: biblioteca_publica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biblioteca_publica (
    id_biblioteca integer NOT NULL,
    id_persona_juridica integer NOT NULL
);


ALTER TABLE public.biblioteca_publica OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16444)
-- Name: comuna; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comuna (
    cod_comuna integer NOT NULL,
    nom_comuna character varying NOT NULL,
    cod_provincia integer NOT NULL
);


ALTER TABLE public.comuna OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16449)
-- Name: entidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entidad (
    id_entidad integer NOT NULL,
    nombre character varying NOT NULL,
    cod_comuna integer NOT NULL
);


ALTER TABLE public.entidad OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16454)
-- Name: monumento_nacional; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monumento_nacional (
    id_monumento integer NOT NULL,
    nombre_monumento character varying NOT NULL,
    tipo character varying NOT NULL,
    id_organizacion integer NOT NULL,
    CONSTRAINT monumento_nacional_tipo_check CHECK (((tipo)::text = ANY (ARRAY[('monumento historico mueble'::character varying)::text, ('monumento histórico inmueble'::character varying)::text, ('santuario de la naturaleza'::character varying)::text, ('zona tipica'::character varying)::text])))
);


ALTER TABLE public.monumento_nacional OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16460)
-- Name: organizacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organizacion (
    id_organizacion integer NOT NULL
);


ALTER TABLE public.organizacion OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16463)
-- Name: patrimonio_natural; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patrimonio_natural (
    id_patrimonio_natural integer NOT NULL,
    nombre_patrimonio_nat character varying NOT NULL,
    tipo_pat character varying NOT NULL,
    id_organizacion integer NOT NULL,
    CONSTRAINT patrimonio_natural_tipo_pat_check CHECK (((tipo_pat)::text = ANY (ARRAY[('Monumento natural'::character varying)::text, ('parque nacional'::character varying)::text, ('reserva nacional'::character varying)::text])))
);


ALTER TABLE public.patrimonio_natural OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16469)
-- Name: provincia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provincia (
    cod_provincia integer NOT NULL,
    nom_provincia character varying NOT NULL,
    cod_region integer NOT NULL
);


ALTER TABLE public.provincia OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16474)
-- Name: region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region (
    cod_region integer NOT NULL,
    nom_region character varying NOT NULL
);


ALTER TABLE public.region OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16479)
-- Name: cant_monum_nac_patr_naturales; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.cant_monum_nac_patr_naturales AS
 SELECT region.cod_region,
    region.nom_region,
    COALESCE(monum_nac.cant_monumentos_nacionales, (0)::bigint) AS cant_monumentos_nacionales,
    COALESCE(patr_nat.cant_patrimonios_naturales, (0)::bigint) AS cant_patrimonios_naturales
   FROM ((public.region
     LEFT JOIN ( SELECT region_1.cod_region,
            count(monumento_nacional.id_monumento) AS cant_monumentos_nacionales
           FROM (((((public.region region_1
             JOIN public.provincia USING (cod_region))
             JOIN public.comuna USING (cod_provincia))
             JOIN public.entidad USING (cod_comuna))
             JOIN public.organizacion ON ((entidad.id_entidad = organizacion.id_organizacion)))
             JOIN public.monumento_nacional USING (id_organizacion))
          GROUP BY region_1.cod_region) monum_nac ON ((region.cod_region = monum_nac.cod_region)))
     LEFT JOIN ( SELECT region_1.cod_region,
            count(patrimonio_natural.id_patrimonio_natural) AS cant_patrimonios_naturales
           FROM (((((public.region region_1
             JOIN public.provincia USING (cod_region))
             JOIN public.comuna USING (cod_provincia))
             JOIN public.entidad USING (cod_comuna))
             JOIN public.organizacion ON ((entidad.id_entidad = organizacion.id_organizacion)))
             JOIN public.patrimonio_natural USING (id_organizacion))
          GROUP BY region_1.cod_region) patr_nat ON ((region.cod_region = patr_nat.cod_region)));


ALTER VIEW public.cant_monum_nac_patr_naturales OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16484)
-- Name: comuna_cod_comuna_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comuna_cod_comuna_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comuna_cod_comuna_seq OWNER TO postgres;

--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 233
-- Name: comuna_cod_comuna_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comuna_cod_comuna_seq OWNED BY public.comuna.cod_comuna;


--
-- TOC entry 234 (class 1259 OID 16485)
-- Name: dia_patrimonio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dia_patrimonio (
    numero_version integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_termino date NOT NULL
);


ALTER TABLE public.dia_patrimonio OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16488)
-- Name: establecimiento_educacional; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.establecimiento_educacional (
    codigo_est integer NOT NULL,
    nombre character varying NOT NULL,
    cod_comuna integer NOT NULL
);


ALTER TABLE public.establecimiento_educacional OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16493)
-- Name: estudia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estudia (
    id_persona_natural integer NOT NULL,
    rut_alumno integer NOT NULL,
    codigo_est integer NOT NULL,
    anio integer NOT NULL,
    nivel_alumno_anio character varying NOT NULL,
    CONSTRAINT estudia_nivel_alumno_anio_check CHECK (((nivel_alumno_anio)::text = ANY (ARRAY[('basica'::character varying)::text, ('media'::character varying)::text])))
);


ALTER TABLE public.estudia OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16499)
-- Name: estudiante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estudiante (
    id_persona_natural integer NOT NULL,
    rut_alumno integer NOT NULL
);


ALTER TABLE public.estudiante OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16502)
-- Name: museo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.museo (
    id_museo integer NOT NULL,
    nombre_museo character varying NOT NULL,
    id_entidad integer NOT NULL
);


ALTER TABLE public.museo OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16507)
-- Name: patrimonio_comuna; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patrimonio_comuna (
    id_patrimonio_natural integer NOT NULL,
    cod_comuna integer NOT NULL
);


ALTER TABLE public.patrimonio_comuna OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16510)
-- Name: patrimonio_inmaterial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patrimonio_inmaterial (
    nombre_elemento character varying NOT NULL
);


ALTER TABLE public.patrimonio_inmaterial OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16515)
-- Name: patrimonio_inmaterial_ambito; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patrimonio_inmaterial_ambito (
    nombre_elemento character varying NOT NULL,
    ambito character varying NOT NULL
);


ALTER TABLE public.patrimonio_inmaterial_ambito OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16520)
-- Name: persona_juridica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persona_juridica (
    id_persona_juridica integer NOT NULL
);


ALTER TABLE public.persona_juridica OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16523)
-- Name: persona_natural; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persona_natural (
    id_persona_natural integer NOT NULL,
    sexo character varying NOT NULL,
    fecha_nacimiento date NOT NULL,
    nombre_pueblo_ori character varying,
    discapacidad boolean NOT NULL,
    direccion character varying NOT NULL,
    nombre_elemento character varying,
    rut integer NOT NULL,
    CONSTRAINT persona_natural_nombre_pueblo_ori_check CHECK (((nombre_pueblo_ori)::text = ANY (ARRAY[('Mapuche'::character varying)::text, ('Aymara'::character varying)::text, ('Rapa Nui'::character varying)::text, ('Atacameños'::character varying)::text, ('Quechua'::character varying)::text, ('Colla'::character varying)::text, ('Chango'::character varying)::text, ('Diaguita'::character varying)::text, ('Kawésqar'::character varying)::text, ('Yagan'::character varying)::text]))),
    CONSTRAINT persona_natural_sexo_check CHECK (((sexo)::text = ANY (ARRAY[('mujer'::character varying)::text, ('hombre'::character varying)::text])))
);


ALTER TABLE public.persona_natural OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 16530)
-- Name: presta_material; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.presta_material (
    id_persona_natural integer NOT NULL,
    id_biblioteca_publica integer NOT NULL,
    fecha date NOT NULL
);


ALTER TABLE public.presta_material OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 16533)
-- Name: provincia_cod_provincia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.provincia_cod_provincia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.provincia_cod_provincia_seq OWNER TO postgres;

--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 245
-- Name: provincia_cod_provincia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.provincia_cod_provincia_seq OWNED BY public.provincia.cod_provincia;


--
-- TOC entry 246 (class 1259 OID 16534)
-- Name: region_cod_region_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.region_cod_region_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.region_cod_region_seq OWNER TO postgres;

--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 246
-- Name: region_cod_region_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.region_cod_region_seq OWNED BY public.region.cod_region;


--
-- TOC entry 247 (class 1259 OID 16535)
-- Name: trabaja_museo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trabaja_museo (
    id_museo integer NOT NULL,
    vinculo character varying NOT NULL,
    id_persona_natural integer,
    CONSTRAINT trabaja_museo_vinculo_check CHECK (((vinculo)::text = ANY (ARRAY[('temporal'::character varying)::text, ('contratado'::character varying)::text, ('voluntario'::character varying)::text])))
);


ALTER TABLE public.trabaja_museo OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 16541)
-- Name: visita_museo_anio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visita_museo_anio (
    id_museo integer NOT NULL,
    anio integer NOT NULL,
    cantidad_discapacidad integer NOT NULL,
    cantidad_pueblo_originario integer NOT NULL
);


ALTER TABLE public.visita_museo_anio OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 16544)
-- Name: visita_patrimonio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visita_patrimonio (
    id_persona_natural integer NOT NULL,
    id_patrimonio_natural integer NOT NULL,
    fecha date NOT NULL
);


ALTER TABLE public.visita_patrimonio OWNER TO postgres;

--
-- TOC entry 4818 (class 2604 OID 16547)
-- Name: comuna cod_comuna; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comuna ALTER COLUMN cod_comuna SET DEFAULT nextval('public.comuna_cod_comuna_seq'::regclass);


--
-- TOC entry 4819 (class 2604 OID 16548)
-- Name: provincia cod_provincia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provincia ALTER COLUMN cod_provincia SET DEFAULT nextval('public.provincia_cod_provincia_seq'::regclass);


--
-- TOC entry 4820 (class 2604 OID 16549)
-- Name: region cod_region; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region ALTER COLUMN cod_region SET DEFAULT nextval('public.region_cod_region_seq'::regclass);


--
-- TOC entry 5075 (class 0 OID 16400)
-- Dependencies: 215
-- Data for Name: actividad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actividad (id_actividad, nombre_actividad, modalidad, numero_version, id_entidad) FROM stdin;
\.


--
-- TOC entry 5076 (class 0 OID 16406)
-- Dependencies: 216
-- Data for Name: acude_museo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.acude_museo (id_persona_natural, id_museo, fecha) FROM stdin;
7	10	2024-05-03
\.


--
-- TOC entry 5077 (class 0 OID 16409)
-- Dependencies: 217
-- Data for Name: ambito_patrimonio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ambito_patrimonio (ambito) FROM stdin;
\.


--
-- TOC entry 5078 (class 0 OID 16414)
-- Dependencies: 218
-- Data for Name: anio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.anio (anio) FROM stdin;
2000
2001
2002
2003
2004
2005
2006
2007
2008
2009
2010
2011
2012
2013
2014
2015
2016
2017
2018
2019
2020
2021
2022
2023
2024
\.


--
-- TOC entry 5079 (class 0 OID 16417)
-- Dependencies: 219
-- Data for Name: artesania; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artesania (id_artesania, nombre_producto, anio_sello, id_persona_natural, rut) FROM stdin;
\.


--
-- TOC entry 5080 (class 0 OID 16422)
-- Dependencies: 220
-- Data for Name: artesano; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artesano (id_persona_natural, rut_artesano, disciplina) FROM stdin;
\.


--
-- TOC entry 5081 (class 0 OID 16428)
-- Dependencies: 221
-- Data for Name: atiende_anio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.atiende_anio (id_biblioteca_escolar, anio, nivel_medio, nivel_basico) FROM stdin;
1	2020	0	0
2	2024	0	1
3	2024	0	1
4	2024	1	0
\.


--
-- TOC entry 5082 (class 0 OID 16433)
-- Dependencies: 222
-- Data for Name: biblioteca; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.biblioteca (id_biblioteca, nombre_bib) FROM stdin;
1	biblioteca municipal de coronel
2	biblioteca de perros
3	biblioteca talcahuano
4	biblioteca municipal concepcion
\.


--
-- TOC entry 5083 (class 0 OID 16438)
-- Dependencies: 223
-- Data for Name: biblioteca_escolar_cra; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.biblioteca_escolar_cra (id_biblioteca, codigo_est) FROM stdin;
1	11
2	10
3	10
4	11
\.


--
-- TOC entry 5084 (class 0 OID 16441)
-- Dependencies: 224
-- Data for Name: biblioteca_publica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.biblioteca_publica (id_biblioteca, id_persona_juridica) FROM stdin;
\.


--
-- TOC entry 5085 (class 0 OID 16444)
-- Dependencies: 225
-- Data for Name: comuna; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comuna (cod_comuna, nom_comuna, cod_provincia) FROM stdin;
1	Arica	1
2	Camarones	1
3	General Lagos	2
4	Putre	2
5	Alto Hospicio	3
6	Iquique	3
7	Camiña	4
8	Colchane	4
9	Huara	4
10	Pica	4
11	Pozo Almonte	4
12	Tocopilla	5
13	María Elena	5
14	Calama	6
15	Ollague	6
16	San Pedro de Atacama	6
17	Antofagasta	7
18	Mejillones	7
19	Sierra Gorda	7
20	Taltal	7
21	Chañaral	8
22	Diego de Almagro	8
23	Copiapó	9
24	Caldera	9
25	Tierra Amarilla	9
26	Vallenar	10
27	Alto del Carmen	10
28	Freirina	10
29	Huasco	10
30	La Serena	11
31	Coquimbo	11
32	Andacollo	11
33	La Higuera	11
34	Paihuano	11
35	Vicuña	11
36	Ovalle	12
37	Combarbalá	12
38	Monte Patria	12
39	Punitaqui	12
40	Río Hurtado	12
41	Illapel	13
42	Canela	13
43	Los Vilos	13
44	Salamanca	13
45	La Ligua	14
46	Cabildo	14
47	Zapallar	14
48	Papudo	14
49	Petorca	14
50	Los Andes	15
51	San Esteban	15
52	Calle Larga	15
53	Rinconada	15
54	San Felipe	16
55	Llaillay	16
56	Putaendo	16
57	Santa María	16
58	Catemu	16
59	Panquehue	16
60	Quillota	17
61	La Cruz	17
62	La Calera	17
63	Nogales	17
64	Hijuelas	17
65	Valparaíso	18
66	Viña del Mar	18
67	Concón	18
68	Quintero	18
69	Puchuncaví	18
70	Casablanca	18
71	Juan Fernández	18
72	San Antonio	19
73	Cartagena	19
74	El Tabo	19
75	El Quisco	19
76	Algarrobo	19
77	Santo Domingo	19
78	Isla de Pascua	20
79	Quilpué	21
80	Limache	21
81	Olmué	21
82	Villa Alemana	21
83	Colina	22
84	Lampa	22
85	Tiltil	22
86	Santiago	23
87	Vitacura	23
88	San Ramón	23
89	San Miguel	23
90	San Joaquín	23
91	Renca	23
92	Recoleta	23
93	Quinta Normal	23
94	Quilicura	23
95	Pudahuel	23
96	Providencia	23
97	Peñalolén	23
98	Pedro Aguirre Cerda	23
99	Ñuñoa	23
100	Maipú	23
101	Macul	23
102	Lo Prado	23
103	Lo Espejo	23
104	Lo Barnechea	23
105	Las Condes	23
106	La Reina	23
107	La Pintana	23
108	La Granja	23
109	La Florida	23
110	La Cisterna	23
111	Independencia	23
112	Huechuraba	23
113	Estación Central	23
114	El Bosque	23
115	Conchalí	23
116	Cerro Navia	23
117	Cerrillos	23
118	Puente Alto	24
119	San José de Maipo	24
120	Pirque	24
121	San Bernardo	25
122	Buin	25
123	Paine	25
124	Calera de Tango	25
125	Melipilla	26
126	Alhué	26
127	Curacaví	26
128	María Pinto	26
129	San Pedro	26
130	Isla de Maipo	27
131	El Monte	27
132	Padre Hurtado	27
133	Peñaflor	27
134	Talagante	27
135	Codegua	28
136	Coínco	28
137	Coltauco	28
138	Doñihue	28
139	Graneros	28
140	Las Cabras	28
141	Machalí	28
142	Malloa	28
143	Mostazal	28
144	Olivar	28
145	Peumo	28
146	Pichidegua	28
147	Quinta de Tilcoco	28
148	Rancagua	28
149	Rengo	28
150	Requínoa	28
151	San Vicente de Tagua Tagua	28
152	Chépica	29
153	Chimbarongo	29
154	Lolol	29
155	Nancagua	29
156	Palmilla	29
157	Peralillo	29
158	Placilla	29
159	Pumanque	29
160	San Fernando	29
161	Santa Cruz	29
162	La Estrella	30
163	Litueche	30
164	Marchigüe	30
165	Navidad	30
166	Paredones	30
167	Pichilemu	30
168	Curicó	31
169	Hualañé	31
170	Licantén	31
171	Molina	31
172	Rauco	31
173	Romeral	31
174	Sagrada Familia	31
175	Teno	31
176	Vichuquén	31
177	Talca	32
178	San Clemente	32
179	Pelarco	32
180	Pencahue	32
181	Maule	32
182	San Rafael	32
183	Curepto	33
184	Constitución	32
185	Empedrado	32
186	Río Claro	32
187	Linares	33
188	San Javier	33
189	Parral	33
190	Villa Alegre	33
191	Longaví	33
192	Colbún	33
193	Retiro	33
194	Yerbas Buenas	33
195	Cauquenes	34
196	Chanco	34
197	Pelluhue	34
198	Bulnes	35
199	Chillán	35
200	Chillán Viejo	35
201	El Carmen	35
202	Pemuco	35
203	Pinto	35
204	Quillón	35
205	San Ignacio	35
206	Yungay	35
207	Cobquecura	36
208	Coelemu	36
209	Ninhue	36
210	Portezuelo	36
211	Quirihue	36
212	Ránquil	36
213	Treguaco	36
214	San Carlos	37
215	Coihueco	37
216	San Nicolás	37
217	Ñiquén	37
218	San Fabián	37
219	Alto Biobío	38
220	Antuco	38
221	Cabrero	38
222	Laja	38
223	Los Ángeles	38
224	Mulchén	38
225	Nacimiento	38
226	Negrete	38
227	Quilaco	38
228	Quilleco	38
229	San Rosendo	38
230	Santa Bárbara	38
231	Tucapel	38
232	Yumbel	38
233	Concepción	39
234	Coronel	39
235	Chiguayante	39
236	Florida	39
237	Hualpén	39
238	Hualqui	39
239	Lota	39
240	Penco	39
241	San Pedro de La Paz	39
242	Santa Juana	39
243	Talcahuano	39
244	Tomé	39
245	Arauco	40
246	Cañete	40
247	Contulmo	40
248	Curanilahue	40
249	Lebu	40
250	Los Álamos	40
251	Tirúa	40
252	Angol	41
253	Collipulli	41
254	Curacautín	41
255	Ercilla	41
256	Lonquimay	41
257	Los Sauces	41
258	Lumaco	41
259	Purén	41
260	Renaico	41
261	Traiguén	41
262	Victoria	41
263	Temuco	42
264	Carahue	42
265	Cholchol	42
266	Cunco	42
267	Curarrehue	42
268	Freire	42
269	Galvarino	42
270	Gorbea	42
271	Lautaro	42
272	Loncoche	42
273	Melipeuco	42
274	Nueva Imperial	42
275	Padre Las Casas	42
276	Perquenco	42
277	Pitrufquén	42
278	Pucón	42
279	Saavedra	42
280	Teodoro Schmidt	42
281	Toltén	42
282	Vilcún	42
283	Villarrica	42
284	Valdivia	43
285	Corral	43
286	Lanco	43
287	Los Lagos	43
288	Máfil	43
289	Mariquina	43
290	Paillaco	43
291	Panguipulli	43
292	La Unión	44
293	Futrono	44
294	Lago Ranco	44
295	Río Bueno	44
296	Osorno	45
297	Puerto Octay	45
298	Purranque	45
299	Puyehue	45
300	Río Negro	45
301	San Juan de la Costa	45
302	San Pablo	45
303	Calbuco	46
304	Cochamó	46
305	Fresia	46
306	Frutillar	46
307	Llanquihue	46
308	Los Muermos	46
309	Maullín	46
310	Puerto Montt	46
311	Puerto Varas	46
312	Ancud	47
313	Castro	47
314	Chonchi	47
315	Curaco de Vélez	47
316	Dalcahue	47
317	Puqueldón	47
318	Queilén	47
319	Quellón	47
320	Quemchi	47
321	Quinchao	47
322	Chaitén	48
323	Futaleufú	48
324	Hualaihué	48
325	Palena	48
326	Lago Verde	49
327	Coihaique	49
328	Aysén	50
329	Cisnes	50
330	Guaitecas	50
331	Río Ibáñez	51
332	Chile Chico	51
333	Cochrane	52
334	O'Higgins	52
335	Tortel	52
336	Natales	53
337	Torres del Paine	53
338	Laguna Blanca	54
339	Punta Arenas	54
340	Río Verde	54
341	San Gregorio	54
342	Porvenir	55
343	Primavera	55
344	Timaukel	55
345	Cabo de Hornos	56
346	Antártica	56
\.


--
-- TOC entry 5093 (class 0 OID 16485)
-- Dependencies: 234
-- Data for Name: dia_patrimonio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dia_patrimonio (numero_version, fecha_inicio, fecha_termino) FROM stdin;
\.


--
-- TOC entry 5086 (class 0 OID 16449)
-- Dependencies: 226
-- Data for Name: entidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entidad (id_entidad, nombre, cod_comuna) FROM stdin;
1	ABC	234
2	DEF	12
3	GHI	233
4	JKL	233
5	MNO	233
6	PQR	233
7	STU	10
\.


--
-- TOC entry 5094 (class 0 OID 16488)
-- Dependencies: 235
-- Data for Name: establecimiento_educacional; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.establecimiento_educacional (codigo_est, nombre, cod_comuna) FROM stdin;
11	Escuela Cerrro Cornou	243
10	Escuela buena vista	243
\.


--
-- TOC entry 5095 (class 0 OID 16493)
-- Dependencies: 236
-- Data for Name: estudia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estudia (id_persona_natural, rut_alumno, codigo_est, anio, nivel_alumno_anio) FROM stdin;
3	444444	10	2024	basica
1	200000000	11	2024	media
\.


--
-- TOC entry 5096 (class 0 OID 16499)
-- Dependencies: 237
-- Data for Name: estudiante; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estudiante (id_persona_natural, rut_alumno) FROM stdin;
3	444444
4	444344
5	484344
6	744344
1	200000000
\.


--
-- TOC entry 5087 (class 0 OID 16454)
-- Dependencies: 227
-- Data for Name: monumento_nacional; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monumento_nacional (id_monumento, nombre_monumento, tipo, id_organizacion) FROM stdin;
123456	Estatua ABC	monumento historico mueble	2
4321	DEF	monumento historico mueble	6
\.


--
-- TOC entry 5097 (class 0 OID 16502)
-- Dependencies: 238
-- Data for Name: museo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.museo (id_museo, nombre_museo, id_entidad) FROM stdin;
10	museo coronel	2
11	museo concepcion	4
\.


--
-- TOC entry 5088 (class 0 OID 16460)
-- Dependencies: 228
-- Data for Name: organizacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizacion (id_organizacion) FROM stdin;
2
4
6
\.


--
-- TOC entry 5098 (class 0 OID 16507)
-- Dependencies: 239
-- Data for Name: patrimonio_comuna; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patrimonio_comuna (id_patrimonio_natural, cod_comuna) FROM stdin;
1	4
2	8
3	17
4	18
4	17
5	20
5	21
6	23
6	25
7	29
8	36
9	71
105	64
11	78
10	120
12	140
12	171
13	220
14	233
14	238
15	246
15	252
15	259
15	257
16	262
16	254
17	254
17	256
17	273
17	282
18	278
18	266
19	278
19	267
19	283
19	291
20	285
20	292
21	295
21	294
21	299
21	297
22	297
22	311
22	304
22	324
22	322
22	325
23	310
23	304
24	304
24	324
25	322
26	312
26	313
26	314
\.


--
-- TOC entry 5099 (class 0 OID 16510)
-- Dependencies: 240
-- Data for Name: patrimonio_inmaterial; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patrimonio_inmaterial (nombre_elemento) FROM stdin;
Baile de morenos de paso en la región de Arica y Parinacota
Tradición de las Cruces de Mayo afrodescendientes en los valles de Azapa, Lluta y Acha
Bailes chinos
Danza cachimbo de las comunas de Pica, Huara y Pozo Almonte
Bailes Devocionales de la Oficina Salitrera Pedro de Valdivia
Bailes tradicionales de San Pedro de Atacama
Conocimientos y técnicas de alfareras y alfareros de Santiago Río Grande
Música carnavaleña y cuecas tradicionales de Toconao
Teatro tradicional de títeres
Trashumancia Kolla
Canto a lo poeta
Circo Tradicional en Chile
Crianza caprina pastoril del río Choapa
Trashumancia andina del Río Choapa Alto
Kai Kai de Rapa Nui
Música de la bohemia tradicional de Valparaíso
Oficio tradicional del organillero-chinchinero
Tradición de los dulces de La Ligua
Tradición oral Rapa Nui
Baile de los Negros de Lora
Fiesta de Cuasimodo
Minería de oro de Santa Celia
Portadores del anda de la Fiesta de la Virgen de la Merced de Isla de Maipo
Técnica de la cuelcha o trenzado en fibra de trigo en el secano interior del Valle del Río Itata
Modo de vida campesino de Larmahue y su vinculación con el medioambiente a través de las ruedas de agua
Tradición de salineros y salineras en Cáhuil, Barrancas, La Villa, Lo Valdivia y Yoncavén
Trenzadoras y trenzadores de paja de trigo ligún en la localidad de Cutemu y alrededores, en la comuna de Paredones, región de O'Higgins
Loceras de Pilén, comuna de Cauquenes, región del Maule
Tejido en Crin de Rari y Panimavida
Alfarería de la quebrada de las Ulloa
Alfarería de Quinchamalí y Santa Cruz de Cuca
Carpintería de ribera del Boca Lebu
Componedores de huesos en Tirúa
Conocimientos, saberes y prácticas de la comunidad de Caleta Tumbes asociados al rito fúnebre ante la desaparición de pescadores en el mar
Fabricación y venta de tortillas de rescoldo de Laraquete
Recolección y ruta del cochayuyo desde los sectores Pilico, Casa de Piedra, Danquil y Quilantahue, hasta Temuco
Representación del imaginario rural a través de bordados, forma de expresión de las mujeres de Copiulemu
Técnicas y saberes asociados a la cestería de coirón y chupón en Hualqui
Técnicas y saberes asociados a la práctica arriera y criancera de la cordillera de Antuco
Técnicas y saberes asociados al pan minero de Lota
Kimün trarikanmakuñ Wallmapu
Carpintería de ribera de Cutipay
Artesanía chilota en fibra vegetal y sus diferentes tradiciones
Carpintería de ribera tradicional en la región de Los Lagos
Pasacalles devocionales de la cultura chilota
Tejuelería en la región de Aysén
Tradición de Fiscales de la cultura chilota
Tradición del tejido en Quelgo
Carpintería de Ribera en la región de Aysén
Fabricación y práctica de la taba patagónica
Trabajo en soga en la región de Aysén
Carpintería de ribera en la región de Magallanes
Cestería Yagan
Modo de vida asociado a las labores del campo en Torres del Paine
\.


--
-- TOC entry 5100 (class 0 OID 16515)
-- Dependencies: 241
-- Data for Name: patrimonio_inmaterial_ambito; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patrimonio_inmaterial_ambito (nombre_elemento, ambito) FROM stdin;
\.


--
-- TOC entry 5089 (class 0 OID 16463)
-- Dependencies: 229
-- Data for Name: patrimonio_natural; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patrimonio_natural (id_patrimonio_natural, nombre_patrimonio_nat, tipo_pat, id_organizacion) FROM stdin;
1	Parque Nacional Lauca	parque nacional	2
2	Parque Nacional Volcán Isluga	parque nacional	2
3	Parque Nacional Llullaillaco	parque nacional	2
105	Parque Nacional La Campana	parque nacional	2
4	Parque Nacional Morro Moreno	parque nacional	2
5	Parque Nacional Pan de Azúcar	parque nacional	2
6	Parque Nacional Nevado de Tres Cruces	parque nacional	2
7	Parque Nacional Llanos de Challe	parque nacional	2
8	Parque Nacional Bosque Fray Jorge	parque nacional	2
9	Parque Nacional Archipiélago de Juan Fernández	parque nacional	2
10	Parque Nacional Río Clarillo	parque nacional	2
11	Parque Nacional Rapa Nui	parque nacional	2
12	Parque Nacional Las Palmas de Cocalán	parque nacional	2
13	Parque Nacional Huerquehue	parque nacional	2
14	Parque Nacional Radal Siete Tazas	parque nacional	2
15	Parque Nacional Villarrica	parque nacional	2
16	Parque Nacional Laguna del Laja	parque nacional	2
17	Parque Nacional Alerce Costero	parque nacional	2
18	Parque Nacional Nonguén	parque nacional	2
19	Parque Nacional Puyehue	parque nacional	2
20	Parque Nacional Nahuelbuta	parque nacional	2
21	Parque Nacional Vicente Pérez Rosales	parque nacional	2
22	Parque Nacional Tolhuaca	parque nacional	2
23	Parque Nacional Pumalín Douglas Tompkins	parque nacional	2
24	Parque Nacional Conguillío	parque nacional	2
25	Parque Nacional Alerce Andino	parque nacional	2
26	Parque Nacional Hornopirén	parque nacional	2
27	Parque Nacional Queulat	parque nacional	2
28	Parque Nacional Corcovado	parque nacional	2
29	Parque Nacional Isla Guamblín	parque nacional	2
30	Parque Nacional Melimoyu,	parque nacional	2
31	Parque Nacional Cerro Castillo	parque nacional	2
32	Parque Nacional Bernardo OHiggins	parque nacional	2
33	Parque Nacional Isla Magdalena	parque nacional	2
34	Parque Nacional Torres del Paine	parque nacional	2
35	Parque Nacional Laguna San Rafael	parque nacional	2
36	Parque Nacional Pali Aike	parque nacional	2
37	Parque Nacional Patagonia	parque nacional	2
38	Parque Nacional Alberto de Agostini	parque nacional	2
39	Parque Nacional Cabo de Hornos	parque nacional	2
40	Parque Nacional Kawésqar	parque nacional	2
41	Parque Nacional Yendegaia,	parque nacional	2
42	Reserva Nacional Las Vicuñas	reserva nacional	2
43	Reserva Nacional Pampa del Tamarugal	reserva nacional	2
44	Reserva Nacional La Chimba	reserva nacional	2
45	Reserva Nacional Malleco	reserva nacional	2
46	Reserva Nacional Los Flamencos	reserva nacional	2
47	Reserva Nacional Alto Biobío	reserva nacional	2
48	Reserva Nacional Las Chinchillas	reserva nacional	2
49	Reserva Nacional Nalcas	reserva nacional	2
50	Reserva Nacional Pingüino de Humboldt	reserva nacional	2
51	Reserva Nacional Malalcahuello	reserva nacional	2
52	Reserva Nacional Río Blanco	reserva nacional	2
53	Reserva Nacional China Muerta	reserva nacional	2
54	Reserva Nacional Lago Peñuelas	reserva nacional	2
55	Reserva Nacional Villarrica	reserva nacional	2
56	Reserva Nacional El Yali	reserva nacional	2
57	Reserva Nacional Mocho-Choshuenco	reserva nacional	2
58	Reserva Nacional Río Clarillo	reserva nacional	2
59	Reserva Nacional Llanquihue	reserva nacional	2
60	Reserva Nacional Roblería del Cobre de Loncha	reserva nacional	2
61	Reserva Nacional Futaleufú	reserva nacional	2
62	Reserva Nacional Río de los Cipreses	reserva nacional	2
63	Reserva Nacional Lago Palena	reserva nacional	2
64	Reserva Nacional Laguna Torca	reserva nacional	2
65	Reserva Nacional Lago Carlota	reserva nacional	2
66	Reserva Nacional Radal Siete Tazas	reserva nacional	2
67	Reserva Nacional Lago Las Torres	reserva nacional	2
68	Reserva Nacional Altos de Lircay	reserva nacional	2
69	Reserva Nacional Lago Rosselot	reserva nacional	2
70	Reserva Nacional Los Ruiles	reserva nacional	2
71	Reserva Nacional Las Guaitecas	reserva nacional	2
72	Reserva Nacional Los Bellotos del Melado	reserva nacional	2
73	Reserva Nacional Río Simpson	reserva nacional	2
74	Reserva Nacional Federico Albert	reserva nacional	2
75	Reserva Nacional Coyhaique	reserva nacional	2
76	Reserva Nacional Los Queules	reserva nacional	2
77	Reserva Nacional Trapananda	reserva nacional	2
78	Reserva Nacional Los Huemules de Niblinto	reserva nacional	2
79	Reserva Nacional Katalalixar	reserva nacional	2
80	Reserva Nacional Ñuble	reserva nacional	2
81	Reserva Nacional Kawésqar	reserva nacional	2
82	Reserva Nacional Isla Mocha	reserva nacional	2
83	Reserva Nacional Laguna Parrillar	reserva nacional	2
84	Reserva Nacional Ralco	reserva nacional	2
85	Reserva Nacional Magallanes	reserva nacional	2
86	Reserva Nacional Altos de Pemehue	reserva nacional	2
87	Monumento Natural Salar de Surire	Monumento natural	2
88	Monumento Natural Cerro Ñielol	Monumento natural	2
89	Monumento Natural Picaflor de Arica	Monumento natural	2
90	Monumento Natural Lahuén Ñadi	Monumento natural	2
91	Monumento Natural Quebrada de Cardones	Monumento natural	2
92	Monumento Natural Islotes de Puñihuil	Monumento natural	2
93	Monumento Natural La Portada	Monumento natural	2
94	Monumento Natural Cinco Hermanas	Monumento natural	2
95	Monumento Natural Paposo Norte	Monumento natural	2
96	Monumento Natural Dos Lagunas	Monumento natural	2
97	Monumento Natural Pichasca	Monumento natural	2
98	Monumento Natural Cueva del Milodón	Monumento natural	2
99	Monumento Natural Isla Cachagua	Monumento natural	2
100	Monumento Natural Los Pingüinos	Monumento natural	2
101	Monumento Natural El Morado	Monumento natural	2
102	Monumento Natural Canquén Colorado	Monumento natural	2
103	Monumento Natural Contulmo	Monumento natural	2
104	Monumento Natural Laguna de los Cisnes	Monumento natural	2
\.


--
-- TOC entry 5101 (class 0 OID 16520)
-- Dependencies: 242
-- Data for Name: persona_juridica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persona_juridica (id_persona_juridica) FROM stdin;
\.


--
-- TOC entry 5102 (class 0 OID 16523)
-- Dependencies: 243
-- Data for Name: persona_natural; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persona_natural (id_persona_natural, sexo, fecha_nacimiento, nombre_pueblo_ori, discapacidad, direccion, nombre_elemento, rut) FROM stdin;
1	hombre	2002-03-07	\N	f	pasaje linares 2927 coronel	\N	123456
3	mujer	2003-06-29	\N	f	concepcion123	\N	7376667
4	hombre	2003-06-29	\N	f	concepcion123	\N	5535325
5	hombre	2003-06-29	\N	f	concepcion123	\N	3243
6	hombre	2003-06-29	\N	f	concepcion123	\N	322443
7	mujer	2002-03-07	Mapuche	t	callefalsa123	\N	6564
\.


--
-- TOC entry 5103 (class 0 OID 16530)
-- Dependencies: 244
-- Data for Name: presta_material; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.presta_material (id_persona_natural, id_biblioteca_publica, fecha) FROM stdin;
\.


--
-- TOC entry 5090 (class 0 OID 16469)
-- Dependencies: 230
-- Data for Name: provincia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provincia (cod_provincia, nom_provincia, cod_region) FROM stdin;
1	Arica	1
2	Parinacota	1
3	Iquique	2
4	El Tamarugal	2
5	Tocopilla	3
6	El Loa	3
7	Antofagasta	3
8	Chañaral	4
9	Copiapó	4
10	Huasco	4
11	Elqui	5
12	Limarí	5
13	Choapa	5
14	Petorca	6
15	Los Andes	6
16	San Felipe de Aconcagua	6
17	Quillota	6
18	Valparaiso	6
19	San Antonio	6
20	Isla de Pascua	6
21	Marga Marga	6
22	Chacabuco	7
23	Santiago	7
24	Cordillera	7
25	Maipo	7
26	Melipilla	7
27	Talagante	7
28	Cachapoal	8
29	Colchagua	8
30	Cardenal Caro	8
31	Curicó	9
32	Talca	9
33	Linares	9
34	Cauquenes	9
35	Diguillín	10
36	Itata	10
37	Punilla	10
38	Bio Bío	11
39	Concepción	11
40	Arauco	11
41	Malleco	12
42	Cautín	12
43	Valdivia	13
44	Ranco	13
45	Osorno	14
46	Llanquihue	14
47	Chiloé	14
48	Palena	14
49	Coyhaique	15
50	Aysén	15
51	General Carrera	15
52	Capitán Prat	15
53	Última Esperanza	16
54	Magallanes	16
55	Tierra del Fuego	16
56	Antártica Chilena	16
\.


--
-- TOC entry 5091 (class 0 OID 16474)
-- Dependencies: 231
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region (cod_region, nom_region) FROM stdin;
1	Tarapacá
2	Antofagasta
3	Atacama
4	Coquimbo
5	Valparaíso
6	Libertador General Bernardo OHiggins
7	Maule
8	Biobío
9	La Araucanía
10	Los Lagos
11	Aysén del General Carlos Ibáñez del Campo
12	Magallanes y de la Antártica Chilena
13	Metropolitana de Santiago
14	Los Ríos
15	Arica y Parinacota
16	Ñuble
\.


--
-- TOC entry 5106 (class 0 OID 16535)
-- Dependencies: 247
-- Data for Name: trabaja_museo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trabaja_museo (id_museo, vinculo, id_persona_natural) FROM stdin;
10	contratado	4
11	voluntario	3
\.


--
-- TOC entry 5107 (class 0 OID 16541)
-- Dependencies: 248
-- Data for Name: visita_museo_anio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visita_museo_anio (id_museo, anio, cantidad_discapacidad, cantidad_pueblo_originario) FROM stdin;
10	2024	1	1
\.


--
-- TOC entry 5108 (class 0 OID 16544)
-- Dependencies: 249
-- Data for Name: visita_patrimonio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visita_patrimonio (id_persona_natural, id_patrimonio_natural, fecha) FROM stdin;
1	103	2024-07-03
3	100	2024-07-03
3	101	2023-07-03
3	102	2022-07-03
1	86	2024-07-03
3	80	2024-07-03
3	81	2024-07-03
4	79	2024-07-03
5	1	2024-07-03
6	3	2024-07-03
\.


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 233
-- Name: comuna_cod_comuna_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comuna_cod_comuna_seq', 346, true);


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 245
-- Name: provincia_cod_provincia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.provincia_cod_provincia_seq', 56, true);


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 246
-- Name: region_cod_region_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.region_cod_region_seq', 1, false);


--
-- TOC entry 4830 (class 2606 OID 16551)
-- Name: actividad actividad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad
    ADD CONSTRAINT actividad_pkey PRIMARY KEY (id_actividad);


--
-- TOC entry 4832 (class 2606 OID 16553)
-- Name: acude_museo acude_museo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acude_museo
    ADD CONSTRAINT acude_museo_pkey PRIMARY KEY (id_persona_natural);


--
-- TOC entry 4834 (class 2606 OID 16555)
-- Name: ambito_patrimonio ambito_patrimonio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ambito_patrimonio
    ADD CONSTRAINT ambito_patrimonio_pkey PRIMARY KEY (ambito);


--
-- TOC entry 4836 (class 2606 OID 16557)
-- Name: anio anio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anio
    ADD CONSTRAINT anio_pkey PRIMARY KEY (anio);


--
-- TOC entry 4838 (class 2606 OID 16559)
-- Name: artesania artesania_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artesania
    ADD CONSTRAINT artesania_pkey PRIMARY KEY (id_artesania);


--
-- TOC entry 4840 (class 2606 OID 16561)
-- Name: artesano artesano_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artesano
    ADD CONSTRAINT artesano_pkey PRIMARY KEY (id_persona_natural);


--
-- TOC entry 4842 (class 2606 OID 16563)
-- Name: atiende_anio atiende_anio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atiende_anio
    ADD CONSTRAINT atiende_anio_pkey PRIMARY KEY (id_biblioteca_escolar, anio);


--
-- TOC entry 4846 (class 2606 OID 16565)
-- Name: biblioteca_escolar_cra biblioteca_escolar_cra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biblioteca_escolar_cra
    ADD CONSTRAINT biblioteca_escolar_cra_pkey PRIMARY KEY (id_biblioteca);


--
-- TOC entry 4844 (class 2606 OID 16567)
-- Name: biblioteca biblioteca_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biblioteca
    ADD CONSTRAINT biblioteca_pkey PRIMARY KEY (id_biblioteca);


--
-- TOC entry 4848 (class 2606 OID 16569)
-- Name: biblioteca_publica biblioteca_publica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biblioteca_publica
    ADD CONSTRAINT biblioteca_publica_pkey PRIMARY KEY (id_biblioteca);


--
-- TOC entry 4850 (class 2606 OID 16571)
-- Name: comuna comuna_nom_comuna_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comuna
    ADD CONSTRAINT comuna_nom_comuna_key UNIQUE (nom_comuna);


--
-- TOC entry 4852 (class 2606 OID 16573)
-- Name: comuna comuna_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comuna
    ADD CONSTRAINT comuna_pkey PRIMARY KEY (cod_comuna);


--
-- TOC entry 4870 (class 2606 OID 16575)
-- Name: dia_patrimonio dia_patrimonio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dia_patrimonio
    ADD CONSTRAINT dia_patrimonio_pkey PRIMARY KEY (numero_version);


--
-- TOC entry 4854 (class 2606 OID 16577)
-- Name: entidad entidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entidad
    ADD CONSTRAINT entidad_pkey PRIMARY KEY (id_entidad);


--
-- TOC entry 4872 (class 2606 OID 16579)
-- Name: establecimiento_educacional establecimiento_educacional_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.establecimiento_educacional
    ADD CONSTRAINT establecimiento_educacional_pkey PRIMARY KEY (codigo_est);


--
-- TOC entry 4874 (class 2606 OID 16581)
-- Name: estudia estudia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudia
    ADD CONSTRAINT estudia_pkey PRIMARY KEY (id_persona_natural, rut_alumno, codigo_est, anio);


--
-- TOC entry 4876 (class 2606 OID 16583)
-- Name: estudiante estudiante_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante
    ADD CONSTRAINT estudiante_pkey PRIMARY KEY (id_persona_natural);


--
-- TOC entry 4878 (class 2606 OID 16585)
-- Name: estudiante estudiante_rut_alumno_uq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante
    ADD CONSTRAINT estudiante_rut_alumno_uq UNIQUE (rut_alumno);


--
-- TOC entry 4856 (class 2606 OID 16587)
-- Name: monumento_nacional monumento_nacional_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monumento_nacional
    ADD CONSTRAINT monumento_nacional_pkey PRIMARY KEY (id_monumento);


--
-- TOC entry 4880 (class 2606 OID 16589)
-- Name: museo museo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.museo
    ADD CONSTRAINT museo_pkey PRIMARY KEY (id_museo);


--
-- TOC entry 4858 (class 2606 OID 16591)
-- Name: organizacion organizacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizacion
    ADD CONSTRAINT organizacion_pkey PRIMARY KEY (id_organizacion);


--
-- TOC entry 4882 (class 2606 OID 16593)
-- Name: patrimonio_comuna patrimonio_comuna_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patrimonio_comuna
    ADD CONSTRAINT patrimonio_comuna_pkey PRIMARY KEY (id_patrimonio_natural, cod_comuna);


--
-- TOC entry 4886 (class 2606 OID 16595)
-- Name: patrimonio_inmaterial_ambito patrimonio_inmaterial_ambito_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patrimonio_inmaterial_ambito
    ADD CONSTRAINT patrimonio_inmaterial_ambito_pkey PRIMARY KEY (nombre_elemento, ambito);


--
-- TOC entry 4884 (class 2606 OID 16597)
-- Name: patrimonio_inmaterial patrimonio_inmaterial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patrimonio_inmaterial
    ADD CONSTRAINT patrimonio_inmaterial_pkey PRIMARY KEY (nombre_elemento);


--
-- TOC entry 4860 (class 2606 OID 16599)
-- Name: patrimonio_natural patrimonio_natural_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patrimonio_natural
    ADD CONSTRAINT patrimonio_natural_pkey PRIMARY KEY (id_patrimonio_natural);


--
-- TOC entry 4888 (class 2606 OID 16601)
-- Name: persona_juridica persona_juridica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_juridica
    ADD CONSTRAINT persona_juridica_pkey PRIMARY KEY (id_persona_juridica);


--
-- TOC entry 4890 (class 2606 OID 16603)
-- Name: persona_natural persona_natural_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_natural
    ADD CONSTRAINT persona_natural_pkey PRIMARY KEY (id_persona_natural);


--
-- TOC entry 4862 (class 2606 OID 16605)
-- Name: provincia provincia_nom_provincia_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provincia
    ADD CONSTRAINT provincia_nom_provincia_key UNIQUE (nom_provincia);


--
-- TOC entry 4864 (class 2606 OID 16607)
-- Name: provincia provincia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provincia
    ADD CONSTRAINT provincia_pkey PRIMARY KEY (cod_provincia);


--
-- TOC entry 4866 (class 2606 OID 16609)
-- Name: region region_nom_region_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_nom_region_key UNIQUE (nom_region);


--
-- TOC entry 4868 (class 2606 OID 16611)
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (cod_region);


--
-- TOC entry 4892 (class 2606 OID 16613)
-- Name: trabaja_museo trabaja_museo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trabaja_museo
    ADD CONSTRAINT trabaja_museo_pkey PRIMARY KEY (id_museo);


--
-- TOC entry 4894 (class 2606 OID 16615)
-- Name: visita_museo_anio visita_museo_anio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visita_museo_anio
    ADD CONSTRAINT visita_museo_anio_pkey PRIMARY KEY (id_museo, anio);


--
-- TOC entry 4930 (class 2620 OID 16616)
-- Name: monumento_nacional verificar_comuna_organizacion_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER verificar_comuna_organizacion_t BEFORE UPDATE ON public.monumento_nacional FOR EACH ROW EXECUTE FUNCTION public.verificar_comuna_organizacion();


--
-- TOC entry 4895 (class 2606 OID 16617)
-- Name: actividad actividad_id_entidad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad
    ADD CONSTRAINT actividad_id_entidad_fkey FOREIGN KEY (id_entidad) REFERENCES public.entidad(id_entidad);


--
-- TOC entry 4896 (class 2606 OID 16622)
-- Name: actividad actividad_numero_version_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad
    ADD CONSTRAINT actividad_numero_version_fkey FOREIGN KEY (numero_version) REFERENCES public.dia_patrimonio(numero_version);


--
-- TOC entry 4897 (class 2606 OID 16627)
-- Name: acude_museo acude_museo_id_museo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acude_museo
    ADD CONSTRAINT acude_museo_id_museo_fkey FOREIGN KEY (id_museo) REFERENCES public.museo(id_museo);


--
-- TOC entry 4899 (class 2606 OID 16632)
-- Name: artesano artesano_id_persona_natural_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artesano
    ADD CONSTRAINT artesano_id_persona_natural_fkey FOREIGN KEY (id_persona_natural) REFERENCES public.persona_natural(id_persona_natural) NOT VALID;


--
-- TOC entry 4898 (class 2606 OID 16637)
-- Name: artesania artesano_id_persona_natural_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artesania
    ADD CONSTRAINT artesano_id_persona_natural_fkey FOREIGN KEY (id_persona_natural) REFERENCES public.artesano(id_persona_natural) NOT VALID;


--
-- TOC entry 4900 (class 2606 OID 16642)
-- Name: atiende_anio atiende_anio_anio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atiende_anio
    ADD CONSTRAINT atiende_anio_anio_fkey FOREIGN KEY (anio) REFERENCES public.anio(anio);


--
-- TOC entry 4901 (class 2606 OID 16647)
-- Name: atiende_anio atiende_anio_id_biblioteca_escolar_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atiende_anio
    ADD CONSTRAINT atiende_anio_id_biblioteca_escolar_fkey FOREIGN KEY (id_biblioteca_escolar) REFERENCES public.biblioteca_escolar_cra(id_biblioteca);


--
-- TOC entry 4902 (class 2606 OID 16652)
-- Name: biblioteca_escolar_cra biblioteca_escolar_cra_codigo_est_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biblioteca_escolar_cra
    ADD CONSTRAINT biblioteca_escolar_cra_codigo_est_fkey FOREIGN KEY (codigo_est) REFERENCES public.establecimiento_educacional(codigo_est);


--
-- TOC entry 4903 (class 2606 OID 16657)
-- Name: biblioteca_escolar_cra biblioteca_escolar_cra_id_biblioteca_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biblioteca_escolar_cra
    ADD CONSTRAINT biblioteca_escolar_cra_id_biblioteca_fkey FOREIGN KEY (id_biblioteca) REFERENCES public.biblioteca(id_biblioteca);


--
-- TOC entry 4904 (class 2606 OID 16662)
-- Name: biblioteca_publica biblioteca_publica_id_biblioteca_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biblioteca_publica
    ADD CONSTRAINT biblioteca_publica_id_biblioteca_fkey FOREIGN KEY (id_biblioteca) REFERENCES public.biblioteca(id_biblioteca);


--
-- TOC entry 4905 (class 2606 OID 16667)
-- Name: biblioteca_publica biblioteca_publica_id_persona_juridica_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biblioteca_publica
    ADD CONSTRAINT biblioteca_publica_id_persona_juridica_fkey FOREIGN KEY (id_persona_juridica) REFERENCES public.persona_juridica(id_persona_juridica);


--
-- TOC entry 4906 (class 2606 OID 16672)
-- Name: comuna comuna_cod_provincia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comuna
    ADD CONSTRAINT comuna_cod_provincia_fkey FOREIGN KEY (cod_provincia) REFERENCES public.provincia(cod_provincia);


--
-- TOC entry 4907 (class 2606 OID 16677)
-- Name: entidad entidad_cod_comuna_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entidad
    ADD CONSTRAINT entidad_cod_comuna_fkey FOREIGN KEY (cod_comuna) REFERENCES public.comuna(cod_comuna);


--
-- TOC entry 4912 (class 2606 OID 16682)
-- Name: establecimiento_educacional establecimiento_educacional_cod_comuna_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.establecimiento_educacional
    ADD CONSTRAINT establecimiento_educacional_cod_comuna_fkey FOREIGN KEY (cod_comuna) REFERENCES public.comuna(cod_comuna);


--
-- TOC entry 4913 (class 2606 OID 16687)
-- Name: estudia estudia_anio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudia
    ADD CONSTRAINT estudia_anio_fkey FOREIGN KEY (anio) REFERENCES public.anio(anio);


--
-- TOC entry 4914 (class 2606 OID 16692)
-- Name: estudia estudia_codigo_est_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudia
    ADD CONSTRAINT estudia_codigo_est_fkey FOREIGN KEY (codigo_est) REFERENCES public.establecimiento_educacional(codigo_est);


--
-- TOC entry 4915 (class 2606 OID 16697)
-- Name: estudiante estudiante_id_persona_natural_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante
    ADD CONSTRAINT estudiante_id_persona_natural_fkey FOREIGN KEY (id_persona_natural) REFERENCES public.persona_natural(id_persona_natural) NOT VALID;


--
-- TOC entry 4908 (class 2606 OID 16702)
-- Name: monumento_nacional monumento_nacional_id_organizacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monumento_nacional
    ADD CONSTRAINT monumento_nacional_id_organizacion_fkey FOREIGN KEY (id_organizacion) REFERENCES public.organizacion(id_organizacion);


--
-- TOC entry 4916 (class 2606 OID 16707)
-- Name: museo museo_id_entidad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.museo
    ADD CONSTRAINT museo_id_entidad_fkey FOREIGN KEY (id_entidad) REFERENCES public.entidad(id_entidad);


--
-- TOC entry 4909 (class 2606 OID 16712)
-- Name: organizacion organizacion_id_organizacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizacion
    ADD CONSTRAINT organizacion_id_organizacion_fkey FOREIGN KEY (id_organizacion) REFERENCES public.entidad(id_entidad);


--
-- TOC entry 4917 (class 2606 OID 16717)
-- Name: patrimonio_comuna patrimonio_comuna_cod_comuna_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patrimonio_comuna
    ADD CONSTRAINT patrimonio_comuna_cod_comuna_fkey FOREIGN KEY (cod_comuna) REFERENCES public.comuna(cod_comuna);


--
-- TOC entry 4918 (class 2606 OID 16722)
-- Name: patrimonio_comuna patrimonio_comuna_id_patrimonio_natural_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patrimonio_comuna
    ADD CONSTRAINT patrimonio_comuna_id_patrimonio_natural_fkey FOREIGN KEY (id_patrimonio_natural) REFERENCES public.patrimonio_natural(id_patrimonio_natural);


--
-- TOC entry 4919 (class 2606 OID 16727)
-- Name: patrimonio_inmaterial_ambito patrimonio_inmaterial_ambito_ambito_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patrimonio_inmaterial_ambito
    ADD CONSTRAINT patrimonio_inmaterial_ambito_ambito_fkey FOREIGN KEY (ambito) REFERENCES public.ambito_patrimonio(ambito);


--
-- TOC entry 4920 (class 2606 OID 16732)
-- Name: patrimonio_inmaterial_ambito patrimonio_inmaterial_ambito_nombre_elemento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patrimonio_inmaterial_ambito
    ADD CONSTRAINT patrimonio_inmaterial_ambito_nombre_elemento_fkey FOREIGN KEY (nombre_elemento) REFERENCES public.patrimonio_inmaterial(nombre_elemento);


--
-- TOC entry 4910 (class 2606 OID 16737)
-- Name: patrimonio_natural patrimonio_natural_id_organizacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patrimonio_natural
    ADD CONSTRAINT patrimonio_natural_id_organizacion_fkey FOREIGN KEY (id_organizacion) REFERENCES public.organizacion(id_organizacion);


--
-- TOC entry 4921 (class 2606 OID 16742)
-- Name: persona_juridica persona_juridica_id_persona_juridica_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_juridica
    ADD CONSTRAINT persona_juridica_id_persona_juridica_fkey FOREIGN KEY (id_persona_juridica) REFERENCES public.entidad(id_entidad);


--
-- TOC entry 4922 (class 2606 OID 16747)
-- Name: persona_natural persona_natural_id_persona_natural_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_natural
    ADD CONSTRAINT persona_natural_id_persona_natural_fkey FOREIGN KEY (id_persona_natural) REFERENCES public.entidad(id_entidad);


--
-- TOC entry 4923 (class 2606 OID 16752)
-- Name: persona_natural persona_natural_nombre_elemento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_natural
    ADD CONSTRAINT persona_natural_nombre_elemento_fkey FOREIGN KEY (nombre_elemento) REFERENCES public.patrimonio_inmaterial(nombre_elemento);


--
-- TOC entry 4924 (class 2606 OID 16757)
-- Name: presta_material presta_material_id_biblioteca_publica_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presta_material
    ADD CONSTRAINT presta_material_id_biblioteca_publica_fkey FOREIGN KEY (id_biblioteca_publica) REFERENCES public.persona_juridica(id_persona_juridica) NOT VALID;


--
-- TOC entry 4911 (class 2606 OID 16762)
-- Name: provincia provincia_cod_region_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provincia
    ADD CONSTRAINT provincia_cod_region_fkey FOREIGN KEY (cod_region) REFERENCES public.region(cod_region);


--
-- TOC entry 4925 (class 2606 OID 16767)
-- Name: trabaja_museo trabaja_museo_id_museo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trabaja_museo
    ADD CONSTRAINT trabaja_museo_id_museo_fkey FOREIGN KEY (id_museo) REFERENCES public.museo(id_museo);


--
-- TOC entry 4926 (class 2606 OID 16772)
-- Name: trabaja_museo trabaja_museo_id_persona_natural_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trabaja_museo
    ADD CONSTRAINT trabaja_museo_id_persona_natural_fkey FOREIGN KEY (id_persona_natural) REFERENCES public.persona_natural(id_persona_natural) NOT VALID;


--
-- TOC entry 4927 (class 2606 OID 16777)
-- Name: visita_museo_anio visita_museo_anio_anio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visita_museo_anio
    ADD CONSTRAINT visita_museo_anio_anio_fkey FOREIGN KEY (anio) REFERENCES public.anio(anio);


--
-- TOC entry 4928 (class 2606 OID 16782)
-- Name: visita_museo_anio visita_museo_anio_id_museo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visita_museo_anio
    ADD CONSTRAINT visita_museo_anio_id_museo_fkey FOREIGN KEY (id_museo) REFERENCES public.museo(id_museo);


--
-- TOC entry 4929 (class 2606 OID 16787)
-- Name: visita_patrimonio visita_patrimonio_id_patrimonio_natural_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visita_patrimonio
    ADD CONSTRAINT visita_patrimonio_id_patrimonio_natural_fkey FOREIGN KEY (id_patrimonio_natural) REFERENCES public.patrimonio_natural(id_patrimonio_natural);


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE trabaja_museo; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.trabaja_museo FROM postgres;


-- Completed on 2024-09-28 23:44:07

--
-- PostgreSQL database dump complete
--

