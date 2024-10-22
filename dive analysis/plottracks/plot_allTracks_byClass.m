%% plot_allTracks_byClass

%% H72

% plot XY
% load bathymetry
load('F:\bathymetry\siteHgridLarge.mat');
% load receiver positions
load('F:\Instrument_Orientation\SOCAL_H_72_HS\dep\SOCAL_H_72_HS_harp4chPar');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Instrument_Orientation\SOCAL_H_72_HW\dep\SOCAL_H_72_HW_harp4chParams');
hydLoc{2} = recLoc;
h0 = mean([hydLoc{1}; hydLoc{2}]);
hydLoc{3} = [32.86117  -119.13516 -1282.5282];
% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
[h3(1), h3(2)] = latlon2xy_wgs84(hydLoc{3}(1), hydLoc{3}(2), h0(1), h0(2));
h3(3) = abs(h0(3))-abs(hydLoc{3}(3));
% load whale positions
df = dir('F:\Erics_detector\SOCAL_H_72\cleaned_tracks\track*');
% params
paramFile = 'C:\Users\Lauren\Documents\GitHub\wheresWhaledo\brushing.params';
global brushing
loadParams(paramFile)

% convert lat lon to meters, from Eric
plotAx = [-3500, 3500, -3500, 3500];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(X)), X, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(Y, h0(2).*ones(size(Y)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);

figure(4)
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
hold on
% plot(h1(2),h1(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
% plot(h2(2),h2(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
% plot(h3(2),h3(1),'o','markeredgecolor','black','markerfacecolor','black','markersize',10)
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\*z_stats.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        elseif z_stats(6,wn) == 1
            color = [0 0.4470 0.7410];
            plot(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),'color',color,'linewidth',.5)
        elseif z_stats(6,wn) == 2
            color = [0.8500 0.3250 0.0980];
            plot(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),'color',color,'linewidth',.5)
        elseif z_stats(6,wn) == 3
            color = [0.4660 0.6740 0.1880];
            plot(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),'color',color,'linewidth',.5)
        else
            continue
        end
    end
end
plot(h1(2),h1(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',6)
plot(h2(2),h2(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',6)
plot(h3(2),h3(1),'o','markeredgecolor','black','markerfacecolor','black','markersize',6)
set(gca,'XDir','reverse')
camroll(-90)
title('H 72')

% plot depth vs time
% plot all by classification type
figure(1)
ylim([-1500 -400])
title('H 74')
ylabel('Depth (m)')
xlabel('Track Duration')
hold on
figure(2)
ylim([-1500 -800])
title('H 74')
ylabel('Depth (m)')
xlabel('Track Duration')
hold on
figure(3)
ylim([-1500 -800])
title('H 74')
ylabel('Depth (m)')
xlabel('Track Duration')
hold on
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    load(fullfile([myFile.folder,'\z_stats.mat'])); % load the dive classification

    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        end
        
        tDur = datetime(whale{wn}.TDet,'convertfrom','datenum');
        
        for n = 1:length(tDur)
            tVec(n,1) = tDur(n) - tDur(1);
        end
        
        if z_stats(6,wn) == 1
            color = [0 0.4470 0.7410];
            figure(1)
            plot(tVec(:,1),whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',.5,'displayname','Type 1')
            xlim([duration(00,00,00) duration(00,50,00)])
        elseif z_stats(6,wn) == 2
            color = [0.8500 0.3250 0.0980];
            figure(2)
            plot(tVec(:,1),whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',.5,'displayname','Type 2')
            xlim([duration(00,00,00) duration(00,50,00)])
        elseif z_stats(6,wn) == 3
            color = [0.4660 0.6740 0.1880];
            figure(3)
            plot(tVec(:,1),whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',.5,'displayname','Type 3')
            xlim([duration(00,00,00) duration(00,50,00)])
        else
            continue
        end
        
        clear tVec
        
    end
end
title('H 72')
ylabel('Depth (m)')
xlabel('Track Duration')
ylim([-1500 -400])
set(figure(1), ylim([-1500 -400]))


%% H73
% plot XY
% load bathymetry
load('F:\bathymetry\siteHgridLarge.mat');
% load receiver positions
load('F:\Instrument_Orientation\SOCAL_H_73_HS\dep\SOCAL_H_73_HS_harp4chParams');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Instrument_Orientation\SOCAL_H_73_HW\dep\SOCAL_H_73_harp4chParams');
hydLoc{2} = recLoc;
h0 = mean([hydLoc{1}; hydLoc{2}]);
hydLoc{3} = [32.86098  -119.13526 -1268.0248];
% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
[h3(1), h3(2)] = latlon2xy_wgs84(hydLoc{3}(1), hydLoc{3}(2), h0(1), h0(2));
h3(3) = abs(h0(3))-abs(hydLoc{3}(3));
% load whale positions
df = dir('F:\Erics_detector\SOCAL_H_73\cleaned_tracks\track*');
% params
paramFile = 'C:\Users\Lauren\Documents\GitHub\wheresWhaledo\brushing.params';
global brushing
loadParams(paramFile)

% convert lat lon to meters, from Eric
plotAx = [-3500, 3500, -3500, 3500];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(X)), X, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(Y, h0(2).*ones(size(Y)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);

figure
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
hold on
% plot(h1(2),h1(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
% plot(h2(2),h2(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
% plot(h3(2),h3(1),'o','markeredgecolor','black','markerfacecolor','black','markersize',10)
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\*z_stats.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        elseif z_stats(6,wn) == 1
            color = [0 0.4470 0.7410];
            plot(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),'color',color,'linewidth',1)
        elseif z_stats(6,wn) == 2
            color = [0.8500 0.3250 0.0980];
            plot(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),'color',color,'linewidth',1)
        elseif z_stats(6,wn) == 3
            color = [0.4660 0.6740 0.1880];
            plot(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),'color',color,'linewidth',1)
        else
            continue
        end
    end
end
plot(h1(2),h1(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',6)
plot(h2(2),h2(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',6)
plot(h3(2),h3(1),'o','markeredgecolor','black','markerfacecolor','black','markersize',6)
set(gca,'XDir','reverse')
camroll(-90)
title('H 73')

% plot depth vs time
% plot all by classification type
figure(1)
ylim([-1500 -400])
title('H 73')
ylabel('Depth (m)')
xlabel('Track Duration')
hold on
figure(2)
ylim([-1500 -800])
title('H 73')
ylabel('Depth (m)')
xlabel('Track Duration')
hold on
figure(3)
ylim([-1500 -800])
title('H 73')
ylabel('Depth (m)')
xlabel('Track Duration')
hold onhold on
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    load(fullfile([myFile.folder,'\z_stats.mat'])); % load the dive classification

    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        end
                
        tDur = datetime(whale{wn}.TDet,'convertfrom','datenum');
        
        for n = 1:length(tDur)
            tVec(n,1) = tDur(n) - tDur(1);
        end
        
        if z_stats(6,wn) == 1
            color = [0 0.4470 0.7410];
            figure(1)
            plot(tVec(:,1),whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',.5,'displayname','Type 1')
            xlim([duration(00,00,00) duration(00,30,00)])
        elseif z_stats(6,wn) == 2
            color = [0.8500 0.3250 0.0980];
            figure(2)
            plot(tVec(:,1),whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',.5,'displayname','Type 2')
            xlim([duration(00,00,00) duration(00,30,00)])
        elseif z_stats(6,wn) == 3
            color = [0.4660 0.6740 0.1880];
            figure(3)
            plot(tVec(:,1),whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',.5,'displayname','Type 3')
            xlim([duration(00,00,00) duration(00,30,00)])
        else
            continue
        end
        
        clear tVec
        
    end
end
title('H 73')
ylabel('Depth (m)')
xlabel('Track Duration')
ylim([-1500 -400])


%% H74
% plot XY
% load bathymetry
load('F:\bathymetry\siteHgridLarge.mat');
% load receiver positions
load('F:\Instrument_Orientation\SOCAL_H_74_HS\rec\SOCAL_H_74_HS_harp4chParams');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Instrument_Orientation\SOCAL_H_74_HW\rec\SOCAL_H_74_HW_harp4chParams');
hydLoc{2} = recLoc;
h0 = mean([hydLoc{1}; hydLoc{2}]);
hydLoc{3} = [32.8578  -119.1355 0];
% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
[h3(1), h3(2)] = latlon2xy_wgs84(hydLoc{3}(1), hydLoc{3}(2), h0(1), h0(2));
h3(3) = abs(h0(3))-abs(hydLoc{3}(3));
% load whale positions
df = dir('F:\Erics_detector\SOCAL_H_74\cleaned_tracks\track*');
% params
paramFile = 'C:\Users\Lauren\Documents\GitHub\wheresWhaledo\brushing.params';
global brushing
loadParams(paramFile)

% convert lat lon to meters, from Eric
plotAx = [-3500, 3500, -3500, 3500];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(X)), X, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(Y, h0(2).*ones(size(Y)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);

figure
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
hold on
% plot(h1(2),h1(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
% plot(h2(2),h2(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
% plot(h3(2),h3(1),'o','markeredgecolor','black','markerfacecolor','black','markersize',10)
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\*z_stats.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        elseif z_stats(6,wn) == 1
            color = [0 0.4470 0.7410];
            plot(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),'color',color,'linewidth',1)
        elseif z_stats(6,wn) == 2
            color = [0.8500 0.3250 0.0980];
            plot(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),'color',color,'linewidth',1)
        elseif z_stats(6,wn) == 3
            color = [0.4660 0.6740 0.1880];
            plot(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),'color',color,'linewidth',1)
        else
            continue
        end
    end
end
plot(h1(2),h1(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',6)
plot(h2(2),h2(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',6)
plot(h3(2),h3(1),'o','markeredgecolor','black','markerfacecolor','black','markersize',6)
set(gca,'XDir','reverse')
camroll(-90)
title('H 74')

% plot depth vs time
% plot all by classification type
figure
hold on
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    load(fullfile([myFile.folder,'\z_stats.mat'])); % load the dive classification

    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        end
        
        tDur = datetime(whale{wn}.TDet,'convertfrom','datenum');
        
        for n = 1:length(tDur)
            tVec(n,1) = tDur(n) - tDur(1);
        end
        
        if z_stats(6,wn) == 1
            color = [0 0.4470 0.7410];
            plot(tVec(:,1),whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',.5,'displayname','Type 1')
            xlim([duration(00,00,00) duration(00,30,00)])
        elseif z_stats(6,wn) == 2
            color = [0.8500 0.3250 0.0980];
            plot(tVec(:,1),whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',.5,'displayname','Type 2')
            xlim([duration(00,00,00) duration(00,30,00)]) 
        elseif z_stats(6,wn) == 3
            color = [0.4660 0.6740 0.1880];
            plot(tVec(:,1),whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',.5,'displayname','Type 3')
            xlim([duration(00,00,00) duration(00,30,00)])
        else
            continue
        end
        
        clear tVec
        
    end
end
title('H 74')
ylabel('Depth (m)')
xlabel('Track Duration')
ylim([-1500 -400])

%% create dummy legend for illustrator

t1 = plot(NaN,NaN,'color',[0 0.4470 0.7410]);
t2 = plot(NaN,NaN,'color',[0.8500 0.3250 0.0980]);
t3 = plot(NaN,NaN,'color',[0.4660 0.6740 0.1880]);
legend([t1,t2,t3],{'Segment Type 1','Segment Type 2','Segment Type 3'});