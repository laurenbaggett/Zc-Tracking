library(ggplot2)

w01 = read.csv("F:/Tracking/Erics_detector/SOCAL_W_01/deployment_stats/SOCAL_W_01_initialDescent_laneDist.csv",header=FALSE)
w02 = read.csv("F:/Tracking/Erics_detector/SOCAL_W_02/deployment_stats/SOCAL_W_02_initialDescent_laneDist.csv",header=FALSE)
w03 = read.csv("F:/Tracking/Erics_detector/SOCAL_W_03/deployment_stats/SOCAL_W_03_initialDescent_laneDist.csv",header=FALSE)
w04 = read.csv("F:/Tracking/Erics_detector/SOCAL_W_04/deployment_stats/SOCAL_W_04_initialDescent_laneDist.csv",header=FALSE)
h72 = read.csv("F:/Tracking/Erics_detector/SOCAL_H_72/deployment_stats/SOCAL_H_72_initialDescent_laneDist.csv",header=FALSE)
h73 = read.csv("F:/Tracking/Erics_detector/SOCAL_H_73/deployment_stats/SOCAL_H_73_initialDescent_laneDist.csv",header=FALSE)
h74 = read.csv("F:/Tracking/Erics_detector/SOCAL_H_74/deployment_stats/SOCAL_H_74_initialDescent_laneDist.csv",header=FALSE)
h75 = read.csv("F:/Tracking/Erics_detector/SOCAL_H_75/deployment_stats/SOCAL_H_75_initialDescent_laneDist.csv",header=FALSE)
e63 = read.csv("F:/Tracking/Erics_detector/SOCAL_E_63/deployment_stats/SOCAL_E_63_initialDescent_laneDist.csv",header=FALSE)
n68 = read.csv("F:/Tracking/Erics_detector/SOCAL_N_68/Zc/deployment_stats/SOCAL_N_68_initialDescent_laneDist.csv",header=FALSE)

w01$site = "W_01"
w02$site = "W_02"
w03$site = "W_03"
w04$site = "W_04"
h72$site = "H_72"
h73$site = "H_73"
h74$site = "H_74"
h75$site = "H_75"
e63$site = "E_63"
n68$site = "N_68"

all = rbind(w01,w02,w03,w04,h72,h73,h74,h75,e63,n68)
colnames(all) = c("min","max","mean","numwhales","tracknum","deployment")
all$vote = 0
write.csv(all,file="F:/Tracking/groups/initialDescent_laneDist.csv")


all = read.csv("F:/Tracking/groups/initialDescent_laneDist.csv")
all = na.omit(all)

# remove rows with my 0 vote
all = all[which(all$vote==1),]
write.csv(all,file="F:/Tracking/groups/initialDescent_laneDist.csv")

all$site = substring(all$deployment,1,1)

# make some plots
ggplot(data=all) +
  geom_point(aes(x=X,y=mean)) +
  geom_errorbar(aes(ymin=min, ymax=max,xmin=0,xmax=0,x=X,y=mean))

ggplot(data=all, aes(x=as.factor(site),y=mean,color=as.factor(site))) +
  geom_boxplot()

ggplot(data=all, aes(x=as.factor(numwhales),y=mean,color=as.factor(numwhales))) +
  geom_boxplot()
