### This file will run all queires on the data.cityofchicago.org website/API and write all of the data to a PostgreSQL DB
#%%
### Imoprt Libraries
import psycopg2
import pandas as pd
import datetime
from sodapy import Socrata
import logging
import json
import sys
from shapely.geometry import shape, Point
import time

#%%
### First set up API Connection to data.cityofchicago.org

### First set up the API Loggin Information:

MyAppToken = "nfYJdXEGYjJcd4zmD0pKW5f4b"
username = "michaelsoukup2021@u.northwestern.edu"
password = "MounT@inM@n1992"
source = "data.cityofchicago.org"
timeout = 600

### Call out API Keys for each database to access:
taxi_code = "wrvz-psew"
network_provider_code = "m6dm-c72p"
covid_zip_code = "yhhz-zm2v"
ccvi_code = "xhc6-88s9"
building_permits_code = "ydr8-5enu"
socio_code = "kn9c-c2s2"
zip_boundary_code = 'unjd-c2ca'

### Set up day period for adding new data:
today = datetime.date.today()
delta = 35
time_delta = datetime.timedelta(delta)
day = str(today-time_delta)

### Next set up the API Client to access the data:
client = Socrata(source,
                 MyAppToken,
                 username=username,
                 password=password,
                 timeout = timeout)

#%%
### Call all new data via repeating loop to keep database up to date.
while True:
    print("Covid Data")
    ### Execute SoQL Query for selected rows and columns:
    data_covid = client.get_all(covid_zip_code,
                                select = "zip_code, week_start, cases_weekly, percent_tested_positive_weekly",
                                where = "week_start >= '{}'".format(day),
                                order = "week_start DESC",
                                limit = 10000)

    df_covid = pd.DataFrame(data=data_covid).dropna()
    df_covid = df_covid[df_covid['zip_code'] != 'Unknown']
    df_covid.reset_index(inplace=True)
    df_covid['zip_code_week_start'] = df_covid['zip_code']+' '+df_covid['week_start']

    ### Insert data into Covid database:
    conn = psycopg2.connect(
        host='localhost',
        database = 'CBI',
        user='postgres',
        password="MounT@inM@n1992",
        port = '5433'
    )

    sql = """
    INSERT INTO covid_19_by_zip (zip_code, week_start, cases_weekly, percent_tested_positive_weekly, zip_code_week_start)
    VALUES (%s,%s,%s,%s,%s)
    """
    while True:
        try:
            cur = conn.cursor()
            for index, row in df_covid.iterrows():
                values = (int(row['zip_code']),
                        row['week_start'][0:10],
                        float(row['cases_weekly']),
                        float(row['percent_tested_positive_weekly']),
                        row['zip_code_week_start'][0:16])
                cur.execute(sql, values)
                conn.commit()
            break
        except:
            print("Oops!", sys.exc_info()[0],"occurred.")
            break
    cur.close()

    ### Set up DataBase for Taxi-Trips Data 
    print("taxi data")
    data_taxi = client.get(taxi_code,
                        select = """trip_id, pickup_community_area, dropoff_community_area, 
                                    trip_start_timestamp, trip_end_timestamp, pickup_centroid_latitude,
                                    pickup_centroid_longitude, dropoff_centroid_latitude,
                                    dropoff_centroid_longitude, trip_miles""",
                        where = "trip_start_timestamp >= '{}'".format(day),
                        order = "trip_start_timestamp DESC",
                        limit = 10000)
    df_taxi = pd.DataFrame(data = data_taxi).dropna()
    df_taxi.reset_index(inplace = True)

    ### Insert data to database:
    conn = psycopg2.connect(
        host='localhost',
        database = 'CBI',
        user='postgres',
        password="MounT@inM@n1992",
        port = '5433'
    )

    sql = """
    INSERT INTO taxi_trips (trip_id, pickup_community_area, dropoff_community_area, trip_start_timestamp, 
                            trip_end_timestamp, pickup_centroid_latitude, pickup_centroid_longitude,
                            dropoff_centroid_latitude, dropoff_centroid_longitude, trip_miles)
    VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
    """
    while True:
        try:
            cur = conn.cursor()
            for index, row in df_taxi.iterrows():
                values = (str(row['trip_id']),
                        int(row['pickup_community_area']),
                        int(row['dropoff_community_area']),
                        row['trip_start_timestamp'],
                        row['trip_end_timestamp'],
                        float(row['pickup_centroid_latitude']),
                        float(row['pickup_centroid_longitude']),
                        float(row['dropoff_centroid_latitude']),
                        float(row['dropoff_centroid_longitude']),
                        float(row['trip_miles']))
                cur.execute(sql, values)
                conn.commit()
            break
        except:
            print("Oops!", sys.exc_info()[0],"occurred.")
            break
    cur.close()

    #%%
    ### Set up DataBase for Transportation Network Provider Data
    print("TNP data")
    data_network_provider = client.get(network_provider_code,
                                    select = """trip_id, pickup_community_area, dropoff_community_area, 
                                    trip_start_timestamp, trip_end_timestamp, pickup_centroid_latitude,
                                    pickup_centroid_longitude, dropoff_centroid_latitude,
                                    dropoff_centroid_longitude, trip_miles""",
                                    where = "trip_start_timestamp >= '{}'".format(day),
                                    order = "trip_start_timestamp DESC",
                                    limit = 10000)

    df_np = pd.DataFrame(data = data_network_provider).dropna()
    df_np.reset_index(inplace = True)

    conn = psycopg2.connect(
        host='localhost',
        database = 'CBI',
        user='postgres',
        password="MounT@inM@n1992",
        port = '5433'
    )

    sql = """
    INSERT INTO tnp_trips (trip_id, pickup_community_area, dropoff_community_area, trip_start_timestamp, 
                            trip_end_timestamp, pickup_centroid_latitude, pickup_centroid_longitude,
                            dropoff_centroid_latitude, dropoff_centroid_longitude, trip_miles)
    VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
    """
    while True:
        try:
            cur = conn.cursor()
            for index, row in df_np.iterrows():
                values = (str(row['trip_id']),
                        int(row['pickup_community_area']),
                        int(row['dropoff_community_area']),
                        row['trip_start_timestamp'],
                        row['trip_end_timestamp'],
                        float(row['pickup_centroid_latitude']),
                        float(row['pickup_centroid_longitude']),
                        float(row['dropoff_centroid_latitude']),
                        float(row['dropoff_centroid_longitude']),
                        float(row['trip_miles']))
                cur.execute(sql, values)
                conn.commit()
            break
        except:
            print("Oops!", sys.exc_info()[0],"occurred.")
            break
    cur.close()

    ### Add Community Areas to Database

    print("community area data")
    df_com_area = pd.read_csv("/Users/mikesoukup/Desktop/NU MSDS/MSDS 432/CBI Project/Data Analysis/CommAreas.csv")
    #df_com_area
    df_com_area = df_com_area[['AREA_NUM_1','COMMUNITY']]
    df_com_area = df_com_area.sort_values(by = ['AREA_NUM_1'])
    df_com_area = df_com_area.dropna()
    df_com_area.reset_index(inplace = True)

    conn = psycopg2.connect(
        host='localhost',
        database = 'CBI',
        user='postgres',
        password="MounT@inM@n1992",
        port = '5433'
    )

    sql = """
    INSERT INTO community_areas (community_area_number, community)
    VALUES (%s,%s)
    """
    while True:
        try:
            cur = conn.cursor()
            for index, row in df_com_area.iterrows():
                values = (int(row['AREA_NUM_1']),
                        row['COMMUNITY'])
                cur.execute(sql, values)
            break
        except:
            print("Oops!", sys.exc_info()[0],"occurred.")
            break
    conn.commit()
    cur.close()


    ### Load in the Chicago COVID-19 Community Vulnerability Index (CCVI) Data to PostgreSQL
    print("ccvi data")
    data_ccvi = client.get(ccvi_code,
                        select = "community_area_or_zip, ccvi_score, ccvi_category",
                        where = "ccvi_category = 'HIGH' and community_area_name IS NOT NULL",
                        order = "ccvi_score DESC",
                        limit = 1000)
    df_ccvi = pd.DataFrame(data = data_ccvi)
    df_ccvi = df_ccvi.dropna()
    df_ccvi.reset_index(inplace=True)

    conn = psycopg2.connect(
        host='localhost',
        database = 'CBI',
        user='postgres',
        password="MounT@inM@n1992",
        port = '5433'
    )

    sql = """
    INSERT INTO ccvi (community_area_or_zip, ccvi_score, ccvi_category)
    VALUES (%s,%s,%s)
    """
    while True:
        try:
            cur = conn.cursor()
            for index, row in df_ccvi.iterrows():
                values = (int(row['community_area_or_zip']),
                        float(row['ccvi_score']),
                        str(row['ccvi_category']))
                cur.execute(sql, values)
            break
        except:
            print("Oops!", sys.exc_info()[0],"occurred.")
            break
    conn.commit()
    cur.close()

    print("building permits")
    ### Read in the Building Permits data to PostgreSQL
    bp_data = client.get(building_permits_code, 
                        select = "permit_, permit_type, community_area, issue_date, reported_cost",
                        where = "issue_date > '{}'".format(day), 
                        order = "issue_date DESC",
                        limit = 100000)
    df_bp = pd.DataFrame(data = bp_data).dropna()
    df_bp.reset_index(inplace=True)

    conn = psycopg2.connect(
        host='localhost',
        database = 'CBI',
        user='postgres',
        password="MounT@inM@n1992",
        port = '5433'
    )

    sql = """
    INSERT INTO building_permits (permit_, permit_type, community_area, issue_date, reported_cost)
    VALUES (%s,%s,%s,%s,%s)
    """
    while True:
        try:
            cur = conn.cursor()
            for index, row in df_bp.iterrows():
                values = (int(row['permit_']),
                        str(row['permit_type']),
                        int(row['community_area']),
                            row['issue_date'],
                        float(row['reported_cost']))
                cur.execute(sql, values)
                conn.commit()
            break
        except:
            print("Oops!", sys.exc_info()[0],"occurred.")
            break
    cur.close()

    ### Read in the Socio Economic Data to PostgreSQL
    print("socioeconomic data")
    s_data = client.get(socio_code,
                        select = "ca, community_area_name, percent_households_below_poverty, percent_aged_16_unemployed, per_capita_income_ ",
                        order = "percent_aged_16_unemployed DESC")
    df_s = pd.DataFrame(data = s_data).dropna()
    df_s.reset_index(inplace=True)

    conn = psycopg2.connect(
        host='localhost',
        database = 'CBI',
        user='postgres',
        password="MounT@inM@n1992",
        port = '5433'
    )

    sql = """
    INSERT INTO socio_economic_data (ca, community_area_name, percent_aged_16_unemployed, per_capita_income_, percent_households_below_poverty)
    VALUES (%s,%s,%s,%s,%s)
    """
    while True:
        try:
            cur = conn.cursor()
            for index, row in df_s.iterrows():
                values = (int(row['ca']),
                        row['community_area_name'],
                        float(row['percent_aged_16_unemployed']),
                        int(row['per_capita_income_']),
                        float(row['percent_households_below_poverty']))
                cur.execute(sql, values)
            break
        except:
            print("Oops!", sys.exc_info()[0],"occurred.")
            break
    conn.commit()
    cur.close()

    ### Need to add some missing Ohare Data:
    print("Ohare data")
    ### Execute SoQL Query for selected rows and columns:
    data_covid = client.get_all(covid_zip_code,
                                select = "zip_code, week_start, percent_tested_positive_weekly",
                                where = "week_start >= '{}' and zip_code = '60666'".format(day),
                                order = "cases_weekly DESC,week_start DESC, zip_code ASC",
                                limit = 10000)


    df_covid = pd.DataFrame(data=data_covid).dropna()
    df_covid = df_covid[df_covid['zip_code'] != 'Unknown']
    df_covid.reset_index(inplace=True)
    df_covid['zip_code_week_start'] = df_covid['zip_code']+' '+df_covid['week_start']

    ### Will add 0 for all cases_weekly values out of Ohare:
    df_covid['cases_weekly'] = 0

    ### Now load this new Ohare specific data into PostgreSQL:
    conn = psycopg2.connect(
        host='localhost',
        database = 'CBI',
        user='postgres',
        password="MounT@inM@n1992",
        port = '5433'
    )

    sql = """
    INSERT INTO covid_19_by_zip (zip_code, week_start, cases_weekly, percent_tested_positive_weekly, zip_code_week_start)
    VALUES (%s,%s,%s,%s,%s)
    """
    while True:
        try:
            cur = conn.cursor()
            for index, row in df_covid.iterrows():
                values = (int(row['zip_code']),
                        row['week_start'][0:10],
                        float(row['cases_weekly']),
                        float(row['percent_tested_positive_weekly']),
                        row['zip_code_week_start'][0:16])
                cur.execute(sql, values)
                conn.commit()
            break
        except:
            print("Oops!", sys.exc_info()[0],"occurred.")
            break
    conn.commit()
    cur.close()

    ### re-run this script every 2 min for development (Actually would update once a day):
    print("Sleep")
    time.sleep(120) #time.sleep(seconds) - set to 120 for development. Would normally set to ~ 1 day or every 8-12 hours during production.
    
    #%%
    ### Write in taxi-trips-info data:
# %%
### Load in all taxi data:
#Only use taxi data for this because of disparity between counts on taxi and uber data and mismatch dates
conn = psycopg2.connect(
    host='localhost',
    database = 'CBI',
    user='postgres',
    password="MounT@inM@n1992",
    port = '5433'
)

cur = conn.cursor()

sql = """
SELECT *
FROM taxi_trips;
"""

### add in way to continue with SQL calls even if there is a "Bad Address"
#try:
#    cur.execute(sql)
#except:
#    continue

cur.execute(sql)

data = cur.fetchall()

df_ts = pd.DataFrame(data = data,
                    columns = ['trip_id', 'pickup_community_area', 'dropoff_community_area', 
                                'trip_start_timestamp', 'trip_end_timestamp', 'pickup_centroid_latitude',
                                'pickup_centroid_longitude', 'dropoff_centroid_latitude',
                                'dropoff_centroid_longitude', 'trip_miles'])

sql_ca = """
SELECT *
FROM community_areas;
"""

cur.execute(sql_ca)
data_ca = cur.fetchall()
df_ca = pd.DataFrame(data = data_ca,
                    columns = ['community_area_number','community'])

### Create commuinty area number to community name dictionary:
ca_dict = {}

for index, row in df_ca.iterrows():
    ca_dict[row[0]] = row[1]

cur.close()

#%%
#Convert time data to dates:
df_ts['trip_start_timestamp'] = df_ts['trip_start_timestamp'].apply(lambda x: x.date())
df_ts['trip_end_timestamp'] = df_ts['trip_end_timestamp'].apply(lambda x: x.date())
df_ts.sort_values('trip_start_timestamp', ascending= True, inplace= True)
df_ts.reset_index(inplace = True)
df_ts = df_ts[(df_ts['trip_start_timestamp'] <= datetime.date(year = 2021, month = 2, day = 27)) & (df_ts['trip_start_timestamp'] >= datetime.date(year = 2020, month = 12, day = 1))]
#%%
### Add pickup and and drop off zips and communities to the taxi dataset and write to a new datatable:
### Manually call this during development. This is CPU intensive. Need to optimize to only add zipcode information to rows without it. 

def write_taxi_trips_info(df_ts = df_ts):
    df_ts['pickup_community'] = df_ts['pickup_community_area'].map(ca_dict)
    df_ts['dropoff_community'] = df_ts['dropoff_community_area'].map(ca_dict)

    df_ts['pickup_zip'] = 0
    df_ts['dropoff_zip'] = 0
    with open('Boundaries - ZIP Codes.geojson') as f:
            js = json.load(f)
                    
    for index, row in df_ts.iterrows():
        print(index)
        pickup = Point(row['pickup_centroid_longitude'], row['pickup_centroid_latitude'])
        dropoff = Point(row['dropoff_centroid_longitude'], row['dropoff_centroid_latitude'])
        for feature in js['features']:
            polygon = shape(feature['geometry'])
            if polygon.contains(pickup):
                pickup_zip = feature['properties']['zip']
            else:
                continue
            
        for feature in js['features']:
            polygon = shape(feature['geometry'])
            if polygon.contains(dropoff):
                dropoff_zip = feature['properties']['zip']
            else:
                continue
        df_ts['pickup_zip'][index] = pickup_zip
        df_ts['dropoff_zip'][index] = dropoff_zip

    conn = psycopg2.connect(
        host='localhost',
        database = 'CBI',
        user='postgres',
        password="MounT@inM@n1992",
        port = '5433'
    )

    sql = """
    INSERT INTO taxi_trips_info (trip_id, pickup_community_area, dropoff_community_area, trip_start_timestamp, 
                            trip_end_timestamp, pickup_centroid_latitude, pickup_centroid_longitude,
                            dropoff_centroid_latitude, dropoff_centroid_longitude, trip_miles,
                            pickup_community, dropoff_community, pickup_zip, dropoff_zip)
    VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
    """
    while True:
        try:
            cur = conn.cursor()
            for index, row in df_ts.iterrows():
                values = (str(row['trip_id']),
                        int(row['pickup_community_area']),
                        int(row['dropoff_community_area']),
                        row['trip_start_timestamp'],
                        row['trip_end_timestamp'],
                        float(row['pickup_centroid_latitude']),
                        float(row['pickup_centroid_longitude']),
                        float(row['dropoff_centroid_latitude']),
                        float(row['dropoff_centroid_longitude']),
                        float(row['trip_miles']),
                        row['pickup_community'],
                        row['dropoff_community'],
                        int(row['pickup_zip']),
                        int(row['dropoff_zip']))
                cur.execute(sql, values)
                conn.commit()
            break
        except:
            print("Oops!", sys.exc_info()[0],"occurred.")
            break
    cur.close()

#%%
### Pad Taxi Data for additional analysis
def taxi_pad():
    day = '2021-05-26'
    day_1 = '2021-05-27'
    data_taxi = client.get(taxi_code,
                        select = """trip_id, pickup_community_area, dropoff_community_area, 
                                    trip_start_timestamp, trip_end_timestamp, pickup_centroid_latitude,
                                    pickup_centroid_longitude, dropoff_centroid_latitude,
                                    dropoff_centroid_longitude, trip_miles""",
                        where = "trip_start_timestamp >= '{}' and trip_start_timestamp < '{}'".format(day, day_1),
                        order = "trip_start_timestamp ASC",
                        limit = 1000000)
    df_taxi = pd.DataFrame(data = data_taxi).dropna()
    df_taxi.reset_index(inplace = True)

    ### Insert data to database:
    conn = psycopg2.connect(
        host='localhost',
        database = 'CBI',
        user='postgres',
        password="MounT@inM@n1992",
        port = '5433'
    )

    sql = """
    INSERT INTO taxi_trips (trip_id, pickup_community_area, dropoff_community_area, trip_start_timestamp, 
                            trip_end_timestamp, pickup_centroid_latitude, pickup_centroid_longitude,
                            dropoff_centroid_latitude, dropoff_centroid_longitude, trip_miles)
    VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
    """
    while True:
        try:
            cur = conn.cursor()
            for index, row in df_taxi.iterrows():
                print(index)
                values = (str(row['trip_id']),
                        int(row['pickup_community_area']),
                        int(row['dropoff_community_area']),
                        row['trip_start_timestamp'],
                        row['trip_end_timestamp'],
                        float(row['pickup_centroid_latitude']),
                        float(row['pickup_centroid_longitude']),
                        float(row['dropoff_centroid_latitude']),
                        float(row['dropoff_centroid_longitude']),
                        float(row['trip_miles']))
                cur.execute(sql, values)
                conn.commit()
            break
        except:
            print("Oops!", sys.exc_info()[0],"occurred.")
            break
    cur.close()
    return
