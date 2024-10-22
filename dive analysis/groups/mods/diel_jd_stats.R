# diel_jd_stats

library(R.matlab)
library(scales)
library(ggpubr)
library(cowplot)
library(ggplot2)
library(tidyverse)
library(ggpubr)
library(FSA)
library(stringr)
library(mgcv)

# load in data
e = read.csv("F:/Tracking/Erics_detector/SOCAL_E_63/deployment_stats/SOCAL_E_63_night_jd.csv")
e$dt = as.factor(e$dt)
n = read.csv("F:/Tracking/Erics_detector/SOCAL_N_68/Zc/deployment_stats/SOCAL_N_68_night_jd.csv")
n$dt = as.factor(n$dt)
h72 = read.csv("F:/Tracking/Erics_detector/SOCAL_H_72/deployment_stats/SOCAL_H_72_night_jd.csv")
h73 = read.csv("F:/Tracking/Erics_detector/SOCAL_H_73/deployment_stats/SOCAL_H_73_night_jd.csv")
h74 = read.csv("F:/Tracking/Erics_detector/SOCAL_H_74/deployment_stats/SOCAL_H_74_night_jd.csv")
h75 = read.csv("F:/Tracking/Erics_detector/SOCAL_H_75/deployment_stats/SOCAL_H_75_night_jd.csv")
h = rbind(h72,h73,h74,h75)
h$dt = as.factor(h$dt)
w01 = read.csv("F:/Tracking/Erics_detector/SOCAL_W_01/deployment_stats/SOCAL_W_01_night_jd.csv")
w02 = read.csv("F:/Tracking/Erics_detector/SOCAL_W_02/deployment_stats/SOCAL_W_02_night_jd.csv")
w03 = read.csv("F:/Tracking/Erics_detector/SOCAL_W_03/deployment_stats/SOCAL_W_03_night_jd.csv")
w04 = read.csv("F:/Tracking/Erics_detector/SOCAL_W_04/deployment_stats/SOCAL_W_04_night_jd.csv")
w05 = read.csv("F:/Tracking/Erics_detector/SOCAL_W_05/deployment_stats/SOCAL_W_05_night_jd.csv")
w = rbind(w01,w02,w03,w04,w05)
w$dt = as.factor(w$dt)

## do some plotting --------------------------
p1 = ggplot(e,aes(x=dt, y=numWhales, group=dt, col=dt)) +
  geom_boxplot(show.legend=FALSE) +
  labs(x = "", y = "Number of Whales Per Encounter", title = "Site E") +
  theme_bw() +
  ylim(c(0,8)) +
  guides(fill=FALSE) +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_discrete(labels=c('Night','Day')) + stat_summary(fun.y=mean)

p2 = ggplot(h,aes(x=dt, y=numWhales, group=dt, col=dt)) +
  geom_boxplot(show.legend=FALSE) +
  labs(x = "", y = "Number of Whales Per Encounter", title = "Site H") +
  theme_bw() +
  ylim(c(0,8)) +
  guides(fill=FALSE) +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_discrete(labels=c('Night','Day'))

p3 = ggplot(n,aes(x=dt, y=numWhales, group=dt, col=dt)) +
  geom_boxplot(show.legend=FALSE) +
  labs(x = "", y = "Number of Whales Per Encounter", title = "Site N") +
  ylim(c(0,8)) +
  theme_bw() +
  guides(fill=FALSE) +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_discrete(labels=c('Night','Day'))

p4 = ggplot(w,aes(x=dt, y=numWhales, group=dt, col=dt)) +
  geom_boxplot(show.legend=FALSE) +
  labs(x = "", y = "Number of Whales Per Encounter", title = "Site W") +
  theme_bw() +
  ylim(c(0,8)) +
  guides(fill=FALSE) +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_discrete(labels=c('Night','Day'))


figure = plot_grid(p1, p2, p3, p4,
                    ncol = 2, nrow = 2)
figure




## group size by site -------------------------
e$site = "E"
h$site = "H"
n$site = "N"
w$site = "W"
data = rbind(e,h,n,w)

hex = hue_pal()(6)

# plot group size distributions per site!
ggplot(data = e, aes(x = numWhales)) +
  geom_histogram(binwidth = 1, color="black",fill=hex[1]) +
  xlim(c(0, 8)) +
  labs(x = "Group Size", y = "Frequency", title = "Site E") +
  theme_bw() +
  guides(fill=FALSE) +
  theme(plot.title = element_text(hjust = 0.5))

ggplot(data = h, aes(x = numWhales)) +
  geom_histogram(binwidth = 1, color="black",fill=hex[2]) +
  xlim(c(0, 8)) +
  labs(x = "Group Size", y = "Frequency", title = "Site H") +
  theme_bw() +
  guides(fill=FALSE) +
  theme(plot.title = element_text(hjust = 0.5))

ggplot(data = n, aes(x = numWhales)) +
  geom_histogram(binwidth = 1, color="black",fill=hex[3]) +
  xlim(c(0, 8)) +
  labs(x = "Group Size", y = "Frequency", title = "Site N") +
  theme_bw() +
  guides(fill=FALSE) +
  theme(plot.title = element_text(hjust = 0.5))

ggplot(data = w, aes(x = numWhales)) +
  geom_histogram(binwidth = 1, color="black",fill=hex[4]) +
  xlim(c(0, 8)) +
  labs(x = "Group Size", y = "Frequency", title = "Site W") +
  theme_bw() +
  guides(fill=FALSE) +
  theme(plot.title = element_text(hjust = 0.5))

# figure = plot_grid(plotlist = c(pe,ph,pn,pw),ncol=2,nrow=2)

# run kruskal-wallis
# h0: there is no difference in group size per site
# h1: there is a difference in group size per site
kruskal.test(numWhales~as.factor(site), data=data)
# p-value = 0.0007563
# p-value < 0.05, reject the null

# now, a post-hoc test
dunnTest(numWhales~as.factor(site), data=data,
         method="bh")

# Comparison         Z     P.unadj       P.adj
# 1      E - H  1.009076 0.312938232 0.312938232
# 2      E - N  2.172711 0.029802045 0.059604090
# 3      H - N  1.646501 0.099660658 0.149490986
# 4      E - W -1.621862 0.104832835 0.125799402
# 5      H - W -3.090628 0.001997334 0.005992001
# 6      N - W -3.215865 0.001300520 0.007803119

# W is significantly different from sites H and N

# start diel trends ------------------------------------------------

day = data[data$dt==1,]
night = data[data$dt==0,]

hist(day$numWhales)
hist(night$numWhales)

pa = ggplot(day, aes(x=as.factor(site), y=numWhales, color=site)) +
  geom_boxplot() +
  theme_classic() +
  ylim(c(0,8)) +
  labs(x="Site",y="Group Size",title="Daytime Group Sizes") +
  theme(plot.title = element_text(hjust = 0.5)) 

pb = ggplot(night, aes(x=as.factor(site), y=numWhales, grp=as.factor(site), color=site)) +
  geom_boxplot() +
  theme_classic() +
  ylim(c(0,8)) +
  labs(x="Site",y="Group Size",title="Nighttime Group Sizes") +
  theme(plot.title = element_text(hjust = 0.5)) 

figure = plot_grid(pa,pb,ncol=2,nrow=1)
figure

d1 = ggplot(data = day, aes(x = numWhales)) +
  geom_histogram(binwidth = 1, color="black",fill="lightblue") +
  xlim(c(0, 8)) +
  labs(x = "Group Size", y = "Frequency", title = "Daytime Encounters") +
  theme_bw() +
  guides(fill=FALSE) +
  theme(plot.title = element_text(hjust = 0.5))

d2 = ggplot(data = night, aes(x = numWhales)) +
  geom_histogram(binwidth = 1, color="black",fill="darkblue") +
  xlim(c(0, 8)) +
  labs(x = "Group Size", y = "Frequency", title = "Nighttime Encounters") +
  theme_bw() +
  guides(fill=FALSE) +
  theme(plot.title = element_text(hjust = 0.5))

plot_grid(d1,d2,ncol=2, nrow=1)

## run some stats ------------------------------------

mean(night$numWhales)
mean(day$numWhales)

# mann-whitney u
# h0: there is no difference in group sizes during day vs the night
# h1: there is a difference in group sizes during day vs the night
wilcox.test(numWhales~dt, data=data)
# p-value = 0.004663
# p-value < 0.05, reject the null
# there is a significant difference in group size between day and night

# make a boxplot of all sites, day vs night
ggplot(data, aes(x=dt,y=numWhales)) +
  geom_boxplot() +
  labs(x = "", y = "Number of Whales Per Encounter") +
  theme_bw() +
  ylim(c(0,8)) +
  guides(fill=FALSE) +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_discrete(labels=c('Night','Day'))


## add year to data frame and save ------------------

m1 = lm(data$numWhales~data$dt)
summary(m1)
