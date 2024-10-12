--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-10-10 22:06:44

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
-- TOC entry 845 (class 1247 OID 16578)
-- Name: tipo_libro; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.tipo_libro AS text
	CONSTRAINT tipo_libro_ex_check CHECK ((VALUE = ANY (ARRAY['reportaje'::text, 'biografia'::text, 'Luis miguel'::text, 'cuento'::text, 'novela'::text, 'autoayuda'::text, 'estudio'::text])));


ALTER DOMAIN public.tipo_libro OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16580)
-- Name: autor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.autor (
    seudonimo text NOT NULL,
    nombre text NOT NULL,
    nacionalidad text
);


ALTER TABLE public.autor OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16585)
-- Name: biblioteca; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biblioteca (
    nombre text NOT NULL,
    direccion text NOT NULL,
    comuna text NOT NULL,
    telefono integer
);


ALTER TABLE public.biblioteca OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16590)
-- Name: editorial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.editorial (
    nombre text NOT NULL,
    descripcion text
);


ALTER TABLE public.editorial OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16595)
-- Name: libro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.libro (
    id integer NOT NULL,
    titulo text NOT NULL,
    tipo public.tipo_libro NOT NULL,
    anio smallint,
    autor text
);


ALTER TABLE public.libro OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16600)
-- Name: publicacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publicacion (
    isbn integer NOT NULL,
    anio smallint NOT NULL,
    id_libro integer NOT NULL,
    editorial text NOT NULL,
    formato text
);


ALTER TABLE public.publicacion OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16605)
-- Name: publicacion_biblioteca; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publicacion_biblioteca (
    isbn integer NOT NULL,
    biblioteca text NOT NULL,
    cantidad smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.publicacion_biblioteca OWNER TO postgres;

--
-- TOC entry 4872 (class 0 OID 16580)
-- Dependencies: 215
-- Data for Name: autor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.autor (seudonimo, nombre, nacionalidad) FROM stdin;
Romina	Romina Carrera	Chile
Rogelio Largo	Rogelio Largo	Argentina
Javier Naranjo	Javier Naranjo	Chile
Lion J Albert	Lion J Albert	Inglaterra
Ruperto	Ruperto Javier Rosenthal	Colombia
Fanita	Fanita	Mexico
The Moon	Javiera Brookesmith	USA
Jorge Negro	Jorge Alberto Negro	Peru
Braulio	Braulio Grey	Argentina
Señor Mayor	Tania McGregor	Ingraterra
\.


--
-- TOC entry 4873 (class 0 OID 16585)
-- Dependencies: 216
-- Data for Name: biblioteca; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.biblioteca (nombre, direccion, comuna, telefono) FROM stdin;
Biblioteca Municipal de Yumbel	pasaje verde 8954	Yumbel	2019012
Biblioteca grande	Avenida Azul 2210	Concepcion	\N
Centro de los libros	Calle 20 numero 7	Concepcion	\N
Biblioteca ambulante	Calle refrescante 12	Chillan	212166
Don Gerardo	Pasaje Gerardino 16	Osorno	10059
\.


--
-- TOC entry 4874 (class 0 OID 16590)
-- Dependencies: 217
-- Data for Name: editorial; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.editorial (nombre, descripcion) FROM stdin;
Editorial Azul	
Grandes Obras SA	
Editorial Romero	Editorial mas antigua
Normand	Entidad publica
Aguila Dorada	Editorial especializada en traduccion de obras clasicas
\.


--
-- TOC entry 4875 (class 0 OID 16595)
-- Dependencies: 218
-- Data for Name: libro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.libro (id, titulo, tipo, anio, autor) FROM stdin;
1	Libro Mayor	novela	1980	Romina
2	Secretos del pasado	novela	1983	Rogelio Largo
3	Biologia aplicada	estudio	2015	Javier Naranjo
4	Secretos destructores	autoayuda	1989	Lion J Albert
5	El imperio de la perdicion	novela	1370	Ruperto
6	Dorisia y las serpientes	novela	67	\N
7	Grandes placeres terrenales	novela	1978	Jorge Negro
8	El puente	novela	1986	Jorge Negro
9	Sonrisa de mujer	novela	1999	Romina
10	El hombre modelo	autoayuda	2015	Lion J Albert
11	Smart Astronomy	estudio	2010	The Moon
12	Santuario	autoayuda	1280	\N
13	Santuario segundo	autoayuda	1280	\N
14	Feeling	autoayuda	2019	Ruperto
15	Biblioteca de la nacion	novela	2009	Señor Mayor
\.


--
-- TOC entry 4876 (class 0 OID 16600)
-- Dependencies: 219
-- Data for Name: publicacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publicacion (isbn, anio, id_libro, editorial, formato) FROM stdin;
188872	1981	1	Editorial Azul	tapa dura
128872	1981	1	Editorial Azul	Formato economico
428872	1983	1	Grandes Obras SA	Formato economico
311252	2021	5	Grandes Obras SA	Formato economico
178551	2020	11	Grandes Obras SA	tapa dura
590332	1985	1	Normand	Formato economico
190000	1986	8	Normand	Formato economico
289110	1990	8	Grandes Obras SA	tapa dura
221741	2019	2	Editorial Azul	tapa dura
900012	2021	14	Editorial Azul	Formato economico
891100	2022	14	Editorial Azul	Formato economico
745002	2012	15	Grandes Obras SA	tapa dura
\.


--
-- TOC entry 4877 (class 0 OID 16605)
-- Dependencies: 220
-- Data for Name: publicacion_biblioteca; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publicacion_biblioteca (isbn, biblioteca, cantidad) FROM stdin;
188872	Biblioteca Municipal de Yumbel	2
188872	Biblioteca grande	5
188872	Centro de los libros	4
128872	Biblioteca Municipal de Yumbel	15
128872	Biblioteca grande	12
311252	Biblioteca ambulante	1
311252	Biblioteca Municipal de Yumbel	9
178551	Biblioteca ambulante	1
190000	Biblioteca ambulante	1
221741	Biblioteca ambulante	1
745002	Centro de los libros	6
190000	Centro de los libros	5
891100	Centro de los libros	2
891100	Don Gerardo	3
590332	Don Gerardo	5
428872	Biblioteca ambulante	1
\.


--
-- TOC entry 4713 (class 2606 OID 16612)
-- Name: autor autor_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autor
    ADD CONSTRAINT autor_pk PRIMARY KEY (seudonimo);


--
-- TOC entry 4715 (class 2606 OID 16614)
-- Name: biblioteca biblioteca_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biblioteca
    ADD CONSTRAINT biblioteca_pk PRIMARY KEY (nombre);


--
-- TOC entry 4717 (class 2606 OID 16616)
-- Name: editorial editorial_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editorial
    ADD CONSTRAINT editorial_pk PRIMARY KEY (nombre);


--
-- TOC entry 4719 (class 2606 OID 16618)
-- Name: libro libro_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libro
    ADD CONSTRAINT libro_pk PRIMARY KEY (id);


--
-- TOC entry 4723 (class 2606 OID 16620)
-- Name: publicacion_biblioteca publicacion_biblioteca_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion_biblioteca
    ADD CONSTRAINT publicacion_biblioteca_pk PRIMARY KEY (biblioteca, isbn);


--
-- TOC entry 4721 (class 2606 OID 16622)
-- Name: publicacion publicacion_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion
    ADD CONSTRAINT publicacion_pk PRIMARY KEY (isbn);


--
-- TOC entry 4724 (class 2606 OID 16623)
-- Name: libro libro_autor_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.libro
    ADD CONSTRAINT libro_autor_fk FOREIGN KEY (autor) REFERENCES public.autor(seudonimo) NOT VALID;


--
-- TOC entry 4727 (class 2606 OID 16628)
-- Name: publicacion_biblioteca publicacion_biblioteca_biblioteca_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion_biblioteca
    ADD CONSTRAINT publicacion_biblioteca_biblioteca_fk FOREIGN KEY (biblioteca) REFERENCES public.biblioteca(nombre);


--
-- TOC entry 4728 (class 2606 OID 16633)
-- Name: publicacion_biblioteca publicacion_biblioteca_publicacion_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion_biblioteca
    ADD CONSTRAINT publicacion_biblioteca_publicacion_fk FOREIGN KEY (isbn) REFERENCES public.publicacion(isbn);


--
-- TOC entry 4725 (class 2606 OID 16638)
-- Name: publicacion publicacion_editorial_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion
    ADD CONSTRAINT publicacion_editorial_fk FOREIGN KEY (editorial) REFERENCES public.editorial(nombre) NOT VALID;


--
-- TOC entry 4726 (class 2606 OID 16643)
-- Name: publicacion publicacion_libro_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion
    ADD CONSTRAINT publicacion_libro_fk FOREIGN KEY (id_libro) REFERENCES public.libro(id);


-- Completed on 2024-10-10 22:06:44

--
-- PostgreSQL database dump complete
--

