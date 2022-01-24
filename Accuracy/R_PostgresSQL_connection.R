#Load in the packages necessary to connect to PostgresDB
library(RPostgres)
library(DBI)

#Define the database specific information
db <- 'Accuracy'
host_db <- 'localhost'
db_port <- 5432
db_user <- 'postgres'
db_password <- 'iamgreat'

#establish connection to database
con <- dbConnect(RPostgres::Postgres(), dbname = db, host=host_db, port=db_port,
                 user=db_user, password=db_password)  

#check if connection is established
###dbListTables(con)

#Test Query
df <- dbGetQuery(con, 'SELECT * 
                       FROM public.daily_bags_toss
                       WHERE id = 1
                       ORDER BY "Date" ASC' )

dates <- df$Date
made <- df$Made

plot(dates, made, type = "b", 
     main = 'Bag Results out of 100 by Date',
     ylim = c(0,1.15*max(made)),
     color = 'black',
     pch = 16)
abline(h = mean(made), col = 'red',
       lty = 2)