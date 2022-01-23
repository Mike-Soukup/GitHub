import datetime
from flask import Flask, redirect, render_template, request, url_for
import datetime
import sys
from logging import FileHandler,WARNING

from numpy.lib.twodim_base import tri
from numpy.lib.type_check import asfarray
from taxi_reqs import chicago_covid19_html
from taxi_reqs import carrier_notification_html
from taxi_reqs import trips_airport_to_zipcode_clustermap_html
from taxi_reqs import trips_to_percent_positive
from taxi_reqs import trips_and_high_ccvi_areas
from taxi_reqs import taxi_forecast
from taxi_reqs import covid_alert_counts
from taxi_reqs import covid_alert_relative
from requirement_5 import req_5
from requirement_6 import req_6

app = Flask(__name__)

file_handler = FileHandler('errorlog.txt')
file_handler.setLevel(WARNING)

@app.route("/")
def welcome():
    return """
    <h1>Welcome to the CBI Business Intelligence Dashboard</h1>
    <h3>To view the Covid-19 Heat Map pass: /covid19_map</h3>
    <p>Can also pass /covid19_map/yyyy-mm-dd into URL to directly pull the Covid-19 Heat Map</p>
    <ul> 
        <li> Week must be the start of a week in 2021; Week start is on a Sunday </li>
        <li> Week must be provided in YYYY-MM-DD format </li>
    </ul>
    <h3>To see a random taxi/uber trip pass: /carrier_notification </h3>
    <h3>To see the cluster map of taxi trips from airports pass: /airport_cluster </h3>
    <p>Can also pass /airport_cluster/yyyy-mm-dd into URL to directly pull the Airport Cluster Map for a given week</p>
    <h3>To see how taxi trips from airports correlate to Covid-19 % Positive Tests for a given week pass: /correlation </h3>
    <h3>To view trips from and to HIGH CCVI areas pass: /ccvi_trips </h3>
    <h3>To view Taxi Forecasts for a given ZipCode pass: /taxi_forecasting</h3>
    <p>Can also pass /taxi_forecasting/zip/number of periods/frequency/pickup or dropoff for direct access</p>
    <ul> 
        <li> zip = ZipCode and must be an integer value </li>
        <li> number of periods = number of periods to be forecasted out </li>
        <li> frequency = D for Days, W for Weeks, Y for Years, M for Months, and Q for Quarters</li>
        <li> pickup or dropoff = enter either pickup or dropoff to select what trip type to view for the ZipCode</li>
    </ul>
    <h3>View Chicago's Top 5 Most Impoverished Communities and their Perimitting records pass: /infrastructure_investment</h3>
    <h3>View the Illinois Small Business Emergency Loan Fund Delta Dashboard pass: /little_guys</h3>
    <h3>To Get Covid-19 Alerts for your community based on counts of Taxi Trips and Percent Positive Covid-19 Tests pass: /covid_alert_counts</h3>
    <h3>To Get Covid-19 Alerts for your community based on relative amounts of Taxi Trips and Percent Positive Covid-19 Tests pass: /covid_alert_relative</h3>
    """

@app.route("/covid19_map", methods = ["GET","POST"])
def get_cov19_week():
    if request.method == 'POST':
        week = str(request.form["ws"])
        return redirect(url_for("chicago_covid19_by_week_map", week = week))
    else:
        return render_template("datepicker.html")
    
@app.route("/covid19_map/<string:week>")
def chicago_covid19_by_week_map(week):
    try:
        if week is not None:
                year = int(week[:4])
                month = int(week[5:7])
                day = int(week[-2:])
                week_feed = datetime.date(year = year, month = month, day = day)
                return chicago_covid19_html(week = week_feed)
    except:
        msg = """
        <h2>Error in API call!</h2>
        <p>Please be sure to enter week start date in the following form YYYY-MM-DD</p>
        <p>Also be sure a week start is provided. I.e. Date entered is a Sunday</p>
        <p>Date may be out of range!</p>
        """
        return msg

@app.route("/carrier_notification")
def taxi_tracking():
    return carrier_notification_html()

@app.route("/airport_cluster", methods = ["GET","POST"])
def get_airportcluster_week():
    if request.method == 'POST':
        week = str(request.form["ws"])
        return redirect(url_for("airport_tracking", week = week))
    else:
        return render_template("datepicker.html")

@app.route("/airport_cluster/<string:week>")
def airport_tracking(week):
    try:
        if week is not None:
                year = int(week[:4])
                month = int(week[5:7])
                day = int(week[-2:])
                week_feed = datetime.date(year = year, month = month, day = day)
                return trips_airport_to_zipcode_clustermap_html(week = week_feed)
    except:
        msg = """
        <h2>Error in API call!</h2>
        <p>Please be sure to enter week start date in the following form YYYY-MM-DD</p>
        <p>Also be sure a week start is provided. I.e. Date entered is a Sunday</p>
        <p>Date may be out of range!</p>
        """
        return msg

@app.route("/correlation", methods = ["GET","POST"])
def get_correlation_week():
    if request.method == 'POST':
        week = str(request.form["ws"])
        return redirect(url_for("correlation", week = week))
    else:
        return render_template("datepicker.html")

@app.route("/correlation/<string:week>")
def correlation(week):
    try:
        if week is not None:
                year = int(week[:4])
                month = int(week[5:7])
                day = int(week[-2:])
                week_feed = datetime.date(year = year, month = month, day = day)
                trips_to_percent_positive(week = week_feed)
                return render_template("see_popup.html")

    except:
         msg = """
        <h2>Error in API call!</h2>
        <p>Please be sure to enter week start date in the following form YYYY-MM-DD</p>
        <p>Also be sure a week start is provided. I.e. Date entered is a Sunday</p>
        <p>Date may be out of range!</p>
        """
    return msg


@app.route("/ccvi_trips")
def ccvi_trips_2021():
    trips_and_high_ccvi_areas()
    return render_template("see_popup.html")

@app.route("/taxi_forecasting", methods = ["GET","POST"])
def get_taxi_forecast_info():
    if request.method == 'POST':
        z = str(request.form['zips'])
        c = str(request.form['comms'])
        n = int(request.form["n_per"])
        f = str(request.form["f"])
        a = str(request.form["p_or_d"])
        if len(z) > 0:
            loc = z
        elif len(c) > 0:
            loc = c
        else:
            #Set Default Location:
            loc = str(60661)
        return redirect(url_for('taxi_forecast_long_url', location = loc, n_per = n, freq = f, agg_type = a))
    else:
        return render_template("taxi_forecast.html")

@app.route("/taxi_forecasting/<string:location>/<int:n_per>/<string:freq>/<string:agg_type>")
def taxi_forecast_long_url(location, n_per, freq, agg_type):
    taxi_forecast(location=location, n_per=n_per, f=freq,agg_type=agg_type)
    return render_template("see_popup.html")

@app.route("/infrastructure_investment")
def infrastructure_investment():
    return req_5()

@app.route("/little_guys")
def little_guys():
    return req_6()

@app.route("/covid_alert_counts", methods = ["GET","POST"])
def get_covid_alert_counts_info():
    if request.method == 'POST':
        week_feed = str(request.form["ws"])
        zip = str(request.form['zips'])
        c = str(request.form['comms'])
        if len(zip) > 0:
            loc = zip
        elif len(c) > 0:
            loc = c
        else:
            msg = """
        <h2>Error in API call!</h2>
        <p>Please be sure to enter week start date in the following form YYYY-MM-DD</p>
        <p>Also be sure a week start is provided. I.e. Date entered is a Sunday</p>
        <p>Date may be out of range!</p>
        """
            return msg
        return redirect(url_for('covid_alert_counts_html', location = loc, week = week_feed))
    else:
        return render_template("taxi_alert_counts.html")

@app.route("/covid_alert_counts/<string:location>/<string:week>")
def covid_alert_counts_html(location, week):
    try:
        if week is not None:
            year = int(week[:4])
            month = int(week[5:7])
            day = int(week[-2:])
            week_feed = datetime.date(year = year, month = month, day = day)
            return covid_alert_counts(location = location, week = week_feed)

    except:
         msg = """
        <h2>Error in API call!</h2>
        <p>Please be sure to enter week start date in the following form YYYY-MM-DD</p>
        <p>Also be sure a week start is provided. I.e. Date entered is a Sunday</p>
        <p>Date may be out of range!</p>
        """
    return msg

@app.route("/covid_alert_relative", methods = ["GET","POST"])
def get_covid_alert_relative_info():
    if request.method == 'POST':
        week_feed = str(request.form["ws"])
        zip = str(request.form['zips'])
        c = str(request.form['comms'])
        if len(zip) > 0:
            loc = zip
        elif len(c) > 0:
            loc = c
        else:
            msg = """
        <h2>Error in API call!</h2>
        <p>Please be sure to enter week start date in the following form YYYY-MM-DD</p>
        <p>Also be sure a week start is provided. I.e. Date entered is a Sunday</p>
        <p>Date may be out of range!</p>
        """
            return msg
        return redirect(url_for('covid_alert_relative_html', location = loc, week = week_feed))
    else:
        return render_template("taxi_alert_counts.html")

@app.route("/covid_alert_relative/<string:location>/<string:week>")
def covid_alert_relative_html(location, week):
    try:
        if week is not None:
            year = int(week[:4])
            month = int(week[5:7])
            day = int(week[-2:])
            week_feed = datetime.date(year = year, month = month, day = day)
            return covid_alert_relative(location = location, week = week_feed)

    except:
         msg = """
        <h2>Error in API call!</h2>
        <p>Please be sure to enter week start date in the following form YYYY-MM-DD</p>
        <p>Also be sure a week start is provided. I.e. Date entered is a Sunday</p>
        <p>Date may be out of range!</p>
        """
    return msg
