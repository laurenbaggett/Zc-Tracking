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

# data = subset(data,avg>-0)

# ggbetweenstats(data = data,
#                x = site,
#                y = avg)

data$site = factor(data$site, levels = c("W","H","E","N"))

medians <- data %>%
  group_by(site) %>%
  summarise(med = median(avg))

ggplot(data, aes(x = as.factor(site), y=avg, color=site)) +
  geom_violin(width=1, aes(fill=site), show.legend = FALSE) +
  geom_boxplot(width=0.15, color="black", fill="white") +
  theme_classic() +
  xlab("Site") +
  ylab("Average Distance Above Seafloor (m)") +
  stat_summary(fun.y="mean", geom="point", size=2, show.legend=FALSE) +
  geom_text(data=medians, aes(x=factor(site), y=med, label=round(med,1)),
            hjust=-.35, vjust = -0.5, color="black")
  

# run kruskal-wallis
# h0: there is no difference in average dive depths per site
# h1: there is a difference in average dive depths per site
kruskal.test(avg~site, data=data)
# p-value < 2.2e-16
# p-value < 0.05, reject the null

# now, a post-hoc test
dunnTest(avg~site, data=data,
         method="bh")

# Comparison          Z      P.unadj        P.adj
# 1      E - H -11.293490 1.413114e-29 8.478686e-29
# 2      E - N  -7.304241 2.788354e-13 5.576707e-13
# 3      H - N  -0.187226 8.514835e-01 8.514835e-01 # not different
# 4      E - W  -6.834024 8.256511e-12 1.238477e-11
# 5      H - W   7.590824 3.178772e-14 9.536317e-14
# 6      N - W   4.323790 1.533712e-05 1.840454e-05
