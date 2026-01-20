\restrict 4xZc49MGFwpPR5EArAVAkT2OFVtvN1lsY5ERRNJ1ZnW7JP2eeheoui9VFrBM1dD

-- Dumped from database version 15.15 (Homebrew)
-- Dumped by pg_dump version 15.15 (Homebrew)

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
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


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
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying,
    description text,
    organisation_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: daycare_visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.daycare_visits (
    id bigint NOT NULL,
    date date NOT NULL,
    start_time time without time zone NOT NULL,
    duration integer NOT NULL,
    notes text,
    pet_id bigint NOT NULL,
    organisation_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status integer DEFAULT 0,
    employee_id bigint
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
    date date NOT NULL,
    start_time time without time zone NOT NULL,
    last_groom date,
    notes text,
    pet_id bigint NOT NULL,
    organisation_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status integer DEFAULT 0,
    employee_id bigint,
    deposit double precision,
    deposit_method integer,
    end_time time without time zone
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
-- Name: images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.images (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    pet_id bigint,
    onboarding_pet_id bigint,
    product_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id bigint,
    category_id bigint,
    groom_id bigint,
    temporary_groom_id bigint
);


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.images_id_seq OWNED BY public.images.id;


--
-- Name: log_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.log_reports (
    id bigint NOT NULL,
    groom_id bigint,
    temporary_groom_id bigint,
    daycare_visit_id bigint,
    temporary_daycare_visit_id bigint,
    org_notes text DEFAULT ''::text NOT NULL,
    customer_notes text DEFAULT ''::text NOT NULL,
    price double precision DEFAULT 0.0 NOT NULL,
    payment_method integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    duration numeric(5,2) DEFAULT 0.0,
    reward_points integer DEFAULT 0
);


--
-- Name: log_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.log_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.log_reports_id_seq OWNED BY public.log_reports.id;


--
-- Name: onboarding_organisations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.onboarding_organisations (
    id bigint NOT NULL,
    name character varying,
    email character varying,
    phone character varying,
    address character varying,
    city character varying,
    postcode character varying,
    user_name character varying,
    user_password character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: onboarding_organisations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.onboarding_organisations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: onboarding_organisations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.onboarding_organisations_id_seq OWNED BY public.onboarding_organisations.id;


--
-- Name: onboarding_pets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.onboarding_pets (
    id bigint NOT NULL,
    name character varying(100),
    dob date,
    breed character varying,
    species integer,
    gender integer,
    weight integer,
    health_conditions character varying,
    user_id bigint NOT NULL,
    organisation_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: onboarding_pets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.onboarding_pets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: onboarding_pets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.onboarding_pets_id_seq OWNED BY public.onboarding_pets.id;


--
-- Name: onboarding_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.onboarding_users (
    id bigint NOT NULL,
    email character varying,
    password character varying,
    first_name character varying,
    last_name character varying,
    phone character varying,
    address character varying,
    city character varying,
    postcode character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    access_code character varying
);


--
-- Name: onboarding_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.onboarding_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: onboarding_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.onboarding_users_id_seq OWNED BY public.onboarding_users.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    organisation_id bigint NOT NULL,
    status integer DEFAULT 0,
    payment_intent_id character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: organisations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organisations (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    email character varying,
    phone character varying,
    address text,
    city text,
    postcode text,
    maximum_weekly_grooms integer DEFAULT 0,
    maximum_daily_grooms integer DEFAULT 0,
    maximum_weekly_daycare_visits integer DEFAULT 0,
    maximum_daily_daycare_visits integer DEFAULT 0,
    revenue_target integer DEFAULT 0,
    stripe_api_key text,
    grooming_reward_points integer DEFAULT 0,
    daycare_visit_reward_points integer DEFAULT 0,
    country text,
    access_code character varying NOT NULL,
    default_groom_cost double precision,
    default_daycare_visit_cost double precision,
    opening_hours text
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
    name character varying(100) NOT NULL,
    dob date NOT NULL,
    breed character varying NOT NULL,
    visits_remaining integer DEFAULT 0,
    grooms_remaining integer DEFAULT 0,
    species integer DEFAULT 0 NOT NULL,
    gender integer DEFAULT 0 NOT NULL,
    weight integer DEFAULT 0 NOT NULL,
    health_conditions character varying NOT NULL,
    user_id bigint NOT NULL,
    organisation_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    notes text,
    date_of_death date,
    status integer DEFAULT 0,
    allergies text,
    medication text,
    rabies_expiration date,
    bordetella_expiration date,
    dhpp_expiration date,
    heartworm_expiration date,
    kennel_cough_expiration date,
    colour_codes character varying[] DEFAULT '{}'::character varying[]
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
-- Name: product_category_joins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_category_joins (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    category_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: product_category_joins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_category_joins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_category_joins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_category_joins_id_seq OWNED BY public.product_category_joins.id;


--
-- Name: product_order_joins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_order_joins (
    product_id bigint NOT NULL,
    order_id bigint NOT NULL
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    name character varying,
    brand character varying,
    description text,
    price numeric,
    stock integer,
    features character varying[] DEFAULT '{}'::character varying[],
    item_number character varying,
    dimensions character varying,
    weight character varying,
    life_stage character varying,
    breed_size character varying,
    material character varying,
    organisation_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reviews (
    id bigint NOT NULL,
    rating integer,
    comment text,
    product_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: temporary_daycare_visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.temporary_daycare_visits (
    id bigint NOT NULL,
    pet_name text NOT NULL,
    owner_name text NOT NULL,
    date date NOT NULL,
    start_time time without time zone NOT NULL,
    duration integer NOT NULL,
    pet_notes text,
    owner_notes text,
    employee_id bigint,
    status integer DEFAULT 0,
    organisation_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: temporary_daycare_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.temporary_daycare_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temporary_daycare_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.temporary_daycare_visits_id_seq OWNED BY public.temporary_daycare_visits.id;


--
-- Name: temporary_grooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.temporary_grooms (
    id bigint NOT NULL,
    pet_name text NOT NULL,
    owner_name text NOT NULL,
    date date NOT NULL,
    start_time time without time zone NOT NULL,
    last_groom date,
    pet_notes text,
    owner_notes text,
    employee_id bigint,
    status integer DEFAULT 0,
    organisation_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    end_time time without time zone
);


--
-- Name: temporary_grooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.temporary_grooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temporary_grooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.temporary_grooms_id_seq OWNED BY public.temporary_grooms.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password_digest character varying NOT NULL,
    organisation_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    active boolean DEFAULT true,
    phone text,
    weight integer,
    address text,
    city text,
    postcode text,
    role integer DEFAULT 0,
    max_daycare_visits integer DEFAULT 10,
    notes text,
    colour character varying,
    rewards_points integer DEFAULT 0,
    additional_user_first_name text,
    additional_user_last_name text,
    additional_user_email text,
    additional_user_phone text,
    additional_user_relationship text,
    colour_codes character varying[] DEFAULT '{}'::character varying[]
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
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: daycare_visits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daycare_visits ALTER COLUMN id SET DEFAULT nextval('public.daycare_visits_id_seq'::regclass);


--
-- Name: grooms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grooms ALTER COLUMN id SET DEFAULT nextval('public.grooms_id_seq'::regclass);


--
-- Name: images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);


--
-- Name: log_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_reports ALTER COLUMN id SET DEFAULT nextval('public.log_reports_id_seq'::regclass);


--
-- Name: onboarding_organisations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onboarding_organisations ALTER COLUMN id SET DEFAULT nextval('public.onboarding_organisations_id_seq'::regclass);


--
-- Name: onboarding_pets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onboarding_pets ALTER COLUMN id SET DEFAULT nextval('public.onboarding_pets_id_seq'::regclass);


--
-- Name: onboarding_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onboarding_users ALTER COLUMN id SET DEFAULT nextval('public.onboarding_users_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: organisations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisations ALTER COLUMN id SET DEFAULT nextval('public.organisations_id_seq'::regclass);


--
-- Name: pets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pets ALTER COLUMN id SET DEFAULT nextval('public.pets_id_seq'::regclass);


--
-- Name: product_category_joins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_category_joins ALTER COLUMN id SET DEFAULT nextval('public.product_category_joins_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: temporary_daycare_visits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporary_daycare_visits ALTER COLUMN id SET DEFAULT nextval('public.temporary_daycare_visits_id_seq'::regclass);


--
-- Name: temporary_grooms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporary_grooms ALTER COLUMN id SET DEFAULT nextval('public.temporary_grooms_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


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
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: log_reports log_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_reports
    ADD CONSTRAINT log_reports_pkey PRIMARY KEY (id);


--
-- Name: onboarding_organisations onboarding_organisations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onboarding_organisations
    ADD CONSTRAINT onboarding_organisations_pkey PRIMARY KEY (id);


--
-- Name: onboarding_pets onboarding_pets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onboarding_pets
    ADD CONSTRAINT onboarding_pets_pkey PRIMARY KEY (id);


--
-- Name: onboarding_users onboarding_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onboarding_users
    ADD CONSTRAINT onboarding_users_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


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
-- Name: product_category_joins product_category_joins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_category_joins
    ADD CONSTRAINT product_category_joins_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: temporary_daycare_visits temporary_daycare_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporary_daycare_visits
    ADD CONSTRAINT temporary_daycare_visits_pkey PRIMARY KEY (id);


--
-- Name: temporary_grooms temporary_grooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporary_grooms
    ADD CONSTRAINT temporary_grooms_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_categories_on_organisation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_organisation_id ON public.categories USING btree (organisation_id);


--
-- Name: index_daycare_visits_on_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_daycare_visits_on_employee_id ON public.daycare_visits USING btree (employee_id);


--
-- Name: index_daycare_visits_on_org_status_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_daycare_visits_on_org_status_date ON public.daycare_visits USING btree (organisation_id, status, date);


--
-- Name: index_daycare_visits_on_organisation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_daycare_visits_on_organisation_id ON public.daycare_visits USING btree (organisation_id);


--
-- Name: index_daycare_visits_on_organisation_id_and_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_daycare_visits_on_organisation_id_and_date ON public.daycare_visits USING btree (organisation_id, date);


--
-- Name: index_daycare_visits_on_pet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_daycare_visits_on_pet_id ON public.daycare_visits USING btree (pet_id);


--
-- Name: index_grooms_on_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grooms_on_employee_id ON public.grooms USING btree (employee_id);


--
-- Name: index_grooms_on_org_status_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grooms_on_org_status_date ON public.grooms USING btree (organisation_id, status, date);


--
-- Name: index_grooms_on_organisation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grooms_on_organisation_id ON public.grooms USING btree (organisation_id);


--
-- Name: index_grooms_on_organisation_id_and_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grooms_on_organisation_id_and_date ON public.grooms USING btree (organisation_id, date);


--
-- Name: index_grooms_on_pet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grooms_on_pet_id ON public.grooms USING btree (pet_id);


--
-- Name: index_images_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_images_on_category_id ON public.images USING btree (category_id);


--
-- Name: index_images_on_groom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_images_on_groom_id ON public.images USING btree (groom_id);


--
-- Name: index_images_on_onboarding_pet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_images_on_onboarding_pet_id ON public.images USING btree (onboarding_pet_id);


--
-- Name: index_images_on_pet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_images_on_pet_id ON public.images USING btree (pet_id);


--
-- Name: index_images_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_images_on_product_id ON public.images USING btree (product_id);


--
-- Name: index_images_on_temporary_groom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_images_on_temporary_groom_id ON public.images USING btree (temporary_groom_id);


--
-- Name: index_images_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_images_on_user_id ON public.images USING btree (user_id);


--
-- Name: index_log_reports_on_daycare_visit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_log_reports_on_daycare_visit_id ON public.log_reports USING btree (daycare_visit_id);


--
-- Name: index_log_reports_on_groom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_log_reports_on_groom_id ON public.log_reports USING btree (groom_id);


--
-- Name: index_log_reports_on_temporary_daycare_visit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_log_reports_on_temporary_daycare_visit_id ON public.log_reports USING btree (temporary_daycare_visit_id);


--
-- Name: index_log_reports_on_temporary_groom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_log_reports_on_temporary_groom_id ON public.log_reports USING btree (temporary_groom_id);


--
-- Name: index_onboarding_pets_on_organisation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_onboarding_pets_on_organisation_id ON public.onboarding_pets USING btree (organisation_id);


--
-- Name: index_onboarding_pets_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_onboarding_pets_on_user_id ON public.onboarding_pets USING btree (user_id);


--
-- Name: index_orders_on_organisation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_organisation_id ON public.orders USING btree (organisation_id);


--
-- Name: index_orders_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_user_id ON public.orders USING btree (user_id);


--
-- Name: index_pets_on_organisation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pets_on_organisation_id ON public.pets USING btree (organisation_id);


--
-- Name: index_pets_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pets_on_user_id ON public.pets USING btree (user_id);


--
-- Name: index_product_category_joins_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_category_joins_on_category_id ON public.product_category_joins USING btree (category_id);


--
-- Name: index_product_category_joins_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_category_joins_on_product_id ON public.product_category_joins USING btree (product_id);


--
-- Name: index_product_order_joins_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_order_joins_on_order_id ON public.product_order_joins USING btree (order_id);


--
-- Name: index_product_order_joins_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_order_joins_on_product_id ON public.product_order_joins USING btree (product_id);


--
-- Name: index_products_on_organisation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_organisation_id ON public.products USING btree (organisation_id);


--
-- Name: index_reviews_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reviews_on_product_id ON public.reviews USING btree (product_id);


--
-- Name: index_reviews_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reviews_on_user_id ON public.reviews USING btree (user_id);


--
-- Name: index_temporary_daycare_visits_on_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_temporary_daycare_visits_on_employee_id ON public.temporary_daycare_visits USING btree (employee_id);


--
-- Name: index_temporary_daycare_visits_on_org_status_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_temporary_daycare_visits_on_org_status_date ON public.temporary_daycare_visits USING btree (organisation_id, status, date);


--
-- Name: index_temporary_daycare_visits_on_organisation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_temporary_daycare_visits_on_organisation_id ON public.temporary_daycare_visits USING btree (organisation_id);


--
-- Name: index_temporary_daycare_visits_on_organisation_id_and_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_temporary_daycare_visits_on_organisation_id_and_date ON public.temporary_daycare_visits USING btree (organisation_id, date);


--
-- Name: index_temporary_grooms_on_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_temporary_grooms_on_employee_id ON public.temporary_grooms USING btree (employee_id);


--
-- Name: index_temporary_grooms_on_org_status_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_temporary_grooms_on_org_status_date ON public.temporary_grooms USING btree (organisation_id, status, date);


--
-- Name: index_temporary_grooms_on_organisation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_temporary_grooms_on_organisation_id ON public.temporary_grooms USING btree (organisation_id);


--
-- Name: index_temporary_grooms_on_organisation_id_and_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_temporary_grooms_on_organisation_id_and_date ON public.temporary_grooms USING btree (organisation_id, date);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_organisation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_organisation_id ON public.users USING btree (organisation_id);


--
-- Name: index_users_on_organisation_id_and_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_organisation_id_and_phone ON public.users USING btree (organisation_id, phone);


--
-- Name: pets fk_rails_0fa4bae6b1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT fk_rails_0fa4bae6b1 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: daycare_visits fk_rails_132c7d43ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daycare_visits
    ADD CONSTRAINT fk_rails_132c7d43ca FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- Name: images fk_rails_19cd822056; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT fk_rails_19cd822056 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: onboarding_pets fk_rails_3a66c530fb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onboarding_pets
    ADD CONSTRAINT fk_rails_3a66c530fb FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: temporary_grooms fk_rails_3eeab0d03e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporary_grooms
    ADD CONSTRAINT fk_rails_3eeab0d03e FOREIGN KEY (employee_id) REFERENCES public.users(id);


--
-- Name: log_reports fk_rails_42082339ed; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_reports
    ADD CONSTRAINT fk_rails_42082339ed FOREIGN KEY (temporary_groom_id) REFERENCES public.temporary_grooms(id);


--
-- Name: daycare_visits fk_rails_518dd25eba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daycare_visits
    ADD CONSTRAINT fk_rails_518dd25eba FOREIGN KEY (employee_id) REFERENCES public.users(id);


--
-- Name: products fk_rails_550fc2b569; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_rails_550fc2b569 FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- Name: product_category_joins fk_rails_56df6eaf7a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_category_joins
    ADD CONSTRAINT fk_rails_56df6eaf7a FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: images fk_rails_5f6f7eff28; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT fk_rails_5f6f7eff28 FOREIGN KEY (groom_id) REFERENCES public.grooms(id);


--
-- Name: images fk_rails_6d4d09f216; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT fk_rails_6d4d09f216 FOREIGN KEY (temporary_groom_id) REFERENCES public.temporary_grooms(id);


--
-- Name: categories fk_rails_6ee4866115; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT fk_rails_6ee4866115 FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- Name: reviews fk_rails_74a66bd6c5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_rails_74a66bd6c5 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: daycare_visits fk_rails_7589875ec8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daycare_visits
    ADD CONSTRAINT fk_rails_7589875ec8 FOREIGN KEY (pet_id) REFERENCES public.pets(id);


--
-- Name: grooms fk_rails_7a98d4e14b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grooms
    ADD CONSTRAINT fk_rails_7a98d4e14b FOREIGN KEY (employee_id) REFERENCES public.users(id);


--
-- Name: pets fk_rails_7c53bdee02; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT fk_rails_7c53bdee02 FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- Name: temporary_daycare_visits fk_rails_84cf442eab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporary_daycare_visits
    ADD CONSTRAINT fk_rails_84cf442eab FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- Name: log_reports fk_rails_88d34f032d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_reports
    ADD CONSTRAINT fk_rails_88d34f032d FOREIGN KEY (groom_id) REFERENCES public.grooms(id);


--
-- Name: orders fk_rails_8adba69ca4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_rails_8adba69ca4 FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- Name: product_category_joins fk_rails_8cc50ae96f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_category_joins
    ADD CONSTRAINT fk_rails_8cc50ae96f FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: grooms fk_rails_8f95164373; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grooms
    ADD CONSTRAINT fk_rails_8f95164373 FOREIGN KEY (pet_id) REFERENCES public.pets(id);


--
-- Name: onboarding_pets fk_rails_91a9501b99; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onboarding_pets
    ADD CONSTRAINT fk_rails_91a9501b99 FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- Name: log_reports fk_rails_98e4f3e5f3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_reports
    ADD CONSTRAINT fk_rails_98e4f3e5f3 FOREIGN KEY (temporary_daycare_visit_id) REFERENCES public.temporary_daycare_visits(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: users fk_rails_9a64b73984; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_9a64b73984 FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- Name: images fk_rails_9dab9b62a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT fk_rails_9dab9b62a6 FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: images fk_rails_bd36e75ae4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT fk_rails_bd36e75ae4 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: reviews fk_rails_bedd9094d4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_rails_bedd9094d4 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: temporary_daycare_visits fk_rails_c8b128f1f3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporary_daycare_visits
    ADD CONSTRAINT fk_rails_c8b128f1f3 FOREIGN KEY (employee_id) REFERENCES public.users(id);


--
-- Name: grooms fk_rails_e1b884cc88; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grooms
    ADD CONSTRAINT fk_rails_e1b884cc88 FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- Name: images fk_rails_e4ddc9e2c4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT fk_rails_e4ddc9e2c4 FOREIGN KEY (onboarding_pet_id) REFERENCES public.onboarding_pets(id);


--
-- Name: log_reports fk_rails_ec0ff3140c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_reports
    ADD CONSTRAINT fk_rails_ec0ff3140c FOREIGN KEY (daycare_visit_id) REFERENCES public.daycare_visits(id);


--
-- Name: temporary_grooms fk_rails_f104b5e9b3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporary_grooms
    ADD CONSTRAINT fk_rails_f104b5e9b3 FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- Name: orders fk_rails_f868b47f6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_rails_f868b47f6a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: images fk_rails_fef71f2b9c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT fk_rails_fef71f2b9c FOREIGN KEY (pet_id) REFERENCES public.pets(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 4xZc49MGFwpPR5EArAVAkT2OFVtvN1lsY5ERRNJ1ZnW7JP2eeheoui9VFrBM1dD

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20260120092418'),
('20251125123247'),
('20251118130911'),
('20251118130852'),
('20251118130201'),
('20251118130130'),
('20251112092604'),
('20251112092222'),
('20251023124605'),
('20250902131258'),
('20250902130509'),
('20250819122549'),
('20250813123725'),
('20250226122836'),
('20250226115444'),
('20250209124815'),
('20250209123005'),
('20250209120104'),
('20250209115850'),
('20250201115424'),
('20250201041919'),
('20250201040630'),
('20250124234933'),
('20250116103712'),
('20250116102515'),
('20250116053059'),
('20250112121317'),
('20241110133908'),
('20241001114038'),
('20240925124458'),
('20240925115751'),
('20240923113840'),
('20240923112139'),
('20240922130108'),
('20240910111129'),
('20240910100011'),
('20240909123800'),
('20240909114417'),
('20240828121210'),
('20240827120105'),
('20240820123001'),
('20240820121612'),
('20240815121645'),
('20240814120510'),
('20240813122310'),
('20240812124826'),
('20240812123002'),
('20240811113015'),
('20240731102032'),
('20240721104704'),
('20240717104219'),
('20240715115959'),
('20240715114418'),
('20240703102909'),
('20240604115053'),
('20240604113529'),
('20240519114136'),
('20240404110118'),
('20240403121514'),
('20240403120526'),
('20240403115052'),
('20240327123312'),
('20240327123129');

