--
-- PostgreSQL database dump
--

\restrict wMNEAkDKFN5XuHUglz5UCUIYWw9hUFM0Oe2ViWh18QCUKwT3ge5yKeVaOye5elt

-- Dumped from database version 15.17 (Debian 15.17-1.pgdg12+1)
-- Dumped by pg_dump version 15.17 (Debian 15.17-1.pgdg12+1)

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
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.courses_id_seq
    START WITH 21
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.courses (
    id integer DEFAULT nextval('public.courses_id_seq'::regclass) NOT NULL,
    title character varying NOT NULL,
    description text,
    thumbnail_url character varying,
    price integer,
    level character varying,
    instructor_id character varying,
    created_at timestamp without time zone,
    video_url character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer DEFAULT nextval('public.users_id_seq'::regclass) NOT NULL,
    email character varying NOT NULL,
    hashed_password character varying NOT NULL,
    name character varying NOT NULL,
    role character varying,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.courses (id, title, description, thumbnail_url, price, level, instructor_id, created_at, video_url) FROM stdin;
11	[건설안전기술사] 4-3. 지반 개량 공법의 종류	건설안전 기술사 시험 대비 지반 개량 공법의 종류와 특징을 다루는 실무 강의입니다.	https://i.ytimg.com/vi/f3_XBCz8v-A/hqdefault.jpg	0	Expert	P6IX-SC	2026-03-09 07:34:12.255625	f3_XBCz8v-A
12	[건설안전기술사] 4-2. 다짐과 압밀	토질 역학의 기초가 되는 지반 다짐과 압밀의 원리를 상세하게 설명합니다.	https://i.ytimg.com/vi/yEzfFl-ta3w/hqdefault.jpg	0	Expert	P6IX-SC	2026-03-09 07:34:12.255625	yEzfFl-ta3w
13	[건설안전기술사] 4-1. 최적 함수비(O.M.C)	최적 함수비(O.M.C) 개념과 시험 방법, 실무 적용 사례를 학습합니다.	https://i.ytimg.com/vi/MIQFF5qbBVA/hqdefault.jpg	0	Expert	P6IX-SC	2026-03-09 07:34:12.255625	MIQFF5qbBVA
14	3강 통합본 건설안전 핵심 이론	3강을 한 번에 학습할 수 있는 통합본 영상입니다.	https://i.ytimg.com/vi/Geoc46v2sEo/hqdefault.jpg	0	Expert	P6IX-SC	2026-03-09 07:34:12.255625	Geoc46v2sEo
15	[건설안전기술사] 3-29. 타워크레인 지지방법	지지 방법과 안전 준수 사항을 다룹니다.	https://i.ytimg.com/vi/1Paj8k0uP7o/hqdefault.jpg	0	Intermediate	P6IX-SC	2026-03-09 07:34:12.255625	1Paj8k0uP7o
16	[건설안전기술사] 3-28. 타워크레인 재해유형	재해 유형과 예방 대책을 학습합니다.	https://i.ytimg.com/vi/5aP4TQIk0TY/hqdefault.jpg	0	Intermediate	P6IX-SC	2026-03-09 07:34:12.255625	5aP4TQIk0TY
17	[건설안전기술사] 3-26. 곤돌라의 안전장치	주요 안전 기구와 점검 요령을 설명합니다.	https://i.ytimg.com/vi/9MJkCH0DWkg/hqdefault.jpg	0	Intermediate	P6IX-SC	2026-03-09 07:34:12.255625	9MJkCH0DWkg
18	[건설안전기술사] 3-25. 리프트 조립/해체	위험성 평가 방법과 안전 수칙을 배웁니다.	https://i.ytimg.com/vi/G2h1pIHU3PI/hqdefault.jpg	0	Beginner	P6IX-SC	2026-03-09 07:34:12.255625	G2h1pIHU3PI
19	[건설안전기술사] 3-23. 리프트 주의사항	계획 수립과 안전 조치 사항을 정리합니다.	https://i.ytimg.com/vi/ajlp8muWwf4/hqdefault.jpg	0	Beginner	P6IX-SC	2026-03-09 07:34:12.255625	ajlp8muWwf4
20	[건설안전기술사] 3-21. 양중기 안전대책	양중기 안전 관리 체계와 작업 수칙을 다룹니다.	https://i.ytimg.com/vi/bSoFGw4Hlj4/hqdefault.jpg	0	Beginner	P6IX-SC	2026-03-09 07:34:12.255625	bSoFGw4Hlj4
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, hashed_password, name, role, is_active, created_at, updated_at) FROM stdin;
1	w@w.w	$pbkdf2-sha256$29000$p3Suda7V2htjDCHkfC9lTA$4y0Sr2AXyl7ScB67qoOWqp5.O3WiLkX/Gj4NJ4rKxRU	명가	student	t	2026-03-09 06:48:51.66407	2026-03-09 06:48:51.66407
\.


--
-- Name: courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.courses_id_seq', 20, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict wMNEAkDKFN5XuHUglz5UCUIYWw9hUFM0Oe2ViWh18QCUKwT3ge5yKeVaOye5elt

