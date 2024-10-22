## distfromsf_stats
# LMB 3/13/24
# this script will run statistical analysis for distance from seafloor calculations

# load libraries
library(ggplot2)
library(dplyr)
library(forcats)
library(hrbrthemes)
library(viridis)
library(FSA)

# load in the data
h = read.csv("F:/Tracking/Erics_detector/siteH_disffromsf_masterTable.csv")
h = h[which(h[,3]!=1),]
h = h[which(h[,3]!=4),]
# h = h[which(h[,3]!=2),]
# h = h[-(which(h$avg>470)),]
e = read.csv("F:/Tracking/Erics_detector/siteE_disffromsf_masterTable.csv")
e = e[which(e[,3]!=1),]
e = e[which(e[,3]!=4),]
# e = e[which(e[,3]!=2),]
# e = e[-(which(e$avg>500)),]
n = read.csv("F:/Tracking/Erics_detector/siteN_disffromsf_masterTable.csv")
n = n[which(n[,3]!=1),]
n = n[which(n[,3]!=4),]
# n = n[which(n[,3]!=2),]
# n = n[-(which(n$avg>500)),]
w = read.csv("F:/Tracking/Erics_detector/siteW_disffromsf_masterTable.csv")
w = w[which(w[,3]!=1),]
w = w[which(w[,3]!=4),]
# w = w[which(w[,3]!=2),]
w = w[-(which(w$avg< -50)),]


# make boxplots to visualize
sh = data.frame(matrix(NA, nrow = nrow(h), ncol = 2))
sh[,1] = h$avg
sh[,2] = c("H");
eh = data.frame(matrix(NA, nrow = nrow(e), ncol = 2))
eh[,1] = e$avg
eh[,2] = c("E");
nh = data.frame(matrix(NA, nrow = nrow(n), ncol = 2))
nh[,1] = n$avg
nh[,2] = c("N");
wh = data.frame(matrix(NA, nrow = nrow(w), ncol = 2))
wh[,1] = w$avg
wh[,2] = c("W");
data = rbind(sh,eh,nh,wh)
colnames(data) = c("avg","site")
data$site = as.factor(data$site)

# remove spurious values
# data = subset(data, avg>-50)

ggplot(data, aes(x = as.factor(site), y=avg, color=site)) +
  geom_boxplot() +
  theme_classic() +
  xlab("Site") +
  ylab("Average Distance Above Seafloor (m)")
  

# run kruskal-wallis
# h0: there is no difference in average dive depths per site
# h1: there is a difference in average dive depths per site
kruskal.test(avg~site, data=data)
# p-value < 2.2e-16
# p-value < 0.05, reject the null

# now, a post-hoc test
dunnTest(avg~site, data=data,
         method="bh")

# Comparison           Z      P.unadj        P.adj
# 1      E - H -12.5094129 6.631249e-36 3.978750e-35
# 2      E - N  -8.4592932 2.690029e-17 5.380058e-17
# 3      H - N  -0.9870206 3.236325e-01 3.236325e-01
# 4      E - W  -5.3346141 9.574797e-08 1.148976e-07
# 5      H - W  10.3654095 3.562292e-25 1.068688e-24
# 6      N - W   6.5271312 6.704132e-11 1.005620e-10
