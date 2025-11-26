%% plot_df_density
% LMB 03/23/2024

% plot a heatmap showing where the most tracks are for a given deployment

% initialize by making an empty matrix
xline = [-4000:100:4000]; % x limits, 1000 m bins
yline = [-4000:100:4000]'; % y limits 1000 m bins
grdf = zeros(length(xline),length(yline)); % final gridded zeros, initialized

dfList = {'SOCAL_N_68'};
% dfList = {'SOCAL_E_63'};

for m = 1:length(dfList)

df = dir(['F:\Tracking\Erics_detector\',char(dfList(m)),'\cleaned_tracks\track*']); % directory of folders containing files
spd = 60*60*24;

for i = 1:length(df) % for each track

    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

    for b = 1:numel(whale) % remove any fields that are 0x0
        if height(whale{b}) <= 2
            whale{b} = [];
        elseif size(whale{b},2)<15
            whale{b} = [];
        end
    end
    whale(cellfun('isempty',whale)) = []; % remove any empty fields

    if length(whale) >= 1 % if we have more than one whale

        % interpolate
        for wn = 1:numel(whale)
            tstart = whale{wn}.TDet(1);
            tend = whale{wn}.TDet(end);
            ti = tstart:1/spd:tend; % interpolate by 1 s interval
            lngth(wn) = length(whale{wn}.TDet);
            whaleI{wn}.TInterp = ti;
            for dim = 1:3
                whaleI{wn}.wlocSmooth(:, dim) = interp1(whale{wn}.TDet, whale{wn}.wlocSmooth(:, dim), ti);
            end
        end

        % initialize values for storing
        time = zeros(max(lngth),length(whale));
        x = zeros(max(lngth),length(whale));
        y = zeros(max(lngth),length(whale));
        z = zeros(max(lngth),length(whale));

        for wn = 1:length(whaleI) % for each whale

            time(1:length(whaleI{wn}.TInterp),wn) = whaleI{wn}.TInterp; % grab time
            x(1:length(whaleI{wn}.wlocSmooth(:,1)),wn) = whaleI{wn}.wlocSmooth(:,1); % grab x position
            y(1:length(whaleI{wn}.wlocSmooth(:,2)),wn) = whaleI{wn}.wlocSmooth(:,2); % grab y position
            z(1:length(whaleI{wn}.wlocSmooth(:,3)),wn) = whaleI{wn}.wlocSmooth(:,3); % grab z position

        end % close wn for loop

        % split the spatial grid into 10mx10m squares
        % add one to the grid when the whale passes through that grid
        % square
        % how far apart are those grid squares?

        % find the interpolated values for that grid, add them
        for wn = 1:length(whaleI) % for each interpolated whale

            grdt = zeros(length(xline),length(yline)); % temp gridded zeros, initialized

            for j = 1:length(whaleI{wn}.wlocSmooth(:,1)) % for each point

                x = find(whaleI{wn}.wlocSmooth(j,1) > xline(1:end-1) & whaleI{wn}.wlocSmooth(j,1) < xline(2:end)); % find which bin x value falls in
                y = find(whaleI{wn}.wlocSmooth(j,2) > yline(1:end-1) & whaleI{wn}.wlocSmooth(j,2) < yline(2:end)); % find which bin y value falls in
                grdt(x,y) = 1; % make the bin value 1
    
            end
            grdf = grdf+grdt;
        end
    end

    clear whale; clear whaleI;

end % for each whale
end % for each deployment

% plot this on a map

% load bathymetry
load('F:\Tracking\bathymetry\socal2');

% N 68
load('F:\Tracking\Instrument_Orientation\SOCAL_N_68\SOCAL_N_68_NS\dep\SOCAL_N_68_NS_harp4chParams');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Tracking\Instrument_Orientation\SOCAL_N_68\SOCAL_N_68_NW\dep\SOCAL_N_68_NW_harp4chParams');
hydLoc{2} = recLoc;
h0 = mean([hydLoc{1}; hydLoc{2}]);
hydLoc{3} = [32.36975  -118.56458 -1298.3579];
 
% E 63
% hydLoc{2} = [32.65871  -119.47711 -1325.5285]; % EE
% hydLoc{1} = [32.65646  -119.48815 -1330.1631]; % EW
% h0 = mean([hydLoc{1}; hydLoc{2}]);
% hydLoc{3} = [32.65345  -119.48455 -1328.9836]; % ES

% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
[h3(1), h3(2)] = latlon2xy_wgs84(hydLoc{3}(1), hydLoc{3}(2), h0(1), h0(2));
h3(3) = abs(h0(3))-abs(hydLoc{3}(3));

% convert lat lon to meters, from Eric
plotAx = [-4500, 4500, -4500, 4500];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(X)), X, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(Y, h0(2).*ones(size(Y)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);

cmap = cmocean('dense');
cmap = vertcat([1 1 1],cmap);
% grdf(grdf==0) = nan;
% grdf(70,80) = 100;

figure
h = imagesc(xline,yline,grdf')
set(h,'AlphaData',~isnan(grdf'))
colormap(cmap)
% colormap(flipud(plasma))
colorbar
% cRange = caxis;
hold on
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
% caxis(cRange)
caxis([0 20]) % site N % caxis([0 20]) % site E
set(gca,'YDir','normal')
plot(h1(1),h1(2),'s','markeredgecolor','white','markerfacecolor',[0 0 0],'markersize',6);
plot(h2(1),h2(2),'s','markeredgecolor','white','markerfacecolor',[0 0 0],'markersize',6);
plot(h3(1),h3(2),'o','markeredgecolor','white','markerfacecolor',[0 0 0],'markersize',6);
% plot(h3(1),h3(2),'o','markeredgecolor','white','markerfacecolor',[0.8 0.8 0.8],'markersize',6);
% title(['Site ',dfList{1}(7)])
xlim([-4500, 4500])
ylim([-4500, 4500])
axis equal

%% Site H

% plot a heatmap showing where the most tracks are for a given deployment
spd = 60*60*24;

% initialize by making an empty matrix
xline = [-4000:100:4000]; % x limits, 1000 m bins
yline = [-4000:100:4000]'; % y limits 1000 m bins
grdf = zeros(length(xline),length(yline)); % final gridded zeros, initialized

dfList = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75'};

% H 72
load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_HS\dep\SOCAL_H_72_HS_harp4chPar');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_HW\dep\SOCAL_H_72_HW_harp4chParams');
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

for m = 1:length(dfList)

% load whale positions
    df = dir(['F:\Tracking\Erics_detector\',dfList{m},'\cleaned_tracks\track*']);
    if dfList{m} == 'SOCAL_H_72'
        offset = [0 0 0]; % already loaded this
    elseif dfList{m} == 'SOCAL_H_73'
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_73\SOCAL_H_73_HS\dep\SOCAL_H_73_HS_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_73\SOCAL_H_73_HW\dep\SOCAL_H_73_HW_harp4chParams');
        hydLoc{2} = recLoc;
        h0_2 = mean([hydLoc{1}; hydLoc{2}]);
        [offset(1) offset(2)] = latlon2xy_wgs84(h0_2(1), h0_2(2), h0(1), h0(2));
        offset(3) = h0_2(3)-h0(3);
    elseif dfList{m} == 'SOCAL_H_74'
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_74\SOCAL_H_74_HS\rec\SOCAL_H_74_HS_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_74\SOCAL_H_74_HW\rec\SOCAL_H_74_HW_harp4chParams');
        hydLoc{2} = recLoc;
        h0_2 = mean([hydLoc{1}; hydLoc{2}]);
        [offset(1) offset(2)] = latlon2xy_wgs84(h0_2(1), h0_2(2), h0(1), h0(2));
        offset(3) = h0_2(3)-h0(3);
    elseif dfList{m} == 'SOCAL_H_75'
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_75\SOCAL_H_75_HS\rec\SOCAL_H_75_HS_harp4chPar');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_75\SOCAL_H_75_HW\rec\SOCAL_H_75_HW_harp4chParams');
        hydLoc{2} = recLoc;
        h0_2 = mean([hydLoc{1}; hydLoc{2}]);
        [offset(1) offset(2)] = latlon2xy_wgs84(h0_2(1), h0_2(2), h0(1), h0(2));
        offset(3) = h0_2(3)-h0(3);
    end

for i = 1:length(df) % for each track

    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

    for b = 1:numel(whale) % remove any fields that are 0x0
        if height(whale{b}) <= 2
            whale{b} = [];
        elseif size(whale{b},2)<15
            whale{b} = [];
        end
    end
    whale(cellfun('isempty',whale)) = []; % remove any empty fields

    if length(whale) >= 1 % if we have more than one whale

        % interpolate
        for wn = 1:numel(whale)
            tstart = whale{wn}.TDet(1);
            tend = whale{wn}.TDet(end);
            ti = tstart:1/spd:tend; % interpolate by 1 s interval
            lngth(wn) = length(whale{wn}.TDet);
            whaleI{wn}.TInterp = ti;
            for dim = 1:3
                whaleI{wn}.wlocSmooth(:, dim) = interp1(whale{wn}.TDet, whale{wn}.wlocSmooth(:, dim), ti);
            end
        end

        % initialize values for storing
        time = zeros(max(lngth),length(whale));
        x = zeros(max(lngth),length(whale));
        y = zeros(max(lngth),length(whale));
        z = zeros(max(lngth),length(whale));

        for wn = 1:length(whaleI) % for each whale

            time(1:length(whaleI{wn}.TInterp),wn) = whaleI{wn}.TInterp; % grab time
            x(1:length(whaleI{wn}.wlocSmooth(:,1)),wn) = whaleI{wn}.wlocSmooth(:,1); % grab x position
            y(1:length(whaleI{wn}.wlocSmooth(:,2)),wn) = whaleI{wn}.wlocSmooth(:,2); % grab y position
            z(1:length(whaleI{wn}.wlocSmooth(:,3)),wn) = whaleI{wn}.wlocSmooth(:,3); % grab z position
            x = x+offset(1);
            y = y+offset(2);
            z = z+offset(3);

        end % close wn for loop

        % split the spatial grid into 10mx10m squares
        % add one to the grid when the whale passes through that grid
        % square
        % how far apart are those grid squares?

        % find the interpolated values for that grid, add them
        for wn = 1:length(whaleI) % for each interpolated whale

            grdt = zeros(length(xline),length(yline)); % temp gridded zeros, initialized

            for j = 1:length(whaleI{wn}.wlocSmooth(:,1)) % for each point

                x = find(whaleI{wn}.wlocSmooth(j,1) > xline(1:end-1) & whaleI{wn}.wlocSmooth(j,1) < xline(2:end)); % find which bin x value falls in
                y = find(whaleI{wn}.wlocSmooth(j,2) > yline(1:end-1) & whaleI{wn}.wlocSmooth(j,2) < yline(2:end)); % find which bin y value falls in
                grdt(x,y) = 1; % make the bin value 1
    
            end
            grdf = grdf+grdt;
        end
    end

    clear whale; clear whaleI;

end % for each whale
end % for each deployment

% plot this on a map

% load bathymetry
load('F:\Tracking\bathymetry\socal2');

% % H 72
% hydLoc{1} = [32.85651  -119.13880 -1248.9655]; % HS
% hydLoc{2} = [32.86211  -119.14259 -1263.1919]; % HW
% h0 = mean([hydLoc{1}; hydLoc{2}]);
% hydLoc{3} = [32.86117  -119.13516 -1282.5282]; % HE

% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
[h3(1), h3(2)] = latlon2xy_wgs84(hydLoc{3}(1), hydLoc{3}(2), h0(1), h0(2));
h3(3) = abs(h0(3))-abs(hydLoc{3}(3));

% convert lat lon to meters, from Eric
plotAx = [-4500, 4500, -4500, 4500];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(X)), X, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(Y, h0(2).*ones(size(Y)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);

cmap = cmocean('dense');
cmap = vertcat([1 1 1],cmap);
grdf(grdf==0) = nan;
% max(grdf)

figure
imagesc(xline, yline, grdf')
% set(h,'AlphaData',~isnan(grdf'))
colormap(cmap)
% colormap(flipud(plasma))
colorbar
% cRange = caxis;
hold on
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
% caxis(cRange)
caxis([0 32])
set(gca,'YDir','normal')
plot(h1(1),h1(2),'s','markeredgecolor','white','markerfacecolor',[1.0000    1.0000    0.0667],'markersize',6);
plot(h2(1),h2(2),'s','markeredgecolor','white','markerfacecolor',[1.0000    1.0000    0.0667],'markersize',6);
% plot(h3(1),h3(2),'o','markeredgecolor','white','markerfacecolor',[0.8 0.8 0.8],'markersize',6);
xlim([-4500, 4500])
ylim([-4500, 4500])
axis equal
% title(['Site ',dfList{1}(7)])


%% Site W

% plot a heatmap showing where the most tracks are for a given deployment
spd = 60*60*24;

vp = [33.53503 -120.2560];

% initialize by making an empty matrix
xline = [-4500:100:4500]; % x limits, 1000 m bins
yline = [-4500:100:4500]'; % y limits 1000 m bins
grdf = zeros(length(xline),length(yline)); % final gridded zeros, initialized

dfList = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04', 'SOCAL_W_05'};

% load receiver positions
% W 01
load('F:\Tracking\Instrument_Orientation\SOCAL_W_01\SOCAL_W_01_WE\dep\SOCAL_W_01_WE_harp4chPar');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Tracking\Instrument_Orientation\SOCAL_W_01\SOCAL_W_01_WS\dep\SOCAL_W_01_WS_harp4chPar');
hydLoc{2} = recLoc;
h0 = mean([hydLoc{1}; hydLoc{2}]);
hydLoc{3} = [33.53973  -120.25815 -1377.8741];

% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
[h3(1), h3(2)] = latlon2xy_wgs84(hydLoc{3}(1), hydLoc{3}(2), h0(1), h0(2));
h3(3) = abs(h0(3))-abs(hydLoc{3}(3));

[vp(1), vp(2)] = latlon2xy_wgs84(vp(1),vp(2),h0(1),h0(2));

for m = 1:length(dfList)

% load whale positions
    df = dir(['F:\Tracking\Erics_detector\',dfList{m},'\cleaned_tracks\track*']);
    if dfList{m} == 'SOCAL_W_01'
        offset = [0 0 0]; % already loaded this
    elseif dfList{m} == 'SOCAL_W_02'
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_02\SOCAL_W_02_WE\dep\SOCAL_W_02_WE_dep_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_02\SOCAL_W_02_WS\dep\SOCAL_W_02_WS_harp4chParams.mat');
        hydLoc{2} = recLoc;
        h0_2 = mean([hydLoc{1}; hydLoc{2}]);
        [offset(1) offset(2)] = latlon2xy_wgs84(h0_2(1), h0_2(2), h0(1), h0(2));
        offset(3) = h0_2(3)-h0(3);
    elseif dfList{m} == 'SOCAL_W_03'
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WS\dep\SOCAL_W_03_WS_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WE\dep\SOCAL_W_03_WE_harp4chParams');
        hydLoc{2} = recLoc;
        h0_2 = mean([hydLoc{1}; hydLoc{2}]);
        [offset(1) offset(2)] = latlon2xy_wgs84(h0_2(1), h0_2(2), h0(1), h0(2));
        offset(3) = h0_2(3)-h0(3);
    elseif dfList{m} == 'SOCAL_W_04'
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_04\SOCAL_W_04_WS\dep\SOCAL_W_04_WS_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_04\SOCAL_W_04_WE\dep\SOCAL_W_04_WE_harp4chParams');
        hydLoc{2} = recLoc;
        h0_2 = mean([hydLoc{1}; hydLoc{2}]);
        [offset(1) offset(2)] = latlon2xy_wgs84(h0_2(1), h0_2(2), h0(1), h0(2));
        offset(3) = h0_2(3)-h0(3);
    elseif dfList{m} == 'SOCAL_W_05'
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_05\SOCAL_W_05_WE\REDO\SOCAL_W_05_WE_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_05\SOCAL_W_05_WS\REDO\SOCAL_W_05_WS_harp4chParams');
        hydLoc{2} = recLoc;
        h0_2 = mean([hydLoc{1}; hydLoc{2}]);
        [offset(1) offset(2)] = latlon2xy_wgs84(h0_2(1), h0_2(2), h0(1), h0(2));
        offset(3) = h0_2(3)-h0(3);
    end

for i = 1:length(df) % for each track

    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

    for b = 1:numel(whale) % remove any fields that are 0x0
        if height(whale{b}) <= 2
            whale{b} = [];
        elseif size(whale{b},2)<15
            whale{b} = [];
        end
    end
    whale(cellfun('isempty',whale)) = []; % remove any empty fields

    if length(whale) >= 1 % if we have more than one whale

        % interpolate
        for wn = 1:numel(whale)
            tstart = whale{wn}.TDet(1);
            tend = whale{wn}.TDet(end);
            ti = tstart:1/spd:tend; % interpolate by 1 s interval
            lngth(wn) = length(whale{wn}.TDet);
            whaleI{wn}.TInterp = ti;
            for dim = 1:3
                whaleI{wn}.wlocSmooth(:, dim) = interp1(whale{wn}.TDet, whale{wn}.wlocSmooth(:, dim), ti);
            end
        end

        % initialize values for storing
        time = zeros(max(lngth),length(whale));
        x = zeros(max(lngth),length(whale));
        y = zeros(max(lngth),length(whale));
        z = zeros(max(lngth),length(whale));

        for wn = 1:length(whaleI) % for each whale

            time(1:length(whaleI{wn}.TInterp),wn) = whaleI{wn}.TInterp; % grab time
            x(1:length(whaleI{wn}.wlocSmooth(:,1)),wn) = whaleI{wn}.wlocSmooth(:,1); % grab x position
            y(1:length(whaleI{wn}.wlocSmooth(:,2)),wn) = whaleI{wn}.wlocSmooth(:,2); % grab y position
            z(1:length(whaleI{wn}.wlocSmooth(:,3)),wn) = whaleI{wn}.wlocSmooth(:,3); % grab z position
            x = x+offset(1);
            y = y+offset(2);
            z = z+offset(3);

        end % close wn for loop

        % split the spatial grid into 10mx10m squares
        % add one to the grid when the whale passes through that grid
        % square
        % how far apart are those grid squares?

        % find the interpolated values for that grid, add them
        for wn = 1:length(whaleI) % for each interpolated whale

            grdt = zeros(length(xline),length(yline)); % temp gridded zeros, initialized

            for j = 1:length(whaleI{wn}.wlocSmooth(:,1)) % for each point

                x = find(whaleI{wn}.wlocSmooth(j,1) > xline(1:end-1) & whaleI{wn}.wlocSmooth(j,1) < xline(2:end)); % find which bin x value falls in
                y = find(whaleI{wn}.wlocSmooth(j,2) > yline(1:end-1) & whaleI{wn}.wlocSmooth(j,2) < yline(2:end)); % find which bin y value falls in
                grdt(x,y) = 1; % make the bin value 1
    
            end
            grdf = grdf+grdt;
        end
    end

    clear whale; clear whaleI;

end % for each whale
end % for each deployment

% plot this on a map

% load bathymetry
load('F:\Tracking\bathymetry\socal2');

% restrict spatially
plotAx = [-4500, 4500, -4500, 4500];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(X)), X, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(Y, h0(2).*ones(size(Y)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);

cmap = cmocean('dense');
% cmap = vertcat([1 1 1],cmap);
grdf(grdf==0) = nan;

figure
h = imagesc(xline, yline, grdf')
set(h,'AlphaData',~isnan(grdf'))
colormap(cmap)
% colormap(flipud(plasma))
colorbar
% cRange = caxis;
hold on
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
% caxis(cRange)
caxis([0 120])
set(gca,'YDir','normal')
plot(h1(1),h1(2),'s','markeredgecolor','white','markerfacecolor',[1.0000    1.0000    0.0667],'markersize',6);
plot(h2(1),h2(2),'s','markeredgecolor','white','markerfacecolor',[1.0000    1.0000    0.0667],'markersize',6);
plot(h3(1),h3(2),'o','markeredgecolor','white','markerfacecolor',[1.0000    1.0000    0.0667],'markersize',6);
plot(vp(1),vp(2),'o','markeredgecolor','white','markerfacecolor','red','markersize',6);
xlim([-4500, 4500])
ylim([-4500, 4500])
axis equal
% plot(h3(1),h3(2),'o','markeredgecolor','white','markerfacecolor',[0.8 0.8 0.8],'markersize',6);
% title(['Site ',dfList{1}(7)])


