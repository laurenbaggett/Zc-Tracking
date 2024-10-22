# distbtwnpairs_stats.R
# LMB 3/19/24

library(R.matlab)
library(scales)
library(ggpubr)
library(cowplot)
library(HistogramTools)

w = data.frame(readMat("F:/Tracking/Erics_detector/siteW_mnDistBtwnPairs.mat"))
e = data.frame(readMat("F:/Tracking/Erics_detector/siteE_mnDistBtwnPairs.mat"))
h = data.frame(readMat("F:/Tracking/Erics_detector/siteH_mnDistBtwnPairs.mat"))
n = data.frame(readMat("F:/Tracking/Erics_detector/siteN_mnDistBtwnPairs.mat"))

sh = data.frame(matrix(NA, nrow = nrow(h), ncol = 3))
sh[,1] = h$mnsGrp.1
sh[,2] = h$mnsGrp.2
sh[,3] = c("H");
eh = data.frame(matrix(NA, nrow = nrow(e), ncol = 3))
eh[,1] = e$mnsGrp.1
eh[,2] = e$mnsGrp.2
eh[,3] = c("E");
nh = data.frame(matrix(NA, nrow = nrow(n), ncol = 3))
nh[,1] = n$mnsGrp.1
nh[,2] = n$mnsGrp.2
nh[,3] = c("N");
wh = data.frame(matrix(NA, nrow = nrow(w), ncol = 3))
wh[,1] = w$mnsGrp.1
wh[,2] = w$mnsGrp.2
wh[,3] = c("W");
data = rbind(sh,eh,nh,wh)
colnames(data) = c("avg","grp","site")
data$site = as.factor(data$site)
data$grp = as.factor(data$grp)

# make histogram by site
ggplot(data, aes(x = as.factor(site), y=avg, color=site)) +
  geom_boxplot() +
  theme_classic() +
  xlab("Site") +
  ylab("Average Distance Between Pairs (m)")

ggplot(data, aes(x = as.factor(grp), y=avg, color=grp)) +
  geom_boxplot() +
  theme_classic() +
  xlab("Number of Zc Per Encounter") +
  ylab("Average Distance Between Pairs (m)")

grp2 = data[data$grp==2,]
grp3 = data[data$grp==3,]
grp4 = data[data$grp==4,]
grp5 = data[data$grp==5,]
grp6 = data[data$grp==6,]
grp7 = data[data$grp==7,]

hex = hue_pal()(6)

p1 = ggplot(data = grp2, aes(x = avg, fill=grp)) +
  # scale_color_manual(values = c(hex[1])) +
  geom_histogram(binwidth = 100) +
  xlim(c(0, 5000)) +
  labs(x = "Avg Distance Between Pairs (m)", y = "Frequency", title = "Group Size = 2") +
  theme_bw() +
  guides(fill=FALSE) +
  scale_fill_manual(values = c(hex[1])) +
  theme(plot.title = element_text(hjust = 0.5))
p2 = ggplot(data = grp3, aes(x = avg, fill=grp)) +
  geom_histogram(binwidth = 100) +
  xlim(c(0, 5000)) +
  labs(x = "Avg Distance Between Pairs (m)", y = "Frequency", title = "Group Size = 3") +
  theme_bw() +
  guides(fill=FALSE) +
  scale_fill_manual(values = c(hex[2])) +
  theme(plot.title = element_text(hjust = 0.5))

p3 = ggplot(data = grp4, aes(x = avg, fill=grp)) +
  geom_histogram(binwidth = 100) +
  xlim(c(0, 5000)) +
  labs(x = "Avg Distance Between Pairs (m)", y = "Frequency", title = "Group Size = 4") +
  theme_bw() +
  guides(fill=FALSE) +
  scale_fill_manual(values = c(hex[3])) +
  theme(plot.title = element_text(hjust = 0.5))


p4 = ggplot(data = grp5, aes(x = avg, fill=grp)) +
  geom_histogram(binwidth = 100) +
  xlim(c(0, 5000)) +
  labs(x = "Avg Distance Between Pairs (m)", y = "Frequency", title = "Group Size = 5") +
  theme_bw() +
  guides(fill=FALSE) +
  scale_fill_manual(values = c(hex[4])) +
  theme(plot.title = element_text(hjust = 0.5))


p5 = ggplot(data = grp6, aes(x = avg, fill=grp)) +
  geom_histogram(binwidth = 100) +
  xlim(c(0, 5000)) +
  labs(x = "Avg Distance Between Pairs (m)", y = "Frequency", title = "Group Size = 6") +
  theme_bw() +
  guides(fill=FALSE)+
  scale_fill_manual(values = c(hex[5])) +
  theme(plot.title = element_text(hjust = 0.5))


p6 = ggplot(data = grp7, aes(x = avg, fill=grp)) +
  geom_histogram(binwidth = 100) +
  xlim(c(0, 5000)) +
  ylim(c(0,12)) +
  labs(x = "Avg Distance Between Pairs (m)", y = "Frequency", title = "Group Size = 7") +
  theme_bw() +
  guides(fill=FALSE) +
  scale_fill_manual(values = c(hex[6])) +
  theme(plot.title = element_text(hjust = 0.5))


plot_grid(p1, p2, p3, p4, p5, p6,
                    ncol = 3, nrow = 2)
plot_grid(plotlist = c(p1,p2,p3,p4,p5,p6), ncol = 3, nrow = 2)


hist(grp2$avg,xlab="Avg Distance Between Pairs (m)", main="Group Size = 2", col=hex[1], xlim = c(0, 5000), breaks = 9, border=F)
hist(grp3$avg,xlab="Avg Distance Between Pairs (m)", main="Group Size = 3", col=hex[2], xlim = c(0, 5000), breaks = 9, border=F)
hist(grp4$avg,xlab="Avg Distance Between Pairs (m)", main="Group Size = 4", col=hex[3], xlim = c(0, 5000), breaks = 9, border=F)
hist(grp5$avg,xlab="Avg Distance Between Pairs (m)", main="Group Size = 5", col=hex[4], xlim = c(0, 5000), breaks = 9, border=F)
hist(grp6$avg,xlab="Avg Distance Between Pairs (m)", main="Group Size = 6", col=hex[5], xlim = c(0, 5000), breaks = 9, border=F)
hist(grp7$avg,xlab="Avg Distance Between Pairs (m)", main="Group Size = 7", col=hex[6], xlim = c(0, 5000), breaks = 9, border=F)


# check that distributions are actually different
vals = matrix(nrow=52,ncol=1000)
b = c()
for (i in 1:100) {
a = data.frame(sample(grp2$avg,size=52))
a$iteration = i
colnames(a) = c('vals','iteration')
b = rbind(b,a)
}
b$iteration = as.factor(b$iteration)


brks = c(seq(0,5500,by=100))
for (i in 1:20) {
  a = hist(sample(grp2$avg,size=52),breaks=brks)
  assign(paste('h',i,sep=""),a)
}

plot(h1)
plot(h2,add=T)    
plot(h3,add=T)  
plot(h4,add=T)    
plot(h5,add=T)    
plot(h6,add=T)    
plot(h7,add=T)    
plot(h8,add=T)    
plot(h9,add=T)    
plot(h10,add=T)   
plot(h11,add=T)    
plot(h12,add=T)    
plot(h13,add=T)    
plot(h14,add=T)    
plot(h15,add=T)    
plot(h16,add=T)    
plot(h17,add=T)    
plot(h18,add=T)    
plot(h19,add=T)    
plot(h20,add=T,ylim=c(0,15))    


