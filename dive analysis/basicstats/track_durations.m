%% track_durations.m
% this script will go through the final tracks, grab their durations, sum
% to get total recorded duration, and make a histogram of distributions

% go through final tracks, grab the durations
deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75','SOCAL_E_63','SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05','SOCAL_N_68'};

% preallocate to hold all the duration values
allDur = [];

for j = 1:length(deps) % for each deployment
    df = dir(['F:\Tracking\Erics_detector\',char(deps(j)),'\cleaned_tracks']);

    for i = 3:length(df) % for each track in this deployment
        myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
        trackNum = extractAfter(myFile.folder,'cleaned_tracks\'); % grab the track num for naming later
        load(fullfile([myFile.folder,'\',myFile.name])); % load the file

        for wn = 1:length(whale) % for each whale in this track
            if ~isempty(whale{wn}) % that isn't empty
                whaleDur(1,wn) = etime(datevec(datetime(whale{wn}.TDet(end),'convertfrom','datenum')),datevec(datetime(whale{wn}.TDet(1),'convertfrom','datenum')));
            end
        end
        
        % allDur = [allDur,whaleDur];
        % grab the largest of these duration values, store it
        maxDur = max(whaleDur);
        allDur(i-2,j) = maxDur;

    end
end

% calculate the total number of recorded seconds
s = sum(allDur,'all'); % this gives in seconds
m = s/60;
h = m/60;

% calculate for individual tracks
allMin = allDur./60;
allMin(allMin==0) = NaN;

edges = [1:5:50] % bin edges for histogram

figure
histogram(allMin,edges,'facecolor',[0.6 0.6 0.6])
xlabel('Encounter Duration (Minutes)')
ylabel('Frequency')


mn = min(min(allMin));
mx = max(max(allMin));
men = nanmean(allMin,"all");
med = nanmedian(allMin,"all");