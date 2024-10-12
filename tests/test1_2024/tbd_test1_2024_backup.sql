--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-10-10 01:33:40

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
-- TOC entry 848 (class 1247 OID 16400)
-- Name: estado_venta; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.estado_venta AS character varying
	CONSTRAINT estado_venta_check CHECK (((VALUE)::text = ANY (ARRAY[('en preparacion'::character varying)::text, ('en reparto'::character varying)::text, ('entregado'::character varying)::text])));


ALTER DOMAIN public.estado_venta OWNER TO postgres;

--
-- TOC entry 852 (class 1247 OID 16403)
-- Name: tipo_pago; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.tipo_pago AS character varying
	CONSTRAINT tipo_pago_check CHECK (((VALUE)::text = ANY (ARRAY[('contado'::character varying)::text, ('credito'::character varying)::text])));


ALTER DOMAIN public.tipo_pago OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16405)
-- Name: categoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria (
    id_categoria integer NOT NULL,
    nombre_categoria character varying NOT NULL
);


ALTER TABLE public.categoria OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16419)
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    rut_cliente integer NOT NULL,
    nombre_cliente character varying NOT NULL
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16474)
-- Name: compra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compra (
    id_compra integer NOT NULL,
    fecha_compra date NOT NULL,
    rut_proveedor integer NOT NULL,
    rut_empleado integer NOT NULL,
    cantidad bigint NOT NULL,
    precio bigint NOT NULL,
    id_producto integer NOT NULL
);


ALTER TABLE public.compra OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16494)
-- Name: detalle_venta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_venta (
    id_producto integer NOT NULL,
    id_venta integer NOT NULL,
    cantidad bigint NOT NULL,
    precio bigint NOT NULL
);


ALTER TABLE public.detalle_venta OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16433)
-- Name: empleado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empleado (
    rut_empleado integer NOT NULL,
    nombre_empleado character varying NOT NULL,
    id_tienda integer NOT NULL
);


ALTER TABLE public.empleado OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16462)
-- Name: producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto (
    id_producto integer NOT NULL,
    nombre_producto character varying NOT NULL,
    id_categoria integer NOT NULL,
    stock bigint NOT NULL
);


ALTER TABLE public.producto OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16412)
-- Name: proveedor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proveedor (
    rut_proveedor integer NOT NULL,
    nombre_proveedor character varying NOT NULL
);


ALTER TABLE public.proveedor OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16426)
-- Name: tienda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tienda (
    id_tienda integer NOT NULL,
    nombre_tienda character varying NOT NULL
);


ALTER TABLE public.tienda OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16445)
-- Name: venta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venta (
    id_venta integer NOT NULL,
    fecha_venta date NOT NULL,
    monto_venta integer NOT NULL,
    rut_empleado integer NOT NULL,
    estado_venta public.estado_venta NOT NULL,
    tipo_pago public.tipo_pago NOT NULL,
    rut_cliente integer NOT NULL
);


ALTER TABLE public.venta OWNER TO postgres;

--
-- TOC entry 4897 (class 0 OID 16405)
-- Dependencies: 215
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria (id_categoria, nombre_categoria) FROM stdin;
\.


--
-- TOC entry 4899 (class 0 OID 16419)
-- Dependencies: 217
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente (rut_cliente, nombre_cliente) FROM stdin;
\.


--
-- TOC entry 4904 (class 0 OID 16474)
-- Dependencies: 222
-- Data for Name: compra; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compra (id_compra, fecha_compra, rut_proveedor, rut_empleado, cantidad, precio, id_producto) FROM stdin;
\.


--
-- TOC entry 4905 (class 0 OID 16494)
-- Dependencies: 223
-- Data for Name: detalle_venta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detalle_venta (id_producto, id_venta, cantidad, precio) FROM stdin;
\.


--
-- TOC entry 4901 (class 0 OID 16433)
-- Dependencies: 219
-- Data for Name: empleado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empleado (rut_empleado, nombre_empleado, id_tienda) FROM stdin;
\.


--
-- TOC entry 4903 (class 0 OID 16462)
-- Dependencies: 221
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto (id_producto, nombre_producto, id_categoria, stock) FROM stdin;
\.


--
-- TOC entry 4898 (class 0 OID 16412)
-- Dependencies: 216
-- Data for Name: proveedor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proveedor (rut_proveedor, nombre_proveedor) FROM stdin;
\.


--
-- TOC entry 4900 (class 0 OID 16426)
-- Dependencies: 218
-- Data for Name: tienda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tienda (id_tienda, nombre_tienda) FROM stdin;
\.


--
-- TOC entry 4902 (class 0 OID 16445)
-- Dependencies: 220
-- Data for Name: venta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.venta (id_venta, fecha_venta, monto_venta, rut_empleado, estado_venta, tipo_pago, rut_cliente) FROM stdin;
\.


--
-- TOC entry 4728 (class 2606 OID 16411)
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id_categoria);


--
-- TOC entry 4732 (class 2606 OID 16425)
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (rut_cliente);


--
-- TOC entry 4742 (class 2606 OID 16478)
-- Name: compra compra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_pkey PRIMARY KEY (id_compra);


--
-- TOC entry 4744 (class 2606 OID 16498)
-- Name: detalle_venta detalle_venta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_venta
    ADD CONSTRAINT detalle_venta_pkey PRIMARY KEY (id_producto, id_venta);


--
-- TOC entry 4736 (class 2606 OID 16439)
-- Name: empleado empleado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (rut_empleado);


--
-- TOC entry 4740 (class 2606 OID 16468)
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id_producto);


--
-- TOC entry 4730 (class 2606 OID 16418)
-- Name: proveedor proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (rut_proveedor);


--
-- TOC entry 4734 (class 2606 OID 16432)
-- Name: tienda tienda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tienda
    ADD CONSTRAINT tienda_pkey PRIMARY KEY (id_tienda);


--
-- TOC entry 4738 (class 2606 OID 16451)
-- Name: venta venta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_pkey PRIMARY KEY (id_venta);


--
-- TOC entry 4748 (class 2606 OID 16469)
-- Name: producto id_categoria_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT id_categoria_fk FOREIGN KEY (id_categoria) REFERENCES public.categoria(id_categoria);


--
-- TOC entry 4749 (class 2606 OID 16479)
-- Name: compra id_producto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT id_producto_fk FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);


--
-- TOC entry 4752 (class 2606 OID 16499)
-- Name: detalle_venta id_producto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_venta
    ADD CONSTRAINT id_producto_fk FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);


--
-- TOC entry 4745 (class 2606 OID 16440)
-- Name: empleado id_tienda_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT id_tienda_fk FOREIGN KEY (id_tienda) REFERENCES public.tienda(id_tienda);


--
-- TOC entry 4753 (class 2606 OID 16504)
-- Name: detalle_venta id_venta_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_venta
    ADD CONSTRAINT id_venta_fk FOREIGN KEY (id_venta) REFERENCES public.venta(id_venta);


--
-- TOC entry 4746 (class 2606 OID 16452)
-- Name: venta rut_cliente_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT rut_cliente_fk FOREIGN KEY (rut_cliente) REFERENCES public.cliente(rut_cliente);


--
-- TOC entry 4747 (class 2606 OID 16457)
-- Name: venta rut_empleado_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT rut_empleado_fk FOREIGN KEY (rut_empleado) REFERENCES public.empleado(rut_empleado);


--
-- TOC entry 4750 (class 2606 OID 16484)
-- Name: compra rut_empleado_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT rut_empleado_fk FOREIGN KEY (rut_empleado) REFERENCES public.empleado(rut_empleado);


--
-- TOC entry 4751 (class 2606 OID 16489)
-- Name: compra rut_proveedor_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT rut_proveedor_fk FOREIGN KEY (rut_proveedor) REFERENCES public.proveedor(rut_proveedor);


-- Completed on 2024-10-10 01:33:41

--
-- PostgreSQL database dump complete
--

