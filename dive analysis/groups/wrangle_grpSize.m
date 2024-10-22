%% groupSize_boxplots

% load in group sizes for each deployment, combine per site
% site E
e = load('F:\Tracking\Erics_detector\SOCAL_E_63\group_size\cleanedTracksTable.mat');
e_grp = e.cleanedTracksTable(:,7);
% site N
n = load('F:\Tracking\Erics_detector\SOCAL_N_68\Zc\group_size\cleanedTracksTable.mat');
n_grp = n.cleanedTracksTable(:,7);
% site H
h72 = load('F:\Tracking\Erics_detector\SOCAL_H_72\group_size\cleanedTracksTable.mat');
h73 = load('F:\Tracking\Erics_detector\SOCAL_H_73\group_size\cleanedTracksTable.mat');
h74 = load('F:\Tracking\Erics_detector\SOCAL_H_74\group_size\cleanedTracksTable.mat');
h75 = load('F:\Tracking\Erics_detector\SOCAL_H_75\group_size\cleanedTracksTable.mat');
h_grp = vertcat(h72.cleanedTracksTable(:,7),h73.cleanedTracksTable(:,7),h74.cleanedTracksTable(:,7),h75.cleanedTracksTable(:,7));
% site W
w01 = load('F:\Tracking\Erics_detector\SOCAL_W_01\group_size\cleanedTracksTable.mat');
w02 = load('F:\Tracking\Erics_detector\SOCAL_W_02\group_size\cleanedTracksTable.mat');
w03 = load('F:\Tracking\Erics_detector\SOCAL_W_03\group_size\cleanedTracksTable.mat');
w04 = load('F:\Tracking\Erics_detector\SOCAL_W_04\group_size\cleanedTracksTable.mat');
w05 = load('F:\Tracking\Erics_detector\SOCAL_W_05\group_size\cleanedTracksTable.mat')
w_grp = vertcat(w01.cleanedTracksTable(:,7),w02.cleanedTracksTable(:,7),w03.cleanedTracksTable(:,7),w04.cleanedTracksTable(:,7),w05.cleanedTracksTable(:,7));

writetable(w_grp,'F:\grps\w_grp.csv');
writetable(h_grp,'F:\grps\h_grp.csv');
writetable(e_grp,'F:\grps\e_grp.csv');
writetable(n_grp,'F:\grps\n_grp.csv');