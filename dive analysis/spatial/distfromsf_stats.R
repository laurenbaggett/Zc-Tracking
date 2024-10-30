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
library(ggstatsplot)

# load in the data
h = read.csv("F:/Tracking/Erics_detector/siteH_disffromsf_masterTable_NEW.csv")
h = h[which(h[,3]!=1),]
h = h[which(h[,3]!=4),]
# h = h[which(h[,3]!=2),]
# h = h[-(which(h$avg>470)),]
e = read.csv("F:/Tracking/Erics_detector/siteE_disffromsf_masterTable_NEW.csv")
e = e[which(e[,3]!=1),]
e = e[which(e[,3]!=4),]
# e = e[which(e[,3]!=2),]
# e = e[-(which(e$avg>500)),]
n = read.csv("F:/Tracking/Erics_detector/siteN_disffromsf_masterTable_NEW.csv")
n = n[which(n[,3]!=1),]
n = n[which(n[,3]!=4),]
# n = n[which(n[,3]!=2),]
# n = n[-(which(n$avg>500)),]
w = read.csv("F:/Tracking/Erics_detector/siteW_disffromsf_masterTable_NEW.csv")
w = w[which(w[,3]!=1),]
w = w[which(w[,3]!=4),]
# w = w[which(w[,3]!=2),]
# w = w[-(which(w$avg< -50)),]


# make boxplots to visualize
sh = data.frame(matrix(NA, nrow = nrow(h), ncol = 2))
sh[,1] = h$avg
sh[,2] = c("H");
sh[,3] = h$clss
eh = data.frame(matrix(NA, nrow = nrow(e), ncol = 2))
eh[,1] = e$avg
eh[,2] = c("E");
eh[,3] = e$clss
nh = data.frame(matrix(NA, nrow = nrow(n), ncol = 2))
nh[,1] = n$avg
nh[,2] = c("N");
nh[,3] = n$clss
wh = data.frame(matrix(NA, nrow = nrow(w), ncol = 2))
wh[,1] = w$avg
wh[,2] = c("W");
wh[,3] = w$clss
data = rbind(sh,eh,nh,wh)
colnames(data) = c("avg","site","class")
data$site = as.factor(data$site)

data = subset(data,avg>-0)

ggbetweenstats(data = data,
               x = site,
               y = avg)

data$site = factor(data$site, levels = c("W","H","E","N"))

ggplot(data, aes(x = as.factor(site), y=avg, color=site)) +
  geom_violin(width=1) +
  geom_boxplot(width=0.1) +
  theme_classic() +
  xlab("Site") +
  ylab("Average Distance Above Seafloor (m)") +
  stat_summary(fun.y="mean", geom="point", size=2, color="red")
  

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
# 1      E - H -12.4650054 1.158639e-35 6.951836e-35
# 2      E - N  -8.3948476 4.664990e-17 9.329980e-17
# 3      H - N  -0.9798838 3.271435e-01 3.271435e-01 # not different
# 4      E - W  -6.1036173 1.036944e-09 1.244333e-09
# 5      H - W   9.6714486 3.986940e-22 1.196082e-21
# 6      N - W   6.1115053 9.869574e-10 1.480436e-09
