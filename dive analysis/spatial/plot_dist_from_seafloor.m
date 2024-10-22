%% plot_dist_from_seafloor
% LMB 3/11/24 2023a
% this script will plot average distances from the seafloor a variety of
% ways

% first, plot as points with stdev error bars
% a = load('F:\Tracking\Erics_detector\SOCAL_W_01\deployment_stats\SOCAL_W_01_mean_distfromsf.mat');
% b = load('F:\Tracking\Erics_detector\SOCAL_W_02\deployment_stats\SOCAL_W_02_mean_distfromsf.mat');
% c = load('F:\Tracking\Erics_detector\SOCAL_W_03\deployment_stats\SOCAL_W_03_mean_distfromsf.mat');
% d = load('F:\Tracking\Erics_detector\SOCAL_W_04\deployment_stats\SOCAL_W_04_mean_distfromsf.mat');
% full = horzcat(a.distfromsfmeans,b.distfromsfmeans,c.distfromsfmeans,d.distfromsfmeans);
% a = load('F:\Tracking\Erics_detector\SOCAL_E_63\deployment_stats\SOCAL_E_63_mean_distfromsf.mat');
% a = load('F:\Tracking\Erics_detector\SOCAL_N_68\Zc\deployment_stats\SOCAL_N_68_mean_distfromsf.mat');
% full = a.distfromsfmeans
% a = load('F:\Tracking\Erics_detector\SOCAL_H_72\deployment_stats\SOCAL_H_72_mean_distfromsf.mat');
% b = load('F:\Tracking\Erics_detector\SOCAL_H_73\deployment_stats\SOCAL_H_73_mean_distfromsf.mat');
% c = load('F:\Tracking\Erics_detector\SOCAL_H_74\deployment_stats\SOCAL_H_74_mean_distfromsf.mat');
% d = load('F:\Tracking\Erics_detector\SOCAL_H_75\deployment_stats\SOCAL_H_75_mean_distfromsf.mat');
% full = horzcat(a.distfromsfmeans,b.distfromsfmeans,c.distfromsfmeans,d.distfromsfmeans);
a = load('F:\Tracking\Erics_detector\SOCAL_W_05\new\SOCAL_W_05_NEW_mean_distfromsf.mat');
full = a.distfromsfmeans;


% define a colormap
m = vertcat([0 0.4470 0.7410], [0.8500 0.3250 0.0980], [0.4660 0.6740 0.1880], [0 0 0]);

figure
hold on
xlim([0 length(full)+1]);
% ylim([-100 925]);
for i = 1:numel(full)
    whale = full{i};
    for wn = 1:size(whale,2)
        if cell2mat(whale(1,wn)) > 0
            e = errorbar(i,cell2mat(whale(1,wn)),cell2mat(whale(2,wn)),'*');
            e.Color = m(cell2mat(whale(4,wn)),:);
        end
    end
end
ylabel('Mean Distance Above Seafloor')
xlabel('Index')
title('SOCAL H')


% make a histogram
hval = [];
for i = 1:numel(full)
    whale = full{i};
    for wn = 1:size(whale,2)
        hval = vertcat(hval, cell2mat(whale(1,wn)));
        if cell2mat(whale(1,wn))<-50
            disp(string(whale(3,wn)))
        end
    end
end

figure
histogram(hval,[-300, -250, -200, -150, -100, -50, 0, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900])
title('SOCAL H')