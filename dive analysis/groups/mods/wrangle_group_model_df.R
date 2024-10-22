## wrangle_group_model_df

# load in data frames for each site
w = read.csv("F:/Tracking/groups/SOCAL_W_binned_260min_groups.csv")
h = read.csv("F:/Tracking/groups/SOCAL_H_binned_260min_groups.csv")
e = read.csv("F:/Tracking/groups/SOCAL_E_binned_260min_groups.csv")
n = read.csv("F:/Tracking/groups/bigmodel/SOCAL_N_binned_260min_groups.csv")

# add a site parameter
w$site = "W"
h$site = "H"
e$site = "E"
n$site = "N"

df = rbind(w,h,e,n)

write.csv(df,"F:/Tracking/groups/SOCAL_total_binned_260min_groups.csv")
