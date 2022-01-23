#%%
### Import libraries
import psycopg2
#%%
### Establish connection to PostgreSQL Server and Create Database:
try:    
    conn = psycopg2.connect(
        database = "postgres",
        user = "postgres",
        password = "MounT@inM@n1992",
        host = "localhost",
        port = "5433"
    )

    conn.autocommit = True 

    cur = conn.cursor()

    ### Create the Database:
    sql = """
    CREATE database "CBI"
    """

    cur.execute(sql)

    cur.close()
except psycopg2.errors.DuplicateDatabase:
    print("Database Already Exists!")
# %%
### Establish PostgreSQL Connection to new database and Create Tables:
conn = psycopg2.connect(
    database = "CBI",
    user = "postgres",
    password = "MounT@inM@n1992",
    host = "localhost",
    port = "5433"
)

cur = conn.cursor()

### Create taxi_trips Table:

sql_taxi_trips ="""
CREATE TABLE IF NOT EXISTS public.taxi_trips
(
    trip_id character varying(50) COLLATE pg_catalog."default" NOT NULL,
    pickup_community_area smallint NOT NULL,
    dropoff_community_area smallint NOT NULL,
    trip_start_timestamp timestamp with time zone NOT NULL,
    trip_end_timestamp timestamp with time zone NOT NULL,
    pickup_centroid_latitude numeric NOT NULL,
    pickup_centroid_longitude numeric NOT NULL,
    dropoff_centroid_latitude numeric NOT NULL,
    dropoff_centroid_longitude numeric NOT NULL,
    trip_miles numeric NOT NULL,
    CONSTRAINT taxi_trips_pkey PRIMARY KEY (trip_id)
)

TABLESPACE pg_default;

ALTER TABLE public.taxi_trips
    OWNER to postgres;
"""

sql_taxi_trips_info="""
CREATE TABLE IF NOT EXISTS public.taxi_trips_info
(
    trip_id character varying(50) COLLATE pg_catalog."default" NOT NULL,
    pickup_community_area smallint NOT NULL,
    dropoff_community_area smallint NOT NULL,
    trip_start_timestamp timestamp with time zone NOT NULL,
    trip_end_timestamp timestamp with time zone NOT NULL,
    pickup_centroid_latitude numeric NOT NULL,
    pickup_centroid_longitude numeric NOT NULL,
    dropoff_centroid_latitude numeric NOT NULL,
    dropoff_centroid_longitude numeric NOT NULL,
    trip_miles numeric NOT NULL,
    pickup_community character varying(50) COLLATE pg_catalog."default" NOT NULL,
    dropoff_community character varying(50) COLLATE pg_catalog."default" NOT NULL,
    pickup_zip integer NOT NULL,
    dropoff_zip integer NOT NULL,
    CONSTRAINT taxi_trips_info_pkey PRIMARY KEY (trip_id)
)

TABLESPACE pg_default;

ALTER TABLE public.taxi_trips_info
    OWNER to postgres;
"""

sql_tnp_trips = """
CREATE TABLE IF NOT EXISTS public.tnp_trips
(
    trip_id character varying(50) COLLATE pg_catalog."default" NOT NULL,
    pickup_community_area smallint NOT NULL,
    dropoff_community_area smallint NOT NULL,
    trip_start_timestamp timestamp with time zone NOT NULL,
    trip_end_timestamp timestamp with time zone NOT NULL,
    pickup_centroid_latitude numeric NOT NULL,
    pickup_centroid_longitude numeric NOT NULL,
    dropoff_centroid_latitude numeric NOT NULL,
    dropoff_centroid_longitude numeric NOT NULL,
    trip_miles numeric NOT NULL,
    CONSTRAINT tnp_trips_pkey PRIMARY KEY (trip_id)
)

TABLESPACE pg_default;

ALTER TABLE public.tnp_trips
    OWNER to postgres;
"""

sql_soc_data = """
CREATE TABLE IF NOT EXISTS public.socio_economic_data
(
    ca smallint NOT NULL,
    community_area_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    percent_aged_16_unemployed numeric NOT NULL,
    per_capita_income_ integer NOT NULL,
    percent_households_below_poverty numeric NOT NULL,
    CONSTRAINT socio_economic_data_pkey PRIMARY KEY (ca)
)

TABLESPACE pg_default;

ALTER TABLE public.socio_economic_data
    OWNER to postgres;
"""

sql_cov_zip = '''
CREATE TABLE IF NOT EXISTS public.covid_19_by_zip
(
    zip_code integer NOT NULL,
    week_start date NOT NULL,
    cases_weekly numeric NOT NULL,
    percent_tested_positive_weekly numeric NOT NULL,
    zip_code_week_start character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT covid_19_by_zip_pkey PRIMARY KEY (zip_code_week_start)
)

TABLESPACE pg_default;

ALTER TABLE public.covid_19_by_zip
    OWNER to postgres;
'''

sql_com_areas = """
CREATE TABLE IF NOT EXISTS public.community_areas
(
    community_area_number smallint NOT NULL,
    community character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT community_areas_pkey PRIMARY KEY (community_area_number)
)

TABLESPACE pg_default;

ALTER TABLE public.community_areas
    OWNER to postgres;
"""

sql_ccvi = """
CREATE TABLE IF NOT EXISTS public.ccvi
(
    community_area_or_zip smallint NOT NULL,
    ccvi_score numeric NOT NULL,
    ccvi_category character varying(10) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT ccvi_pkey PRIMARY KEY (community_area_or_zip)
)

TABLESPACE pg_default;

ALTER TABLE public.ccvi
    OWNER to postgres;
"""

sql_permits ="""
CREATE TABLE IF NOT EXISTS public.building_permits
(
    permit_ integer NOT NULL,
    permit_type character varying(50) COLLATE pg_catalog."default" NOT NULL,
    community_area smallint NOT NULL,
    issue_date date NOT NULL,
    reported_cost numeric NOT NULL,
    CONSTRAINT building_permits_pkey PRIMARY KEY (permit_)
)

TABLESPACE pg_default;

ALTER TABLE public.building_permits
    OWNER to postgres;
"""

sql_all_trip = """
CREATE TABLE IF NOT EXISTS public.all_trip_info
(
    trip_id character varying(50) COLLATE pg_catalog."default" NOT NULL,
    pickup_community_area smallint NOT NULL,
    dropoff_community_area smallint NOT NULL,
    trip_start_timestamp timestamp with time zone NOT NULL,
    trip_end_timestamp timestamp with time zone NOT NULL,
    pickup_centroid_latitude numeric NOT NULL,
    pickup_centroid_longitude numeric NOT NULL,
    dropoff_centroid_latitude numeric NOT NULL,
    dropoff_centroid_longitude numeric NOT NULL,
    trip_miles numeric NOT NULL,
    pickup_community character varying(50) COLLATE pg_catalog."default" NOT NULL,
    dropoff_community character varying(50) COLLATE pg_catalog."default" NOT NULL,
    pickup_zip integer NOT NULL,
    dropoff_zip integer NOT NULL,
    CONSTRAINT all_trip_info_pkey PRIMARY KEY (trip_id)
)

TABLESPACE pg_default;

ALTER TABLE public.all_trip_info
    OWNER to postgres;
"""

commands = (sql_taxi_trips,sql_taxi_trips_info,sql_tnp_trips,
            sql_soc_data,sql_cov_zip,sql_com_areas,sql_ccvi,
            sql_permits,sql_all_trip)

for command in commands:
    cur.execute(command)

cur.close()
conn.commit()
conn.close()