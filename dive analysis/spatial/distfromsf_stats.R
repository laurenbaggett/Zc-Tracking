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
  geom_violin(width=.8, aes(fill=site), alpha = 0.8, show.legend = FALSE) +
  geom_boxplot(width=0.15, color="black", fill="white") +
  theme_classic() +
  xlab("Site") +
  ylab("Median Distance Above Seafloor (m)") +
  stat_summary(fun.y="mean", geom="point", size=2, show.legend=FALSE) +
  # geom_text(data=medians, aes(x=factor(site), y=med, label=round(med,1)),
  #     hjust=-.35, vjust = -0.5, color="black") +
  scale_fill_manual(values=c(W="#0072BD",H="#6fc6ff",E="#004471",N="#6fc6ff")) +
  scale_color_manual(values=c(W="#0072BD",H="#6fc6ff",E="#004471",N="#6fc6ff"))

# scale_color_manual(values=c(W="#0072BD",H="#D95319",E="#7E2F8E",N="#77AC30"))

# run kruskal-wallis
# h0: there is no difference in average dive depths per site
# h1: there is a difference in average dive depths per site
kruskal.test(median~site, data=data)
# Kruskal-Wallis rank sum test
# 
# data:  median by site
# Kruskal-Wallis chi-squared = 384.25, df = 3, p-value < 2.2e-16
# there is a difference in average dive depths per site

# now, a post-hoc test
dunnTest(median~site, data=data,
         method="bh")

# Dunn (1964) Kruskal-Wallis multiple comparison
# p-values adjusted with the Benjamin-Hochberg method.
# 
# Comparison           Z      P.unadj        P.adj
# 1      E - H -17.5357114 7.648641e-69 4.589185e-68
# 2      E - N  -9.8857883 4.797907e-23 9.595813e-23
# 3      H - N   0.6462815 5.180971e-01 5.180971e-01
# 4      E - W  -8.2613536 1.440298e-16 2.160446e-16
# 5      H - W  14.7409037 3.520419e-49 1.056126e-48
# 6      N - W   6.0376101 1.564134e-09 1.876961e-09

# plot sideways histograms instead to see if this improves the display
w = data[data$site=='W',]
w = w[w$median>0,]
ggplot(w, aes(y=median)) +
  geom_histogram(aes(x=..density..),color="black",fill=	"white",alpha=0.3) +
  geom_density(alpha=0.2, color="#0072BD", lwd=1, fill=	"#0072BD") +
  theme_classic() +
  ylim(c(0,1000))

h = data[data$site=='H',]
h = h[h$median>0,]
ggplot(h, aes(y=median)) +
  geom_histogram(aes(x=..density..),color="black",fill=	"white",alpha=0.3) +
  geom_density(alpha=0.2, color="#0072BD", lwd=1, fill=	"#0072BD") +
  theme_classic() +
  ylim(c(0,1000))

e = data[data$site=='E',]
e = e[e$median>0,]
ggplot(e, aes(y=median)) +
  geom_histogram(aes(x=..density..),color="black",fill=	"white",alpha=0.3) +
  geom_density(alpha=0.2, color="#0072BD", lwd=1, fill=	"#0072BD") +
  theme_classic() +
  ylim(c(0,1000))

n = data[data$site=='N',]
n = n[n$median>0,]
ggplot(n, aes(y=median)) +
  geom_histogram(aes(x=..density..),color="black",fill=	"white",alpha=0.3) +
  geom_density(alpha=0.2, color="#0072BD", lwd=1, fill=	"#0072BD") +
  theme_classic() +
  ylim(c(0,1000))


