--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.4

-- Started on 2024-10-09 22:25:15

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 24834)
-- Name: empresa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empresa (
    id_empresa integer NOT NULL,
    nombre_empresa character varying(25) NOT NULL
);


ALTER TABLE public.empresa OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 24837)
-- Name: orden_mantenimiento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orden_mantenimiento (
    cod_orden integer NOT NULL,
    rut integer NOT NULL,
    id_empresa integer NOT NULL,
    fecha_orden date NOT NULL,
    valor_total integer
);


ALTER TABLE public.orden_mantenimiento OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24840)
-- Name: repuesto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.repuesto (
    cod_repuesto integer NOT NULL,
    nombre_repuesto character varying(25) NOT NULL,
    valor_repuesto integer NOT NULL,
    stock_repuesto integer NOT NULL
);


ALTER TABLE public.repuesto OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24843)
-- Name: repuesto_orden; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.repuesto_orden (
    cod_orden integer NOT NULL,
    cod_repuesto integer NOT NULL,
    cantidad_repuesto integer NOT NULL
);


ALTER TABLE public.repuesto_orden OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24846)
-- Name: supervisor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supervisor (
    rut integer NOT NULL,
    nombre_supervisor character varying(25) NOT NULL
);


ALTER TABLE public.supervisor OWNER TO postgres;

--
-- TOC entry 4860 (class 0 OID 24834)
-- Dependencies: 215
-- Data for Name: empresa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empresa (id_empresa, nombre_empresa) FROM stdin;
11	Ecos
12	Metal
13	Prime
\.


--
-- TOC entry 4861 (class 0 OID 24837)
-- Dependencies: 216
-- Data for Name: orden_mantenimiento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orden_mantenimiento (cod_orden, rut, id_empresa, fecha_orden, valor_total) FROM stdin;
4545	222	12	2016-03-30	\N
5656	111	12	2016-06-12	7000
6767	111	13	2015-11-25	20000
8989	111	12	2014-06-12	\N
\.


--
-- TOC entry 4862 (class 0 OID 24840)
-- Dependencies: 217
-- Data for Name: repuesto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.repuesto (cod_repuesto, nombre_repuesto, valor_repuesto, stock_repuesto) FROM stdin;
124	manilla	300	10
123	motor	10000	5
125	estanque	5000	8
126	medidor	2500	2
127	polea	500	15
\.


--
-- TOC entry 4863 (class 0 OID 24843)
-- Dependencies: 218
-- Data for Name: repuesto_orden; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.repuesto_orden (cod_orden, cod_repuesto, cantidad_repuesto) FROM stdin;
5656	127	4
5656	125	1
6767	123	2
\.


--
-- TOC entry 4864 (class 0 OID 24846)
-- Dependencies: 219
-- Data for Name: supervisor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supervisor (rut, nombre_supervisor) FROM stdin;
111	Jose
222	Luis
333	Maria
\.


--
-- TOC entry 4704 (class 2606 OID 24850)
-- Name: empresa empresa_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_pk PRIMARY KEY (id_empresa);


--
-- TOC entry 4706 (class 2606 OID 24852)
-- Name: orden_mantenimiento orden_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_mantenimiento
    ADD CONSTRAINT orden_pk PRIMARY KEY (cod_orden);


--
-- TOC entry 4710 (class 2606 OID 24854)
-- Name: repuesto_orden orden_repuesto_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repuesto_orden
    ADD CONSTRAINT orden_repuesto_pk PRIMARY KEY (cod_orden, cod_repuesto);


--
-- TOC entry 4708 (class 2606 OID 24856)
-- Name: repuesto repuesto_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repuesto
    ADD CONSTRAINT repuesto_pk PRIMARY KEY (cod_repuesto);


--
-- TOC entry 4712 (class 2606 OID 24858)
-- Name: supervisor supervidor; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supervisor
    ADD CONSTRAINT supervidor PRIMARY KEY (rut);


--
-- TOC entry 4713 (class 2606 OID 24859)
-- Name: orden_mantenimiento orden_empresa_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_mantenimiento
    ADD CONSTRAINT orden_empresa_fk FOREIGN KEY (id_empresa) REFERENCES public.empresa(id_empresa);


--
-- TOC entry 4715 (class 2606 OID 24864)
-- Name: repuesto_orden orden_rep_orden; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repuesto_orden
    ADD CONSTRAINT orden_rep_orden FOREIGN KEY (cod_orden) REFERENCES public.orden_mantenimiento(cod_orden);


--
-- TOC entry 4716 (class 2606 OID 24869)
-- Name: repuesto_orden orden_rep_repuesto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repuesto_orden
    ADD CONSTRAINT orden_rep_repuesto FOREIGN KEY (cod_repuesto) REFERENCES public.repuesto(cod_repuesto);


--
-- TOC entry 4714 (class 2606 OID 24874)
-- Name: orden_mantenimiento orden_supervisor_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_mantenimiento
    ADD CONSTRAINT orden_supervisor_fk FOREIGN KEY (rut) REFERENCES public.supervisor(rut);


-- Completed on 2024-10-09 22:25:15

--
-- PostgreSQL database dump complete
--

