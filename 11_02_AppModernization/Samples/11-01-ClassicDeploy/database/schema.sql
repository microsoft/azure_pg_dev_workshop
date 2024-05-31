--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0
-- Dumped by pg_dump version 16.0

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
-- Name: cart_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_items (
    id bigint NOT NULL,
    cart_id bigint NOT NULL,
    item_id bigint NOT NULL,
    qty smallint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.cart_items OWNER TO postgres;

--
-- Name: cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cart_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cart_items_id_seq OWNER TO postgres;

--
-- Name: cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cart_items_id_seq OWNED BY public.cart_items.id;


--
-- Name: carts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    status character varying(16) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.carts OWNER TO postgres;

--
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.carts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.carts_id_seq OWNER TO postgres;

--
-- Name: carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.carts_id_seq OWNED BY public.carts.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying(32) NOT NULL,
    url character varying(32) NOT NULL,
    img character varying(128) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items (
    id bigint NOT NULL,
    category_id bigint NOT NULL,
    name character varying(32) NOT NULL,
    img character varying(128) NOT NULL,
    price numeric(6,2) NOT NULL,
    cooktime smallint NOT NULL,
    "desc" text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.items OWNER TO postgres;

--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.items_id_seq OWNER TO postgres;

--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    cart_id bigint NOT NULL,
    name character varying(64) NOT NULL,
    address character varying(256) NOT NULL,
    special_instructions text,
    cooktime smallint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.personal_access_tokens OWNER TO postgres;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.personal_access_tokens_id_seq OWNER TO postgres;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(64) NOT NULL,
    address character varying(256) NOT NULL,
    email character varying(128) NOT NULL,
    password character varying(128) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: cart_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN id SET DEFAULT nextval('public.cart_items_id_seq'::regclass);


--
-- Name: carts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts ALTER COLUMN id SET DEFAULT nextval('public.carts_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: cart_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_items (id, cart_id, item_id, qty, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carts (id, user_id, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, name, url, img, created_at, updated_at) FROM stdin;
1	Breakfast	breakfast	potatoes-g792cf4128_1920.jpg	\N	\N
2	Steak	steak	tomahawk-ge5ea2413d_1920.jpg	\N	\N
3	Pizza	pizza	pizza-g204a8b3d6_1920.jpg	\N	\N
4	Burgers	burgers	hamburger-g685f013b8_1920.jpg	\N	\N
5	Sushi	sushi	food-g3eb975adc_1920.jpg	\N	\N
6	Salads	salads	salad-g3f02f56a0_1920.jpg	\N	\N
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items (id, category_id, name, img, price, cooktime, "desc", created_at, updated_at) FROM stdin;
1	1	Cinnamon Roll	cinnamon-rolls-gb12ce8577_1920.jpg	1.19	13	Cupcake ipsum dolor sit amet drag├⌐e topping topping. Powder cheesecake cake shortbread gummies lollipop jelly carrot cake. Pudding sugar plum carrot cake I love muffin. Dessert topping croissant I love tart souffl├⌐ cheesecake sweet sweet. Liquorice pie marshmallow icing topping muffin. Topping brownie oat cake carrot cake donut chocolate bar cake. Bear claw jelly-o ice cream lollipop shortbread dessert jujubes macaroon. I love danish tootsie roll powder candy canes marzipan icing gingerbread chocolate bar.	\N	\N
2	1	Toast & Eggs	breakfast-g7a2675ee6_1920.jpg	2.19	7	Tiramisu muffin sweet roll cotton candy icing bonbon jelly. Tiramisu oat cake shortbread toffee bonbon shortbread candy canes toffee. Sweet roll biscuit I love oat cake gummies bonbon biscuit danish lemon drops. Toffee ice cream jelly beans caramels muffin. Tart jujubes chocolate bar marshmallow gingerbread I love pie. Chocolate I love chocolate cake cake liquorice lollipop. Tiramisu chocolate jelly-o muffin halvah. Shortbread souffl├⌐ ice cream oat cake cotton candy sesame snaps liquorice. Danish marzipan I love jelly brownie muffin halvah candy canes.	\N	\N
3	1	Croissant	croissant-ga61b1fb0e_1920.jpg	3.19	2	I love chocolate cake I love I love jelly beans cotton candy jelly-o ice cream. Icing cotton candy sweet roll fruitcake biscuit apple pie. Gummies chocolate caramels biscuit I love I love I love cookie croissant. Topping apple pie wafer sesame snaps tootsie roll gummies. Apple pie I love wafer sweet roll tootsie roll. Cheesecake I love apple pie muffin tiramisu lemon drops cake. Macaroon caramels chocolate cotton candy souffl├⌐ tart. Chupa chups lemon drops cupcake topping pastry.	\N	\N
4	1	Bacon & Eggs	eggs-g9c07e92b1_1920.jpg	4.19	14	Toffee sesame snaps chupa chups pie pastry marshmallow I love tootsie roll souffl├⌐. Marshmallow fruitcake cheesecake I love icing cake. Liquorice toffee chocolate bar marzipan cotton candy croissant powder. Bonbon I love danish bear claw tootsie roll. Candy canes wafer fruitcake caramels lollipop tart. Oat cake croissant tart gummi bears cookie muffin. Icing sweet roll chupa chups chupa chups jelly-o brownie. Jelly-o cotton candy liquorice tiramisu halvah jujubes.	\N	\N
5	1	Pancakes	pancakes-g9d341228a_1920.jpg	5.19	12	Chocolate caramels gingerbread drag├⌐e gingerbread brownie powder gummi bears pastry. Sugar plum sugar plum tootsie roll shortbread I love cotton candy. Chocolate cake chocolate bonbon cake biscuit. Toffee cheesecake I love cookie cake marzipan I love chocolate cake liquorice. Biscuit biscuit caramels macaroon lollipop powder tootsie roll. Shortbread jelly-o jujubes jelly-o chocolate carrot cake danish croissant. Biscuit jelly-o donut bonbon muffin carrot cake sesame snaps wafer chupa chups. Chupa chups chocolate bar bonbon I love jelly beans lemon drops macaroon muffin. Chocolate cake cookie jelly-o cake cake croissant muffin halvah candy. Apple pie icing pudding chupa chups macaroon I love biscuit fruitcake I love.	\N	\N
6	1	Biscuits & Gravy	biscuits-g07bd069f8_1920.jpg	6.19	6	Souffl├⌐ marshmallow I love candy canes I love apple pie. Icing wafer I love toffee carrot cake cookie candy canes bear claw pastry. Lollipop topping pudding dessert powder jujubes sesame snaps bonbon apple pie. Macaroon tootsie roll dessert cake I love wafer macaroon sweet roll sesame snaps. Wafer cupcake bear claw sweet brownie I love. Pastry I love muffin marzipan I love topping. Pie candy muffin jelly-o croissant cake sweet. Wafer chocolate lemon drops jujubes lollipop drag├⌐e I love jelly. I love macaroon I love powder tootsie roll jelly muffin wafer.	\N	\N
7	2	Tomahawk	steak-4342500_1920.jpg	1.29	27	Bacon ipsum dolor amet shank picanha landjaeger kevin, ham hock spare ribs sausage capicola buffalo alcatra. Short loin spare ribs alcatra bresaola. Salami tongue drumstick tenderloin flank alcatra shank sirloin biltong landjaeger short ribs jerky. Porchetta meatloaf fatback frankfurter bacon tail, ham biltong kielbasa short ribs pork capicola leberkas jowl. Chicken tenderloin kielbasa pork belly, ham hock jowl bacon salami chuck burgdoggen hamburger tongue short loin biltong. Frankfurter sirloin meatloaf ribeye.	\N	\N
8	2	Sirloin	steak-1076665_1920.jpg	2.29	22	Meatball fatback pastrami, porchetta doner chicken burgdoggen pancetta jerky beef ribs salami. Buffalo ball tip tenderloin chuck, frankfurter alcatra ribeye t-bone spare ribs. Hamburger pork chop swine, picanha flank corned beef burgdoggen shoulder frankfurter ham ball tip. Chicken biltong short ribs short loin spare ribs. Pork loin jerky pork chop, fatback frankfurter filet mignon turducken kevin swine. Prosciutto kielbasa short ribs shoulder frankfurter hamburger. Swine leberkas alcatra jerky, ball tip pastrami meatloaf pork belly doner venison turkey buffalo ham hock pig.	\N	\N
9	2	T-Bone	steak-978654_1920.jpg	3.29	23	Swine doner leberkas tri-tip pork loin hamburger cupim alcatra spare ribs kielbasa bacon. Shoulder tail alcatra meatloaf beef hamburger, short loin tri-tip cupim ham pork chop. Corned beef kevin strip steak tri-tip. Landjaeger meatball chuck biltong salami fatback jerky pastrami shank beef. Frankfurter ground round strip steak pork chop shoulder, picanha pig doner prosciutto chislic ham. Ham hock alcatra shankle chislic rump landjaeger brisket pork leberkas t-bone meatloaf pancetta pork loin.	\N	\N
10	3	Pepperoni	pizza-1344720_1920.jpg	1.39	12	Gouda mozzarella babybel. Jarlsberg emmental who moved my cheese cauliflower cheese brie cheesy feet airedale swiss. Port-salut bocconcini monterey jack squirty cheese cut the cheese say cheese cauliflower cheese lancashire. Who moved my cheese who moved my cheese taleggio cheesy feet cheeseburger hard cheese emmental.	\N	\N
11	3	Margherita	pizza-3000274_1920.jpg	2.39	6	I love cheese, especially who moved my cheese fondue. Parmesan cheese slices the big cheese cheese strings jarlsberg fromage ricotta red leicester. Queso everyone loves cheesecake everyone loves who moved my cheese red leicester fondue smelly cheese. Mozzarella goat blue castello swiss cheese slices hard cheese swiss cow. Cream cheese swiss.	\N	\N
12	4	Sliders	hamburger-494706_1920.jpg	1.49	9	Ribeye ball tip kevin tri-tip beef biltong. Pastrami pork belly burgdoggen, sirloin bresaola andouille flank fatback short ribs chuck shoulder tongue boudin strip steak. Bacon pancetta biltong kielbasa, cow shank sausage rump chuck spare ribs alcatra ground round meatball chicken strip steak. Sirloin andouille pig ham hock swine kielbasa salami tongue meatball cupim jowl. Cow fatback drumstick picanha ball tip. Meatloaf venison shankle rump, tail tenderloin short ribs.	\N	\N
13	4	Charbroiled	hamburger-1238246_1920.jpg	2.49	17	Kielbasa boudin alcatra, beef ribs spare ribs rump pork belly pork chop salami ribeye pancetta. Alcatra picanha ground round, frankfurter short loin porchetta leberkas venison cow fatback landjaeger rump boudin. Flank t-bone kielbasa burgdoggen short ribs landjaeger tenderloin ham hock pastrami. Burgdoggen turducken landjaeger, short ribs frankfurter tail brisket chuck shoulder buffalo sausage doner rump. Swine ground round ribeye ham hock tongue turducken sirloin, burgdoggen sausage shank t-bone cupim.	\N	\N
14	4	Diner Burger	burger-3442227_1920.jpg	3.49	12	Fatback drumstick filet mignon, frankfurter chicken pork meatloaf pork belly venison jerky beef pork loin ham hock biltong. Pork chop ham andouille ground round hamburger. Beef ribs ground round cow pig biltong short ribs sirloin spare ribs. Fatback pork chop cow filet mignon burgdoggen doner picanha swine tongue, tail corned beef meatball pancetta pork.	\N	\N
15	5	Sashimi Fresh Roll	sushi-354628_1920.jpg	1.59	3	Barbelless catfish eel-goby spiny eel yellowtail snapper mullet minnow white marlin northern pike bigeye? Sauger sandroller; hoki sixgill ray squawfish sailfin silverside. Olive flounder giant danio herring smelt tailor Australasian salmon barbeled houndshark southern grayling porbeagle shark roundhead.	\N	\N
16	5	Power Fish	sushi-2853382_1920.jpg	2.59	5	Atlantic silverside jewfish shovelnose sturgeon huchen temperate ocean-bass mullet menhaden stargazer yellowtail orangestriped triggerfish bluefin tuna. Arapaima plunderfish arapaima, mudskipper, earthworm eel snubnose eel Pacific viperfish tripletail.	\N	\N
17	5	Spicy Tuna	sushi-599721_1920.jpg	3.59	7	Elephantnose fish bango longjaw mudsucker; sand stargazer? Dragonet: kissing gourami tench demoiselle; bullhead shark lookdown catfish halibut tubeblenny southern flounder, hairtail gray reef shark. Long-whiskered catfish lake whitefish, worm eel Ratfish European minnow! Javelin temperate perch sandroller waryfish pikehead gouramie longnose dace starry flounder medusafish cusk-eel.	\N	\N
18	5	Avocado Roll	maki-716432_1920.jpg	4.59	2	Wormfish, glowlight danio Atlantic cod ide flagblenny, ribbon sawtail fish Kafue pike southern grayling. Speckled trout grayling ling nurseryfish threadfin. Snake eel char sturgeon scissor-tail rasbora blue eye worm eel southern smelt. Salmon jellynose fish, buffalofish lanternfish kaluga duckbill eel. Swampfish halosaur flashlight fish wahoo popeye catafula pirarucu; torpedo; rock beauty longnose chimaera elver thornfish, rough scad! Pipefish tompot blenny Kafue pike large-eye bream elasmobranch northern lampfish soapfish rocket danio mudskipper smalltooth sawfish.	\N	\N
19	5	Sampler Plate	sushi-2856545_1920.jpg	5.59	4	Poolfish waryfish frilled shark louvar, wasp fish blue catfish Molly Miller Black scalyfin gizzard shad, platyfish, common carp. Tiger shark roanoke bass milkfish yellowhead jawfish, round stingray sea bass surfperch treefish Asiatic glassfish. Silver carp scissor-tail rasbora pompano dolphinfish: frogmouth catfish mackerel shark. Perch hardhead catfish sand stargazer: goosefish wolf-herring.	\N	\N
20	5	Veggie Roll	sushi-2020287_1920.jpg	6.59	2	Stingray, tarpon; clown triggerfish plaice pleco wrasse Pacific herring kuhli loach rough scad, burma danio. River stingray weasel shark popeye catafula Australian grayling remora flying gurnard smalltooth sawfish, dwarf loach pike conger. Thornyhead megamouth shark pencilfish blacktip reef shark Atlantic silverside Black pickerel, electric eel spiderfish bass electric catfish? Peamouth tetra lightfish midshipman monkfish spearfish burrowing goby trahira, collared dogfish yellow weaver driftfish, dorab roosterfish, sea bream.	\N	\N
21	5	Maki	sushi-748139_1920.jpg	7.59	5	Angler, swampfish orangestriped triggerfish oceanic flyingfish northern anchovy smooth dogfish. Bigscale pomfret stonefish pollyfish warmouth; round herring banded killifish. Walking catfish, weever cod: Antarctic icefish slimy sculpin.	\N	\N
22	6	Bowl of Lettuce	food-1834645_1920.jpg	1.69	1	Carrot grape soko wakame plantain pea broccoli rabe desert raisin. Chard cabbage cress gumbo spinach mung bean turnip greens rock melon chicory collard greens bok choy. Wattle seed wakame eggplant soybean quandong garlic prairie turnip swiss chard radish okra.	\N	\N
23	6	Plate of Lettuce	salad-2150548_1920.jpg	2.69	1	Nori grape silver beet broccoli kombu beet greens fava bean potato quandong celery. Bunya nuts black-eyed pea prairie turnip leek lentil turnip greens parsnip. Sea lettuce lettuce water chestnut eggplant winter purslane fennel azuki bean earthnut pea sierra leone bologi leek soko chicory celtuce parsley j├¡cama salsify.	\N	\N
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	2019_12_14_000001_create_personal_access_tokens_table	1
2	2021_12_10_155392_create_user_table	1
3	2021_12_10_165212_create_category_table	1
4	2021_12_10_165231_create_item_table	1
5	2021_12_10_165446_create_cart_table	1
6	2021_12_10_170023_create_order_table	1
7	2021_12_16_030021_create_cart_items_table	1
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, user_id, cart_id, name, address, special_instructions, cooktime, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, address, email, password, created_at, updated_at) FROM stdin;
1	Jon Yang	3761 N. 14th St	jon24@adventure-works.com	$2y$10$WP.kroOpXnxaqOZHT7QceeE651C4VrK.BTXJuUj.qhpTAzu.fRdJW	\N	\N
2	Eugene Huang	2243 W St.	eugene10@adventure-works.com	$2y$10$lDsh/SnCmUF.1SakLlpHou5X08QKi..zisZAIICEf/TDlXJMtqd9a	\N	\N
3	Ruben Torres	5844 Linden Land	ruben35@adventure-works.com	$2y$10$434opJvsqYtVldux8FDkP.hGLa.DerlJZPiyXbBEEsrf7dKCD9Jsm	\N	\N
4	Christy Zhu	1825 Village Pl.	christy12@adventure-works.com	$2y$10$8/BmptQPWuYEA1MoRpeR6O/xL4NlYH3X/cNlTrurwjE7VwrFA73RC	\N	\N
5	Elizabeth Johnson	7553 Harness Circle	elizabeth5@adventure-works.com	$2y$10$SwcIh5w7ThFzH4/XDdSBtOwefYf0D2.J5u0rtlarkx3VjdOPQHUgK	\N	\N
6	Julio Ruiz	7305 Humphrey Drive	julio1@adventure-works.com	$2y$10$KARZ.tnPRXwjZJayuPeOVeNUucmG8L0E18tEP4kOcBzpUgM//o8ee	\N	\N
7	Janet Alvarez	2612 Berry Dr	janet9@adventure-works.com	$2y$10$ceVu6mT34HaN7xSk4kIFV.8.UMySbwAOvqzmIgKbQJz472/X6mxXe	\N	\N
8	Marco Mehta	942 Brook Street	marco14@adventure-works.com	$2y$10$o9hNdTNBO9kczrY4yoVwwuicErkLSHQJmI7uxXOSjoUEkbXj541lm	\N	\N
9	Rob Verhoff	624 Peabody Road	rob4@adventure-works.com	$2y$10$oogFbxeCHHT5Rb88PyDVl.WrEPH.cPB03IOzAZ.degm1yuEYDCnda	\N	\N
10	Shannon Carlson	3839 Northgate Road	shannon38@adventure-works.com	$2y$10$LzvGZXaFaQw56YpYaehoAu5wca/EzetdzIUWT07WRUZoqK4k15Te6	\N	\N
11	Jacquelyn Suarez	7800 Corrinne Court	jacquelyn20@adventure-works.com	$2y$10$oxAXQdR5VGw2DWs2zyI1EeCrJWhvf2HuJkblqhK5PkkaOSupKBTuC	\N	\N
12	Curtis Lu	1224 Shoenic	curtis9@adventure-works.com	$2y$10$gkMhdQCg16giLqMT5EDdEu8mA3hq7PVndyHrYzJlUzakjeiZL0.gy	\N	\N
13	Lauren Walker	4785 Scott Street	lauren41@adventure-works.com	$2y$10$gYlApq72LEC8vC8f3AbzQO3SNpNC.rdFOyWbSXilsZkuR0vQQb4O2	\N	\N
14	Ian Jenkins	7902 Hudson Ave.	ian47@adventure-works.com	$2y$10$IF1WUY4671AegNyN1u4WduRStkkUkOwTALiXh2MqDldWamXLmJq76	\N	\N
15	Sydney Bennett	9011 Tank Drive	sydney23@adventure-works.com	$2y$10$Z3oDyLk9gBAeMoTuI.MKheEwxg4Ym3T1rgX0V/XNkjX.8njSrR.5m	\N	\N
16	Chloe Young	244 Willow Pass Road	chloe23@adventure-works.com	$2y$10$rIjqtKpXk3dTJD0PlRgFBe2AlBtQb.yXGvskoXxBQSL7UN1.FI5Ty	\N	\N
17	Wyatt Hill	9666 Northridge Ct.	wyatt32@adventure-works.com	$2y$10$q0ccT.UuFtTyFsmhl9HjD.jo7sfs6A3MU23jaTimEw86.kXf.zvl6	\N	\N
18	Shannon Wang	7330 Saddlehill Lane	shannon1@adventure-works.com	$2y$10$AyhN8CJ4bgKzhLi3bXbG6etKRDJ7f2MEwzBIV.FxlgwSOu3q85OqO	\N	\N
19	Clarence Rai	244 Rivewview	clarence32@adventure-works.com	$2y$10$DA9mrjUwVOuDD.yLg5VqXOdZHiOWWAe2X6APjcPdloAfXU4LJdMOO	\N	\N
20	Luke Lal	7832 Landing Dr	luke18@adventure-works.com	$2y$10$U9mVsu4ovO9rJVt9AxhVO.CeWQqnb4YA2tUtrcCrCIl98aJF7jMNG	\N	\N
21	Jordan King	7156 Rose Dr.	jordan73@adventure-works.com	$2y$10$ZbiC/o0ftDpvTQWFtUST5OvnaWPfLNMUeQJzt6.t35R9v.cVvgJYC	\N	\N
22	Destiny Wilson	8148 W. Lake Dr.	destiny7@adventure-works.com	$2y$10$Qni8.CRs/W2zBaSHdsXhM.yRYBEuddYLSv0dQsSe/Vq5TDWyQD/Yi	\N	\N
23	Ethan Zhang	1769 Nicholas Drive	ethan20@adventure-works.com	$2y$10$JfiaKfpoAVlcaFkMiV0A4eI1qcivb/EV/E2BrUtolVKBZEceKg7u.	\N	\N
24	Seth Edwards	4499 Valley Crest	seth46@adventure-works.com	$2y$10$dqI4PjqSjqYLbrleLG43BeXvK3S5Nu5oiVhCb315TPIHJMeIIVx76	\N	\N
25	Russell Xie	8734 Oxford Place	russell7@adventure-works.com	$2y$10$ODOdtGCHSDcGP6t4NAF/delrMEJaZgu6uKW4gMDzPVQLswQxk9/0O	\N	\N
26	Alejandro Beck	2596 Franklin Canyon Road	alejandro45@adventure-works.com	$2y$10$W5D.ZtnekbPNBoUYzmTzle.AAbU5kFvSguUVqE3CHnEXdrY8IlnwK	\N	\N
27	Harold Sai	8211 Leeds Ct.	harold3@adventure-works.com	$2y$10$Of0ZsVRRYcJBVyI8R6r76ufOJmJI2wJHDJ5eap8GvH4fn1yJAOQtC	\N	\N
28	Jessie Zhao	213 Valencia Place	jessie16@adventure-works.com	$2y$10$yRzhFH1DpLAxnFxRL8xWtemBsBV6YN4afCvEEOl/cewZi8hPmoiA.	\N	\N
29	Jill Jimenez	9111 Rose Ann Ave	jill13@adventure-works.com	$2y$10$LhMdyZ5JBmie1Izsm0SL6ewXCEash62ejgw.ZgWCHTbA9bgXG75dK	\N	\N
30	Jimmy Moreno	6385 Mark Twain	jimmy9@adventure-works.com	$2y$10$WNoa/EkeHwfXai/yCMCnluV2liWZdCiXoxtnkmxlT.hYw.LI5SpcO	\N	\N
31	Bethany Yuan	636 Vine Hill Way	bethany10@adventure-works.com	$2y$10$4BN48UekxiLyoyJi.mkhN.1mcSkkAefNOE94KUnwSNa1OLBI3xWS.	\N	\N
32	Theresa Ramos	6465 Detroit Ave.	theresa13@adventure-works.com	$2y$10$ZE49ENMdfAjXVVRQIHS6ouS38D8dTqNGzaLc3u7kKF9M4R2/DmLK6	\N	\N
33	Denise Stone	626 Bentley Street	denise10@adventure-works.com	$2y$10$K70SA4dLnKzI9xFAAQOtJ.4bm0EJMM1MBlygRIhCQyKsUKjWKECo.	\N	\N
34	Jaime Nath	5927 Rainbow Dr	jaime41@adventure-works.com	$2y$10$rHCRP30mb3d/gKVMX2EFBOl41g.j5bJy.ETZhhhCAmmjhcDtPtdLS	\N	\N
35	Ebony Gonzalez	5167 Condor Place	ebony19@adventure-works.com	$2y$10$ZfZuaMbQrwODEpjOHuG70uBF9XRhQ/s7BETiNp4fZb4HUMGRcFrpi	\N	\N
36	Wendy Dominguez	1873 Mt. Whitney Dr	wendy12@adventure-works.com	$2y$10$4mlQVccA5x6ezmGP7GfA2.nBqVq6HMewNmhlCpuCMvf8PRZCmI2P2	\N	\N
37	Jennifer Russell	3981 Augustine Drive	jennifer93@adventure-works.com	$2y$10$tKo/eNvgjklGxNyTsR2KSu4UT1IUZcMjV75G1KX/PDYZtRyEvYWr.	\N	\N
38	Chloe Garcia	8915 Woodside Way	chloe27@adventure-works.com	$2y$10$J8XZadJmJ2zow7dnB7.iD.ngQiXpdKwkrolOMLtvelcBfw64gTHsu	\N	\N
39	Diana Hernandez	8357 Sandy Cove Lane	diana2@adventure-works.com	$2y$10$ZmLrrAzkcWGfUf.EPdJbs.T8DtE6NiQQ8y.drAbqlkB.Yr2Emzw72	\N	\N
40	Marc Martin	9353 Creekside Dr.	marc3@adventure-works.com	$2y$10$Ts2Hh7s9XflaXs4sZgiCluyq/HL3GZXBWeMZbtanmdNJSOWhgh9mu	\N	\N
41	Jesse Murphy	3350 Kingswood Circle	jesse15@adventure-works.com	$2y$10$2yQjwJcKjmaODFAkT7R4SOaglKnGWJdbM4CNs74A6GEIqGLITFRda	\N	\N
42	Amanda Carter	5826 Escobar	amanda53@adventure-works.com	$2y$10$P5UXuL9sUCxxGQ4nKyplOuQazmiPzhNJf9rf3ae8.ayKG4jhc0ZQO	\N	\N
43	Megan Sanchez	1397 Paraiso Ct.	megan28@adventure-works.com	$2y$10$S3Dm0iCYmNV/pr21gsoJoeWXHWLznKK0meDnMO30tf5/LVQedC8sm	\N	\N
44	Nathan Simmons	1170 Shaw Rd	nathan11@adventure-works.com	$2y$10$.kdTR.d0IDZiOJQ/f1v.5u9J95KXzUHrb9/Jn.ODVdYbjOupo1POO	\N	\N
45	Adam Flores	6935 Candle Dr	adam10@adventure-works.com	$2y$10$DVYpnPKJuy1Xq.h0lJjSO.H6hhShGpq4tnghm//AFLcvilyDMEQEu	\N	\N
46	Leonard Nara	7466 La Vista Ave.	leonard18@adventure-works.com	$2y$10$lRO6I6gbIDQDkYQkmO8HpOnsg1aLp5KMnRteA4DHH.ieJnXvzGLXK	\N	\N
47	Christine Yuan	2356 Orange St	christine4@adventure-works.com	$2y$10$ri0XBgAXLSFu/PgKT2hxzez1vYujbjlE8yqmwxHbyjNfXIxR4h1TC	\N	\N
48	Jaclyn Lu	2812 Mazatlan	jaclyn12@adventure-works.com	$2y$10$4eMOLPaiiJa.pb1PCwPecOhzBrpIqEBMZrGSaS0McLXJXRXQG8Mha	\N	\N
49	Jeremy Powell	1803 Potomac Dr.	jeremy26@adventure-works.com	$2y$10$Bu73NlfZ2bHujblmGiHqJOVbyqs.ticEP5bysYiKsSWoF2H7gA.zK	\N	\N
50	Carol Rai	6064 Madrid	carol8@adventure-works.com	$2y$10$BVpPBi5fwZ6byv5E9sxU2eO3GLx9ZqTn2vj7aNHMu.Zap07mr7tHi	\N	\N
51	Alan Zheng	2741 Gainborough Dr.	alan23@adventure-works.com	$2y$10$ZlBBCNrToz4LGvAazb7a4.r7CdAvCKvM62aZt.phdD5KTKptM89p2	\N	\N
52	Daniel Johnson	8085 Sunnyvale Avenue	daniel18@adventure-works.com	$2y$10$xWtY7W7s8wo3C8fpWtH.k.AlPgUpTCMnRUwYzO7HfNHIgGuk/mQcm	\N	\N
53	Heidi Lopez	2514 Via Cordona	heidi19@adventure-works.com	$2y$10$2hN7UPs.qGOZ2e/.YF/KQe5TczZIHI/N.UhR4ZMaMcFfJAQcqGASu	\N	\N
54	Ana Price	1660 Stonyhill Circle	ana0@adventure-works.com	$2y$10$mZ2tjXiTyPSrCWPFsndqpuiSsRoJZ7sbCObbL4pD.8QyLGHcqNM3C	\N	\N
55	Deanna Munoz	5825 B Way	deanna33@adventure-works.com	$2y$10$c3Nt9n7w1DjrcdXTq6LB0eOcWJLU2TK7twLlE851tKKILji.tz5se	\N	\N
56	Gilbert Raje	8811 The Trees Dr.	gilbert35@adventure-works.com	$2y$10$J5az9DuhwU9OHZ2hijy7Hu6.ecJa/HacZYcXPoHymZA6k/YTPMLHu	\N	\N
57	Michele Nath	5464 Janin Pl.	michele19@adventure-works.com	$2y$10$K9YQgc6a.dSkjtkIfhM6wOruaioEXcPfmDtBVpz4zWtlKeYLoe3iu	\N	\N
58	Carl Andersen	6930 Lake Nadine Place	carl12@adventure-works.com	$2y$10$kfQgInvfeSaA0gTmzobveOTNYutIRPwK22nn5/XjBa3OUfIoFxfsa	\N	\N
59	Marc Diaz	6645 Sinaloa	marc6@adventure-works.com	$2y$10$ypdm64D/hKZkG9TKjJPcAOhqPcc0.H49aLpzWDU39yKWa.ix50mWO	\N	\N
60	Ashlee Andersen	8255 Highland Road	ashlee19@adventure-works.com	$2y$10$KsIij2vP5oS3Zr2rMzLSe.QbF02Y0Jzh87Y9HaQ8tuVNsq69HdwhS	\N	\N
61	Jon Zhou	6574 Hemlock Ave.	jon28@adventure-works.com	$2y$10$2HBFsJHDxSlAYgiR9G06.ObdB6p2/NK1swrCQ3/XmtrG99S.yHeay	\N	\N
62	Todd Gao	8808 Geneva Ave	todd14@adventure-works.com	$2y$10$J6qD4et6/uQ9iZvDVn/vROr.jDvPuklgyW6TKSFYyJZX26iAiV7e.	\N	\N
63	Noah Powell	9794 Marion Ct	noah5@adventure-works.com	$2y$10$IXXiZ5lF6tNjAXKYxYSTnesUDKF6B029Y2QiPfm35MCitTPk/sfmm	\N	\N
64	Angela Murphy	4927 Virgil Street	angela41@adventure-works.com	$2y$10$F74EJzlowGPGbwJBFbh7S.gYegRkybucm34wUf5EUrexlLd.ngafK	\N	\N
65	Chase Reed	2721 Alexander Pl.	chase21@adventure-works.com	$2y$10$Etr6ypF3is14tjMc2I1dpOmFlu4.aogPI7Ax2QSNf1dIRpg5GoQeO	\N	\N
66	Jessica Henderson	9343 Ironwood Way	jessica29@adventure-works.com	$2y$10$JDtwPFYF1LInkHcy2u54H.nv3wRXdlRuvnmGv4zaJUmbwFw6wsJXy	\N	\N
67	Grace Butler	4739 Garden Ave.	grace62@adventure-works.com	$2y$10$nbYhVw6Oo8oM2ytvbLKvduHuOxhUg9IL3xtml/.E6/eSsN8.2R3VO	\N	\N
68	Caleb Carter	9563 Pennsylvania Blvd.	caleb40@adventure-works.com	$2y$10$IDejvf/kbDaFu4.rUhWMdeG2MVqR52BtDPWFXOH7ZNflr6I6AOJoS	\N	\N
69	Tiffany Liang	3608 Sinclair Avenue	tiffany17@adventure-works.com	$2y$10$Swz438xeqZOVBQuSJIBL9OnBoJf0k7V/PNRD16FUE4gCH.LsR4z86	\N	\N
70	Carolyn Navarro	4606 Springwood Court	carolyn30@adventure-works.com	$2y$10$G2xMotWrqyz4qGeO6aBQUOcjxWD.a.U7YkYspIjJoW30ElmVR3OzW	\N	\N
71	Willie Raji	6260 Vernal Drive	willie40@adventure-works.com	$2y$10$MvsyUxrIPWuXW78h7SqRw.11M3IE/g6RAJzn.cC2w9QkSTwlHFdZy	\N	\N
72	Linda Serrano	9808 Shaw Rd.	linda31@adventure-works.com	$2y$10$dE5vdd7xzLT4L9b18gDl6.yxTyCi4mIBnadYZidikE/0jGTXzv7Nu	\N	\N
73	Casey Luo	9513 Roslyn Drive	casey6@adventure-works.com	$2y$10$VJ5OHn3jKz/ix9baScWEYuGyOQX9d04B8T4Z8TqEqmeAj2PW4XzJG	\N	\N
74	Amy Ye	2262 Kirkwood Ct.	amy16@adventure-works.com	$2y$10$y1nBnIWRdlx6eSvCpbRSfu.9JuW.9/FTW99JF7J9ujrcbj2becL6a	\N	\N
75	Levi Arun	4661 Bluetail	levi6@adventure-works.com	$2y$10$FuiFmN8QpG66UHahiiKed.cVsBE3Y2r9wZgR2cAux3/9J/YdY9jxy	\N	\N
76	Felicia Jimenez	786 Eastgate Ave	felicia4@adventure-works.com	$2y$10$rSj61IGPw1TW9bf8UkYszuV/QiJBZmyXZXvXIL4AXkdyKieQpYKSi	\N	\N
77	Blake Anderson	5436 Clear	blake9@adventure-works.com	$2y$10$jMErc1M2boZawYoL/Kv0YeBXkRiOfu1/UuklZrJ./a1YBW8z./QaO	\N	\N
78	Leah Ye	1291 Arguello Blvd.	leah7@adventure-works.com	$2y$10$m/QNvqdfXEk1zFUj4OXToOX4zdJ4DQF9RFZ652E8uEcp39lfygETm	\N	\N
79	Gina Martin	1349 Sol St.	gina1@adventure-works.com	$2y$10$moVwEhj9gSvQgdwvzrxebuVrPfo2rOScyJGTCM2h7atYnjh.AWuCy	\N	\N
80	Donald Gonzalez	4236 Malibu Place	donald20@adventure-works.com	$2y$10$6EVGVLHrExPAnBiMjYF.MOzpaC3Q6dm3eP71yTvkpWw9EtdyFEeGC	\N	\N
81	Damien Chander	9941 Stonehedge Dr.	damien32@adventure-works.com	$2y$10$.pip91sOXPlBnkMIVIhb5OCcaWvPBk/zfQan9udGZz4J4VBbOk/4a	\N	\N
82	Savannah Baker	1210 Trafalgar Circle	savannah39@adventure-works.com	$2y$10$2IxWRTETkErIXsuMWDNZyO4xAA3gwQtp.7P/uEaPb3hO7CUclauAq	\N	\N
83	Angela Butler	6040 Listing Ct	angela17@adventure-works.com	$2y$10$gUsLkyJbpVlN/zlXsrhBNu/Yl/yodWUuTIqRZSGjyM/.fNlP/roN2	\N	\N
84	Alyssa Cox	867 La Orinda Place	alyssa37@adventure-works.com	$2y$10$UZEPo.6v7jT2Y2kAWcF3JegFFY3WD/FuWPlty7H1KXiruFKLfL7MK	\N	\N
85	Lucas Phillips	8668 St. Celestine Court	lucas7@adventure-works.com	$2y$10$FnNgi4xAXFJnJEfluLrv1.aZa4i4R9O00NhRBuXx5BA1IqIJwpPLa	\N	\N
86	Emily Johnson	7926 Stephanie Way	emily1@adventure-works.com	$2y$10$4pjIftWSnpNVmvh7JV8dPeRWxSDoBo6JYBbbFutxEpaAg/ZI89a2W	\N	\N
87	Ryan Brown	2939 Wesley Ct.	ryan43@adventure-works.com	$2y$10$5ttnNdOZleXSsBsXR28yv.GBV7dVKpmJG0fcj0bsrwMF36CRsQy5u	\N	\N
88	Tamara Liang	3791 Rossmor Parkway	tamara6@adventure-works.com	$2y$10$l8AIDT1AT2dubLmvzig0UOCUKvsWq/a2LU5Ovsw5YUbTVthy0CpUu	\N	\N
89	Hunter Davis	4308 Sand Pointe Lane	hunter64@adventure-works.com	$2y$10$SzCW.zR2dsEGvJZ1MtJ1H.e8JagiJaYv/MiUgfGD8tkZrnDlBsTvW	\N	\N
90	Abigail Price	2685 Blackburn Ct	abigail25@adventure-works.com	$2y$10$U832guqsrfDtyT9HRxfc9.XuAUB455hxXry5OqaRM4FHSxjbiQptC	\N	\N
91	Trevor Bryant	5781 Sharon Dr.	trevor18@adventure-works.com	$2y$10$JZLCjKTgyvE8F9kJUpCw1OtB7rSUTM8yL3x1miE4.CAoWmhu/2W5G	\N	\N
92	Dalton Perez	6083 San Jose	dalton37@adventure-works.com	$2y$10$.EKtEqOYxWjv3JmdT8smv.oF1fTurTZWefUgfgs975cthjqB9otPO	\N	\N
93	Cheryl Diaz	7297 Kaywood Drive	cheryl4@adventure-works.com	$2y$10$i49FRuSmI68kT/qz2KRw2OofANVyRVU5CRiKOaLUR6H/1qTkvnofq	\N	\N
94	Aimee He	1833 Olympic Drive	aimee13@adventure-works.com	$2y$10$MwOSTYf3mLA9PtOdxc7iMeEg8N8FI35XDPHIi4O3GRlC0z0LlTJ/G	\N	\N
95	Cedric Ma	3407 Oak Brook Place	cedric15@adventure-works.com	$2y$10$m8dbuc4W8C8u2UuIwH5Z4u/PCbC66ZP6L/f/B3YGae/4mf.ngO0X2	\N	\N
96	Chad Kumar	1681 Lighthouse Way	chad9@adventure-works.com	$2y$10$ZS4tBZPXE6B3zEkXvdcL1eBPc3kzsohfntgOizdJ4/BuDoOKfy4qS	\N	\N
97	Andr├⌐s Anand	5423 Los Gatos Ct.	andr├⌐s18@adventure-works.com	$2y$10$GkfGKdHVzPIoxuFRvH/S0OnDSxgLXJp99W9DOog3uJGbhxNpccTea	\N	\N
98	Edwin Nara	719 William Way	edwin39@adventure-works.com	$2y$10$YQVykPIgg8lQ.z94Y1Y8weGE.lCS27qDDMzqlCK8KOAT9jGvpe/Hm	\N	\N
99	Mallory Rubio	6452 Harris Circle	mallory7@adventure-works.com	$2y$10$DHPY7c9gCtPNpRk7bTvk6.PItjVOa1iHf6Bi91aMSdfTqIbnOTKnW	\N	\N
100	Adam Ross	4378 Westminster Place	adam2@adventure-works.com	$2y$10$LFw/B8U591W9eFvk/GtrHOSaSuv1BGftyHhNWp.g4S7f2WdR9n3Ie	\N	\N
\.


--
-- Name: cart_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cart_items_id_seq', 1, false);


--
-- Name: carts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.carts_id_seq', 1, false);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_seq', 6, true);


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_id_seq', 23, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 7, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, false);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 100, true);


--
-- Name: cart_items cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- Name: cart_items cart_items_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.carts(id) ON DELETE CASCADE;


--
-- Name: cart_items cart_items_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.items(id) ON DELETE CASCADE;


--
-- Name: carts carts_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: items items_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_category_id_foreign FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: orders orders_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.carts(id) ON DELETE CASCADE;


--
-- Name: orders orders_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

