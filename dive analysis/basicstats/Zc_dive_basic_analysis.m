%% Zc_tracks_basic_analysis

% count the number of tracks per deployment, make histograms of track and
% encounter durations

% deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};
% deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75'};
% deps = {'SOCAL_E_63'};
% deps = {'SOCAL_N_68'};
deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05', ...
    'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75', ...
    'SOCAL_E_63','SOCAL_N_68'};

numWhales = []; % preallocate for saving number of whales total
trackDur = []; % preallocate for saving track durations
encDur = []; % preallocate for saving encounter durations

for j = 1:length(deps) % for each deployment

        df = dir(['F:\Tracking\Erics_detector\',char(deps(j)),'\cleaned_tracks\track*']);

        for i = 1:length(df) % for each encounter
            
            myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
            trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
            load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

            numWhales = [numWhales;numel(whale)];

            for wn = 1:numel(whale)
                if ~isempty(whale{wn}) % if we have tracked info
                    t1(wn) = datetime(whale{wn}.TDet(1),'convertfrom','datenum');
                    t2(wn) = datetime(whale{wn}.TDet(end),'convertfrom','datenum');
                end
            end

            tDur = t2-t1; % durations of tracks
            trackDur = [trackDur;tDur']; % save
            eDur = max(t2)-min(t1); % durations of encounters
            encDur = [encDur;eDur']; % save

            clear t1; clear t2;
        end

end

totalWhales = sum(numWhales);

figure
subplot(1,2,1)
histogram(trackDur)
title('Track Durations')
xlim([duration(0,0,0) duration(2,0,0)])
subplot(1,2,2)
histogram(encDur)
title('Encounter Durations')

nanmedian(trackDur)
nanmean(trackDur)

nanmedian(encDur)
nanmean(encDur)

%% how many tracks do we have from brushDOA?

deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05', ...
    'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75', ...
    'SOCAL_E_63','SOCAL_N_68'};

numWhales = []; % preallocate for saving number of whales total

for j = 1:length(deps) % for each deployment

        df = dir(['F:\Tracking\Erics_detector\',char(deps(j)),'\cleaned_tracks\track*']);

        for i = 1:length(df) % for each encounter
            
            myFile = dir([df(i).folder,'\',df(i).name,'\*brushDOA*.mat']); % load the folder name
            if ~isempty(myFile)
                trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
                load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
            else
                myFile = dir([df(i).folder,'\',df(i).name,'\SOCAL*.mat']); % load the folder name
                trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
                load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
            end

            first = length(unique(DET{1,1}.Label));
            second = length(unique(DET{1,2}.Label));

            numWhales = [numWhales;max([first,second])];

        end

end

for j = 1:length(deps) % for each deployment

        df = dir(['F:\Tracking\Erics_detector\',char(deps(j)),'\not_for_3D\track*']);

        for i = 1:length(df) % for each encounter
            
            myFile = dir([df(i).folder,'\',df(i).name,'\*brushDOA*.mat']); % load the folder name
            if ~isempty(myFile)
                trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
                load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
            else
                myFile = dir([df(i).folder,'\',df(i).name,'\SOCAL*.mat']); % load the folder name
                trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
                load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
            end

            first = length(unique(DET{1,1}.Label));
            second = length(unique(DET{1,2}.Label));

            numWhales = [numWhales;max([first,second])];

        end

end

totalWhales = sum(numWhales);
3221-2738;

%% compare to the original counts
a = load('F:\Tracking\Erics_detector\SOCAL_H_72\group_size\cleanedTracksTable.mat');
b = load('F:\Tracking\Erics_detector\SOCAL_H_73\group_size\cleanedTracksTable.mat');
c = load('F:\Tracking\Erics_detector\SOCAL_H_74\group_size\cleanedTracksTable.mat');
d = load('F:\Tracking\Erics_detector\SOCAL_H_75\group_size\cleanedTracksTable.mat');
e = load('F:\Tracking\Erics_detector\SOCAL_E_63\group_size\cleanedTracksTable.mat');
f = load('F:\Tracking\Erics_detector\SOCAL_N_68\group_size\cleanedTracksTable.mat');
g = load('F:\Tracking\Erics_detector\SOCAL_W_01\group_size\cleanedTracksTable.mat');
h = load('F:\Tracking\Erics_detector\SOCAL_W_02\group_size\cleanedTracksTable.mat');
i = load('F:\Tracking\Erics_detector\SOCAL_W_03\group_size\cleanedTracksTable.mat');
j = load('F:\Tracking\Erics_detector\SOCAL_W_04\group_size\cleanedTracksTable.mat');
k = load('F:\Tracking\Erics_detector\SOCAL_W_05\group_size\cleanedTracksTable.mat');

a = sum(a.cleanedTracksTable.numWhales);
b = sum(b.cleanedTracksTable.numWhales);
c = sum(c.cleanedTracksTable.numWhales);
d = sum(d.cleanedTracksTable.numWhales);
e = sum(e.cleanedTracksTable.numWhales);
f = sum(f.cleanedTracksTable.numWhales);
g = sum(g.cleanedTracksTable.numWhales);
h = sum(h.cleanedTracksTable.numWhales);
i = sum(i.cleanedTracksTable.numWhales);
j = sum(j.cleanedTracksTable.numWhales);
k = sum(k.cleanedTracksTable.numWhales);

full = a+b+c+d+e+f+g+h+i+j+k;

