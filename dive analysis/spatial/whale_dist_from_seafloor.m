% whale_dist_from_seafloor
% LMB 3/7/24 2023a
% this script will calculate distance from the seafloor for each whale over
% time

%% define site
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

% % E 63
% hydLoc{1} = [32.65871  -119.47711 -1325.5285]; % EE
% hydLoc{2} = [32.65646  -119.48815 -1330.1631]; % EW
% h0 = mean([hydLoc{1}; hydLoc{2}]);
% hydLoc{3} = [32.65345  -119.48455 -1328.9836]; % ES

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
% load('F:\Tracking\Instrument_Orientation\SOCAL_H_73\SOCAL_H_73_HW\dep\SOCAL_H_73_HW_harp4chParams');
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

% load in the bathymetry data
lon = ncread('F:\Tracking\bathymetry\GEBCO\gebco_2023_n34.0_s31.0_w-121.0_e-117.0.nc','lon');
lat = ncread('F:\Tracking\bathymetry\GEBCO\gebco_2023_n34.0_s31.0_w-121.0_e-117.0.nc','lat');
elev = ncread('F:\Tracking\bathymetry\GEBCO\gebco_2023_n34.0_s31.0_w-121.0_e-117.0.nc','elevation');
% load('F:\Tracking\bathymetry\socal2');
% lon = X;
% lat = Y;
% elev = Z;

% restrict to just a certain distance around the site
% convert lat lon to meters, from Eric
plotAx = [-4000, 4000, -4000, 4000];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(lon)), lon, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(lat, h0(2).*ones(size(lat)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);

x = lon(Ix);
y = lat(Iy);
z = elev(Ix,Iy);
z = cast(z,"double");

%% load in the whale data

% load in the data
% for each point, find the closest lat/lon
% compare depths
% save
% calculate an average value? save per deployment?

df = dir(['F:\Tracking\Erics_detector\SOCAL_N_68\cleaned_tracks\track*']); % directory of folders containing files
distfromsfmeans = [];

for i = 1:length(df) % for each track

    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\z_stats.mat']); % load the folder name
    trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

    % for b = 1:numel(whale) % remove any fields that are 0x0
    %     if height(whale{b}) == 0
    %         whale{b} = [];
    %     end
    % end
    % whale(cellfun('isempty',whale)) = []; % remove any empty fields

    distfromsf = []; % initialize
    mn = []; % initialize again

    for wn = 1:length(whale) % for each whale

        if size(whale{wn},2)>14 % if we generated a smooth
            
            % convert smoothed location to lat/lon/depth
            [lat, lon] = xy2latlon_wgs84(whale{wn}.wlocSmooth(:,1),whale{wn}.wlocSmooth(:,2),h0(1),h0(2));
            zw = h0(3) + whale{wn}.wlocSmooth(:,3);
            wloc = [lat, lon, zw];

            abovesf = zeros(size(wloc,1),2);
            gebcosave = zeros(size(wloc,1),1);

            for p = 1:size(wloc,1) % for each smoothed point

                [~, closeLat] = min(abs(wloc(p,1)-y)); % find the closest lat value
                [~, closeLon] = min(abs(wloc(p,2)-x)); % find the closest lon value
                gebco = z(closeLon,closeLat); % subtract to get distance from seafloor
                gebcosave(p,1) = gebco;
                sfdist = abs(gebco) - abs(wloc(p,3));
                abovesf(p,2) = sfdist; % save the value
                abovesf(p,1) = whale{wn}.TDet(p); % and its time stamp

            end

            distfromsf{wn} = abovesf; % save for this whale
            mn{1,wn} = nanmean(abovesf(:,2)); % save the mean value
            mn{2,wn} = nanstd(abovesf(:,2)); % save the standard deviation
            mn{3,wn} = trackNum;
            mn{4,wn} = z_stats(6,wn);
            mn{5,wn} = nanmedian(abovesf(:,2));

        end

    end

    save([char(myFile.folder),'\',char(trackNum),'_distFromSeafloor.mat'],'distfromsf','mn'); % save the struct

    distfromsfmeans{i} = mn; % save values from this encounter to master spreadsheet

    % % plot this data
    % figure
    % hold on
    % for pt = numel(distfromsf)
    %     if height(distfromsf{pt}) ~= 0
    %         plot(distfromsf{pt}(:,1),distfromsf{pt}(:,2))
    %     end
    % end
    % datetick('x')
    % ylabel('Distance from seafloor [m]')
    % saveas(gcf,[myFile.folder,'\',trackNum,'_distFrmSeafloorFig.fig']); % save the fig

end

save('F:\Tracking\Erics_detector\SOCAL_N_68\deployment_stats\SOCAL_N_68_mean_distfromsf_NEW.mat','distfromsfmeans'); % save the struct

