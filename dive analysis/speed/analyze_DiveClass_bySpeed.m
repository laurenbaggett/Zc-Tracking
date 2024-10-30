%% analyze_DiveClass_bySpeed

% see if the different dive classes happen at different speeds
a = dir('F:\Tracking\Erics_detector\SOCAL_W_01\cleaned_tracks');
b = dir('F:\Tracking\Erics_detector\SOCAL_W_02\cleaned_tracks');
c = dir('F:\Tracking\Erics_detector\SOCAL_W_03\cleaned_tracks');
d = dir('F:\Tracking\Erics_detector\SOCAL_W_04\cleaned_tracks');
e = dir('F:\Tracking\Erics_detector\SOCAL_W_05\cleaned_tracks');

xa = [];
xb = [];
xc = [];
xd = [];
xe = [];

for i = 3:length(a)
    
    myFile = dir([a(i).folder,'\',a(i).name,'\z_stats.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name]));
    trackNum2 = str2num(extractAfter(a(i).name,'track'));
    % z_stats = z_stats';
    myFile = dir([a(i).folder,'\',a(i).name,'\*distSpd.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name]));
    myFile = dir([a(i).folder,'\',a(i).name,'\*whale.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name]));

    for wn = 1:size(z_stats,2)
        if ~isnan(z_stats(1,wn))
        v = z_stats(6,wn);
        minDepth = min(whale{wn}.wlocSmoothLatLonDepth(:,3));
        maxDepth = max(whale{wn}.wlocSmoothLatLonDepth(:,3));
        meanDepth = mean(whale{wn}.wlocSmoothLatLonDepth(:,3));
        if v~=1
            dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
        elseif v == 1
            dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
        end
        v = horzcat(v,meanSpd(wn),deltaSpd(wn),totalDist(wn),trackNum2,01,minDepth,maxDepth,meanDepth,dur);
        xa = vertcat(xa,v);
        end
    end  
end

i=3;
for i = 3:length(b)
    
    myFile = dir([b(i).folder,'\',b(i).name,'\z_stats.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name]));
    trackNum2 = str2num(extractAfter(b(i).name,'track'));
    % z_stats = z_stats';
    myFile = dir([b(i).folder,'\',b(i).name,'\*distSpd.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name]));
    myFile = dir([b(i).folder,'\',b(i).name,'\*whale.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name]));

    for wn = 1:size(z_stats,2)
        if ~isnan(z_stats(1,wn))
        v = z_stats(6,wn);
        minDepth = min(whale{wn}.wlocSmoothLatLonDepth(:,3));
        maxDepth = max(whale{wn}.wlocSmoothLatLonDepth(:,3));
        meanDepth = mean(whale{wn}.wlocSmoothLatLonDepth(:,3));
        if v~=1
            dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
        elseif v == 1
            dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
        end
        v = horzcat(v,meanSpd(wn),deltaSpd(wn),totalDist(wn),trackNum2,01,minDepth,maxDepth,meanDepth,dur);
        xb = vertcat(xb,v);
        end
    end  
end

i=3;
for i = 3:length(c)
    
    myFile = dir([c(i).folder,'\',c(i).name,'\z_stats.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name]));
    trackNum2 = str2num(extractAfter(c(i).name,'track'));
    % z_stats = z_stats';
    myFile = dir([c(i).folder,'\',c(i).name,'\*distSpd.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name]));
    myFile = dir([c(i).folder,'\',c(i).name,'\*whale.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name]));

    for wn = 1:size(z_stats,2)
        if ~isnan(z_stats(1,wn))
        v = z_stats(6,wn);
        minDepth = min(whale{wn}.wlocSmoothLatLonDepth(:,3));
        maxDepth = max(whale{wn}.wlocSmoothLatLonDepth(:,3));
        meanDepth = mean(whale{wn}.wlocSmoothLatLonDepth(:,3));
        if v~=1
            dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
        elseif v == 1
            dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
        end
        v = horzcat(v,meanSpd(wn),deltaSpd(wn),totalDist(wn),trackNum2,01,minDepth,maxDepth,meanDepth,dur);
        xc = vertcat(xc,v);
        end
    end  
end

i=3;
for i = 3:length(d)
    
    myFile = dir([d(i).folder,'\',d(i).name,'\z_stats.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name]));
    trackNum2 = str2num(extractAfter(d(i).name,'track'));
    % z_stats = z_stats';
    myFile = dir([d(i).folder,'\',d(i).name,'\*distSpd.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name]));
    myFile = dir([d(i).folder,'\',d(i).name,'\*whale.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name]));

    for wn = 1:size(z_stats,2)
        if ~isnan(z_stats(1,wn))
        v = z_stats(6,wn);
        minDepth = min(whale{wn}.wlocSmoothLatLonDepth(:,3));
        maxDepth = max(whale{wn}.wlocSmoothLatLonDepth(:,3));
        meanDepth = mean(whale{wn}.wlocSmoothLatLonDepth(:,3));
        if v~=1
            dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
        elseif v == 1
            dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
        end
        v = horzcat(v,meanSpd(wn),deltaSpd(wn),totalDist(wn),trackNum2,01,minDepth,maxDepth,meanDepth,dur);
        xd = vertcat(xd,v);
        end
    end  
end

i=3;
for i = 3:length(e)
    
    myFile = dir([e(i).folder,'\',e(i).name,'\z_stats.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name]));
    trackNum2 = str2num(extractAfter(e(i).name,'track'));
    % z_stats = z_stats';
    myFile = dir([e(i).folder,'\',e(i).name,'\*distSpd.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name]));
    myFile = dir([e(i).folder,'\',e(i).name,'\*whale.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name]));

    for wn = 1:size(z_stats,2)
        if ~isnan(z_stats(1,wn))
        v = z_stats(6,wn);
        minDepth = min(whale{wn}.wlocSmoothLatLonDepth(:,3));
        maxDepth = max(whale{wn}.wlocSmoothLatLonDepth(:,3));
        meanDepth = mean(whale{wn}.wlocSmoothLatLonDepth(:,3));
        if v~=1
            dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
        elseif v == 1
            dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
        end
        v = horzcat(v,meanSpd(wn),deltaSpd(wn),totalDist(wn),trackNum2,01,minDepth,maxDepth,meanDepth,dur);
        xe = vertcat(xe,v);
        end
    end  
end

% i=3;
% for i = 3:length(b)
% 
%     myFile = dir([b(i).folder,'\',b(i).name,'\z_stats.mat']); % load the folder name
%     load(fullfile([myFile.folder,'\',myFile.name]));
%     trackNum2 = str2num(extractAfter(b(i).name,'track'));
%     % z_stats = z_stats';
%     myFile = dir([b(i).folder,'\',b(i).name,'\*distSpd.mat']); % load the folder name
%     load(fullfile([myFile.folder,'\',myFile.name]));
%     myFile = dir([b(i).folder,'\',b(i).name,'\*whale.mat']); % load the folder name
%     load(fullfile([myFile.folder,'\',myFile.name]));
% 
%     for wn = 1:size(z_stats,2)
%         if ~isnan(z_stats(1,wn))
%         v = z_stats(6,wn);
%         minDepth = min(whale{wn}.wlocSmoothLatLonDepth(:,3));
%         maxDepth = max(whale{wn}.wlocSmoothLatLonDepth(:,3));
%         meanDepth = mean(whale{wn}.wlocSmoothLatLonDepth(:,3));
%          if v~=1
%             dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
%         elseif v == 1
%             if ed<length(whale{wn}.TDet)
%             dur = minutes(datetime(whale{wn}.TDet(ed),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
%             elseif ed>length(whale{wn}.TDet)
%             dur = minutes(datetime(whale{wn}.TDet(ed),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
%             end
%          end
%         v = horzcat(v,meanSpd(wn),deltaSpd(wn),totalDist(wn),trackNum2,02,minDepth,maxDepth,meanDepth, dur);
%         xb = vertcat(xb,v);
%         end
%     end
% 
% end
% 
% i=3;
% for i = 3:length(c)
% 
%     myFile = dir([c(i).folder,'\',c(i).name,'\z_stats.mat']); % load the folder name
%     load(fullfile([myFile.folder,'\',myFile.name]));
%     trackNum2 = str2num(extractAfter(c(i).name,'track'));
%     % z_stats = z_stats';
%     myFile = dir([c(i).folder,'\',c(i).name,'\*distSpd.mat']); % load the folder name
%     load(fullfile([myFile.folder,'\',myFile.name]));
%     myFile = dir([c(i).folder,'\',c(i).name,'\*whale.mat']); % load the folder name
%     load(fullfile([myFile.folder,'\',myFile.name]));
% 
%     for wn = 1:size(z_stats,2)
%         if ~isnan(z_stats(1,wn))
%         v = z_stats(6,wn);
%         minDepth = min(whale{wn}.wlocSmoothLatLonDepth(:,3));
%         maxDepth = max(whale{wn}.wlocSmoothLatLonDepth(:,3));
%         meanDepth = mean(whale{wn}.wlocSmoothLatLonDepth(:,3));
%          if v~=1
%             dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
%          elseif v == 1
%             if ed<length(whale{wn}.TDet)
%             dur = minutes(datetime(whale{wn}.TDet(ed),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
%             elseif ed>length(whale{wn}.TDet)
%             dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
%             end
%          end
%         v = horzcat(v,meanSpd(wn),deltaSpd(wn),totalDist(wn),trackNum2,03,minDepth,maxDepth,meanDepth, dur);
%         xc = vertcat(xc,v);
%         end
%     end
% 
% end
% 
% i=3;
% for i = 3:length(d)
% 
%     myFile = dir([d(i).folder,'\',d(i).name,'\z_stats.mat']); % load the folder name
%     load(fullfile([myFile.folder,'\',myFile.name]));
%     trackNum2 = str2num(extractAfter(d(i).name,'track'));
%     % z_stats = z_stats';
%     myFile = dir([d(i).folder,'\',d(i).name,'\*distSpd.mat']); % load the folder name
%     load(fullfile([myFile.folder,'\',myFile.name]));
%     myFile = dir([d(i).folder,'\',d(i).name,'\*whale.mat']); % load the folder name
%     load(fullfile([myFile.folder,'\',myFile.name]));
% 
%     for wn = 1:size(z_stats,2)
%         if ~isnan(z_stats(1,wn))
%         v = z_stats(6,wn);
%         minDepth = min(whale{wn}.wlocSmoothLatLonDepth(:,3));
%         maxDepth = max(whale{wn}.wlocSmoothLatLonDepth(:,3));
%         meanDepth = mean(whale{wn}.wlocSmoothLatLonDepth(:,3));
%          if v~=1
%             dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
%          elseif v == 1
%             if ed<length(whale{wn}.TDet)
%             dur = minutes(datetime(whale{wn}.TDet(ed),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
%             elseif ed>length(whale{wn}.TDet)
%             dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
%             end
%          end
%         v = horzcat(v,meanSpd(wn),deltaSpd(wn),totalDist(wn),trackNum2,04,minDepth,maxDepth,meanDepth, dur);
%         xd = vertcat(xd,v);
%         end
%     end
% 
% end
% 
% i=3;
% for i = 3:length(e)
% 
%     myFile = dir([e(i).folder,'\',e(i).name,'\z_stats.mat']); % load the folder name
%     load(fullfile([myFile.folder,'\',myFile.name]));
%     trackNum2 = str2num(extractAfter(e(i).name,'track'));
%     % z_stats = z_stats';
%     myFile = dir([e(i).folder,'\',e(i).name,'\*distSpd.mat']); % load the folder name
%     load(fullfile([myFile.folder,'\',myFile.name]));
%     myFile = dir([e(i).folder,'\',e(i).name,'\*whale.mat']); % load the folder name
%     load(fullfile([myFile.folder,'\',myFile.name]));
% 
%     for wn = 1:size(z_stats,2)
%         if ~isnan(z_stats(1,wn))
%         v = z_stats(6,wn);
%         minDepth = min(whale{wn}.wlocSmoothLatLonDepth(:,3));
%         maxDepth = max(whale{wn}.wlocSmoothLatLonDepth(:,3));
%         meanDepth = mean(whale{wn}.wlocSmoothLatLonDepth(:,3));
%          if v~=1
%             dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
%          elseif v == 1
%             if ed<length(whale{wn}.TDet)
%             dur = minutes(datetime(whale{wn}.TDet(ed),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
%             elseif ed>length(whale{wn}.TDet)
%             dur = minutes(datetime(whale{wn}.TDet(end),'convertfrom','datenum') - datetime(whale{wn}.TDet(1),'convertfrom','datenum'));
%             end
%          end
%         v = horzcat(v,meanSpd(wn),deltaSpd(wn),totalDist(wn),trackNum2,05,minDepth,maxDepth,meanDepth, dur);
%         xe = vertcat(xe,v);
%         end
%     end
% 
% end


X = vertcat(xa,xb,xc,xd,xe);
color = X(:,1);
dist = X(:,4);
speed = X(:,2);
deltaSpeed = X(:,3);
durtn = X(:,end);

type1 = X(find(X(:,1) == 1),:);
type2 = X(find(X(:,1) == 2),:);
type3 = X(find(X(:,1) == 3),:);
type4 = X(find(X(:,1) == 4),:);

% scatterplot of dist vs speed per dive class
figure
scatter(type1(:,4),type1(:,2),50,[0 0.4470 0.7410],'filled','displayname','Type 1')
hold on
scatter(type2(:,4),type2(:,2),50,[0.8500 0.3250 0.0980],'filled','displayname','Type 2')
scatter(type3(:,4),type3(:,2),50,[0.4660 0.6740 0.1880],'filled','displayname','Type 3')
% scatter(type4(:,3),type4(:,2),50,[0 0 0],'filled','displayname','Type 4')
hold off
legend
xlabel('Distance Traveled (m)');
ylabel('Average Track Speed (m/s)');
title('Site W Dive Classes by Speed, Distance');

saveas(figure(1),'F:\Zc_Analysis\tracking_figures\distance_speed\siteW_diveClasses_bySpeedDistance.jpg');

close all

%% scatterplot with the confidence interval centroids

mean1 = [mean(type1(:,4)) mean(type1(:,2))];
std1 = [std(type1(:,4)) std(type1(:,2))];
mean2 = [mean(type2(:,4)) mean(type2(:,2))];
std2 = [std(type2(:,4)) std(type2(:,2))];
mean3 = [mean(type3(:,4)) mean(type3(:,2))];
std3 = [std(type3(:,4)) std(type3(:,2))];

% plot
figure
scatter(type1(:,4),type1(:,2),10,[0 0.4470 0.7410],'filled','displayname','Type 1')
hold on
scatter(type2(:,4),type2(:,2),10,[0.8500 0.3250 0.0980],'filled','displayname','Type 2')
scatter(type3(:,4),type3(:,2),10,[0.4660 0.6740 0.1880],'filled','displayname','Type 3')
% axis equal %this is important so circles appear as circles
% Plot ellipses, then change their color and other properties
h = plotEllipses(mean1,std1); 
h.FaceColor = [0 0.4470 0.7410 0.15]; %4th value is undocumented: transparency
h.EdgeColor = [0 0.4470 0.7410]; 
h.LineWidth = 2; 
h = plotEllipses(mean2,std2); 
h.FaceColor = [0.8500 0.3250 0.0980 0.15]; %4th value is undocumented: transparency
h.EdgeColor = [0.8500 0.3250 0.0980]; 
h.LineWidth = 2; 
h = plotEllipses(mean3,std3); 
h.FaceColor = [0.4660 0.6740 0.1880 0.15]; %4th value is undocumented: transparency
h.EdgeColor = [0.4660 0.6740 0.1880]; 
h.LineWidth = 2; 
hold off
legend
xlabel('Distance Traveled (m)');
ylabel('Average Track Speed (m/s)');
title('Site W Dive Classes by Speed, Distance');

saveas(figure(1),'F:\Zc_Analysis\tracking_figures\distance_speed\siteW_diveClasses_bySpeedDistance_withEllipses.jpg');

%% plot by speed vs change in speed with centroids
mean1 = [mean(type1(:,2)) mean(type1(:,3))];
std1 = [std(type1(:,2)) std(type1(:,3))];
mean2 = [mean(type2(:,2)) mean(type2(:,3))];
std2 = [std(type2(:,2)) std(type2(:,3))];
mean3 = [mean(type3(:,2)) mean(type3(:,3))];
std3 = [std(type3(:,2)) std(type3(:,3))];


figure
scatter(type1(:,2),type1(:,3),10,[0 0.4470 0.7410],'filled','displayname','Type 1')
hold on
scatter(type2(:,2),type2(:,3),10,[0.8500 0.3250 0.0980],'filled','displayname','Type 2')
scatter(type3(:,2),type3(:,3),10,[0.4660 0.6740 0.1880],'filled','displayname','Type 3')
% scatter(type4(:,3),type4(:,2),50,[0 0 0],'filled','displayname','Type 4')
h = plotEllipses(mean1,std1); 
h.FaceColor = [0 0.4470 0.7410 0.15]; %4th value is undocumented: transparency
h.EdgeColor = [0 0.4470 0.7410]; 
h.LineWidth = 2; 
h = plotEllipses(mean2,std2); 
h.FaceColor = [0.8500 0.3250 0.0980 0.15]; %4th value is undocumented: transparency
h.EdgeColor = [0.8500 0.3250 0.0980]; 
h.LineWidth = 2; 
h = plotEllipses(mean3,std3); 
h.FaceColor = [0.4660 0.6740 0.1880 0.15]; %4th value is undocumented: transparency
h.EdgeColor = [0.4660 0.6740 0.1880]; 
h.LineWidth = 2; 
hold off
legend
xlabel('Average Track Speed (m/s)');
ylabel('Change in Speed Throughout Track (m/s)');
title('Site W Dive Classes by Speed, Change in Speed');
saveas(figure(2),'F:\Erics_detector\siteN_diveClasses_bySpeedDeltaSpeed.jpg');


%% make a struct with average speed, distance per dive class

% class 1
type1avgSpd = mean(type1(:,2));
type1stdSpd = std(type1(:,2));
type1avgDeltaSpd = mean(type1(:,3));
type1stdDeltaSpd = std(type1(:,3));
type1avgDist = mean(type1(:,4));
type1stdDist = std(type1(:,4));

% class 2
type2avgSpd = mean(type2(:,2));
type2stdSpd = std(type2(:,2));
type2avgDeltaSpd = mean(type2(:,3));
type2stdDeltaSpd = std(type2(:,3));
type2avgDist = mean(type2(:,4));
type2stdDist = std(type2(:,4));

% class 3
type3avgSpd = mean(type3(:,2));
type3stdSpd = std(type3(:,2));
type3avgDeltaSpd = mean(type3(:,3));
type3stdDeltaSpd = std(type3(:,3));
type3avgDist = mean(type3(:,4));
type3stdDist = std(type3(:,4));

diveStats = [];
% type 1
diveStats(1,1) = type1avgSpd;
diveStats(2,1) = type1stdSpd;
diveStats(3,1) = type1avgDeltaSpd;
diveStats(4,1) = type1stdDeltaSpd
diveStats(5,1) = type1avgDist;
diveStats(6,1) = type1stdDist;
% type 2
diveStats(1,2) = type2avgSpd;
diveStats(2,2) = type2stdSpd;
diveStats(3,2) = type2avgDeltaSpd;
diveStats(4,2) = type2stdDeltaSpd
diveStats(5,2) = type2avgDist;
diveStats(6,2) = type2stdDist;
% type 3
diveStats(1,3) = type3avgSpd;
diveStats(2,3) = type3stdSpd;
diveStats(3,3) = type3avgDeltaSpd;
diveStats(4,3) = type3stdDeltaSpd;
diveStats(5,3) = type3avgDist;
diveStats(6,3) = type3stdDist;

writematrix(diveStats,'F:\Zc_Analysis\speed_distance\siteW_diveStats.csv');


%% make histograms
t = tiledlayout(1,3,'tilespacing','compact')
nexttile
histogram(type1(:,2),'facecolor',[0 0.4470 0.7410])
xlim([0 3])
legend('Type 1')
nexttile
histogram(type2(:,2),'facecolor',[0.8500 0.3250 0.0980])
xlim([0 3])
legend('Type 2')
nexttile
histogram(type3(:,2),'facecolor',[0.4660 0.6740 0.1880])
xlim([0 3])
legend('Type 3')
% nexttile
% histogram(type4(:,2),'facecolor',[0 0 0])
% xlim([0 5])
% legend('Type 4')

title(t,'Site W')
xlabel(t,'Average Track Speed (m/s)')

t2 = tiledlayout(1,3,'tilespacing','compact')
nexttile
histogram(type1(:,3),'facecolor',[0 0.4470 0.7410])
% xlim([0 4000])
legend('Type 1')
nexttile
histogram(type2(:,3),'facecolor',[0.8500 0.3250 0.0980])
% xlim([0 4000])
legend('Type 2')
nexttile
histogram(type3(:,3),'facecolor',[0.4660 0.6740 0.1880])
% xlim([0 4000])
legend('Type 3')
% nexttile
% histogram(type4(:,3),'facecolor',[0 0 0])
% xlim([0 4000])
% legend('Type 4')

xlabel(t2,'Total Track Distance (m)')


%% plot speed for each file
df = dir('F:\Erics_detector\SOCAL_H_73\cleaned_tracks\track*');

for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*distSpd.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\z_stats.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    
    figure
    hold on
    for wn = 1:size(spd,2)
        if ~isempty(whale{wn})
            if z_stats(6,wn) == 1
                color = [0 0.4470 0.7410];
                speedidx = find(spd(:,wn));
                speed = spd(speedidx,wn);
                plot(whale{wn}.TDet(1:end-1),speed,'color',color,'linewidth',3,'displayname','Type 1')
            elseif z_stats(6,wn) == 2
                color = [0.8500 0.3250 0.0980];
                speedidx = find(spd(:,wn));
                speed = spd(speedidx,wn);
                plot(whale{wn}.TDet(1:end-1),speed,'color',color,'linewidth',3,'displayname','Type 2')
            elseif z_stats(6,wn) == 3
                color = [0.4660 0.6740 0.1880];
                speedidx = find(spd(:,wn));
                speed = spd(speedidx,wn);
                plot(whale{wn}.TDet(1:end-1),speed,'color',color,'linewidth',3,'displayname','Type 3')
            elseif z_stats(6,wn) == 4
                color = [0 0 0];
                speedidx = find(spd(:,wn));
                speed = spd(speedidx,wn);
                plot(whale{wn}.TDet(1:end-1),speed,'color',color,'linewidth',3,'displayname','Type 4')
            end
        end
    end
    datetick('x')
    hold off
    ylabel('Speed (m/s)')
    xlabel('Time (HH:mm)')
    title(['H 73 ',trackNum,' Speed Throughout Track (Smooth)'])
    saveas(figure(1),[myFile.folder,'\',trackNum,'_spdThruTrackPlotSmooth.jpg'])
    close all
end