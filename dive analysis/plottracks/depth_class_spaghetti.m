%% depth_class_spaghetti

% color depth vs time, but assign colors based on segment of the track

%% site N

% load bathymetry
load('F:\Tracking\bathymetry\socal2');
spd = 60*60*24;

% load receiver positions

% N 68
load('F:\Tracking\Instrument_Orientation\SOCAL_N_68\SOCAL_N_68_NS\dep\SOCAL_N_68_NS_harp4chParams');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Tracking\Instrument_Orientation\SOCAL_N_68\SOCAL_N_68_NW\dep\SOCAL_N_68_NW_harp4chParams');
hydLoc{2} = recLoc;
h0 = mean([hydLoc{1}; hydLoc{2}]);
hydLoc{3} = [32.36975  -118.56458 -1298.3579];

% load whale positions
df = dir('F:\Tracking\Erics_detector\SOCAL_N_68\cleaned_tracks\track*');
% params
paramFile = 'C:\Users\Lauren\Documents\GitHub\Wheres-Whaledo\DOA_small_aperture\params\brushing_pastel';
global brushing
loadParams(paramFile)

% plot depth over time
spd = 60*60*24;

cmap = flipud(cmocean('dense'));
cmap = cmap(20:250,:);

figure
colormap(cmap)
hold on
for i = 1:length(df) % for each encounter
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\*z_stats.mat']);
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\*turns2.mat']);
    if ~isempty(myFile)
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

        for wn = 1:numel(whale)
            if size(whale{wn},2)>14

                if ~isnan(turns(wn))

                    etime = []; % preallocate
                    for t = 1:length(whale{wn}.TDet) % for each timestamp
                        etime = [etime;(whale{wn}.TDet(t)-whale{wn}.TDet(1))*spd];
                        etime = etime;
                    end

                    whale1.etime = etime(1:turns(wn));
                    whale1.wlocSmooth = whale{wn}.wlocSmooth(1:turns(wn),:);
                    whale2.etime = etime(turns(wn)+1:end);
                    whale2.wlocSmooth = whale{wn}.wlocSmooth(turns(wn)+1:end,:);

                    plot(whale1.etime,whale1.wlocSmooth(:,3)+h0(3),'color',[0.4660 0.6740 0.1880])
                    plot(whale2.etime,whale2.wlocSmooth(:,3)+h0(3),'color',[0 0.4470 0.7410])

                else % if size(whale{wn},2)>14
                    if any(whale{wn}.wloc(:,3)+h0(3)<-1400)
                        whale{wn}.wloc(find(whale{wn}.wloc(:,3)+h0(3)<-1400),3) = nan;
                    else
                        etime = []; % preallocate
                        for t = 1:length(whale{wn}.TDet) % for each timestamp
                            etime = [etime;(whale{wn}.TDet(t)-whale{wn}.TDet(1))*spd];
                            etime = etime;
                        end
                        plot(etime,whale{wn}.wlocSmooth(:,3)+h0(3),'color',[0 0.4470 0.7410])
                        % patch([etime;nan],[whale{wn}.wlocSmooth(:,3)+h0(3);nan],[nTime;nan],'facecolor','none','edgecolor','interp','linewidth',1.5)
                    end
                end

            end
        end

    else % entire encounter is in one state

        for wn = 1:numel(whale) % for each whale
            if size(whale{wn},2)>14
                if any(whale{wn}.wloc(:,3)+h0(3)<-1400)
                    whale{wn}.wloc(find(whale{wn}.wloc(:,3)+h0(3)<-1400),3) = nan;
                else
                    etime = []; % preallocate
                    for t = 1:length(whale{wn}.TDet) % for each timestamp
                        etime = [etime;(whale{wn}.TDet(t)-whale{wn}.TDet(1))*spd];
                        etime = etime;
                    end

                    if z_stats(6,wn) == 1
                        plot(etime,whale{wn}.wlocSmooth(:,3)+h0(3),'color',[0.4660 0.6740 0.1880])
                    else
                        plot(etime,whale{wn}.wlocSmooth(:,3)+h0(3),'color',[0 0.4470 0.7410])
                    end

                    % patch([etime;nan],[whale{wn}.wlocSmooth(:,3)+h0(3);nan],[nTime;nan],'facecolor','none','edgecolor','interp','linewidth',1.5)
                end
            end
        end
    end
    % caxis([0 1])
    ylim([-1500 0])
    xlim([0 3000])
    % colorbar
end

%% site E

spd = 60*60*24;

% load receiver positions

% E 63
hydLoc{2} = [32.65871  -119.47711 -1325.5285]; % EE
hydLoc{1} = [32.65646  -119.48815 -1330.1631]; % EW
h0 = mean([hydLoc{1}; hydLoc{2}]);
hydLoc{3} = [32.65345  -119.48455 -1328.9836]; % ES

% load whale positions
df = dir('F:\Tracking\Erics_detector\SOCAL_E_63\cleaned_tracks\track*');
% params
paramFile = 'C:\Users\Lauren\Documents\GitHub\Wheres-Whaledo\DOA_small_aperture\params\brushing_pastel';
global brushing
loadParams(paramFile)

% plot depth over time
spd = 60*60*24;

cmap = flipud(cmocean('dense'));
cmap = cmap(20:250,:);

figure
colormap(cmap)
hold on
for i = 1:length(df) % for each encounter
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\*z_stats.mat']);
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\*turns.mat']);
    if ~isempty(myFile)
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

        for wn = 1:numel(whale)
            if size(whale{wn},2)>14

                if ~isnan(turns(wn))

                    etime = []; % preallocate
                    for t = 1:length(whale{wn}.TDet) % for each timestamp
                        etime = [etime;(whale{wn}.TDet(t)-whale{wn}.TDet(1))*spd];
                        etime = etime;
                    end

                    whale1.etime = etime(1:turns(wn));
                    whale1.wlocSmooth = whale{wn}.wlocSmooth(1:turns(wn),:);
                    whale2.etime = etime(turns(wn)+1:end);
                    whale2.wlocSmooth = whale{wn}.wlocSmooth(turns(wn)+1:end,:);

                    plot(whale1.etime,whale1.wlocSmooth(:,3)+h0(3),'color',[0.4660 0.6740 0.1880])
                    plot(whale2.etime,whale2.wlocSmooth(:,3)+h0(3),'color',[0 0.4470 0.7410])

                else % if size(whale{wn},2)>14
                    if any(whale{wn}.wloc(:,3)+h0(3)<-1400)
                        whale{wn}.wloc(find(whale{wn}.wloc(:,3)+h0(3)<-1400),3) = nan;
                    else
                        etime = []; % preallocate
                        for t = 1:length(whale{wn}.TDet) % for each timestamp
                            etime = [etime;(whale{wn}.TDet(t)-whale{wn}.TDet(1))*spd];
                            etime = etime;
                        end
                        plot(etime,whale{wn}.wlocSmooth(:,3)+h0(3),'color',[0 0.4470 0.7410])
                        % patch([etime;nan],[whale{wn}.wlocSmooth(:,3)+h0(3);nan],[nTime;nan],'facecolor','none','edgecolor','interp','linewidth',1.5)
                    end
                end

            end
        end

    else % entire encounter is in one state

        for wn = 1:numel(whale) % for each whale
            if size(whale{wn},2)>14
                if any(whale{wn}.wloc(:,3)+h0(3)<-1400)
                    whale{wn}.wloc(find(whale{wn}.wloc(:,3)+h0(3)<-1400),3) = nan;
                else
                    etime = []; % preallocate
                    for t = 1:length(whale{wn}.TDet) % for each timestamp
                        etime = [etime;(whale{wn}.TDet(t)-whale{wn}.TDet(1))*spd];
                        etime = etime;
                    end

                    if z_stats(6,wn) == 1
                        plot(etime,whale{wn}.wlocSmooth(:,3)+h0(3),'color',[0.4660 0.6740 0.1880])
                    else
                        plot(etime,whale{wn}.wlocSmooth(:,3)+h0(3),'color',[0 0.4470 0.7410])
                    end

                    % patch([etime;nan],[whale{wn}.wlocSmooth(:,3)+h0(3);nan],[nTime;nan],'facecolor','none','edgecolor','interp','linewidth',1.5)
                end
            end
        end
    end
    % caxis([0 1])
    ylim([-1500 0])
    xlim([0 3000])
    % colorbar
end

%% site H

% need to plot per deployment, add the appropriate offset for each
% deployment

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

deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75'};

% plot depth over time
spd = 60*60*24;

figure
colormap(cmap)
hold on
for j = 1:length(deps)
    % load whale positions
    df = dir(['F:\Tracking\Erics_detector\',deps{j},'\cleaned_tracks\track*']);
    if deps{j} == 'SOCAL_H_73'
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_73\SOCAL_H_73_HS\dep\SOCAL_H_73_HS_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_73\SOCAL_H_73_HW\dep\SOCAL_H_73_HW_harp4chParams');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    elseif deps{j} == 'SOCAL_H_74'
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_74\SOCAL_H_74_HS\rec\SOCAL_H_74_HS_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_74\SOCAL_H_74_HW\rec\SOCAL_H_74_HW_harp4chParams');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    elseif deps{j} == 'SOCAL_H_75'
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_75\SOCAL_H_75_HS\rec\SOCAL_H_75_HS_harp4chPar');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_H_75\SOCAL_H_75_HW\rec\SOCAL_H_75_HW_harp4chParams');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    end
    for i = 1:length(df) % for each encounter
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\*z_stats.mat']);
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\*turns2.mat']);
    if ~isempty(myFile)
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

        for wn = 1:numel(whale)
            if size(whale{wn},2)>14

                if ~isnan(turns(wn))

                    etime = []; % preallocate
                    for t = 1:length(whale{wn}.TDet) % for each timestamp
                        etime = [etime;(whale{wn}.TDet(t)-whale{wn}.TDet(1))*spd];
                        etime = etime;
                    end

                    whale1.etime = etime(1:turns(wn));
                    whale1.wlocSmooth = whale{wn}.wlocSmooth(1:turns(wn),:);
                    whale2.etime = etime(turns(wn)+1:end);
                    whale2.wlocSmooth = whale{wn}.wlocSmooth(turns(wn)+1:end,:);

                    plot(whale1.etime,whale1.wlocSmooth(:,3)+h0(3),'color',[0.4660 0.6740 0.1880])
                    plot(whale2.etime,whale2.wlocSmooth(:,3)+h0(3),'color',[0 0.4470 0.7410])

                else % if size(whale{wn},2)>14
                    if any(whale{wn}.wloc(:,3)+h0(3)<-1400)
                        whale{wn}.wloc(find(whale{wn}.wloc(:,3)+h0(3)<-1400),3) = nan;
                    else
                        etime = []; % preallocate
                        for t = 1:length(whale{wn}.TDet) % for each timestamp
                            etime = [etime;(whale{wn}.TDet(t)-whale{wn}.TDet(1))*spd];
                            etime = etime;
                        end
                        plot(etime,whale{wn}.wlocSmooth(:,3)+h0(3),'color',[0 0.4470 0.7410])
                        % patch([etime;nan],[whale{wn}.wlocSmooth(:,3)+h0(3);nan],[nTime;nan],'facecolor','none','edgecolor','interp','linewidth',1.5)
                    end
                end

            end
        end

    else % entire encounter is in one state

        for wn = 1:numel(whale) % for each whale
            if size(whale{wn},2)>14
                if any(whale{wn}.wloc(:,3)+h0(3)<-1400)
                    whale{wn}.wloc(find(whale{wn}.wloc(:,3)+h0(3)<-1400),3) = nan;
                else
                    etime = []; % preallocate
                    for t = 1:length(whale{wn}.TDet) % for each timestamp
                        etime = [etime;(whale{wn}.TDet(t)-whale{wn}.TDet(1))*spd];
                        etime = etime;
                    end

                    if z_stats(6,wn) == 1
                        plot(etime,whale{wn}.wlocSmooth(:,3)+h0(3),'color',[0.4660 0.6740 0.1880])
                    else
                        plot(etime,whale{wn}.wlocSmooth(:,3)+h0(3),'color',[0 0.4470 0.7410])
                    end

                    % patch([etime;nan],[whale{wn}.wlocSmooth(:,3)+h0(3);nan],[nTime;nan],'facecolor','none','edgecolor','interp','linewidth',1.5)
                end
            end
        end
    end
    end
end
ylim([-1500 0])

%% site W

spd = 60*60*24;

% load receiver positions
% W 01
load('F:\Tracking\Instrument_Orientation\SOCAL_W_01\SOCAL_W_01_WE\dep\SOCAL_W_01_WE_harp4chPar');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Tracking\Instrument_Orientation\SOCAL_W_01\SOCAL_W_01_WS\dep\SOCAL_W_01_WS_harp4chPar');
hydLoc{2} = recLoc;
h0 = mean([hydLoc{1}; hydLoc{2}]);
hydLoc{3} = [33.53973  -120.25815 -1377.8741];

deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_05','SOCAL_W_04','SOCAL_W_03'};

figure
colormap(cmap)
hold on
for j = 1:length(deps)
    % load whale positions
    df = dir(['F:\Tracking\Erics_detector\',deps{j},'\cleaned_tracks\track*']);
    if deps{j} == 'SOCAL_W_02'
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_02\SOCAL_W_02_WE\dep\SOCAL_W_02_WE_dep_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_02\SOCAL_W_02_WS\dep\SOCAL_W_02_WS_harp4chParams.mat');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    elseif deps{j} == 'SOCAL_W_03'
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WS\dep\SOCAL_W_03_WS_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WE\dep\SOCAL_W_03_WE_harp4chParams');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    elseif deps{j} == 'SOCAL_W_04'
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_04\SOCAL_W_04_WS\dep\SOCAL_W_04_WS_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_04\SOCAL_W_04_WE\dep\SOCAL_W_04_WE_harp4chParams');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    elseif deps{j} == 'SOCAL_W_05'
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_05\SOCAL_W_05_WE\REDO\SOCAL_W_05_WE_harp4chParams');
        hydLoc{1} = recLoc;
        clear recLoc
        load('F:\Tracking\Instrument_Orientation\SOCAL_W_05\SOCAL_W_05_WS\REDO\SOCAL_W_05_WS_harp4chParams');
        hydLoc{2} = recLoc;
        h0 = mean([hydLoc{1}; hydLoc{2}]);
    end
        for i = 1:length(df) % for each encounter
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\*z_stats.mat']);
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
    myFile = dir([df(i).folder,'\',df(i).name,'\*turns2.mat']);
    if ~isempty(myFile)
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

        for wn = 1:numel(whale)
            if size(whale{wn},2)>14

                if ~isnan(turns(wn))

                    etime = []; % preallocate
                    for t = 1:length(whale{wn}.TDet) % for each timestamp
                        etime = [etime;(whale{wn}.TDet(t)-whale{wn}.TDet(1))*spd];
                        etime = etime;
                    end

                    whale1.etime = etime(1:turns(wn));
                    whale1.wlocSmooth = whale{wn}.wlocSmooth(1:turns(wn),:);
                    whale2.etime = etime(turns(wn)+1:end);
                    whale2.wlocSmooth = whale{wn}.wlocSmooth(turns(wn)+1:end,:);

                    plot(whale1.etime,whale1.wlocSmooth(:,3)+h0(3),'color',[0.4660 0.6740 0.1880])
                    plot(whale2.etime,whale2.wlocSmooth(:,3)+h0(3),'color',[0 0.4470 0.7410])

                else % if size(whale{wn},2)>14
                    if any(whale{wn}.wloc(:,3)+h0(3)<-1400)
                        whale{wn}.wloc(find(whale{wn}.wloc(:,3)+h0(3)<-1400),3) = nan;
                    else
                        etime = []; % preallocate
                        for t = 1:length(whale{wn}.TDet) % for each timestamp
                            etime = [etime;(whale{wn}.TDet(t)-whale{wn}.TDet(1))*spd];
                            etime = etime;
                        end
                        plot(etime,whale{wn}.wlocSmooth(:,3)+h0(3),'color',[0 0.4470 0.7410])
                        % patch([etime;nan],[whale{wn}.wlocSmooth(:,3)+h0(3);nan],[nTime;nan],'facecolor','none','edgecolor','interp','linewidth',1.5)
                    end
                end

            end
        end

    else % entire encounter is in one state

        for wn = 1:numel(whale) % for each whale
            if size(whale{wn},2)>14
                if any(whale{wn}.wloc(:,3)+h0(3)<-1400)
                    whale{wn}.wloc(find(whale{wn}.wloc(:,3)+h0(3)<-1400),3) = nan;
                else
                    etime = []; % preallocate
                    for t = 1:length(whale{wn}.TDet) % for each timestamp
                        etime = [etime;(whale{wn}.TDet(t)-whale{wn}.TDet(1))*spd];
                        etime = etime;
                    end

                    if z_stats(6,wn) == 1
                        plot(etime,whale{wn}.wlocSmooth(:,3)+h0(3),'color',[0.4660 0.6740 0.1880])
                    else
                        plot(etime,whale{wn}.wlocSmooth(:,3)+h0(3),'color',[0 0.4470 0.7410])
                    end

                    % patch([etime;nan],[whale{wn}.wlocSmooth(:,3)+h0(3);nan],[nTime;nan],'facecolor','none','edgecolor','interp','linewidth',1.5)
                end
            end
        end
    end
    end
end
ylim([-1500 0])