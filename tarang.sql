--
-- PostgreSQL database dump
--

\restrict aINVwy6lNJs1McfwNts9KKHnS0tIiQvEsFurn5dKMPaRcyGFuFjIzDgI9rZlXXh

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: blog_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blog_categories (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    slug character varying(150) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.blog_categories OWNER TO postgres;

--
-- Name: blog_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.blog_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.blog_categories_id_seq OWNER TO postgres;

--
-- Name: blog_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.blog_categories_id_seq OWNED BY public.blog_categories.id;


--
-- Name: blog_category_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blog_category_map (
    blog_id integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE public.blog_category_map OWNER TO postgres;

--
-- Name: blogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blogs (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    short_description text,
    content text NOT NULL,
    featured_image character varying(500),
    author_name character varying(150),
    meta_title character varying(255),
    meta_description text,
    meta_keywords text,
    canonical_url character varying(500),
    faqs jsonb DEFAULT '[]'::jsonb,
    status character varying(20) DEFAULT 'draft'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    featured_image_alt character varying(255)
);


ALTER TABLE public.blogs OWNER TO postgres;

--
-- Name: blogs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.blogs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.blogs_id_seq OWNER TO postgres;

--
-- Name: blogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.blogs_id_seq OWNED BY public.blogs.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contacts (
    id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(20),
    subject character varying(255),
    message text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.contacts OWNER TO postgres;

--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contacts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contacts_id_seq OWNER TO postgres;

--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contacts_id_seq OWNED BY public.contacts.id;


--
-- Name: images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.images (
    id integer NOT NULL,
    user_id text NOT NULL,
    url text NOT NULL,
    file_key text NOT NULL,
    title text,
    alt_text text,
    caption text,
    is_featured boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.images OWNER TO postgres;

--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.images_id_seq OWNER TO postgres;

--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.images_id_seq OWNED BY public.images.id;


--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refresh_tokens (
    id uuid NOT NULL,
    user_id uuid,
    token_hash text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    expires_at timestamp with time zone NOT NULL,
    is_revoked boolean DEFAULT false
);


ALTER TABLE public.refresh_tokens OWNER TO postgres;

--
-- Name: treatment_pages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.treatment_pages (
    id integer NOT NULL,
    title text,
    slug text,
    seo jsonb,
    data jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.treatment_pages OWNER TO postgres;

--
-- Name: treatment_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.treatment_pages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.treatment_pages_id_seq OWNER TO postgres;

--
-- Name: treatment_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.treatment_pages_id_seq OWNED BY public.treatment_pages.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_name text NOT NULL,
    user_email text NOT NULL,
    user_password text NOT NULL,
    role character varying(20) DEFAULT 'user'::character varying,
    last_login_at timestamp without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: blog_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_categories ALTER COLUMN id SET DEFAULT nextval('public.blog_categories_id_seq'::regclass);


--
-- Name: blogs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blogs ALTER COLUMN id SET DEFAULT nextval('public.blogs_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contacts ALTER COLUMN id SET DEFAULT nextval('public.contacts_id_seq'::regclass);


--
-- Name: images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.images ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);


--
-- Name: treatment_pages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.treatment_pages ALTER COLUMN id SET DEFAULT nextval('public.treatment_pages_id_seq'::regclass);


--
-- Data for Name: blog_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blog_categories (id, name, slug, description, created_at) FROM stdin;
39	Cancer	cancer	\N	2026-03-07 17:10:13.337616
\.


--
-- Data for Name: blog_category_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blog_category_map (blog_id, category_id) FROM stdin;
23	39
28	39
27	39
\.


--
-- Data for Name: blogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blogs (id, title, slug, short_description, content, featured_image, author_name, meta_title, meta_description, meta_keywords, canonical_url, faqs, status, created_at, updated_at, featured_image_alt) FROM stdin;
23	What is the main cause of liver cancer?	what-is-the-main-cause-of-liver-cancer		<p>Liver is a vital organ of our body which plays a major role in fat, protein and carbohydrate metabolic processes of our body. It helps in absorption of vital nutrients and elimination of the toxic waste. Liver has a significant cleansing action on blood that saves the body from the action of harmful bacteria. Liver also acts as a reservoir for storage of nutrients such as iron and vitamins. Apart from this, various substances that help in coagulation processes is also produced in the liver.</p><p>Given the importance of liver, it is notable to observe that liver cancer is the 5th&nbsp;most common cancer globally.</p><p>When an uncontrolled division of cancer cells occurs in the liver, the type of cells involved determine the classification of the cancer</p><ul><li><p><strong>Hepatocellular carcinoma</strong>– It is made of the liver tissue and is the most common type of liver cancer. It may develop as a single tumor or sometimes multiple small nodules spread throughout the liver.</p></li><li><p><strong>Intrahepatic Cholangiocarcinoma</strong>– It is the cancer of the bile duct that carries the bile from liver &amp; gall bladder to the intestines for easy digestion of fatty substances.</p></li></ul><p>When liver is not the only malignant site in a patient, it is important to determine whether liver is the&nbsp;<strong>Primary</strong>&nbsp;site or cancer from somewhere else has spread to liver making it&nbsp;<strong>secondary (metastatic) site</strong>&nbsp;of cancer.</p><p><strong><em>Who is most likely to get liver cancer?</em></strong></p><p>The definite cause of liver cancer has not been defined yet but there are several factors that have been found to have a direct association with malignant conditions of liver</p><ol><li><p>Prior conditions of liver: When the functioning of the liver is damaged due to several illnesses, the likelihood of developing a cancerous condition increases:<br>– Chronic Hepatitis B and Hepatitis C, and even Hepatitis D<br>– Liver cirrhosis<br>– Metabolic liver disease (particularly nonalcoholic fatty liver disease)<br>&nbsp;</p></li><li><p>Addiction to smoking or alcohol – Persistent alcohol consumption and smoking can damage the liver cells by inducing oxidative stress and inflammation that leads to liver cirrhosis over the years ultimately causing liver malignancy.<br>&nbsp;</p></li><li><p>Exposure to dietary toxins such as aflatoxins and aristolochic acid.<br>&nbsp;</p></li><li><p>Lifestyle – Though a direct correlation between our lifestyle and liver cancer has not been acknowledged yet but various studies have suggested the same. Unhealthy diet, inappropriate methodologies to manage stress, and inadequate dietary patterns consisting of high amounts of sugar, and preservative rich processed foods deplete the immune function gradually depriving the body of the nutritive elements that are required for a sustained living.</p></li></ol><p><strong><em>How do you feel when you have liver cancer?</em></strong></p><p>In those with early stage of liver cancer, the symptoms might not be present. In later stages, the following symptoms may be present due to impact on the liver:</p><ul><li><p>Pain in the abdomen with nausea, fever and unintended weight loss</p></li><li><p>Fullness in the abdomen</p></li><li><p>Loss of appetite</p></li><li><p>Jaundice (yellowing of skin and eyes)</p></li><li><p>Swelling on the abdomen</p></li></ul><p>If the liver tumor has affected other parts of the body, the following symptoms may also be observed:</p><ul><li><p>Increased level of calcium in the blood (hypocalcaemia)</p></li><li><p>Low blood sugar levels</p></li><li><p>Increased red blood cells count</p></li><li><p>High cholesterol levels</p></li></ul><p><strong>You can read more about liver cancer here:</strong><a target="_blank" rel="noopener noreferrer nofollow" href="https://bit.ly/3pwByWS"><strong><em>https://bit.ly/3pwByWS</em></strong></a></p><p><strong><em>Does liver cancer spread fast?</em></strong></p><p>Live cancer may spread to other parts of the body but mostly in advanced stages. The likelihood of metastasis is less in Hepatocellular carcinoma (HCC) whereas the probability is more in the rare types of liver cancers, Angiosarcoma and Hemangiosarcoma.</p><p>The most common sites of liver metastasis are<strong>bones and lungs.</strong></p><p><strong><em>What is the best way to treat liver cancer?</em></strong></p><p>When you visit an oncologist for liver cancer treatment, he may share various treatment options with you after consideration of the case details. These may be:</p><ul><li><p>Surgery – only tumors in early stages are eligible for surgery.</p></li><li><p>Chemotherapy – This treatment option is considered when the tumor is not resectable and other local treatments do not work.</p></li><li><p>Radiation – It is not the first choice of treatment but is opted for when surgery is contraindicated and other treatments have been proved infective</p></li><li><p>Chemoembolisation – This mode of treatment is adopted mainly when either the tumor size is larger than 5 cm or there are multiple tumors present.</p></li><li><p>Targeted Therapy – usually employed in metastatic cases as the drugs are directly injected into the bloodstream and is spread in the entire body.</p></li><li><p>Ablation – It is the destruction of the tumor without removing them. It is mostly done in tumors with size smaller than 3 cm.</p></li></ul><p>These treatments may be used in various combinations to achieve best results for the patients. But none of these treatments come without alternate effects.</p><p>A liver cancer patient has to suffer a lot as his weight, sleep and appetite are drastically affected especially in the advanced stages.</p><p>For such patients, a painless like immunotherapy can manage the symptoms effectively and help the patient relive the normal lifestyle.</p><p><strong><em>What is Immunotherapy?</em></strong></p><p>Immunotherapy is an alternative treatment for cancer that acts on the immune system and reinstates its function. The cellular action of immunotherapy helps boost the growth of the normal cells and restricting the proliferation of malignant ones.</p><p>When a treatment does not have side effects, it is one less thing to worry about. Also, immunotherapy helps the patient recover in a seamless gradual manner. The patient gains confidence as the treatment progresses due to positive effects of the treatment.</p><p><strong><em>You can hear about the effectiveness of this treatment from our patients here</em></strong></p>	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9Yw8Z0O9f0bFMlNLiC4qISXJ9gut7nUKOceBD8	Mr. Danish	What is the main cause of liver cancer? | Dr Tarang Krishna	Explore the main causes of liver cancer, including risk factors like hepatitis infections, alcohol use, and obesity. Learn how to reduce your risk and protect your liver health.		what-is-the-main-cause-of-liver-cancer	[]	published	2026-03-18 10:26:11.18994	2026-03-19 10:45:03.192713	What is the main cause of liver cancer?
28	Can Diet and Exercise Reverse Cancer?	can-diet-and-exercise-reverse-cancer		<p>Nutrition and exercise are two integral entities of our lifestyle that if not entirely, do ascertain our state of health to a great extent. Given their importance in health, these two aspects have to be given utmost importance in a diseased state. While the awareness of diet and exercise has grown exponentially since the last few decades, several stigmas still continue to haunt the cancer patients and survivors.</p><p>We have come up with a set of do’s and don’ts for you.</p><p>A healthful nutrition and lifestyle is a prerequisite for the prevention of cancer. So, if you are a cancer survivor, or you have a loved one dealing with cancer, you might want to read further. But even if you have nothing to do with cancer, following these guidelines may save you from facing the brunt of cancer in future.</p><h2><strong>Do’s</strong></h2><ul><li><p><strong>Include a majority of plant based foods in your diet</strong>Plant based foods are the primary sources of carbohydrates, proteins, vitamins, minerals as well as fibre. Have at least 8 – 10 servings of fruits (such as apples, bananas, pomegranate, kiwi) and vegetables (such as greenpeas, corn, lettuce, spinach, kale) per day. This will not only ensure your daily nutrient intake but also limit the cravings for processed foods and sugars. beans, vegetables, whole grains, nuts, and fruits.</p></li><li><p><strong>Limit sugar intake</strong>Sugar is often associated with an increased risk of cancer. This is due to the fact that excess sugar leads to a proportional increase in insulin (hormone that regulates sugar in the blood) that increases the cancerous activity in the body. Also, sugar can lead to weight gain and obesity and increase the risk of heart diseases, diabetes mellitus and increased cholesterol levels. Sugar is to be obtained from healthful sources such as vegetables, fruits, nuts, and whole grains.</p></li><li><p><strong>Avoid alcohol consumption</strong>Various studies have suggested that alcohol can increase the risk of various cancers such as oral, oesophageal, liver, stomach and breast cancer to name a few. Though no direct connection has been found between alcohol intake and cancer but excessive alcohol intake can hamper liver functioning. Liver being a vital organ of the body, thus its damage can hamper the health status of an individual to a great extent.</p></li><li><p><strong>Spend time in the sun</strong>Various research studies have suggested a correlation between Vitamin D and lowered risk of cancer especially colorectal cancer. Vitamin D is an essential micronutrient with major role in calcium metabolism, bone health and immune function. Your skin will be able to synthesise Vitamin D after an adequate exposure in the sun.</p></li><li><p><strong>Go easy on dairy products</strong></p></li></ul><h2><strong>Don’ts</strong></h2><p><strong>Do not take supplements to replenish your nutrient requirements</strong></p><p>It is not appropriate to stock on various types of supplements to ensure optimum nutrient intake. Rather, go for natural food products such as fruits, vegetables, and nuts, legumes that contain ample amount of antioxidants, polyphenols and micronutrients required for a healthy you. Even if you are planning to take some supplements, always consult your physician before taking <a target="_blank" rel="noopener noreferrer nofollow" href="http://them.Do">them.<strong>Do</strong></a><strong> not consume refined grains, flours and sugars</strong></p><p>Several studies have suggested that an intake of refined grains and flours is associated with cancer recurrence and less survival rate. The reason for the same is that these are devoid of the vitamins and minerals that are present in the unrefined grains. The nutritional content of refined grains is almost nil making them a non viable option especially for cancer <a target="_blank" rel="noopener noreferrer nofollow" href="http://patients.Do">patients.<strong>Do</strong></a><strong> not replace whole foods with juices</strong></p><p>Juices can be included as a part of our dietary regime if you are already having 8 – 9 servings of fruits and vegetables per day. Juice cannot replace the whole foods as they limit the fibre intake that is extremely important. Soluble fibres present in oats lower the cholesterol level, thereby lowering the risk of heart diseases whereas as insoluble fibre (cellulose) present in various fruits &amp; vegetables ease the bowel <a target="_blank" rel="noopener noreferrer nofollow" href="http://function.Do">function.<strong>Do</strong></a><strong> not overeat forcefully</strong></p><p>There is a common tendency for the family to force the patients to eat even when they have nausea or severe loss of appetite. In such cases, take small portions of nutrient dense foods that would furnish the nutrient needs. There are some fortified foods available that can also be considered. It is always wise to take a nutrition consultation for an appropriate guidance.</p><p>Though these are general guidelines for a cancer patient but as every patient is different, the dietary needs may also tend to differ. It is recommended to consult a nutritionist in order to obtain the individualized dietary recommendations. Likewise, not every person dealing with cancer can indulge in regular exercise or physical activity. These tips might prove useful:</p><ul><li><p>If you are unable to swallow solids comfortably, go ahead and blend in that mixture of vegetables.</p></li><li><p>Opt for light meals at regular intervals spread throughout the day instead of heavy meals at one time.</p></li><li><p>If you are unable to exercise, take a walk. If even that is not possible, do the maximum physical activity you can do. Push your limit every day.</p></li><li><p>Make sure to consume more protein (milk, cheese and eggs) as it is important when you have cancer.</p></li></ul><p>Even if you are on a cancer treatment or are too weak to follow every guideline judiciously, do not worry. The key is to stick to the basics and avoid the food products that can hamper your health. A simple walk once a day is also sufficient. You and your physician have to work as a team and customize your health plan according to your needs and physical status.</p><p>Keep yourself motivated, there is always hope for better days ahead.</p><p>After all, your health is in your <a target="_blank" rel="noopener noreferrer nofollow" href="http://hands.Do">hands.<strong>Do</strong></a><strong> not just overcome cancer, defeat cancer with all your might!</strong></p>	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YSoYYrasHyD5dCawqV4S3XTU0KgPQf1tvhANo	Mr. Danish	Can Diet and Exercise Reverse Cancer? | Dr Tarang Krishna\r\n	Learn how diet and exercise can play a role in cancer prevention and management. Explore the evidence on whether lifestyle changes can help reverse cancer progressio\r\n		blogs/can-diet-and-exercise-reverse-cancer	[]	published	2026-03-20 15:28:09.080181	2026-03-20 15:28:09.080181	Can Diet and Exercise Reverse Cancer?
27	How do you stay positive when sick?	how-do-you-stay-positive-when-sick	Whenever we are down with fever, flu or seasonal allergies, we most often feel very irritated and out of place. We do not feel like working, we just want to lie down comfortably in our bed and do nothing but taking rest. But imagine a person diagnosed with cancer. Cancer is not an illness that will get over in a few days. How a cancer patient must be feeling with a part of him always doubtful that he will survive or not?		https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YbdGCAZRE1DV6esv4KiIAxCZGfPuWgYzhXdN7	Mr. Danish	How do you stay positive when sick? | Dr Tarang Krishna\r\n	Discover practical tips to stay positive when sick. Learn how to manage stress, boost your mood, and focus on recovery with a hopeful mindset.\r\n		how-do-you-stay-positive-when-sick	[]	published	2026-03-19 16:28:35.22259	2026-03-20 15:28:23.518716	How do you stay positive when sick?
\.


--
-- Data for Name: contacts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contacts (id, full_name, email, phone, subject, message, created_at) FROM stdin;
3	Rahul Sharma	rahul.sharma@gmail.com	9876543210	Website Inquiry	Hello, I want to know more about your services.	2026-03-18 16:36:40.200846
5	Rahul Sharma	rahul.sharma@gmail.com	9876543210	Website Inquiry	Hello, I want to know more about your services.	2026-03-18 16:43:50.291698
\.


--
-- Data for Name: images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.images (id, user_id, url, file_key, title, alt_text, caption, is_featured, created_at, updated_at) FROM stdin;
46	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YbdGCAZRE1DV6esv4KiIAxCZGfPuWgYzhXdN7	1ZWHDSxidA9YbdGCAZRE1DV6esv4KiIAxCZGfPuWgYzhXdN7			smiley-strong-woman-fighting-breast-cancer.jpg	f	2026-03-19 16:28:02.477284	2026-03-19 16:28:02.477284
49	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YpVgAeuBqZKEug9iLlkABPUIpzWQ40MdCYD6w	1ZWHDSxidA9YpVgAeuBqZKEug9iLlkABPUIpzWQ40MdCYD6w			Rectangle (51).webp	f	2026-03-20 10:31:33.522362	2026-03-20 10:31:33.522362
50	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YcGBCBb8aCtTy7K15dWug2neG8wvbsQVc4YAj	1ZWHDSxidA9YcGBCBb8aCtTy7K15dWug2neG8wvbsQVc4YAj			Rectangle (43).webp	f	2026-03-20 10:39:34.414446	2026-03-20 10:39:34.414446
51	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YJVs1yKvvHR3yhOlcsfZ7abkqYiCF92I6nuzP	1ZWHDSxidA9YJVs1yKvvHR3yhOlcsfZ7abkqYiCF92I6nuzP			Rectangle (54).webp	f	2026-03-20 11:23:24.356327	2026-03-20 11:23:24.356327
40	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9Ydg4YE3elspZfYOIaKMuwFkq5dzVogteWvChN	1ZWHDSxidA9Ydg4YE3elspZfYOIaKMuwFkq5dzVogteWvChN			Rectangle (59).webp	f	2026-03-18 15:05:35.321952	2026-03-18 15:05:35.321952
41	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9Yw8Z0O9f0bFMlNLiC4qISXJ9gut7nUKOceBD8	1ZWHDSxidA9Yw8Z0O9f0bFMlNLiC4qISXJ9gut7nUKOceBD8			Rectangle 26 (2).png	f	2026-03-18 15:10:41.538681	2026-03-18 15:10:41.538681
39	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9Y0KOhIZbjsVaqDPdxCGTgbnX34Fc1kiHvtKpO	1ZWHDSxidA9Y0KOhIZbjsVaqDPdxCGTgbnX34Fc1kiHvtKpO	vcxvcx	vcvcxv	Subtract (4).webp	f	2026-03-18 15:01:30.307358	2026-03-18 15:49:44.858976
44	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YpHK07gBqZKEug9iLlkABPUIpzWQ40MdCYD6w	1ZWHDSxidA9YpHK07gBqZKEug9iLlkABPUIpzWQ40MdCYD6w			Rectangle (60).webp	f	2026-03-19 12:54:45.865085	2026-03-19 12:54:45.865085
58	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9Ybffm95RE1DV6esv4KiIAxCZGfPuWgYzhXdN7	1ZWHDSxidA9Ybffm95RE1DV6esv4KiIAxCZGfPuWgYzhXdN7			Rectangle 36 (9).png	f	2026-03-20 12:43:26.434682	2026-03-20 12:43:26.434682
60	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YRK3SWK64kpZznvSUmy6w8Y7crA9lfgNFtesh	1ZWHDSxidA9YRK3SWK64kpZznvSUmy6w8Y7crA9lfgNFtesh			dr-tarang-krishna.webp	f	2026-03-20 14:57:48.548285	2026-03-20 14:57:48.548285
61	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YFdyF5Gi1qoTClgzhVmntUBcv4ZJx3Qd7w59S	1ZWHDSxidA9YFdyF5Gi1qoTClgzhVmntUBcv4ZJx3Qd7w59S			Rectangle (61).webp	f	2026-03-20 14:58:31.249237	2026-03-20 14:58:31.249237
62	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YhQ96Dyqwq931zMrI7N8XbUGnZERQsOYCjW42	1ZWHDSxidA9YhQ96Dyqwq931zMrI7N8XbUGnZERQsOYCjW42			treatment1.webp	f	2026-03-20 15:03:58.231926	2026-03-20 15:03:58.231926
63	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9Y5pgzezfMN9LnEyKzqpsluZgAS8J7hBjMUeF3	1ZWHDSxidA9Y5pgzezfMN9LnEyKzqpsluZgAS8J7hBjMUeF3			treatment2.webp	f	2026-03-20 15:04:20.669207	2026-03-20 15:04:20.669207
64	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9Y2A0JSLCg0ROVn3QY5cmuFzDU6NHqAZexf1B8	1ZWHDSxidA9Y2A0JSLCg0ROVn3QY5cmuFzDU6NHqAZexf1B8			tr.webp	f	2026-03-20 15:19:41.303415	2026-03-20 15:19:41.303415
65	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YwPGvsBf0bFMlNLiC4qISXJ9gut7nUKOceBD8	1ZWHDSxidA9YwPGvsBf0bFMlNLiC4qISXJ9gut7nUKOceBD8			e1ad5596d1592b4279ff6f2a832fe02ffb841433.webp	f	2026-03-20 15:19:48.34321	2026-03-20 15:19:48.34321
67	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YY5pF1fncIgwZrjyfLTkbnthX7ClO4mouUQea	1ZWHDSxidA9YY5pF1fncIgwZrjyfLTkbnthX7ClO4mouUQea			a1e085d988ce64b08d9c215a8270868f70f36dcd.webp	f	2026-03-20 15:20:20.886422	2026-03-20 15:20:20.886422
69	558c0b80-fa5b-499a-849f-6617ca50ab18	https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YSoYYrasHyD5dCawqV4S3XTU0KgPQf1tvhANo	1ZWHDSxidA9YSoYYrasHyD5dCawqV4S3XTU0KgPQf1tvhANo			image-6.png	f	2026-03-20 15:27:49.624799	2026-03-20 15:27:49.624799
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_tokens (id, user_id, token_hash, created_at, expires_at, is_revoked) FROM stdin;
7c8e63b0-fd0b-49b4-9181-e8d9fbf2dfd8	558c0b80-fa5b-499a-849f-6617ca50ab18	5f18bd8748d84484706c3817bd30e68ca219d2192f1c020c183b8179255f17a5	2026-03-18 17:20:48.379248	2026-03-25 17:20:48.379248+05:30	f
51e17416-1c2f-4b52-8a30-5bc848bc7ce6	558c0b80-fa5b-499a-849f-6617ca50ab18	492e3e8082f7923b06ea1d315d4f6b8cf79452469fc60458249d021d37cd83d9	2026-02-25 16:54:28.15838	2026-03-04 16:54:28.15838+05:30	f
b8687b36-3a91-41bf-85b2-a6917d3117aa	558c0b80-fa5b-499a-849f-6617ca50ab18	b3862631af87c63de1998c42efee98e54bff1a08d1ee48d22e4ace1071187c46	2026-03-19 10:32:33.24482	2026-03-26 10:32:33.24482+05:30	f
1be45569-491d-405b-9725-ed4f7b430c54	558c0b80-fa5b-499a-849f-6617ca50ab18	de3a9733af418b32e65021b2c35eb402a2f30b9e85162fa9d0b02ca0ebfbd0aa	2026-03-06 16:29:28.908471	2026-03-13 16:29:28.908471+05:30	f
b51078df-7b6f-452c-b540-0c004f37833b	558c0b80-fa5b-499a-849f-6617ca50ab18	64ffcf0366c0c06ec3cecb9f477a6a64411becaa0d5796fa7843619ac6ad68ac	2026-03-19 16:42:32.784665	2026-03-26 16:42:32.784665+05:30	f
15a76d6e-0195-4f41-9a7b-442653c4c615	558c0b80-fa5b-499a-849f-6617ca50ab18	f5b257fb559fe0b1a9af5177a201db8c0b559fde06869e365089f756b17828e6	2026-03-20 16:18:37.290512	2026-03-27 16:18:37.290512+05:30	f
94dcbbac-c937-49c5-ad25-401fc3b647b8	558c0b80-fa5b-499a-849f-6617ca50ab18	808c189e91d0e921ea98a6fba76e350ab51e5c78c61fa7e478372862b3c1233c	2026-03-07 17:07:30.285952	2026-03-14 17:07:30.285952+05:30	f
5fd106ee-4a22-40c0-8138-d819da4a40a7	e038b7d3-7aba-494f-bfa6-ef3c8e58996d	3959b18a7f2fd2e6f1deb9f4fc6527d706714db8f2b49a93aa3b5dd13cacb9a5	2026-03-17 12:44:29.359001	2026-03-24 12:44:29.359001+05:30	f
812a0ad0-7a85-44d8-861b-f4cb062c8742	558c0b80-fa5b-499a-849f-6617ca50ab18	c61c5f51f60ea32f8f49be66b21919518eb89dc487bcb09745f6445e9e656b8a	2026-02-24 15:12:46.480167	2026-03-03 15:12:46.480167+05:30	f
2f3559d5-afea-4ee2-a314-2c0c5b75d42b	558c0b80-fa5b-499a-849f-6617ca50ab18	5a1fdd284812f53a7a7be73ec0695a77f00c7f00d726b56419c7aeb4d3de66d2	2026-02-24 16:03:55.573579	2026-03-03 16:03:55.573579+05:30	f
9e366d06-ae45-44f7-9c56-e8b0eef68ede	558c0b80-fa5b-499a-849f-6617ca50ab18	bf94da6cc0b0f5d9eb1e815960f660a50c77ceca8dcdf94037595a85e542df9b	2026-02-24 16:29:47.978676	2026-03-03 16:29:47.978676+05:30	f
\.


--
-- Data for Name: treatment_pages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.treatment_pages (id, title, slug, seo, data, created_at, updated_at) FROM stdin;
8	Blood Cancer	blood-cancer-treatment	{"title": "Blood Cancer Treatment in India", "keywords": "", "canonical": "cancer-type-and-treatment-page/blood-cancer-treatment", "description": "A diagnosis of blood cancer can be deeply unsettling, especially because it affects the body’s ability to produce healthy blood cells and defend against infection. Blood cancer originates in blood-forming tissues, such as the bone marrow or lymphatic system, rather than in a solid organ"}	{"faq": {"items": [{"answer": "Early symptoms may include fatigue, frequent infections, unexplained weight loss, and easy bruising.", "question": "What are the early symptoms of blood cancer?"}, {"answer": "Early symptoms may include fatigue, frequent infections, unexplained weight loss, and easy bruising.", "question": "What causes blood cancer?"}], "maintitle": "Frequently Asked Questions About Blood Cancer"}, "intro": {"fileKey": "1ZWHDSxidA9YRK3SWK64kpZznvSUmy6w8Y7crA9lfgNFtesh", "introimage": "https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YRK3SWK64kpZznvSUmy6w8Y7crA9lfgNFtesh", "introtitle": "Blood Cancer Treatment in India", "introbtnurl": "contact", "introcontent": "<h6>Driven by Purpose, Impact &amp; Service</h6><p></p><p>A diagnosis of blood cancer can be deeply unsettling, especially because it affects the body’s ability to produce healthy blood cells and defend against infection. Blood cancer originates in blood-forming tissues, such as the bone marrow or lymphatic system, rather than in a solid organ</p><p></p><p>Alongside standard medical treatments like chemotherapy or targeted therapy, many patients explore complementary and alternative medicine (CAM) approaches as supportive care to improve strength, immunity, and overall wellbeing.<br><br><strong>Diagnosed with blood cancer? Dr. Tarang offers personalised, integrative treatment planning grounded in clinical oncology experience.</strong><br></p><p></p>"}, "breadcrumb": {"fileKey": "1ZWHDSxidA9YFdyF5Gi1qoTClgzhVmntUBcv4ZJx3Qd7w59S", "breadimage": "https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YFdyF5Gi1qoTClgzhVmntUBcv4ZJx3Qd7w59S", "breadtitle": "Blood Cancer"}, "calltoaction": {"desc": "Every blood cancer case is unique. With experience in integrative oncology and personalised cancer planning, Dr. Tarang helps patients understand their diagnosis and treatment pathways clearly and confidently.", "title": "Blood Cancer Treatment", "btnurl": "contact", "btnname": "Schedule a Cancer Care Consultation"}, "cancerCurable": {"items": [{"title": "National and Global Statistics", "content": "<ul><li><p>In India, blood cancers (including leukaemia, lymphoma, and myeloma) represent a significant portion of all cancer cases. Recent cancer registry data shows that leukaemia alone accounts for roughly 6% of all new cancer cases in the country.</p></li><li><p>Globally, blood cancers are among the most common types of cancer in children and young adults, and survival rates have improved markedly over the past decades due to advances in treatment and supportive care.</p></li></ul><p></p>"}, {"title": "Curability Insights", "content": "<ul><li><p>Some types of blood cancer can be cured, especially when diagnosed early and treated promptly.</p></li><li><p>Others may not be completely curable but can often be controlled for many years, with patients living long and meaningful lives with appropriate care.</p></li><li><p>Remission, where signs and symptoms of cancer are reduced or disappear, is achievable for many patients.</p></li></ul><p></p>"}], "maindesc": "Many patients ask if blood cancer is curable, and the answer depends on many factors, including the type of blood cancer, its stage at diagnosis, and how it responds to treatment.", "mainnote": "It is important to discuss prognosis and treatment goals with an oncologist, as outcomes vary widely based on individual circumstances.", "maintitle": "Is Blood Cancer Curable?"}, "treatmentCards": {"cards": [{"fileKey": "1ZWHDSxidA9Y2A0JSLCg0ROVn3QY5cmuFzDU6NHqAZexf1B8", "treatmentcardimage": "https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9Y2A0JSLCg0ROVn3QY5cmuFzDU6NHqAZexf1B8", "treatmentcardtitle": "Leukaemia", "treatmentcardcontent": "Leukaemia begins in the bone marrow and leads to uncontrolled production of abnormal white blood cells. These cells interfere with normal blood cell production."}, {"fileKey": "1ZWHDSxidA9YwPGvsBf0bFMlNLiC4qISXJ9gut7nUKOceBD8", "treatmentcardimage": "https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YwPGvsBf0bFMlNLiC4qISXJ9gut7nUKOceBD8", "treatmentcardtitle": "Lymphoma", "treatmentcardcontent": "Lymphoma develops in the lymphatic system, which is part of the immune system. It often presents with enlarged lymph nodes and an impaired immune response."}, {"fileKey": "1ZWHDSxidA9YY5pF1fncIgwZrjyfLTkbnthX7ClO4mouUQea", "treatmentcardimage": "https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YY5pF1fncIgwZrjyfLTkbnthX7ClO4mouUQea", "treatmentcardtitle": "Multiple Myeloma", "treatmentcardcontent": "Multiple myeloma originates in plasma cells, a type of white blood cell responsible for producing antibodies. This can weaken bones, disrupt immune function, and affect kidney health."}], "maintreatmentcardtitle": "Types of Blood Cancer", "maintreatmentcardcontent": "Blood cancer is not a single disease but a group of related cancers affecting different kinds of blood cells."}, "treatmentDetails": [{"fileKey": "1ZWHDSxidA9YhQ96Dyqwq931zMrI7N8XbUGnZERQsOYCjW42", "treatmentimage": "https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9YhQ96Dyqwq931zMrI7N8XbUGnZERQsOYCjW42", "treatmenttitle": "Understanding Cancer Treatment", "treatmentcontent": "<p>'Cancer treatment' refers to the medical strategies used to control, remove, or destroy cancer cells. The treatment of cancer is never one size fits all. It is personalised based on:</p><p></p><ul><li><p>Type of cancer</p></li><li><p>Stage of disease</p></li><li><p>Patient age and overall health</p></li><li><p>Molecular and genetic characteristics</p></li><li><p>Previous treatments, if any<br></p></li></ul><p>The goal may be curative, disease-controlling, or symptom-focused depending on the clinical situation.<br><br>When patients search for the best cancer treatment in India, what they truly need is structured planning, accurate staging, and a coordinated treatment roadmap.</p>", "treatmentreverse": false}, {"fileKey": "1ZWHDSxidA9Y5pgzezfMN9LnEyKzqpsluZgAS8J7hBjMUeF3", "treatmentimage": "https://n9aid9d4s8.ufs.sh/f/1ZWHDSxidA9Y5pgzezfMN9LnEyKzqpsluZgAS8J7hBjMUeF3", "treatmenttitle": "Latest Cancer Treatment Advances", "treatmentbtnurl": "", "treatmentcontent": "<p>The landscape of cancer treatment in India has evolved rapidly recently. Advances in oncology now allow treatment plans to be tailored more precisely to each patient’s disease biology and overall health.<br><br>Patients today may benefit from:</p><p></p><ul><li><p>Molecular profiling that helps doctors select targeted therapies</p></li></ul><ul><li><p>Precision radiation techniques that minimize damage to healthy tissue</p></li><li><p>Organ-preserving surgical approaches in appropriate cases</p></li><li><p>Immunotherapy and targeted therapy combinations for certain cancers</p></li><li><p>Advanced treatments for blood cancers, including cellular therapies<br></p></li></ul><p>Alongside these medical advances, there is growing recognition of the role of integrative supportive care. Approaches that support immunity, nutrition, stress management, and overall wellbeing can help patients maintain strength and resilience during treatment.</p><p></p><p>The latest cancer treatment does not replace established therapies. Instead, the combination of evidence-based medical treatment and patient-specific supportive care yields the best outcomes.</p><p></p>", "treatmentreverse": false}]}	2026-03-20 14:58:37.561418	2026-03-20 16:33:15.46295
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, user_name, user_email, user_password, role, last_login_at) FROM stdin;
e038b7d3-7aba-494f-bfa6-ef3c8e58996d	Danish	danish@healthus.ai	$2b$10$JJk45ysv5k1eDmBO36kZR.yV6qApMxXrFZeiwVhx5Cjq7DHRZ68UG	admin	\N
558c0b80-fa5b-499a-849f-6617ca50ab18	Mr. Danish	s.danish0827@gmail.com	$2b$10$JJk45ysv5k1eDmBO36kZR.yV6qApMxXrFZeiwVhx5Cjq7DHRZ68UG	admin	\N
\.


--
-- Name: blog_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.blog_categories_id_seq', 39, true);


--
-- Name: blogs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.blogs_id_seq', 28, true);


--
-- Name: contacts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contacts_id_seq', 5, true);


--
-- Name: images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.images_id_seq', 69, true);


--
-- Name: treatment_pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.treatment_pages_id_seq', 8, true);


--
-- Name: blog_categories blog_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_categories
    ADD CONSTRAINT blog_categories_pkey PRIMARY KEY (id);


--
-- Name: blog_categories blog_categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_categories
    ADD CONSTRAINT blog_categories_slug_key UNIQUE (slug);


--
-- Name: blog_category_map blog_category_map_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_category_map
    ADD CONSTRAINT blog_category_map_pkey PRIMARY KEY (blog_id, category_id);


--
-- Name: blogs blogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blogs
    ADD CONSTRAINT blogs_pkey PRIMARY KEY (id);


--
-- Name: blogs blogs_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blogs
    ADD CONSTRAINT blogs_slug_key UNIQUE (slug);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: treatment_pages treatment_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.treatment_pages
    ADD CONSTRAINT treatment_pages_pkey PRIMARY KEY (id);


--
-- Name: treatment_pages treatment_pages_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.treatment_pages
    ADD CONSTRAINT treatment_pages_slug_key UNIQUE (slug);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_user_email_key UNIQUE (user_email);


--
-- Name: idx_blog_category_blog_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_blog_category_blog_id ON public.blog_category_map USING btree (blog_id);


--
-- Name: idx_blog_category_category_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_blog_category_category_id ON public.blog_category_map USING btree (category_id);


--
-- Name: blog_category_map blog_category_map_blog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_category_map
    ADD CONSTRAINT blog_category_map_blog_id_fkey FOREIGN KEY (blog_id) REFERENCES public.blogs(id) ON DELETE CASCADE;


--
-- Name: blog_category_map blog_category_map_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_category_map
    ADD CONSTRAINT blog_category_map_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.blog_categories(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict aINVwy6lNJs1McfwNts9KKHnS0tIiQvEsFurn5dKMPaRcyGFuFjIzDgI9rZlXXh

