--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-10-10 01:53:10

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
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16510)
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    rut integer NOT NULL,
    nombre character varying(30),
    apellido character varying(30),
    direccion text NOT NULL,
    telefono character varying(15),
    zona smallint NOT NULL
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16515)
-- Name: contrato; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contrato (
    codigo integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_termino date NOT NULL,
    cliente integer NOT NULL,
    vendedor integer NOT NULL,
    servicio smallint NOT NULL
);


ALTER TABLE public.contrato OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16518)
-- Name: disponibilidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disponibilidad (
    codigo_zona smallint NOT NULL,
    codigo_servicio smallint NOT NULL
);


ALTER TABLE public.disponibilidad OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16521)
-- Name: servicio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servicio (
    codigo smallint NOT NULL,
    nombre character varying(30) NOT NULL,
    descripcion text,
    precio integer NOT NULL,
    cobro character varying(15) NOT NULL
);


ALTER TABLE public.servicio OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16526)
-- Name: vendedor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendedor (
    rut integer NOT NULL,
    nombre character varying(30) NOT NULL,
    apellido character varying(30) NOT NULL,
    telefono character varying(15)
);


ALTER TABLE public.vendedor OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16529)
-- Name: zona; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zona (
    codigo smallint NOT NULL,
    nombre character varying(30) NOT NULL,
    descripcion text,
    ciudad character varying(30) NOT NULL
);


ALTER TABLE public.zona OWNER TO postgres;

--
-- TOC entry 4868 (class 0 OID 16510)
-- Dependencies: 215
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente (rut, nombre, apellido, direccion, telefono, zona) FROM stdin;
5667897	\N	\N	Calle el Alama 4590	8901112	2
78976511	Sebastian	Nuñez	Edificio Gran Domo, departamento 6, LAs rosas 89	1690554	2
98067541	Romina	Rominola	Calle dos 8901	\N	1
17853251	Godofredo	Caballero	Ruperto 16789	\N	3
7679982	\N	\N	Avenida 30 de Noviembre  8090	898900	3
1123451	\N	\N	Edificios Liberales 6090	1278944	5
2344987	\N	\N	Ripio 60	2331899	5
12221178	Rodolfo	Matamala	Calle Alejo 1920	\N	6
89876521	Dorian	Fuguet	Gran camino norte, edificio Azul, oficina 45	\N	5
11297644	Emilio	Palta	Carmen Herrera 790	\N	5
98764109	\N	\N	Municipalidad de Yumbel	8900015	8
\.


--
-- TOC entry 4869 (class 0 OID 16515)
-- Dependencies: 216
-- Data for Name: contrato; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contrato (codigo, fecha_inicio, fecha_termino, cliente, vendedor, servicio) FROM stdin;
1	2022-04-17	2022-05-10	1123451	15627142	5
2	2021-04-17	2022-04-17	17853251	15627142	4
3	2020-04-17	2021-04-17	17853251	15627142	4
4	2021-04-17	2022-04-17	17853251	22715621	6
5	2018-09-19	2024-10-10	11297644	76651982	6
6	2012-08-21	2012-09-19	2344987	76651982	1
7	2022-03-03	2022-03-03	12221178	67876541	8
8	2018-10-11	2018-10-11	12221178	76651982	11
\.


--
-- TOC entry 4870 (class 0 OID 16518)
-- Dependencies: 217
-- Data for Name: disponibilidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.disponibilidad (codigo_zona, codigo_servicio) FROM stdin;
7	14
1	4
1	5
1	6
3	4
3	5
3	6
4	4
4	5
4	6
5	4
5	5
5	6
7	4
7	5
7	6
1	1
1	2
1	3
3	1
3	2
3	3
3	12
2	1
7	2
1	7
3	7
4	7
5	7
7	8
6	8
6	11
\.


--
-- TOC entry 4871 (class 0 OID 16521)
-- Dependencies: 218
-- Data for Name: servicio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.servicio (codigo, nombre, descripcion, precio, cobro) FROM stdin;
7	Servicio tecnico simple	\N	35000	pago unico
8	Servicio tecnico avanzado	\N	55000	pago unico
9	Plan cuadruple	Plan completo general	68000	mensual
10	Internet Avanzado	\N	79990	mensual
11	Servicio Azar	\N	100000	pago unico
12	Plan sorpresa	Plan promocional 2018	13990	mensual
13	H79801	H7898 Solo habilitado para  el verano del 2017	256000	otro
14	Comuna conectada	Unicamente para Chiguayante	6000	mensual
1	Plan internet doble	instalacion gratuita	9900	mensual
2	Plan internet triple	instalacion gratuita	15000	mensual
3	Internet navidad	instalacion gratuita	67000	mensual
4	Telefono simple	instalacion gratuita	5000	mensual
5	Internet simple	instalacion gratuita	7000	mensual
6	Television simple	instalacion gratuita, equipos disponibles	45000	mensual
\.


--
-- TOC entry 4872 (class 0 OID 16526)
-- Dependencies: 219
-- Data for Name: vendedor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendedor (rut, nombre, apellido, telefono) FROM stdin;
67876541	Mark	Hoppus	895678
13586124	Roberto	Toledo	123480
12345912	Javiera	Perez	\N
15627142	Tania	Arroz	\N
4468909	Rogelio	Caballero	809067
98986432	Minerva	Barra	\N
11241987	Arturo 	Lopez	560091
22715621	Dillman	San Martín	\N
981121	Doble	Rebolledo	\N
76651982	Paz Artura	Godofredina	178500
15676122	Rubén	Garcia	\N
\.


--
-- TOC entry 4873 (class 0 OID 16529)
-- Dependencies: 220
-- Data for Name: zona; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.zona (codigo, nombre, descripcion, ciudad) FROM stdin;
1	Norte Talca	\N	Talca
2	Sur Talca	\N	Talca
3	Concepcion A	\N	Concepcion
4	Concepcion B	\N	Concepcion
5	Concepcion C	\N	Concepcion
6	Concepcion D	\N	Concepcion
7	Chiguayante	Toda Chiguayante	Chiguayante
8	Yumbel Metropolitano	\N	Yumbel
\.


--
-- TOC entry 4708 (class 2606 OID 16535)
-- Name: cliente cliente_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pk PRIMARY KEY (rut);


--
-- TOC entry 4710 (class 2606 OID 16537)
-- Name: contrato contrato_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contrato
    ADD CONSTRAINT contrato_pk PRIMARY KEY (codigo);


--
-- TOC entry 4712 (class 2606 OID 16539)
-- Name: disponibilidad disponibilidad_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disponibilidad
    ADD CONSTRAINT disponibilidad_pk PRIMARY KEY (codigo_zona, codigo_servicio);


--
-- TOC entry 4714 (class 2606 OID 16541)
-- Name: servicio servicio_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicio
    ADD CONSTRAINT servicio_pk PRIMARY KEY (codigo);


--
-- TOC entry 4716 (class 2606 OID 16543)
-- Name: vendedor vendedor_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendedor
    ADD CONSTRAINT vendedor_pk PRIMARY KEY (rut);


--
-- TOC entry 4718 (class 2606 OID 16545)
-- Name: zona zona_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zona
    ADD CONSTRAINT zona_pk PRIMARY KEY (codigo);


--
-- TOC entry 4719 (class 2606 OID 16546)
-- Name: cliente cliente_zona_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_zona_fk FOREIGN KEY (zona) REFERENCES public.zona(codigo);


--
-- TOC entry 4720 (class 2606 OID 16551)
-- Name: contrato contrato_cliente_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contrato
    ADD CONSTRAINT contrato_cliente_fk FOREIGN KEY (cliente) REFERENCES public.cliente(rut);


--
-- TOC entry 4721 (class 2606 OID 16556)
-- Name: contrato contrato_servicio_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contrato
    ADD CONSTRAINT contrato_servicio_fk FOREIGN KEY (servicio) REFERENCES public.servicio(codigo);


--
-- TOC entry 4722 (class 2606 OID 16561)
-- Name: contrato contrato_vendedor_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contrato
    ADD CONSTRAINT contrato_vendedor_fk FOREIGN KEY (vendedor) REFERENCES public.vendedor(rut);


--
-- TOC entry 4723 (class 2606 OID 16566)
-- Name: disponibilidad disponibilidad_servicio_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disponibilidad
    ADD CONSTRAINT disponibilidad_servicio_fk_1 FOREIGN KEY (codigo_servicio) REFERENCES public.servicio(codigo);


--
-- TOC entry 4724 (class 2606 OID 16571)
-- Name: disponibilidad disponibilidad_zona_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disponibilidad
    ADD CONSTRAINT disponibilidad_zona_fk FOREIGN KEY (codigo_zona) REFERENCES public.zona(codigo);


-- Completed on 2024-10-10 01:53:11

--
-- PostgreSQL database dump complete
--

