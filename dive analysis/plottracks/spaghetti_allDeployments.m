% spaghetti_allDeployments

% site H
load('F:\Tracking\bathymetry\socal2');
% % H 72
% load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_HS\dep\SOCAL_H_72_HS_harp4chPar');
% hydLoc{1} = recLoc;
% clear recLoc
% load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_HW\dep\SOCAL_H_72_HW_harp4chParams');
% hydLoc{2} = recLoc;
% h0 = mean([hydLoc{1}; hydLoc{2}]);
% hydLoc{3} = [32.86117  -119.13516 -1282.5282];

% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
[h3(1), h3(2)] = latlon2xy_wgs84(hydLoc{3}(1), hydLoc{3}(2), h0(1), h0(2));
h3(3) = abs(h0(3))-abs(hydLoc{3}(3));

% convert lat lon to meters, from Eric
plotAx = [-4000, 4000, -4000, 4000];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(X)), X, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(Y, h0(2).*ones(size(Y)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);

df1 = dir('F:\Tracking\Erics_detector\SOCAL_H_72\cleaned_tracks\track*');
df2 = dir('F:\Tracking\Erics_detector\SOCAL_H_73\cleaned_tracks\track*');
df3 = dir('F:\Tracking\Erics_detector\SOCAL_H_74\cleaned_tracks\track*');
df4 = dir('F:\Tracking\Erics_detector\SOCAL_H_75\cleaned_tracks\track*');

dfs = {df1, df2, df3, df4};

figure
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
hold on
% plot(h1(2),h1(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
% plot(h2(2),h2(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
% plot(h3(2),h3(1),'o','markeredgecolor','black','markerfacecolor','black','markersize',10)
for j = 1:length(dfs)
 df = dfs(j);
    df = df{1,1};
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
  %  pause(1)
end
end
title('Site H Zc Tracks')
