#Read in home price data
hp <- read.csv('/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Module 2/home_prices.csv', 
               sep = ",")
str(hp)

#Exercise 1
#Part a.
price <- hp$PRICE
hist(price)
#The shape is right or positive skewed. The shape is unimodal

#Part b.
tax <- hp$TAX
hist(tax)
#The shape is very similar to the price histogram.
#The shape is right/positive skewed and unimodal.

#Part c.
plot(x = tax, y = price, xlab = 'Tax $', ylab = 'Price ($hundreds)',
     main = 'TAX versus PRICE')
#Looking at the Tax vs. Price scatter plot, there appears to be a strong
#relationship between these two variables.

#Part d.
stem(tax)

#Part e.
par(mfrow = c(2,1))
hist(price)
hist(tax)
par(mfrow = c(1,1))

#Exercise 2
b <- seq(from = 1300, to = max(price) + 600 , by = 600)
bb <- c(1300,1900,2500,3100,3700,4300,4900,5500)
hist(price, breaks = b, right = FALSE)

with(hp, hist(PRICE, breaks = c(1300,1900,2500,3100,3700,4300,4900,5500)))

#Part b.
b1 <- seq(from = 500, to = max(tax) + 500, by = 500)
hist(tax, breaks = b1)

with(hp, hist(TAX, breaks = b1))