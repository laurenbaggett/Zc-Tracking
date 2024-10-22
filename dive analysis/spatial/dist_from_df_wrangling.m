%% dist_from_sf_wrangling
% LMB 3/13/24 2023a

% load in the data
% site H
% h72 = load('F:\Tracking\Erics_detector\SOCAL_H_72\deployment_stats\SOCAL_H_72_mean_distfromsf.mat');
% h73 = load('F:\Tracking\Erics_detector\SOCAL_H_73\deployment_stats\SOCAL_H_73_mean_distfromsf.mat');
% h74 = load('F:\Tracking\Erics_detector\SOCAL_H_74\deployment_stats\SOCAL_H_74_mean_distfromsf.mat');
% h75 = load('F:\Tracking\Erics_detector\SOCAL_H_75\deployment_stats\SOCAL_H_75_mean_distfromsf.mat');
% full = horzcat(h72.distfromsfmeans, h73.distfromsfmeans, h74.distfromsfmeans);
% % site E
% a = load('F:\Tracking\Erics_detector\SOCAL_E_63\deployment_stats\SOCAL_E_63_mean_distfromsf.mat');
% full = a.distfromsfmeans
% site N
% a = load('F:\Tracking\Erics_detector\SOCAL_N_68\Zc\deployment_stats\SOCAL_N_68_mean_distfromsf.mat');
% full = a.distfromsfmeans;
% % site W
a = load('F:\Tracking\Erics_detector\SOCAL_W_01\deployment_stats\SOCAL_W_01_mean_distfromsf.mat');
b = load('F:\Tracking\Erics_detector\SOCAL_W_02\deployment_stats\SOCAL_W_02_mean_distfromsf.mat');
c = load('F:\Tracking\Erics_detector\SOCAL_W_03\deployment_stats\SOCAL_W_03_mean_distfromsf.mat');
d = load('F:\Tracking\Erics_detector\SOCAL_W_04\deployment_stats\SOCAL_W_04_mean_distfromsf.mat');
e = load('F:\Tracking\Erics_detector\SOCAL_W_05\deployment_stats\SOCAL_W_05_NEW_mean_distfromsf.mat');
full = horzcat(a.distfromsfmeans,b.distfromsfmeans,c.distfromsfmeans,d.distfromsfmeans,e.distfromsfmeans);

avg = [];
sd = [];
clss = [];
tnum = [];

for i = 1:length(full)
    whale = full{i};
    for wn = 1:size(whale,2)
        avg = vertcat(avg,whale(1,wn));
        sd = vertcat(sd,whale(2,wn));
        clss = vertcat(clss,whale(4,wn));
        tnum = vertcat(tnum,whale(3,wn));
    end
end

% avg = str2double(avg);
% sd = str2double(sd);
% clss = str2double(clss);

mdfsf = table(avg,sd,clss, tnum);

writetable(mdfsf, 'F:\Tracking\Erics_detector\siteW_disffromsf_masterTable.csv');