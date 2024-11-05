# speed_stats.R

depth = read.csv("F:/Zc_Analysis/speed/speeds_atDepth.csv")
desc = read.csv("F:/Zc_Analysis/speed/speeds_descending.csv")

# test to see if median speeds are different per site
depth$site = as.factor(depth$site)
kruskal.test(median~site, data=depth)
dunnTest(median~site, data=depth,
         method="bh")
# Comparison          Z      P.unadj        P.adj
# 1      1 - 2 -3.6339916 2.790699e-04 0.0008372097 # W different to H
# 2      1 - 3 -4.0866813 4.375875e-05 0.0002625525 # W different to E
# 3      2 - 3 -1.5617995 1.183352e-01 0.1775028357 # H same as E
# 4      1 - 4 -0.8288881 4.071678e-01 0.4071677560 # W same as N
# 5      2 - 4  0.9207756 3.571676e-01 0.4286011270 # H same as N
# 6      3 - 4  1.8683659 6.171109e-02 0.1234221794 # E same as N

# test to see if median speeds are different between initial descents and foraging
data = c(depth$median,desc$median)
depthcode = rep(1,nrow(depth))
descode = rep(2,nrow(desc))
codes = c(depthcode,descode)
data = data.frame(data,codes)

data$codes = as.factor(data$codes)
kruskal.test(data~codes,data=data)
# Kruskal-Wallis rank sum test
# 
# data:  data by codes
# Kruskal-Wallis chi-squared = 0.24115, df = 1, p-value = 0.6234
# NOT significantly different

# but are the standard deviations different?
data = c(depth$std,desc$std)
depthcode = rep(1,nrow(depth))
descode = rep(2,nrow(desc))
codes = c(depthcode,descode)
data = data.frame(data,codes)

data$codes = as.factor(data$codes)
kruskal.test(data~codes,data=data)
# Kruskal-Wallis rank sum test
# 
# data:  data by codes
# Kruskal-Wallis chi-squared = 0.37831, df = 1, p-value = 0.5385
# also no difference here


