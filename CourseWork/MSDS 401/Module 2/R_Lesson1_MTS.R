hp <- read.csv('/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Module 2/home_prices.csv', 
               sep = ",")
str(hp)

#PRICE = Selling Price ($hundreds)
#SQFT = Square feet of living space
#YEAR = Year of construction
#BATHS = Number of bathrooms
#FEATS = Number of features out of 11 max
#NBR = Located in northeast sector of city Y/N
#Corner = Corner location Y/N
#TAX = annual taxes $

# Part a. Measurement levels
  #Price =  Ratio
  #Sqft = Ratio
  #Year = Interval
  #Baths = Ordinal
  #Feats = Ratio
  #NBR = Nominal
  #Corner = Nominal 
  #Tax = Ratio
#Part b. Should any variable have its values changed to better reflect its true nature?
#Year could be given to reflect the age of the house instead of year of construction
#Baths could be expressed in terms of an ordered scale as long as each categore in the scale had a definition

#Part c.

SRS <- sample(hp$PRICE,12,replace = FALSE)
print(SRS)
mean(SRS)

price <- hp$PRICE
set.seed(9999)
SRS <- sample(price,12,replace = FALSE)
print(SRS)
mean(SRS)

#Part d.
S <- seq(from = 7, to = 117, by = 10)
SS <- price[S]
print(SS)
mean(SS)

#Part e.Examine the printed values and means obtained from the two sampling processes.
#Do you see a difference? Try the commands summary(SRS) and summary(SS)

print(SRS)
print(SS)
mean(SRS)
mean(SS)
summary(SRS)
summary(SS)
hist(SRS)
hist(SS)

#Part f. Compare SRS and SS with histograms and stem-and-leaf plots
hist(SRS)
hist(SS)

stem(SRS)
stem(SS)

par(mfrow = c(1,2))
hist(SRS)
hist(SS)
par(mfrow = c(1,1))
