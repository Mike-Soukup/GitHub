#* Three repetitions of the vector c(2, -5.1, -23).
#* #* The arithmetic sum of 7/42, 3 and 35/42
#* 

x <- seq(from = -2, to = 2, length = 4001)
y <- trig.func(x)
y.max <- max(y)
location.ymax <- y == y.max
x.value.ymax <- x[location.ymax]

trig.func(x.value.ymax)
trees <- data(trees)
