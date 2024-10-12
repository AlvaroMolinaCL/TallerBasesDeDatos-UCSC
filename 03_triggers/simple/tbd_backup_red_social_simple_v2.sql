--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

-- Started on 2024-10-09 15:50:48

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

--
-- TOC entry 844 (class 1247 OID 24668)
-- Name: estado; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.estado AS text
	CONSTRAINT estado_check CHECK ((VALUE = ANY (ARRAY['aceptado'::text, 'rechazado'::text, 'pendiente'::text, 'terminado'::text])));


ALTER DOMAIN public.estado OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 24670)
-- Name: amista; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.amista (
    solicitante integer NOT NULL,
    solicitado integer NOT NULL,
    fecha_envio timestamp without time zone NOT NULL,
    fecha_respuesta timestamp without time zone,
    estado public.estado NOT NULL
);


ALTER TABLE public.amista OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 24675)
-- Name: bloquea; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bloquea (
    bloquea integer NOT NULL,
    bloqueador integer NOT NULL,
    fecha timestamp without time zone NOT NULL,
    razon character varying(200)
);


ALTER TABLE public.bloquea OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24678)
-- Name: perfil; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.perfil (
    codigo integer NOT NULL,
    descripcion_portada character varying(200),
    nombre character varying(100) NOT NULL,
    alias character varying(100) NOT NULL,
    fecha_registro timestamp without time zone NOT NULL,
    ultimo_ingreso timestamp without time zone NOT NULL
);


ALTER TABLE public.perfil OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24681)
-- Name: publicacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publicacion (
    codigo integer NOT NULL,
    autor integer NOT NULL,
    fecha timestamp without time zone NOT NULL,
    cuerpo text
);


ALTER TABLE public.publicacion OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24686)
-- Name: respuesta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.respuesta (
    codigo integer NOT NULL,
    autor integer NOT NULL,
    publicacion integer NOT NULL,
    fecha timestamp without time zone NOT NULL,
    cuerpo text
);


ALTER TABLE public.respuesta OWNER TO postgres;

--
-- TOC entry 4867 (class 0 OID 24670)
-- Dependencies: 215
-- Data for Name: amista; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.amista (solicitante, solicitado, fecha_envio, fecha_respuesta, estado) FROM stdin;
1	2	2023-05-04 23:02:16.645	2023-05-04 23:02:18.98	aceptado
1	9	2023-05-04 23:02:23.708	2023-05-04 23:02:25.958	aceptado
3	10	2022-05-04 23:03:36.547	2023-05-04 23:05:39.968	aceptado
3	1	2023-05-04 23:03:33.436	\N	pendiente
3	2	2023-05-04 23:03:36.547	\N	pendiente
3	4	2023-05-04 23:03:36.547	\N	pendiente
3	5	2023-05-04 23:03:36.547	\N	pendiente
3	6	2023-05-04 23:03:36.547	\N	pendiente
3	11	2023-05-04 23:03:36.547	\N	rechazado
3	9	2023-05-04 23:03:36.547	\N	rechazado
3	12	2023-02-04 23:03:36.547	\N	rechazado
6	9	2022-12-29 12:50:00	2023-01-02 23:13:25.288	aceptado
9	7	2023-05-04 23:12:55.794	2023-05-04 23:13:23.661	aceptado
12	10	2023-03-14 23:13:00.865	2023-05-04 23:13:19.647	aceptado
5	11	2023-10-22 00:00:00	\N	pendiente
1	9	2022-05-04 23:02:23.708	2022-05-04 23:02:25.958	terminado
5	6	2022-10-12 00:00:00	2022-12-12 23:10:18.076	aceptado
\.


--
-- TOC entry 4868 (class 0 OID 24675)
-- Dependencies: 216
-- Data for Name: bloquea; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bloquea (bloquea, bloqueador, fecha, razon) FROM stdin;
12	3	2023-05-04 23:14:14.317	Me cae pésimo
1	6	2023-05-04 23:14:47.285	\N
7	2	2023-05-04 23:14:49.281	porque si
\.


--
-- TOC entry 4869 (class 0 OID 24678)
-- Dependencies: 217
-- Data for Name: perfil; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.perfil (codigo, descripcion_portada, nombre, alias, fecha_registro, ultimo_ingreso) FROM stdin;
2	Un hermoso dia soleado	Roberto	Roberto	2022-12-24 00:00:00	2023-01-01 00:00:00
6	\N	Luna Himemori	Luna	2021-05-04 22:56:10.799	2023-05-04 22:56:12.939
10	\N	Alemendra	Sandia	2022-12-01 23:00:04.384	2023-05-04 23:00:19.846
12	NOOOOOO!!	Daniel C.	El Daniel	2022-12-11 23:05:02.464	2023-05-04 23:05:04.688
1		Juanito Tapia	El Gran Juan	2022-05-04 22:53:49.323	2023-05-04 22:53:49.323
3	xDDD	Fanita	La fanta	2022-05-04 22:56:19.212	2023-05-04 22:56:17.094
5	\N	Mark Hoppus	El Mark	2021-03-04 22:55:43.814	2023-05-04 22:56:08.404
7	\N	Paul Azul	El Pol	2022-04-04 22:58:38.424	2023-05-04 22:58:42.456
8	\N	Anacleto	Dinosaurio	2021-05-12 22:58:40.446	2023-05-04 22:58:44.102
9	La vida sin arte no es vida :3	Daniela Alberta Romana	Danielita	2021-11-04 22:58:40.446	2023-05-04 22:58:44.102
11	\N	Duque Godofredo	El Duque	2021-02-24 23:01:07.287	2023-05-04 23:01:08.935
4	Caminando en el barro	Camila Roble	Camila	2021-01-01 22:56:21.143	2023-05-04 22:56:15.191
\.


--
-- TOC entry 4870 (class 0 OID 24681)
-- Dependencies: 218
-- Data for Name: publicacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publicacion (codigo, autor, fecha, cuerpo) FROM stdin;
1	1	2022-08-24 23:16:26.579	El sol esta muy hermoso estos dias
2	1	2023-05-04 23:20:26.2	Hoy descubri que puedo pintar con los lapices de color rojo como si fueran de color verde. Es facil, solamente hay que mezclarlos con un poco de tinta azul china, y algo de amarillo. pero primero tienen que tener mucho cuidado de que algo les salga mal en la mezcla porque es complicado
3	4	2022-12-11 23:22:26.509	Soy de los primeros usuarios de esta cosa
4	12	2023-05-04 23:24:00.732	Tengo tan mala suerte con este juego de ******
5	9	2022-07-27 23:25:56.517	Hoy me ha ido muy bien de camino al trabajo, espero que se repita todos los dias =^^=
6	5	2023-02-02 23:29:07.999	Turn it up, I never wanna go home I only wanna be part of your breakdown
7	7	2023-03-18 23:30:28.559	\N
8	10	2023-05-04 23:31:46.454	Intente cantar en el escenario, pero mi voz no salio. Fue un mal dia
9	4	2021-01-01 23:56:21.143	El primer mensaje a todo el mundo!!!
\.


--
-- TOC entry 4871 (class 0 OID 24686)
-- Dependencies: 219
-- Data for Name: respuesta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.respuesta (codigo, autor, publicacion, fecha, cuerpo) FROM stdin;
1	1	1	2022-08-25 22:17:04.456	Espero que siempre se mantenga así
2	3	1	2022-09-01 23:17:37.952	El sol se va a extinguir!!!!
3	9	1	2022-09-14 23:18:05.345	Sin duda estimado amigo
4	4	3	2023-05-04 23:23:27.293	Deberian respetarme todos, especialmente esos recien llegados altaneros
5	9	4	2023-05-04 23:25:05.219	No te desanimes >: D A mi tampoco me salió nada util al principio :(
6	1	7	2023-05-04 23:30:58.005	\N
7	3	7	2023-05-04 23:31:18.155	\N
8	2	8	2023-05-04 23:32:44.565	Animo
9	12	8	2023-05-04 23:32:46.705	Animo, tu puedes!
10	8	9	2021-01-02 11:06:21.143	Hiciste historia!
\.


--
-- TOC entry 4708 (class 2606 OID 24692)
-- Name: amista pk_amista; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amista
    ADD CONSTRAINT pk_amista PRIMARY KEY (solicitante, solicitado, fecha_envio);


--
-- TOC entry 4710 (class 2606 OID 24694)
-- Name: bloquea pk_bloquea; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bloquea
    ADD CONSTRAINT pk_bloquea PRIMARY KEY (bloquea, bloqueador);


--
-- TOC entry 4712 (class 2606 OID 24696)
-- Name: perfil pk_perfil; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil
    ADD CONSTRAINT pk_perfil PRIMARY KEY (codigo);


--
-- TOC entry 4714 (class 2606 OID 24698)
-- Name: publicacion pk_publicacion; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion
    ADD CONSTRAINT pk_publicacion PRIMARY KEY (codigo);


--
-- TOC entry 4716 (class 2606 OID 24700)
-- Name: respuesta pk_respuesta; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuesta
    ADD CONSTRAINT pk_respuesta PRIMARY KEY (codigo);


--
-- TOC entry 4717 (class 2606 OID 24701)
-- Name: amista fk_amista_perfil_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amista
    ADD CONSTRAINT fk_amista_perfil_1 FOREIGN KEY (solicitante) REFERENCES public.perfil(codigo);


--
-- TOC entry 4718 (class 2606 OID 24706)
-- Name: amista fk_amista_perfil_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amista
    ADD CONSTRAINT fk_amista_perfil_2 FOREIGN KEY (solicitado) REFERENCES public.perfil(codigo);


--
-- TOC entry 4719 (class 2606 OID 24711)
-- Name: bloquea fk_bloquea_perfil_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bloquea
    ADD CONSTRAINT fk_bloquea_perfil_1 FOREIGN KEY (bloquea) REFERENCES public.perfil(codigo);


--
-- TOC entry 4720 (class 2606 OID 24716)
-- Name: bloquea fk_bloquea_perfil_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bloquea
    ADD CONSTRAINT fk_bloquea_perfil_2 FOREIGN KEY (bloqueador) REFERENCES public.perfil(codigo);


--
-- TOC entry 4721 (class 2606 OID 24721)
-- Name: publicacion fk_publicacion_perfil; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion
    ADD CONSTRAINT fk_publicacion_perfil FOREIGN KEY (autor) REFERENCES public.perfil(codigo);


--
-- TOC entry 4722 (class 2606 OID 24726)
-- Name: respuesta fk_respuesta_perfil; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuesta
    ADD CONSTRAINT fk_respuesta_perfil FOREIGN KEY (autor) REFERENCES public.perfil(codigo);


--
-- TOC entry 4723 (class 2606 OID 24731)
-- Name: respuesta fk_respuesta_publicacion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuesta
    ADD CONSTRAINT fk_respuesta_publicacion FOREIGN KEY (publicacion) REFERENCES public.publicacion(codigo);


-- Completed on 2024-10-09 15:50:48

--
-- PostgreSQL database dump complete
--

