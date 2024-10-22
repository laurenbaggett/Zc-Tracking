%% grp_dist_wrangling

% load in the data
% site H
% h72 = load('F:\Tracking\Erics_detector\SOCAL_H_72\deployment_stats\SOCAL_H_72_grpArea.mat');
% h73 = load('F:\Tracking\Erics_detector\SOCAL_H_73\deployment_stats\SOCAL_H_73_grpArea.mat');
% h74 = load('F:\Tracking\Erics_detector\SOCAL_H_74\deployment_stats\SOCAL_H_74_grpArea.mat');
% h75 = load('F:\Tracking\Erics_detector\SOCAL_H_75\deployment_stats\SOCAL_H_75_grpArea.mat');
% full = horzcat(h72.distfromsfmeans, h73.distfromsfmeans, h74.distfromsfmeans);
% % site E
% a = load('F:\Tracking\Erics_detector\SOCAL_E_63\deployment_stats\SOCAL_E_63_grpArea.mat');
% full = a.distfromsfmeans
% site N
% a = load('F:\Tracking\Erics_detector\SOCAL_N_68\Zc\deployment_stats\SOCAL_N_68_grpArea.mat');
% full = a.distfromsfmeans;
% % site W
a = load('F:\Tracking\Erics_detector\SOCAL_W_01\deployment_stats\SOCAL_W_01_grpArea.mat');
b = load('F:\Tracking\Erics_detector\SOCAL_W_02\deployment_stats\SOCAL_W_02_grpArea.mat');
c = load('F:\Tracking\Erics_detector\SOCAL_W_03\deployment_stats\SOCAL_W_03_grpArea.mat');
d = load('F:\Tracking\Erics_detector\SOCAL_W_04\deployment_stats\SOCAL_W_04_grpArea.mat');
full = horzcat(a.mstGrpMaxDist,b.mstGrpMaxDist,c.mstGrpMaxDist,d.mstGrpMaxDist);

whole = [];
for i = 1:length(full)   
    dist = full{i};
    mn = mean(dist(:,1))
    whole = vertcat(whole, mn)
end

plot(whole)