CREATE EXTENSION IF NOT EXISTS vector;

-- Table: public.customer

-- DROP TABLE IF EXISTS public.customer;

CREATE TABLE IF NOT EXISTS public.customer
(
    id text COLLATE pg_catalog."default" NOT NULL,
    data jsonb,
    CONSTRAINT customer_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.customer
    OWNER to wsuser;

-- Table: public.index

-- DROP TABLE IF EXISTS public.index;

CREATE TABLE IF NOT EXISTS public.index
(
    key text COLLATE pg_catalog."default" NOT NULL,
    metadata jsonb,
    embedding vector(1536),
    "timestamp" timestamp with time zone,
    CONSTRAINT index_pkey PRIMARY KEY (key)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.index
    OWNER to wsuser;

-- Table: public.message

-- DROP TABLE IF EXISTS public.message;

CREATE TABLE IF NOT EXISTS public.message
(
    id text COLLATE pg_catalog."default" NOT NULL,
    sessionid text COLLATE pg_catalog."default",
    data jsonb,
    CONSTRAINT message_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.message
    OWNER to wsuser;

-- Table: public.product

-- DROP TABLE IF EXISTS public.product;

CREATE TABLE IF NOT EXISTS public.product
(
    data jsonb,
    id text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT product_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.product
    OWNER to wsuser;

-- Table: public.session

-- DROP TABLE IF EXISTS public.session;

CREATE TABLE IF NOT EXISTS public.session
(
    sessionid text COLLATE pg_catalog."default" NOT NULL,
    data jsonb,
    CONSTRAINT session_pkey PRIMARY KEY (sessionid)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.session
    OWNER to wsuser;