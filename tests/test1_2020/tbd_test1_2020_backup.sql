--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

-- Started on 2024-10-09 14:28:34

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
-- TOC entry 846 (class 1247 OID 24591)
-- Name: mov_cuenta; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.mov_cuenta AS character varying(10) NOT NULL
	CONSTRAINT mov_cuenta_ck CHECK ((((VALUE)::text = 'abono'::text) OR ((VALUE)::text = 'cargo'::text) OR ((VALUE)::text = 'pago_linea'::text)));


ALTER DOMAIN public.mov_cuenta OWNER TO postgres;

--
-- TOC entry 850 (class 1247 OID 24594)
-- Name: mov_tarjeta; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.mov_tarjeta AS character varying(10)
	CONSTRAINT mov_tarjeta_check CHECK ((((VALUE)::text = 'compra'::text) OR ((VALUE)::text = 'pago'::text)));


ALTER DOMAIN public.mov_tarjeta OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 24596)
-- Name: banco; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banco (
    codigo character(2) NOT NULL,
    nombre character varying(15) NOT NULL
);


ALTER TABLE public.banco OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 24599)
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    rut integer NOT NULL,
    nombre character varying(20) NOT NULL,
    codigo character(2) NOT NULL
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24602)
-- Name: cuenta_corriente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuenta_corriente (
    numero_cuenta integer NOT NULL,
    rut integer NOT NULL,
    saldo_cuenta bigint NOT NULL
);


ALTER TABLE public.cuenta_corriente OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24605)
-- Name: linea_credito; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.linea_credito (
    id_linea integer NOT NULL,
    numero_cuenta integer NOT NULL,
    monto_aprobado double precision NOT NULL,
    monto_utilizado double precision NOT NULL
);


ALTER TABLE public.linea_credito OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24608)
-- Name: movimiento_cuenta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movimiento_cuenta (
    id_movimiento integer NOT NULL,
    numero_cuenta integer NOT NULL,
    monto bigint NOT NULL,
    fecha date NOT NULL,
    tipo_movimiento public.mov_cuenta NOT NULL
);


ALTER TABLE public.movimiento_cuenta OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24613)
-- Name: movimiento_tarjeta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movimiento_tarjeta (
    id_movimiento integer NOT NULL,
    numero_tarjeta integer NOT NULL,
    monto bigint NOT NULL,
    fecha date NOT NULL,
    tipo_movimiento public.mov_tarjeta NOT NULL
);


ALTER TABLE public.movimiento_tarjeta OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24618)
-- Name: tarjeta_credito; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tarjeta_credito (
    numero_tarjeta integer NOT NULL,
    rut integer NOT NULL,
    saldo_tarjeta bigint NOT NULL
);


ALTER TABLE public.tarjeta_credito OWNER TO postgres;

--
-- TOC entry 4883 (class 0 OID 24596)
-- Dependencies: 215
-- Data for Name: banco; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banco (codigo, nombre) FROM stdin;
AA	Santander
BB	BCI
CC	Itau
DD	Chile
EE	Estado
\.


--
-- TOC entry 4884 (class 0 OID 24599)
-- Dependencies: 216
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente (rut, nombre, codigo) FROM stdin;
111	Monica Pinto	AA
112	Sebastian Gonzalez	AA
113	Patricia Martinez	AA
114	Luis Perez	BB
115	Jose Brito	BB
117	Danilo Alvarez	DD
118	Joaquin Valdes	DD
\.


--
-- TOC entry 4885 (class 0 OID 24602)
-- Dependencies: 217
-- Data for Name: cuenta_corriente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cuenta_corriente (numero_cuenta, rut, saldo_cuenta) FROM stdin;
331	111	560000
332	113	1500000
333	114	150000
334	114	300000
335	115	80000
338	117	30000
\.


--
-- TOC entry 4886 (class 0 OID 24605)
-- Dependencies: 218
-- Data for Name: linea_credito; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.linea_credito (id_linea, numero_cuenta, monto_aprobado, monto_utilizado) FROM stdin;
1	331	1000000	0
4	338	700000	100000
2	333	1000000	600000
\.


--
-- TOC entry 4887 (class 0 OID 24608)
-- Dependencies: 219
-- Data for Name: movimiento_cuenta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movimiento_cuenta (id_movimiento, numero_cuenta, monto, fecha, tipo_movimiento) FROM stdin;
1	331	2000	2018-03-12	cargo
2	331	40000	2018-06-20	cargo
3	331	100000	2018-08-20	abono
4	331	50000	2019-11-20	cargo
5	332	40000	2019-03-03	cargo
6	332	30000	2019-06-06	cargo
8	332	50000	2019-08-08	cargo
9	334	15000	2019-05-10	cargo
10	334	30000	2019-08-10	cargo
11	334	40000	2019-10-10	abono
12	334	10000	2018-04-10	abono
13	334	20000	2018-07-10	cargo
14	335	15000	2018-01-13	cargo
15	335	15000	2018-03-01	abono
16	331	30000	2019-03-03	pago_linea
17	333	60000	2019-05-05	pago_linea
7	332	150000	2019-07-07	abono
\.


--
-- TOC entry 4888 (class 0 OID 24613)
-- Dependencies: 220
-- Data for Name: movimiento_tarjeta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movimiento_tarjeta (id_movimiento, numero_tarjeta, monto, fecha, tipo_movimiento) FROM stdin;
1	41	15000	2018-05-05	compra
2	41	25000	2018-06-06	pago
3	41	10000	2018-04-04	compra
4	42	30000	2018-01-03	compra
5	42	10000	2018-03-04	compra
7	42	60000	2018-10-10	pago
8	42	50000	2019-05-05	compra
10	45	10000	2019-06-08	compra
12	45	40000	2019-09-07	pago
13	47	30000	2019-06-07	compra
14	47	30000	2019-08-09	pago
15	48	15000	2018-03-03	compra
16	48	15000	2018-09-09	pago
6	42	20000	2018-03-05	compra
9	42	40000	2019-05-06	pago
17	45	20000	2019-09-20	pago
11	45	15000	2019-06-18	compra
\.


--
-- TOC entry 4889 (class 0 OID 24618)
-- Dependencies: 221
-- Data for Name: tarjeta_credito; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tarjeta_credito (numero_tarjeta, rut, saldo_tarjeta) FROM stdin;
41	111	50000
42	112	85000
43	113	45000
47	117	300000
45	114	200000
48	117	40000
\.


--
-- TOC entry 4720 (class 2606 OID 24622)
-- Name: banco banco_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco
    ADD CONSTRAINT banco_pk PRIMARY KEY (codigo);


--
-- TOC entry 4722 (class 2606 OID 24624)
-- Name: cliente cliente_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pk PRIMARY KEY (rut);


--
-- TOC entry 4724 (class 2606 OID 24626)
-- Name: cuenta_corriente cuenta_corriente_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuenta_corriente
    ADD CONSTRAINT cuenta_corriente_pk PRIMARY KEY (numero_cuenta);


--
-- TOC entry 4726 (class 2606 OID 24628)
-- Name: linea_credito linea_credito_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.linea_credito
    ADD CONSTRAINT linea_credito_pk PRIMARY KEY (id_linea);


--
-- TOC entry 4731 (class 2606 OID 24630)
-- Name: movimiento_tarjeta mov_tarjeta_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimiento_tarjeta
    ADD CONSTRAINT mov_tarjeta_pk PRIMARY KEY (id_movimiento);


--
-- TOC entry 4729 (class 2606 OID 24632)
-- Name: movimiento_cuenta movimiento_cuenta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimiento_cuenta
    ADD CONSTRAINT movimiento_cuenta_pkey PRIMARY KEY (id_movimiento);


--
-- TOC entry 4733 (class 2606 OID 24634)
-- Name: tarjeta_credito tarjeta_credito_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarjeta_credito
    ADD CONSTRAINT tarjeta_credito_pk PRIMARY KEY (numero_tarjeta);


--
-- TOC entry 4727 (class 1259 OID 24635)
-- Name: fki_mov_cuenta_cuenta_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_mov_cuenta_cuenta_fk ON public.movimiento_cuenta USING btree (numero_cuenta);


--
-- TOC entry 4734 (class 2606 OID 24636)
-- Name: cliente cliiente_banco_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliiente_banco_fk FOREIGN KEY (codigo) REFERENCES public.banco(codigo) NOT VALID;


--
-- TOC entry 4735 (class 2606 OID 24641)
-- Name: cuenta_corriente cuenta_cliente_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuenta_corriente
    ADD CONSTRAINT cuenta_cliente_fk FOREIGN KEY (rut) REFERENCES public.cliente(rut);


--
-- TOC entry 4736 (class 2606 OID 24646)
-- Name: linea_credito linea_cuenta_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.linea_credito
    ADD CONSTRAINT linea_cuenta_fk FOREIGN KEY (numero_cuenta) REFERENCES public.cuenta_corriente(numero_cuenta);


--
-- TOC entry 4737 (class 2606 OID 24651)
-- Name: movimiento_cuenta mov_cuenta_cuenta_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimiento_cuenta
    ADD CONSTRAINT mov_cuenta_cuenta_fk FOREIGN KEY (numero_cuenta) REFERENCES public.cuenta_corriente(numero_cuenta) NOT VALID;


--
-- TOC entry 4738 (class 2606 OID 24656)
-- Name: movimiento_tarjeta mov_tarjeta_tarjeta_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimiento_tarjeta
    ADD CONSTRAINT mov_tarjeta_tarjeta_fk FOREIGN KEY (numero_tarjeta) REFERENCES public.tarjeta_credito(numero_tarjeta);


--
-- TOC entry 4739 (class 2606 OID 24661)
-- Name: tarjeta_credito tarjeta_cliente_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarjeta_credito
    ADD CONSTRAINT tarjeta_cliente_fk FOREIGN KEY (rut) REFERENCES public.cliente(rut);


-- Completed on 2024-10-09 14:28:35

--
-- PostgreSQL database dump complete
--

