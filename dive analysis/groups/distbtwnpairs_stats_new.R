# distbtwnpairs_stats

df = read.csv('F:/Zc_Analysis/dist_btwn_pairs/dist_btwn_pairs_allsites.csv')

df$site = factor(df$site, levels = c("W","H","E","N"))

means <- df %>%
  group_by(allSite) %>%
  summarise(med = mean(allMeans,na.rm=TRUE))

slopes = df %>%
  group_by(allSite) %>%
  summarise(med = mean(allSlp,na.rm=TRUE))

# test means
kruskal.test(allMeans~allSite, data=df)
# Kruskal-Wallis rank sum test
# 
# data:  allMeans by allSite
# Kruskal-Wallis chi-squared = 1.6962, df = 3, p-value = 0.6378
# not significant!!

# test slopes
kruskal.test(allSlp~allSite,data=df)
# Kruskal-Wallis rank sum test
# 
# data:  allSlp by allSite
# Kruskal-Wallis chi-squared = 6.691, df = 3, p-value = 0.08243
# not significant
