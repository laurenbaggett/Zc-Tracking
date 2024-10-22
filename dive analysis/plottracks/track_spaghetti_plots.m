%% track_spaghetti_plots

% this script will make spaghetti tracks at each site/deployment with the
% bathymetry and depth

%% site H

% load bathymetry
load('F:\Tracking\bathymetry\socal2');

% load receiver positions
% % H 72
% load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_HS\dep\SOCAL_H_72_HS_harp4chPar');
% hydLoc{1} = recLoc;
% clear recLoc
% load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_HW\dep\SOCAL_H_72_HW_harp4chParams');
% hydLoc{2} = recLoc;
% h0 = mean([hydLoc{1}; hydLoc{2}]);
% hydLoc{3} = [32.86117  -119.13516 -1282.5282];
% % H 73
% load('F:\Tracking\Instrument_Orientation\SOCAL_H_73\SOCAL_H_73_HS\dep\SOCAL_H_73_HS_harp4chParams');
% hydLoc{1} = recLoc;
% clear recLoc
% load('F:\Tracking\Instrument_Orientation\SOCAL_H_73\SOCAL_H_73_HW\dep\SOCAL_H_73_harp4chParams');
% hydLoc{2} = recLoc;
% h0 = mean([hydLoc{1}; hydLoc{2}]);
% hydLoc{3} = [32.86098  -119.13526 -1268.0248];
% % H 74
% load('F:\Tracking\Instrument_Orientation\SOCAL_H_74\SOCAL_H_74_HS\rec\SOCAL_H_74_HS_harp4chParams');
% hydLoc{1} = recLoc;
% clear recLoc
% load('F:\Tracking\Instrument_Orientation\SOCAL_H_74\SOCAL_H_74_HW\rec\SOCAL_H_74_HW_harp4chParams');
% hydLoc{2} = recLoc;
% h0 = mean([hydLoc{1}; hydLoc{2}]);
% hydLoc{3} = [32.8609  -119.1353 -1272];
% % H 75
% load('F:\Tracking\Instrument_Orientation\SOCAL_H_75\SOCAL_H_75_HS\rec\SOCAL_H_75_HS_harp4chPar');
% hydLoc{1} = recLoc;
% clear recLoc
% load('F:\Tracking\Instrument_Orientation\SOCAL_H_75\SOCAL_H_75_HW\rec\SOCAL_H_75_HW_harp4chParams');
% hydLoc{2} = recLoc;
% h0 = mean([hydLoc{1}; hydLoc{2}]);
% hydLoc{3} = [32.86216  -119.13519 -1284.5215];

% N 68
load('F:\Tracking\Instrument_Orientation\SOCAL_N_68\SOCAL_N_68_NS\dep\SOCAL_N_68_NS_harp4chParams');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Tracking\Instrument_Orientation\SOCAL_N_68\SOCAL_N_68_NW\dep\SOCAL_N_68_NW_harp4chParams');
hydLoc{2} = recLoc;
h0 = mean([hydLoc{1}; hydLoc{2}]);
hydLoc{3} = [32.36975  -118.56458 -1298.3579];

% % E 63
% hydLoc{2} = [32.65871  -119.47711 -1325.5285]; % EE
% hydLoc{1} = [32.65646  -119.48815 -1330.1631]; % EW
% h0 = mean([hydLoc{1}; hydLoc{2}]);
% hydLoc{3} = [32.65345  -119.48455 -1328.9836]; % ES

% % W 01
% load('F:\Tracking\Instrument_Orientation\SOCAL_W_01\SOCAL_W_01_WE\dep\SOCAL_W_01_WE_harp4chPar');
% hydLoc{1} = recLoc;
% clear recLoc
% load('F:\Tracking\Instrument_Orientation\SOCAL_W_01\SOCAL_W_01_WS\dep\SOCAL_W_01_WS_harp4chPar');
% hydLoc{2} = recLoc;
% h0 = mean([hydLoc{1}; hydLoc{2}]);
% hydLoc{3} = [33.53973  -120.25815 -1377.8741];
% % W 02
% load('F:\Tracking\Instrument_Orientation\SOCAL_W_02\SOCAL_W_02_WE\dep\SOCAL_W_02_WE_dep_harp4chParams');
% hydLoc{1} = recLoc;
% clear recLoc
% load('F:\Tracking\Instrument_Orientation\SOCAL_W_02\SOCAL_W_02_WS\dep\SOCAL_W_02_WS_harp4chParams.mat');
% hydLoc{2} = recLoc;
% h0 = mean([hydLoc{1}; hydLoc{2}]);
% hydLoc{3} = [33.54057  -120.25866 -1370.4091];
% % W 03
% load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WS\dep\SOCAL_W_03_WS_harp4chParams');
% hydLoc{1} = recLoc;
% clear recLoc
% load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WE\dep\SOCAL_W_03_WE_harp4chParams');
% hydLoc{2} = recLoc;
% h0 = mean([hydLoc{1}; hydLoc{2}]);
% hydLoc{3} = [33.54117  -120.25922 -1383.9635];
% % W 04
% load('F:\Tracking\Instrument_Orientation\SOCAL_W_04\SOCAL_W_04_WS\dep\SOCAL_W_04_WS_harp4chParams');
% hydLoc{1} = recLoc;
% clear recLoc
% load('F:\Tracking\Instrument_Orientation\SOCAL_W_04\SOCAL_W_04_WE\dep\SOCAL_W_04_WE_harp4chParams');
% hydLoc{2} = recLoc;
% h0 = mean([hydLoc{1}; hydLoc{2}]);
% hydLoc{3} = [33.54079  -120.25996 -1387.6076];
% % W 05
% load('F:\Tracking\Instrument_Orientation\SOCAL_W_05\SOCAL_W_05_WE\REDO\SOCAL_W_05_WE_harp4chParams');
% hydLoc{1} = recLoc;
% clear recLoc
% load('F:\Tracking\Instrument_Orientation\SOCAL_W_05\SOCAL_W_05_WS\REDO\SOCAL_W_05_WS_harp4chParams');
% hydLoc{2} = recLoc;
% h0 = mean([hydLoc{1}; hydLoc{2}]);
% hydLoc{3} = [33.54196  -120.25820 -1510.562];


% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
[h3(1), h3(2)] = latlon2xy_wgs84(hydLoc{3}(1), hydLoc{3}(2), h0(1), h0(2));
h3(3) = abs(h0(3))-abs(hydLoc{3}(3));

% load whale positions
df = dir('F:\Tracking\Erics_detector\SOCAL_N_68\cleaned_tracks\track*');
% params
paramFile = 'C:\Users\Lauren\Documents\GitHub\Wheres-Whaledo\DOA_small_aperture\params\brushing_pastel';
global brushing
loadParams(paramFile)

% convert lat lon to meters, from Eric
plotAx = [-4000, 4000, -4000, 4000];
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
    % trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        elseif length(whale{wn}.wloc) > 5
            % calculate normalized time for the track
            nTime = [];
            for n = 1:length(whale{wn}.wlocSmooth(:,2))
                nTime(n,1) = n/length(whale{wn}.wlocSmooth(:,2));
            end
            % gscatter(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),nTime)
            patch([whale{1,wn}.wlocSmooth(:,2);nan], [whale{1,wn}.wlocSmooth(:,1);nan],[nTime;nan],'facecolor','none','edgecolor','interp','linewidth',2.0)
            caxis([0 1])
            % scatter(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),4,nTime,'filled')
        end
    end
 % pause(1)
end
caxis([0 1])
colorbar()
plot(h1(1),h1(2),'s','markeredgecolor','black','markerfacecolor','black','markersize',6);
plot(h2(1),h2(2),'s','markeredgecolor','black','markerfacecolor','black','markersize',6);
plot(h3(1),h3(2),'o','markeredgecolor','black','markerfacecolor','black','markersize',6);
% set(gca,'XDir','reverse')
% camroll(-90)
axis equal
title('E 63')


figure
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
hold on
% plot(h1(2),h1(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
% plot(h2(2),h2(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
% plot(h3(2),h3(1),'o','markeredgecolor','black','markerfacecolor','black','markersize',10)
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale_crawl.mat']); % load the folder name
    if height(myFile) > 0
        % trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
        for wn = 1:length(smoothed_walk)
            if isempty(smoothed_walk{wn}) % if no whale with this num
                continue
            elseif length(smoothed_walk{wn}.wlocSmooth) > 5
                % calculate normalized time for the track
                nTime = [];
                for n = 1:length(smoothed_walk{wn}.wlocSmooth(:,2))
                    nTime(n,1) = n/length(smoothed_walk{wn}.wlocSmooth(:,2));
                end
                % gscatter(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),nTime)
                patch([smoothed_walk{1,wn}.wlocSmooth(:,2);nan], [smoothed_walk{1,wn}.wlocSmooth(:,1);nan],[nTime;nan],'facecolor','none','edgecolor','interp','linewidth',2.0)
                caxis([0 1])
                % scatter(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),4,nTime,'filled')
            end
        end
        % pause(1)
    end
end
caxis([0 1])
colorbar()
plot(h1(1),h1(2),'s','markeredgecolor','black','markerfacecolor','black','markersize',6);
plot(h2(1),h2(2),'s','markeredgecolor','black','markerfacecolor','black','markersize',6);
plot(h3(1),h3(2),'o','markeredgecolor','black','markerfacecolor','black','markersize',6);


% depth over time
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    figure
    hold on
    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        elseif length(whale{wn}.wloc) > 5
            plot(whale{wn}.TDet,whale{wn}.wlocSmoothLatLonDepth(:,3),'color',brushing.params.colorMat(wn+2, :),'linewidth',3)
        end
    end
    datetick('x')
    hold off
    ylabel('Depth (m)')
    xlabel('Time (HH:mm)')
    % title(['H 73 ',trackNum,' (Smooth)'])
    saveas(figure(1),[myFile.folder,'\',trackNum,'_depthPlotnotSmoothed.jpg'])
    close all
end

lon = X(find(X>-119.52&X<-119.42))
lat = Y(find(Y>32.625&Y<32.670))
depth = Z(find(Y>32.625&Y<32.670), find(X>-119.52&X<-119.42))

figure
contour(lon,lat,depth,'black','showtext','on')
hold on
plot(hydLoc{1}(2),hydLoc{1}(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',6);
plot(hydLoc{2}(2),hydLoc{2}(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',6);
plot(hydLoc{3}(2),hydLoc{3}(1),'o','markeredgecolor','black','markerfacecolor','black','markersize',6)

%% put all deployments on same map!

% load bathymetry
load('F:\Tracking\bathymetry\socal2');

% load receiver positions
% H 72
load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_HS\dep\SOCAL_H_72_HS_harp4chPar');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_HW\dep\SOCAL_H_72_HW_harp4chParams');
hydLoc{2} = recLoc;
h0 = mean([hydLoc{1}; hydLoc{2}]);
hydLoc{3} = [32.86117  -119.13516 -1282.5282];

% load('F:\Tracking\Instrument_Orientation\SOCAL_W_01\SOCAL_W_01_WE\dep\SOCAL_W_01_WE_harp4chPar');
% hydLoc{1} = recLoc;
% clear recLoc
% load('F:\Tracking\Instrument_Orientation\SOCAL_W_01\SOCAL_W_01_WS\dep\SOCAL_W_01_WS_harp4chPar');
% hydLoc{2} = recLoc;
% h0 = mean([hydLoc{1}; hydLoc{2}]);
% hydLoc{3} = [33.53973  -120.25815 -1377.8741];

% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
[h3(1), h3(2)] = latlon2xy_wgs84(hydLoc{3}(1), hydLoc{3}(2), h0(1), h0(2));
h3(3) = abs(h0(3))-abs(hydLoc{3}(3));

% load whale positions
df1 = dir('F:\Tracking\Erics_detector\SOCAL_H_72\cleaned_tracks\track*');
df2 = dir('F:\Tracking\Erics_detector\SOCAL_H_73\cleaned_tracks\track*');
df3 = dir('F:\Tracking\Erics_detector\SOCAL_H_74\cleaned_tracks\track*');
df4 = dir('F:\Tracking\Erics_detector\SOCAL_H_75\cleaned_tracks\track*');
% df5 = dir('F:\Tracking\Erics_detector\SOCAL_W_05\cleaned_tracks\track*');
df = vertcat(df1,df2,df3,df4);

% params
paramFile = 'C:\Users\Lauren\Documents\GitHub\wheresWhaledo\brushing.params';
global brushing
loadParams(paramFile)

% convert lat lon to meters, from Eric
plotAx = [-4000, 4000, -4000, 4000];
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
    % trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        else
            % calculate normalized time for the track
            nTime = [];
            for n = 1:length(whale{wn}.wlocSmooth(:,2))
                nTime(n,1) = n/length(whale{wn}.wlocSmooth(:,2));
            end
            % gscatter(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),nTime)
            patch([whale{1,wn}.wlocSmooth(:,2);nan], [whale{1,wn}.wlocSmooth(:,1);nan],[nTime;nan],'facecolor','none','edgecolor','interp','linewidth',2.0)
            caxis([0 1])
            % scatter(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),4,nTime,'filled')
        end
    end
 % pause(1)
end
caxis([0 1])
colorbar()
plot(h1(1),h1(2),'s','markeredgecolor','black','markerfacecolor',[0.4 0.4 0.4],'markersize',6);
plot(h2(1),h2(2),'s','markeredgecolor','black','markerfacecolor',[0.4 0.4 0.4],'markersize',6);
plot(h3(1),h3(2),'o','markeredgecolor','black','markerfacecolor',[0.4 0.4 0.4],'markersize',6);
% set(gca,'XDir','reverse')
% camroll(-90)
axis equal
% title('SOCAL W (all deployments)')