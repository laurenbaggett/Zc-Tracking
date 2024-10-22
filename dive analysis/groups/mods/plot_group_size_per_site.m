%% plot_group_size_per_site

% site W
w = load('F:\Tracking\groups\siteWmod\SiteW_275min_presBins.mat');
offEffort = [datetime('15-Jan-2022 13:51:24') datetime('10-Mar-2022 03:15:00');
    datetime('27-May-2022 17:23:34') datetime('27-May-2022 20:02:00');
    datetime('14-Oct-2022 18:49:30') datetime('19-Oct-2022 02:00:00');
    datetime('23-Oct-2022 00:45:12') datetime('16-Apr-2023 19:00:00')]

figure(1)
bar(w.a.Time,w.a.Var1,'barwidth',1,'facecolor','black')
hold on
bar(offEffort(1,1):minutes(275):offEffort(1,2),repelem(250,281),'barwidth',1,'facecolor', [0.8 0.8 0.8],'edgecolor','none')
bar(offEffort(2,1):minutes(275):offEffort(2,2),repelem(250,1),'barwidth',1,'facecolor', [0.8 0.8 0.8],'edgecolor','none')
bar(offEffort(3,1):minutes(275):offEffort(3,2),repelem(250,23),'barwidth',1,'facecolor', [0.8 0.8 0.8],'edgecolor','none')
bar(offEffort(4,1):minutes(275):offEffort(4,2),repelem(250,921),'barwidth',1,'facecolor', [0.8 0.8 0.8],'edgecolor','none')
ylabel('Group Size Summs (275 min bins)')

% site H
h = load('F:\Tracking\groups\siteHmod\SiteH_300min_presBins.mat');
offEffort = [datetime('23-Oct-2021 01:10:03') datetime('21-Dec-2021 01:00:00');
    datetime('22-May-2022 21:59:27') datetime('10-Jun-2022 22:00:00');
    datetime('15-Oct-2022 21:05:36') datetime('17-Oct-2022 00:00:00')]

figure(2)
bar(h.a.Time,h.a.Var1,'barwidth',1,'facecolor','black')
hold on
bar(offEffort(1,1):minutes(300):offEffort(1,2),repelem(150,284),'barwidth',1,'facecolor', [0.8 0.8 0.8],'edgecolor','none')
bar(offEffort(2,1):minutes(300):offEffort(2,2),repelem(150,92),'barwidth',1,'facecolor', [0.8 0.8 0.8],'edgecolor','none')
bar(offEffort(3,1):minutes(300):offEffort(3,2),repelem(150,6),'barwidth',1,'facecolor', [0.8 0.8 0.8],'edgecolor','none')
ylabel('Group Size Summs (300 min bins)')

% site E
e = load('F:\Tracking\groups\siteEmod\SiteE_100min_presBins.mat');

figure(3)
bar(e.a.Time,e.a.Var1,'barwidth',1,'facecolor','black')
ylabel('Group Size Summs (100 min bins)')

