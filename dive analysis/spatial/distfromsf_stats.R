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

# # load in the data
# h = read.csv("F:/Tracking/Erics_detector/siteH_disffromsf_masterTable_NEW.csv")
# h = h[which(h[,3]!=1),]
# h = h[which(h[,3]!=4),]
# # h = h[which(h[,3]!=2),]
# # h = h[-(which(h$avg>470)),]
# e = read.csv("F:/Tracking/Erics_detector/siteE_disffromsf_masterTable_NEW.csv")
# e = e[which(e[,3]!=1),]
# e = e[which(e[,3]!=4),]
# # e = e[which(e[,3]!=2),]
# # e = e[-(which(e$avg>500)),]
# n = read.csv("F:/Tracking/Erics_detector/siteN_disffromsf_masterTable_NEW.csv")
# n = n[which(n[,3]!=1),]
# n = n[which(n[,3]!=4),]
# # n = n[which(n[,3]!=2),]
# # n = n[-(which(n$avg>500)),]
# w = read.csv("F:/Tracking/Erics_detector/siteW_disffromsf_masterTable_NEW.csv")
# w = w[which(w[,3]!=1),]
# w = w[which(w[,3]!=4),]
# # w = w[which(w[,3]!=2),]
# # w = w[-(which(w$avg< -50)),]


# # make boxplots to visualize
# sh = data.frame(matrix(NA, nrow = nrow(h), ncol = 2))
# sh[,1] = h$avg
# sh[,2] = c("H");
# sh[,3] = h$clss
# eh = data.frame(matrix(NA, nrow = nrow(e), ncol = 2))
# eh[,1] = e$avg
# eh[,2] = c("E");
# eh[,3] = e$clss
# nh = data.frame(matrix(NA, nrow = nrow(n), ncol = 2))
# nh[,1] = n$avg
# nh[,2] = c("N");
# nh[,3] = n$clss
# wh = data.frame(matrix(NA, nrow = nrow(w), ncol = 2))
# wh[,1] = w$avg
# wh[,2] = c("W");
# wh[,3] = w$clss
# data = rbind(sh,eh,nh,wh)
# colnames(data) = c("avg","site","class")
# data$site = as.factor(data$site)

# data = subset(data,avg>-0)

# ggbetweenstats(data = data,
#                x = site,
#                y = avg)

data = read.csv("F:/Tracking/allDeps_foragingOnly_distFromSf.csv")
data$site[data$site==1] = "W"
data$site[data$site==2] = "H"
data$site[data$site==3] = "E"
data$site[data$site==4] = "N"

data$site = factor(data$site, levels = c("W","H","E","N"))

medians <- data %>%
  group_by(site) %>%
  summarise(med = median(median,na.rm=TRUE))

ggplot(data, aes(x = as.factor(site), y=median, color=site)) +
  geom_violin(width=1, aes(fill=site), alpha = 0.8, show.legend = FALSE) +
  geom_boxplot(width=0.15, color="black", fill="white") +
  theme_classic() +
  xlab("Site") +
  ylab("Median Distance Above Seafloor (m)") +
  stat_summary(fun.y="mean", geom="point", size=2, show.legend=FALSE) +
  # geom_text(data=medians, aes(x=factor(site), y=med, label=round(med,1)),
  #     hjust=-.35, vjust = -0.5, color="black") +
  scale_fill_manual(values=c(W="#0072BD",H="#D95319",E="#7E2F8E",N="#77AC30")) +
  scale_color_manual(values=c(W="#0072BD",H="#D95319",E="#7E2F8E",N="#77AC30"))
  # scale_color_manual(values=c(W="black",H="black",E="black",N="black"))


  

# run kruskal-wallis
# h0: there is no difference in average dive depths per site
# h1: there is a difference in average dive depths per site
kruskal.test(median~site, data=data)
# p-value < 2.2e-16
# p-value < 0.05, reject the null

# now, a post-hoc test
dunnTest(median~site, data=data,
         method="bh")

# Dunn (1964) Kruskal-Wallis multiple comparison
# p-values adjusted with the Benjamini-Hochberg method.
# 
# Comparison           Z      P.unadj        P.adj
# 1      E - H -17.1883339 3.247308e-66 1.948385e-65
# 2      E - N  -9.8144089 9.760839e-23 1.952168e-22
# 3      H - N   0.5445249 5.860803e-01 5.860803e-01 # only one not different!
# 4      E - W  -8.5457598 1.276934e-17 1.915400e-17
# 5      H - W  13.8186135 1.968243e-43 5.904730e-43
# 6      N - W   5.8000741 6.628563e-09 7.954275e-09
