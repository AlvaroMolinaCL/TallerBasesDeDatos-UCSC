--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-10-11 00:27:27

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
-- TOC entry 849 (class 1247 OID 16650)
-- Name: especie; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.especie AS character varying(15) NOT NULL
	CONSTRAINT estado_ck CHECK ((((VALUE)::text = 'pino'::text) OR ((VALUE)::text = 'eucaliptus'::text)));


ALTER DOMAIN public.especie OWNER TO postgres;

--
-- TOC entry 853 (class 1247 OID 16653)
-- Name: tipo_des; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.tipo_des AS character varying(10)
	CONSTRAINT des_ck CHECK ((((VALUE)::text = 'incendio'::text) OR ((VALUE)::text = 'plaga'::text)));


ALTER DOMAIN public.tipo_des OWNER TO postgres;

--
-- TOC entry 857 (class 1247 OID 16656)
-- Name: tipo_fae; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.tipo_fae AS character varying(12)
	CONSTRAINT plant_ck CHECK ((((VALUE)::text = 'plantacion'::text) OR ((VALUE)::text = 'cosecha'::text)));


ALTER DOMAIN public.tipo_fae OWNER TO postgres;

--
-- TOC entry 861 (class 1247 OID 16659)
-- Name: tipo_ins; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.tipo_ins AS character varying(15)
	CONSTRAINT ins_ck CHECK ((((VALUE)::text = 'bodega'::text) OR ((VALUE)::text = 'patio acopio'::text) OR ((VALUE)::text = 'oficina'::text)));


ALTER DOMAIN public.tipo_ins OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16661)
-- Name: bosque; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bosque (
    cod_bosque integer NOT NULL,
    cod_predio integer NOT NULL,
    superficie_bosque integer NOT NULL,
    especie_bosque public.especie NOT NULL
);


ALTER TABLE public.bosque OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16666)
-- Name: contratista_faena; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contratista_faena (
    rut_contratista integer NOT NULL,
    nombre_contratista character varying(20) NOT NULL,
    superficie_total_faena integer
);


ALTER TABLE public.contratista_faena OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16669)
-- Name: contratista_mantencion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contratista_mantencion (
    rut_contratista integer NOT NULL,
    nombre_contratista character varying(15) NOT NULL,
    superficie_total_mantencion integer
);


ALTER TABLE public.contratista_mantencion OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16672)
-- Name: desastre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.desastre (
    id_desastre integer NOT NULL,
    superficie_total_desastre integer NOT NULL,
    tipo_desastre public.tipo_des NOT NULL,
    fecha date NOT NULL
);


ALTER TABLE public.desastre OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16677)
-- Name: desastre_bosque; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.desastre_bosque (
    id_desastre integer NOT NULL,
    cod_bosque integer NOT NULL,
    superficie_desastre_bosque integer NOT NULL
);


ALTER TABLE public.desastre_bosque OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16680)
-- Name: faena; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faena (
    id_faena integer NOT NULL,
    rut_contratista integer NOT NULL,
    cod_bosque integer NOT NULL,
    superficie_faena integer NOT NULL,
    tipo_faena public.tipo_fae NOT NULL
);


ALTER TABLE public.faena OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16685)
-- Name: forestal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.forestal (
    cod_forestal integer NOT NULL,
    nombre character varying(20) NOT NULL
);


ALTER TABLE public.forestal OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16688)
-- Name: instalacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instalacion (
    cod_instalacion integer NOT NULL,
    cod_predio integer NOT NULL,
    tipo_instalacion public.tipo_ins NOT NULL,
    superficie_instalacion integer NOT NULL
);


ALTER TABLE public.instalacion OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16693)
-- Name: mantencion_instalacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mantencion_instalacion (
    cod_mantencion integer NOT NULL,
    cod_instalacion integer NOT NULL,
    rut_contratista integer NOT NULL,
    superficie_mantencion integer NOT NULL
);


ALTER TABLE public.mantencion_instalacion OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16696)
-- Name: predio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.predio (
    cod_predio integer NOT NULL,
    cod_forestal integer NOT NULL,
    nombre_predio character varying(20) NOT NULL,
    superficie_total integer NOT NULL,
    valor_comercial integer NOT NULL
);


ALTER TABLE public.predio OWNER TO postgres;

--
-- TOC entry 4912 (class 0 OID 16661)
-- Dependencies: 215
-- Data for Name: bosque; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bosque (cod_bosque, cod_predio, superficie_bosque, especie_bosque) FROM stdin;
11	1	100	pino
12	1	150	pino
13	1	200	eucaliptus
21	2	300	pino
22	2	50	pino
31	3	150	eucaliptus
41	4	500	pino
61	6	200	eucaliptus
62	6	100	pino
63	6	80	eucaliptus
\.


--
-- TOC entry 4913 (class 0 OID 16666)
-- Dependencies: 216
-- Data for Name: contratista_faena; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contratista_faena (rut_contratista, nombre_contratista, superficie_total_faena) FROM stdin;
111	Pedro Pablo	350
222	Julio Nova	0
333	Martin Acevedo	100
444	Camilo Lozano	280
\.


--
-- TOC entry 4914 (class 0 OID 16669)
-- Dependencies: 217
-- Data for Name: contratista_mantencion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contratista_mantencion (rut_contratista, nombre_contratista, superficie_total_mantencion) FROM stdin;
901	Raul Gomez	30
902	Pedro Jimenez	55
903	Jaime Pinto	0
904	Julio Melgarejo	30
\.


--
-- TOC entry 4915 (class 0 OID 16672)
-- Dependencies: 218
-- Data for Name: desastre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.desastre (id_desastre, superficie_total_desastre, tipo_desastre, fecha) FROM stdin;
66	110	incendio	2023-01-11
77	30	incendio	2023-02-20
88	40	plaga	2022-11-25
99	30	plaga	2023-03-12
55	0	incendio	2023-02-25
\.


--
-- TOC entry 4916 (class 0 OID 16677)
-- Dependencies: 219
-- Data for Name: desastre_bosque; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.desastre_bosque (id_desastre, cod_bosque, superficie_desastre_bosque) FROM stdin;
66	12	50
66	31	20
88	62	40
99	63	20
99	13	10
66	62	40
77	31	30
\.


--
-- TOC entry 4917 (class 0 OID 16680)
-- Dependencies: 220
-- Data for Name: faena; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faena (id_faena, rut_contratista, cod_bosque, superficie_faena, tipo_faena) FROM stdin;
11111	111	11	50	plantacion
11112	111	12	50	cosecha
11113	111	13	150	plantacion
33311	333	11	50	cosecha
33322	333	22	50	plantacion
44462	444	62	80	cosecha
44441	444	41	200	cosecha
11141	111	41	100	plantacion
\.


--
-- TOC entry 4918 (class 0 OID 16685)
-- Dependencies: 221
-- Data for Name: forestal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.forestal (cod_forestal, nombre) FROM stdin;
1	Forestal Biobio
2	Forestal Arauco
3	Forestal Valdivia
4	Forestal Millalemu
5	Forestal Infinito
\.


--
-- TOC entry 4919 (class 0 OID 16688)
-- Dependencies: 222
-- Data for Name: instalacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instalacion (cod_instalacion, cod_predio, tipo_instalacion, superficie_instalacion) FROM stdin;
911	1	bodega	30
913	3	bodega	20
921	1	patio acopio	50
915	5	bodega	40
925	5	oficina	10
914	4	patio acopio	100
923	3	bodega	15
933	3	patio acopio	40
\.


--
-- TOC entry 4920 (class 0 OID 16693)
-- Dependencies: 223
-- Data for Name: mantencion_instalacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mantencion_instalacion (cod_mantencion, cod_instalacion, rut_contratista, superficie_mantencion) FROM stdin;
1001	911	902	10
1002	914	904	30
1003	914	902	40
1004	915	901	10
1005	921	901	20
1006	911	902	5
\.


--
-- TOC entry 4921 (class 0 OID 16696)
-- Dependencies: 224
-- Data for Name: predio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.predio (cod_predio, cod_forestal, nombre_predio, superficie_total, valor_comercial) FROM stdin;
1	1	Fundo Pidima	1000	10000
2	2	Fundo Patagual	1500	15000
3	1	Fundo Agua Amarilla	900	9000
4	2	Fundo Mininco	3000	30000
5	3	Fundo Colinas	2000	20000
6	2	Fundo Arauco	4000	40000
7	5	Fundo Infinito	500	5000
\.


--
-- TOC entry 4740 (class 2606 OID 16700)
-- Name: bosque bosque_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bosque
    ADD CONSTRAINT bosque_pkey PRIMARY KEY (cod_bosque);


--
-- TOC entry 4744 (class 2606 OID 16702)
-- Name: contratista_mantencion contratista_mantencion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratista_mantencion
    ADD CONSTRAINT contratista_mantencion_pkey PRIMARY KEY (rut_contratista);


--
-- TOC entry 4742 (class 2606 OID 16704)
-- Name: contratista_faena contratista_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratista_faena
    ADD CONSTRAINT contratista_pkey PRIMARY KEY (rut_contratista);


--
-- TOC entry 4748 (class 2606 OID 16706)
-- Name: desastre_bosque desastre_bosque_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.desastre_bosque
    ADD CONSTRAINT desastre_bosque_pkey PRIMARY KEY (id_desastre, cod_bosque);


--
-- TOC entry 4746 (class 2606 OID 16708)
-- Name: desastre desastre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.desastre
    ADD CONSTRAINT desastre_pkey PRIMARY KEY (id_desastre);


--
-- TOC entry 4750 (class 2606 OID 16710)
-- Name: faena faena_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faena
    ADD CONSTRAINT faena_pkey PRIMARY KEY (id_faena);


--
-- TOC entry 4752 (class 2606 OID 16712)
-- Name: forestal forestal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forestal
    ADD CONSTRAINT forestal_pkey PRIMARY KEY (cod_forestal);


--
-- TOC entry 4754 (class 2606 OID 16714)
-- Name: instalacion instalacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instalacion
    ADD CONSTRAINT instalacion_pkey PRIMARY KEY (cod_instalacion);


--
-- TOC entry 4756 (class 2606 OID 16716)
-- Name: mantencion_instalacion mantencion_instalacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mantencion_instalacion
    ADD CONSTRAINT mantencion_instalacion_pkey PRIMARY KEY (cod_mantencion);


--
-- TOC entry 4759 (class 2606 OID 16718)
-- Name: predio predio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predio
    ADD CONSTRAINT predio_pkey PRIMARY KEY (cod_predio);


--
-- TOC entry 4757 (class 1259 OID 16719)
-- Name: fki_predio_forestal_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_predio_forestal_fk ON public.predio USING btree (cod_forestal);


--
-- TOC entry 4760 (class 2606 OID 16720)
-- Name: bosque bosque_predio_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bosque
    ADD CONSTRAINT bosque_predio_fk FOREIGN KEY (cod_predio) REFERENCES public.predio(cod_predio) NOT VALID;


--
-- TOC entry 4766 (class 2606 OID 16725)
-- Name: mantencion_instalacion contratista_mantencion_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mantencion_instalacion
    ADD CONSTRAINT contratista_mantencion_fk FOREIGN KEY (rut_contratista) REFERENCES public.contratista_mantencion(rut_contratista) NOT VALID;


--
-- TOC entry 4761 (class 2606 OID 16730)
-- Name: desastre_bosque desastre_bosque_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.desastre_bosque
    ADD CONSTRAINT desastre_bosque_fk FOREIGN KEY (cod_bosque) REFERENCES public.bosque(cod_bosque);


--
-- TOC entry 4762 (class 2606 OID 16735)
-- Name: desastre_bosque desastre_desastre_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.desastre_bosque
    ADD CONSTRAINT desastre_desastre_fk FOREIGN KEY (id_desastre) REFERENCES public.desastre(id_desastre);


--
-- TOC entry 4763 (class 2606 OID 16740)
-- Name: faena faena_bosque_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faena
    ADD CONSTRAINT faena_bosque_fk FOREIGN KEY (cod_bosque) REFERENCES public.bosque(cod_bosque);


--
-- TOC entry 4764 (class 2606 OID 16745)
-- Name: faena faena_contratista_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faena
    ADD CONSTRAINT faena_contratista_fk FOREIGN KEY (rut_contratista) REFERENCES public.contratista_faena(rut_contratista);


--
-- TOC entry 4765 (class 2606 OID 16750)
-- Name: instalacion instalacion_predio_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instalacion
    ADD CONSTRAINT instalacion_predio_fk FOREIGN KEY (cod_predio) REFERENCES public.predio(cod_predio) NOT VALID;


--
-- TOC entry 4767 (class 2606 OID 16755)
-- Name: mantencion_instalacion mantencion_instalacion_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mantencion_instalacion
    ADD CONSTRAINT mantencion_instalacion_fk FOREIGN KEY (cod_instalacion) REFERENCES public.instalacion(cod_instalacion) NOT VALID;


--
-- TOC entry 4768 (class 2606 OID 16760)
-- Name: predio predio_forestal_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predio
    ADD CONSTRAINT predio_forestal_fk FOREIGN KEY (cod_forestal) REFERENCES public.forestal(cod_forestal) NOT VALID;


-- Completed on 2024-10-11 00:27:27

--
-- PostgreSQL database dump complete
--

