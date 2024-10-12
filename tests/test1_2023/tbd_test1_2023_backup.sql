--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.4

-- Started on 2024-10-09 15:58:07

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
-- TOC entry 847 (class 1247 OID 24738)
-- Name: especie; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.especie AS character varying(15) NOT NULL
	CONSTRAINT estado_ck CHECK ((((VALUE)::text = 'pino'::text) OR ((VALUE)::text = 'eucaliptus'::text)));


ALTER DOMAIN public.especie OWNER TO postgres;

--
-- TOC entry 851 (class 1247 OID 24741)
-- Name: tipo_des; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.tipo_des AS character varying(10)
	CONSTRAINT des_ck CHECK ((((VALUE)::text = 'incendio'::text) OR ((VALUE)::text = 'plaga'::text)));


ALTER DOMAIN public.tipo_des OWNER TO postgres;

--
-- TOC entry 855 (class 1247 OID 24744)
-- Name: tipo_fae; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.tipo_fae AS character varying(12)
	CONSTRAINT plant_ck CHECK ((((VALUE)::text = 'plantacion'::text) OR ((VALUE)::text = 'cosecha'::text)));


ALTER DOMAIN public.tipo_fae OWNER TO postgres;

--
-- TOC entry 859 (class 1247 OID 24747)
-- Name: tipo_ins; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.tipo_ins AS character varying(15)
	CONSTRAINT ins_ck CHECK ((((VALUE)::text = 'bodega'::text) OR ((VALUE)::text = 'patio acopio'::text) OR ((VALUE)::text = 'oficina'::text)));


ALTER DOMAIN public.tipo_ins OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 24749)
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
-- TOC entry 216 (class 1259 OID 24754)
-- Name: contratista; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contratista (
    rut_contratista integer NOT NULL,
    nombre_contratista character varying(20) NOT NULL
);


ALTER TABLE public.contratista OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24757)
-- Name: desastre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.desastre (
    id_desastre integer NOT NULL,
    superficie_desastre integer NOT NULL,
    tipo_desastre public.tipo_des NOT NULL,
    fecha date NOT NULL
);


ALTER TABLE public.desastre OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24762)
-- Name: desastre_bosque; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.desastre_bosque (
    id_desastre integer NOT NULL,
    cod_bosque integer NOT NULL,
    superficie_desastre_bosque integer NOT NULL
);


ALTER TABLE public.desastre_bosque OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24765)
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
-- TOC entry 220 (class 1259 OID 24770)
-- Name: forestal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.forestal (
    cod_forestal integer NOT NULL,
    nombre character varying(20) NOT NULL
);


ALTER TABLE public.forestal OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24773)
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
-- TOC entry 222 (class 1259 OID 24778)
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
-- TOC entry 4898 (class 0 OID 24749)
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
-- TOC entry 4899 (class 0 OID 24754)
-- Dependencies: 216
-- Data for Name: contratista; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contratista (rut_contratista, nombre_contratista) FROM stdin;
111	Pedro Pablo
222	Julio Nova
333	Martin Acevedo
444	Camilo Lozano
\.


--
-- TOC entry 4900 (class 0 OID 24757)
-- Dependencies: 217
-- Data for Name: desastre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.desastre (id_desastre, superficie_desastre, tipo_desastre, fecha) FROM stdin;
66	100	incendio	2023-01-11
77	250	incendio	2023-02-20
88	80	plaga	2022-11-25
99	150	plaga	2023-03-12
\.


--
-- TOC entry 4901 (class 0 OID 24762)
-- Dependencies: 218
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
-- TOC entry 4902 (class 0 OID 24765)
-- Dependencies: 219
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
-- TOC entry 4903 (class 0 OID 24770)
-- Dependencies: 220
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
-- TOC entry 4904 (class 0 OID 24773)
-- Dependencies: 221
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
-- TOC entry 4905 (class 0 OID 24778)
-- Dependencies: 222
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
-- TOC entry 4732 (class 2606 OID 24782)
-- Name: bosque bosque_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bosque
    ADD CONSTRAINT bosque_pkey PRIMARY KEY (cod_bosque);


--
-- TOC entry 4734 (class 2606 OID 24784)
-- Name: contratista contratista_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratista
    ADD CONSTRAINT contratista_pkey PRIMARY KEY (rut_contratista);


--
-- TOC entry 4738 (class 2606 OID 24786)
-- Name: desastre_bosque desastre_bosque_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.desastre_bosque
    ADD CONSTRAINT desastre_bosque_pkey PRIMARY KEY (id_desastre, cod_bosque);


--
-- TOC entry 4736 (class 2606 OID 24788)
-- Name: desastre desastre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.desastre
    ADD CONSTRAINT desastre_pkey PRIMARY KEY (id_desastre);


--
-- TOC entry 4740 (class 2606 OID 24790)
-- Name: faena faena_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faena
    ADD CONSTRAINT faena_pkey PRIMARY KEY (id_faena);


--
-- TOC entry 4742 (class 2606 OID 24792)
-- Name: forestal forestal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forestal
    ADD CONSTRAINT forestal_pkey PRIMARY KEY (cod_forestal);


--
-- TOC entry 4744 (class 2606 OID 24794)
-- Name: instalacion instalacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instalacion
    ADD CONSTRAINT instalacion_pkey PRIMARY KEY (cod_instalacion);


--
-- TOC entry 4747 (class 2606 OID 24796)
-- Name: predio predio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predio
    ADD CONSTRAINT predio_pkey PRIMARY KEY (cod_predio);


--
-- TOC entry 4745 (class 1259 OID 24797)
-- Name: fki_predio_forestal_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_predio_forestal_fk ON public.predio USING btree (cod_forestal);


--
-- TOC entry 4748 (class 2606 OID 24798)
-- Name: bosque bosque_predio_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bosque
    ADD CONSTRAINT bosque_predio_fk FOREIGN KEY (cod_predio) REFERENCES public.predio(cod_predio) NOT VALID;


--
-- TOC entry 4749 (class 2606 OID 24803)
-- Name: desastre_bosque desastre_bosque_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.desastre_bosque
    ADD CONSTRAINT desastre_bosque_fk FOREIGN KEY (cod_bosque) REFERENCES public.bosque(cod_bosque);


--
-- TOC entry 4750 (class 2606 OID 24808)
-- Name: desastre_bosque desastre_desastre_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.desastre_bosque
    ADD CONSTRAINT desastre_desastre_fk FOREIGN KEY (id_desastre) REFERENCES public.desastre(id_desastre);


--
-- TOC entry 4751 (class 2606 OID 24813)
-- Name: faena faena_bosque_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faena
    ADD CONSTRAINT faena_bosque_fk FOREIGN KEY (cod_bosque) REFERENCES public.bosque(cod_bosque);


--
-- TOC entry 4752 (class 2606 OID 24818)
-- Name: faena faena_contratista_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faena
    ADD CONSTRAINT faena_contratista_fk FOREIGN KEY (rut_contratista) REFERENCES public.contratista(rut_contratista);


--
-- TOC entry 4753 (class 2606 OID 24823)
-- Name: instalacion instalacion_predio_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instalacion
    ADD CONSTRAINT instalacion_predio_fk FOREIGN KEY (cod_predio) REFERENCES public.predio(cod_predio) NOT VALID;


--
-- TOC entry 4754 (class 2606 OID 24828)
-- Name: predio predio_forestal_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predio
    ADD CONSTRAINT predio_forestal_fk FOREIGN KEY (cod_forestal) REFERENCES public.forestal(cod_forestal) NOT VALID;


-- Completed on 2024-10-09 15:58:07

--
-- PostgreSQL database dump complete
--

