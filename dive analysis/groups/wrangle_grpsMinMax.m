%% wrangle_grpsMinMax

% site E
e = load('F:\Tracking\Erics_detector\SOCAL_E_63\deployment_stats\SOCAL_E_63_maxminPairs.mat');
e = horzcat(e.maxPair', e.minPair', e.numW');
e = e(-e(:,1)~=0,:);

% site N
n = load('F:\Tracking\Erics_detector\SOCAL_N_68\Zc\deployment_stats\SOCAL_N_68_maxminPairs.mat');
n = horzcat(n.maxPair', n.minPair', n.numW');
n = n(-n(:,1)~=0,:);

% site H
h72 = load('F:\Tracking\Erics_detector\SOCAL_H_72\deployment_stats\SOCAL_H_72_maxminPairs.mat');
h72 = horzcat(h72.maxPair', h72.minPair', h72.numW');
h72 = h72(-h72(:,1)~=0,:);
h73 = load('F:\Tracking\Erics_detector\SOCAL_H_73\deployment_stats\SOCAL_H_73_maxminPairs.mat');
h73 = horzcat(h73.maxPair', h73.minPair', h73.numW');
h73 = h73(-h73(:,1)~=0,:);
h74 = load('F:\Tracking\Erics_detector\SOCAL_H_74\deployment_stats\SOCAL_H_74_maxminPairs.mat');
h74 = horzcat(h74.maxPair', h74.minPair', h74.numW');
h74 = h74(-h74(:,1)~=0,:);
h75 = load('F:\Tracking\Erics_detector\SOCAL_H_75\deployment_stats\SOCAL_H_75_maxminPairs.mat');
h75 = horzcat(h75.maxPair', h75.minPair', h75.numW');
h75 = h75(-h75(:,1)~=0,:);
h = vertcat(h72, h73, h74, h75);

% site W
w01 = load('F:\Tracking\Erics_detector\SOCAL_W_01\deployment_stats\SOCAL_W_01_maxminPairs.mat');
w01 = horzcat(w01.maxPair', w01.minPair', w01.numW');
w01 = w01(-w01(:,1)~=0,:);
w02 = load('F:\Tracking\Erics_detector\SOCAL_W_02\deployment_stats\SOCAL_W_02_maxminPairs.mat');
w02 = horzcat(w02.maxPair', w02.minPair', w02.numW');
w02 = w02(-w02(:,1)~=0,:);
w03 = load('F:\Tracking\Erics_detector\SOCAL_W_03\deployment_stats\SOCAL_W_03_maxminPairs.mat');
w03 = horzcat(w03.maxPair', w03.minPair', w03.numW');
w03 = w03(-w03(:,1)~=0,:);
w04 = load('F:\Tracking\Erics_detector\SOCAL_W_04\deployment_stats\SOCAL_W_04_maxminPairs.mat');
w04 = horzcat(w04.maxPair', w04.minPair', w04.numW');
w04 = w04(-w04(:,1)~=0,:);
w = vertcat(w01, w02, w03, w04);

writematrix(w,'F:\grps\w_minMax.csv');
writematrix(h,'F:\grps\h_minMax.csv');
writematrix(e,'F:\grps\e_minMax.csv');
writematrix(n,'F:\grps\n_minMax.csv');