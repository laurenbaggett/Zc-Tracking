## grpMinMaxHist

h = read.csv('F:/grps/h_minMax.csv')
e = read.csv('F:/grps/e_minMax.csv')
w = read.csv('F:/grps/w_minMax.csv')
n = read.csv('F:/grps/n_minMax.csv')

sh = data.frame(matrix(NA, nrow = nrow(h), ncol = 4))
sh[,1] = h$X349.627297044495
sh[,2] = h$X349.627297044495.1
sh[,3] = c("H")
sh[,4] = h$X2
eh = data.frame(matrix(NA, nrow = nrow(e), ncol = 4))
eh[,1] = e$X393.832671429281
eh[,2] = e$X288.578620222032
eh[,3] = c("E");
eh[,4] = e$X3
nh = data.frame(matrix(NA, nrow = nrow(n), ncol = 4))
nh[,1] = n$X871.777782809503
nh[,2] = n$X410.021860830909
nh[,3] = c("N");
nh[,4] = n$X3
wh = data.frame(matrix(NA, nrow = nrow(w), ncol = 4))
wh[,1] = w$X334.671631242196
wh[,2] = w$X334.671631242196.1
wh[,3] = c("W");
wh[,4] = w$X2
data = rbind(sh,eh,nh,wh)
colnames(data) = c("max","min","site","grp")
data$site = as.factor(data$site)
data$grp = as.factor(data$grp)

# make histogram by site
ggplot(data, aes(x = as.factor(site), y=min, color=site)) +
  geom_boxplot() +
  theme_classic() +
  xlab("Site") +
  ylab("Minimum Avgerage Distance Between Pairs (m)")

ggplot(data, aes(x = as.factor(site), y=max, color=site)) +
  geom_boxplot() +
  theme_classic() +
  xlab("Site") +
  ylab("Maximum Average Distance Between Pairs (m)")

# make histogram by group size
ggplot(data, aes(x = as.factor(grp), y=min, color=grp)) +
  geom_boxplot() +
  theme_classic() +
  xlab("Number of Zc Per Encounter") +
  ylab("Minimum Average Distance Between Pairs (m)")

ggplot(data, aes(x = as.factor(grp), y=max, color=grp)) +
  geom_boxplot() +
  theme_classic() +
  xlab("Number of Zc Per Encounter") +
  ylab("Maximum Average Distance Between Pairs (m)")