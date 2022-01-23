#%%
### Load in Libraries:
import pandas as pd
import psycopg2 
import numpy as np

#%%
def req_5():
    ### Call in data for top 5 neighborhoods with highest unemployment AND Poverty Rates
    conn = psycopg2.connect(
        host='localhost',
        database = 'CBI',
        user='postgres',
        password="MounT@inM@n1992",
        port = '5433'
    )

    cur = conn.cursor()

    sql="""SELECT community_area_name, percent_aged_16_unemployed, percent_households_below_poverty
    FROM public.socio_economic_data
    ORDER BY percent_aged_16_unemployed DESC,
            percent_households_below_poverty DESC
    LIMIT 5;
    """

    cur.execute(sql)

    data = cur.fetchall()


    df_soc = pd.DataFrame(data = data,
                        columns = ['Community', 'Unemployment [%]', 'Percent Below Poverty [%]'])
    df_soc.index += 1

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
    ### Style the table for publishing:
    soc = df_soc.style

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

    soc.set_caption("Chicago's Top 5 Neighborhoods with Highest Unemplotyment and Poverty Rates")\
        .set_table_styles([row_hover, headers, blank])
    
    # %%
    ### Pull in Building Permit data:
    conn = psycopg2.connect(
        host='localhost',
        database = 'CBI',
        user='postgres',
        password="MounT@inM@n1992",
        port = '5433'
    )

    cur = conn.cursor()

    sql ="""SELECT permit_, community_area, issue_date, reported_cost
        FROM public.building_permits
        ORDER BY issue_date DESC;"""

    cur.execute(sql)

    data = cur.fetchall()
    cur.close()
    df_p5 = pd.DataFrame(data = data,
                        columns = ["permit","community_area","issue_date","reported_cost"])

    #%%
    ### Identify Number of permits per community area and total permit costs:
    df_p5['Community'] = df_p5['community_area'].map(ca_dict)

    list_of_communities = []
    for i in df_soc['Community']:
        list_of_communities.append(i.upper())

    df_p5 = df_p5[df_p5['Community'].isin(list_of_communities)]
    df_p5_agg = df_p5.groupby('Community').agg({'permit': np.count_nonzero, 'reported_cost': np.sum})
    df_p5_agg = df_p5_agg.rename(columns = {'permit':"# of Permits","reported_cost":"Total Permit Fees"})
    df_p5_agg['Total Permit Fees'] = df_p5_agg['Total Permit Fees'].apply(lambda x: "${:,.2f}".format(x))
    df_p5_agg = df_p5_agg.reindex(index = df_soc['Community'].str.upper())
    # %%
    ### Style the resultant data frame:
    df_p5_aggstyle = df_p5_agg.style

    ind = {
        'selector':'.index_name',
        'props': [('background-color', 'black'), ('color', 'white')]
    }

    df_p5_aggstyle.set_caption("# of Permits and Total Permit Fees in Chicago's Top 5 Impoverished Neighborhoods").\
        set_table_styles([row_hover, headers, blank, ind])

    df_soc_html = df_soc.to_html()

    html_1 = """
    <h1>Chicago Industrial and Neighborhood Infrastructure Investment Dashboard</h1>

    <h3>Top 5 Neighborhoods with Highest Unemployment and Poverty Rates</h3>

    """

    html_2 = """
    <h3>Number of Permits and Total Permit Fees in Chicago's Top 5 Impoverished Neighborhoods</h3>
    """
    df_p5_agg_html = df_p5_agg.to_html()

    html_out = html_1 + df_soc_html + html_2 + df_p5_agg_html

    return html_out

