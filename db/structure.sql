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
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: daycare_visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.daycare_visits (
    id bigint NOT NULL,
    visit timestamp(6) without time zone,
    organisation_id bigint NOT NULL,
    pet_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: daycare_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.daycare_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: daycare_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.daycare_visits_id_seq OWNED BY public.daycare_visits.id;


--
-- Name: grooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grooms (
    id bigint NOT NULL,
    visit timestamp(6) without time zone,
    organisation_id bigint NOT NULL,
    pet_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: grooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.grooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.grooms_id_seq OWNED BY public.grooms.id;


--
-- Name: organisations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organisations (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: organisations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organisations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organisations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organisations_id_seq OWNED BY public.organisations.id;


--
-- Name: pets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pets (
    id bigint NOT NULL,
    name character varying,
    age integer,
    breed character varying,
    visits_remaining integer,
    grooms_remaining integer,
    users_id bigint NOT NULL,
    organisation_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: pets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pets_id_seq OWNED BY public.pets.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password_digest character varying NOT NULL,
    organisation_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: daycare_visits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daycare_visits ALTER COLUMN id SET DEFAULT nextval('public.daycare_visits_id_seq'::regclass);


--
-- Name: grooms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grooms ALTER COLUMN id SET DEFAULT nextval('public.grooms_id_seq'::regclass);


--
-- Name: organisations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisations ALTER COLUMN id SET DEFAULT nextval('public.organisations_id_seq'::regclass);


--
-- Name: pets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pets ALTER COLUMN id SET DEFAULT nextval('public.pets_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: daycare_visits daycare_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daycare_visits
    ADD CONSTRAINT daycare_visits_pkey PRIMARY KEY (id);


--
-- Name: grooms grooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grooms
    ADD CONSTRAINT grooms_pkey PRIMARY KEY (id);


--
-- Name: organisations organisations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisations
    ADD CONSTRAINT organisations_pkey PRIMARY KEY (id);


--
-- Name: pets pets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_daycare_visits_on_organisation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_daycare_visits_on_organisation_id ON public.daycare_visits USING btree (organisation_id);


--
-- Name: index_daycare_visits_on_pet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_daycare_visits_on_pet_id ON public.daycare_visits USING btree (pet_id);


--
-- Name: index_grooms_on_organisation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grooms_on_organisation_id ON public.grooms USING btree (organisation_id);


--
-- Name: index_grooms_on_pet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grooms_on_pet_id ON public.grooms USING btree (pet_id);


--
-- Name: index_pets_on_organisation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pets_on_organisation_id ON public.pets USING btree (organisation_id);


--
-- Name: index_pets_on_users_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pets_on_users_id ON public.pets USING btree (users_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_organisation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_organisation_id ON public.users USING btree (organisation_id);


--
-- Name: daycare_visits fk_rails_132c7d43ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daycare_visits
    ADD CONSTRAINT fk_rails_132c7d43ca FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- Name: pets fk_rails_5e502b2584; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT fk_rails_5e502b2584 FOREIGN KEY (users_id) REFERENCES public.users(id);


--
-- Name: daycare_visits fk_rails_7589875ec8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daycare_visits
    ADD CONSTRAINT fk_rails_7589875ec8 FOREIGN KEY (pet_id) REFERENCES public.pets(id);


--
-- Name: pets fk_rails_7c53bdee02; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT fk_rails_7c53bdee02 FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- Name: grooms fk_rails_8f95164373; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grooms
    ADD CONSTRAINT fk_rails_8f95164373 FOREIGN KEY (pet_id) REFERENCES public.pets(id);


--
-- Name: users fk_rails_9a64b73984; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_9a64b73984 FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- Name: grooms fk_rails_e1b884cc88; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grooms
    ADD CONSTRAINT fk_rails_e1b884cc88 FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20240327123129'),
('20240327123312'),
('20240403115052'),
('20240403120526'),
('20240403121514');


