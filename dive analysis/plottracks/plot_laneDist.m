%% plot_laneDist

% load in the data
% % site W
% a = load('F:\Tracking\Erics_detector\SOCAL_W_01\deployment_stats\SOCAL_W_01_laneDist.mat');
% b = load('F:\Tracking\Erics_detector\SOCAL_W_02\deployment_stats\SOCAL_W_02_laneDist.mat');
% c = load('F:\Tracking\Erics_detector\SOCAL_W_03\deployment_stats\SOCAL_W_03_laneDist.mat');
% d = load('F:\Tracking\Erics_detector\SOCAL_W_04\deployment_stats\SOCAL_W_04_laneDist.mat');
% depMeans = vertcat(a.depMeans,b.depMeans,c.depMeans,d.depMeans);
% % site H
% a = load('F:\Tracking\Erics_detector\SOCAL_H_72\deployment_stats\SOCAL_H_72_laneDist.mat');
% b = load('F:\Tracking\Erics_detector\SOCAL_H_73\deployment_stats\SOCAL_H_73_laneDist.mat');
% c = load('F:\Tracking\Erics_detector\SOCAL_H_74\deployment_stats\SOCAL_H_74_laneDist.mat');
% d = load('F:\Tracking\Erics_detector\SOCAL_H_75\deployment_stats\SOCAL_H_75_laneDist.mat');
% depMeans = vertcat(a.depMeans,b.depMeans,c.depMeans,d.depMeans);
% site E
% load('F:\Tracking\Erics_detector\SOCAL_E_63\deployment_stats\SOCAL_E_63_laneDist.mat');
% site N
% load('F:\Tracking\Erics_detector\SOCAL_N_68\Zc\deployment_stats\SOCAL_N_68_laneDist.mat');


%% plot all of them with means, mins, max
figure
errorbar(1:height(depMeans),str2double(depMeans(:,1)),str2double(depMeans(:,3))-str2double(depMeans(:,1)),str2double(depMeans(:,1))-str2double(depMeans(:,2)),0,0,'o','color','black')
ylabel('Lane Distance (Pairs)')
xlim([0 height(depMeans)])
ylim([0 6000])
title('Site N')

%% plot slopes