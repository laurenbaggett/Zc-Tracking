%% plot_allTracks_bathy.m
% this script will plot the receiver positions and xy track positions for a
% single deployment

%% H 72

% load bathymetry
load('F:\bathymetry\W01.mat');
% load receiver positions
load('F:\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WE\dep\SOCAL_W_03_WE_harp4chParams');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WS\dep\SOCAL_W_03_WS_harp4chParams');
hydLoc{2} = recLoc;
h0 = mean([hydLoc{1}; hydLoc{2}]);
% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
% load whale positions
df = dir('J:\SOCAL_W_03\cleaned_tracks\track*');
% params
paramFile = 'C:\Users\Lauren\Documents\GitHub\wheresWhaledo\brushing.params';
global brushing
loadParams(paramFile)

% plot all sites
figure
contour(X,Y,Z,'black','showtext','on')
hold on
plot(hydLoc{1,1}(2),hydLoc{1,1}(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
plot(hydLoc{1,2}(2),hydLoc{1,2}(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        else
            plot(whale{wn}.LatLonDepth(:,2),whale{wn}.LatLonDepth(:,1),'color',brushing.params.colorMat(wn+2, :))
        end
    end
end
title('W 01, All Tracks (Raw)')
saveas(figure(1),'F:\Erics_detector\SOCAL_H_74\H_74_allTracksRaw_bathy.jpg')
close all

% individual tracks
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    
    figure
    contour(X,Y,Z,'black','showtext','on')
    hold on
    plot(hydLoc{1,1}(2),hydLoc{1,1}(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
    plot(hydLoc{1,2}(2),hydLoc{1,2}(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        else
            plot(whale{wn}.LatLonDepth(:,2),whale{wn}.LatLonDepth(:,1),'color',brushing.params.colorMat(wn+2, :))
        end
    end
    title(['H 74 ', trackNum,' (Raw)'])
    saveas(figure(1),[myFile.folder,'\',trackNum,'_bathyPlot.jpg'])
    close all
end

% plot the smooths!
figure
contour(X,Y,Z,'black','showtext','on')
hold on
plot(hydLoc{1,1}(2),hydLoc{1,1}(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
plot(hydLoc{1,2}(2),hydLoc{1,2}(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        else
            plot(whale{wn}.wlocSmoothLatLonDepth(:,2),whale{wn}.wlocSmoothLatLonDepth(:,1),'color',brushing.params.colorMat(wn+2, :))
        end
    end
end
title('H 74, All Tracks (Smooth)')
saveas(figure(1),'F:\Erics_detector\SOCAL_H_74\H_74_allTracksSmooth_bathy.jpg')
close all

% plot the smooths, color by time
figure
contour(X,Y,Z,'black','showtext','on')
hold on
plot(hydLoc{1,1}(2),hydLoc{1,1}(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
plot(hydLoc{1,2}(2),hydLoc{1,2}(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        else
            scatter(whale{wn}.wlocSmoothLatLonDepth(:,2),whale{wn}.wlocSmoothLatLonDepth(:,1),2,1:length(whale{wn}.TDet))
        end
    end
end
c = colorbar;
caxis([0 1000])
set(get(c,'Title'),'String','Time (idx)')
title('H 74, All Tracks (Smooth) By Time')
saveas(figure(1),'F:\Erics_detector\SOCAL_H_74\H_74_allTracksSmooth_bathyDuration.jpg')
close all

% individual tracks, but smooth
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    
    figure
    contour(X,Y,Z,'black','showtext','on')
    hold on
    plot(hydLoc{1,1}(2),hydLoc{1,1}(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
    plot(hydLoc{1,2}(2),hydLoc{1,2}(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        else
            plot(whale{wn}.wlocSmoothLatLonDepth(:,2),whale{wn}.wlocSmoothLatLonDepth(:,1),'color',brushing.params.colorMat(wn+2, :),'linewidth',2)
        end
    end
    title(['H 74 ', trackNum,' (Smooth)'])
    saveas(figure(1),[myFile.folder,'\',trackNum,'_bathyPlotSmooth.jpg'])
    close all
end


%% plot z value over time

% load whale positions
df = dir('F:\Erics_detector\SOCAL_H_73\cleaned_tracks\track*');
% params
paramFile = 'C:\Users\Lauren\Documents\GitHub\wheresWhaledo\brushing.params';
global brushing
loadParams(paramFile)

% plot all sites
figure
hold on
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        else
            plot(1:length(whale{wn}.TDet),whale{wn}.wlocSmoothLatLonDepth(:,3),'color',brushing.params.colorMat(wn+2, :))
        end
    end
end
title('H 74, All Tracks (Smooth)')
saveas(figure(1),'F:\Erics_detector\SOCAL_H_74\H_74_allTracksSmooth_depth.jpg')
close all

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
        elseif z_stats(6,wn) == 1
            color = [0 0.4470 0.7410];
            plot(1:length(whale{wn}.TDet),whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',1,'displayname','Type 1')
        elseif z_stats(6,wn) == 2
            color = [0.8500 0.3250 0.0980];
            plot(1:length(whale{wn}.TDet),whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',1,'displayname','Type 2')
        elseif z_stats(6,wn) == 3
            color = [0.4660 0.6740 0.1880];
            plot(1:length(whale{wn}.TDet),whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',1,'displayname','Type 3')
        else
            color = [0 0 0];
            plot(1:length(whale{wn}.TDet),whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',1,'displayname','Other')
        end
    end
end
title('H 72, All Tracks (Dive Class)')
ylabel('Depth (m)')
xlabel('Dive Duration (index)')
ylim([-1500 -400])
legendUnq()
legend
saveas(figure(1),'F:\Erics_detector\SOCAL_H_72\H_72_allTracksSmooth_diveClass.jpg')
close all

% plot depth for each file
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    figure
    hold on
    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        else
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


% plot depth for each file, color by dive class
for i = 1:length(df)
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\z_stats.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file


    figure
    hold on
    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        else
            
            if z_stats(6,wn) == 1
                color = [0 0.4470 0.7410];
                plot(whale{wn}.TDet,whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',3,'displayname','Type 1')
            elseif z_stats(6,wn) == 2
                color = [0.8500 0.3250 0.0980];
                plot(whale{wn}.TDet,whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',3,'displayname','Type 2')
            elseif z_stats(6,wn) == 3
                color = [0.4660 0.6740 0.1880];
                plot(whale{wn}.TDet,whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',3,'displayname','Type 3')
            elseif z_stats(6,wn) == 4
                color = [0 0 0];
                plot(whale{wn}.TDet,whale{wn}.wlocSmoothLatLonDepth(:,3),'color',color,'linewidth',3,'displayname','Type 4')
            end
        end
        
    end
    datetick('x')
    hold off
    ylabel('Depth (m)')
    xlabel('Time (HH:mm)')
    title(['H 74 ',trackNum,' Depth by Dive Class (Smooth)'])
    saveas(figure(1),[myFile.folder,'\',trackNum,'_depth_byDiveClassPlot_Smooth.jpg'])
    close all
end
