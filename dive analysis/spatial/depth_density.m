%% depth density

%% Site E, N
% initialize by making an empty matrix
zline = [-1500:10:0]'; % z limits 10 m bins
grdf = zeros(length(zline),1); % final gridded zeros, initialized

dfList = {'SOCAL_N_68'};
% dfList = {'SOCAL_E_63'};

for m = 1:length(dfList)

    df = dir(['F:\Tracking\Erics_detector\',char(dfList(m)),'\cleaned_tracks\track*']); % directory of folders containing files
    spd = 60*60*24;

    if dfList{m} == 'SOCAL_N_68'
        load('F:\Tracking\Instrument_Orientation\SOCAL_N_68\SOCAL_N_68_NS\dep\SOCAL_N_68_NS_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_N_68\SOCAL_N_68_NW\dep\SOCAL_N_68_NW_harp4chParams');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
        hydLoc{3} = [32.36975  -118.56458 -1298.3579];
    elseif dfList{m} == 'SOCAL_E_63'
        hydLoc{2} = [32.65871  -119.47711 -1325.5285]; % EE
        hydLoc{1} = [32.65646  -119.48815 -1330.1631]; % EW
        h0 = mean([hydLoc{1}; hydLoc{2}]);
        hydLoc{3} = [32.65345  -119.48455 -1328.9836]; % ES
    end

    for i = 1:length(df)

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
            z = zeros(max(lngth),length(whale));

            for wn = 1:length(whaleI) % for each whale

                time(1:length(whaleI{wn}.TInterp),wn) = whaleI{wn}.TInterp; % grab time
                z(1:length(whaleI{wn}.wlocSmooth(:,3)),wn) = whaleI{wn}.wlocSmooth(:,3); % grab z position

            end % close wn for loop

            % split the spatial grid into 10mx10m squares
            % add one to the grid when the whale passes through that grid
            % square
            % how far apart are those grid squares?

            % find the interpolated values for that grid, add them
            for wn = 1:length(whaleI) % for each interpolated whale

                grdt = zeros(length(zline),1); % temp gridded zeros, initialized

                for j = 1:length(whaleI{wn}.wlocSmooth(:,1)) % for each point

                    z = find(whaleI{wn}.wlocSmooth(j,3)+h0(3) > zline(1:end-1) & whaleI{wn}.wlocSmooth(j,3)+h0(3) < zline(2:end)); % find which bin y value falls in
                    grdt(z) = 1; % make the bin value 1

                end
                grdf = grdf+grdt;
            end
        end

        clear whale; clear whaleI;

    end % for each encounter

end % for each deployment

% plot this!
figure
% scatter(grdf,zline,'filled','markerfacecolor',[0.3010 0.7450 0.9330]) % E
scatter(grdf,zline,'filled','markerfacecolor',[0.4940 0.1840 0.5560]) % N
hold on
% plot(grdf,zline,'linestyle','--','color',[0.3010 0.7450 0.9330]) % E
plot(grdf,zline,'linestyle','--','color',[0.4940 0.1840 0.5560]) % N
ylabel(['Depth (m)'])
xlabel(['Counts'])
title(['SOCAL ',dfList{m}(7),' ',dfList{m}(9:10)])
scatter(0,h0(3),30,'red','^','filled')


%% Site H

% initialize by making an empty matrix
zline = [-1500:10:0]'; % z limits 10 m bins
grdf = zeros(length(zline),1); % final gridded zeros, initialized

dfList = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75'};

for m = 1:length(dfList)

    df = dir(['F:\Tracking\Erics_detector\',char(dfList(m)),'\cleaned_tracks\track*']); % directory of folders containing files
    spd = 60*60*24;

    if dfList{m} == 'SOCAL_H_72'
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_HS\dep\SOCAL_H_72_HS_harp4chPar');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_72\SOCAL_H_72_HW\dep\SOCAL_H_72_HW_harp4chParams');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    elseif dfList{m} == 'SOCAL_H_73'
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_73\SOCAL_H_73_HS\dep\SOCAL_H_73_HS_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_73\SOCAL_H_73_HW\dep\SOCAL_H_73_HW_harp4chParams');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    elseif dfList{m} == 'SOCAL_H_74'
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_74\SOCAL_H_74_HS\rec\SOCAL_H_74_HS_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_74\SOCAL_H_74_HW\rec\SOCAL_H_74_HW_harp4chParams');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    elseif dfList{m} == 'SOCAL_H_75'
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_75\SOCAL_H_75_HS\rec\SOCAL_H_75_HS_harp4chPar');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_75\SOCAL_H_75_HW\rec\SOCAL_H_75_HW_harp4chParams');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    end

    for i = 1:length(df)

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
            z = zeros(max(lngth),length(whale));

            for wn = 1:length(whaleI) % for each whale

                time(1:length(whaleI{wn}.TInterp),wn) = whaleI{wn}.TInterp; % grab time
                z(1:length(whaleI{wn}.wlocSmooth(:,3)),wn) = whaleI{wn}.wlocSmooth(:,3); % grab z position

            end % close wn for loop

            % split the spatial grid into 10mx10m squares
            % add one to the grid when the whale passes through that grid
            % square
            % how far apart are those grid squares?

            % find the interpolated values for that grid, add them
            for wn = 1:length(whaleI) % for each interpolated whale

                grdt = zeros(length(zline),1); % temp gridded zeros, initialized

                for j = 1:length(whaleI{wn}.wlocSmooth(:,1)) % for each point

                    z = find(whaleI{wn}.wlocSmooth(j,3)+h0(3) > zline(1:end-1) & whaleI{wn}.wlocSmooth(j,3)+h0(3) < zline(2:end)); % find which bin y value falls in
                    grdt(z) = 1; % make the bin value 1

                end
                grdf = grdf+grdt;
            end
        end

        clear whale; clear whaleI;

    end % for each encounter

end % for each deployment

% plot this!
figure
scatter(grdf,zline,'filled','markerfacecolor',[0.8500 0.3250 0.0980])
hold on
plot(grdf,zline,'linestyle','--','color',[0.8500 0.3250 0.0980])
ylabel(['Depth (m)'])
xlabel(['Counts'])
title(['SOCAL H'])
scatter(0,h0(3),30,'red','^','filled')

%% SOCAL W

% initialize by making an empty matrix
zline = [-1500:10:0]'; % z limits 10 m bins
grdf = zeros(length(zline),1); % final gridded zeros, initialized

dfList = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};

for m = 1:length(dfList)

    df = dir(['F:\Tracking\Erics_detector\',char(dfList(m)),'\cleaned_tracks\track*']); % directory of folders containing files
    spd = 60*60*24;

    if dfList{m} == 'SOCAL_W_01'
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_01\SOCAL_W_01_WE\dep\SOCAL_W_01_WE_harp4chPar');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_01\SOCAL_W_01_WS\dep\SOCAL_W_01_WS_harp4chPar');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    elseif dfList{m} == 'SOCAL_W_02'
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_02\SOCAL_W_02_WE\dep\SOCAL_W_02_WE_dep_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_02\SOCAL_W_02_WS\dep\SOCAL_W_02_WS_harp4chParams.mat');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    elseif dfList{m} == 'SOCAL_W_03'
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WS\dep\SOCAL_W_03_WS_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WE\dep\SOCAL_W_03_WE_harp4chParams');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    elseif dfList{m} == 'SOCAL_W_04'
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_04\SOCAL_W_04_WS\dep\SOCAL_W_04_WS_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_04\SOCAL_W_04_WE\dep\SOCAL_W_04_WE_harp4chParams');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    elseif dfList{m} == 'SOCAL_W_05'
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_05\SOCAL_W_05_WE\REDO\SOCAL_W_05_WE_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_05\SOCAL_W_05_WS\REDO\SOCAL_W_05_WS_harp4chParams');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    end

    for i = 1:length(df)

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
            z = zeros(max(lngth),length(whale));

            for wn = 1:length(whaleI) % for each whale

                time(1:length(whaleI{wn}.TInterp),wn) = whaleI{wn}.TInterp; % grab time
                z(1:length(whaleI{wn}.wlocSmooth(:,3)),wn) = whaleI{wn}.wlocSmooth(:,3); % grab z position

            end % close wn for loop

            % split the spatial grid into 10mx10m squares
            % add one to the grid when the whale passes through that grid
            % square
            % how far apart are those grid squares?

            % find the interpolated values for that grid, add them
            for wn = 1:length(whaleI) % for each interpolated whale

                grdt = zeros(length(zline),1); % temp gridded zeros, initialized

                for j = 1:length(whaleI{wn}.wlocSmooth(:,1)) % for each point

                    z = find(whaleI{wn}.wlocSmooth(j,3)+h0(3) > zline(1:end-1) & whaleI{wn}.wlocSmooth(j,3)+h0(3) < zline(2:end)); % find which bin y value falls in
                    grdt(z) = 1; % make the bin value 1

                end
                grdf = grdf+grdt;
            end
        end

        clear whale; clear whaleI;

    end % for each encounter

end % for each deployment

% plot this!
figure
scatter(grdf,zline,'filled','markerfacecolor',[0 0.4470 0.7410])
hold on
plot(grdf,zline,'linestyle','--','color',[0 0.4470 0.7410])
ylabel(['Depth (m)'])
xlabel(['Counts'])
title(['SOCAL W'])
scatter(0,h0(3),30,'red','^','filled')

