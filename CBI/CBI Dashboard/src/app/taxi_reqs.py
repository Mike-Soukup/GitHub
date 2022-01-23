#%%
### Start by loading in libraries:
from folium.features import Choropleth
import pandas as pd
import psycopg2 
import folium
import geopandas as gpd
import json
from sodapy import Socrata
from shapely.geometry import shape, Point
import random
import datetime
from dateutil.relativedelta import relativedelta
import sys
from folium.plugins import MarkerCluster
import numpy as np
from sklearn import linear_model
import plotly.express as px
import plotly.graph_objects as go
from prophet import Prophet, forecaster
from prophet.plot import plot_components
from prophet.plot import plot_plotly, plot_components_plotly
import matplotlib.pyplot as plt
import plotly.offline as py
import warnings
warnings.simplefilter("ignore")
# %%
### Now pull in all data needed for this application:

#City of Chicago Data API Info:
MyAppToken = "nfYJdXEGYjJcd4zmD0pKW5f4b"
username = "michaelsoukup2021@u.northwestern.edu"
password = "MounT@inM@n1992"
source = "data.cityofchicago.org"
timeout = 600

zip_boundary_code = 'unjd-c2ca'

### Next set up the API Client to access some data:
client = Socrata(source,
                 MyAppToken,
                 username=username,
                 password=password,
                 timeout = timeout)

### Pull in necessary data from PostgreSQL DataLake:

conn = psycopg2.connect(
    host='localhost',
    database = 'CBI',
    user='postgres',
    password="MounT@inM@n1992",
    port = '5433'
)

sql = """
SELECT *
FROM covid_19_by_zip;
"""

sql_taxi = """
SELECT *
FROM taxi_trips;
"""

sql_tnp = """
SELECT *
FROM tnp_trips;
"""

sql_ca = """
SELECT *
FROM community_areas;
"""

cur = conn.cursor()
cur.execute(sql)

data = cur.fetchall()

df_covid = pd.DataFrame(data = data,
                        columns = ['zip','week_start','cases_weekly',
                        'percent_tested_positive_weekly','zip_code_week_start'])

cur = conn.cursor()
cur.execute(sql_taxi)
data_taxi = cur.fetchall()
df_taxi = pd.DataFrame(data = data_taxi,
                       columns = ['trip_id', 'pickup_community_area', 'dropoff_community_area', 
                                   'trip_start_timestamp', 'trip_end_timestamp', 'pickup_centroid_latitude',
                                   'pickup_centroid_longitude', 'dropoff_centroid_latitude',
                                   'dropoff_centroid_longitude', 'trip_miles'])
df_taxi = df_taxi.sort_values(by = 'trip_start_timestamp')

cur.execute(sql_tnp)
data_tnp = cur.fetchall()
df_tnp = pd.DataFrame(data = data_tnp,
                      columns = ['trip_id', 'pickup_community_area', 'dropoff_community_area', 
                                   'trip_start_timestamp', 'trip_end_timestamp', 'pickup_centroid_latitude',
                                   'pickup_centroid_longitude', 'dropoff_centroid_latitude',
                                   'dropoff_centroid_longitude', 'trip_miles'])

cur.execute(sql_ca)
data_ca = cur.fetchall()
df_ca = pd.DataFrame(data = data_ca,
                     columns = ['community_area_number','community'])

chicago_geo_df = gpd.read_file('Boundaries - ZIP Codes.geojson')

cur.close()

#%%
### Manipulate the data used in this application:

### Manipluate Covid data by Zip Code:
df_covid['zip'] = df_covid['zip'].astype(str)
df_covid['cases_weekly'] = df_covid['cases_weekly'].astype(float)


df_geo = df_covid.sort_values(by = ['week_start'], ascending = False)
df_geo.reset_index(inplace = True)
latest_week = df_geo['week_start'][0]
df_graph = df_geo[df_geo['week_start'] == latest_week]

### Create commuinty area number to community name dictionary:
ca_dict = {}

for index, row in df_ca.iterrows():
    ca_dict[row[0]] = row[1]

### Combine Taxi and TNP data into one dataframe:

frames = [df_taxi, df_tnp]

df = pd.concat(frames)

df = df.sort_values(by = 'trip_start_timestamp', ascending= False)
df.reset_index(inplace = True)
df['pickup_community'] = df['pickup_community_area'].map(ca_dict)
df['dropoff_community'] = df['dropoff_community_area'].map(ca_dict)

#%%
### Set up Function to create Chicago Covid-19 Choropleth by Zip-Code:

def chicago_covid19(week=latest_week,df=df_covid, chicago_geo_df=chicago_geo_df):
    #Subset data for week of interest:
    df_geo = df.sort_values(by = ['week_start'], ascending = False)
    df_geo.reset_index(inplace = True)
    df_graph = df_geo[df_geo['week_start'] == week]
    #Define Chicago Latitude and Longitude:
    chicago = [41.8781, -87.6298]
    #Create base map centered at Chicago:
    map = folium.Map(location= chicago, default_zoom_start = 15,
                 min_zoom = 9, max_zoom = 13)
    #Create Choropleth with Covid-19 Zip Code data:
    folium.Choropleth(
    geo_data = chicago_geo_df,
    name = "choropleth",
    data = df_graph,
    columns = ['zip','cases_weekly'],
    key_on = 'feature.properties.zip',
    fill_color = 'YlOrRd',
    fill_opacity = 0.5,
    line_color = "black",
    line_opacity = 0.5,
    legend_name = "Covid-19 Weekly Cases for {}".format(week),
    highlight = 1
    ).add_to(map)
    #Define style and highlight functions for interactivity:
    style_function = lambda x: {'fillColor': '#ffffff', 
                            'color':'#000000', 
                            'fillOpacity': 0.1, 
                            'weight': 0.1}
    highlight_function = lambda x: {'fillColor': '#000000', 
                                'color':'#000000', 
                                'fillOpacity': 0.50, 
                                'weight': 0.1}
    #Further manipulate data for interactivity:
    df_graph = df_graph.astype(str)
    chicago_geo_df = chicago_geo_df.merge(df_graph, on = 'zip')
    for i in range(len(chicago_geo_df['cases_weekly'])):
        chicago_geo_df['cases_weekly'][i] = "{:.1f}".format(float(chicago_geo_df['cases_weekly'][i]))
    #Set up tooltip:
    tooltip = folium.features.GeoJson(
    data = chicago_geo_df,
    style_function = style_function,
    control = False,
    highlight_function = highlight_function,
    tooltip = folium.features.GeoJsonTooltip(
        fields = ['zip', 'cases_weekly'],
        aliases = ['Zip Code:','Cases per Week:'],
        style =('background-color: white; color: #333333; font-family: arial; font-size: 10px; padding: 4px;')
    ))
    map.add_child(tooltip)
    map.keep_in_front(tooltip)
    folium.LayerControl().add_to(map)
    return map

#%%
### Now create the HTML output version of this function:
def chicago_covid19_html(week=latest_week,df=df_covid, chicago_geo_df=chicago_geo_df):
    #Subset data for week of interest:
    df_geo = df.sort_values(by = ['week_start'], ascending = False)
    df_geo.reset_index(inplace = True)
    df_graph = df_geo[df_geo['week_start'] == week]
    #Define Chicago Latitude and Longitude:
    chicago = [41.8781, -87.6298]
    #Create base map centered at Chicago:
    map = folium.Map(location= chicago, default_zoom_start = 15,
                 min_zoom = 9, max_zoom = 13)
    #Create Choropleth with Covid-19 Zip Code data:
    folium.Choropleth(
    geo_data = chicago_geo_df,
    name = "choropleth",
    data = df_graph,
    columns = ['zip','cases_weekly'],
    key_on = 'feature.properties.zip',
    fill_color = 'YlOrRd',
    fill_opacity = 0.5,
    line_color = "black",
    line_opacity = 0.5,
    legend_name = "Covid-19 Weekly Cases for {}".format(week),
    highlight = 1
    ).add_to(map)
    #Define style and highlight functions for interactivity:
    style_function = lambda x: {'fillColor': '#ffffff', 
                            'color':'#000000', 
                            'fillOpacity': 0.1, 
                            'weight': 0.1}
    highlight_function = lambda x: {'fillColor': '#000000', 
                                'color':'#000000', 
                                'fillOpacity': 0.50, 
                                'weight': 0.1}
    #Further manipulate data for interactivity:
    df_graph = df_graph.astype(str)
    chicago_geo_df = chicago_geo_df.merge(df_graph, on = 'zip')
    for i in range(len(chicago_geo_df['cases_weekly'])):
        chicago_geo_df['cases_weekly'][i] = "{:.1f}".format(float(chicago_geo_df['cases_weekly'][i]))
    #Set up tooltip:
    tooltip = folium.features.GeoJson(
    data = chicago_geo_df,
    style_function = style_function,
    control = False,
    highlight_function = highlight_function,
    tooltip = folium.features.GeoJsonTooltip(
        fields = ['zip', 'cases_weekly'],
        aliases = ['Zip Code:','Cases per Week:'],
        style =('background-color: white; color: #333333; font-family: arial; font-size: 10px; padding: 4px;')
    ))
    map.add_child(tooltip)
    map.keep_in_front(tooltip)
    folium.LayerControl().add_to(map)
    return map._repr_html_()
# %%
### Now define Taxi/TNP specific Information and notification function:
def carrier_notification(df=df, df_geo = df_geo):
    #create a random trip variable first:
    random.seed()
    trip = df.loc[random.randint(0,len(df))]

    #Get week of trip to reflect on Chloropleth Graph:

    trip_date = trip['trip_start_timestamp']

    if type(trip_date) == datetime.datetime:
        cal_week = trip_date.isocalendar()[1]
        trip_week_start = datetime.date(trip_date.year,1,3) + relativedelta(weeks=+(cal_week-1))
    else:
        trip_week_start = datetime.date(trip_date.year,1,3) + relativedelta(weeks=+(trip_date.week-1))
    df_graph = df_geo[df_geo['week_start'] == trip_week_start]

    #Create choropleth first:
    
    map = chicago_covid19(week = trip_week_start)

    with open('Boundaries - ZIP Codes.geojson') as f:
        js = json.load(f)

    pickup = Point(trip['pickup_centroid_longitude'],trip['pickup_centroid_latitude'])
    dropoff = Point(trip['dropoff_centroid_longitude'],trip['dropoff_centroid_latitude'])

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

    covid_pickup = df_graph[df_graph['zip'] == pickup_zip]['cases_weekly'].item()
    covid_dropoff = df_graph[df_graph['zip'] == dropoff_zip]['cases_weekly'].item()

    pickup_tooltip = "Pickup"
    width = 175
    html_pickup = """
    <h6> Pickup Location: </h6>
    <p> Community Area: {} </p>
    <p> Community: {} </p>
    <p> Zip Code: {} </p> 
    <p> Weekly Covid-19 Cases: {:.1f} </p>
    """
    folium.Marker(
        location = [trip['pickup_centroid_latitude'],trip['pickup_centroid_longitude']],
        popup = folium.Popup(html = html_pickup.format(trip['pickup_community_area'], 
                                                      trip['pickup_community'],
                                                      pickup_zip, covid_pickup),
                            min_width = width,
                            max_width = width),
        tooltip = pickup_tooltip,
        icon = folium.Icon(icon = "thumbs-up"),
    ).add_to(map)

    dropoff_tooltip = "Dropoff"
    width = 175
    html_dropoff = """
    <h6> Pickup Location: </h6>
    <p> Community Area: {} </p>
    <p> Community: {} </p>
    <p> Zip Code: {} </p> 
    <p> Weekly Covid-19 Cases: {:.1f} </p>
    """
    folium.Marker(
        location = [trip['dropoff_centroid_latitude'],trip['dropoff_centroid_longitude']],
        popup = folium.Popup(html = html_dropoff.format(trip['dropoff_community_area'],
                                                        trip['dropoff_community'],
                                                        dropoff_zip, covid_dropoff),
                            min_width = width,
                            max_width = width),
        tooltip = dropoff_tooltip,
        icon = folium.Icon(icon = "ok-sign", color = "green")
    ).add_to(map)

    median = df_graph['cases_weekly'].quantile(q=0.5)

    if covid_pickup <= median:
        pickup_severity = "LOW"
    else:
        pickup_severity = "HIGH"
    
    if covid_dropoff <= median:
        dropoff_severity = "LOW"
    else:
        dropoff_severity = "HIGH"
    

    if covid_dropoff > covid_pickup:
        msg = '''Ride Confirmed!

        CAUTION: Dropoff Location has a higher rate of Covid-19 than Pickup Location

        Ride Details:

        Pickup Location
        Community: {} Zip Code: {} Weekly Covid Cases: {:.1f} Covid Severity: {}

        Dropoff Location
        Community: {} Zip Code: {} Weekly Covid Cases: {:.1f} Covid Severity: {}

        Thank you and Be Safe!!'''.format(trip['pickup_community'], pickup_zip, covid_pickup, pickup_severity,
                trip['dropoff_community'],dropoff_zip, covid_dropoff, dropoff_severity)
    else:
        msg = '''Ride Confirmed!

        Ride Details:

        Pickup Location
        Community: {} Zip Code: {} Weekly Covid Cases: {:.1f} Covid Severity: {}

        Dropoff Location
        Community: {} Zip Code: {} Weekly Covid Cases: {:.1f} Covid Severity: {}

        Thank you and Be Safe!!'''.format(trip['pickup_community'], pickup_zip, covid_pickup, pickup_severity,
                trip['dropoff_community'],dropoff_zip, covid_dropoff, dropoff_severity)

    print(msg)

    return map

#%%
### Define Carrier Notification HTML
def carrier_notification_html(df=df, df_geo = df_geo):
    #create a random trip variable first:
    random.seed()
    trip = df.loc[random.randint(0,len(df))]

    #Get week of trip to reflect on Chloropleth Graph:

    trip_date = trip['trip_start_timestamp']

    if type(trip_date) == datetime.datetime:
        cal_week = trip_date.isocalendar()[1]
        trip_week_start = datetime.date(trip_date.year,1,3) + relativedelta(weeks=+(cal_week-1))
    else:
        trip_week_start = datetime.date(trip_date.year,1,3) + relativedelta(weeks=+(trip_date.week-1))

    df_graph = df_geo[df_geo['week_start'] == trip_week_start]

    #Create choropleth first:
    
    map = chicago_covid19(week = trip_week_start)

    with open('Boundaries - ZIP Codes.geojson') as f:
        js = json.load(f)

    pickup = Point(trip['pickup_centroid_longitude'],trip['pickup_centroid_latitude'])
    dropoff = Point(trip['dropoff_centroid_longitude'],trip['dropoff_centroid_latitude'])

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

    covid_pickup = df_graph[df_graph['zip'] == pickup_zip]['cases_weekly'].item()
    covid_dropoff = df_graph[df_graph['zip'] == dropoff_zip]['cases_weekly'].item()

    pickup_tooltip = "Pickup"
    width = 175
    html_pickup = """
    <h6> Pickup Location: </h6>
    <p> Community Area: {} </p>
    <p> Community: {} </p>
    <p> Zip Code: {} </p> 
    <p> Weekly Covid-19 Cases: {:.1f} </p>
    <p> Pickup Date: {} </p>
    """
    folium.Marker(
        location = [trip['pickup_centroid_latitude'],trip['pickup_centroid_longitude']],
        popup = folium.Popup(html = html_pickup.format(trip['pickup_community_area'], 
                                                      trip['pickup_community'],
                                                      pickup_zip, covid_pickup, trip_date),
                            min_width = width,
                            max_width = width),
        tooltip = pickup_tooltip,
        icon = folium.Icon(icon = "thumbs-up"),
    ).add_to(map)

    dropoff_tooltip = "Dropoff"
    width = 175
    html_dropoff = """
    <h6> Dropoff Location: </h6>
    <p> Community Area: {} </p>
    <p> Community: {} </p>
    <p> Zip Code: {} </p> 
    <p> Weekly Covid-19 Cases: {:.1f} </p>
    """
    folium.Marker(
        location = [trip['dropoff_centroid_latitude'],trip['dropoff_centroid_longitude']],
        popup = folium.Popup(html = html_dropoff.format(trip['dropoff_community_area'],
                                                        trip['dropoff_community'],
                                                        dropoff_zip, covid_dropoff),
                            min_width = width,
                            max_width = width),
        tooltip = dropoff_tooltip,
        icon = folium.Icon(icon = "ok-sign", color = "green")
    ).add_to(map)

    median = df_graph['cases_weekly'].quantile(q=0.5)

    if covid_pickup <= median:
        pickup_severity = "LOW"
    else:
        pickup_severity = "HIGH"
    
    if covid_dropoff <= median:
        dropoff_severity = "LOW"
    else:
        dropoff_severity = "HIGH"
    

    if covid_dropoff > covid_pickup:
        msg = '''
        Ride Confirmed!

        CAUTION: Dropoff Location has a higher rate of Covid-19 than Pickup Location

        Ride Details:

        Pickup Location
        Community: {} Zip Code: {} Weekly Covid Cases: {:.1f} Covid Severity: {}

        Dropoff Location
        Community: {} Zip Code: {} Weekly Covid Cases: {:.1f} Covid Severity: {}

        Thank you and Be Safe!!'''.format(trip['pickup_community'], pickup_zip, covid_pickup, pickup_severity,
                trip['dropoff_community'],dropoff_zip, covid_dropoff, dropoff_severity)
    else:
        msg = '''
        Ride Confirmed!

        Ride Details:

        Pickup Location
        Community: {} Zip Code: {} Weekly Covid Cases: {:.1f} Covid Severity: {}

        Dropoff Location
        Community: {} Zip Code: {} Weekly Covid Cases: {:.1f} Covid Severity: {}

        Thank you and Be Safe!!'''.format(trip['pickup_community'], pickup_zip, covid_pickup, pickup_severity,
                trip['dropoff_community'],dropoff_zip, covid_dropoff, dropoff_severity)
    
    print(msg)

    return map._repr_html_()

#%%
###Insert the requirement 2 code to limit load times for each function in the app
#%%
### Now find all the Zip Codes in the Taxi/TNP data, and create a new datatable to avoid repeating this operation:
def add_zip_insert(df=df):
    df['pickup_zip'] = 0
    df['dropoff_zip'] = 0
    with open('Boundaries - ZIP Codes.geojson') as f:
            js = json.load(f)
                
    for index, row in df.iterrows():
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
        df['pickup_zip'][index] = pickup_zip
        df['dropoff_zip'][index] = dropoff_zip

    conn = psycopg2.connect(
        host='localhost',
        database = 'CBI',
        user='postgres',
        password="MounT@inM@n1992",
        port = '5433'
    )

    sql = """
    INSERT INTO all_trip_info (trip_id, pickup_community_area, dropoff_community_area, trip_start_timestamp, 
                            trip_end_timestamp, pickup_centroid_latitude, pickup_centroid_longitude,
                            dropoff_centroid_latitude, dropoff_centroid_longitude, trip_miles,
                            pickup_community, dropoff_community, pickup_zip, dropoff_zip)
    VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
    """
    while True:
        try:
            cur = conn.cursor()
            for index, row in df.iterrows():
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
### Get taxi trip information from PostgreSQL

conn = psycopg2.connect(
    host='localhost',
    database = 'CBI',
    user='postgres',
    password="MounT@inM@n1992",
    port = '5433'
)

### Only select trip information from ORD or MDW//Only use taxi trips data for consistency. With TNP data have limited date range.
# ORD = 60666
# MDW = 60638
sql = """
SELECT *
FROM taxi_trips_info
"""
#WHERE pickup_zip = 60666 OR pickup_zip = 60638 


cur = conn.cursor()
cur.execute(sql)
data = cur.fetchall()

df2 = pd.DataFrame(data = data,
                 columns = ['trip_id', 'pickup_community_area', 'dropoff_community_area', 'trip_start_timestamp', 
                            'trip_end_timestamp', 'pickup_centroid_latitude', 'pickup_centroid_longitude',
                            'dropoff_centroid_latitude', 'dropoff_centroid_longitude', 'trip_miles',
                            'pickup_community', 'dropoff_community', 'pickup_zip', 'dropoff_zip'])
cur.close()
df2 = df2.sort_values(by = ['trip_start_timestamp'], ascending=False)
#%%
### Only take values from this year
df2_edit = df2[df2['pickup_zip'].isin([60666,60638])]
df2_edit = df2_edit[pd.to_datetime(df2_edit['trip_start_timestamp'],utc = True).dt.date > datetime.date(year = 2021, month = 1, day = 1)]
#Drop any Ohare dropoffs as we only want to look at trips from Ohare, not to it. 
df2_edit = df2_edit[df2_edit['dropoff_zip'] != 60666]
# %%
### Get list of weeks we have data for and prove chicago_covid19() will work with arbitrary week:
list_of_weeks = df_covid.sort_values(by = 'week_start', ascending=False)['week_start'].unique()
week = random.choice(list_of_weeks)

#%%
### Write function to correlate trips to a zip code an percent positive covid-19 rate for that zip code:

def trips_to_percent_positive(df2 = df2_edit, df_covid = df_covid, week = week):

    df2_agg = df2.groupby('dropoff_zip')['trip_id'].count()
    df2_agg = df2_agg.reset_index().rename(columns={"trip_id":"trips"})
    df_covid_pos = df_covid[df_covid['week_start']==week].sort_values(by = "zip")
    df2_agg_zips = list(df2_agg['dropoff_zip'])
    zips_not_in_agg = []

    for zip in df_covid_pos['zip']:
        if int(zip) in df2_agg_zips:
            continue
        else:
            zips_not_in_agg.append(zip)

    for zip in zips_not_in_agg:
        df_covid_pos = df_covid_pos[df_covid_pos['zip'] != zip]

    df_covid_pos = df_covid_pos
    if df2_agg_zips == list(df_covid_pos['zip'].astype(int)):
        df2_agg['tested_positive'] = list(df_covid_pos['percent_tested_positive_weekly'])
    else:
        print('Error when adding percent tested positive weekly to aggregate trip data!')

    trips = df2_agg['trips']
    positive_data = df2_agg['tested_positive']

    trips = np.array(trips).reshape((-1, 1))
    positive_data = np.array(positive_data)
    #Create Linear Regression Model
    regr = linear_model.LinearRegression().fit(trips, positive_data)
    slope = regr.coef_
    intercept = regr.intercept_
    score = regr.score(trips, positive_data)

    x = np.linspace(min(df2_agg['trips']), max(df2_agg['trips']),100)
    y = regr.predict(np.array(x).reshape(-1,1))

    fig = px.scatter(
        df2_agg, x='trips', y='tested_positive', opacity=0.65,
        trendline='ols', trendline_color_override='darkblue',
        width = 1350, height = 750, 
        title = "Positive Covid Tests per ZipCode vs. Trips from Airports for Week {}".format(week),
        labels={
                        "trips": "Trips from Airports",
                        "tested_positive": "% Positive Covid Tests"
                    }  
    )
    
    fig.show()

    if score < 0.5:
        msg = """
        
        There is a poor correlation between Taxi Trips from Airports to Local Communities and the spread of Covid-19.
        
        """
    elif score >= 0.5 and slope > 0:
        msg = """
        
        The Data indicates that Taxi and Transportation Service Providers fuel the spread of Covid-19 to local communities.
        
        """
    elif score >= 0.5 and slope < 0:
        msg = """
        
        The Data indicates that Taxi and Transportation Service Providers mitigate the spread of Covid-19 to local communities.
        
        """
    
    print(msg)





# %%
### Define Marker Cluster Map for a given week

def trips_airport_to_zipcode_clustermap_html(week = week, df = df_covid, chicago_geo_df = chicago_geo_df, df2=df2_edit):
    df_geo = df.sort_values(by = ['week_start'], ascending = False)
    df_geo.reset_index(inplace = True)
    df_graph = df_geo[df_geo['week_start'] == week]
    
    df2['trip_start_timestamp'] = pd.to_datetime(df2['trip_start_timestamp'], utc = True).dt.date
    end = week + datetime.timedelta(days=7)
    df2 = df2[(df2['trip_start_timestamp'] >= week) & (df2['trip_start_timestamp'] < end)]

    #Define Chicago Latitude and Longitude:
    chicago = [41.8781, -87.6298]
    #Create base map centered at Chicago:
    mapp = folium.Map(location= chicago, default_zoom_start = 15,
                    min_zoom = 9, max_zoom = 13)
    
    airports = {60666:"ORD",60638:"MDW"}

    marker_cluster = MarkerCluster().add_to(mapp)

    for index, row in df2.iterrows():
        lat = float(row['dropoff_centroid_latitude'])
        lon = float(row['dropoff_centroid_longitude'])
        folium.Marker(location = (lat, lon),
                    popup = folium.Popup(
                        html = "Date: %s <br> Pickup: %s <br> Dropoff: %s <br> Distance: %s <br>" %(str(row['trip_start_timestamp'])[0:10], airports[row['pickup_zip']], row['dropoff_community'], row['trip_miles']) 
                    )).add_to(marker_cluster)
    
    folium.Choropleth(
        geo_data = chicago_geo_df,
        name = "choropleth",
        data = df_graph,
        columns = ['zip','cases_weekly'],
        key_on = 'feature.properties.zip',
        fill_color = 'YlOrRd',
        fill_opacity = 0.5,
        line_color = "black",
        line_opacity = 0.5,
        legend_name = "Covid-19 Weekly Cases for {}".format(week),
        highlight = 1
        ).add_to(mapp)
    
    return mapp._repr_html_()

#%%
### Call in HIGH CCVI Area data from PostgreSQL

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
FROM ccvi;
"""
cur.execute(sql)
data = cur.fetchall()

df_ccvi = pd.DataFrame(data = data,
                       columns = ['community_area','ccvi_score','ccvi_label'])
cur.close()

#%%
### Set up fucntion for all trips FROM HIGH CCVI Community Areas:

def trips_and_high_ccvi_areas(ccvi_df = df_ccvi, trip_df = df2):
    high_ccvi_areas = list(df_ccvi['community_area'])
    df_from = df2
    df_from = df_from[df_from['pickup_community_area'].isin(high_ccvi_areas)]

    # Aggregate values to count the number of trips from each community area:
    df_from_agg = df_from.groupby('pickup_community')['trip_id'].count()
    df_from_agg = df_from_agg.reset_index()
    df_from_agg.rename(columns = {"trip_id":"trips_from"}, inplace=True)

    df_to = df2
    df_to = df_to[df_to['dropoff_community_area'].isin(high_ccvi_areas)]

    df_to_agg = df_to.groupby('dropoff_community')['trip_id'].count()
    df_to_agg = df_to_agg.reset_index()
    df_to_agg.rename(columns = {"trip_id":"trips_to"}, inplace=True)

    if list(df_from_agg['pickup_community']) == list(df_to_agg['dropoff_community']):
        df_ccvi_bar = pd.DataFrame()
        df_ccvi_bar['community'] = df_from_agg['pickup_community']
        df_ccvi_bar['trips_from'] = df_from_agg['trips_from']
        df_ccvi_bar['trips_to'] = df_to_agg['trips_to']
    else:
        print("From/To Error!!")

    fig = go.Figure()
    fig.add_trace(go.Bar(
        x = list(df_from_agg['pickup_community']),
        y = list(df_ccvi_bar['trips_from']),
        name = "From",
        marker_color = '#d62728'
    ))
    fig.add_trace(go.Bar(
        x = list(df_to_agg['dropoff_community']),
        y = list(df_ccvi_bar['trips_to']),
        name = "To",
        marker_color = '#2ca02c'
    ))

    fig.update_layout(barmode = "group", xaxis_tickangle=-45,
                    title_text = "Count of Taxi/TNP Trips FROM and TO HIGH CCVI Communities",
                    title_font_size = 25,
                    xaxis_tickfont_size=10,
                    yaxis=dict(
                        title='Trips',
                        titlefont_size=15,
                        tickfont_size=10,
        ),
                    bargap=0.5, # gap between bars of adjacent location coordinates.
                    bargroupgap=0.1 )
    fig.show()
    fig.write_html("/Users/mikesoukup/Desktop/'NU MSDS'/'MSDS 432'/'CBI Project'/Requirements/templates/ccvi_to_from.html")
    return 

#%%
df_ts = df2.copy()

#Convert time data to dates:
df_ts['trip_start_timestamp'] = df_ts['trip_start_timestamp'].apply(lambda x: x.date())
df_ts['trip_end_timestamp'] = df_ts['trip_end_timestamp'].apply(lambda x: x.date())

### Only look at trip_start_datetime > 2021
df_ts = df_ts[df_ts['trip_start_timestamp'] >= datetime.date(year = 2021, month = 1, day = 1)]
df_ts = df_ts[df_ts['trip_start_timestamp'] < datetime.date(year = 2021, month = 11, day = 1)] #Limited data available for 11/1/2021 skews results

### Drop unneccessary columns:
df_ts.drop(columns = ['trip_id','trip_end_timestamp','pickup_community_area','dropoff_community_area',
    'pickup_centroid_latitude', 'pickup_centroid_longitude',
    'dropoff_centroid_latitude', 'dropoff_centroid_longitude', 'trip_miles'], inplace = True)

### Create Freq Dict for prophet mapping
freq_dict = {'D':'Days', 'W':'Weeks','M':'Months','Q':'Quarters','Y':'Years'}
#%%
### Create Taxi Forecasts:
def taxi_forecast(location, n_per, f, agg_type, df = df_ts):
    """Using all available taxi data, forecast the number of pickups, dropoffs, or total trips
        in a given zip code or neighborhood, for the number of periods (n_per) and forecast frequency, f ('D','W','M')"""
    #agg_type = 'Total' #was pickup_or_dropoff, options are pickup, dropoff, total
    #n_per = 30
    #f = 'D'
    #location = 60661 #was zip
    df = df_ts.copy()
    loc = str(location)
    agg_type = agg_type.lower()


    if loc.isdigit():
        loc = int(loc)
        df.drop(columns = ['pickup_community','dropoff_community'], inplace=True)
        df.rename(columns={'pickup_zip':'pickup','dropoff_zip':'dropoff'}, inplace=True)
        df = df[(df['pickup'] == loc) | (df['dropoff'] == loc)]
        if agg_type == 'pickup':
            df = df[df['pickup']==loc]
            df_ts_agg = df.groupby('trip_start_timestamp').count()
        elif agg_type == 'dropoff':
            df = df[df['dropoff']==loc]
            df_ts_agg = df.groupby('trip_start_timestamp').count()
        else:
            df_ts_agg = df.groupby('trip_start_timestamp').count()
        
    else:
        df.drop(columns = ['pickup_zip','dropoff_zip'], inplace=True)
        df.rename(columns={'pickup_community':'pickup','dropoff_community':'dropoff'},inplace = True)
        df = df[(df['pickup'] == loc) | (df['dropoff'] == loc)]
        if agg_type == 'pickup':
            df = df[df['pickup']==loc]
            df_ts_agg = df.groupby('trip_start_timestamp').count()
        elif agg_type == 'dropoff':
            df = df[df['dropoff']==loc]
            df_ts_agg = df.groupby('trip_start_timestamp').count()
        else:
            df_ts_agg = df.groupby('trip_start_timestamp').count()

    df_ts_agg.drop(columns = ['pickup'],inplace = True)
    df_ts_agg.reset_index(inplace=True)
    df_ts_agg.rename(columns = {'trip_start_timestamp':'ds','dropoff':'y'}, inplace = True)

    #%%
    #Now train model with Prophet
    m = Prophet(interval_width=0.95, daily_seasonality=True, yearly_seasonality=True)
    model = m.fit(df_ts_agg)
    #Make preductions
    future = m.make_future_dataframe(periods=n_per, freq=f)
    forecast = m.predict(future)
    fig1 = plot_plotly(m, forecast,
                        xlabel='Date',
                        ylabel='{} trips'.format(agg_type))
    fig1.update_layout(
        title = "Taxi Forecast for {}s in {}; Forecasting {} {}".format(agg_type, loc, n_per, freq_dict[f])
    )
    py.iplot(fig1)

    fig2 = plot_components_plotly(m, forecast)
    fig2.update_layout(
        title = """Overall Trend, Weekly and Time of Day Influence of Taxi Trips for {}""".format(loc)
    )
    py.iplot(fig2)

# %%
### Covid-19 Alert
#df2 = taxi_trip data
#df_covid = covid trip data
today = datetime.date.today()
alert_week = datetime.date(today.year,1,3) + relativedelta(weeks=+(today.isocalendar()[1]-1))
# %%
###
dfb = df2.copy()
dfb['iso_year'] = dfb['trip_start_timestamp'].apply(lambda x: x.isocalendar()[0])
dfb['iso_week'] = dfb['trip_start_timestamp'].apply(lambda x: x.isocalendar()[1])
dfb['iso_day'] = dfb['trip_start_timestamp'].apply(lambda x: x.isocalendar()[2])
dfb = dfb[pd.to_datetime(dfb['trip_start_timestamp'],utc = True).dt.date >= datetime.date(year = 2021, month = 1, day = 3)]
### Get Taxi pickups by neighborhood per week:
dfb_pickups = dfb.groupby(['iso_year','iso_week','pickup_community']).count()
dfb_pickups.drop(columns=dfb_pickups.columns[1:], inplace = True)
dfb_pickups.reset_index(inplace=True)
dfb_pickups.rename(columns = {'trip_id':'taxi_pickups','pickup_community':'community'}, inplace=True)

### Get Taxi dropoffs by neighborhood per week:
dfb_dropoffs = dfb.groupby(['iso_year','iso_week','dropoff_community']).count()
dfb_dropoffs.drop(columns=dfb_dropoffs.columns[1:], inplace = True)
dfb_dropoffs.reset_index(inplace = True)
dfb_dropoffs.rename(columns = {'trip_id':'taxi_dropoffs','dropoff_community':'community'}, inplace=True)

### Merge the two tables:
dfa = dfb_dropoffs.merge(dfb_pickups, left_on=['iso_year','iso_week','community'],
                                right_on=['iso_year','iso_week','community'],
                                how = 'outer')
dfa = dfa.fillna(0)
dfa['taxi_trips'] = dfa['taxi_dropoffs']+dfa['taxi_pickups']
dfa.drop(columns=['taxi_dropoffs','taxi_pickups'], inplace = True)
### Turn Iso information to week information:
def f(x):
    return datetime.date.fromisocalendar(x[0],x[1],7)

dfa['week_start'] = dfa.apply(f,axis=1)

dfa.drop(columns = ['iso_year','iso_week'], inplace = True)

# %%
### Creat map of neighborhoods to zipcode
#### ONLY RUN ONCE TO CREATE CSV FILE #####
#def comm_to_zip_dict(df = df2):
#    comm_to_zip = {}
#    for index, row in df.iterrows():
#        comm_to_zip[row['pickup_community']] = row['pickup_zip']
#    return comm_to_zip

#comm_to_zip = comm_to_zip_dict()

#%%
#df_comm_zip = pd.DataFrame()
#df_comm_zip['Communities'] = comm_to_zip.keys()
#df_comm_zip['ZipCodes'] = comm_to_zip.values()
#df_comm_zip.to_csv("CommunitesToZipCodes")

# %%
### Read in CommunitiesToZipCodes file and create mapping dictionary of communities to zip codes
df_comm_zip = pd.read_csv('CommunitesToZipCodes')
df_comm_zip.drop(columns=['Unnamed: 0'],inplace=True)
comm_zip_dict = {}
for index, row in df_comm_zip.iterrows():
    comm_zip_dict[row['Communities']] = row['ZipCodes']

# %%
### Map communities to zipcodes and combine final dataframe for alert function:
dfa['zip'] = dfa['community'].map(comm_zip_dict)
dfa = dfa[['week_start','zip','community','taxi_trips']]
df_covid_2 = df_covid.copy()
df_covid_2['zip'] = df_covid_2['zip'].astype(int)
df_alert = dfa.merge(df_covid_2, left_on=['week_start','zip'],
                         right_on=['week_start','zip'],how='inner')
df_alert.drop(columns=['zip_code_week_start','cases_weekly'], inplace = True)
# %%
### Set up Covid_Alert function based on Taxi Trips and Percent Postive Test Counts
def covid_alert_counts(location, week, df_alert = df_alert):
    
    location = str(location)

    df_week = df_alert[df_alert['week_start']==week]
    df_week['percent_tested_positive_weekly'] = df_week['percent_tested_positive_weekly'].astype(float)

    taxi_trips_25 = df_week['taxi_trips'].quantile(0.25)
    taxi_trips_75 = df_week['taxi_trips'].quantile(0.75)

    perc_pos_25 = df_week['percent_tested_positive_weekly'].quantile(0.25)
    perc_pos_75 = df_week['percent_tested_positive_weekly'].quantile(0.75)

    if location.isdigit():
        df_loc = df_week[df_week['zip'] == int(location)]
        if len(df_loc['community'].unique()) > 1:
            df_loc = df_loc.groupby(['week_start']).agg({'taxi_trips':np.sum,"percent_tested_positive_weekly":np.mean})
            df_loc.reset_index(inplace=True)
    else:
        df_loc = df_week[df_week['community']==location]
    loc_trips = int(df_loc['taxi_trips'].values)
    loc_pos = float(df_loc['percent_tested_positive_weekly'].values)

    if ((loc_trips < taxi_trips_25) and (loc_pos < perc_pos_25)):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:green">LOW</span></h1>

        <h3>For {}, {} had {} taxi trips and {}% positive Covid-19 Tests</h3>
        """.format(location, week, location, loc_trips, loc_pos, week)
    elif ((loc_trips < taxi_trips_25) and (perc_pos_25 <= loc_pos <= perc_pos_75)):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:green">LOW</span></h1>

        <h3>For {}, {} had {} taxi trips and {}% positive Covid-19 Tests</h3>
        """.format(location, week, location, loc_trips, loc_pos)
    elif ((loc_trips < taxi_trips_25) and (loc_pos > perc_pos_75)):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:orange">MEDIUM</span></h1>

        <h3>For {}, {} had {} taxi trips and {}% positive Covid-19 Tests</h3>
        """.format(location, week, location, loc_trips, loc_pos)
    elif ((taxi_trips_25 <= loc_trips <= taxi_trips_75) and (loc_pos < perc_pos_25)):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:green">LOW</span></h1>

        <h3>For {}, {} had {} taxi trips and {}% positive Covid-19 Tests</h3>
        """.format(location, week, location, loc_trips, loc_pos)
    elif ((taxi_trips_25 <= loc_trips <= taxi_trips_75) and (perc_pos_25 <= loc_pos <= perc_pos_75)):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:orange">MEDIUM</span></h1>

        <h3>For {}, {} had {} taxi trips and {}% positive Covid-19 Tests</h3>
        """.format(location, week, location, loc_trips, loc_pos)
    elif ((taxi_trips_25 <= loc_trips <= taxi_trips_75) and (loc_pos > perc_pos_75)):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:red">HIGH</span></h1>

        <h3>For {}, {} had {} taxi trips and {}% positive Covid-19 Tests</h3>
        """.format(location, week, location, loc_trips, loc_pos)
    elif ((loc_trips > taxi_trips_75) and (loc_pos < perc_pos_25)):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:orange">MEDIUM</span></h1>

        <h3>For {}, {} had {} taxi trips and {}% positive Covid-19 Tests</h3>
        """.format(location, week, location, loc_trips, loc_pos)
    elif ((loc_trips > taxi_trips_75) and (perc_pos_25 <= loc_pos <= perc_pos_75)):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:red">HIGH</span></h1>

        <h3>For {}, {} had {} taxi trips and {}% positive Covid-19 Tests</h3>
        """.format(location, week, location, loc_trips, loc_pos)
    elif ((loc_trips > taxi_trips_75) and (loc_pos > perc_pos_75)):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:red">HIGH</span></h1>

        <h3>For {}, {} had {} taxi trips and {}% positive Covid-19 Tests</h3>
        """.format(location, week, location, loc_trips, loc_pos)

    return msg
# %%
### Set up Covid_Alert Function Based on relative rates of taxi trips and Covid-19 in the location:
def covid_alert_relative(location, week, df_alert = df_alert):

    location = str(location)
    delta = 7
    td = datetime.timedelta(delta)
    week_1 = week - td

    df_rel = df_alert[(df_alert['week_start'] == week) | (df_alert['week_start'] == week_1)]

    if location.isdigit():
        df_rel = df_rel[df_rel['zip'] == int(location)]
        if len(df_rel['community'].unique()) > 1:
            df_rel['percent_tested_positive_weekly'] = df_rel['percent_tested_positive_weekly'].astype(float)
            df_rel = df_rel.groupby(['week_start']).agg({'taxi_trips':np.sum,"percent_tested_positive_weekly":np.mean})
            df_rel.reset_index(inplace=True)
    else:
        df_rel = df_rel[df_rel['community']==location]

    taxi_chg = round(((int(df_rel['taxi_trips'][df_rel['week_start']==week])-int(df_rel['taxi_trips'][df_rel['week_start']==week_1]))/(int(df_rel['taxi_trips'][df_rel['week_start']==week_1])))*100,1)
    perc_pos_chg = round(float(df_rel['percent_tested_positive_weekly'][df_rel['week_start']==week])-float(df_rel['percent_tested_positive_weekly'][df_rel['week_start']==week_1]),3)

    if ((taxi_chg < -10) and (perc_pos_chg < 0)):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:green">LOW</span></h1>

        <h3>For {}, {} had {}% change in taxi trips and {}% decrease in positive Covid-19 Tests</h3>
        """.format(location, week, location, taxi_chg, perc_pos_chg, week)
    elif ((taxi_chg < -10) and ( perc_pos_chg == 0 )):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:green">LOW</span></h1>

        <h3>For {}, {} had {}% change in taxi trips and no change in positive Covid-19 Tests</h3>
        """.format(location, week, location, taxi_chg)
    elif ((taxi_chg < -10) and (perc_pos_chg > 0)):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:orange">MEDIUM</span></h1>

        <h3>For {}, {} had {}% change in taxi trips and {}% increase in positive Covid-19 Tests</h3>
        """.format(location, week, location, taxi_chg, perc_pos_chg)
    elif ((-10 <= taxi_chg <= 10) and (perc_pos_chg < 0)):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:green">LOW</span></h1>

        <h3>For {}, {} had {}% change in taxi trips and {}% decrease in positive Covid-19 Tests</h3>
        """.format(location, week, location, taxi_chg, perc_pos_chg)
    elif ((-10 <= taxi_chg <= 10) and (perc_pos_chg == 0 )):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:orange">MEDIUM</span></h1>

        <h3>For {}, {} had {}% change in taxi trips and no change in positive Covid-19 Tests</h3>
        """.format(location, week, location, taxi_chg)
    elif ((-10 <= taxi_chg <= 10) and (perc_pos_chg > 0)):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:red">HIGH</span></h1>

        <h3>For {}, {} had {}% change in taxi trips and {}% increase in positive Covid-19 Tests</h3>
        """.format(location, week, location, taxi_chg, perc_pos_chg)
    elif ((taxi_chg > 10) and (perc_pos_chg < 0)):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:orange">MEDIUM</span></h1>

        <h3>For {}, {} had {}% change in taxi trips and {}% decrease in positive Covid-19 Tests</h3>
        """.format(location, week, location, taxi_chg, perc_pos_chg)
    elif ((taxi_chg > 10) and (perc_pos_chg == 0 )):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:red">HIGH</span></h1>

        <h3>For {}, {} had {}% change in taxi trips and no change in positive Covid-19 Tests</h3>
        """.format(location, week, location, taxi_chg)
    elif ((taxi_chg > 10) and (perc_pos_chg > 0)):
        msg = """
        <h1>COVID-19 Alert for {} is <span style="color:red">HIGH</span></h1>

        <h3>For {}, {} had {}% change in taxi trips and {}% increase in positive Covid-19 Tests</h3>
        """.format(location, week, location, taxi_chg, perc_pos_chg)
    return msg
# %%
#random.seed(0)
#weeks = list(df_alert['week_start'].unique())
#week = random.choice(weeks)
#locations = list(df_alert['zip'].unique())
#location = random.choice(locations)

#location = 60608
#week = datetime.date(year = 2021, month = 10, day = 3)
# %%
