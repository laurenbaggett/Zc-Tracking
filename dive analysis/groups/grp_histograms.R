
h = read.csv('F:/grps/h_grp.csv')
e = read.csv('F:/grps/e_grp.csv')
w = read.csv('F:/grps/w_grp.csv')
n = read.csv('F:/grps/n_grp.csv')

sh = data.frame(matrix(NA, nrow = nrow(h), ncol = 2))
sh[,1] = h$numWhales
sh[,2] = c("H");
eh = data.frame(matrix(NA, nrow = nrow(e), ncol = 2))
eh[,1] = e$numWhales
eh[,2] = c("E");
nh = data.frame(matrix(NA, nrow = nrow(n), ncol = 2))
nh[,1] = n$numWhales
nh[,2] = c("N");
wh = data.frame(matrix(NA, nrow = nrow(w), ncol = 2))
wh[,1] = w$numWhales
wh[,2] = c("W");
data = rbind(sh,eh,nh,wh)
colnames(data) = c("numwhales","site")
data$site = as.factor(data$site)

# make histogram by site
ggplot(data, aes(x = as.factor(site), y=numwhales, color=site)) +
  geom_boxplot() +
  theme_classic() +
  xlab("Site") +
  ylab("Number of Whales Per Encounter")

median(e$numWhales)
median(h$numWhales)
median(w$numWhales)
median(n$numWhales)
