#%%
### Load in Libraries:
import pandas as pd
import psycopg2 
import numpy as np

# %%
def req_6():
    ### Pull in all permits with permit_type = PERMIT - NEW CONSTRUCTION
    conn = psycopg2.connect(
        host='localhost',
        database = 'CBI',
        user='postgres',
        password="MounT@inM@n1992",
        port = '5433'
    )

    cur = conn.cursor()
    sql = """
        SELECT community_area, reported_cost
        FROM public.building_permits
        WHERE permit_type = 'PERMIT - NEW CONSTRUCTION'
        ORDER BY issue_date DESC;
    """
    cur.execute(sql)
    data = cur.fetchall()

    df_nc = pd.DataFrame(data = data,
                        columns = ['community_area', 'reported_cost'])

    sql_soc = """
    SELECT ca, per_capita_income_
        FROM public.socio_economic_data
        ORDER BY per_capita_income_ ASC;
    """

    cur.execute(sql_soc)

    data_soc = cur.fetchall()
    df_soc = pd.DataFrame(data = data_soc,
                        columns = ['community_area','per_capita_income'])

    sql_ca = """
    SELECT *
    FROM community_areas;
    """
    cur.execute(sql_ca)
    data_ca = cur.fetchall()
    df_ca = pd.DataFrame(data = data_ca,
                        columns = ['community_area_number','community'])
    ca_dict = {}

    for index, row in df_ca.iterrows():
        ca_dict[row[0]] = row[1]

    cur.close()

    #%%
    ### Convert both New Construction and Per Capita Income data frames to include Community Names
    df_nc['community'] = df_nc['community_area'].map(ca_dict)
    df_soc['community'] = df_soc['community_area'].map(ca_dict)

    # %%
    ### Filter df_soc to only include areas with per_capita_income < 30,000
    df_soc = df_soc[df_soc['per_capita_income'] < 30000]
    # %%
    ### Filter out high per_capita_income communities from New Constructions Table:
    low_percap_areas = df_soc['community_area'].unique()
    df_nc = df_nc[df_nc['community_area'].isin(low_percap_areas)]
    # %%
    ### Aggregate new constructions dataframe to count the number of permits in each community
    df_nc_agg = df_nc.groupby('community').agg({'reported_cost':[np.count_nonzero, np.sum]})
    df_nc_agg.columns = ['# New Construction Permits','Permit Costs']
    df_nc_agg.index.names = ['Community']
    df_nc_agg = df_nc_agg.sort_values(by = '# New Construction Permits', ascending= True)
    df_nc_agg['Permit Costs'] = df_nc_agg['Permit Costs'].apply(lambda x: "${:,.2f}".format(x))
    df_nc_10 = df_nc_agg.head(10)
    # %%
    ### Style the resultant table:
    df_nc_10_style = df_nc_10.style

    row_hover = {  # for row hover use <tr> instead of <td>
        'selector': 'tr:hover',
        'props':[('color','black'),('background-color', '#FFFF00'),('opacity','.5')]
    }
    headers = {
        'selector': 'th.col_heading',
        'props': [('background-color', 'black'), ('color', 'white')]
    }

    blank = {
        'selector':'th.blank',
        'props': [('background-color', 'black'), ('color', 'white')]
    }
    ind = {
        'selector':'.index_name',
        'props': [('background-color', 'black'), ('color', 'white')]
    }
    df_nc_10_style.set_caption("Communities with least amount of New Construction Permits and Per Capita Incomes < $30,000").\
        set_table_styles([row_hover, headers, blank, ind])
    
    html_1 = """
    <h1>Illinois Small Business Emergency Loan Fund Delta Dashboard</h1>
    <h3>Top 10 Communities with Per Capita Income < $30,000 and Lowest Number of New Construction Permits:</h3>
    """

    df_nc_10_html = df_nc_10.to_html()

    html_out = html_1 + df_nc_10_html

    return html_out
# %%
